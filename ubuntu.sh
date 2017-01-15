#!/data/data/com.termux/files/usr/bin/bash
folder=ubuntu-fs
if [ -d "$folder" ]; then
    first=1
    echo "skipping downloading"
fi
if [ "$first" != 1 ];then
    if [ ! -f "ubuntu.tar.gz" ]; then
        echo "downloading ubuntu-image"
        if [ "$(dpkg --print-architecture)" == "aarch64" ];then
            wget https://partner-images.canonical.com/core/yakkety/current/ubuntu-yakkety-core-cloudimg-arm64-root.tar.gz -O ubuntu.tar.gz
        elif [ "$(dpkg --print-architecture)" == "arm" ];then
            wget https://partner-images.canonical.com/core/yakkety/current/ubuntu-yakkety-core-cloudimg-armhf-root.tar.gz -O ubuntu.tar.gz
        else
            echo "unknown architecture"
            exit 1
        fi
    fi
    cur=`pwd`
    mkdir -p $folder
    cd $folder
    echo "decompressing ubuntu image"
    proot --link2symlink tar -xf $cur/ubuntu.tar.gz||:
    echo "fixing nameserver, otherwise it can't connect to the internet"
    echo "nameserver 8.8.8.8" > $folder/etc/resolv.conf
    cd $cur
fi
bin=startubuntu.sh
echo "writing launch script"
cat > $bin <<- EOM
#!/bin/bash
export PROOT_NO_SECCOMP=1
command="proot"
command+=" --link2symlink"
command+=" -0"
command+=" -r $folder"
command+=" -b /system"
command+=" -b /dev/"
command+=" -b /sys/"
command+=" -b /proc/"
command+=" -b /data/data/com.termux/files/home"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=/bin:/usr/bin:/sbin:/usr/sbin"
command+=" TERM=\$TERM"
command+=" /bin/bash --login"

com="\$@"
if [ -z "\$1" ];then
    exec \$command
else
    \$command -c "\$com"
fi
EOM
echo "fixing shebang of $bin"
termux-fix-shebang $bin
echo "making $bin executable"
chmod +x $bin
