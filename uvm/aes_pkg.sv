package aes_pkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;

	`include "aes_sequencer.sv"
	`include "aes_monitor.sv"
	`include "aes_driver.sv"
	`include "aes_agent.sv"
	`include "aes_scoreboard.sv"
	`include "aes_config.sv"
	`include "aes_env.sv"
	`include "aes_test.sv"
endpackage: aes_pkg
