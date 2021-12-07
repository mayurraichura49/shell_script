#!/bin/sh
wru=`whoami`
list_name=`pwd | sed 's%\/% %g' | awk '{print $NF}'`
model_name=`pwd | sed 's%\/% %g' | awk '{print $(NF-3)}'`
user_name=`pwd | sed 's%\/% %g' | awk '{print $5}'`
file_name=$user_name\_$model_name\_$list_name
final_file_name_intent_met_assert=failed_assert.txt
final_file_name_intent_not_met_assert=$file_name\_failed_assert.txt
final_file_name_intent_met_uniq=failed_uniq.txt
final_file_name_intent_not_met_uniq=$file_name\_failed_uniq.txt
lsti_fail_name=$file_name\_lsti_fail.txt

zgrep -il "sprsp_temp -> fail" */postsim.log.gz */external*/postsim.log.gz > failseeds.txt
sed -i 's/\/postsim.log.gz//g' failseeds.txt

if [[ -f $final_file_name_intent_met_assert ]] 
then
rm -rf $final_file_name_intent_met_assert
fi

exec 3< failseeds.txt 
while read 0<&3 line; do
cd $line
time=`lsti | grep FAIL | awk '{print $4 }'`
cd -
zgrep -il "sprsp_temp -> fail" $line/postsim.log.gz | xargs zgrep -i "failed at" > failassert 
#cat failassert | wc -l 
#grep $time failassert
grep -v $time failassert > fa
sed -i '/$time/d' failassert
#cat failassert | wc -l 
#cat fa | wc -l 
#echo $time
#cat failassert >> $final_file_name_intent_met_assert
cat fa >> $final_file_name_intent_met_assert
done

if [[ -f $final_file_name_intent_met_uniq ]] 
then
cp -rf $final_file_name_intent_met_uniq $final_file_name_intent_met_uniq\_old
fi

if [[ -f $final_file_name_intent_not_met_assert ]] 
then
rm -rf $final_file_name_intent_not_met_assert
fi

if [[ -f $final_file_name_intent_not_met_uniq ]] 
then
cp -rf  $final_file_name_intent_not_met_uniq $final_file_name_intent_not_met_uniq\_old 
fi

###MAYU zgrep -il "sprsp_temp -> fail" */postsim.log.gz | xargs zgrep -i "failed at" >> $final_file_name_intent_met_assert
###MAYU zgrep -il "sprsp_temp -> fail" */external*/postsim.log.gz | xargs zgrep -i "failed at" >> $final_file_name_intent_met_assert
sed -i 's/.*soc_tb/soc_tb/g' $final_file_name_intent_met_assert
sed -i 's/: .*fs//g' $final_file_name_intent_met_assert
cp -rf $final_file_name_intent_met_assert $final_file_name_intent_met_assert\_complete
#sed -i 's/mcddr_mee_c\d_r\d_d0/mcddr_mee_c\.\*_r\.\*_d0/g' $final_file_name_intent_met_assert
sed -i 's/mcddr_mee_c\([0-9]\+\)_r\([0-9]\+\)_d0/mcddr_mee_c\.\*_r\.\*_d0/g' $final_file_name_intent_met_assert
sed -i 's/soc_tb.soc.sprspxcc_d0.sprmccsouth.*pi5_pi5_c.*_r.*parfblp.fblp_tx_top.lpt.cxp_phy.pm.pmt.TL.*cxpmtl.cxpmosg.TS1DataStable15/soc_tb.soc.sprspxcc_d0.sprmccsouth.*pi5_pi5_c.*_r.*parfblp.fblp_tx_top.lpt.cxp_phy.pm.pmt.TL.*cxpmtl.cxpmosg.TS1DataStable15/g' $final_file_name_intent_met_assert
sed -i 's/soc_tb.soc.sprspxcc_d0.sprmccnorth.*pi5_pi5_.*parfblp.fblp_tx_top.lpt.cxp_phy.pm.pmt.TL.*cxpmtl.cxpmosg.TS1DataStable15/soc_tb.soc.sprspxcc_d0.sprmccnorth4.pi5_pi5_c.*_r.*parfblp.fblp_tx_top.lpt.cxp_phy.pm.pmt.TL.*cxpmtl.cxpmosg.TS1DataStable15/' $final_file_name_intent_met_assert

sed -i 's/memddr_c\([0-9]\+\)_r\([0-9]\+\)_d0/memddr_c\.\*_r\.\*_d0/g' $final_file_name_intent_met_assert
sed -i 's/msprmcddr\([0-9]\+\)/msprmcddr\.\*/g' $final_file_name_intent_met_assert
sed -i 's/port\([0-9]\+\)/port\.\*/g' $final_file_name_intent_met_assert
#sed -i 's/sprtile.*llch.cha_pldp.cbegradd_pktizers/sprtile\.\*llch.cha_pldp.cbegradd_pktizers/g' $final_file_name_intent_met_assert
sed -i 's/sprtile\([0-9]\+\)/sprtile\.\*/g' $final_file_name_intent_met_assert
sed -i 's/i_iclt_.*mswt_mode/i_iclt_\.\*mswt_mode/g' $final_file_name_intent_met_assert
sed -i 's/LOOP_CBO_SRL_PIPE_MCA_CONFIG0.*R_Cbo_MisMatch_CBO_SRL_PIPE_MCA_CONFIG0/LOOP_CBO_SRL_PIPE_MCA_CONFIG0\[\.\*\].R_Cbo_MisMatch_CBO_SRL_PIPE_MCA_CONFIG0/g' $final_file_name_intent_met_assert
sed -i 's/i\([0-9]\+\)_dqbuf/i\.\*_dqbuf/g' $final_file_name_intent_met_assert
sed -i 's/i\([0-9]\+\)_ddrda_x4/i\.\*_ddrdax4/g' $final_file_name_intent_met_assert
sed -i 's/\.\*\./\.\*/g' $final_file_name_intent_met_assert
sed -i 's/mcddr_mee.mcchanddr.*parmc2lmddr/mcddr_mee.mcchanddr.*parmc2lmddr/g' $final_file_name_intent_met_assert
sed -i 's/scf_iocoh_c\([0-9]\+\)_r\([0-9]\+\)_d\([0-9]\+\)/scf_iocoh_c\.\*_r\.\*_d\.\*/g' $final_file_name_intent_met_assert
sort -u $final_file_name_intent_met_assert > $final_file_name_intent_met_uniq
sort -u $final_file_name_intent_met_assert\_complete > $final_file_name_intent_met_uniq\_complete

zgrep -il "sprsp_temp -> Fail" */postsim.log.gz */external*/postsim.log.gz | xargs zgrep -i "failed at" >> $final_file_name_intent_not_met_assert
sed -i 's/.*soc_tb/soc_tb/g' $final_file_name_intent_not_met_assert
sed -i 's/: .*fs//g' $final_file_name_intent_not_met_assert
sort -u $final_file_name_intent_not_met_assert > $final_file_name_intent_not_met_uniq

###MAYUR    cp -rf $final_file_name_intent_met_uniq . 
###MAYUR    cp -rf $final_file_name_intent_met_uniq\_complete . 
###MAYUR    cp -rf $final_file_name_intent_not_met_uniq .

cat $final_file_name_intent_met_uniq\_old > $final_file_name_intent_met_uniq\_new_temp
cat $final_file_name_intent_met_uniq >> $final_file_name_intent_met_uniq\_new_temp

sort $final_file_name_intent_met_uniq\_new_temp > $final_file_name_intent_met_uniq\_new_temp1
uniq -u $final_file_name_intent_met_uniq\_new_temp1 
uniq -u $final_file_name_intent_met_uniq\_new_temp1 > $final_file_name_intent_met_uniq\_delta
rm -rf $final_file_name_intent_met_uniq\_new_temp1
rm -rf $final_file_name_intent_met_uniq\_new_temp
cp -rf $final_file_name_intent_met_uniq\_delta fail_assertion_delta.txt
cp -rf $final_file_name_intent_met_uniq fail_uniq_assertions.txt
cp -rf fail_uniq_assertions.txt fua
sed -i 's/\./ /g' fua 
awk '{print $NF}' fua > fail_uniq_temp
sort -u fail_uniq_temp > fail_uniq


if [[ -f fail_uniq_assertion_with_seed.txt ]] 
then
rm -rf fail_uniq_assertion_with_seed.txt
fi

exec 3< fail_uniq 
while read 0<&3 line; do
echo $line >> fail_uniq_assertion_with_seed.txt
zgrep -il "sprsp_temp -> Fail" */postsim.log.gz */external*/postsim.log.gz | xargs zgrep -l "$line.*failed at" >> fail_uniq_assertion_with_seed.txt
echo >> fail_uniq_assertion_with_seed.txt
done
