// Author: Tasdiq Ameem


module part1 (SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);	
	input [17:0] SW;
	input [2:0] KEY; // keys
	output [6:0] HEX0; // 7-seg displays
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;

	wire [2:0] wire_one, wire_two, wire_three, wire_four, wire_five, wire_six;

	// Instantiating 6 multiplexers that would output wires for HEX displays
	// Inverting KEY here.
	// mux_3bit6to1 one (3'b000, 3'b001, 3'b010, 3'b011, 3'b100, 3'b101, ~KEY, wire_one );
	// mux_3bit6to1 two (3'b001, 3'b010, 3'b011, 3'b100, 3'b101, 3'b000, ~KEY, wire_two );	
	// mux_3bit6to1 three (3'b010, 3'b011, 3'b100, 3'b101, 3'b000, 3'b001, ~KEY, wire_three );
	// mux_3bit6to1 four (3'b011, 3'b100, 3'b101, 3'b000, 3'b001, 3'b010, ~KEY, wire_four );
	// mux_3bit6to1 five (3'b100, 3'b101, 3'b000, 3'b001, 3'b010, 3'b001, ~KEY, wire_five );
	// mux_3bit6to1 six (3'b101, 3'b000, 3'b001, 3'b010, 3'b001, 3'b101, ~KEY, wire_six );


	mux_3bit6to1 one 	(SW[17:15], SW[14:12], SW[11:9], SW[8:6], SW[5:3], SW[2:0], ~KEY, wire_one);
	mux_3bit6to1 two 	(SW[14:12], SW[11:9], SW[8:6], SW[5:3], SW[2:0], SW[17:15], ~KEY, wire_two);
	mux_3bit6to1 three 	(SW[11:9], SW[8:6], SW[5:3], SW[2:0], SW[17:15], SW[14:12], ~KEY, wire_three);
	mux_3bit6to1 four 	(SW[8:6], SW[5:3], SW[2:0], SW[17:15], SW[14:12], SW[11:9], ~KEY, wire_four);
	mux_3bit6to1 five 	(SW[5:3], SW[2:0], SW[17:15], SW[14:12], SW[11:9], SW[8:6], ~KEY, wire_five);
	mux_3bit6to1 six 	(SW[2:0], SW[17:15], SW[14:12], SW[11:9], SW[8:6], SW[5:3], ~KEY, wire_six);



	//
	seven_seg_display display_1 (wire_one , HEX5);
	seven_seg_display display_2 (wire_two , HEX4);
	seven_seg_display display_3 (wire_three , HEX3);
	seven_seg_display display_4 (wire_four , HEX2);
	seven_seg_display display_5 (wire_five , HEX1);	
	seven_seg_display display_6 (wire_six , HEX0);
	
endmodule


// implements a 3-bit wide 6-to-1 multiplexer
module mux_3bit6to1  ( U,V,W,X,Y,Z, key, M);
	input [2:0] U, V,W,X,Y,Z ;
	input [2:0] key; // s2, s1, s0
	output reg [2:0] M;

	always@(*)
	begin
		case(key)
			3'b000: M = U;
			3'b001: M = V;
			3'b010: M = W;
			3'b011: M = X;
			3'b100: M = Y;
			3'b101: M = Z;
			default: M = 3'b111;
		endcase
	end
endmodule 

module seven_seg_display (C, display);
	input [2:0] C;
	output reg [6:0] display;

	always@(*)
	begin
		case(C)
			3'b000: display = 7'b1000111;
			3'b001: display = 7'b0000110;
			3'b010: display = 7'b0001000;
			3'b011: display = 7'b0001110;
			3'b100: display = 7'b0000010;
			3'b101: display = 7'b0011000;
			default: display = 7'b1111111;
		endcase
	end
endmodule

////////////////////////////////////////////////////////////////////
// part 2 below:
module part2(SW, LEDR, LEDG);
	// LEDG for S 0-3 and Cout
	// SW7-4 for A and SW3-0 for B
	// SW8 for Cin
	// USE ANOTHER MODULE FOR ADDITION 
	
	input [8:0] SW;
	output [8:0] LEDR;
	output [4:0] LEDG;
	wire C1, C2, C3;
	
	assign LEDR = SW;
	
	fullAdder FA1(SW[4], SW[0], SW[8], LEDG[0], C1);
	fullAdder FA2(SW[5], SW[1], C1, LEDG[1], C2);
	fullAdder FA3(SW[6], SW[2], C2, LEDG[2], C3);
	fullAdder FA4(SW[7], SW[3], C3, LEDG[3], LEDG[4]);
	
	
endmodule 

module mux2to1 (x, y, s, f);
	input x, y, s;
	output f;
	
	assign f=(~s & x) | (s & y);
endmodule


module fullAdder (A, B, Cin, S, Cout);
	
	input A, B, Cin;
	output S, Cout;
	wire aXORb; 
	
	assign aXORb = A ^ B;
	assign S = Cin ^ aXORb;
	mux2to1 asdf (B, Cin, aXORb, Cout);
		
endmodule 


//////////////////////////////////
// part 3 below:
module part3 (SW, LEDR);
	input [4:1] SW;
	output LEDR[0];

	assign LEDR[0] = SW[2] & SW[4] | SW[1] & ~SW[2] & ~SW[3] | ~SW[1] & ~SW[2] & SW[3] ;
endmodule


//////////////////////////////////
// part 4 below:
module part4 (SW, KEY, LEDR);

	input [15:0] SW;
	input [2:0] KEY;
	output [7:0] LEDR;
	
	// SW[15:8] = A[7:0]
	// SW[7:0]  = B[7:0]
	
	reg [7:0]LEDR;
	integer i;
	integer j;
	// Use a wire to invert KEY
	always@(KEY or SW)
	begin
		case(KEY)
			3'b000: LEDR = ~SW[15:8] ^ SW[7:0];
			3'b001: LEDR = SW[15:8] ^ ~SW[7:0];
			3'b010: LEDR =  ~(SW[15:8] & SW[7:0]);
			3'b011: LEDR = SW[15:8] & SW[7:0];
			3'b100: LEDR = SW[15:8] + SW[7:0] + 8'b00000001;
			3'b101: LEDR = ~(SW[15:8] ^ SW[7:0]);
			3'b110: begin
						LEDR = 8'b00000000;
						for(i= 8; i<16; i= i+1)
							LEDR = LEDR + {~SW[i]};	// {} converts 1bit 1/0 to 8bit 1/0
					end
			3'b111: begin
						LEDR = 8'b00000000;
						for(i = 0; i < 8; i = i + 1 )		
							LEDR = LEDR + {SW[i]};	// {} converts 1bit 1/0 to 8bit 1/0
						for(j= 8; j<16; j= j+1)
							LEDR = LEDR + {~SW[j]};	// {} converts 1bit 1/0 to 8bit 1/0
					end
			default: LEDR = 8'b00000000;
		endcase
	end
endmodule 

