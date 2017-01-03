#!/data/data/com.termux/files/usr/bin/bash
apt update
apt install -y proot wget tar
mkdir -p ~/ubuntu
echo "downloading ubuntu-image"
if [ "$(dpkg --print-architecture)" == "aarch64" ];then
wget https://partner-images.canonical.com/core/yakkety/current/ubuntu-yakkety-core-cloudimg-arm64-root.tar.gz -O ubuntu.tar.gz
elif [ "$(dpkg --print-architecture)" == "arm" ];then
wget https://partner-images.canonical.com/core/yakkety/current/ubuntu-yakkety-core-cloudimg-armhf-root.tar.gz -O ubuntu.tar.gz
else
    echo "unknown architecture"
fi
mkdir -p ~/ubuntu
cd ~/ubuntu
echo "decompressing ubuntu image"
tar -xf ~/ubuntu.tar.gz||:
echo "fixing nameserver, otherwise it can't connect to the internet"
echo "nameserver 8.8.8.8" > ~/ubuntu/etc/resolv.conf
bin=$PREFIX/bin/startubuntu
echo "writing launch script"
cat > $bin <<- EOM
#!/bin/bash
proot --link2symlink -0 -r ~/ubuntu -b /system -b /dev/ -b /sys/ -b /proc/ -b /data/data/com.termux/files/home /usr/bin/env -i HOME=/root ATH=/bin:/usr/bin:/sbin:/usr/sbin /bin/bash --login
EOM
echo "fixing shebang of $bin"
termux-fix-shebang $bin
echo "making $bin executable"
chmod +x $bin
