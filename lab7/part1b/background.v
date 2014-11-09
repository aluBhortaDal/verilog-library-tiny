// Background image display

module background
	(
		KEY,
		CLOCK_50,						//	On Board 50 MHz
		SW,							//	Push Button[0:0]
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK,						//	VGA BLANK
		VGA_SYNC,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,	  						//	VGA Blue[9:0]
		HEX4, HEX5, HEX6, HEX7
	);

	input	CLOCK_50;				//	50 MHz
	input	[3:0] KEY;				//	Button[0:0]
	input	[17:0] SW;				//	Button[0:0]
	output	VGA_CLK;   				//	VGA Clock
	output	VGA_HS;					//	VGA H_SYNC
	output	VGA_VS;					//	VGA V_SYNC
	output	VGA_BLANK;				//	VGA BLANK
	output	VGA_SYNC;				//	VGA SYNC
	output	[9:0] VGA_R;   			//	VGA Red[9:0]
	output	[9:0] VGA_G;	 		//	VGA Green[9:0]
	output	[9:0] VGA_B;   			//	VGA Blue[9:0]
	output	[6:0]  HEX4, HEX5, HEX6, HEX7;
	
	wire resetn, plot;
	wire [2:0] color;
	wire [7:0] x;
	wire [6:0] y;

	assign resetn = KEY[0];
	assign x[7 :0] = SW[7 :0];
	assign y[6:0] = SW[14 :8];
	assign color[2:0] = SW[17:15]; 
	assign plot = ~KEY[1];

	wire clk;
	bitwise_mux2to1 jj(CLOCK_50, KEY[2], SW[6], clk);
	
	binary_to_hex_7segDecoder x1 (SW[3:0], HEX6);
	binary_to_hex_7segDecoder x2 (SW[7:4], HEX7);
	binary_to_hex_7segDecoder y1 (SW[11:8], HEX4);
	binary_to_hex_7segDecoder y2 (SW[14:12], HEX5);
	

	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(KEY[0]),
			.clock(CLOCK_50),
			.colour(SW[17:15]),
			.x(x),
			.y(y),
			.plot(~KEY[1]),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK),
			.VGA_SYNC(VGA_SYNC),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "display.mif";
		
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

module bitwise_mux2to1(a,b,s,m);
	input a,b;
	input s;
	output m;
	// s=0 -> a, s=1 ->b
	assign m = (~s & a) | (s & b);
endmodule

module pixelPos_iterator(vga_clock, resetn, xCounter_clear, yCounter_clear, xCounter, yCounter);
	//--- Timing parameters.
	/* Recall that the VGA specification requires a few more rows and columns are drawn
	 * when refreshing the screen than are actually present on the screen. This is necessary to
	 * generate the vertical and the horizontal syncronization signals. If you wish to use a
	 * display mode other than 640x480 you will need to modify the parameters below as well
	 * as change the frequency of the clock driving the monitor (VGA_CLK).
	 */
	parameter C_VERT_NUM_PIXELS  = 10'd480;
	parameter C_VERT_SYNC_START  = 10'd493;
	parameter C_VERT_SYNC_END    = 10'd494; //(C_VERT_SYNC_START + 2 - 1); 
	parameter C_VERT_TOTAL_COUNT = 10'd525;

	parameter C_HORZ_NUM_PIXELS  = 10'd640;
	parameter C_HORZ_SYNC_START  = 10'd659;
	parameter C_HORZ_SYNC_END    = 10'd754; //(C_HORZ_SYNC_START + 96 - 1); 
	parameter C_HORZ_TOTAL_COUNT = 10'd800;	
		


	input vga_clock, resetn;	// vga clock in 25MHz
	output xCounter_clear, yCounter_clear;
	output reg [9:0] xCounter, yCounter;


/* A counter to scan through a horizontal line. */
	always @(posedge vga_clock or negedge resetn)
	begin
		if (!resetn)
			xCounter <= 10'd0;
		else if (xCounter_clear)
			xCounter <= 10'd0;
		else
		begin
			xCounter <= xCounter + 1'b1;
		end
	end
	assign xCounter_clear = (xCounter == (C_HORZ_TOTAL_COUNT-1));

	/* A counter to scan vertically, indicating the row currently being drawn. */
	always @(posedge vga_clock or negedge resetn)
	begin
		if (!resetn)
			yCounter <= 10'd0;
		else if (xCounter_clear && yCounter_clear)
			yCounter <= 10'd0;
		else if (xCounter_clear)		//Increment when x counter resets
			yCounter <= yCounter + 1'b1;
	end
	assign yCounter_clear = (yCounter == (C_VERT_TOTAL_COUNT-1)); 

endmodule 
