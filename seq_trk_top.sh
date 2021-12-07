#!/bin/sh
PWD=`pwd`
rm -rf seq_trk.txt
#touch seq_trk.txt
result=$PWD\/seq_trk.txt
echo "MAYUR" >> $result
echo >> $result

num=1
exec 2< list
while read 0<&2 line; do
cd ${line}
echo "$num ${line}" >> $result
#if [[ -f seq_start ]] 
#then
rm -rf seq_end seq_start* seq_trk
#fi

echo "${line}"
zgrep -i "SEQ_TRACK" acerun.log.gz > seq_trk
cp -rf seq_trk seq_trk_original
#sed -i 's/OVM_INFO.*\[SEQ_TRACKER/\[SEQ_TRACKER/g' seq_trk
sed -i 's/OVM_INFO.*\]//g' seq_trk
sed -i 's/\[.*\]//g' seq_trk
sed -i 's/.*\]//g' seq_trk
sed -i 's/^ //g' seq_trk
#sed -i 's/\[.*\]//g' seq_trk
sed -i 's/<EOM>//g' seq_trk
grep "begin\|enabled\|start \|Launching" seq_trk >> seq_start
#grep "Launching" seq_trk >> seq_start
grep "end\|done\|Completed" seq_trk >> seq_end
#grep "Completed" seq_trk >> seq_end
sed -i '/Launching uncore_pm_seq_inst/d' seq_start
sed -i '/uncore_random_top_mixer/d' seq_start
sed -i '/uncore_random_top_mixer/d' seq_end
sed -i 's/UNCORE //g' seq_start
sed -i 's/Uncore //g' seq_start
sed -i '/pm_fabricgv_basic_allflavors_vseq/d' seq_start
sed -i 's/ begin//g' seq_start
sed -i 's/:body//g' seq_start
sed -i 's/body//g' seq_start
sed -i 's/ is enabled//g' seq_start
sed -i 's/ start//g' seq_start
sed -i '/FLASH SAFE POOL/d' seq_end
sed -i 's/^ //g' seq_start
sed -i 's/^ //g' seq_end
sed -i 's/ end//g' seq_end
sed -i 's/ done//g' seq_end
sed -i 's/CROSS_DOMAIN_SEQ_TRACKER: Launching //g' seq_start
sed -i 's/CROSS_DOMAIN_SEQ_TRACKER: Completed //g' seq_end
sed -i 's/Launching //g' seq_start
sed -i 's/Completed //g' seq_end
#sed -i '' seq_end

sed -i 's/ //g' seq_start
cp seq_start seq_start_copy
exec 3< seq_start
while read 0<&3 line; do
#echo "${line} Mayur"
var=`echo ${line} | awk '{print $1}'`
#echo $var
if [ `grep -c "${line}" seq_end` != 0 ]
then
sed -i "0,/${line}/{//d;}" seq_start_copy
fi
sed -i "0,/${line}/{//d;}" seq_end
#sed -i '0,/$var/{//d;}' seq_end
#sed -i "s/${line}/MAYUR/g" seq_end
#sed -i 's/$var//g' seq_start_copy
#sed -i '/$var/d' seq_start_copy
#sed -i '0,/$var/{//d;}' seq_start_copy
#line_no=`grep -m 1 -n $var seq_end | sed 's/:/ /g' | awk '{print $1}'`
#sed -i '{$line_no}d' seq_end
#echo "$line_no"
done
#fi
cat seq_start_copy
cat seq_start_copy >> $result

if [ `cat seq_end | wc -l ` != 0 ]
then
echo "Info in seq_end is" >> $result
cat seq_end >> $result
fi
echo >> $result 
cd -
num=`expr $num + 1`
done
#sed -i '0,/uncore_cross_domain_mixer/{//d;}' seq_end
