`timescale 1ns / 1ps

 //  Design     : 1st Convolution Layer for CNN MNIST dataset
 //               Convolution Sum Calculation

 module conv1_calc #(parameter WIDTH = 28, HEIGHT = 28, DATA_BITS = 8) (
    input clk,
   input valid_out_buf,
   input [DATA_BITS - 1:0] data_out_0, data_out_1, data_out_2, data_out_3, data_out_4,
   data_out_5, data_out_6, data_out_7, data_out_8, data_out_9,
   data_out_10, data_out_11, data_out_12, data_out_13, data_out_14,
   data_out_15, data_out_16, data_out_17, data_out_18, data_out_19,
   data_out_20, data_out_21, data_out_22, data_out_23, data_out_24,
   output signed [11:0] conv_out_1, conv_out_2, conv_out_3,
   output valid_out_calc
 );

 localparam FILTER_SIZE = 5;
 localparam CHANNEL_LEN = 3;

 wire signed [DATA_BITS - 1:0] weight_1 [0:FILTER_SIZE * FILTER_SIZE - 1];
 wire signed [DATA_BITS - 1:0] weight_2 [0:FILTER_SIZE * FILTER_SIZE - 1];
 wire signed [DATA_BITS - 1:0] weight_3 [0:FILTER_SIZE * FILTER_SIZE - 1];
 wire signed [DATA_BITS - 1:0] bias [0:CHANNEL_LEN - 1];
    
 assign weight_1[0] = 8'h06;
 assign weight_1[1] = 8'h00;
 assign weight_1[2] = 8'h1b;
 assign weight_1[3] = 8'h29;
 assign weight_1[4] = 8'h35;
 assign weight_1[5] = 8'he7;
 assign weight_1[6] = 8'h13;
 assign weight_1[7] = 8'hfd;
 assign weight_1[8] = 8'h0b;
 assign weight_1[9] = 8'h3e;
 assign weight_1[10] = 8'hf1;
 assign weight_1[11] = 8'hf3;
 assign weight_1[12] = 8'h0e;
 assign weight_1[13] = 8'hf5;
 assign weight_1[14] = 8'hf6;
 assign weight_1[15] = 8'hd2;
 assign weight_1[16] = 8'hd8;
 assign weight_1[17] = 8'hdb;
 assign weight_1[18] = 8'hd6;
 assign weight_1[19] = 8'hd9;
 assign weight_1[20] = 8'he7;
 assign weight_1[21] = 8'he3;
 assign weight_1[22] = 8'hd6;
 assign weight_1[23] = 8'he2;
 assign weight_1[24] = 8'hdc;
 
 assign weight_2[0] = 8'h08;
 assign weight_2[1] = 8'h00;
 assign weight_2[2] = 8'h06;
 assign weight_2[3] = 8'hf5;
 assign weight_2[4] = 8'hfd;
 assign weight_2[5] = 8'h1a;
 assign weight_2[6] = 8'hf0;
 assign weight_2[7] = 8'h19;
 assign weight_2[8] = 8'h0a;
 assign weight_2[9] = 8'h24;
 assign weight_2[10] = 8'h0f;
 assign weight_2[11] = 8'h12;
 assign weight_2[12] = 8'h21;
 assign weight_2[13] = 8'h46;
 assign weight_2[14] = 8'h41;
 assign weight_2[15] = 8'h0d;
 assign weight_2[16] = 8'h3a;
 assign weight_2[17] = 8'h6c;
 assign weight_2[18] = 8'h76;
 assign weight_2[19] = 8'h2e;
 assign weight_2[20] = 8'h31;
 assign weight_2[21] = 8'h1d;
 assign weight_2[22] = 8'h58;
 assign weight_2[23] = 8'h35;
 assign weight_2[24] = 8'h4e;
 
 assign weight_3[0] = 8'h21;
 assign weight_3[1] = 8'h1a;
 assign weight_3[2] = 8'h33;
 assign weight_3[3] = 8'h29;
 assign weight_3[4] = 8'h47;
 assign weight_3[5] = 8'h1b;
 assign weight_3[6] = 8'h1b;
 assign weight_3[7] = 8'h20;
 assign weight_3[8] = 8'h0c;
 assign weight_3[9] = 8'hf8;
 assign weight_3[10] = 8'hd8;
 assign weight_3[11] = 8'h02;
 assign weight_3[12] = 8'he0;
 assign weight_3[13] = 8'hdd;
 assign weight_3[14] = 8'hd5;
 assign weight_3[15] = 8'hdc;
 assign weight_3[16] = 8'hc3;
 assign weight_3[17] = 8'hce;
 assign weight_3[18] = 8'hbc;
 assign weight_3[19] = 8'he5;
 assign weight_3[20] = 8'hd5;
 assign weight_3[21] = 8'hd9;
 assign weight_3[22] = 8'hda;
 assign weight_3[23] = 8'h03;
 assign weight_3[24] = 8'hf9;

 assign bias[0] = 8'h07;
 assign bias[1] = 8'h0f;
 assign bias[2] = 8'h2f;
    
//integer is_fill = 0;

//always @(*) begin
//if(is_fill == 0) begin
//    weight_1[0] <= 8'h06;
//    ...
//    weight_1[24] <= 8'hdc;

//    weight_2[0] <= 8'h08;
//    ...
//    weight_2[24] <= 8'h4e;

//    weight_3[0] <= 8'h21;
//    ...
//    weight_3[24] <= 8'hf9;

//    bias[0] <= 8'h07;
//    bias[1] <= 8'h0f;
//    bias[2] <= 8'h2f;
    
//    is_fill = 1;
    
//    end
//    end


 wire signed [19:0] calc_out_1, calc_out_2, calc_out_3;
 wire signed [DATA_BITS:0] exp_data [0:FILTER_SIZE * FILTER_SIZE - 1];
 wire signed [11:0] exp_bias [0:CHANNEL_LEN - 1];
 
// initial begin
//   $readmemh("C:/Users/DELL/Desktop/cnn/cnn.srcs/sources_1/new/data/conv1_weight_1.txt", weight_1);
//   $readmemh("C:/Users/DELL/Desktop/cnn/cnn.srcs/sources_1/new/data/conv1_weight_2.txt", weight_2);
//   $readmemh("C:/Users/DELL/Desktop/cnn/cnn.srcs/sources_1/new/data/conv1_weight_3.txt", weight_3);
//   $readmemh("C:/Users/DELL/Desktop/cnn/cnn.srcs/sources_1/new/data/conv1_bias.txt", bias);
// end
 
                  
                    
 // Unsigned -> Signed
 assign exp_data[0] = {1'd0, data_out_0};
 assign exp_data[1] = {1'd0, data_out_1};
 assign exp_data[2] = {1'd0, data_out_2};
 assign exp_data[3] = {1'd0, data_out_3};
 assign exp_data[4] = {1'd0, data_out_4};
 assign exp_data[5] = {1'd0, data_out_5};
 assign exp_data[6] = {1'd0, data_out_6};
 assign exp_data[7] = {1'd0, data_out_7};
 assign exp_data[8] = {1'd0, data_out_8};
 assign exp_data[9] = {1'd0, data_out_9};
 assign exp_data[10] = {1'd0, data_out_10};
 assign exp_data[11] = {1'd0, data_out_11};
 assign exp_data[12] = {1'd0, data_out_12};
 assign exp_data[13] = {1'd0, data_out_13};
 assign exp_data[14] = {1'd0, data_out_14};
 assign exp_data[15] = {1'd0, data_out_15};
 assign exp_data[16] = {1'd0, data_out_16};
 assign exp_data[17] = {1'd0, data_out_17};
 assign exp_data[18] = {1'd0, data_out_18};
 assign exp_data[19] = {1'd0, data_out_19};
 assign exp_data[20] = {1'd0, data_out_20};
 assign exp_data[21] = {1'd0, data_out_21};
 assign exp_data[22] = {1'd0, data_out_22};
 assign exp_data[23] = {1'd0, data_out_23};
 assign exp_data[24] = {1'd0, data_out_24};

 //  Re-calibration of extracted weight data according to MSB
 assign exp_bias[0] = (bias[0][7] == 1) ? {4'b1111, bias[0]} : {4'd0, bias[0]};
 assign exp_bias[1] = (bias[1][7] == 1) ? {4'b1111, bias[1]} : {4'd0, bias[1]};
 assign exp_bias[2] = (bias[2][7] == 1) ? {4'b1111, bias[2]} : {4'd0, bias[2]};
 
 assign calc_out_1 = exp_data[0]*weight_1[0] + exp_data[1]*weight_1[1] + exp_data[2]*weight_1[2] + exp_data[3]*weight_1[3] + exp_data[4]*weight_1[4] +
					exp_data[5]*weight_1[5] + exp_data[6]*weight_1[6] + exp_data[7]*weight_1[7] + exp_data[8]*weight_1[8] + exp_data[9]*weight_1[9] +
					exp_data[10]*weight_1[10] + exp_data[11]*weight_1[11] + exp_data[12]*weight_1[12] + exp_data[13]*weight_1[13] + exp_data[14]*weight_1[14] +
					exp_data[15]*weight_1[15] + exp_data[16]*weight_1[16] + exp_data[17]*weight_1[17] + exp_data[18]*weight_1[18] + exp_data[19]*weight_1[19] +
					exp_data[20]*weight_1[20] + exp_data[21]*weight_1[21] +exp_data[22]*weight_1[22] +exp_data[23]*weight_1[23] +exp_data[24]*weight_1[24];
 
 assign calc_out_2 = exp_data[0]*weight_2[0] + exp_data[1]*weight_2[1] + exp_data[2]*weight_2[2] + exp_data[3]*weight_2[3] + exp_data[4]*weight_2[4] +
					exp_data[5]*weight_2[5] + exp_data[6]*weight_2[6] + exp_data[7]*weight_2[7] + exp_data[8]*weight_2[8] + exp_data[9]*weight_2[9] +
					exp_data[10]*weight_2[10] + exp_data[11]*weight_2[11] + exp_data[12]*weight_2[12] + exp_data[13]*weight_2[13] + exp_data[14]*weight_2[14] +
					exp_data[15]*weight_2[15] + exp_data[16]*weight_2[16] + exp_data[17]*weight_2[17] + exp_data[18]*weight_2[18] + exp_data[19]*weight_2[19] +
					exp_data[20]*weight_2[20] + exp_data[21]*weight_2[21] + exp_data[22]*weight_2[22] +exp_data[23]*weight_2[23] +exp_data[24]*weight_2[24];
 
 assign calc_out_3 = exp_data[0]*weight_3[0] + exp_data[1]*weight_3[1] + exp_data[2]*weight_3[2] + exp_data[3]*weight_3[3] + exp_data[4]*weight_3[4] + 
					exp_data[5]*weight_3[5] + exp_data[6]*weight_3[6] + exp_data[7]*weight_3[7] + exp_data[8]*weight_3[8] + exp_data[9]*weight_3[9] + 
					exp_data[10]*weight_3[10] + exp_data[11]*weight_3[11] + exp_data[12]*weight_3[12] + exp_data[13]*weight_3[13] + exp_data[14]*weight_3[14] + 
					exp_data[15]*weight_3[15] + exp_data[16]*weight_3[16] + exp_data[17]*weight_3[17] + exp_data[18]*weight_3[18] + exp_data[19]*weight_3[19] + 
					exp_data[20]*weight_3[20] + exp_data[21]*weight_3[21] + exp_data[22]*weight_3[22] + exp_data[23]*weight_3[23] + exp_data[24]*weight_3[24];
 
 assign conv_out_1 = calc_out_1[19:8] + exp_bias[0];
 assign conv_out_2 = calc_out_2[19:8] + exp_bias[1];
 assign conv_out_3 = calc_out_3[19:8] + exp_bias[2];

 assign valid_out_calc = valid_out_buf;
 
//  ila_0 debugg (
//        .clk(clk),
//        .probe0(valid_out_buf),
//        .probe1(valid_out_calc),
//        .probe2(data_out_0),
//        .probe3(conv_out_1),
//        .probe4(weight_1[0]),
//        .probe5(weight_2[0]),
//        .probe6(weight_3[0]),
//        .probe7(bias[0])
//        );
                      
endmodule

