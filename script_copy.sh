#!/bin/sh

### This script is sanity checks which will run 3 scripts for pending transctions and dump it in final_report.
#fail.txt ------  Have to give all seeds for which you want to run these tests.
#final_report.txt --- result will be dumped into this file 
# It will also capture the first error signature line from postsim.log

###MAYUR    wru=`whoami`
###MAYUR    if [[ ! -d /tmp/$wru ]] 
###MAYUR    then
###MAYUR    mkdir /tmp/$wru
###MAYUR    fi
cd $1
final_report=$PWD\/final_report.txt


###MAYUR    if [[ -f $final_report ]] 
###MAYUR    then
###MAYUR    rm -rf $final_report
###MAYUR    fi


num=1

if [[ -f fail.txt ]] 
then
cp -rf fail.txt fail_temp.txt
rm -rf fail.txt
fi

if [[ -f fail_temp.txt ]] 
then
num=`cat fail_temp.txt | wc -l`
fi

zgrep -l "Mode:sprsp_temp -> Fail" */postsim.log.gz */external*/postsim.log.gz | sed 's/\(.*\)\//\1 /' | awk '{print $1}' >> fail.txt 

sort -u fail.txt >> fail_temp.txt
sort fail_temp.txt > fail_temp1.txt
uniq -u fail_temp1.txt > fail_delta.txt

rm -rf fail_temp.txt
#echo "MAYUR" >> $final_report
exec 3< fail_delta.txt
while read 0<&3 line; do
cd $line
echo "$num ${line}" >> $final_report
lsti | grep FAIL >> $final_report
zgrep dirtag simmon.xml.gz | sed 's/<dirtag>//g' | sed 's/<.*>//g' >> $final_report
#/nfs/sc/disks/sdg74_1309/sw/bin/incomplete_pcie_trans | grep "Number of Pending Transactions" >> $final_report
pcie_line=`/nfs/sc/disks/sdg74_1309/sw/bin/incomplete_pcie_trans | grep "Number of Pending Transactions" `
iosf_line=`/nfs/sc/disks/sdg74_1309/sw/bin/iosf_txn_chk.pl | grep "First Pending Transaction of ALL Trackers is"`
echo "$pcie_line" >> $final_report
echo "$iosf_line" >> $final_report
iosf_time=`echo $iosf_line | grep "First Pending Transaction of ALL Trackers is " | grep -Eo '[0-9]*'`
pcie_time=`echo $pcie_line | grep -o "Time of Oldest Transaction:.*+ERROR" | tail -1 | grep -Eo '[0-9]*'`
echo "*       First pending transaction from pcie.log is " >> $final_report
grep "   " hang_logs/pcie.log | head -1 >> $final_report
pcie_log_time=`grep "   " hang_logs/pcie.log | head -1 | grep -o "out.gz .* " | awk '{print $2}'`

#echo $pcie_time
#echo "$num ${line}" 
echo "*       Below is the first Error from postsim.log " >> $final_report
zgrep -A 3 "Errors from logfile" postsim.log.gz >> $final_report
zgrep -m 1 "HANG_CHECK" postsim.log.gz >> $final_report
#`/nfs/sc/disks/sdg74_1309/sw/bin/incomplete_pcie_trans` >> $PWD\/pc.txt
#/nfs/sc/disks/sdg74_1309/sw/bin/iosf_txn_chk.pl | wc -l > $PWD\/pend_iosf.txt
#/nfs/sc/disks/sdg74_1309/sw/bin/parse_idi_tracker.pl | grep -v Llc | grep -v GO_I | grep -v SpCyc | wc -l >> pend_idi.txt
#/nfs/sc/disks/xpg.sprmccfe_soccw.0001/$wru/JUNK/pendingtor.tcsh | wc -l >> pend_ptor.txt
#cat pend_iosf.txt
#zgrep -m 1 "Error: SHR_PACKAGE Seeing outstanding transactions at the end of the test" sn_compile.elog.gz >> $final_report
echo "*       Below is the last line in linker_output " >> $final_report 
last_line=`zcat linker_output.elog.gz | tail -1 `
linker_time=`echo $last_line | grep -o "\[.*\]" | grep -Eo '[0-9]*' `
#echo "linker_time is $linker_time " 
echo "$last_line" >> $final_report
echo "*       Below is the the output of sn_hang " >> $final_report
time=`lsti | grep FAIL |awk '{print $4}'` 
/nfs/sc/disks/xpg.sprmccfe_soccw.0001/mraichux/JUNK/script/original/hang.sh $time >> $final_report
sn_time=`/nfs/sc/disks/xpg.sprmccfe_soccw.0001/mraichux/JUNK/script/original/hang.sh $time | head -1 | grep -o "\[.*\]" | grep -Eo '[0-9]*' `

echo "Transactions without zero length from iosf_trk are as follows:" >> $final_report
iosf_non_zero_line=`/nfs/sc/disks/sdg74_1309/sw/bin/iosf_txn_chk.pl | grep "^|" | grep -v "|   0" | sort | head -1 `
iosf_non_zero=`echo $iosf_non_zero_line | sed 's/|/ /g' | awk '{print $1}' `
echo "$iosf_non_zero_line" >> $final_report

echo "" >> $final_report
echo "Simulation end time : $time" >> $final_report
echo "1st pending pcie transaction time from pcie_trk is : $pcie_time" >> $final_report
echo "1st pending pcie transaction time from pcie_log is : $pcie_log_time" >> $final_report
echo "linker_log last line time : $linker_time " >> $final_report
echo "1st hang from sn_compiler : $sn_time" >> $final_report 
echo "1st pending iosf transaction time : $iosf_time" >> $final_report
echo "1st pending iosf transaction with non zero length is : $iosf_non_zero" >> $final_report
#iosf_num=$(cat $PWD\/pend_iosf.txt)
###MAYUR    if [ $iosf_num != 8 ]
###MAYUR    then
###MAYUR    echo "*       There are pending iosf transactions as \"iosf_trk | wc -l\" is greter than 8" >> $final_report
###MAYUR    else 
###MAYUR    echo "*       There are no pending iosf transactions " >> $final_report
###MAYUR    fi

###MAYUR    idi_num=$(cat pend_idi.txt)
###MAYUR    if [ $idi_num != 21 ]
###MAYUR    then
###MAYUR    echo "*       There are pending idi transactions as \"idi_trk | wc -l\" is greter than 23" >> $final_report
###MAYUR    fi

###MAYUR    ptor_num=$(cat pend_ptor.txt)
###MAYUR    if [ $ptor_num == 0 ]
###MAYUR    then
###MAYUR    echo "*       Value of is  \"ptor | wc -l\" is 0 which means it is not reached to user_data_phase" >> $final_report
###MAYUR    #ptor_num=$(cat pend_ptor.txt)
###MAYUR    elif [ $ptor_num != 34 ]
###MAYUR    then
###MAYUR    echo "*       There are pending ptor as \"ptor | wc -l\" is greter than 34" >> $final_report
###MAYUR    else
###MAYUR    echo "*       There are no pending tor" >> $final_report
###MAYUR    fi

###MAYUR    rm -rf $PWD\/pend_iosf 
###MAYUR    rm -rf $PWD\/pend_ptor.txt
###MAYUR    rm -rf pend_idi.txt
#rm -rf p.log p.log.gz
cd -
echo >> $final_report
###MAYUR    tac $PWD\/pc.txt | head -1 >> $final_report
echo "*****************************************************************************************************" >> $final_report
echo >> $final_report
###MAYUR    rm -rf $PWD\/pc.txt
num=`expr $num + 1`
done
sed -i '/Errors from logfile/d' $final_report
sed -i '/# acerun.log/d' $final_report
sed -i '/Line Number: Line/d' $final_report
sed -i '/Errors from logfile/d' $final_report
cp -rf $final_report final_temp
cat final_temp | uniq > $final_report
