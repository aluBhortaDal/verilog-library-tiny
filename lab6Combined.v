// Author: Tasdiq Ameem


// PART 1 BELOW:
module part1 (SW, KEY, LEDR, LEDG);
	input [17:0] SW;
	input [3:0] KEY; // CLOCK
	// SW0 = ACTIVE LOW SYNC RESETN 
	// SW1 = W;
	output [6:0] LEDR;
	output [7:0] LEDG;

	wire [6:0] pres_state;
	wire [6:0] next_state;
	
//	parallelLoad_flipflop ff (next_state[6:0], KEY[0], SW[0], pres_state[6:0]);

	assign next_state[0] = (pres_state[0] | pres_state[1] | pres_state[4] | pres_state[6]) & ~SW[1];
	assign next_state[1] = (pres_state[0] ) & SW[1];
	assign next_state[2] = (pres_state[1]  | pres_state[6]) & SW[1];
	assign next_state[3] = (pres_state[4] ) & SW[1];
	assign next_state[4] = (pres_state[2] | pres_state[3] | pres_state[5]) & ~SW[1];
	assign next_state[5] = (pres_state[3] | pres_state[5] ) & SW[1];
	assign next_state[6] = (pres_state[4] ) & SW[1];

	assign LEDR[6:0] = SW[6:0];
//	assign LEDG[0] = pres_state[6];

	parallelLoad_flipflop ff (next_state[6:0], KEY[0], SW[0], pres_state[6:0]);
	
endmodule 


module parallelLoad_flipflop(D, clk, resetn, Q);
	input [6:0] D;
	input clk;
	input resetn;
	output reg [6:0] Q;

	always@(posedge clk)
	begin
		if (!resetn)
			Q <= 7'b0;
		else
			Q <= D;
	end 
endmodule 


