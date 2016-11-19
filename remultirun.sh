#!/usr/local/bin/bash 
source /home/users/zhangl6/.bashrc
type=prod
project=jjprd224002
protocol=56022473AML2002

#=================================================================================
#  clear all files from last round multirun
cd /projects/${project}/stats/transfer/
find . -type  f  \( -name  'qc_*.txt' -o -name  '*.log'  -o -name '*.lst' -o -name '*.sas7bcat' -o -name '*.xml' \)  -exec  rm -f {} \;

cd /projects/${project}/stats/transfer/data/
find . \
-path './raw*' -prune -o  \
-path './edt' -prune -o  \
-path './metadatastd' -prune -o \
-type f -name '*.sas7bdat' -exec  rm -f {} \;

rm -f /projects/${project}/stats/transfer/global/qc_*.txt  *.pdf


cd /projects/${project}/stats/transfer/data/raw 
 
unzip -P jj224002 -n *.zip
	
cd /projects/${project}/stats/transfer/data/rawcust
unzip -n *.zip



#extra the latest e-data if needfull
#cd /projects/${project}/stats/transfer/data/edt
#ls *2002*.zip | sort -u -r -t_ -k 2,2 | xargs -n1 unzip -n  

#commit all one side program

echo "User name : ${LOGNAME}"
if [ "${LOGNAME}" = "zhangl6" ] ;
  then 
cd /projects/${project}/stats/transfer/qcprog
find . -type f -name "qc_*.sas" -print | xargs svn commit -m " " 
fi

if [ "${LOGNAME}" = "lup" ] ;
  then 
cd /projects/${project}/stats/transfer/prog
find . -type f -name "*.sas" -print | xargs svn commit -m " " 
fi



#========================================================================
# start multirun 
cd /projects/${project}/stats/transfer/prog/transfer
multirun93 multirun_m.txt 
cd /projects/${project}/stats/transfer/qcprog/transfer
multirun93 multirun_qc.txt 
cd /projects/${project}/stats/transfer/global/
multirun93 dmcc.txt

# define xml  
cd /projects/${project}/stats/transfer/prog/define/define_xml/production
sas93 sdtm_define.sas
# SAS 2 xpt 
cd /projects/${project}/stats/transfer
find . -type  f \( -name '*.xpt'  \) -exec  rm -f {} \;
cd /projects/${project}/stats/transfer/prog/transfer
sas93 sas2xpt.sas
# move xpt to define xml folder
cd /projects/${project}/stats/transfer/data/transfer/xpt/
cp *.xpt  /projects/${project}/stats/transfer/prog/define/define_xml/output/

# generate SDTM package to /stats/transfer/outputs/define/
rm -f /projects/${project}/stats/transfer/prog/define/define_xml/${protocol}_SDTM_*_Transfer_*.zip
cd /projects/${project}/stats/transfer/prog/define/define_xml/output/
cp *.xml  define.xml
export TZ=GMT-8; date
datename=$(date +%Y%m%d)

zip -r /projects/${project}/stats/transfer/prog/define/define_xml/${protocol}_SDTM_${type}_Transfer_$datename.zip *  -x"define_20*.xml"
rm -f /projects/${project}/stats/transfer/prog/define/define_xml/output/define.xml

export TZ=EST5EDT


