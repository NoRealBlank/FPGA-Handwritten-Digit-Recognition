`timescale 1ns / 1ps

module ram_1w2r(
    input clk,
    input rst,
    input wena,
    input [9:0] addr_w,
    input [7:0] data_in,
    input [9:0] addr_r1,
    output reg [7:0] data_out1,
    input [9:0] addr_r2,
    output reg [7:0] data_out2
    );
    
    reg [7:0] pic[0:783];
    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            data_out1 <= 0;
            data_out2 <= 0;
            end
        else begin
            if (wena)
                pic[addr_w] <= data_in;
            else begin
                data_out1 <= pic[addr_r1];
                data_out2 <= pic[addr_r2];
                end
            end
        end
    
endmodule
