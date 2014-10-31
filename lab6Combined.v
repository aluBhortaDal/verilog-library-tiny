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

assign LEDG[0] = pres[6] | pres[5];


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


module enable_counter(clk, resetn, opcode, m);
	input clk, resetn;
	input [2:0] opcode;
	output reg [4:0] length; 

	parameter length_A = 5'd19;
	parameter length_B = 5'd19;
	parameter length_C = 5'd19;
	parameter length_D = 5'd19;
	parameter length_E = 5'd19;
	parameter length_F = 5'd19;
	parameter length_G = 5'd19;

	always @(posedge clk or posedge resetn) begin
		if (!resetn) begin
			// reset
			length <= 5'b0;
		end
		else begin
			case(opcode)
				3'b000: length <= length_A;
				3'b001: length <= length_B;
				3'b010: length <= length_C;
				3'b011: length <= length_D;
				3'b100: length <= length_E;
				3'b101: length <= length_F;
				3'b110: length <= length_G;
				3'b111: length <= length_F;
			endcase 
		end
	end




endmodule 


module fsm_stuff(clk, resetn, enable, dash, outs, ready);
	input clk, resetn, enable, dash;
	output outs, ready;

	parameter state_A = 7'b0000001;
	parameter state_B = 7'b0000010;
	parameter state_C = 7'b0000100;
	parameter state_D = 7'b0001000;
	parameter state_E = 7'b0010000;
	parameter state_F = 7'b0100000;
	parameter state_G = 7'b1000000;

	reg [6:0] present_state;	
	reg [6:0] next_state;

	assign  outs = present_state[3] | present_state[4] | present_state[5] | present_state[6];
	assign ready = present_state[0] & enable;

	always @(posedge clk) begin
		if (!resetn) 
			present_state <= state_A;			
		else 
			present_state <= next_state;

		case(present_state)
			state_A:
				begin
					if (!enable)
						next_state <= state_A;
					else if (dash)
						next_state <= state_E;
					else 
						next_state <= state_D;
				end
			state_B:
					next_state <= state_A;
			state_C:
					next_state <= state_B;
			state_D:
					next_state <= state_C;
			state_E:
					next_state <= state_F;
			state_F:
					next_state <= state_G;
			state_G:
					next_state <= state_C;
			default: 
				next_state <= state_A;
		endcase 
	end
endmodule 
