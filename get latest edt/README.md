This script is used for check and download the latest edt on Janssen SDD. I developed a function get_latest_edt{} inside, user need to modify the study info and edt info inside, then all the lastest eDT can be download to kennet automaticlly.

# basic syntax is like 

get_latest_edt   edtname1  "edt1 filename keyword"   "old edt1(need to be removed in kennet) filename keyword"

get_latest_edt   edtname2  "edt2 filename keyword"   "old edt2(need to be removed in kennet) filename keyword"

etc.....

we have 4 paramter in this function:  1st one is the edtname (just a simple name to be assgined),  2nd one is the edt filename looks like on SDD , 3rd one is the old edt filename looks like on kennet (which you need removed before download new one) , 4th one is the files inside zipfile , if your old edt is a zip file ,  and if your zip file contain multiple file, you can use it as  "file1 file2 file3" ;
you need quote the 3rd and 4th parameter


#  I will list the part you need update in script

# 1, update user SDD account info
sdduser=username

sddpassword="xxxxxxxxxxxxxx"

# 2, update eDT info 

# user's kennet dir folder (where you need the edt download to ? )  
local_dir=/projects/jjprd224002/stats/transfer/data/rawrand  
# edt location on SDD
sdd_dir=/SAS/3952/56022473AML2002/Files/Staging/IVRS_IWRS     

# for *.sas7bdat file, script will lowercase its filename after download, because UNIX SAS cannot read SAS datasets in upcase 
get_latest_edt  zr  "AML2002_ZR_........\.sas7bdat"   "*zr*.sas7bdat"     

# example for zip file edt
get_latest_edt  st  "_ST_........_.*\.zip"  "*_ST_*_*.zip"  "containertrac.sas7bdat   samptrac.sas7bdat"

# example for other file format
get_latest_edt  vumc  "_LB_VUMC_........\.csv" "*_LB_VUMC_*.csv" 

# example for file name which inside contains space   please use \ escape them 
get_latest_edt  heme  "_hTERT\ Data\ Table_......\.xlsx" "*_hTERT Data Table_*.xlsx" 
