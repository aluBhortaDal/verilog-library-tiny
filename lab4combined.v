////////////////////////////////////////////////////
// PART 2 BELOW:


// Write a Verilog module for the rotating register with parallel load that instantiates eight instances of your
// Verilog module for Figure 2. This Verilog module should match with the schematic in your lab book. Use
// SW[7:0] as the inputs DATA_IN[7:0]. Use SW[8] as the RotateRight input, SW[9] as the ASRight input and
// SW[10] as the ParallelLoadn input. Use KEY[0] as the clock, but read the important note below about
// switch bouncing. The outputs Q[7:0] should be displayed on the red LEDs (LEDR[7:0])

module part2 (SW, LEDR, KEY);
	input [11:0] SW;
	// 0-7 for DATA_IN[7:0]
	// 8 for RotateRight
	// 9 for ASRright -> LEFT
	// 10 for parallelloadn
	// 11 for ASLeft -> RIGHT
	input [0:0] KEY;
	output [7:0] LEDR;

	subcircuit subC1 (KEY[0], SW[8], SW[10], SW[11], SW[9], SW[0], LEDR[0]);
	subcircuit subC2 (KEY[0], SW[8], SW[10], SW[11], SW[9], SW[1], LEDR[1]);
	subcircuit subC3 (KEY[0], SW[8], SW[10], SW[11], SW[9], SW[2], LEDR[2]);
	subcircuit subC4 (KEY[0], SW[8], SW[10], SW[11], SW[9], SW[3], LEDR[3]);
	subcircuit subC5 (KEY[0], SW[8], SW[10], SW[11], SW[9], SW[4], LEDR[4]);
	subcircuit subC6 (KEY[0], SW[8], SW[10], SW[11], SW[9], SW[5], LEDR[5]);
	subcircuit subC7 (KEY[0], SW[8], SW[10], SW[11], SW[9], SW[6], LEDR[6]);
	subcircuit subC8 (KEY[0], SW[8], SW[10], SW[11], SW[9], SW[7], LEDR[7]);
endmodule

module subcircuit(clk, loadL, loadn, right, left,  D, Q);
	input right, left, loadn, loadL, D, clk;
	output Q;
	wire intermediate, real_D;

	mux2to1 mux1(right, left, loadL, intermediate);
	mux2to1 mux2(D, intermediate, loadn, real_D);

	D_latch latched(clk, real_D, Q);
endmodule

module D_latch(clk, D, Q);
	input clk, D;
	output reg Q;
	always@(posedge clk)
		Q <= D;
endmodule

module mux2to1(a,b,s,m); 
	input a,b; 
	input s; 
	output m; 
	// s=0 -> a, s=1 ->b 
	assign m = (~s & a) | (s & b); 
endmodule 


///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
// PART 3 BELOW:

module part3(SW, KEY, HEX0, HEX1, HEX2, HEX3, LEDR);
	input [11:0] SW;
	input [0:0] KEY;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [17:0] LEDR;

	wire [7:0] alubhorta;
	wire [7:0] B;

	binary_to_hex_7segDecoder Apos1 (A[3:0], HEX0);
	binary_to_hex_7segDecoder Apos2 (A[7:4], HEX1);
	binary_to_hex_7segDecoder Bpos1 (B[3:0], HEX2);
	binary_to_hex_7segDecoder Bpos2 (A[7:4], HEX3);

	D_ff shi_t (alubhorta, KEY[0], SW[11],B);
	alu_balu alubhaji (SW[7:0], B, SW[8:10], alubhorta);
endmodule



module D_ff (D, clock, resetn, Q);
	input [7:0] D;
	input clock, resetn;
	output reg [7:0] Q;
	// synchronouse reset
	always@(posedge clock)
	begin
		if (!resetn)
			Q <= 8'b00000000;
		else
			Q <= D;
	end 
endmodule 


module binary_to_hex_7segDecoder (n, hex_decoder);
	input [3:0] n;			// 4 bit binary number
	output [6:0] hex_decoder;	// to display a single digit of hex number

	assign hex_decoder[0] = ~((n[0] & n[2] & (~n[3])) | ((~n[0]) & (~n[2])) | ((~n[0]) & n[3]) | (n[1] & n[2]) | (n[1] & (~n[3])) | ((~n[1]) & (~n[2]) & n[3]));
	assign hex_decoder[1] = ~((n[0] & n[1] & (~n[3])) | (n[0] & (~n[1]) & n[3]) | ((~n[0]) & (~n[1]) & (~n[3])) | ((~n[0]) & (~n[2])) | ((~n[2]) & (~n[3])));
	assign hex_decoder[2] = ~((n[0] & (~n[1])) | (n[0] & (~n[2])) | ((~n[1]) & (~n[2])) | (n[2] & (~n[3])) | ((~n[2]) & n[3]));
	assign hex_decoder[3] = ~((n[0] & n[1] & (~n[2])) | (n[0] & (~n[1]) & n[2]) | ((~n[0]) & n[1] & n[2]) | ((~n[0]) & (~n[2]) & (~n[3])) | ((~n[1]) & n[3]));
	assign hex_decoder[4] = ~(((~n[0]) & n[1]) | ((~n[0]) & (~n[2])) | (n[1] & n[3]) | (n[2] & n[3]));
	assign hex_decoder[5] = ~(((~n[0]) & (~n[1])) | ((~n[0]) & n[2]) | (n[1] & n[3]) | ((~n[1]) & n[2] & (~n[3])) | ((~n[2]) & n[3]));
	assign hex_decoder[6] = ~((n[0] & (~n[1]) & n[2]) | ((~n[0]) & n[2] & (~n[3])) | (n[1] & (~n[2])) | (n[1] & n[3]) | ((~n[2]) & n[3]));
endmodule 


module alu_balu (A, B, KEY, LEDR);
	//input [15:0] SW;
	input [7:0] A;
	input [7:0] B;
	input [2:0] KEY;
	output [7:0] LEDR;
	
	// SW[15:8] = A[7:0]
	// SW [7:0]  = B[7:0]
	reg [7:0]LEDR;
	integer i;
	integer j;
	// Use a wire to invert KEY
	always@(KEY A or B)
	begin
		case(KEY)
			3'b000: LEDR = ~A[7:0] ^ B[7:0];
			3'b001: LEDR = A[7:0] ^ ~B[7:0];
			3'b010: LEDR =  ~(A[7:0] & B[7:0]);
			3'b011: LEDR = A[7:0] & B[7:0];
			3'b100: LEDR = A[7:0] + B[7:0] + 8'b00000001;
			3'b101: LEDR = ~(A[7:0] ^ B[7:0]);
			3'b110: begin
						LEDR = 8'b00000000;
						for(i= 0; i<8; i= i+1)
							LEDR = LEDR + {~A[i]};	// {} converts 1bit 1/0 to 8bit 1/0
					end
			3'b111: begin
						LEDR = 8'b00000000;
						for(i = 0; i < 8; i = i + 1 )		
							LEDR = LEDR + {B[i]};	// {} converts 1bit 1/0 to 8bit 1/0
						for(j= 0; j<8; j= j+1)
							LEDR = LEDR + {~A[j]};	// {} converts 1bit 1/0 to 8bit 1/0
					end
			default: LEDR = 8'b00000000;
		endcase
	end
endmodule 
