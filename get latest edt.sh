#!/usr/local/bin/bash 
source  /opt/pxlcommon/stats/applications/sdd/setcp 

sdduser=username
sddpassword="xxxxxxxxxxxxxx"


get_latest_edt()
{
#@USAGE get_latest_edt edt_name file_match_partten old_zipfile old_file_extra
/opt/java6/bin/java sample.SASDrugDevCommand -s https://sddcampine.ondemand.sas.com -u ${sdduser} -p ${sddpassword} -repository_list ${sdd_dir} -verbose -showChildren > ${1}_raw
grep -i "path:" ${1}_raw > ${1}_file_lst
grep -i "Attribute created has value:" ${1}_raw > ${1}_file_ctime
paste -d"\t" ${1}_file_ctime  ${1}_file_lst | grep -i  $2  | awk -F' '  '{print $(NF) , $7 , $6 ,$10 , $8  }' | sort -k1n | tail -n 1 > ${local_dir}/.${1}_info.txt
fileinfo_new=$(cat ${local_dir}/.${1}_info.txt)
if  [  -f ${local_dir}/${1}_info.txt ]
then
  fileinfo_old=$(cat ${local_dir}/${1}_info.txt)
else
  fileinfo_old=""
fi

if  [ "$fileinfo_old" != "$fileinfo_new" ]
then
        eval latest_${1}=$(awk '{ print $1 }' ${local_dir}/.${1}_info.txt )
        latest_temp=$(eval echo \$latest_$1) 
        echo -e "\n*********************************************************************************"
        echo -e "$latest_temp  will be download" 
        echo -e "*********************************************************************************\n"

    if (( ${#3} >1 )) 
    then
        rm -f "${local_dir}/${3}" 
    fi
    if (( ${#4} >1 )) 
    then
        rm -f "${local_dir}/${4}"
    fi

	/opt/java6/bin/java sample.SASDrugDevCommand -s https://sddcampine.ondemand.sas.com -u ${sdduser} -p ${sddpassword} -download_repository_file $latest_temp    ${local_dir}/$( echo $latest_temp | awk -F/  '{print $(NF) }' )

    if [ $(echo $latest_temp | awk -F. '{print tolower($(NF))}') = "zip" ]
    then
        unzip -o -LL ${local_dir}/$( echo "$latest_temp" | awk -F/  '{print $(NF) }' ) -d  ${local_dir}  &&  mv ${local_dir}/.${1}_info.txt ${local_dir}/${1}_info.txt
    elif [ $(echo $latest_temp | awk -F. '{print tolower($(NF))}') = "sas7bdat" ]
    then
       mv  ${local_dir}/$( echo "$latest_temp" | awk -F/  '{print $(NF) }' )  ${local_dir}/$(echo "$latest_temp" | awk -F/ '{print $(NF)}'| tr '[A-Z]' '[a-z]') &&  mv ${local_dir}/.${1}_info.txt ${local_dir}/${1}_info.txt
    else
        mv ${local_dir}/.${1}_info.txt ${local_dir}/${1}_info.txt
    fi
else
    echo -e "\n***************************************************************************************"
    echo -e `cat ${local_dir}/${1}_info.txt` "  is the latest, not need update "
    echo -e "****************************************************************************************\n"
fi

rm -f ${1}_raw ${1}_file_lst  ${1}_file_ctime  ${local_dir}/.${1}_info.txt



unset local_dir
unset sdd_dir
unset fileinfo_old
unset fileinfo_new
unset latest_temp
}


#-----------------------IWRS ZR ----------------------------------------------
local_dir=/projects/jjprd224002/stats/transfer/data/rawrand
sdd_dir=/SAS/3952/56022473AML2002/Files/Staging/IVRS_IWRS
get_latest_edt  zr  "AML2002_ZR_........\.sas7bdat"   "***.sas7bdat"

#-----------------------Sample tracking ----------------------------------------------
local_dir=/projects/jjprd224002/stats/transfer/data/edt
sdd_dir=/SAS/3952/56022473AML2002/Files/Staging/LAB/Biomarkers
get_latest_edt  st  "_ST_........_.*\.zip"  "_ST_........_.*\.zip"  "containertrac.sas7bdat   samptrac.sas7bdat"

#-----------------------BCP ------------------------------------------------------------
local_dir=/projects/jjprd224002/stats/transfer/data/edt
sdd_dir=/SAS/3952/56022473AML2002/Files/Staging/PK_Office/PC_Sample_Identifier
get_latest_edt  bcp "_SAMPID_........\.zip"  "JNJ56022473AML2002_SAMPID*.zip"  "*aml2002_sampid***.*"

#-----------------------PRA LIMS ------------------------------------------------------
local_dir=/projects/jjprd224002/stats/transfer/data/edt
sdd_dir=/SAS/3952/56022473AML2002/Files/Staging/PK_Office/PC_Sample_Identifier
get_latest_edt  pra  "_LIMS_........\.zip"  "JNJ56022473AML2002_LIMS*.*"  "jnj56022473aml2002_lims***.*"


#--------------------BARC Covance_lb ------------------------------------------------------
local_dir=/projects/jjprd224002/stats/transfer/data/edt
sdd_dir=/SAS/3952/56022473AML2002/Files/Staging/LAB/Biomarkers
get_latest_edt  covance_lb  "_LB_........_.*\.ZIP" "_LB_........_.*\.ZIP"  "covance_lb.sas7bdat"


#--------------------BARC Covance_pr ------------------------------------------------------
local_dir=/projects/jjprd224002/stats/transfer/data/edt
sdd_dir=/SAS/3952/56022473AML2002/Files/Staging/LAB/Biomarkers
get_latest_edt  covance_pr  "_PR_........_.*\.ZIP" "_PR_........_.*\.ZIP"  "covance_pr.sas7bdat"


#--------------------VUMC ------------------------------------------------------
local_dir=/projects/jjprd224002/stats/transfer/data/edt
sdd_dir=/SAS/3952/56022473AML2002/Files/Staging/LAB 
get_latest_edt  vumc  "_LB_VUMC_........\.csv" "_LB_VUMC_........\.csv" 

