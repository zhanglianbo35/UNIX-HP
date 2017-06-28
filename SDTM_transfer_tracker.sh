#colllect transfer info 
# the script extra the info inside the define package of each transfer
# package file name looks like  56022473AML2002_SDTM_prod_Transfer_20160503.zip

zipinfo  -m -h -t  "56022473AML2002_SDTM_*_Transfer_*.zip"  *.xpt > listfile.txt
grep "bytes compressed" listfile.txt | awk -F' ' '{ print $1 }' > test.txt
grep "Archive:" listfile.txt | awk -F_ 'BEGIN{OFS="\t"} { print "56022473AML2002" , $2 , toupper($3) , substr($5,1,8) }' > test2.txt
paste -d"\t" test2.txt test.txt  | sort -k4n  >log.txt
rm -f test.txt test2.txt listfile.txt

cat log.txt | awk '{sum+=$5 ; print $0} END{print "\033[32m SDTM totally transfer",sum,"datasets \033[0m"}'
