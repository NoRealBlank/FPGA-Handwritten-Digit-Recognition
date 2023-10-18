`timescale 1ns / 1ps

module cnn_top(
    input clk,
    input rst_n,
    input [7:0] douta,
    output reg [9:0] addra,
    output [5:0] valid_out,
    output [3:0] decision
    );
    
    wire signed [11:0] conv_out_1, conv_out_2, conv_out_3;
    wire signed [11:0] conv2_out_1, conv2_out_2, conv2_out_3;
    wire signed [11:0] max_value_1, max_value_2, max_value_3;
    wire signed [11:0] max2_value_1, max2_value_2, max2_value_3;
    wire signed [11:0] fc_out_data;
    
    // Module Instantiation
    conv1_layer conv1_layer(
      .clk(clk),
      .rst_n(rst_n),
      .data_in(douta),
      .conv_out_1(conv_out_1),
      .conv_out_2(conv_out_2),
      .conv_out_3(conv_out_3),
      .valid_out_conv(valid_out[0])
    );
    
    maxpool_relu #(.CONV_BIT(12), .HALF_WIDTH(12), .HALF_HEIGHT(12), .HALF_WIDTH_BIT(4))
    maxpool_relu_1(
      .clk(clk),
      .rst_n(rst_n),
      .valid_in(valid_out[0]),
      .conv_out_1(conv_out_1),
      .conv_out_2(conv_out_2),
      .conv_out_3(conv_out_3),
      .max_value_1(max_value_1),
      .max_value_2(max_value_2),
      .max_value_3(max_value_3),
      .valid_out_relu(valid_out[1])
    );
    
    conv2_layer conv2_layer(
      .clk(clk),
      .rst_n(rst_n),
      .valid_in(valid_out[1]),
      .max_value_1(max_value_1),
      .max_value_2(max_value_2),
      .max_value_3(max_value_3),
      .conv2_out_1(conv2_out_1),
      .conv2_out_2(conv2_out_2),
      .conv2_out_3(conv2_out_3),
      .valid_out_conv2(valid_out[2])
    );
    
    maxpool_relu #(.CONV_BIT(12), .HALF_WIDTH(4), .HALF_HEIGHT(4), .HALF_WIDTH_BIT(3))
    maxpool_relu_2(
      .clk(clk),
      .rst_n(rst_n),
      .valid_in(valid_out[2]),
      .conv_out_1(conv2_out_1),
      .conv_out_2(conv2_out_2),
      .conv_out_3(conv2_out_3),
      .max_value_1(max2_value_1),
      .max_value_2(max2_value_2),
      .max_value_3(max2_value_3),
      .valid_out_relu(valid_out[3])
    );
    
    fully_connected fully_connected(
      .clk(clk),
      .rst_n(rst_n),
      .valid_in(valid_out[3]),
      .data_in_1(max2_value_1),
      .data_in_2(max2_value_2),
      .data_in_3(max2_value_3),
      .data_out(fc_out_data),
      .valid_out_fc(valid_out[4])
    );
    
    wire [3:0] decision_t1;   
     
    comparator comparator(
      .clk(clk),
      .rst_n(rst_n),
      .valid_in(valid_out[4]),
      .data_in(fc_out_data),
      .decision(decision_t1),
      .valid_out(valid_out[5])
    );
    
//    ila_1 outer (
//            .clk(clk),
//            .probe0(valid_out),
//            .probe1(decision_t1),
//            .probe2(douta),
//            .probe3(conv_out_1),
//            .probe4(max_value_1),
//            .probe5(conv2_out_1),
//            .probe6(max2_value_1),
//            .probe7(fc_out_data)
//            );
    
    reg [3:0] decision_t2;
    reg is_rst;
    
    always @(posedge clk) begin
        if (~rst_n) begin
            is_rst <= 1;
            decision_t2 <= 0;
            end
        else if(valid_out[5] && is_rst) begin
            decision_t2 <= decision_t1;
            is_rst <= 0;
            end        
        end
    
    assign decision = decision_t2;
    
    always @(posedge clk) begin
        if (~rst_n)
            addra <= 0;
        else if(addra < 10'd784)
            addra <= addra + 1'b1;       
        end
               
endmodule
