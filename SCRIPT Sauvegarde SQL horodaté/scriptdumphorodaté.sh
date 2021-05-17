echo debut de la procedure >>/tmp/save/sauvegardelog.log
date >> /tmp/save/sauvegardelog.log
mysqldump --user=root --password=toto --all-databases > /tmp/save/sauvegarde.sql
echo fin exportation sql >>/tmp/save/sauvegardelog.log
date >> /tmp/save/sauvegardelog.log
tar -czvf sauvegarde1sql.tar.gz /tmp/save/sauvegarde.sql
echo fin compression  >>/tmp/save/sauvegardelog.log
date >> /tmp/save/sauvegardelog.log
mv sauvegarde1sql.tar.gz /tmp/save/`date +%Y-%m-%d-%H-%M`.-sauvegarde.tar.gz
echo fin sauvegarde >>/tmp/save/sauvegardelog.log
date >> /tmp/save/sauvegardelog.log

lftp ftp://toto:'toto'@172.17.1.176 -e "mirror -e -R /tmp/save /  ; quit"
