#colllect transfer info 
zipinfo  -m "56022473AML2002_SDTM_*_Transfer_*.zip" > listfile.txt
grep "number of entries" listfile.txt | awk -F: '{ print $(NF) - 6  }' > test.txt
grep "Archive:" listfile.txt | awk -F_ 'BEGIN{OFS="\t"} { print "56022473AML2002" , $2 , toupper($3) , substr($5,1,8) }' > test2.txt
paste -d"\t" test2.txt test.txt  | sort -k4n  >log.txt
rm -f test.txt test2.txt listfile.txt

cat log.txt
