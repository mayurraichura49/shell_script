#!/bin/sh
wru=`whoami`
list_name=`pwd | sed 's%\/% %g' | awk '{print $NF}'`
model_name=`pwd | sed 's%\/% %g' | awk '{print $(NF-3)}'`
user_name=`pwd | sed 's%\/% %g' | awk '{print $5}'`
file_name=$user_name\_$model_name\_$list_name
final_file_name_intent_met_assert=satisfied_assert.txt
final_file_name_intent_not_met_assert=$file_name\_failed_assert.txt
final_file_name_intent_met_uniq=satisfied_uniq.txt
final_file_name_intent_not_met_uniq=$file_name\_failed_uniq.txt
lsti_fail_name=$file_name\_lsti_fail.txt

if [[ -f $final_file_name_intent_met_assert ]] 
then
rm -rf $final_file_name_intent_met_assert
fi

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

zgrep -il "sprsp_temp -> Satisfied" */postsim.log.gz | xargs zgrep -i "failed at" >> $final_file_name_intent_met_assert
zgrep -il "sprsp_temp -> Satisfied" */external*/postsim.log.gz | xargs zgrep -i "failed at" >> $final_file_name_intent_met_assert
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

zgrep -il "sprsp_temp -> Fail" */postsim.log.gz | xargs zgrep -i "failed at" >> $final_file_name_intent_not_met_assert
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
cp -rf $final_file_name_intent_met_uniq\_delta assertion_delta.txt
cp -rf $final_file_name_intent_met_uniq uniq_assertions.txt

if [[ -f satisfied_uniq_assertion_with_seed.txt ]] 
then
rm -rf satisfied_uniq_assertion_with_seed.txt 
fi

exec 3< uniq_assertions.txt 
while read 0<&3 line; do
echo $line >> satisfied_uniq_assertion_with_seed.txt
assert_name=`echo $line | sed 's/\./ /g' | awk '{print $NF}'`
#echo $assert_name
zgrep -il "sprsp_temp -> Satisfied" */postsim.log.gz */external*/postsim.log.gz | xargs zgrep -l "$assert_name.*failed at"  >> satisfied_uniq_assertion_with_seed.txt 
echo >> satisfied_uniq_assertion_with_seed.txt
done
