#!/usr/local/bin/bash 

sdduser=yoursddusername
sddpassword=yoursddpassword

local_definedir=/projects/jjprd224002/stats/transfer/outputs/define
sdd_definedir=/SAS/3952/56022473AML2002/Files/Staging/DM_CRO/SDTM_XPT_Package/Current
input4pk=/SAS/3952/56022473AML2002/Files/Staging/DM_CRO/Input_Data_For_PK_Office


source  /opt/pxlcommon/stats/applications/sdd/setcp

current_sdtm=$(cd ${local_definedir} ;\
ls -l *prod*.zip | awk -F_ '{print substr($(NF),1,8) , $0}' | sort -k1n | awk 'END{print $(NF)}' );\
echo -e $current_sdtm  "   will be upload to SDD"
sddurl="https://jajprod.ondemand.sas.com"
$javaexe sample.SASDrugDevCommand -s $sddurl -u ${sdduser} -p ${sddpassword}  \
-create_repository_file ${sdd_definedir}/${current_sdtm} ${local_definedir}/${current_sdtm}

# in my own study , i need put a SDTM package copy to PK office folder, on the begin of each month
#  if you don't need this step , you can just remove the code below. 
export thisday=$(date +%d) 
if (( $((10#$thisday))  <  7 )) || [ "$1" == "pk" ]
then   
  echo "send an copy to SG PK office" 
 $javaexe sample.SASDrugDevCommand -s $sddurl -u ${sdduser} -p ${sddpassword}  \
  -create_repository_file ${input4pk}/${current_sdtm} ${local_definedir}/${current_sdtm}
fi
