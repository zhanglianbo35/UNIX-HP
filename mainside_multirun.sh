type=prod
project=jjprd224002
protocol=56022473AML2002
export protocol 
export project
export type

#=================================================================================
#  clear all files from last round multirun

cd /projects/${project}/stats/transfer/
find . \
-path './qcprog' -prune -o  \
-path './data/q*' -prune -o \
-type f \(  -name  '*.log'  -o -name '*.sas7bcat' -o -name '*.xml' \)  -exec  rm -f {} \;

cd /projects/${project}/stats/transfer/data/
find . \
-path './raw*' -prune -o  \
-path './edt' -prune -o  \
-path './metadatastd' -prune -o \
-type f -name '*.sas7bdat' -exec  rm -f {} \;

rm -f /projects/${project}/stats/transfer/global/*.pdf

#=================================================================================
#    unzip source data   
cd /projects/${project}/stats/transfer/data/raw
unzip  -P jj224002 -n  *.zip   

cd /projects/${project}/stats/transfer/data/rawcust
unzip -n *.zip

#========================================================================
# start multirun mainside

cd /projects/${project}/stats/transfer/prog/transfer
multirun93 multirun_m.txt 

cd /projects/${project}/stats/transfer/global/
sas93 -sysparm "mainside" logcheck_transfer.sas

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

# generate SDTM package to /stats/transfer/outputs/define/  folder
rm -f /projects/${project}/stats/transfer/prog/define/define_xml/${protocol}_SDTM_*_Transfer_*.zip
cd /projects/${project}/stats/transfer/prog/define/define_xml/output/
cp *.xml  define.xml
TZ=GMT-8; export TZ; date
datename=$(date +%Y%m%d)
zip -r /projects/${project}/stats/transfer/prog/define/define_xml/${protocol}_SDTM_${type}_Transfer_$datename.zip *  -x"define_20*.xml"
sleep 3
rm -f /projects/${project}/stats/transfer/prog/define/define_xml/output/define.xml

TZ=EST5EDT; export TZ;
