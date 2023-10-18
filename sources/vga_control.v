`timescale 1ns / 1ps

module vga_control(
    input vga_clk,
    input rst,
    output reg[11:0] Hs_poi,
    output reg[11:0] Vs_poi,
    output is_display,
    output Hs_valid,
    output Vs_valid
);
    
    parameter x_sync = 11'd96;
    parameter x_before = 11'd144;
    parameter x_beside_after = 11'd784;
    parameter x_all = 11'd800;
    
    parameter y_sync = 11'd2;
    parameter y_before = 11'd35;
    parameter y_beside_after = 11'd515;
    parameter y_all = 11'd525;
    
    assign is_display = ((Hs_poi >= x_before) && (Hs_poi < x_beside_after) 
                        && (Vs_poi >= y_before) && (Vs_poi < y_beside_after)) ? 1 : 0;
    
    assign Hs_valid = (Hs_poi < x_sync) ? 0 : 1;
    assign Vs_valid = (Vs_poi < y_sync) ? 0 : 1;
    
    always @(posedge vga_clk) begin
        if (rst) begin
            Hs_poi <= 0;
            Vs_poi <= 0;
        end
        else begin
            if (Hs_poi == x_all - 1) begin
                Hs_poi <= 0;
                if (Vs_poi == y_all - 1)
                    Vs_poi <= 0;
                else
                    Vs_poi <= Vs_poi + 1;
                end
            else
                Hs_poi <= Hs_poi + 1;
            end
        end
        
endmodule