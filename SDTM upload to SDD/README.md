# Upload SDTM define package to SDD. Modify these info before you use it

# your SDD account info
sdduser=yoursddusername

sddpassword=yoursddpassword

# kennet folder where your define package store
local_definedir=/projects/jjprd224002/stats/transfer/outputs/define

# SDD folder
sdd_definedir=/SAS/3952/56022473AML2002/Files/Staging/DM_CRO/SDTM_XPT_Package/Current

# for save a copy to PK office folder,  if your study not need it,  please remove last part in code

# syntax like  below,  normally you don't need modify the code inside function  upload2sdd(){ }
# suppose your define package name looks like  xxxx_${type}_xxxxx.zip , and the type is the value in "upload2sdd prod"

upload2sdd prod  
upload2sdd cutoff  
upload2sdd test  

