#!/bin/sh

### Date :- 03/09/2020

wru=`whoami`
list_name=`pwd | sed 's%\/% %g' | awk '{print $NF}'`
model_name=`pwd | sed 's%\/% %g' | awk '{print $(NF-3)}'`
user_name=`pwd | sed 's%\/% %g' | awk '{print $5}'`
file_name=$user_name\_$model_name\_$list_name
final_file_name_intent_met=$file_name\_intent_met_seeds.txt
final_file_name_intent_not_met=intent_not_met_seeds.txt
final_file_name_seed=$file_name\_bucket_report_with_seed.txt
final_fail_name_intent_met=$file_name\_intent_met.txt
PWD=`pwd`
final_fail_name_intent_not_met=$PWD\/intent_not_met.txt
lsti_fail_name=$file_name\_lsti_fail.txt
###MAYUR    if [[ ! -d /tmp/$wru ]] 
###MAYUR    then
###MAYUR    mkdir /tmp/$wru
###MAYUR    fi

if [[ -f $lsti_fail_name ]] 
then
rm -rf $lsti_fail_name
fi

if [[ -f $final_fail_name_intent_met ]] 
then
rm -rf $final_fail_name_intent_met
fi

if [[ -f $final_file_name_intent_met ]] 
then
rm -rf $final_file_name_intent_met
fi

if [[ -f $final_fail_name_intent_not_met ]] 
then
rm -rf $final_fail_name_intent_not_met
rm -rf $final_fail_name_intent_not_met\_delta
fi

if [[ -f $final_file_name_intent_not_met ]] 
then
sort -u $final_file_name_intent_not_met > $final_file_name_intent_not_met\_temp
rm -rf $final_file_name_intent_not_met
fi
num=1

###MAYUR    lsti | grep " FAIL " | awk '{print $3}' >> $lsti_fail_name
###MAYUR    exec 3< $lsti_fail_name
###MAYUR    while read 0<&3 line; do
#cd $line
#zgrep -l "Mode:sprsp_temp -> Satisfied" $line/postsim.log.gz $line/external*/postsim.log.gz | sed 's%\/% %g' | awk '{print $1}' >> $final_file_name_intent_met
zgrep -l "Mode:sprsp_temp -> Fail" */postsim.log.gz */external*/postsim.log.gz | sed 's/\(.*\)\//\1 /' | awk '{print $1}' >> $final_file_name_intent_not_met
#cd -
###MAYUR    done

###MAYUR satisfied intent net not required .        exec 3< $final_file_name_intent_met
###MAYUR satisfied intent net not required .        while read 0<&3 line; do
###MAYUR satisfied intent net not required .        echo "$num ${line}" >> $final_fail_name_intent_met
###MAYUR satisfied intent net not required .        lsti | grep " ${line} " >> $final_fail_name_intent_met
###MAYUR satisfied intent net not required .        grep -B 20 "${line}$" *.rpt | grep "DIR TAG" >> $final_fail_name_intent_met
###MAYUR satisfied intent net not required .        cd $line
###MAYUR satisfied intent net not required .        zgrep -h -A 3 "Errors from logfile" postsim.log.gz external*/postsim.log.gz >> $final_fail_name_intent_met
###MAYUR satisfied intent net not required .        zgrep -h "Error: SHR" postsim.log.gz external*/postsim.log.gz >> $final_fail_name_intent_met
###MAYUR satisfied intent net not required .        ###MAYUR    echo "      *** Below is the summary in postsim.log" >> $final_fail_name_intent_met
###MAYUR satisfied intent net not required .        ###MAYUR    zgrep -A 3 "Error Summary" postsim.log.gz external*/postsim.log.gz >> $final_fail_name_intent_met
###MAYUR satisfied intent net not required .        cd -
###MAYUR satisfied intent net not required .        echo >> $final_fail_name_intent_met
###MAYUR satisfied intent net not required .        echo "*****************************************************************************************************" >> $final_fail_name_intent_met
###MAYUR satisfied intent net not required .        echo >> $final_fail_name_intent_met
###MAYUR satisfied intent net not required .        num=`expr $num + 1`
###MAYUR satisfied intent net not required .        done
###MAYUR satisfied intent net not required .        sed -i '/Errors from logfile/d' $final_fail_name_intent_met
###MAYUR satisfied intent net not required .        sed -i '/# acerun.log/d' $final_fail_name_intent_met
###MAYUR satisfied intent net not required .        sed -i '/Line Number: Line/d' $final_fail_name_intent_met
###MAYUR    sed -i '/Error Summary/d' $final_fail_name_intent_met
###MAYUR    sed -i '/All, Sorted by Severity, Other/d' $final_fail_name_intent_met
###MAYUR    sed -i '/  1 - ALL : /d' $final_fail_name_intent_met
###MAYUR    sed -i 's/^postsim.log.gz://g' $final_fail_name_intent_met


num1=1
sort -u $final_file_name_intent_not_met >> $final_file_name_intent_not_met\_temp
sort $final_file_name_intent_not_met\_temp > $final_file_name_intent_not_met\_temp1
uniq -u $final_file_name_intent_not_met\_temp1 > $final_file_name_intent_not_met\_delta
 
exec 3< $final_file_name_intent_not_met
while read 0<&3 line; do
echo "$num1 ${line}" >> $final_fail_name_intent_not_met
lsti | grep " ${line} " >> $final_fail_name_intent_not_met
echo "${line}"
grep -B 20 "${line}" *.rpt | grep "DIR TAG" >> $final_fail_name_intent_not_met
cd $line
###MAYUR    zgrep -l "VCS terminated abruptly at time" acerun.log.gz >> $final_fail_name_intent_not_met 
zgrep -h -A 3 "Errors from logfile" postsim.log.gz  >> $final_fail_name_intent_not_met
zgrep -h "Error: SHR" postsim.log.gz  >> $final_fail_name_intent_not_met
zgrep -m 1 "HANG_CHECK" postsim.log.gz  >> $final_fail_name_intent_not_met
echo "mem configuration is " >> $final_fail_name_intent_not_met
~jbstein/bin/mem_config | grep "ddr5 / MC" >> $final_fail_name_intent_not_met

###MAYUR "not need to capture assertions "   zgrep -i "failed at" postsim.log.gz > assert.txt
###MAYUR "not need to capture assertions "   sed -i 's/.*soc_tb/soc_tb/g' assert.txt
###MAYUR "not need to capture assertions "   sed -i 's/: .*fs//g' assert.txt
###MAYUR "not need to capture assertions "   sort -u assert.txt >> $final_fail_name_intent_not_met

cd -
echo >> $final_fail_name_intent_not_met
echo "*****************************************************************************************************" >> $final_fail_name_intent_not_met
echo >> $final_fail_name_intent_not_met
num1=`expr $num1 + 1`
done
sed -i '/Errors from logfile/d' $final_fail_name_intent_not_met
sed -i '/# acerun.log/d' $final_fail_name_intent_not_met
sed -i '/Line Number: Line/d' $final_fail_name_intent_not_met
sed -i '/Errors from logfile/d' $final_fail_name_intent_not_met
cp -rf $final_file_name_intent_not_met failed.txt
echo >> failed.txt
cat $final_fail_name_intent_not_met | uniq >> failed.txt

num2=1

exec 3< $final_file_name_intent_not_met\_delta
while read 0<&3 line; do
echo "$num2 ${line}" >> $final_fail_name_intent_not_met\_delta
lsti | grep " ${line} " >> $final_fail_name_intent_not_met\_delta
grep -B 20 "${line}$" *.rpt | grep "DIR TAG" >> $final_fail_name_intent_not_met\_delta
cd $line
###MAYUR    zgrep -l "VCS terminated abruptly at time" acerun.log.gz >> $final_fail_name_intent_not_met\_delta 
zgrep -h -A 3 "Errors from logfile" postsim.log.gz  >> $final_fail_name_intent_not_met\_delta
zgrep -h "Error: SHR" postsim.log.gz  >> $final_fail_name_intent_not_met\_delta
zgrep -m 1 "HANG_CHECK" postsim.log.gz  >> $final_fail_name_intent_not_met\_delta
echo "mem configuration is " >> $final_fail_name_intent_not_met\_delta
~jbstein/bin/mem_config | grep "ddr5 / MC" >> $final_fail_name_intent_not_met\_delta
#source /nfs/sc/disks/xpg_sprsp_0124/aghendag/Others/hang_checks/hang_check.tcsh
#source /nfs/sc/disks/xpg.sprmccfe_soccw.0001/mraichux/JUNK/script/original/hang_check.tcsh
###MAYUR "not need to capture assertions "   zgrep -i "failed at" postsim.log.gz > assert.txt
###MAYUR "not need to capture assertions "   sed -i 's/.*soc_tb/soc_tb/g' assert.txt
###MAYUR "not need to capture assertions "   sed -i 's/: .*fs//g' assert.txt
###MAYUR "not need to capture assertions "   sort -u assert.txt >> $final_fail_name_intent_not_met\_delta

cd -
echo >> $final_fail_name_intent_not_met\_delta
echo "*****************************************************************************************************" >> $final_fail_name_intent_not_met\_delta
echo >> $final_fail_name_intent_not_met\_delta
num2=`expr $num2 + 1`
done
sed -i '/Errors from logfile/d' $final_fail_name_intent_not_met\_delta
sed -i '/# acerun.log/d' $final_fail_name_intent_not_met\_delta
sed -i '/Line Number: Line/d' $final_fail_name_intent_not_met\_delta
sed -i '/Errors from logfile/d' $final_fail_name_intent_not_met\_delta
cp -rf $final_file_name_intent_not_met\_delta failed_delta.txt
echo >> failed_delta.txt
cat $final_fail_name_intent_not_met\_delta | uniq >> failed_delta.txt
echo "MAYUR
