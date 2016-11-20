type=prod
project=jjprd224002
protocol=56022473AML2002
#==============================================================
# clear some files 
cd /projects/${project}/stats/transfer/data/metadata/previous
rm -f *.sas7bdat
find /projects/${project}/stats/transfer/data/raw* -type f -name '*.zip' -exec rm -f {} \;
cd /projects/${project}/stats/transfer/global
rm -f ${protocol}\ Metadata\ Compare\ Report*.xls

# set time zone to GMT-8
TZ=GMT-8; export TZ; date
datename=$(date +%Y%m%d)

#backup this round's meta data 

cd /projects/${project}/stats/transfer/data/metadata
zip -r metadata_$datename.zip *.sas7bdat -r
sleep 2
mv metadata_$datename.zip /projects/${project}/stats/transfer/data/metadata/previous/

#backup mainside SAS dataset, sometimes maybe sponsor want to us also compare SDTM dataset differece
cd /projects/${project}/stats/transfer/data/transfer/
zip -r domain_${type}_transfer_$datename.zip *.sas7bdat -r
sleep 2

mv domain_${type}_transfer_$datename.zip  /projects/${project}/stats/transfer/data/transfer/previous/

#move SDTM package into transfer/outputs/define/
mv /projects/${project}/stats/transfer/prog/define/define_xml/${protocol}_SDTM_${type}_Transfer_$datename.zip   /projects/${project}/stats/transfer/outputs/define/

#backup all files to /stats/deliverables/
cd /projects/${project}/stats/transfer
zip -r /projects/${project}/stats/deliverables/${project}_sdtm_${type}_$datename.zip prog data qcprog -x /data/transfer/xpt/xpt_*.zip \
prog/define/define_xml/*.zip data/metadata/previous/*.* data/transfer/previous/*.zip  qcprog/transfer/*.zip

#unzip last round metadata package, and do the metadata compare
cd /projects/${project}/stats/transfer/data/metadata/previous 
find /projects/${project}/stats/transfer/data/metadata/previous -mtime +1 -mtime -12  -name "metadata*.zip" -print -exec  unzip  {} \;
cd /projects/${project}/stats/transfer/global/ 
sas93 gmjjmetacompare.sas

# move sdtm data to offline folder
if [ ${type}=prod ] ;
then
rm -f /projects/${project}/stats/listings/data/raw/*.sas7bdat
cp /projects/${project}/stats/transfer/data/transfer/*.sas7bdat  /projects/${project}/stats/listings/data/raw
fi

cd /projects/${project}/stats/transfer/global
wget  --http-user zhangl6  --http-password XXXXX -O svnversion.txt http://kennet.na.pxl.int:7070/svnrepo/LP_BLINDED_JJPRD224002_STATS/transfer

TZ=EST5EDT; export TZ;
