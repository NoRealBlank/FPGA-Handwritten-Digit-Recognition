`timescale 1ns / 1ps

module bluetooth_get_pic(
    input clk,
    input rst,
    input get,
    output reg [7:0] dina,
    output reg [9:0] addra,
    output reg valid_pic
);

    parameter bps = 10417;// 1/9600
    reg [14:0] count_1;
    reg [3:0] count_2;
    reg buffer_0, buffer_1, buffer_2;
    wire buffer_en;
    reg add_en;

    always @(posedge clk) begin
        if (rst) begin
            buffer_0 <= 1;
            buffer_1 <= 1;
            buffer_2 <= 1;
            end
        else begin
            buffer_0 <= get;
            buffer_1 <= buffer_0;
            buffer_2 <= buffer_1;
            end
        end

    assign buffer_en = buffer_2 & ~buffer_1;

    always @(posedge clk) begin
        if (rst)
            count_1 <= 0;
        else if (add_en) begin
            if(count_1 == bps-1)
                count_1 <= 0;
            else
                count_1 <= count_1+1;
            end
        end

    always @(posedge clk) begin
        if (rst)
            count_2 <= 0;
        else if (add_en && count_1 == bps-1) begin
            if(count_2 == 8)
                count_2 <= 0;
            else
                count_2 <= count_2 + 1;
            end
        end

    always @(posedge clk) begin
        if (rst)
            add_en <= 0;
        else if (buffer_en)
            add_en <= 1;        
        else if (add_en && (count_2 == 8) && (count_1 == bps-1))
            add_en <= 0;
        end
    
    always @(posedge clk) begin
        if (rst) begin
            dina <= 0;
            addra <= 0;
            valid_pic <= 0;
            end
        else if(add_en && (count_1 == bps / 2 - 1) && (count_2 != 0)) begin
            dina[count_2 - 1] <= get;
            if (count_2 == 8) begin
                addra = addra + 1;
                if (addra == 10'd784) begin
                    valid_pic <= 1;
                    end
                end
            end
        end
    
endmodule
