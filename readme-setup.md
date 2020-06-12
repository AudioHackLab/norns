# norns setup

## 1. install packages prerequisites

```
sudo apt-get install libnanomsg-dev supercollider-language supercollider-server supercollider-supernova supercollider-dev liblua5.3-dev libudev-dev libevdev-dev liblo-dev libcairo2-dev libavahi-compat-libdnssd-dev libasound2-dev sc3-plugins ladspalist x11vnc tigervnc-viewer
```

## 2. building norns

```
cd ~
git clone -b virtfb https://github.com/AudioHackLab/norns.git
cd norns
./waf configure
./waf
```

this should build all the c-based components (`matron` and `ws-wrapper`.)

the `crone` audio engine consists of supercollider classes. copy files to the default location for user SC extensions

```
pushd sc
./install.sh
popd
```

## 3. configure virtual-fb

```
git clone https://github.com/AudioHackLab/linux-module-virtfb.git
make clean
make all
sudo make install
sudo depmod -a
sudo modprobe virtual-fb
```

Note: to autostart virtual-fb at next reboot add it to /etc/modules or remember to keep loading it manually with `sudo modprobe virtual-fb`

## 4. launching components

run `start.sh` to execute it.\
Note: The OSC rx port to control matron bind at: 10111 .\
To see the virtual oled screen run `xvncviewer 127.0.0.1:5901`\

This script will start two separate services automatically:

### a. `crone` (audio engine)

run `crone.sh` from the norns directory. this creates a `sclang` process wrapped with `ws-wrapper`

if the crone classes are installed correctly, you should see some lines like this in output from sclang initialization: 

```
-------------------------------------------------
 Crone startup

 OSC rx port: 57120
 OSC tx port: 8888
--------------------------------------------------
```

and immediately after sclang init, you should see the server being booted and some jack/alsa related messages. 

### b. `matron` (lua interpreter)

with the audio engine running, run `matron.sh` from the norns directory. this creates a `matron` process wrapped with `ws-wrapper` and vnc server running on this host at port 5901.

matron waits for crone to finish loading before entering the main event loop.

## 5. setup `maiden` the web UI client (optional)

### download and install dust

```
cd ~  
git clone https://github.com/monome/dust
cd dust
git reset --hard c10c62c24e88d1dc10c5eb3ed77f5b9b451fbe6c
```

### download and install maiden

```
sudo apt-get install golang
export PATH=$PATH:~/go/bin
export GOPATH=$HOME/go
go get -d github.com/monome/maiden
cd ~/go/src/github.com/monome/maiden  
git reset --hard e4d4a9082d718f41335b00e14090a965a55e17b7
go build
cd ~  
ln -s ~/go/src/github.com/monome/maiden
cd maiden
cp -v tool/start.sh .
```

### setup and build maiden UI

```
sudo apt remove cmdtest yarn
curl -sL https://deb.nodesource.com/setup_10.x 1 | sudo -E bash -  
sudo apt-get install nodejs  
sudo npm install -g yarn
sudo npm install react-scripts  
cd web
rm -rf build 
yarn install
yarn build
cd ..
mkdir -pv ./app
cp -rv ./web/build ./app
```

run `start.sh` to execute it and browse it [http://127.0.0.1:5000/maiden](http://127.0.0.1:5000/maiden)


## 6. docs addendum (optional)

if you want to generate the docs (using ldoc) first install:

```
sudo apt-get install luarocks liblua5.1-dev
sudo luarocks install ldoc
```

to generate the docs:

`ldoc .` in the root norns folder

To read the documentation, point the browser window with Maiden loaded to [http://norns.local/doc](http://norns.local/doc) (or use IP address if this doesn't work).
