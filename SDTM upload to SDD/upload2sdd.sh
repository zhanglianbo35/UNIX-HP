#!/usr/local/bin/bash
source  /opt/pxlcommon/stats/applications/sdd/setcp

sdduser=yoursddusername
sddpassword=yoursddpassword

#  Don't add '/' on the end of the path
local_definedir=/projects/jjprd224002/stats/transfer/outputs/define

# **  define your LSAF location for different type's transfer , don't change the variable name  ****

sdd_define_prod_dir=/SAS/3952/56022473AML2002/Files/Staging/DM_CRO/SDTM_XPT_Package/Current          # prod transfer
sdd_define_test_dir=/SAS/3952/56022473AML2002/Files/Staging/DM_CRO/SDTM_XPT_Package/UAT/Current      # UAT transfer 
sdd_define_cutoff_dir=/SAS/3952/56022473AML2002/Files/Staging/DM_CRO/SDTM_XPT_Package/UAT            # cutoff transfer
sdd_define_pk_dir=/SAS/3952/56022473AML2002/Files/Staging/DM_CRO/Input_Data_For_PK_Office            # PK office transfer
	
#---------------------------------------------------------------------------------------------------------------------	
upload2sdd()
{
 # user can define type  as  prod , test, cutoff ,PK
	type=$1

	eval sdd_definedir=\$sdd_define_${type,,}_dir 

	if [  "${type,,}" = "prod" ] 
	then 
	  prodYN="Y"
	fi

	if [  "${type,,}" = "pk" ]  # we just send prod transfer to PK office folder
	then 
	  type=prod
	fi
	
	current_sdtm=$(cd ${local_definedir} ;ls -ltr *${type}*.zip | awk 'END {print $(NF)}' ) 
	echo -e "\033[32m $current_sdtm  "   will be upload to SDD \033[0m"
	sddurl="https://jajprod.ondemand.sas.com"
	
# test whether it can be connected to LSAF , if fail then stop script
   if [[ "$($javaexe sample.SASLsafCommand -s $sddurl -u "${sdduser}" -p "${sddpassword}" -test)" != "Connection successful!"  ]]
    then
      exit 1
   fi
	
	$javaexe sample.SASLsafCommand -s $sddurl -u "${sdduser}" -p "${sddpassword}" -create_repository_file "${sdd_definedir}/${current_sdtm}" "${local_definedir}/${current_sdtm}"

unset sdd_definedir
unset type
 
}
 
#-------------------------------------------------------------------------------------------------------------------------------------
 
#update the code below according to your requirement
 
 
upload2sdd prod 
#*** if user have also cutoff transfer as well as prod transfer,  just uncomment below row ****
#upload2sdd cutoff 
 

# this part only for  PK office transfer, user can remove this place , if you don't need 
 
thisday=$(date +%d)  
if (( $((10#$thisday)) <  7 )) || [ "$1" = "pk" ] && [  "$prodYN" = "Y" ]  # transfer one copy to PK office folder in beginning of each month
  then 
	  echo "send an copy to SG PK office"
	  unset prodYN
	  upload2sdd pk 
fi

 
 
