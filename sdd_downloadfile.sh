#!/usr/local/bin/bash

source  /opt/pxlcommon/stats/applications/sdd/setcp

#download the latest IWRS data  , which is stored as sas7bdat file on SDD
# list and find the latest file
latest_iwrs=$(/opt/java6/bin/java sample.SASDrugDevCommand -s https://sddcampine.ondemand.sas.com -u LZHAN134 -p password \
-repository_list /SAS/3952/56022473AML2002/Files/Staging/IVRS_IWRS  -showChildren | \
grep -i "ZR_........\.sas7bdat" | sort -n | awk -F: 'END{print $(NF) }'); echo $latest_iwrs  " will be download" 
# download the latest version to local
/opt/java6/bin/java sample.SASDrugDevCommand -s https://sddcampine.ondemand.sas.com -u LZHAN134 -p password \
-download_repository_file $latest_iwrs  /projects/jjprd224002/stats/transfer/data/rawrand/zr.sas7bdat
