# xud-box-digitalocean
xud-box plugin to provision debian 9.5 digitalocean image to run xud-box.

## Install
`git clone https://github.com/ExchangeUnion/xud-box-digitalocean.git ~/xud-box-digitalocean`

### Edit Settings
`cd ~/xud-box-digitalocean`

Edit `.env` file and fill in your `DIGITALOCEAN_API_TOKEN`

#### Create
[digitalocean.com/docs/api/create-personal-access-token/](https://www.digitalocean.com/docs/api/create-personal-access-token/)

`touch .env`

#### Open
`vim .env`

#### Edit
```
export DIGITALOCEAN_API_TOKEN=<CHANGE_WITH_YOUR_DO_KEY> # change this with your own key
export USERNAME="admin" # optionally, you can change the default user
export PASSWORD="lollercopter#123" # change this password
export TAG="xud-box-simnet" # tag is used to clear up your running instances
export BASE_IMAGE=debian-9-x64
export SIZE=4gb # amount of RAM
export DROPLET_NAME="xud-box" # server name
export CREATE_TIME=40 # seconds it takes to create the server
export BOOT_TIME=20 # seconds it takes to boot the server
```

### Ensure SSH key
Ensure that your public key has been setup on DigitalOcean control panel.

### Start
`./create-machine.sh`

### Check Status
`./status.sh`

### Cleanup
`./cleanup.sh`
