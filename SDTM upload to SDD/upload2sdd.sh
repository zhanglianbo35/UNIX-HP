#!/usr/local/bin/bash
source  /opt/pxlcommon/stats/applications/sdd/setcp

sdduser=yoursddusername
sddpassword=yoursddpassword

#  Don't add '/' on the end of the path
local_definedir=/projects/jjprd224002/stats/transfer/outputs/define

# **  define your LSAF location for different type's transfer  ****

sdd_define_prod_dir=/SAS/3952/56022473AML2002/Files/Staging/DM_CRO/SDTM_XPT_Package/Current          # prod transfer
sdd_define_UAT_dir=/SAS/3952/56022473AML2002/Files/Staging/DM_CRO/SDTM_XPT_Package/UAT/Current       # UAT transfer 
sdd_define_cutoff_dir=/SAS/3952/56022473AML2002/Files/Staging/DM_CRO/SDTM_XPT_Package/UAT            # cutoff transfer
sdd_define_pk_dir=/SAS/3952/56022473AML2002/Files/Staging/DM_CRO/Input_Data_For_PK_Office            # PK office transfer
	
	
upload2sdd()
{
 # user can define type  as  prod , test, cutoff ,PK
	type=$1
	type=${type,,}

	if  [  "$type" = "test" ]
	then
	  sdd_definedir=$sdd_define_UAT_dir
	elif [  "$type" = "cutoff" ]
	then
	  sdd_definedir=$sdd_define_cutoff_dir
	elif [  "$type" = "pk" ]
	then
	  sdd_definedir=$sdd_define_pk_dir
	else
	  sdd_definedir=$sdd_define_prod_dir
	  export prodYN=Y
	fi

	if [  "$type" = "pk" ]  # we just send prod transfer to PK office folder
	then 
	  type=prod
	fi
	
	current_sdtm=$(cd ${local_definedir} ;\
	ls -l *${type}*.zip | awk -F_ '{print substr($(NF),1,8) , $0}' | sort -k1n | awk 'END{print $(NF)}' );\
	echo -e $current_sdtm  "   will be upload to SDD"
	sddurl="https://jajprod.ondemand.sas.com"
	
# test whether it can be connected to LSAF , if fail then stop script
   if [[ "$($javaexe sample.SASDrugDevCommand -s $sddurl -u ${sdduser} -p ${sddpassword} -test)" != "Connection successful!"  ]]
    then
      exit 1
   fi
	
	$javaexe sample.SASDrugDevCommand -s $sddurl -u ${sdduser} -p ${sddpassword} -create_repository_file ${sdd_definedir}/${current_sdtm} ${local_definedir}/${current_sdtm}

unset sdd_definedir
unset type
 
}
 
# user can adjust the code below according to your situation
upload2sdd prod 
#*** if user have also cutoff transfer as well as prod transfer,  just uncomment below row ****
#upload2sdd cutoff 
 

# this part only for  PK office transfer, user can remove this place , if you don't need 
 
thisday=$(date +%d)  
if (( $((10#$thisday)) <  7 )) && [  "$prodYN" = "Y" ]  # transfer one copy to PK office folder in beginning of each month
  then 
	  echo "send an copy to SG PK office"
	  unset prodYN
	  upload2sdd pk 
fi

 
