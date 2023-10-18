`timescale 1ns / 1ps

module vga_display(
    input clk_vga,//25.175MHz
    input rst,
    input [7:0] douta,
    output reg [9:0] addra,
    output Hs_valid,
    output Vs_valid,
    output reg [3:0] grey
);
    parameter Hs_before=11'd144;
    parameter Vs_before=11'd35;
    parameter Hs_size_pic=11'd280;
    parameter Vs_size_pic=11'd280;
    
    wire [11:0] Hs_poi;
    wire [11:0] Vs_poi;
    wire is_display;

    vga_control control(clk_vga,rst,Hs_poi,Vs_poi,is_display,Hs_valid,Vs_valid);

    always @(*) begin
        grey <= 0;
        if (is_display && Hs_poi-Hs_before <= Hs_size_pic && Vs_poi-Vs_before <= Vs_size_pic) begin
            addra <= (Vs_poi - Vs_before)/10*28 + (Hs_poi - Hs_before)/10;
            grey <= douta * 10;
            end
        end
        
endmodule
