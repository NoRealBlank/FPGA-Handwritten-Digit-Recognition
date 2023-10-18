`timescale 1ns / 1ps

module mp3_driver #(parameter MUSIC_SIZE = 25112) (
    input mp3_clk,
    input rst,
    input [3:0] decision,       
    input DREQ,
    output reg xRSET = 0,
    output reg xCS = 1,
    output reg xDCS = 1,
    output reg MOSI,
    output reg SCLK = 0
    );

reg [1:0] music_over;

reg [14:0] mp3_addr;
wire [31:0] mp3_data_all[0:10];
    
localparam  RESET = 0,
            CMD_CONTROL = 1,
            CMD_SEND = 2,
            DATA_CONTROL = 3,
            DATA_SEND = 4;

reg [2:0] state = RESET;

reg [31:0] mp3_data, mp3_data0;

localparam  cmd_mode = 32'h02000804,
            cmd_vol = 32'h020B1010,
            cmd_bass = 32'h02020055,
            cmd_clock = 32'h02039800;

reg [127:0] cmd = {cmd_mode, cmd_vol, cmd_bass, cmd_clock};
reg [2:0] cmd_id;
reg [5:0] cnt;

//reg music_over=0;

localparam CMD_NUM = 4;

always @(posedge mp3_clk or posedge rst) begin
    if (rst == 1) begin
        state<=RESET;
        music_over <= 2'b00;
        end 
    else if (music_over == 2'b00 || music_over == 2'b01) begin
        if (state == RESET) begin
            cmd <= {cmd_mode, cmd_vol, cmd_bass, cmd_clock};
            mp3_addr <= 0;
            cmd_id <= 0;
            cnt <= 0;
            xCS <= 1;
            xDCS <= 1;
            xRSET <= 0;
            SCLK <= 0;
                        
            if (rst == 0)
                state <= CMD_CONTROL;
            else
                state <= RESET;          
            end

        else if (state == CMD_CONTROL) begin
            xRSET <= 1;
            if (cmd_id < CMD_NUM && DREQ) begin
                cmd_id <= cmd_id + 1;
                xCS <= 0;
                MOSI <= cmd[127];
                cmd <= {cmd[126:0], cmd[127]};
                cnt <= 1;
                state <= CMD_SEND;
                end
            else begin
                cmd_id <= 0;
                state <= DATA_CONTROL;
                end
            end

        else if (state == CMD_SEND) begin
            if (DREQ) begin
                if(SCLK) begin
                    if(cnt < 32) begin
                        cnt <= cnt + 1;
                        MOSI <= cmd[127];
                        cmd <= {cmd[126:0], cmd[127]};
                        end
                    else begin
                        xCS <= 1;
                        cnt <= 0;
                        state <= CMD_CONTROL;
                        end
                    end
                SCLK <= ~SCLK;
                end
            end

        else if(state == DATA_CONTROL) begin
            if(mp3_addr >= MUSIC_SIZE) begin
                state <= RESET;
                music_over <= music_over + 1'b1;
                //DCS<=1;
                end
            else if (DREQ) begin
                //music_over<=0;
                xDCS <= 0;
                SCLK <= 0;
                
                if (music_over == 2'b00)
                    mp3_data0 <= mp3_data_all[10];
                else if (music_over == 2'b01)
                    mp3_data0 <= mp3_data_all[decision];
                
                MOSI <= mp3_data0[31];
                mp3_data <= {mp3_data0[30:0], mp3_data0[31]};
                cnt <= 1;
                state <= DATA_SEND;
                end
            end

        else if(state == DATA_SEND) begin
            if (DREQ) begin
                if (SCLK) begin
                    if (cnt < 32) begin
                        MOSI <= mp3_data[31];
                        cnt <= cnt + 1;
                        mp3_data <= {mp3_data[30:0], mp3_data[31]};
                        end
                    else begin
                        xDCS <= 1;
                        cnt <= 0;
                        mp3_addr <= mp3_addr + 1;
                        state <= DATA_CONTROL;
                        end
                    end
                SCLK <= ~SCLK;
                end
            end

        else
            state <= RESET;
        end
    end

    blk_mem_gen_0 mic_tips (.clka(mp3_clk), .ena(~rst), .addra(mp3_addr), .douta(mp3_data_all[10]));    
    blk_mem_gen_1 num_0 (.clka(mp3_clk), .ena(~rst), .addra(mp3_addr[12:0]), .douta(mp3_data_all[0]));                                
    blk_mem_gen_2 num_1 (.clka(mp3_clk), .ena(~rst), .addra(mp3_addr[12:0]), .douta(mp3_data_all[1]));                    
    blk_mem_gen_3 num_2 (.clka(mp3_clk), .ena(~rst), .addra(mp3_addr[12:0]), .douta(mp3_data_all[2]));                   
    blk_mem_gen_4 num_3 (.clka(mp3_clk), .ena(~rst), .addra(mp3_addr[12:0]), .douta(mp3_data_all[3]));                    
    blk_mem_gen_5 num_4 (.clka(mp3_clk), .ena(~rst), .addra(mp3_addr[12:0]), .douta(mp3_data_all[4]));                    
    blk_mem_gen_6 num_5 (.clka(mp3_clk), .ena(~rst), .addra(mp3_addr[12:0]), .douta(mp3_data_all[5]));                   
    blk_mem_gen_7 num_6 (.clka(mp3_clk), .ena(~rst), .addra(mp3_addr[12:0]), .douta(mp3_data_all[6]));                    
    blk_mem_gen_8 num_7 (.clka(mp3_clk), .ena(~rst), .addra(mp3_addr[12:0]), .douta(mp3_data_all[7]));            
    blk_mem_gen_9 num_8 (.clka(mp3_clk), .ena(~rst), .addra(mp3_addr[12:0]), .douta(mp3_data_all[8]));
    blk_mem_gen_10 num_9 (.clka(mp3_clk), .ena(~rst), .addra(mp3_addr[12:0]), .douta(mp3_data_all[9]));     
    
endmodule
