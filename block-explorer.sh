#!/bin/bash

echo "downloading part2"
echo

wget https://raw.githubusercontent.com/GRinvest/zelcash-block-explorer/master/block-explorer-part2.sh

echo "---------------"
# Install zelcash dependencies:

echo "installing zelcash"
echo

sudo apt-get -y --force-yes install \
      build-essential pkg-config libc6-dev m4 g++-multilib \
      autoconf libtool ncurses-dev unzip git python python-zmq \
      zlib1g-dev wget bsdmainutils automake curl

sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get -y --force-yes install g++-4.9 

# download zcash source from fork with block explorer patches
git clone https://github.com/zelcash/zelcash.git
git clone https://gitlab.com/zcashcommunity/params.git

cd zelcash
chmod +x zcutil/build.sh depends/config.guess depends/config.sub autogen.sh share/genbuild.sh src/leveldb/build_detect_platform
./zcutil/build.sh --disable-rust -j$(nproc)

# install safecoin
sudo cp src/zelcashd /usr/local/bin/
sudo cp src/zelcash-cli /usr/local/bin/

cd
mkdir .zelcash
mkdir .zelcash-params
cd .zelcash-params
sudo cp ~/params/sprout-proving.key .
sudo cp ~/params/sprout-verifying.key .

echo "---------------"
echo "installing node and npm"
echo

# install node and dependencies
cd ..
sudo apt-get -y install npm

echo "---------------"
echo "installing nvm"
echo

# install nvm
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

echo "logout of this shell, log back in and run:"
echo "bash block-explorer-part2.sh"