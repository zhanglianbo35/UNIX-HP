#!/usr/local/bin/bash 
source  /opt/pxlcommon/stats/applications/sdd/setcp 

sdduser=username
sddpassword="xxxxxxxxxxxxxx"

get_latest_edt()
{
#@USAGE get_latest_edt edt_name file_match_partten  old_zipfile  old_file_extra
# test whether it can be connected to LSAF , if fail then stop script
 if [[ "$($javaexe sample.SASLsafCommand -s $sddurl -u ${sdduser} -p ${sddpassword} -test)" != "Connection successful!"  ]] ; then
   exit 1
 fi
$javaexe sample.SASLsafCommand -s $sddurl -u ${sdduser} -p ${sddpassword} -repository_list ${sdd_dir} -verbose -showChildren > ${1}_raw
grep -i "path:" ${1}_raw |sed 's/^path:\ //g'  > ${1}_file_lst
grep -i "Attribute lastModified has value:" ${1}_raw |sed 's/^[ \t]*//;s/[ \t]*$//' |  tr " " "\t"  >   ${1}_file_ctime
awk -F'\t' '{print $7 , $6 , $10 , $8 }' ${1}_file_ctime | while read day monthname year ptime
 do
  monthname=${monthname^^}
  case $monthname in ## convert $monthname to number
	JAN*) month=01 ;;
	FEB*) month=02 ;;
	MAR*) month=03 ;;
	APR*) month=04 ;;
	MAY*) month=05 ;;
	JUN*) month=06 ;;
	JUL*) month=07 ;;
	AUG*) month=08 ;;
	SEP*) month=09 ;;
	OCT*) month=10 ;;
	NOV*) month=11 ;;
	DEC*) month=12 ;;
    [1-9]|1[0-2]) month=$monthname ;; ## accept number if entered
    *) echo "Invalid month: $monthname" >&2 ;;
  esac
  echo -e  "${year}${month}${day}T${ptime}"  
  done >  ${1}_file_ctime_num 
paste -d'\t' ${1}_file_ctime_num  ${1}_file_ctime  ${1}_file_lst | grep -i  "$2"  | awk 'BEGIN{FS="\t";OFS="\t";ORS="\n"}{print $1, $(NF) , $8 , $7 ,$11 , $9  }' |\
 sort -t $'\t' -k1n | tail -n 1 | cut -d$'\t' -f2- | sed 's/ /\\ /g' > ${local_dir}/.${1}_info.txt
 
fileinfo_new="$(cat ${local_dir}/.${1}_info.txt | tr '\t' ' ')"

if [  -f ${local_dir}/${1}_info.txt ] ; then
  fileinfo_old="$(cat ${local_dir}/${1}_info.txt)"
else
  fileinfo_old=""
fi

if [ "$fileinfo_old" != "$fileinfo_new" ] ; then
     eval latest_${1}="$(awk -F'\t' '{ print $1 }' ${local_dir}/.${1}_info.txt )"
#new edt file info{	 
     latest_temp="$(eval echo \$latest_$1)" 
     targetfile="${latest_temp##*/}"
     fileextend="${targetfile##*.}"
#-----------------}	 
     echo -e "\033[32m $latest_temp  will be download \033[0m" 

    if (( ${#3} >1 )) ; then
      cd ${local_dir} && rm -f ${3}
      cd $OLDPWD
    fi
    if (( ${#4} >1 )) ; then
      cd ${local_dir} && rm -f ${4}
      cd $OLDPWD
    fi

    $javaexe sample.SASLsafCommand -s $sddurl -u ${sdduser} -p ${sddpassword} -download_repository_file "$latest_temp"  "${local_dir}/$targetfile"

    if [ ${fileextend,,} = "zip" ] ; then
	   if [ "$zippasswd" != "" ] ; then
	     unzipexe="$(eval echo unzip -o -LL -P \${zippasswd})"
	   else	
         unzipexe="unzip -o -LL"
       fi	   
	 $unzipexe ${local_dir}/$targetfile -d  ${local_dir}  
    elif [ ${fileextend,,} = "sas7bdat" ] && [ ${targetfile,,} != ${targetfile} ] ; then
      mv  ${local_dir}/$targetfile  ${local_dir}/${targetfile,,}  
    fi
    cat ${local_dir}/.${1}_info.txt | tr '\t' ' '>  ${local_dir}/${1}_info.txt 

else
    echo -e `cat ${local_dir}/${1}_info.txt` "  is the latest, no need update "
fi

rm -f ${1}_raw ${1}_file_lst  ${1}_file_ctime*  ${local_dir}/.${1}_info.txt


unset zippasswd
unset local_dir
unset sdd_dir
unset fileinfo_old
unset fileinfo_new
unset latest_temp
unset targetfile
unset fileextend
unset unzipexe
}

#-----------------------IWRS ZR ----------------------------------------------
local_dir=/projects/jjprd224002/stats/transfer/data/rawrand
sdd_dir=/SAS/3952/56022473AML2002/Files/Staging/IVRS_IWRS
get_latest_edt  zr  "AML2002_ZR_........\.sas7bdat"   "*zr*.sas7bdat"

#-----------------------Sample tracking ----------------------------------------------
local_dir=/projects/jjprd224002/stats/transfer/data/edt
sdd_dir=/SAS/3952/56022473AML2002/Files/Staging/LAB/Biomarkers
get_latest_edt  st  "_ST_........_.*\.zip"  "*_ST_*_*.zip"  "containertrac.sas7bdat   samptrac.sas7bdat"

#-----------------------BCP ------------------------------------------------------------
local_dir=/projects/jjprd224002/stats/transfer/data/edt
sdd_dir=/SAS/3952/56022473AML2002/Files/Staging/PK_Office/PC_Sample_Identifier
# if your zip file contains password, then assgin the password just before execute the function
# if no password, you don't need define this variable, just remove
zippasswd="zip file password"
get_latest_edt  bcp "_SAMPID_........\.zip"  "JNJ56022473AML2002_SAMPID*.zip"  "*aml2002_sampid***.*"

#-----------------------PRA LIMS ------------------------------------------------------
local_dir=/projects/jjprd224002/stats/transfer/data/edt
sdd_dir=/SAS/3952/56022473AML2002/Files/Staging/PK_Office/PC_Sample_Identifier
get_latest_edt  pra  "_LIMS_........\.zip"  "JNJ56022473AML2002_LIMS*.*"  "jnj56022473aml2002_lims***.*"


#--------------------BARC Covance_lb ------------------------------------------------------
local_dir=/projects/jjprd224002/stats/transfer/data/edt
sdd_dir=/SAS/3952/56022473AML2002/Files/Staging/LAB/Biomarkers
get_latest_edt  covance_lb  "_LB_........_.*\.ZIP" "*_LB_*_*.ZIP"  "covance_lb.sas7bdat"


#--------------------BARC Covance_pr ------------------------------------------------------
local_dir=/projects/jjprd224002/stats/transfer/data/edt
sdd_dir=/SAS/3952/56022473AML2002/Files/Staging/LAB/Biomarkers
get_latest_edt  covance_pr  "_PR_........_.*\.ZIP" "*_PR_*_*.ZIP"  "covance_pr.sas7bdat"


#--------------------VUMC ------------------------------------------------------
local_dir=/projects/jjprd224002/stats/transfer/data/edt
sdd_dir=/SAS/3952/56022473AML2002/Files/Staging/LAB 
get_latest_edt  vumc  "_LB_VUMC_........\.csv" "*_LB_VUMC_*.csv" 

#--------------------JNJ heme ----------if your target filename contain space or other string,  please use \ escape them -----
local_dir=~/test
sdd_dir=/SAS/4207/63935937MYF2001/Files/Staging/LAB_JNJ_HEME
get_latest_edt  heme  "_hTERT\ Data\ Table_......\.xlsx" "*_hTERT Data Table_*.xlsx" 
