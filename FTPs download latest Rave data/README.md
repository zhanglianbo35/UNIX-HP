# This script can help user always download the latest Rave edc data and custom domain (if study have) to kennet folder

#  Normally User only need to modify these variable info 

# insert your username here, eg. zhangl6 , we must manually utilize the user's bash configure file at first
source /home/users/YOUR_username/.bashrc   
# your Janssen FTP account info
ftpuser="yourftpusername"

password="yourpassword"                    #if you have special character , you can quote your password

# your study's protocol ID
protocol="JNJ protocol ID"
#  PROD or UAT  , case insensitive
type=Prod
#  root folder on kennet
project="PXL_project"                      # eg.   jjprd224002
#  rave data dir on kennet
dir_raw=/projects/${project}/stats/transfer/data/raw
#  custom domain dir on kennet
dir_cust=/projects/${project}/stats/transfer/data/rawcust
