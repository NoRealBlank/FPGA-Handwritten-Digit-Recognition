`timescale 1ns / 1ps

module cnn_top_tb;
    reg clk;
    reg rst_n;
    wire [5:0] valid_out;
    wire [3:0] decision;
    reg [7:0] pic[0:784];
   
    wire [9:0] addr_r2;
    reg [7:0] data_out2;
    cnn_top uut_cnn (
        .clk(clk),
        .rst_n(rst_n),
        .douta(data_out2),
        .addra(addr_r2),
        .valid_out(valid_out),
        .decision(decision)
        );
    
    // Clock generation
    always #5 clk = ~clk;
    
    always @(posedge clk) begin
        if(~rst_n)
            data_out2 <= 0;
        else
            data_out2 = pic[addr_r2];
        end
    
    reg is_play;
    always @(posedge clk) begin
        if(~rst_n)
            is_play <= 0;
        else if(valid_out[5])
            is_play <= 1;
            end
                
    // Read image text file
    initial begin
        $readmemh("C:/Users/DELL/Desktop/cnn/cnn.srcs/sources_1/new/data/9_0.txt", pic);
        clk <= 1'b0;
        rst_n <= 1'b1;
        #3 rst_n <= 1'b0;
        #3 rst_n <= 1'b1;
        end

endmodule
