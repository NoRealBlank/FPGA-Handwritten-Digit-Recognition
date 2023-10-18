`timescale 1ns / 1ps

//  Design     : 2nd Convolution Layer for CNN MNIST dataset
//               Convolution Sum Calculation - 2nd Channel

module conv2_calc_2(
	input clk,
    input rst_n,
    input valid_out_buf,
	input signed [11:0] data_out1_0, data_out1_1, data_out1_2, data_out1_3, data_out1_4,
	  data_out1_5, data_out1_6, data_out1_7, data_out1_8, data_out1_9,
	  data_out1_10, data_out1_11, data_out1_12, data_out1_13, data_out1_14,
	  data_out1_15, data_out1_16, data_out1_17, data_out1_18, data_out1_19,
	  data_out1_20, data_out1_21, data_out1_22, data_out1_23, data_out1_24,
	
	  data_out2_0, data_out2_1, data_out2_2, data_out2_3, data_out2_4,
	  data_out2_5, data_out2_6, data_out2_7, data_out2_8, data_out2_9,
	  data_out2_10, data_out2_11, data_out2_12, data_out2_13, data_out2_14,
	  data_out2_15, data_out2_16, data_out2_17, data_out2_18, data_out2_19,
	  data_out2_20, data_out2_21, data_out2_22, data_out2_23, data_out2_24,
	
	  data_out3_0, data_out3_1, data_out3_2, data_out3_3, data_out3_4,
	  data_out3_5, data_out3_6, data_out3_7, data_out3_8, data_out3_9,
	  data_out3_10, data_out3_11, data_out3_12, data_out3_13, data_out3_14,
	  data_out3_15, data_out3_16, data_out3_17, data_out3_18, data_out3_19,
	  data_out3_20, data_out3_21, data_out3_22, data_out3_23, data_out3_24,

	output [13:0] conv_out_calc,
  	output reg valid_out_calc
);

wire signed [19:0] calc_out, calc_out_1, calc_out_2, calc_out_3;

wire signed [7:0] weight_1 [0:24];
wire signed [7:0] weight_2 [0:24];
wire signed [7:0] weight_3 [0:24];

assign weight_1[0] = 8'h00; //00
assign weight_1[1] = 8'h0d;
assign weight_1[2] = 8'h06;
assign weight_1[3] = 8'h11;
assign weight_1[4] = 8'hfc;
assign weight_1[5] = 8'h09;
assign weight_1[6] = 8'hf4;
assign weight_1[7] = 8'h0e;
assign weight_1[8] = 8'h0b;
assign weight_1[9] = 8'hfc;
assign weight_1[10] = 8'h07;
assign weight_1[11] = 8'h18;
assign weight_1[12] = 8'h1a;
assign weight_1[13] = 8'h0a;
assign weight_1[14] = 8'hfa;
assign weight_1[15] = 8'h0b;
assign weight_1[16] = 8'h2a;
assign weight_1[17] = 8'h1c;
assign weight_1[18] = 8'h04; //04
assign weight_1[19] = 8'hea;
assign weight_1[20] = 8'h12;
assign weight_1[21] = 8'h16;
assign weight_1[22] = 8'hf3;
assign weight_1[23] = 8'hf0;
assign weight_1[24] = 8'hf6;

assign weight_2[0] = 8'h00; //00
assign weight_2[1] = 8'hbf;
assign weight_2[2] = 8'hae;
assign weight_2[3] = 8'hd1;
assign weight_2[4] = 8'hfb;
assign weight_2[5] = 8'h15;
assign weight_2[6] = 8'h1e;
assign weight_2[7] = 8'h0f;
assign weight_2[8] = 8'h20;
assign weight_2[9] = 8'hf3;
assign weight_2[10] = 8'h2a;
assign weight_2[11] = 8'h43;
assign weight_2[12] = 8'h48;
assign weight_2[13] = 8'h30;
assign weight_2[14] = 8'hf7;
assign weight_2[15] = 8'hfb;
assign weight_2[16] = 8'hef;
assign weight_2[17] = 8'hf2;
assign weight_2[18] = 8'h02; //02;
assign weight_2[19] = 8'h00; //00
assign weight_2[20] = 8'hdd;
assign weight_2[21] = 8'he6;
assign weight_2[22] = 8'he7;
assign weight_2[23] = 8'hfa;
assign weight_2[24] = 8'he2;

assign weight_3[0] = 8'he5;
assign weight_3[1] = 8'h0d;
assign weight_3[2] = 8'h10;
assign weight_3[3] = 8'hef;
assign weight_3[4] = 8'hfa;
assign weight_3[5] = 8'hec;
assign weight_3[6] = 8'hed;
assign weight_3[7] = 8'hf0;
assign weight_3[8] = 8'hf7;
assign weight_3[9] = 8'h00; //00
assign weight_3[10] = 8'h05;
assign weight_3[11] = 8'hfe;
assign weight_3[12] = 8'h05;
assign weight_3[13] = 8'h16;
assign weight_3[14] = 8'h01; //01;
assign weight_3[15] = 8'h0c;
assign weight_3[16] = 8'h29;
assign weight_3[17] = 8'h3c;
assign weight_3[18] = 8'h10;
assign weight_3[19] = 8'hfa;
assign weight_3[20] = 8'h15;
assign weight_3[21] = 8'h1d;
assign weight_3[22] = 8'h0b;
assign weight_3[23] = 8'hf0;
assign weight_3[24] = 8'hf0;



// integer is_fill = 0;

//always @(*) begin
//if(is_fill == 0) begin
////	$readmemh("C:/Users/DELL/Desktop/cnn/cnn.srcs/sources_1/new/data/conv2_weight_21.txt", weight_1);
////	$readmemh("C:/Users/DELL/Desktop/cnn/cnn.srcs/sources_1/new/data/conv2_weight_22.txt", weight_2);
////	$readmemh("C:/Users/DELL/Desktop/cnn/cnn.srcs/sources_1/new/data/conv2_weight_23.txt", weight_3);

//weight_1[0] <= 8'h00;
//weight_1[1] <= 8'h0d;
//weight_1[2] <= 8'h06;
//weight_1[3] <= 8'h11;
//weight_1[4] <= 8'hfc;
//weight_1[5] <= 8'h09;
//weight_1[6] <= 8'hf4;
//weight_1[7] <= 8'h0e;
//weight_1[8] <= 8'h0b;
//weight_1[9] <= 8'hfc;
//weight_1[10] <= 8'h07;
//weight_1[11] <= 8'h18;
//weight_1[12] <= 8'h1a;
//weight_1[13] <= 8'h0a;
//weight_1[14] <= 8'hfa;
//weight_1[15] <= 8'h0b;
//weight_1[16] <= 8'h2a;
//weight_1[17] <= 8'h1c;
//weight_1[18] <= 8'h04;
//weight_1[19] <= 8'hea;
//weight_1[20] <= 8'h12;
//weight_1[21] <= 8'h16;
//weight_1[22] <= 8'hf3;
//weight_1[23] <= 8'hf0;
//weight_1[24] <= 8'hf6;

//weight_2[0] <= 8'h00;
//weight_2[1] <= 8'hbf;
//weight_2[2] <= 8'hae;
//weight_2[3] <= 8'hd1;
//weight_2[4] <= 8'hfb;
//weight_2[5] <= 8'h15;
//weight_2[6] <= 8'h1e;
//weight_2[7] <= 8'h0f;
//weight_2[8] <= 8'h20;
//weight_2[9] <= 8'hf3;
//weight_2[10] <= 8'h2a;
//weight_2[11] <= 8'h43;
//weight_2[12] <= 8'h48;
//weight_2[13] <= 8'h30;
//weight_2[14] <= 8'hf7;
//weight_2[15] <= 8'hfb;
//weight_2[16] <= 8'hef;
//weight_2[17] <= 8'hf2;
//weight_2[18] <= 8'h02;
//weight_2[19] <= 8'h00;
//weight_2[20] <= 8'hdd;
//weight_2[21] <= 8'he6;
//weight_2[22] <= 8'he7;
//weight_2[23] <= 8'hfa;
//weight_2[24] <= 8'he2;

//weight_3[0] <= 8'he5;
//weight_3[1] <= 8'h0d;
//weight_3[2] <= 8'h10;
//weight_3[3] <= 8'hef;
//weight_3[4] <= 8'hfa;
//weight_3[5] <= 8'hec;
//weight_3[6] <= 8'hed;
//weight_3[7] <= 8'hf0;
//weight_3[8] <= 8'hf7;
//weight_3[9] <= 8'h00;
//weight_3[10] <= 8'h05;
//weight_3[11] <= 8'hfe;
//weight_3[12] <= 8'h05;
//weight_3[13] <= 8'h16;
//weight_3[14] <= 8'h01;
//weight_3[15] <= 8'h0c;
//weight_3[16] <= 8'h29;
//weight_3[17] <= 8'h3c;
//weight_3[18] <= 8'h10;
//weight_3[19] <= 8'hfa;
//weight_3[20] <= 8'h15;
//weight_3[21] <= 8'h1d;
//weight_3[22] <= 8'h0b;
//weight_3[23] <= 8'hf0;
//weight_3[24] <= 8'hf0;

//is_fill <= 1;

//end
//end

assign calc_out_1 = data_out1_0*weight_1[0] + data_out1_1*weight_1[1] + data_out1_2*weight_1[2] + data_out1_3*weight_1[3] + data_out1_4*weight_1[4] + 
					data_out1_5*weight_1[5] + data_out1_6*weight_1[6] + data_out1_7*weight_1[7] + data_out1_8*weight_1[8] + data_out1_9*weight_1[9] + 
					data_out1_10*weight_1[10] + data_out1_11*weight_1[11] + data_out1_12*weight_1[12] + data_out1_13*weight_1[13] + data_out1_14*weight_1[14] + 
					data_out1_15*weight_1[15] + data_out1_16*weight_1[16] + data_out1_17*weight_1[17] + data_out1_18*weight_1[18] + data_out1_19*weight_1[19] + 
					data_out1_20*weight_1[20] + data_out1_21*weight_1[21] + data_out1_22*weight_1[22] + data_out1_23*weight_1[23] + data_out1_24*weight_1[24];

assign calc_out_2 = data_out2_0*weight_2[0] + data_out2_1*weight_2[1] + data_out2_2*weight_2[2] + data_out2_3*weight_2[3] + data_out2_4*weight_2[4] + 
					data_out2_5*weight_2[5] + data_out2_6*weight_2[6] + data_out2_7*weight_2[7] + data_out2_8*weight_2[8] + data_out2_9*weight_2[9] + 
					data_out2_10*weight_2[10] + data_out2_11*weight_2[11] + data_out2_12*weight_2[12] + data_out2_13*weight_2[13] + data_out2_14*weight_2[14] + 
					data_out2_15*weight_2[15] + data_out2_16*weight_2[16] + data_out2_17*weight_2[17] + data_out2_18*weight_2[18] + data_out2_19*weight_2[19] + 
					data_out2_20*weight_2[20] + data_out2_21*weight_2[21] + data_out2_22*weight_2[22] + data_out2_23*weight_2[23] + data_out2_24*weight_2[24];

assign calc_out_3 = data_out3_0*weight_3[0] + data_out3_1*weight_3[1] + data_out3_2*weight_3[2] + data_out3_3*weight_3[3] + data_out3_4*weight_3[4] + 
					data_out3_5*weight_3[5] + data_out3_6*weight_3[6] + data_out3_7*weight_3[7] + data_out3_8*weight_3[8] + data_out3_9*weight_3[9] + 
					data_out3_10*weight_3[10] + data_out3_11*weight_3[11] + data_out3_12*weight_3[12] + data_out3_13*weight_3[13] + data_out3_14*weight_3[14] + 
					data_out3_15*weight_3[15] + data_out3_16*weight_3[16] + data_out3_17*weight_3[17] + data_out3_18*weight_3[18] + data_out3_19*weight_3[19] + 
					data_out3_20*weight_3[20] + data_out3_21*weight_3[21] + data_out3_22*weight_3[22] + data_out3_23*weight_3[23] + data_out3_24*weight_3[24];

assign calc_out = calc_out_1 + calc_out_2 + calc_out_3;

//reg signed [19:0] calc_out, calc_out_1, calc_out_2, calc_out_3;

assign conv_out_calc = calc_out[19:6]; // 14bit

always @ (posedge clk) begin
	if(~rst_n) begin
		valid_out_calc <= 0;
    //conv_out_calc <= 0;
	end
	else begin
		// Toggling Valid Output Signal
		if(valid_out_buf == 1) begin
			if(valid_out_calc == 1)
				valid_out_calc <= 0;
			else
				valid_out_calc <= 1;
		end
	end
end

//integer state;
//always @ (posedge clk) begin
//	if(~rst_n) begin
//	   valid_out_calc <= 0;
//	   state <= 0;
//    //conv_out_calc <= 0;
//	   end
//	else begin
//		// Toggling Valid Output Signal
//	   if(valid_out_buf == 1) begin
//	       if(valid_out_calc == 1) begin
//	           valid_out_calc <= 0;
//	           state <= 0;
//	           end
//	       else if (state == 0) begin
//	           calc_out_1 <= data_out1_0*weight_1[0] + data_out1_1*weight_1[1] + data_out1_2*weight_1[2] + data_out1_3*weight_1[3] + data_out1_4*weight_1[4] + 
//                               data_out1_5*weight_1[5] + data_out1_6*weight_1[6] + data_out1_7*weight_1[7] + data_out1_8*weight_1[8] + data_out1_9*weight_1[9] + 
//                               data_out1_10*weight_1[10] + data_out1_11*weight_1[11] + data_out1_12*weight_1[12] + data_out1_13*weight_1[13] + data_out1_14*weight_1[14] + 
//                               data_out1_15*weight_1[15] + data_out1_16*weight_1[16] + data_out1_17*weight_1[17] + data_out1_18*weight_1[18] + data_out1_19*weight_1[19] + 
//                               data_out1_20*weight_1[20] + data_out1_21*weight_1[21] + data_out1_22*weight_1[22] + data_out1_23*weight_1[23] + data_out1_24*weight_1[24];
//	           state <= 1;
//	           end
//	       else if (state == 1) begin
//               calc_out_2 <= data_out2_0*weight_2[0] + data_out2_1*weight_2[1] + data_out2_2*weight_2[2] + data_out2_3*weight_2[3] + data_out2_4*weight_2[4] + 
//                               data_out2_5*weight_2[5] + data_out2_6*weight_2[6] + data_out2_7*weight_2[7] + data_out2_8*weight_2[8] + data_out2_9*weight_2[9] + 
//                               data_out2_10*weight_2[10] + data_out2_11*weight_2[11] + data_out2_12*weight_2[12] + data_out2_13*weight_2[13] + data_out2_14*weight_2[14] + 
//                               data_out2_15*weight_2[15] + data_out2_16*weight_2[16] + data_out2_17*weight_2[17] + data_out2_18*weight_2[18] + data_out2_19*weight_2[19] + 
//                               data_out2_20*weight_2[20] + data_out2_21*weight_2[21] + data_out2_22*weight_2[22] + data_out2_23*weight_2[23] + data_out2_24*weight_2[24];

//               state <= 2;         
//               end
//           else if (state == 2) begin
//               calc_out_3 <= data_out3_0*weight_3[0] + data_out3_1*weight_3[1] + data_out3_2*weight_3[2] + data_out3_3*weight_3[3] + data_out3_4*weight_3[4] + 
//                               data_out3_5*weight_3[5] + data_out3_6*weight_3[6] + data_out3_7*weight_3[7] + data_out3_8*weight_3[8] + data_out3_9*weight_3[9] + 
//                               data_out3_10*weight_3[10] + data_out3_11*weight_3[11] + data_out3_12*weight_3[12] + data_out3_13*weight_3[13] + data_out3_14*weight_3[14] + 
//                               data_out3_15*weight_3[15] + data_out3_16*weight_3[16] + data_out3_17*weight_3[17] + data_out3_18*weight_3[18] + data_out3_19*weight_3[19] + 
//                               data_out3_20*weight_3[20] + data_out3_21*weight_3[21] + data_out3_22*weight_3[22] + data_out3_23*weight_3[23] + data_out3_24*weight_3[24];
//               calc_out <= calc_out_1 + calc_out_2 + calc_out_3;
//               valid_out_calc <= 1;                    
//               end
//		end
//	end
//end

endmodule