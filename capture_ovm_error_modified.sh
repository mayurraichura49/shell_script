if [[ -f ovm_error.txt ]] 
then
cp -rf ovm_error.txt ovm_error.txt_old
fi

zgrep -il "sprsp_temp -> Satisfied" */postsim.log.gz | xargs zgrep " OVM_ERROR "  > ovm_error.txt1
zgrep -il "sprsp_temp -> Satisfied" */postsim.log.gz | xargs zgrep " OVM_FATAL "  >> ovm_error.txt1
zgrep -il "sprsp_temp -> Satisfied" */external*/postsim.log.gz | xargs zgrep " OVM_ERROR "  >> ovm_error.txt1
zgrep -il "sprsp_temp -> Satisfied" */external*/postsim.log.gz | xargs zgrep " OVM_FATAL "  >> ovm_error.txt1
sed -i 's/.*postsim.log.gz:\([0-9]\+\): //g' ovm_error.txt1
sed -i 's/.*postsim.log.gz: //g' ovm_error.txt1
sed -i 's/ @ .*ns //g' ovm_error.txt1
sed -i 's/scf_scha_subsystem.*scf_scha_agent.cha0.chaSlaEnv_\([0-9]\+\)_\([0-9]\+\)/scf_scha_subsystem10.scf_scha_agent.cha0.chaSlaEnv_4_3/g' ovm_error.txt1
sed -i 's/Time of MCA:            .* /Time of MCA:            194676676 /g' ovm_error.txt1
sed -i 's/torid=0x.*, CoreID=0x.*, ThreadID=0x.*, with/torid=0x0, CoreID=0x0, ThreadID=0x0, with/g' ovm_error.txt1
sed -i 's/mcddr_mee_subsystem.*mcddr_mee_agent.mc0.mcddr_.*mc_env_.*ddr_bfm_channel.ddr_agen.*dimm_checker.*PIN4 Violated: Command ERR_ACK needs to be sent.*times back to back on SC.*command sent only.*times in the required timeframe/mcddr_mee_subsystem0.mcddr_mee_agent.mc0.mcddr_0_3_mc_env_0.ddr_bfm_channel.ddr_agent0.dimm_checker0) [dimm_checker0] PIN4 Violated: Command ERR_ACK needs to be sent 3 times back to back on SC1. command sent only 1 times in the required timeframe/g' ovm_error.txt1
sed -i 's/ @ \([0-9]\+\) //g' ovm_error.txt1
sed -i 's/^ *//g' ovm_error.txt1
sed -i 's/RTL VALUE=.*, DESIRED=.* /RTL VALUE=000000000000000000, DESIRED=00000000000000000f /g' ovm_error.txt1
sed -i 's/Expected Value is .*, received value is .* /Expected Value is 00000000000000, received value is 00000000000100 /g' ovm_error.txt1
sed -i 's/LRU corrupted for set=.*addr=.*expected.*actual.* /LRU corrupted for set=16f, addr=a0ee14a5bc0, expected 3a00000, actual 2500000 /g' ovm_error.txt1
sed -i 's/pipe.*_msg.DRAM=.*pipe.*_msg.DDRT=.*_msg.OrigCacheState=T_LLC_I, ~pipe.*_msg.ReqIsMS2IAL=.*, pipe.*_msg.FS=.* /pipe8_msg.DRAM=0, pipe8_msg.DDRT=1, pipe8_msg.OrigCacheState=T_LLC_I, ~pipe8_msg.ReqIsMS2IAL=1, pipe8_msg.FS=1 /g' ovm_error.txt1
sed -i 's/Timed out after .* IO reads to IO_MAIN_IOSF_SB_CTL/Timed out after 400 IO reads to IO_MAIN_IOSF_SB_CTL/g' ovm_error.txt1
sed -i 's/mismatch for addr=0x.* /mismatch for addr=0x25eb7e00440 /g' ovm_error.txt1
sed -i 's/scf_scha_subsystem.*scf_scha_agent.ms2idi.*ms2idi_sla_env_.*ral/scf_scha_subsystem18.scf_scha_agent.ms2idi0.ms2idi_sla_env_6_4_0.ral/g' ovm_error.txt1
sed -i 's/Chip select seen during zqlat, cs.* = .* tzqlat start = .* tzqlat end = .*, eval count = .* /Chip select seen during zqlat, cs\[0\] = 0. tzqlat start = 27130, tzqlat end = 27356, eval count = 27219 /g' ovm_error.txt1
sed -i 's/mc0.mcddr_.*_.*_mc_env_1/mc0.mcddr_0_3_mc_env_1/g' ovm_error.txt1
sed -i 's/mcddr_mee_subsystem\([0-9]\+\)/mcddr_mee_subsystem0/g' ovm_error.txt1
sed -i 's/iosf_pri_transactions.svh:\([0-9]\+\)/iosf_pri_transactions.svh:/g' ovm_error.txt1
sed -i 's/mcddr_mee_subsystem.*mcddr_mee_agent.mc.*mcddr_.*_mc_env_.*mc_scoreboard_.*mc_error_log_scoreboard/mcddr_mee_subsystem1.mcddr_mee_agent.mc0.mcddr_0_6_mc_env_0.mc_scoreboard_0.mc_error_log_scoreboard/g' ovm_error.txt1
sed -i 's/scf_scha_subsystem.*scf_scha_agent.ms2idi.*ms2idi_sla_env_.*ms2idiEnv.ms2idi_scoreboard.ms2idi_trans_queue/scf_scha_subsystem5.scf_scha_agent.ms2idi0.ms2idi_sla_env_5_2_0.ms2idiEnv.ms2idi_scoreboard.ms2idi_trans_queue/g' ovm_error.txt1
sed -i 's/checker xpt credit count=.*and RTL xpt credit count.*. /checker xpt credit count=3 and RTL xpt credit count=0. /g' ovm_error.txt1
sed -i 's/^\([0-9]\+\): OVM_ERROR/OVM_ERROR/g' ovm_error.txt1
sed -i 's/^\([0-9]\+\): OVM_FATAL/OVM_FATAL/g' ovm_error.txt1
sed -i 's/out of range.*cha_id=.*must/out of range\. cha_id=111 \(must/g' ovm_error.txt1
sed -i 's/Expected parity=.*, Received parity from mesh_msg=.* for address=.* /Expected parity=0, Received parity from mesh_msg=1 for address=0001c0 /g' ovm_error.txt1
sed -i 's/idi_transactions.svh:.*\[stim_idi_req\] Address picking failed after .* attempts/idi_transactions.svh:1583\[stim_idi_req\] Address picking failed after 40 attempts/' ovm_error.txt1
sed -i 's/Hang Check Exit . Start=.*, Wait=.*, Current=.* /Hang Check Exit . Start=1608058976, Wait=21600, Current=1608882733 /g' ovm_error.txt1
sed -i 's/mcddr_.*_tme_env_0/mcddr_6_6_tme_env_0/g' ovm_error.txt1
sed -i 's/parity.*mismatched expected=0x.* actual=0x.* /parity\[2\] mismatched expected=0x8fa5391e148487eb actual=0x4d323dcb663ef752 /g' ovm_error.txt1
sed -i 's/mcddr_.*_m2mem_env_0.scoreboard/mcddr_0_6_m2mem_env_0.scoreboard/g' ovm_error.txt1
sed -i 's/data.*mismatched expected=0x.* actual=0x.* /data\[2\] mismatched expected=0x8fa5391e148487eb actual=0x4d323dcb663ef752 /g' ovm_error.txt1
sed -i 's/passthrough_single_sequence_test.i_model_env.system.*scf_dummy_chassis.cms.*cmsEnv.cmsAgent.cms_scoreboard/passthrough_single_sequence_test.i_model_env.system0.s0.scf_dummy_subsystem10.scf_dummy_chassis.cms0.cmsSlaEnv_3_7.cmsEnv.cmsAgent.cms_scoreboard/g' ovm_error.txt1
sed -i 's/Address Not Seen: Address=.*hw_addr:/Address Not Seen: Address=0x000000005a4a6a00 .*hw_addr:/g' ovm_error.txt1
sed -i 's/name:"DEST0 Addr=0x.*iosfCmd/name:"DEST0 Addr=0x000000005a4a6a00", iosfCmd/g' ovm_error.txt1 
sed -i 's/\[Addr=0x.*\] \[Length=128\] \[FBE=0xf/\[Addr=0x000000005a4a6000\] \[Length=128\] \[FBE=0xf/g' ovm_error.txt1
sort -u ovm_error.txt1 > ovm_error.txt
cat ovm_error.txt_old > temp_file
cat ovm_error.txt >> temp_file
sort temp_file > temp_file1
uniq -u temp_file1 > ovm_error.txt_delta
cat ovm_error.txt_delta


if [[ -f ovm_error.txt_mod ]] 
then
rm -rf ovm_error.txt_mod 
fi

if [[ -f ovm_error.txt_with_seed ]] 
then
rm -rf ovm_error.txt_with_seed
fi

cp -rf ovm_error.txt ovm_error.txt_mod
sed -i 's/OVM_ERROR .*) //g' ovm_error.txt_mod
sed -i 's/<EOM>//g' ovm_error.txt_mod 
sed -i 's/<.*>/.*/g' ovm_error.txt_mod
sed -i 's/{.*}/.*/g' ovm_error.txt_mod
sed -i 's/\[.*\]/.*/g' ovm_error.txt_mod
sed -i 's/\.\*\.\*/.*/g' ovm_error.txt_mod
#sed -i 's/[[:digit:]]/.*/g' ovm_error.txt_mod
sed -i 's/\([0-9]\+\)/.*/g' ovm_error.txt_mod

#exec 2< ovm_error.txt
line_no=1
exec 3< ovm_error.txt_mod
while read 0<&3 line; do
sed -n "$line_no"p ovm_error.txt >> ovm_error.txt_with_seed
zgrep -l "sprsp_temp -> Satisfied" */postsim.log.gz */external*/postsim.log.gz | xargs zgrep -l "${line}" >> ovm_error.txt_with_seed 
echo >> ovm_error.txt_with_seed
line_no=`expr $line_no + 1`
done
