interface aes_if;

	/*inputs*/
	logic [7:0] in_key_byte;
	logic [7:0] in_state_byte;
	logic sig_clock;
	logic sig_rst;
	logic sig_enable;
	/* outputs */
	logic [7:0] out_state_byte;
	logic sig_load,sig_ready;

endinterface: aes_if
