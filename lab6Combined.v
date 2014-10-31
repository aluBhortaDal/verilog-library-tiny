module part1(SW, KEY, LEDR, LEDG);
	input [17:0] SW;
	input [3:0] KEY; // CLOCK
	// SW0 = ACTIVE LOW SYNC RESETN 
	// SW1 = W;
	output [17:0] LEDR;
	output [7:0] LEDG;

	wire [6:0] pres_state;
	wire [6:0] next_state;
	
	
//	assign LEDR [16:10] = next_state[6:0];
	

	subCircuit jj(pres_state, SW[1], next_state);
	parallelLoad_flipflop ff(next_state[6:0], KEY[0], SW[0], pres_state[6:0]);
	
	
	assign LEDR[6:0] = pres_state[6:0];
	assign LEDG[0] = pres_state[6];
endmodule 


module subCircuit(pres, W, m );

	input [6:0] pres;
	input W;
	output [6:0]m;

	assign m[0] = (pres[0] | pres[1] | pres[4] | pres[6]) & ~W;
	assign m[1] = (pres[0] ) & W;
	assign m[2] = (pres[1]  | pres[6]) & W;
	assign m[3] = (pres[4] ) & W;
	assign m[4] = (pres[2] | pres[3] | pres[5]) & ~W;
	assign m[5] = (pres[3] | pres[5] ) & W;
	assign m[6] = (pres[4] ) & W;
endmodule 


module parallelLoad_flipflop(D, clk, resetn, Q);
	input [6:0] D;
	input clk;
	input 	resetn;
	output reg [6:0] Q;

	always@(posedge clk)
	begin
		if (!resetn)
			Q[0] <= 1;
		else
			Q[6:0] <= D[6:0];
	end 
endmodule 


