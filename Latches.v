// Author: Tasdiq Ameem ....unless otherwise stated in an individiual block

// Following module is work of Professor Belinda Wang
// Directly copied from lecture notes
module D_latch(D, clk, Q);
	input D, clk;
	output reg Q;
	always @(D, clk)
		if(clk)
			Q=D;
endmodule 

