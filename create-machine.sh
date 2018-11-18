#!/bin/bash
# Configuration
cd "$(dirname "$0")" || exit
source .env
# Check fingerprint
PUBKEY_FINGERPRINT=$(ssh-keygen -E md5 -lf ~/.ssh/id_rsa.pub | awk '{print $2}' | cut -d":" -f 2-)
if [ -z "$(eval "echo \$PUBKEY_FINGERPRINT")" ]; then
  echo "Missing public key."
  exit 1
fi
# Create droplet
DROPLET=$(curl -X POST \
	-H "Content-Type: application/json" \
	-H "Authorization: Bearer $DIGITALOCEAN_API_TOKEN" \
  -d "{\"name\":\"$DROPLET_NAME\",\"region\":\"ams3\",\"size\":\"$SIZE\",\"image\":\"$BASE_IMAGE\",\"ssh_keys\":[\"$PUBKEY_FINGERPRINT\"],\"backups\":false,\"ipv6\":false,\"user_data\":null,\"private_networking\":null,\"volumes\": null,\"tags\":[\"$TAG\"]}" \
	"https://api.digitalocean.com/v2/droplets")
DROPLET_ID=$(echo "$DROPLET" | jq -r .droplet.id)
if [ "$DROPLET_ID" == null ]; then
  echo "Failed to create droplet."
	echo "$DROPLET" | jq
  exit 1
fi
DROPLET_STATUS=$(echo "$DROPLET" | jq -r .droplet.status)
echo "Waiting for droplet to become active."
sleep $CREATE_TIME
while [ "$DROPLET_STATUS" != "active" ]
do
  DROPLET_STATUS=$(curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $DIGITALOCEAN_API_TOKEN" "https://api.digitalocean.com/v2/droplets/$DROPLET_ID" | jq -r .droplet.status) &&
	echo "Droplet status is: $DROPLET_STATUS" &&
  sleep 5
done
DROPLET_INFO=$(curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $DIGITALOCEAN_API_TOKEN" "https://api.digitalocean.com/v2/droplets/$DROPLET_ID")
IP_ADDRESS=$(echo "$DROPLET_INFO" | jq -r .droplet.networks.v4[].ip_address)
echo "Waiting for droplet to boot."
sleep $BOOT_TIME
echo "Connecting to root@$IP_ADDRESS"
connect_ssh=true
while "$connect_ssh"; do
  echo "Trying to ssh..." &&
  # Run the initial root provisioning script on the machine
	ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "root@$IP_ADDRESS" 'bash -s' < root-init.sh "$USERNAME" "$PASSWORD" &&
  connect_ssh=false
  if "$connect_ssh"; then
    sleep 5
  fi
done
# Run the initial regular user provisioning script
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "$USERNAME@$IP_ADDRESS" 'bash -s' < provision-user.sh
echo "Connect to your new machine ssh $USERNAME@$IP_ADDRESS"
