#!/usr/local/bin/bash 
source  /opt/pxlcommon/stats/applications/sdd/setcp 

local_definedir=/projects/jjprd224002/stats/transfer/outputs/define
sdd_definedir=/SAS/3952/56022473AML2002/Files/Staging/DM_CRO/SDTM_XPT_Package/Current

current_sdtm=$(cd ${local_definedir} ;\
ls -l *prod*.zip | awk -F_ '{print substr($(NF),1,8) , $0}' | sort -k1n | awk 'END{print $(NF)}' );\
echo -e $current_sdtm  "   will be upload to SDD"

 /opt/java6/bin/java sample.SASDrugDevCommand -s https://sddcampine.ondemand.sas.com -u LZHAN134 -p sdd_password  \
-create_repository_file ${sdd_definedir}/${current_sdtm} ${local_definedir}/${current_sdtm}