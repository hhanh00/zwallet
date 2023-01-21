git clone https://github.com/hhanh00/zwallet.git $HOME/zwallet
cd $HOME/zwallet
git checkout $1
git submodule update --init --recursive
source misc/vagrant/build-ubuntu.sh $PWD
