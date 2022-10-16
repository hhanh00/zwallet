cat << EOF | fdisk /dev/sda
n
3


w
EOF
btrfs device add -f /dev/sda3 /
pacman -Syu
pacman -S --noconfirm git
git clone https://github.com/hhanh00/zwallet.git
(cd zwallet; git checkout $1; git submodule update --init; ./install-dev.sh)
