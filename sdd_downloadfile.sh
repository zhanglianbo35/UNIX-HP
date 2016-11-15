#!/usr/local/bin/bash

sdduser=your_sdd_username
sddpassword=your_sdd_password
local_dir=/projects/jjprd224002/stats/transfer/data/rawrand
sdd_dir=/SAS/3952/56022473AML2002/Files/Staging/IVRS_IWRS


source  /opt/pxlcommon/stats/applications/sdd/setcp
#download the latest IWRS data  , which is stored as sas7bdat file on SDD, named such like AML2002_ZR_yyyymmdd.sas7bdat
# list and find the latest file
latest_iwrs=$(/opt/java6/bin/java sample.SASDrugDevCommand -s https://sddcampine.ondemand.sas.com -u ${sdduser} -p ${sddpassword} \
-repository_list ${sdd_dir}  -showChildren | \
grep -i "ZR_........\.sas7bdat" | sort -n | awk -F: 'END{print $(NF) }'); echo $latest_iwrs  " will be download" 
# download the latest version to local
/opt/java6/bin/java sample.SASDrugDevCommand -s https://sddcampine.ondemand.sas.com -u ${sdduser} -p ${sddpassword} \
-download_repository_file $latest_iwrs ${local_dir}/$( echo $latest_st | awk -F/  '{print $(NF) }' )


