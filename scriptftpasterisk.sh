mkdir saveasterisk
cp -r /etc/asterisk /home/saveasterisk/asterisk
tar -czvf saveasterisk.tar.gz /home/saveasterisk/asterisk
mkdir /home/user/save
mv saveasterisk.tar.gz /home/user/save/saveasterisk.tar.gz
