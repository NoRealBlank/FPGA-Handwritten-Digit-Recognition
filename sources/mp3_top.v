`timescale 1ns / 1ps

module mp3_top(
    input clk,
    input rst,
    input valid_in,
    input [3:0] decision,
    input DREQ,
    output xRSET,
    output xCS,
    output xDCS,
    output MOSI,
    output SCLK
    );
     
    reg is_play;
    
    always @(posedge clk or posedge rst) begin
        if(rst)
            is_play <= 0;
        else if(valid_in)
            is_play <= 1;
        end
        
    mp3_driver #(.MUSIC_SIZE(25112)) uut_mp3 (
        .mp3_clk(clk),
        .rst(rst | ~is_play),   
        .decision(decision),           
        .DREQ(DREQ),
        .xRSET(xRSET),
        .xCS(xCS),
        .xDCS(xDCS),
        .MOSI(MOSI),
        .SCLK(SCLK)
        );                                                        
        
endmodule
