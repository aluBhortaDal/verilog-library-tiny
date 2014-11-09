module part1b();
	input [17:0] SW;
	input [3:0] KEY;
	output [6:0] HEX0;
	output jj;

	parameter X_size = 8;
	parameter Y_size = 7;

	wire [X_size-1 :0] X;
	wire [Y_size-1 :0] Y;
	wire [2:0] colour;
	wire wr_enablen;
	assign X[X_size-1 :0] = SW[X_size-1 :0];
	assign Y[Y_size-1 :0] = SW[Y_size + X_size-1 :X_size];
	assign colour[2:0] = SW[17:0]; 
	assign wr_enablen = KEY[0];

	




endmodule 