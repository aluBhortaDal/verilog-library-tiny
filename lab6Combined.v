// Author: Tasdiq Ameem


// PART 1 BELOW:
module part1 ();
	input [17:0] SW;
	// SW1 is 


	parameter 
				state_A = 7'b0000001,
				state_B = 7'b0000010,
				state_C = 7'b0000100,
				state_D = 7'b0001000,
				state_E = 7'b0010000,
				state_F = 7'b0100000,
				state_G = 7'b1000000;


	reg [6:0] present_state;
	reg [6:0] next_state;



endmodule 


module D_flipflop(D, clk, resetn, Q);
	parameter n = 8;
	input [n-1:0] D;
	input clk, resetn;
	output reg [n-1:0] Q;
	// synchronouse reset, active low
	always@(posedge clk)
//always@(posedge clk or negedge resetn) // for async 
	begin
		if (!resetn)
			Q <= 0;
		else
			Q <= D;
	end 
endmodule 
