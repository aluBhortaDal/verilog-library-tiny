// Etch-and-sketch

module sketch
	(
		CLOCK_50,						//	On Board 50 MHz
		KEY,							//	Push Button[3:0]
		SW,								//	DPDT Switch[17:0]
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK,						//	VGA BLANK
		VGA_SYNC,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,   						//	VGA Blue[9:0]
		HEX4, HEX5, HEX6, HEX7
	);
	
	parameter WIDTH = 8'd6;
	parameter HEIGHT = 7'd6;
	parameter HALF_HEIGHT = 7'd3;
	
	

	input			CLOCK_50;				//	50 MHz
	input	[3:0]	KEY;					//	Button[3:0]
	input	[17:0]	SW;						//	Switches[0:0]
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK;				//	VGA BLANK
	output			VGA_SYNC;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	output [6:0] HEX4, HEX5, HEX6, HEX7;
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the color, x, y and writeEn wires that are inputs to the controller.

	wire [2:0] color;
	wire [2:0] complement;
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
	wire [7:0] xCounter;
	wire [6:0] yCounter;
	wire [7:0] xActual;
	wire [6:0] yActual;	
	
	reg [7:0] xa;
	reg [6:0] ya;	
//	assign xa = x + WIDTH;
	
	
	assign x[7 :0] = SW[7 :0];
	assign y[6:0] = SW[14 :8];
	assign color[2:0] = SW[17:15]; 
	assign complement[2:0] = ~SW[17:15]; 
//	assign plot = ~KEY[1];
	
	
	always@(posedge CLOCK_50)
	begin
		xa <= xCounter;
		ya <= yCounter;
	end 
	assign writeEn = ~KEY[2] || (~KEY[1] && (xa >= x) && (xa < (x+WIDTH)) && (ya >= y) && (ya < (y+HEIGHT)));
	
	
	pos_select ps(xa, ya, xCounter, yCounter, KEY[2], xActual, yActual);
	colour_select kk (color, (yCounter < (y + HALF_HEIGHT)), colour, KEY[2]);
	binary_to_hex_7segDecoder x1 (SW[3:0], HEX6);
	binary_to_hex_7segDecoder x2 (SW[7:4], HEX7);
	binary_to_hex_7segDecoder y1 (SW[11:8], HEX4);
	binary_to_hex_7segDecoder y2 (SW[14:12], HEX5);

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(xActual),
			.y(yActual),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK),
			.VGA_SYNC(VGA_SYNC),
			.VGA_CLK(VGA_CLK),
			.xCounter(xCounter),
			.yCounter(yCounter));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "display.mif";
			
	// Put your code here. Your code should produce signals x,y,color and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
	
	
	
endmodule 

module pos_select(xa, ya, xCounter, yCounter, resetn, xActual, yActual);
	input [7:0] xa, xCounter;
	input [6:0] ya, yCounter; 
	input resetn; 
	
	output reg [7:0] xActual;
	output reg [6:0] yActual; 
	
	always@(*) begin 
		if (resetn) begin 
			xActual <= xa;
			yActual <= ya;
		end 
		else begin 
			xActual <= xCounter;
			yActual <= yCounter;
		end 
	end
endmodule 



module colour_select(user_given, is_bottom, colour, resetn);
	input [2:0] user_given;
	input is_bottom;
	input resetn ;
	output reg[2:0] colour;
	always@(*)begin
		if (!resetn)
			colour <= 3'b000;
		else if(is_bottom)
			colour <= ~user_given;
		else 
			colour <= user_given;
	end 
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