// Animation

module animation
	(	SW, 
		CLOCK_50,						//	On Board 50 MHz
		KEY,							//	Push Button[3:0]
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK,						//	VGA BLANK
		VGA_SYNC,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input	[0:0]	KEY;					//	Button[3:0]
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK;				//	VGA BLANK
	output			VGA_SYNC;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	input [17:0] SW;
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the color, x, y and writeEn wires that are inputs to the controller.

	wire [2:0] colour;
	wire [7:0] xCounter;
	wire [6:0] yCounter;
	wire writeEn;
//	assign color = 3'b111;
	reg [28:0] counter; 
	reg [7:0] xPos;
	reg [6:0] yPos;
	
	reg [7:0] xPrev;
	reg [6:0] yPrev;
	
	wire[7:0] xPassIn;
	wire [6:0] yPassIn;
	
	parameter MOVEx = 8'd1;
	parameter MOVEy = 7'd1;
	wire compute_enable;
	wire do_draw;
	assign compute_enable = counter[22] & counter [23];
	
	always@(posedge CLOCK_50)
	begin 
		if (counter > 28'd12582912) begin 
			counter <= 28'd0;	// computational refresh rate ~= 12.5 MHz
								// nooo :(
		end 
		else 
			counter <= counter + 1;
		
		if (compute_enable) begin 
			xPrev <= xPos;
			yPrev <= yPos;
			
			xPos <= xPos + MOVEx;
			yPos <= yPos + MOVEy;
		end 
		
//		if (do_draw)
//			colour <= 3'b111;
//		else // erase
//			colour <= 3'b000;
	end 
	
	wire draw_ , erase_, plot;
	assign writeEn = SW[2] & plot;
	sate_machine FSM(compute_enable, CLOCK_50, draw_, erase_, plot);
	coordinate_selector CS(CLOCK_50, draw_, erase_, xPrev, yPrev, xPos, yPos, xPassIn, yPassIn);
	colour_select colour_mux(CLOCK_50, draw_, xPrev, yPrev, xCounter, yCounter, colour);

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(xPassIn),
			.y(yPassIn),
			.plot(writeEn),
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
			
	// Put your code here. Your code should produce signals x,y,color and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
	
	
endmodule 

module coordinate_selector(clk, draw_, erase_, xPrev, yPrev, xNow, yNow, xPassIn, yPassIn);
	input [7:0] xPrev, xNow;
	input [6:0] yPrev, yNow;
	input draw_, erase_, clk;
	output reg [7:0] xPassIn;
	output reg [6:0] yPassIn;
	
	always@(posedge clk) begin 
		if (draw_) begin 
			xPassIn <= xNow;
			yPassIn <= yNow;
		end 
		else if (erase_) begin 
			xPassIn <= xPrev;
			yPassIn <= yPrev;
		end 
	end 
endmodule  



module sate_machine(compute_enable, clk_50, draw_, erase_, plot);
	parameter IDLE = 	2'b00;
	parameter DRAW = 	2'b01;
	parameter ERASE = 2'b10;
	
	input compute_enable, clk_50;
	output draw_, erase_, plot;
	reg [2:0] present_state, next_state;
	
	assign plot = (present_state != IDLE);
	assign draw_ = (present_state == DRAW);
	assign erase_ = (present_state == ERASE);
	always@(posedge clk_50) begin 
		case (present_state)
			IDLE: begin 
					if (compute_enable)
						next_state <= ERASE;
					else 
						next_state <= IDLE;
					end 
			DRAW:
				next_state <= IDLE;
			ERASE: 
				next_state <= DRAW;	
			default: 
				next_state <= IDLE;
		endcase
		present_state <= next_state;	
	end 
endmodule 


module colour_select(clk, draw_, xPrev, yPrev, xCounter, yCounter, colour);
	input [7:0] xPrev, xCounter;
	input [6:0] yPrev, yCounter;	
	output reg [2:0] colour;
	input clk, draw_;
	always@(posedge clk)begin 
		if (draw_) 
			colour <= 3'b111;	// DRAW
		else 
			colour <= 3'b000;
	end 
	
endmodule 