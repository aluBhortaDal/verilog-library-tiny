module part1(SW, KEY, LEDR, LEDG);
	input [17:0] SW;
	input [3:0] KEY; // CLOCK
	// SW0 = ACTIVE LOW SYNC RESETN 
	// SW1 = W;
	output [17:0] LEDR;
	output [7:0] LEDG;

//	wire [6:0] pres_state;
//	wire [6:0] next_state;

	reg [6:0] pres;
	
	wire [6:0]m ;
//	wire [6:0]uu ;
//	assign uu = pres;
	
	assign LEDR[16:10] = m[6:0];
//	wire a, b, c, d, e, f, g;
		assign LEDR[6:0] = pres[6:0];
//		assign LEDG[0] = m[6];
//	assign LEDG[0] = pres_state[6];
	
//	assign LEDR [16:10] = next_state[6:0];
	assign m[0] = (pres[0] | pres[1] | pres[4] | pres[6]) & ~SW[1];
	assign m[1] = (pres[0] ) & SW[1];
	assign m[2] = (pres[1]  | pres[6]) & SW[1];
	assign m[3] = (pres[2] ) & SW[1];
	assign m[4] = (pres[2] | pres[3] | pres[5]) & ~SW[1];
	assign m[5] = (pres[3] | pres[5] ) & SW[1];
	assign m[6] = (pres[4] ) & SW[1];

assign LEDG[0] = pres[6];


always@(posedge KEY[0]) begin 
	if (!SW[0]) begin 
		pres <= 7'b0000001;	
	end 

	else begin 
		pres <= m;
	end 

end 




//	subCircuit jj(pres_state, SW[1], next_state);
//	parallelLoad_flipflop ff(next_state[6:0], KEY[0], SW[0], pres_state[6:0]);
	
	

endmodule 


module subCircuit(pres, W, m );

	input [6:0] pres;
	input W;
	output [6:0]m;

	assign m[0] = (pres[0] | pres[1] | pres[4] | pres[6]) & ~W;
	assign m[1] = (pres[0] ) & W;
	assign m[2] = (pres[1]  | pres[6]) & W;
	assign m[3] = (pres[2] ) & W;
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
			Q[0] <= 7'b0000001;
		else
			Q[6:0] <= D[6:0];
	end 
endmodule 


















// 
module decode (num, coded);
input [2:0] num;
output reg [13:0] coded;


endmodule 
