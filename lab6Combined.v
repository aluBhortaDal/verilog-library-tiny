// Author: Tasdiq Ameem


// PART 1 BELOW:
module part1 (SW, KEY, LEDR, LEDG);
	input [1:0] SW;
	input [0:0] KEY; // CLOCK
	// SW0 = ACTIVE LOW SYNC RESETN 
	// SW1 = W;
	output [6:0] LEDR;
	output [0:0] LEDG;

	wire [6:0] pres_state;
	wire [6:0] next_state;

	assign next_state[0] = (pres_state[0] | pres_state[1] | pres_state[4] | pres_state[6]) & ~SW[1];
	assign next_state[1] = (pres_state[0] ) & SW[1];
	assign next_state[2] = (pres_state[1]  | pres_state[6]) & SW[1];
	assign next_state[3] = (pres_state[4] ) & SW[1];
	assign next_state[4] = (pres_state[2] | pres_state[3] | pres_state[5]) & ~SW[1];
	assign next_state[5] = (pres_state[3] | pres_state[5] ) & SW[1];
	assign next_state[6] = (pres_state[4] ) & SW[1];

	assign LEDR[6:0] = pres_state;
	assign LEDG[0] = pres_state[6];

	seven_parallelLoad_flipflop ff (next_state, KEY[0], SW[0], pres_state);
endmodule 

module seven_parallelLoad_flipflop(D, clk, resetn, Q);
	input [6:0] D;
	input clk, resetn;
	output [6:0] Q;

	D_flipflop ff0(D[0], clk, resetn, Q[0]);
	D_flipflop ff1(D[1], clk, resetn, Q[1]);
	D_flipflop ff2(D[2], clk, resetn, Q[2]);
	D_flipflop ff3(D[3], clk, resetn, Q[3]);
	D_flipflop ff4(D[4], clk, resetn, Q[4]);
	D_flipflop ff5(D[5], clk, resetn, Q[5]);
	D_flipflop ff6(D[6], clk, resetn, Q[6]);
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
