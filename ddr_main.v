`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2022 04:38:25 PM
// Design Name: 
// Module Name: ddr_main
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


module ddr_main(
    input clk,
    input data,
    input reset,
    output latch, nes_clk,
    input [3:0] sw,
    output reg [15:0] led,
    output reg [3:0] an,
    output reg [6:0] seg,
    output [3:0] vgaRed,
    output [3:0] vgaBlue,
    output [3:0] vgaGreen,
    output hsync,
    output vsync
    );
    
wire up, down, left, right, start, select, A, B;
reg [24:0] counter;  
reg [24:0] slower_counter;
reg clkout;
reg slow_clkout;
reg [24:0] slower_counter_max;
reg [24:0] led_counter;
reg [24:0] led_counter_max;
reg [1:0] q;
reg [3:0] qlong = 0000;
reg feedback;
reg [1:0] prev_state;
reg [7:0] score;
reg [6:0] seg_dir;
reg [6:0] seg_num0;
reg [6:0] seg_num1;
reg [24:0] led_counter_min, slower_counter_min;
wire [2:0] rgb;
reg vga_on;

initial begin
    counter = 50000;
    slower_counter = 0;
    slower_counter_max = 600;
    led_counter = 600;
    led_counter_max = 1201;
    clkout = 0;
    slow_clkout = 0;
    an = 4'b0001;
end

// NES CONTROLLER MODULE
ddr_nes controller (.clk(clk), .reset(reset), .data(data), .latch(latch), .nes_clk(nes_clk),
			.A(A), .B(B), .select(select), .start(start), .up(up), .down(down), .left(left), .right(right));

// VGA OUTPUT CODE
reg vga_clk_reg, vga_temp;
wire vga_clk;
assign vga_clk = vga_clk_reg;
always @(posedge clk) begin
    vga_temp <= ~vga_temp;
end
always @(posedge vga_temp) begin
    vga_clk_reg <= ~vga_clk_reg;
end

vga display_out (.clk(vga_clk), .reset(reset), .direction_wire(q), .hsync(hsync), .vsync(vsync), .rgb(rgb), .vga_on(vga_on));
assign vgaRed = {4{rgb[0]}};
assign vgaBlue = {4{rgb[1]}};
assign vgaGreen = {4{rgb[2]}};

// Counter for clock out (60Hz) and directional case statement assignment for 7-seg display
always @(posedge clk) begin
    if (counter == 0) begin
        counter <= 50000;
        clkout <= ~clkout;
    end else begin
        counter <= counter - 1;
    end
// Determine which direction is selected based on sudorandom bits
    case(q)
        2'b00 : seg_dir = 7'b1111110;
        2'b01 : seg_dir = 7'b1111001;
        2'b10 : seg_dir = 7'b1001111;
        2'b11 : seg_dir = 7'b1110111;
    endcase
end

reg [19:0] clkdiv;
wire [1:0] active_LED;
assign active_LED = clkdiv[19:18];

// 7-Segment display refresh block, output either digit or direction or nothing for each display
always @(*)begin
    case(active_LED)
    0: begin
        an = 4'b0111;
        seg = seg_num1;
        end
    1: begin         
        an = 4'b1011;
        seg = seg_num0;
        end
    2: begin
        an = 4'b1111;
        seg = seg_dir;
        end
    3: begin
        an = 4'b1110;
        seg = seg_dir;
        end
    endcase
 end

// Clock for the 7-Segment Display code above, ~60Hz
always @(posedge clk) begin
    clkdiv <= clkdiv + 1;
end

// DIFFICULTY SELECTION ALWAYS BLOCK
always @(*) begin
    case (sw)
        0 : begin 
            slower_counter_min = 0;
            led_counter_min = 0;    
            end
        1 : begin 
            slower_counter_min = 150;
            led_counter_min = 300;      
            end
        2 : begin 
            slower_counter_min = 300;
            led_counter_min = 600;     
            end
        3 : begin 
            slower_counter_min = 450;
            led_counter_min = 900;
            end
        default : begin 
            slower_counter_min = 0;
            led_counter_min = 0;
            end
    endcase
end
            


// CLOCKS FOR LED BAR AND NEXT MOVE. ALSO CASE STATEMENT FOR LED BAR
always @(posedge clkout) begin
    if (slower_counter == slower_counter_max) begin
        slower_counter <= slower_counter_min;
        slow_clkout <= ~slow_clkout;
    end else begin
        slower_counter <= slower_counter + 1;
    end
    
    if(led_counter == led_counter_max)
        led_counter <= led_counter_min;
    else begin
        led_counter <= led_counter + 1;
    end
     
    case(led_counter)
        1 : begin
            led = 16'b0000000000000001; 
            vga_on = 0;
        end
        80 : led = 16'b0000000000000010; 
        160 : led = 16'b0000000000000100; 
        240 : led = 16'b0000000000001000; 
        320 : begin
            led = 16'b0000000000010000; 
            vga_on = 0;
        end
        400 : led = 16'b0000000000100000; 
        480 : led = 16'b0000000001000000; 
        560 : led = 16'b0000000010000000; 
        640 : begin
            led = 16'b0000000100000000; 
            vga_on = 0;
        end
        720 : led = 16'b0000001000000000; 
        800 : led = 16'b0000010000000000; 
        880 : led = 16'b0000100000000000; 
        960 : begin
            led = 16'b0001000000000000; 
            vga_on = 0;
        end
        1040 : begin
            led = 16'b0010000000000000; 
            vga_on = 1;
        end
        1120 : led = 16'b0100000000000000; 
        1200 : led = 16'b1000000000000000; 
     endcase
end

// Digits for 7-segment. Turns score into a 2-digit number
always @(score)
    begin

    case (score % 10) //case statement
        0 : seg_num0 = 7'b1000000;
        1 : seg_num0 = 7'b1111001;
        2 : seg_num0 = 7'b0100100;
        3 : seg_num0 = 7'b0110000;
        4 : seg_num0 = 7'b0011001;
        5 : seg_num0 = 7'b0010010;
        6 : seg_num0 = 7'b0000010;
        7 : seg_num0 = 7'b1111000;
        8 : seg_num0 = 7'b0000000;
        9 : seg_num0 = 7'b0010000;
        //switch off 7 segment character when the bcd digit is not a decimal number.
        default : seg_num0 = 7'b1111111; 
    endcase
    
   case (score / 10) //case statement
        0 : seg_num1 = 7'b1000000;
        1 : seg_num1 = 7'b1111001;
        2 : seg_num1 = 7'b0100100;
        3 : seg_num1 = 7'b0110000;
        4 : seg_num1 = 7'b0011001;
        5 : seg_num1 = 7'b0010010;
        6 : seg_num1 = 7'b0000010;
        7 : seg_num1 = 7'b1111000;
        8 : seg_num1 = 7'b0000000;
        9 : seg_num1 = 7'b0010000;
        //switch off 7 segment character when the bcd digit is not a decimal number.
        default : seg_num1 = 7'b1111111; 
    endcase
end

// ALWAYS BLOCK FOR GENERATING NEXT MOVE, AND INCREMENTING SCORE
always @(posedge slow_clkout) begin
    prev_state = q;
    feedback = ~{qlong[3] ^ qlong[2]};
    qlong = {qlong[2:0], feedback};
    q = qlong[3:2];
    if (prev_state == 2'b00 && up == 1)
        score = score + 1;
    if (prev_state == 2'b01 && right == 1)
        score = score + 1;
    if (prev_state == 2'b10 && left == 1)
        score = score + 1;
    if (prev_state == 2'b11 && down == 1)
        score = score + 1;
    if (score == 100)
        score = 0;
end

endmodule
