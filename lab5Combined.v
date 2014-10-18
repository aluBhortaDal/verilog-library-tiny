// Author: Tasdiq Ameem

// PART 1 BELOW:
module part1 (SW, KEY, HEX0 , HEX1);
	input [1:0] SW; 	// SW[1] for enable, SW[0] for clearN
	input [0:0] KEY;	// clk input
	
	output [7:0] HEX0;
	output [7:0] HEX1;
	
	wire [7:0] number; 	// 0-3 for HEX0, 4-7 for HEX1
	wire [7:0] next;	

	// enclosed part for part2
	//////////////////////////////////////////////////
	count_you_cunt fuck(~KEY[0], number, SW[0]);
	// now implement 7seg decoder
	//////////////////////////////////////////////////

	
	t_flip_flop_with_AND obj0(SW[1],   ~KEY[0], SW[0], number[0], next[0]);
	t_flip_flop_with_AND obj1(next[0], ~KEY[0], SW[0], number[1], next[1]);
	t_flip_flop_with_AND obj2(next[1], ~KEY[0], SW[0], number[2], next[2]);
	t_flip_flop_with_AND obj3(next[2], ~KEY[0], SW[0], number[3], next[3]);
	t_flip_flop_with_AND obj4(next[3], ~KEY[0], SW[0], number[4], next[4]);
	t_flip_flop_with_AND obj5(next[4], ~KEY[0], SW[0], number[5], next[5]);
	t_flip_flop_with_AND obj6(next[5], ~KEY[0], SW[0], number[6], next[6]);
	t_flip_flop_with_AND obj7(next[6], ~KEY[0], SW[0], number[7], next[7]);

	// 7 segment decoders
	binary_to_hex_7segDecoder num0(number[3:0],HEX0);
	binary_to_hex_7segDecoder num1(number[7:4],HEX1);
endmodule

module t_flip_flop_with_AND (T, clk, clearn, Q, and_gate);	
	input T, clk, clearn;
	output reg Q;
	output and_gate;

	assign  and_gate = Q & T ;
	always@(posedge clk)
	begin
		if(~clearn) 
			Q=0;
		else if (T)  
			Q=~Q;
//		else 	Q = Q;	
	end 
endmodule


// enclosed part for part2
//////////////////////////////////////////////////
module count_you_cunt(clk, Q, Resetn);
	input clk, Resetn;
	output reg [7:0] Q;

	always @(posedge clk ) begin
		if (~Resetn)
			// reset
			Q <= 8'b0;

		else 
			Q <= Q + 1;
	end
endmodule 
//////////////////////////////////////////////////

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



// PART 3 BELOW:
module part3 (SW, KEY, CLOCK_50, HEX0);
	input [1:0] SW;
	input CLOCK_50;
	input [2:0] KEY;	// key2 for clock debug
	// key0 clock reset, key1 counter reset
	// ACTIVE HIGH RESETS
	output [6:0] HEX0;

	wire new_clk;
	frequency_divider clock_shit(CLOCK_50, ~KEY[0], SW[1:0], new_clk);
	counter_actual count_up(new_clk, ~KEY[1], HEX0);
endmodule 


module counter_actual (clk, reset, HEX0);
	input clk, reset;
	output HEX0;
	reg [3:0] num;	// wire to 7seg decoder

	// asynchronous reset
	always @(posedge clk or posedge reset) begin
		if (reset)
			num <= 4'b0;
		else 
			num <= num + 1;
	end
	binary_to_hex_7segDecoder got_this(num[3:0], HEX0);	
endmodule 


module frequency_divider(clk,rst, opcode, clk_out); // debug code: , counter);
	input clk,rst;
	input [1:0] opcode;
	// clk is the original clk
	output reg clk_out;	// desired clk 
	parameter n = 28; // #of bitsize of factor and counter
	parameter full_speed = 28'd0;
	parameter oneHz		 = 28'd49999999;
	parameter halfHz	 = 28'd99999999;
	parameter quarterHz	 = 28'd199999999;
	
	reg [n-1:0]factor; 
	// keep factor bitsize divisible by 4, just in case you want hex	
	reg [n-1:0]counter;
// output reg [n-1:0]counter;	// debug code 

	always @(opcode) begin
		case (opcode)
// factor = (original frequency / (2 x desired frequency)) - 1
			2'b00: factor <= full_speed;
			2'b01: factor <= oneHz;
			2'b10: factor <= halfHz;
			2'b11: factor <= quarterHz;
			default: factor <= full_speed;
		endcase 
	end

	always @(posedge clk)
	begin
		if(rst)	begin 		// synchronous reset
			counter <= 28'd0;	// see comment at factor
//			counter <= 28'd24990;  // debug code
			clk_out <= 1'b0;
		end
		else if(counter==factor)begin
			counter <= 28'd0;	// see comment at factor
			clk_out <= ~clk_out;
		end
		//	//	//	//
		else
		counter <= counter+1;
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


///////////////////////////////////////////
// PART4 BELOW:
module part4 (SW, CLOCK_50, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);	
	input [17:0] SW;
	input [0:0] KEY; // clock debug
	input CLOCK_50;
	output [6:0] HEX0; // 7-seg displays
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;

	parameter char_L = 3'b000;
	parameter char_E = 3'b001;
	parameter char_A = 3'b010;
	parameter char_F = 3'b011;
	parameter char_6 = 3'b100;
	parameter char_7 = 3'b101;

	wire [2:0] new_clk, wire_one, wire_two, wire_three, wire_four, wire_five, wire_six;
	wire clock_1Hz;
	reg [2:0] opcode;

	// TO DO
	frequency_divider FIFTYMto1(CLOCK_50, 1'b0, clock_1Hz);

	always @(posedge clock_1Hz) 
	begin
		opcode <= opcode + 1;
	end


	// Instantiating 6 multiplexers that would output wires for HEX displays
	mux_3bit6to1 one 	(char_L, char_E, char_A, char_F, char_6, char_7, opcode, wire_one );
	mux_3bit6to1 two 	(char_E, char_A, char_F, char_6, char_7, char_L, opcode, wire_two );	
	mux_3bit6to1 three 	(char_A, char_F, char_6, char_7, char_L, char_E, opcode, wire_three );
	mux_3bit6to1 four 	(char_F, char_6, char_7, char_L, char_E, char_A, opcode, wire_four );
	mux_3bit6to1 five 	(char_6, char_7, char_L, char_E, char_A, char_E, opcode, wire_five );
	mux_3bit6to1 six 	(char_7, char_L, char_E, char_A, char_E, char_7, opcode, wire_six );

	//	display left to right
	seven_seg_display display_1 (wire_one , HEX5);
	seven_seg_display display_2 (wire_two , HEX4);
	seven_seg_display display_3 (wire_three , HEX3);
	seven_seg_display display_4 (wire_four , HEX2);
	seven_seg_display display_5 (wire_five , HEX1);	
	seven_seg_display display_6 (wire_six , HEX0);
endmodule


module frequency_divider(clk,rst,clk_out); // debug code: , counter);
	input clk,rst;
	// clk is the original clk
	output reg clk_out;	// desired clk 

	// factor = original frequency / (2 x desired frequency) - 1
	parameter factor = 28'd24999999; // 50 MHz --> 1 Hz
	// keep factor bitsize divisible by 4, just in case you want hex
	// bitsize = n + n mod 4   ....n + remainder of n/4
	
	parameter n = 25; // #of bits required to hold factor
						// be exact here, no less and no more
	reg [n-1:0]counter;
	always @(posedge clk)
	begin
		if(rst)	begin 		// synchronous reset
			counter <= 28'd0;	// see comment at factor
			clk_out <= 1'b0;
		end
		else if(counter==factor)begin
			counter <= 28'd0;	// see comment at factor
			clk_out <= ~clk_out;
		end
		//	//	//	//
		else
		counter <= counter+1;
	end
endmodule


// implements a 3-bit wide 6-to-1 multiplexer
module mux_3bit6to1  ( U,V,W,X,Y,Z, opcode, M);
	input [2:0] U, V,W,X,Y,Z ;
	input [2:0] opcode; // s2, s1, s0
	output reg [2:0] M;
	always@(opcode)
	begin
		case(opcode)
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
	always@(C)
	begin
		case(C)
			3'b000: display = 7'b1000111;	// L
			3'b001: display = 7'b0000110;	// E
			3'b010: display = 7'b0001000;	// A
			3'b011: display = 7'b0001110;	// F
			3'b100: display = 7'b0000010;	// 6
			3'b101: display = 7'b1111000;	// 7
			default: display = 7'b1111111;
		endcase
	end
endmodule
