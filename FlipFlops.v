

module D_flipflop(D, clk, resetn, Q);
	parameter n = 8;
	input [n-1:0] D;
	input clk, resetn;
	output reg [n-1:0] Q;
	// synchronouse reset, active low
	always@(posedge clk)
//always@(posedge clk or negedge resetn) // for async 
	begin
		if (!resetn)
			Q <= 0;
		else
			Q <= D;
	end 
endmodule 