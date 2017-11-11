#!/data/data/com.termux/files/usr/bin/bash
folder=ubuntu-fs
if [ -d "$folder" ]; then
    first=1
    echo "skipping downloading"
fi
if [ "$first" != 1 ];then
    if [ ! -f "ubuntu.tar.gz" ]; then
        echo "downloading ubuntu-image"
        if [ "$(dpkg --print-architecture)" = "aarch64" ];then
            wget https://partner-images.canonical.com/core/artful/current/ubuntu-artful-core-cloudimg-arm64-root.tar.gz -O ubuntu.tar.gz
        elif [ "$(dpkg --print-architecture)" = "arm" ];then
            wget https://partner-images.canonical.com/core/artful/current/ubuntu-artful-core-cloudimg-armhf-root.tar.gz -O ubuntu.tar.gz
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
    echo "nameserver 8.8.8.8" > etc/resolv.conf
    cd $cur
fi

echo "linking home directory"
ln -s /data/data/com.termux/files/home /home
bin=start.sh
echo "writing launch script"
cat > $bin <<- EOM
#!/bin/bash
cd \$(dirname \$0)
#unset LD_PRELOAD in case termux-exec is installed
unset LD_PRELOAD
command="proot"
command+=" --link2symlink"
command+=" -0"
command+=" -r $folder"
command+=" -b /system"
command+=" -b /dev/"
command+=" -b /sys/"
command+=" -b /proc/"
command+=" -b /data/data/com.termux/files/home"
command+=" -w /home"
command+=" /usr/bin/env -i"
command+=" HOME=/home"
command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
command+=" TERM=\$TERM"
command+=" LANG=\$LANG"
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
echo "You can now launch Ubuntu with the ./start.sh script"
