module rippleCarryAdder(a, b, carry_in, total_sum);

	input [n:0] a;
	input [n:0] b;
	input carry_in;				// initial input
	output [n+1:0] total_sum;

	wire carry_out;
	wire carry_wire;				// Cin for each FA except first one.
	assign  total_sum[n+1] = carry_out;

	bitwise_fullAdder FA0 (a[0], b[0], carry_in,  )



endmodule

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
	mux2to1(B, Cin, aXORb, Cout);		
endmodule 

