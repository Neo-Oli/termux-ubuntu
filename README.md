# termux-ubuntu

A script to install Ubuntu chroot in Termux

You need to install wget and proot in Termux before using this script.

```
pkg install wget proot
```

The script will make its files in the current directory. So if you want your Ubuntu-filesystem at a particular location switch to that folder first and then call the script with it's relative path. Example:
```
mkdir -p ~/jails/ubuntu1
cd ~/jails/ubuntu1
~/termux-ubuntu/ubuntu.sh
```

After running it you can run "start.sh" to switch into your ubuntu

