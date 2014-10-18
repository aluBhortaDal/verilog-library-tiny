/*
 *	Author: Tasdiq Ameem
 *
 *	Please keep timing delays in mind!
 */


// This module produces an actual clock 
// with 50% duty cycle :)
// Use it as you would use the default clck.
module frequency_divider(clk,rst,clk_out) // debug code: , counter);
	input clk,rst;
	// clk is the original clk
	output reg clk_out;	// desired clk 

	// factor = original frequency / (2 x desired frequency) - 1
	parameter factor = 28'd24999; 
	// keep factor bitsize divisible by 4, just in case you want hex
	// bitsize = n + n mod 4   ....n + remainder of n/4
	
	parameter n = 25; // #of bits required to hold factor
						// be exact here, no less and no more

	reg [n-1:0]counter;
// output reg [n-1:0]counter;	// debug code 

	always @(posedge clk)
	begin
		if(rst)	begin 		// synchronous reset
			counter <= 28'd0;	// see comment at factor
//			counter <= 12'd24990;  // debug code
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



// This module's duty cycle varies. 
// Always use negedge of this clock 
// otherwise your clock will mess up
module frequency_divider_special(clk,rst,clk_out) // debug code: , counter);
	input clk,rst;
	// clk is the original clk
	output clk_out;	// desired clk 

	// factor = original frequency / desired frequency 
	parameter factor = 28'd49999; 
	// keep factor bitsize divisible by 4, just in case you want hex
	// bitsize = n + n mod 4   ....n + remainder of n/4
	
	parameter n = 26; // #of bits required to hold factor
						// be exact here, no less and no more

	reg [n-1:0]counter;
// output reg [n-1:0]counter;	// debug code 

	always @(posedge clk)	
	begin
		if(rst)				// synchronous reset
			counter <= 28'd0;	// see comment at factor
//			counter <= 28'd49980;  // debug code
		else if(counter==factor)
			counter <= 28'd0;
		//	//	//	//
		else
		counter <= counter+1;
	end

	assign clk_out =counter[n-1];	// relays most significant (actual)
									// bit as the new clock
endmodule


