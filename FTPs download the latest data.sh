#!/usr/local/bin/bash

# I use this script to download the datasets package stored in JNJ FTP server,  including RAVE data & custom domain 
# suppose you had setup a regular extra data through SASonDemand



source /home/users/YOUR_username/.bashrc   #insert your username here, eg. zhangl6 , we must manually utilize the user's bash configure file at first
ftpuser="yourftpusername"
password="yourpassword"                    #if you have special character , you can quote your password
protocol="JNJ protocol ID"
type=Prod
project="PXL_project"                      # eg.   jjprd224002
dir_raw=/projects/${project}/stats/transfer/data/raw
dir_cust=/projects/${project}/stats/transfer/data/rawcust


type=${type^^}
protocol=${protocol^^}
/usr/local/bin/curl  --ftp-pasv  --ftp-ssl -u ${ftpuser}:${password} -k ftp://jnj2.ftp.mdsol.com/${protocol}/${type}/ > ftpdownload.txt
awk -F_  -v protocol=$protocol  '{ if ($0 ~ ("_" protocol) ) print "ravedata", $(NF-1), substr($(NF),1,6) , $0 ; if ($0 ~ (" " protocol))  print "cust", $(NF-1), substr($(NF),1,6) , $0 }' ftpdownload.txt > ftpdownload1.txt

filelst=`sort -t" " -k2rn -k3rn < ftpdownload1.txt | awk '!x[$1]++' | sort -k1 | awk -F' ' '{if ($1=="cust") print "latestcust="$(NF); if ($1=="ravedata") print "latestraw="$(NF)}'`
eval $filelst
echo -e "\033[32m lastest ravedata is: " $latestraw  "\033[0m"
echo -e "\033[32m lastest custom domain is: " $latestcust  "\033[0m"

rm -f ${dir_raw}/*.*
rm -f ${dir_cust}/*.*

/opt/pdag/bin/curl  --ftp-pasv  --ftp-ssl -u ${ftpuser}:${password} -k -O  ftp://jnj2.ftp.mdsol.com/${protocol}/${type}/$latestraw  \
-O  ftp://jnj2.ftp.mdsol.com/${protocol}/${type}/$latestcust   

mv $latestraw  $dir_raw
mv $latestcust $dir_cust

unset password
unset ftpuser
unset type
rm -f ftpdownload.txt ftpdownload1.txt


