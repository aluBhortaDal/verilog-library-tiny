/*
Author: Tasdiq Ameem

  */

 /* 
   _0	
 5| |1		6_
 4|_|2
	3
________________________________________________
0 1 2 3 4 5 6 7 8 9 A b C d E F
  _			 _		_				 _
 | |	|	 _|		_|		|_|		|_
 |_|	|	|_		_|		  |		 _|

  _  	_		 _		 _			 _
 |_		 |		|_|		|_|	  		|_|
 |_| 	 |		|_|		 _|			| |

		 _				 _		 _
|_		|		 _|		|_		|_
|_|		|_		|_|		|_		|

*/


// IMPORTANT:
// IF YOUR 7 SEG DECODER IS INVERTED, JUST PUT A NOT ON THE WHOLE OUTPUT
// FOR BEHAVIOURAL LOGIC, FLIP THE OUTPUT STATE
module binary_to_hex_7segDecoder (num, hex_decoder);
	input [3:0] num;			// 4 bit binary number
	output [6:0] hex_decoder;	// to display a single digit of hex number

	assign hex_decoder[0] = (num[0]&num[2]) | (num[0]&(~num[3])) | ((~num[0])&(~num[2])&num[3]) | (num[1]&num[2]&(~num[3])) | ((~num[1])&(~num[2])) | ((~num[1])&num[3]);
	assign hex_decoder[1] = (num[0]&num[1]&num[3]) | (num[0]&num[2]) | ((~num[0])&num[1]&(~num[3])) | ((~num[0])&(~num[1])&num[3]) | (num[2]&num[3]);
	assign hex_decoder[2] = ((~num[0])&num[1]) | ((~num[0])&num[2]) | (num[1]&num[2]) | (num[2]&(~num[3])) | ((~num[2])&num[3]);
	assign hex_decoder[3] = (num[0]&(~num[1])&(~num[2])) | (num[0]&num[2]&num[3]) | ((~num[0])&(~num[1])&num[2]) | ((~num[0])&(~num[2])&num[3]) | (num[1]&(~num[3]));
	assign hex_decoder[4] = (num[0]&(~num[1])) | (num[0]&num[2]) | ((~num[1])&(~num[3])) | ((~num[2])&(~num[3]));
	assign hex_decoder[5] = (num[0]&num[1]) | (num[0]&(~num[2])) | (num[1]&(~num[2])&num[3]) | ((~num[1])&(~num[3])) | (num[2]&(~num[3]));
	assign hex_decoder[6] = (num[0]&(~num[1])) | ((~num[0])&num[2]) | ((~num[0])&(~num[3])) | (num[1]&(~num[2])&num[3]) | (num[2]&(~num[3]));
endmodule 


module binary_to_hex_7segDecoder_BEHAVIOURAL (num, hex_decoder);
	input [3:0] num;				// 4 bit binary number
	output reg [6:0] hex_decoder;	// to display a single digit of hex number
	always @(*) begin
		case(num)
		begin
			4'b0000: hex_decoder = 7'b0111111;	// 0
			4'b0001: hex_decoder = 7'b0000110;	// 1
			4'b0010: hex_decoder = 7'b1011011;	// 2
			4'b0011: hex_decoder = 7'b1001111;	// 3
			4'b0100: hex_decoder = 7'b1100110;	// 4
			4'b0101: hex_decoder = 7'b1101101;	// 5
			4'b0110: hex_decoder = 7'b1111101;	// 6
			4'b0111: hex_decoder = 7'b0000111;	// 7
			4'b1000: hex_decoder = 7'b1111111;	// 8
			4'b1001: hex_decoder = 7'b1101111;	// 9
			4'b1010: hex_decoder = 7'b1110111;	// A
			4'b1011: hex_decoder = 7'b1111100;	// b
			4'b1100: hex_decoder = 7'b1111001;	// C
			4'b1101: hex_decoder = 7'b1011110;	// d
			4'b1110: hex_decoder = 7'b1111001;	// E
			4'b1111: hex_decoder = 7'b1110001;	// F
			default: hex_decoder = 7'b0000000;	// lights off
		end
	end	
endmodule