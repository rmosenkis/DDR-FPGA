`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2022 07:03:48 PM
// Design Name: 
// Module Name: moveGenerator
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


module moveGenerator(
        input get_move,
        input reset,
        output [1:0] move,
        output end_move
    );
    
    // Create local parameters for what the direction of the current move is
    localparam [1:0] UP = 2'd0,
        DOWN = 2'd1,
        LEFT = 2'd2,
        RIGHT = 2'd3;
    
    reg [3:0] pattern, next_pattern;      // Stores which step of the pattern 
    reg [1:0] next_move;    // UP/DOWN/LEFT/RIGHT current output
    reg end_move_reg;       // set to high when end of pattern reached, signals no more moves remaining
    
    assign move = next_move;
    assign end_move = end_move_reg;
    
    always @(posedge get_move or posedge reset)
        begin
        if (reset) begin
            pattern <= 0;
            next_pattern <= 0;
            next_move <= 0;
            end_move_reg <= 0;
            end
        else begin
            pattern <= next_pattern;
            case (pattern)
                0 : begin
                    next_move = UP;
                    next_pattern = pattern + 1;
                    end_move_reg = 0;
                    end
                1 : begin
                    next_move = DOWN;
                    next_pattern = pattern + 1;
                    end_move_reg = 0;
                    end
                2 : begin
                    next_move = UP;
                    next_pattern = pattern + 1;
                    end_move_reg = 0;
                    end
                3 : begin
                    next_move = RIGHT;
                    next_pattern = pattern + 1;
                    end_move_reg = 0;
                    end
                4 : begin
                    next_move = DOWN;
                    next_pattern = pattern + 1;
                    end_move_reg = 0;
                    end
                5 : begin
                    next_move = UP;
                    next_pattern = pattern + 1;
                    end_move_reg = 0;
                    end
                6 : begin
                    next_move = LEFT;
                    next_pattern = pattern + 1;
                    end_move_reg = 0;
                    end
                7 : begin
                    next_move = RIGHT;
                    next_pattern = pattern + 1;
                    end_move_reg = 0;
                    end
                8 : begin
                    next_move = DOWN;
                    next_pattern = pattern + 1;
                    end_move_reg = 0;
                    end
                9 : begin
                    next_move = LEFT;
                    next_pattern = pattern + 1;
                    end_move_reg = 0;
                    end
                10 : begin
                    next_move = UP;
                    next_pattern = pattern + 1;
                    end_move_reg = 0;
                    end
                11 : begin
                    next_move = RIGHT;
                    next_pattern = pattern + 1;
                    end_move_reg = 0;
                    end
                12 : begin
                    next_move = LEFT;
                    next_pattern = pattern + 1;
                    end_move_reg = 0;
                    end
                13 : begin
                    next_move = DOWN;
                    next_pattern = pattern + 1;
                    end_move_reg = 0;
                    end
                14 : begin
                    next_move = RIGHT;
                    next_pattern = pattern + 1;
                    end_move_reg = 0;
                    end
                15 : begin
                    next_move = LEFT;
                    next_pattern = pattern;
                    end_move_reg = 1;
                    end
                endcase
            end
        end
endmodule
