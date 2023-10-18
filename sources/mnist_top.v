`timescale 1ns / 1ps

module mnist_top(
    input clk,
    input rst,
    output [6:0] valid_flag,
    output [6:0] display7,
    // BLUETOOTH
    input bluetooth_get,
    // VGA
    output [3:0] red, green, blue,
    output Hs_valid,
    output Vs_valid,
    // MP3
    input DREQ,
    output xRSET,
    output xCS,
    output xDCS,
    output MOSI,
    output SCLK
    );
 
    wire clk_vga ;//vga 25.175mhz
    wire clk_mp3_std;//mp3 12.288mhz
    wire clk_mp3;//mp3 2mhz
    clk_wiz_0 uut_clk0(.clk_in1(clk), .clk_out1(clk_vga), .clk_out2(clk_mp3_std));
    divider #(.mod(200)) uut_clk1(.clk_in(clk),.rst(rst),.clk_out(clk_mp3));

    wire [9:0] addr_w, addr_r1, addr_r2;
    wire [7:0] data_in, data_out1, data_out2;
    
    ram_1w2r uut_ram (
        .clk(clk),
        .rst(rst),
        .wena(~valid_flag[0]),
        .addr_w(addr_w),
        .data_in(data_in),
        .addr_r1(addr_r1),
        .data_out1(data_out1),
        .addr_r2(addr_r2),
        .data_out2(data_out2)
        );
      
    bluetooth_get_pic uut_bt (
        .clk(clk),
        .rst(rst),
        .get(bluetooth_get),
        .dina(data_in),
        .addra(addr_w),
        .valid_pic(valid_flag[0])
        );
    
    vga_display uut_vga (
        .clk_vga(clk_vga),//25.175MHz
        .rst(rst | ~valid_flag[0]),
        .douta(data_out1),
        .addra(addr_r1),
        .Hs_valid(Hs_valid),
        .Vs_valid(Vs_valid),
        .grey(red)
        );
        
    assign green = red;
    assign blue = red;
    
    wire [3:0] decision;
    cnn_top uut_cnn (
        .clk(clk),
        .rst_n(~rst & valid_flag[0]),
        .douta(data_out2),
        .addra(addr_r2),
        .valid_out(valid_flag[6:1]),
        .decision(decision)
        );
    
    display7 uut_d7 (.iData(decision), .oData(display7));
    
    mp3_top uut_mp3 (
        .clk(clk_mp3),
        .rst(rst),
        .valid_in(valid_flag[6]),
        .decision(decision),      
        .DREQ(DREQ),
        .xRSET(xRSET),
        .xCS(xCS),
        .xDCS(xDCS),
        .MOSI(MOSI),
        .SCLK(SCLK)
        );
   
endmodule

