if [file exists "work"] {vdel -all}
vlib work


# SystemVerilog DUT
vlog dut/r_con.v
vlog dut/s_box.v
vlog dut/subBytes.v
vlog dut/singleKeyExpansion.v
vlog dut/AddRoundKey.v
vlog dut/MixColumns.v
vlog dut/ShiftRows.v
vlog dut/AES_Encrypt_top.v

#uvm top module and packages 
vlog aes_pkg.sv
vlog aes_if.sv
vlog aes_tb_top.sv


vsim  -coverage -t 1ns -novopt work.aes_tb_top +UVM_TESTNAME=aes_test

set NoQuitOnFinish 1
onbreak {resume}
log /* -r

run -a

quit -sim
#vsim top_optimized -coverage +UVM_TESTNAME=random_test
#set NoQuitOnFinish 1
#onbreak {resume}
#log /* -r
#run -all








