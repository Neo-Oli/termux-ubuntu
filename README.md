# termux-ubuntu

A script to install Ubuntu chroot in Termux

The script will make it's files in the current directory. So if you want your Ubuntu-filesystem at a particular location switch to that folder first and then call the script with it's relative path. Example:
```
mkdir ~/jails/ubuntu1
cd ~/jails/ubuntu1
~/termux-ubuntu/ubuntush
```

After running it you can run "startubuntu.sh" to switch into your ubuntu

