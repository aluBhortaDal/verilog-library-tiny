// Verilog for part 1 below 
module part1 (SW, LEDR);
	input [17:0] SW;	// toggle switches
	output [17:0] LEDR; // red LEDs
	assign LEDR = SW;
endmodule

///////////////////////////////

// Verilog for part 2 below:
module part2 (SW, LEDR );
	input [16:0] SW;
	output [7:0] LEDR;

	mux gotThis(SW[7:0], SW[15:8], s, LEDR[7:0]);
endmodule

module mux(x,y,s,m);
	input [7:0]	x, y; 
	input s;
	output [7:0] m;

	assign m[0] = ( s & ~x[0] & ~y[0]) | (~s & x[0]) ;
	assign m[1] = ( s & ~x[1] & ~y[1]) | (~s & x[1]) ;
	assign m[2] = ( s & ~x[2] & ~y[2]) | (~s & x[2]) ;
	assign m[3] = ( s & ~x[3] & ~y[3]) | (~s & x[3]) ;
	assign m[4] = ( s & ~x[4] & ~y[4]) | (~s & x[4]) ;
	assign m[5] = ( s & ~x[5] & ~y[5]) | (~s & x[5]) ;
	assign m[6] = ( s & ~x[6] & ~y[6]) | (~s & x[6]) ;
	assign m[7] = ( s & ~x[7] & ~y[7]) | (~s & x[7]) ;
	// m = (~s & x) | (s & ~(x | y))
endmodule

/////////////////////

// Verilog for part 3 below:
module part3(SW, KEY, LEDR, LEDG);
	input [17:0] SW;
	input [2:0] KEY; // s2, s1, s0
	output [17:0] LEDR;
	output reg [2:0] LEDG;
	assign  LEDR = SW;

	always@(*)
	begin
		case(KEY)
			3'b000: LEDG = SW[17:15];
			3'b001: LEDG = SW[14:12];
			3'b010: LEDG = SW[11:9];
			3'b011: LEDG = SW[8:6];
			3'b100: LEDG = SW[5:3];
			3'b101: LEDG = SW[2:0];
			default: LEDG = 'b000;
		endcase
	end

	// 17-15:u
	// 14-12:v
	// 11- 9:w
	//  8- 6:x
	//  5- 3:y
	//  2- 0:z
endmodule

// ALTERNATIVE:
module part3(SW, KEY, LEDR, LEDG);
	input [17:0] SW;
	input [2:0] KEY; // s2, s1, s0
	output [17:0] LEDR;
	output wire  [2:0] LEDG;
	assign  LEDR = SW;

	wire [2:0] uv, wx, yz, uvwx;
	// 17-15:u
	// 14-12:v
	// 11- 9:w
	//  8- 6:x
	//  5- 3:y
	//  2- 0:z

	3bit_mux2to1 mux1(SW[17:15],SW[14:12],KEY[0],uv);
	3bit_mux2to1 mux2(SW[11:9],SW[8:6],KEY[0],wx);
	3bit_mux2to1 mux3(SW[5:3],SW[2:0],KEY[0],yz);
	3bit_mux2to1 mux4(uv,wx,KEY[1],uvwx);
	3bit_mux2to1 mux5(uvwx,yz,KEY[2],LEDG);

endmodule

module 3bit_mux2to1(p,q,s,m)
	input [2:0] p,q;
	input s;
	output [2:0] r;

	bitwise_mux2to1 mux1(p[0],q[0],s,m[0]);
	bitwise_mux2to1 mux2(p[1],q[1],s,m[1]);
	bitwise_mux2to1 mux3(p[2],q[2],s,m[2]);
endmodule

module bitwise_mux2to1(a,b,s,m);
	input a,b;
	input s;
	output m;
	// s=0 -> a, s=1 ->b
	assign m = (~s & a) | (s & b);
endmodule

//////////////////////////
// Verilog for part 4 below:

module part4 (SW, HEX0);
	input [2:0] SW;
	output [6:0] HEX0;

	seven_seg_decoder gotThis([2:0]SW, HEX0);
endmodule

module seven_seg_decoder(input [2:0]c, output [6:0]z);
	assign z[0] = ~c[2] & ~c[1] ; 
	assign z[1] = ~c[2] & c[1] & ~c[0] | c[2] & ~c[1] & c[0]; 
	assign z[2] = c[2] & ~c[1]; 
	assign z[3] = ~c[1] & (~c[2] | ~c[0]); 
	assign z[4] = ~c[2] | ~c[1] & ~c[0]; 
	assign z[5] = ~c[2] | ~c[1] & ~c[0]; 
	assign z[6] = c[2] & ~c[1] & ~c[0] | ~c[2] & c[1] | ~c[2] & c[0]; 
endmodule
////////////////////////////////////

// Verilog for part 5 below
module part5 (SW, KEY, LEDR, LEDG, HEX0);
	input [17:0] SW;
	input [2:0] KEY; // s2, s1, s0
	output [17:0] LEDR;
	output wire reg [2:0] LEDG;
	assign  LEDR = SW;
	output [6:0] HEX0;

	always@(*)
	begin
		case(KEY)
			3'b001: LEDG = SW[17:15];
			3'b001: LEDG = SW[14:12];
			3'b010: LEDG = SW[11:9];
			3'b011: LEDG = SW[8:6];
			3'b100: LEDG = SW[5:3];
			3'b101: LEDG = SW[2:0];
			default: LEDG = 'b000;
		endcase
	end
	seven_seg_decoder gotThis([2:0]LEDG, HEX0);
endmodule

module seven_seg_decoder(input [2:0]c, output [6:0]z);
	assign z[0] = ~c[2] & ~c[1] | ~c[1] & c[0]; 
	assign z[1] = ~c[2] & c[1] & ~c[0] | c[2] & ~c[1] & c[0]; 
	assign z[2] = c[2] & ~c[1] | ~c[2] & c[1] & ~c[0]; 
	assign z[3] = ~c[1] & (~c[2] | ~c[0]); 
	assign z[4] = ~c[2] | ~c[1] & ~c[0]; 
	assign z[5] = ~c[2] | ~c[1] & ~c[0]; 
	assign z[6] = c[2] & ~c[1] & ~c[0] | ~c[2] & c[1] | ~c[2] & c[0]; 
endmodule