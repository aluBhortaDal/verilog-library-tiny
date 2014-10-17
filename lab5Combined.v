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
//		else 
//			Q = Q;	
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
module part3 (SW, KEY, CLOCK_50);
	input [17:0] SW;
	input CLOCK_50;
	input [3:0] KEY; // debug code 

// SHIT

endmodule 


// TO DO
module counter_actual ();
	input clk;

	reg [3:0] num;	// wire to 7seg decoder
	
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