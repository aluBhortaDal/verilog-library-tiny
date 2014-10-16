/*
 *	Author: Tasdiq Ameem
 *
 *	Arithmetic shift: line 11
 *	Logical shift: line 35
 *	Circular shift: line 75
 *
 *
 */

// Arithmetic shift, shifts at posedge clock
// assumes unsigned number 
module arith_shift(clk, P, Q);
// [n:0] for (n+1) bits. Replace n value to suit your code
	input [n:0] P;
	output reg [n:0] Q;
	input clk;

	// shift left 
	always @(posedge clk) begin
		Q  = P <<< m; // replace m with the number of 
					// place you want to shift each time
		Q[m-1:0] = Q [m:1]; // you do the sum :)
	end

	// shift right
	always @(posedge clk) begin
		Q  = $signed(P) >>> m; // replace m with the number of 
					// place you want to shift each time
	end
endmodule 



// Logical shift
// assumes unsigned number
// shifts at clock edge
module logical_shift(clk, P, Q);
// [n:0] for (n+1) bits. Replace n value to suit your code
	input [n:0] P;
	input clk;
	output reg [n:0] Q;

	// shift left
	always @(posedge clk) begin
		Q  = P << m; // replace m with the number of 
					// place you want to shift each time
	end

	// shift right
	always @(posedge clk) begin
		Q  = P >> m; // replace m with the number of 
					// place you want to shift each time
	end
endmodule 

// Alternative, NOT edge triggered:
module logical_shift(P, Q);
// [n:0] for (n+1) bits. Replace n value to suit your code
	input [n:0] P;
	output  [n:0] Q;

	// shift left
	assign Q  = P << m; // replace m with the number of 
					// place you want to shift each time


	// shift right
	assign Q  = P >> m; // replace m with the number of 
					// place you want to shift each time
endmodule



// Circular shift, shifts at posedge clock
// assumes unsigned number
module circular_shift(clk, P, Q);
// [n:0] for (n+1) bits. Replace n value to suit your code
	input [n:0] P;
	input clk;
	output reg [n:0] Q;

	// shift left, rotate right
	always @(posedge clk) begin
		Q <= P << m;// replace m with the number of 
					// place you want to shift each time
		Q[m-1:0] <= P[n:n-m+1];	// you do the sum :)
	end

	// shift right, rotate left
	always @(posedge clk) begin
		Q <= P >> m;// replace m with the number of 
					// place you want to shift each time
		Q[n:n-m+1] <= P[m-1:0]; // you do the sum :)
	end
endmodule 


// Alternative, NOT edge triggered
module circular_shift(P, Q);
// [n:0] for (n+1) bits. Replace n value to suit your code
	input [n:0] P;
	output reg [n:0] Q;

	// shift left, rotate right
	assign Q[n:m] = P[n-m:0];
	assign Q[m-1:0] = P[n:n-m+1] ;

	// shift right, rotate left
	assign Q[n-m:0] = P[n:m];	
	assign Q[n:n-m+1] = P[m-1:0];
endmodule 
