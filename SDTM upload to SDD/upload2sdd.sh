#!/usr/local/bin/bash 
source  /opt/pxlcommon/stats/applications/sdd/setcp

sdduser=yoursddusername
sddpassword=yoursddpassword

type=prod                                                            # prod or test                             

#  Don't add '/' on the end of the path
local_definedir=/projects/jjprd224002/stats/transfer/outputs/define
sdd_define_prod_dir=/SAS/3952/56022473AML2002/Files/Staging/DM_CRO/SDTM_XPT_Package/Current        # prod transfer folder
sdd_define_UAT_dir=/SAS/3952/56022473AML2002/Files/Staging/DM_CRO/SDTM_XPT_Package/UAT/Current     # UAT transfer folder
input4pk=/SAS/3952/56022473AML2002/Files/Staging/DM_CRO/Input_Data_For_PK_Office



type=${type,,}
if  [  "$type" = "test" ]
then
  sdd_definedir=$sdd_define_UAT_dir
else
  sdd_definedir=$sdd_define_prod_dir
fi
	
	
current_sdtm=$(cd ${local_definedir} ;\
ls -l *${type}*.zip | awk -F_ '{print substr($(NF),1,8) , $0}' | sort -k1n | awk 'END{print $(NF)}' );\
echo -e $current_sdtm  "   will be upload to SDD"
sddurl="https://jajprod.ondemand.sas.com"
$javaexe sample.SASDrugDevCommand -s $sddurl -u ${sdduser} -p ${sddpassword}  \
 -create_repository_file ${sdd_definedir}/${current_sdtm} ${local_definedir}/${current_sdtm}

thisday=$(date +%d) 
if (( $((10#$thisday)) <  7 )) || [ "$1" == "pk" ]  && [ "$type" == "prod" ]
then 
  echo "send an copy to SG PK office"
  $javaexe  sample.SASDrugDevCommand -s $sddurl -u ${sdduser} -p ${sddpassword}  \
   -create_repository_file ${input4pk}/${current_sdtm} ${local_definedir}/${current_sdtm}
fi

unset sdd_definedir
unset thisday
unset type
