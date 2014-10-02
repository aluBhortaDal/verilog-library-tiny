// Author: Tasdiq Ameem

/* 
IMPORTANT : READ THE COMMENTS BEFORE YOU IMPLEMENT

The rippleCarryAdder(...) module will alow you to add binary numbers

total_sum  = a + b
where a and b are (n+1) bit binary numbers (0 to nth bit) 
and total sum is (n+2) bit binary number (0 to (n+1)th bit)

If you are not using any carry in with this, you may 
ignore and delete the carry_in input from your code.

Other modules in this file are needed to function the top level 
unlesss otherwise stated. 
*/

module rippleCarryAdder(a, b, carry_in, total_sum);
	// Change the value of n to suite your needs
	input [n:0] a;				// (n+1) bit
	input [n:0] b;				// (n+1) bit
	input carry_in;				// initial carry input, bit
	output [n+1:0] total_sum;	// (n+2) bit, takes care of overflow/carry out


	wire [n:0] carry_wire;				// Cin for each FA except first one.
	assign  total_sum[n+1] = carry_wire[n];

	bitwise_fullAdder FA0 (a[0], b[0], carry_in, total_sum[0], carry_wire[0]);
	bitwise_fullAdder FA1 (a[1], b[1], carry_wire[0], total_sum[1], carry_wire[1]);
	bitwise_fullAdder FA2 (a[2], b[2], carry_wire[1], total_sum[2], carry_wire[2]);
//	.		.		.		.
//	.		.		.		.	Continue till n
//	.		.		.		.
	bitwise_fullAdder FAn (a[n], b[n], carry_wire[n-1], total_sum[n], carry_wire[n]);
endmodule


// You may integrate this into the next module if you want
module mux2to1 (x, y, s, f);
	input x, y, s;
	output f;
	
	assign f=(~s & x) | (s & y);
endmodule


module bitwise_fullAdder (A, B, Cin, S, Cout);
	input A, B, Cin;
	output S, Cout;
	wire aXORb; 					// You can skip this
	assign aXORb = A ^ B;			// step and plug in directly

	assign S = Cin ^ aXORb;
	mux2to1 implement_mux(B, Cin, aXORb, Cout);		
endmodule 

// Hope it helps :)