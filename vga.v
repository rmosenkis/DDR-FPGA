`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2022 02:26:35 PM
// Design Name: 
// Module Name: vga
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`include "hvsync_generator.v"

/*
A simple test pattern using the hvsync_generator module.
*/

module vga(

  input clk, reset,	// clock and reset signals (input)
  input [1:0] direction_wire,
  input vga_on,
  output hsync, vsync,	// H/V sync signals (output)
  output [2:0] rgb	// RGB output (BGR order)
  );
  wire display_on;	// display_on signal
  wire [9:0] hpos;	// 9-bit horizontal position
  wire [9:0] vpos;	// 9-bit vertical position
  

  // Include the H-V Sync Generator module and
  // wire it to inputs, outputs, and wires.
  hvsync_generator hvsync_gen(
    .clk(clk),
    .reset(0),
    .hsync(hsync),
    .vsync(vsync),
    .display_on(display_on),
    .hpos(hpos),
    .vpos(vpos)
  );

  // Assign each color bit to individual wires.
  
  reg r, g, b;
  reg [1:0] direction;
  assign direction_wire = direction;
  always @(*) begin
    r = 0; g = 0; b = 0;
    //Left
    if(direction == 2'b10) begin
    	if(hpos >= 50 && hpos <= 180 && vpos <= 140 && vpos >= 110)
  		r = display_on;
    	if(hpos >= 80 && hpos <= 90 && vpos <= 170 && vpos >= 80)
  		r = display_on;
    	if(hpos >= 70 && hpos <= 80 && vpos <= 160 && vpos >= 90)
  		r = display_on;
    	if(hpos >= 60 && hpos <= 70 && vpos <= 150 && vpos >= 100)
  		r = display_on;
    	if(hpos >= 40 && hpos <= 50 && vpos <= 130 && vpos >= 120)
  		r = display_on;
  		if(vga_on == 1 && hpos >= 200 && hpos <= 250 && vpos <= 250 && vpos >= 200)
        	g = display_on;
  		
    end
    // Right
    if(direction == 2'b01) begin
      	if(hpos >= 50 && hpos <= 200 && vpos <= 140 && vpos >= 110)
  		g = display_on;
    	if(hpos >= 160 && hpos <= 170 && vpos <= 170 && vpos >= 80)
  		g = display_on;
    	if(hpos >= 170 && hpos <= 180 && vpos <= 160 && vpos >= 90)
  		g = display_on;
    	if(hpos >= 180 && hpos <= 190 && vpos <= 150 && vpos >= 100)
  		g = display_on;
    	if(hpos >= 200 && hpos <= 210 && vpos <= 130 && vpos >= 120)
  		g = display_on;
  		if(vga_on == 1 && hpos >= 200 && hpos <= 250 && vpos <= 250 && vpos >= 200)
        	g = display_on;
    end
    // Up
    if(direction == 2'b00) begin
    	if(vpos >= 50 && vpos <= 180 && hpos <= 140 && hpos >= 110)
  		b = display_on;
    	if(vpos >= 80 && vpos <= 90 && hpos <= 170 && hpos >= 80)
  		b = display_on;
    	if(vpos >= 70 && vpos <= 80 && hpos <= 160 && hpos >= 90)
  		b = display_on;
    	if(vpos >= 60 && vpos <= 70 && hpos <= 150 && hpos >= 100)
  		b = display_on;
    	if(vpos >= 40 && vpos <= 50 && hpos <= 130 && hpos >= 120)
  		b = display_on;
  		if(vga_on == 1 && hpos >= 200 && hpos <= 250 && vpos <= 250 && vpos >= 200)
        	g = display_on;
    end
    //Down
    if(direction == 2'b11) begin   
        if(vpos >= 70 && vpos <= 200 && hpos <= 140 && hpos >= 110) begin
  		b = display_on;
      		g = display_on;
          	r = display_on;
        end
        if(vpos >= 160 && vpos <= 170 && hpos <= 170 && hpos >= 80) begin
  		b = display_on;
      		g = display_on;
          	r = display_on;
        end
  		
        if(vpos >= 170 && vpos <= 180 && hpos <= 160 && hpos >= 90) begin
  		b = display_on;
      		g = display_on;
          	r = display_on;
        end
        if(vpos >= 180 && vpos <= 190 && hpos <= 150 && hpos >= 100) begin
  		b = display_on;
      		g = display_on;
          	r = display_on;
        end
        if(vpos >= 200 && vpos <= 210 && hpos <= 130 && hpos >= 120) begin
  		b = display_on;
      		g = display_on;
          	r = display_on;
        end
        if(vga_on == 1 && hpos >= 200 && hpos <= 250 && vpos <= 250 && vpos >= 200)
        	g = display_on;
    end
  end
  
  // Concatenation operator merges the red, green, and blue signals
  // into a single 3-bit vector, which is assigned to the 'rgb'
  // output. The IDE expects this value in BGR order.
  assign rgb = {b,g,r};

endmodule
