int=$(route |grep default |awk '{print $8}')
sed "s/$int/eth0/g" /etc/sysconfig/network-scripts/ifcfg-$int > /etc/sysconfig/network-scripts/ifcfg-eth0
rm -rf /etc/sysconfig/network-scripts/ifcfg-$int
sed -i '/GRUB_CMDLINE_LINUX/s/\"$/ net.ifnames=0 biosdevname=0\"/g' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg