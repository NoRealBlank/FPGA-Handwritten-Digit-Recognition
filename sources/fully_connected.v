`timescale 1ns / 1ps

 // Design     : Fully Connected Layer for CNN

 module fully_connected (//#(parameter INPUT_NUM = 48, OUTPUT_NUM = 10, DATA_BITS = 8) (
   input clk,
   input rst_n,
   input valid_in,
   input signed [11:0] data_in_1, data_in_2, data_in_3,
   output [11:0] data_out,
   output reg valid_out_fc
//   output reg delay
 );

parameter INPUT_NUM = 48, OUTPUT_NUM = 10, DATA_BITS = 8;

 localparam INPUT_WIDTH = 16;
 localparam INPUT_NUM_DATA_BITS = 5;

 reg state;
 reg [INPUT_WIDTH - 1:0] buf_idx;
 reg [3:0] out_idx;
 reg signed [13:0] buffer [0:INPUT_NUM - 1];
 
 wire signed [DATA_BITS - 1:0] weight [0:INPUT_NUM * OUTPUT_NUM - 1];
 wire signed [DATA_BITS - 1:0] bias [0:OUTPUT_NUM - 1];
   
 wire signed [19:0] calc_out;
 wire signed [13:0] data1, data2, data3;

assign weight[0] = 8'hfe;
assign weight[1] = 8'h18;
assign weight[2] = 8'hfe;
assign weight[3] = 8'hf8;
assign weight[4] = 8'h13;
assign weight[5] = 8'h13;
assign weight[6] = 8'hfc;
assign weight[7] = 8'h14;
assign weight[8] = 8'h11;
assign weight[9] = 8'hfb;
assign weight[10] = 8'hf8;
assign weight[11] = 8'h22;
assign weight[12] = 8'hfd;
assign weight[13] = 8'hee;
assign weight[14] = 8'h00;
assign weight[15] = 8'h01;
assign weight[16] = 8'hfd;
assign weight[17] = 8'h02;
assign weight[18] = 8'h0f;
assign weight[19] = 8'h06;
assign weight[20] = 8'hf2;
assign weight[21] = 8'hf5;
assign weight[22] = 8'he7;
assign weight[23] = 8'hfd;
assign weight[24] = 8'hdf;
assign weight[25] = 8'he3;
assign weight[26] = 8'hf2;
assign weight[27] = 8'h04;
assign weight[28] = 8'hf1;
assign weight[29] = 8'h12;
assign weight[30] = 8'h1a;
assign weight[31] = 8'hfa;
assign weight[32] = 8'hf5;
assign weight[33] = 8'h09;
assign weight[34] = 8'h03;
assign weight[35] = 8'h02;
assign weight[36] = 8'hfd;
assign weight[37] = 8'hfa;
assign weight[38] = 8'h0d;
assign weight[39] = 8'h23;
assign weight[40] = 8'h14;
assign weight[41] = 8'hef;
assign weight[42] = 8'he0;
assign weight[43] = 8'hfc;
assign weight[44] = 8'h27;
assign weight[45] = 8'heb;
assign weight[46] = 8'hcc;
assign weight[47] = 8'h0a;
assign weight[48] = 8'hfe;
assign weight[49] = 8'hef;
assign weight[50] = 8'h30;
assign weight[51] = 8'h0d;
assign weight[52] = 8'h09;
assign weight[53] = 8'h09;
assign weight[54] = 8'h0a;
assign weight[55] = 8'hf3;
assign weight[56] = 8'h18;
assign weight[57] = 8'h0f;
assign weight[58] = 8'hef;
assign weight[59] = 8'hec;
assign weight[60] = 8'h14;
assign weight[61] = 8'h28;
assign weight[62] = 8'he0;
assign weight[63] = 8'hf9;
assign weight[64] = 8'h01;
assign weight[65] = 8'h17;
assign weight[66] = 8'hdd;
assign weight[67] = 8'hf1;
assign weight[68] = 8'h0b;
assign weight[69] = 8'hf4;
assign weight[70] = 8'hed;
assign weight[71] = 8'he8;
assign weight[72] = 8'h02;
assign weight[73] = 8'hf4;
assign weight[74] = 8'hef;
assign weight[75] = 8'hf2;
assign weight[76] = 8'h11;
assign weight[77] = 8'hf4;
assign weight[78] = 8'hf7;
assign weight[79] = 8'h20;
assign weight[80] = 8'hd9;
assign weight[81] = 8'h31;
assign weight[82] = 8'hd4;
assign weight[83] = 8'hd6;
assign weight[84] = 8'hdd;
assign weight[85] = 8'h40;
assign weight[86] = 8'hfe;
assign weight[87] = 8'hfe;
assign weight[88] = 8'hed;
assign weight[89] = 8'h10;
assign weight[90] = 8'hf5;
assign weight[91] = 8'h05;
assign weight[92] = 8'hc5;
assign weight[93] = 8'h21;
assign weight[94] = 8'h03;
assign weight[95] = 8'hfa;
assign weight[96] = 8'he3;
assign weight[97] = 8'hf5;
assign weight[98] = 8'hed;
assign weight[99] = 8'he4;
assign weight[100] = 8'h0f;
assign weight[101] = 8'h11;
assign weight[102] = 8'h16;
assign weight[103] = 8'h1b;
assign weight[104] = 8'h38;
assign weight[105] = 8'h29;
assign weight[106] = 8'h09;
assign weight[107] = 8'h00;
assign weight[108] = 8'hfd;
assign weight[109] = 8'hed;
assign weight[110] = 8'hde;
assign weight[111] = 8'he3;
assign weight[112] = 8'h1e;
assign weight[113] = 8'h06;
assign weight[114] = 8'h0e;
assign weight[115] = 8'hf1;
assign weight[116] = 8'h3a;
assign weight[117] = 8'h14;
assign weight[118] = 8'hfd;
assign weight[119] = 8'hf1;
assign weight[120] = 8'h12;
assign weight[121] = 8'hfa;
assign weight[122] = 8'h02;
assign weight[123] = 8'h14;
assign weight[124] = 8'he7;
assign weight[125] = 8'hfa;
assign weight[126] = 8'h04;
assign weight[127] = 8'h2a;
assign weight[128] = 8'h1c;
assign weight[129] = 8'h28;
assign weight[130] = 8'h3d;
assign weight[131] = 8'h06;
assign weight[132] = 8'hfe;
assign weight[133] = 8'hee;
assign weight[134] = 8'hf6;
assign weight[135] = 8'hf4;
assign weight[136] = 8'hd0;
assign weight[137] = 8'hf1;
assign weight[138] = 8'hdd;
assign weight[139] = 8'h02;
assign weight[140] = 8'h00;
assign weight[141] = 8'hfa;
assign weight[142] = 8'h0c;
assign weight[143] = 8'h10;
assign weight[144] = 8'hcc;
assign weight[145] = 8'hf9;
assign weight[146] = 8'h0f;
assign weight[147] = 8'h1e;
assign weight[148] = 8'hf2;
assign weight[149] = 8'h11;
assign weight[150] = 8'h01;
assign weight[151] = 8'h12;
assign weight[152] = 8'he1;
assign weight[153] = 8'hdb;
assign weight[154] = 8'hd0;
assign weight[155] = 8'h03;
assign weight[156] = 8'h01;
assign weight[157] = 8'h1c;
assign weight[158] = 8'h18;
assign weight[159] = 8'h17;
assign weight[160] = 8'h1e;
assign weight[161] = 8'h14;
assign weight[162] = 8'h08;
assign weight[163] = 8'h04;
assign weight[164] = 8'h17;
assign weight[165] = 8'h03;
assign weight[166] = 8'h0b;
assign weight[167] = 8'h0b;
assign weight[168] = 8'h00;
assign weight[169] = 8'h01;
assign weight[170] = 8'h11;
assign weight[171] = 8'hfc;
assign weight[172] = 8'h25;
assign weight[173] = 8'hfa;
assign weight[174] = 8'h14;
assign weight[175] = 8'hf0;
assign weight[176] = 8'hfa;
assign weight[177] = 8'h26;
assign weight[178] = 8'h17;
assign weight[179] = 8'hfe;
assign weight[180] = 8'he8;
assign weight[181] = 8'h00;
assign weight[182] = 8'hfb;
assign weight[183] = 8'hf7;
assign weight[184] = 8'he6;
assign weight[185] = 8'h13;
assign weight[186] = 8'h12;
assign weight[187] = 8'hfc;
assign weight[188] = 8'hed;
assign weight[189] = 8'hf8;
assign weight[190] = 8'h00;
assign weight[191] = 8'h08;
assign weight[192] = 8'h14;
assign weight[193] = 8'h20;
assign weight[194] = 8'h20;
assign weight[195] = 8'h2c;
assign weight[196] = 8'h27;
assign weight[197] = 8'he9;
assign weight[198] = 8'hf3;
assign weight[199] = 8'h1a;
assign weight[200] = 8'hef;
assign weight[201] = 8'hdb;
assign weight[202] = 8'h06;
assign weight[203] = 8'hec;
assign weight[204] = 8'h1b;
assign weight[205] = 8'h16;
assign weight[206] = 8'hf5;
assign weight[207] = 8'hf5;
assign weight[208] = 8'hf9;
assign weight[209] = 8'hd0;
assign weight[210] = 8'hcc;
assign weight[211] = 8'hd7;
assign weight[212] = 8'hfb;
assign weight[213] = 8'h17;
assign weight[214] = 8'h00;
assign weight[215] = 8'hef;
assign weight[216] = 8'h19;
assign weight[217] = 8'h18;
assign weight[218] = 8'h1e;
assign weight[219] = 8'h1c;
assign weight[220] = 8'hf8;
assign weight[221] = 8'hf6;
assign weight[222] = 8'he6;
assign weight[223] = 8'hf7;
assign weight[224] = 8'h35;
assign weight[225] = 8'hee;
assign weight[226] = 8'hf0;
assign weight[227] = 8'hf7;
assign weight[228] = 8'h08;
assign weight[229] = 8'hef;
assign weight[230] = 8'h2c;
assign weight[231] = 8'hef;
assign weight[232] = 8'h12;
assign weight[233] = 8'h0f;
assign weight[234] = 8'hf2;
assign weight[235] = 8'hfa;
assign weight[236] = 8'hf0;
assign weight[237] = 8'h01;
assign weight[238] = 8'h08;
assign weight[239] = 8'hf1;
assign weight[240] = 8'h01;
assign weight[241] = 8'h12;
assign weight[242] = 8'hea;
assign weight[243] = 8'he7;
assign weight[244] = 8'he6;
assign weight[245] = 8'hf3;
assign weight[246] = 8'he0;
assign weight[247] = 8'hb3;
assign weight[248] = 8'h00;
assign weight[249] = 8'h01;
assign weight[250] = 8'h12;
assign weight[251] = 8'he9;
assign weight[252] = 8'hed;
assign weight[253] = 8'h12;
assign weight[254] = 8'h1f;
assign weight[255] = 8'h29;
assign weight[256] = 8'hf0;
assign weight[257] = 8'h02;
assign weight[258] = 8'h08;
assign weight[259] = 8'h39;
assign weight[260] = 8'hfc;
assign weight[261] = 8'h08;
assign weight[262] = 8'h0e;
assign weight[263] = 8'h25;
assign weight[264] = 8'h18;
assign weight[265] = 8'h05;
assign weight[266] = 8'hfe;
assign weight[267] = 8'h00;
assign weight[268] = 8'h2c;
assign weight[269] = 8'h04;
assign weight[270] = 8'h0c;
assign weight[271] = 8'hee;
assign weight[272] = 8'h0d;
assign weight[273] = 8'he3;
assign weight[274] = 8'hdb;
assign weight[275] = 8'h21;
assign weight[276] = 8'h1b;
assign weight[277] = 8'hf1;
assign weight[278] = 8'hfb;
assign weight[279] = 8'h03;
assign weight[280] = 8'h15;
assign weight[281] = 8'h0c;
assign weight[282] = 8'h23;
assign weight[283] = 8'hf8;
assign weight[284] = 8'h00;
assign weight[285] = 8'hfb;
assign weight[286] = 8'h0b;
assign weight[287] = 8'h05;
assign weight[288] = 8'h18;
assign weight[289] = 8'h2c;
assign weight[290] = 8'h18;
assign weight[291] = 8'he7;
assign weight[292] = 8'h06;
assign weight[293] = 8'hff;
assign weight[294] = 8'h0b;
assign weight[295] = 8'hdc;
assign weight[296] = 8'hf6;
assign weight[297] = 8'h17;
assign weight[298] = 8'h29;
assign weight[299] = 8'h2a;
assign weight[300] = 8'hed;
assign weight[301] = 8'he6;
assign weight[302] = 8'hf6;
assign weight[303] = 8'hf9;
assign weight[304] = 8'hf1;
assign weight[305] = 8'he2;
assign weight[306] = 8'hf3;
assign weight[307] = 8'hff;
assign weight[308] = 8'he4;
assign weight[309] = 8'he2;
assign weight[310] = 8'h0f;
assign weight[311] = 8'h23;
assign weight[312] = 8'he1;
assign weight[313] = 8'hea;
assign weight[314] = 8'h08;
assign weight[315] = 8'h09;
assign weight[316] = 8'he5;
assign weight[317] = 8'h05;
assign weight[318] = 8'h0e;
assign weight[319] = 8'h0d;
assign weight[320] = 8'hf4;
assign weight[321] = 8'hd1;
assign weight[322] = 8'hbc;
assign weight[323] = 8'h1a;
assign weight[324] = 8'hf4;
assign weight[325] = 8'hc1;
assign weight[326] = 8'hc5;
assign weight[327] = 8'h09;
assign weight[328] = 8'h0d;
assign weight[329] = 8'hef;
assign weight[330] = 8'h09;
assign weight[331] = 8'h11;
assign weight[332] = 8'h1c;
assign weight[333] = 8'h10;
assign weight[334] = 8'h0b;
assign weight[335] = 8'h0d;
assign weight[336] = 8'hf0;
assign weight[337] = 8'hd3;
assign weight[338] = 8'he1;
assign weight[339] = 8'h18;
assign weight[340] = 8'h17;
assign weight[341] = 8'h23;
assign weight[342] = 8'h0b;
assign weight[343] = 8'h0d;
assign weight[344] = 8'h0f;
assign weight[345] = 8'hf1;
assign weight[346] = 8'h0f;
assign weight[347] = 8'h0c;
assign weight[348] = 8'h13;
assign weight[349] = 8'h0b;
assign weight[350] = 8'h00;
assign weight[351] = 8'hfb;
assign weight[352] = 8'h15;
assign weight[353] = 8'h1c;
assign weight[354] = 8'h2b;
assign weight[355] = 8'h05;
assign weight[356] = 8'h1e;
assign weight[357] = 8'h17;
assign weight[358] = 8'h02;
assign weight[359] = 8'h00;
assign weight[360] = 8'h13;
assign weight[361] = 8'he9;
assign weight[362] = 8'hf3;
assign weight[363] = 8'h29;
assign weight[364] = 8'hfd;
assign weight[365] = 8'he2;
assign weight[366] = 8'hde;
assign weight[367] = 8'he8;
assign weight[368] = 8'h11;
assign weight[369] = 8'hfe;
assign weight[370] = 8'h09;
assign weight[371] = 8'hde;
assign weight[372] = 8'hfc;
assign weight[373] = 8'h0c;
assign weight[374] = 8'h39;
assign weight[375] = 8'h04;
assign weight[376] = 8'h0e;
assign weight[377] = 8'hf6;
assign weight[378] = 8'hd7;
assign weight[379] = 8'hea;
assign weight[380] = 8'hc7;
assign weight[381] = 8'h01;
assign weight[382] = 8'h00;
assign weight[383] = 8'h00;
assign weight[384] = 8'h0e;
assign weight[385] = 8'hff;
assign weight[386] = 8'hfa;
assign weight[387] = 8'h07;
assign weight[388] = 8'hf6;
assign weight[389] = 8'hee;
assign weight[390] = 8'h0d;
assign weight[391] = 8'h17;
assign weight[392] = 8'h28;
assign weight[393] = 8'h2a;
assign weight[394] = 8'hf6;
assign weight[395] = 8'he3;
assign weight[396] = 8'hfa;
assign weight[397] = 8'hd0;
assign weight[398] = 8'h0b;
assign weight[399] = 8'h10;
assign weight[400] = 8'he3;
assign weight[401] = 8'h0f;
assign weight[402] = 8'hff;
assign weight[403] = 8'h14;
assign weight[404] = 8'hf9;
assign weight[405] = 8'h0c;
assign weight[406] = 8'h03;
assign weight[407] = 8'h15;
assign weight[408] = 8'hef;
assign weight[409] = 8'hf8;
assign weight[410] = 8'hf4;
assign weight[411] = 8'h12;
assign weight[412] = 8'hd4;
assign weight[413] = 8'hff;
assign weight[414] = 8'h07;
assign weight[415] = 8'h05;
assign weight[416] = 8'hf7;
assign weight[417] = 8'h14;
assign weight[418] = 8'h17;
assign weight[419] = 8'h19;
assign weight[420] = 8'h32;
assign weight[421] = 8'h12;
assign weight[422] = 8'he9;
assign weight[423] = 8'h04;
assign weight[424] = 8'h00;
assign weight[425] = 8'h19;
assign weight[426] = 8'hef;
assign weight[427] = 8'h04;
assign weight[428] = 8'h0b;
assign weight[429] = 8'hed;
assign weight[430] = 8'h00;
assign weight[431] = 8'hec;
assign weight[432] = 8'h16;
assign weight[433] = 8'h28;
assign weight[434] = 8'h0e;
assign weight[435] = 8'hfb;
assign weight[436] = 8'hf4;
assign weight[437] = 8'he9;
assign weight[438] = 8'h0e;
assign weight[439] = 8'h0d;
assign weight[440] = 8'hd1;
assign weight[441] = 8'hc9;
assign weight[442] = 8'hf8;
assign weight[443] = 8'h06;
assign weight[444] = 8'h15;
assign weight[445] = 8'h24;
assign weight[446] = 8'hed;
assign weight[447] = 8'h02;
assign weight[448] = 8'hf3;
assign weight[449] = 8'h0a;
assign weight[450] = 8'h1c;
assign weight[451] = 8'h08;
assign weight[452] = 8'hce;
assign weight[453] = 8'h0a;
assign weight[454] = 8'h07;
assign weight[455] = 8'h0d;
assign weight[456] = 8'h00;
assign weight[457] = 8'h1f;
assign weight[458] = 8'hfd;
assign weight[459] = 8'hca;
assign weight[460] = 8'hf2;
assign weight[461] = 8'h13;
assign weight[462] = 8'he3;
assign weight[463] = 8'hbe;
assign weight[464] = 8'hc4;
assign weight[465] = 8'he0;
assign weight[466] = 8'h09;
assign weight[467] = 8'h01;
assign weight[468] = 8'h01;
assign weight[469] = 8'h16;
assign weight[470] = 8'h1e;
assign weight[471] = 8'hfa;
assign weight[472] = 8'h0a;
assign weight[473] = 8'h0f;
assign weight[474] = 8'h37;
assign weight[475] = 8'hfc;
assign weight[476] = 8'h03;
assign weight[477] = 8'h00;
assign weight[478] = 8'hf1;
assign weight[479] = 8'h09;

assign bias[0] = 8'hf5;
assign bias[1] = 8'h1d;
assign bias[2] = 8'h09;
assign bias[3] = 8'he0;
assign bias[4] = 8'h00;
assign bias[5] = 8'hfb;
assign bias[6] = 8'h07;
assign bias[7] = 8'h05;
assign bias[8] = 8'hf9;
assign bias[9] = 8'hf4;


//integer is_fill = 0;

//always @(*) begin
//if(is_fill == 0) begin
////   $readmemh("C:/Users/DELL/Desktop/cnn/cnn.srcs/sources_1/new/data/fc_weight.txt", weight);
////   $readmemh("C:/Users/DELL/Desktop/cnn/cnn.srcs/sources_1/new/data/fc_bias.txt", bias);

//weight[0] <= 8'hfe;
//...
//weight[479] <= 8'h09;

//bias[0] <= 8'hf5;
//...
//bias[9] <= 8'hf4;

//is_fill <= 1;

// end
// end

 assign data1 = (data_in_1[11] == 1) ? {2'b11, data_in_1} : {2'b00, data_in_1};
 assign data2 = (data_in_2[11] == 1) ? {2'b11, data_in_2} : {2'b00, data_in_2};
 assign data3 = (data_in_3[11] == 1) ? {2'b11, data_in_3} : {2'b00, data_in_3};
 
 always @(posedge clk) begin
   if(~rst_n) begin
     valid_out_fc <= 0;
     buf_idx <= 0;
     out_idx <= 0;
     state <= 0;
   end

   if(valid_out_fc == 1) begin
     valid_out_fc <= 0;
   end

   if(valid_in == 1) begin
     // Wait until 48 input data filled in buffer
     if(!state) begin
       buffer[buf_idx] <= data1;
       buffer[INPUT_WIDTH + buf_idx] <= data2;
       buffer[INPUT_WIDTH * 2 + buf_idx] <= data3;
       buf_idx <= buf_idx + 1'b1;
       if(buf_idx == INPUT_WIDTH - 1) begin
         buf_idx <= 0;
         state <= 1;
         valid_out_fc <= 1;
       end
     end else begin // valid state
       out_idx <= out_idx + 1'b1;
       if(out_idx == OUTPUT_NUM - 1) begin
         out_idx <= 0;
       end
       valid_out_fc <= 1;
     end
   end
 end

 assign calc_out = weight[out_idx * INPUT_NUM] * buffer[0] + weight[out_idx * INPUT_NUM + 1] * buffer[1] + 
		  		weight[out_idx * INPUT_NUM + 2] * buffer[2] + weight[out_idx * INPUT_NUM + 3] * buffer[3] + 
  				weight[out_idx * INPUT_NUM + 4] * buffer[4] + weight[out_idx * INPUT_NUM + 5] * buffer[5] + 
	  			weight[out_idx * INPUT_NUM + 6] * buffer[6] + weight[out_idx * INPUT_NUM + 7] * buffer[7] + 
		  		weight[out_idx * INPUT_NUM + 8] * buffer[8] + weight[out_idx * INPUT_NUM + 9] * buffer[9] + 
  				weight[out_idx * INPUT_NUM + 10] * buffer[10] + weight[out_idx * INPUT_NUM + 11] * buffer[11] + 
  				weight[out_idx * INPUT_NUM + 12] * buffer[12] + weight[out_idx * INPUT_NUM + 13] * buffer[13] + 
	  			weight[out_idx * INPUT_NUM + 14] * buffer[14] + weight[out_idx * INPUT_NUM + 15] * buffer[15] + 
  				weight[out_idx * INPUT_NUM + 16] * buffer[16] + weight[out_idx * INPUT_NUM + 17] * buffer[17] + 
  				weight[out_idx * INPUT_NUM + 18] * buffer[18] + weight[out_idx * INPUT_NUM + 19] * buffer[19] + 
  				weight[out_idx * INPUT_NUM + 20] * buffer[20] + weight[out_idx * INPUT_NUM + 21] * buffer[21] + 
  				weight[out_idx * INPUT_NUM + 22] * buffer[22] + weight[out_idx * INPUT_NUM + 23] * buffer[23] + 
  				weight[out_idx * INPUT_NUM + 24] * buffer[24] + weight[out_idx * INPUT_NUM + 25] * buffer[25] + 
  				weight[out_idx * INPUT_NUM + 26] * buffer[26] + weight[out_idx * INPUT_NUM + 27] * buffer[27] + 
  				weight[out_idx * INPUT_NUM + 28] * buffer[28] + weight[out_idx * INPUT_NUM + 29] * buffer[29] + 
  				weight[out_idx * INPUT_NUM + 30] * buffer[30] + weight[out_idx * INPUT_NUM + 31] * buffer[31] + 
  				weight[out_idx * INPUT_NUM + 32] * buffer[32] + weight[out_idx * INPUT_NUM + 33] * buffer[33] + 
  				weight[out_idx * INPUT_NUM + 34] * buffer[34] + weight[out_idx * INPUT_NUM + 35] * buffer[35] + 
  				weight[out_idx * INPUT_NUM + 36] * buffer[36] + weight[out_idx * INPUT_NUM + 37] * buffer[37] + 
  				weight[out_idx * INPUT_NUM + 38] * buffer[38] + weight[out_idx * INPUT_NUM + 39] * buffer[39] + 
	  			weight[out_idx * INPUT_NUM + 40] * buffer[40] + weight[out_idx * INPUT_NUM + 41] * buffer[41] + 
	  			weight[out_idx * INPUT_NUM + 42] * buffer[42] + weight[out_idx * INPUT_NUM + 43] * buffer[43] + 
	  			weight[out_idx * INPUT_NUM + 44] * buffer[44] + weight[out_idx * INPUT_NUM + 45] * buffer[45] + 
  				weight[out_idx * INPUT_NUM + 46] * buffer[46] + weight[out_idx * INPUT_NUM + 47] * buffer[47] + 
  				bias[out_idx];
  				
 assign data_out = calc_out[18:7];

 endmodule
 
//    integer step;
//    reg [19:0] result1[0:3];
//    reg [19:0] result2;
 
//    always @(posedge clk) begin
//        if (~rst_n) begin
//            valid_out_fc <= 0;
//            buf_idx <= 0;
//            out_idx <= 0;
//            state <= 0;
//            step <= 0;
//            delay <= 0;
//            end
 
//        if (valid_out_fc == 1) begin
//            valid_out_fc <= 0;
//            step <= 0;
//            end
 
//        if (valid_in == 1) begin
//            // Wait until 48 input data filled in buffer
//            if (!state) begin
//                buffer[buf_idx] <= data1;
//                buffer[INPUT_WIDTH + buf_idx] <= data2;
//                buffer[INPUT_WIDTH * 2 + buf_idx] <= data3;
//                buf_idx <= buf_idx + 1'b1;
//                if(buf_idx == INPUT_WIDTH - 1) begin
//                    buf_idx <= 0;
//                    state <= 1;
//                    step <= 0;
//                    delay <= 1;
////                    valid_out_fc <= 1;
//                    end
//                end 
//            else begin // valid state
                
//                result1[step] <= weight[out_idx * INPUT_NUM + step * 12] * buffer[0 + step * 12] + weight[out_idx * INPUT_NUM + 1 + step * 12] * buffer[1 + step * 12] 
//                    + weight[out_idx * INPUT_NUM + 2 + step * 12] * buffer[2 + step * 12] + weight[out_idx * INPUT_NUM + 3 + step * 12] * buffer[3 + step * 12] 
//                    + weight[out_idx * INPUT_NUM + 4 + step * 12] * buffer[4 + step * 12] + weight[out_idx * INPUT_NUM + 5 + step * 12] * buffer[5 + step * 12] 
//                    + weight[out_idx * INPUT_NUM + 6 + step * 12] * buffer[6 + step * 12] + weight[out_idx * INPUT_NUM + 7 + step * 12] * buffer[7 + step * 12] 
//                    + weight[out_idx * INPUT_NUM + 8 + step * 12] * buffer[8 + step * 12] + weight[out_idx * INPUT_NUM + 9 + step * 12] * buffer[9 + step * 12] 
//                    + weight[out_idx * INPUT_NUM + 10 + step * 12] * buffer[10 + step * 12] + weight[out_idx * INPUT_NUM + 11 + step * 12] * buffer[11 + step * 12];

//                if (step == 3) begin
//                    result2 <= result1[0] + result1[1] + result1[2] + result1[3] + bias[out_idx];
//                    step <= 0;
//                    delay <= 0;
//                    out_idx <= out_idx + 1'b1;
//                    if (out_idx == OUTPUT_NUM - 1) begin
//                        out_idx <= 0;
//                        end
//                    valid_out_fc <= 1;
//                    end
//                else
//                    step <= step + 1;
                    
//                end 
//            end
//        end
                   
//  assign data_out = result2[18:7];
 
//  endmodule