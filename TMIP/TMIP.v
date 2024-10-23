//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   2021 ICLAB Spring Course
//   Lab03          : Template Matching with Image Processing (TMIP)
//   Author         : CHAN-HAO LIAO (jericc880417@gmail.com)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   File Name   : TMIP.v
//   Module Name : TMIP
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

//synopsys translate_off
 `include "/home/lab911_1/Desktop/7112064131/IClab2021/ICLAB_05/RA2SH.v"
//synopsys translate_on
module TMIP(
           // input signals
           clk,
           rst_n,
           in_valid,
           in_valid_2,
           image,
           img_size,
           template,
           action,

           // output signals
           out_valid,
           out_x,
           out_y,
           out_img_pos,
           out_value
       );
input clk, rst_n, in_valid, in_valid_2;
input [15:0] image, template;
input [4:0]  img_size;
input [1:0]  action;
output reg        out_valid;
output reg [3:0]  out_x, out_y;
output reg [7:0]  out_img_pos;
output reg signed [39:0] out_value;

/////////////////////////////////////////////////////////////

wire SRAM1_cen = 1'd0   ;
wire SRAM1_oen = 1'd0   ;
wire SRAM1_wen 			;
reg  [7:0] SRAM_a       ;
wire [39:0] SRAM1_out   ;

wire [9:0] a ;

wire skip4, skip8, skip16                      ;
wire skip4_column, skip8_column, skip16_column ;
wire skip_back                                 ;
wire size4_finish, size8_finish, size16_finish ;
wire size4_out, size8_out, size16_out      	   ;

wire size8_3x3, size16_3x3                     ;

reg [1:0] current_action                       ;
reg [1:0] action_history 		 [0:7]         ;
reg [2:0] counter_action                       ;
reg [2:0] current_counter_action               ;
reg [3:0] counter_store_data                   ;
reg [4:0] current_size                         ;
reg [9:0] counter_image                        ;

reg signed [15:0] current_image                ;
reg signed [15:0] store_image    [0:323]       ;
reg signed [15:0] store_template [0:8]         ;
reg signed [39:0] add_action0                  ;
wire signed [39:0] mul_action0                 ;

reg [1:0] counter_size4_skip                   ;
reg [2:0] counter_size8_skip                   ;
reg [3:0] counter_size16_skip                  ;

reg [2:0] counter_size4_column                 ;
reg [3:0] counter_size8_column                 ;
reg [4:0] counter_size16_column                ;

reg [1:0] size_skip                            ;
reg [3:0] size_back                            ;
reg [8:0] number_action0                       ;

reg signed [39:0] max_number                   ;
reg [3:0] size_max_x, size_max_y               ;
reg [3:0] max_x, max_y 						   ;
reg [7:0] current_pos                          ;
reg [8:0] counter_out                          ;

reg [3:0] counter_size4_action3                ;
reg [5:0] counter_size8_action3                ;
reg [7:0] counter_size16_action3               ;

reg skip_action1                               ;
reg [1:0] back_action1                         ;
reg [1:0] total_size8_action1                  ;
reg [2:0] total_size16_action1                 ;
reg [3:0] counter_size8_sub                    ;
reg [5:0] counter_size8_action1                ;
reg [7:0] counter_size16_action1               ;
reg [6:0] number_size8_action1                 ;
reg [8:0] number_size16_action1                ;
wire signed [39:0] max_action1                 ;



reg [3:0] Current_state, Next_state            ;
parameter IDLE 			  = 4'd0               ;
parameter Read_data	      = 4'd1               ;
parameter Read_action     = 4'd2               ;
parameter Decide_action   = 4'd3               ;
parameter Action_0        = 4'd4               ;
parameter Action_1        = 4'd5               ;
parameter Action_2        = 4'd6               ;
parameter Action_3        = 4'd7               ;
parameter Action_0_store  = 4'd8               ;
parameter Delay_out       = 4'd9			   ;
parameter Max_pooling_sub = 4'd10              ;
parameter Out_data        = 4'd11              ;
parameter Reset_data      = 4'd12              ;

integer i 								       ;

//////////////////////////////////////////////////////////////////////////////
//     state change
//////////////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        Current_state <= IDLE ;
    end else
    begin
        Current_state <= Next_state ;
    end
end

always @(*)
begin
    case (Current_state)
        IDLE:
            Next_state = (in_valid)? Read_data : IDLE ;
        Read_data:
            Next_state = (in_valid)? Read_data : Read_action ;
        Read_action:
            Next_state = (in_valid_2)? Read_action : Decide_action ;
        Decide_action:
        begin
            case (current_action)
                2'd0:
                    Next_state = Action_0    ;
                2'd1:
                    Next_state = Action_1    ;
                2'd2:
                    Next_state = Action_2    ;
                2'd3:
                    Next_state = Action_3    ;
            endcase
        end
        Action_0:
            Next_state = (size_back == 4'd8)? Action_0_store : Action_0 ;
        Action_1:
        begin
            if (current_size == 5'd4)
                Next_state = Decide_action ;
            else if (counter_size8_action1 == 6'd63)
                Next_state = Max_pooling_sub ;
            else if (counter_size16_action1 == 8'd255)
                Next_state = Max_pooling_sub ;
            else
                Next_state = Action_1 ;
        end
        Action_2:
            Next_state = Decide_action ;
        Action_3:
            Next_state = (counter_size4_action3 == 4'd15 || counter_size8_action3 == 6'd63 || counter_size16_action3 == 8'd255)? Decide_action : Action_3 ;
        Action_0_store:
            Next_state = (size4_out || size8_out || size16_out)? Delay_out : Action_0 ;
        Delay_out:
            Next_state = Out_data ;
        Max_pooling_sub:
            Next_state = Decide_action ;
        Out_data:
            Next_state = (size4_finish || size8_finish || size16_finish)? Reset_data : Out_data ;
        Reset_data:
            Next_state = IDLE ;
        default:
            Next_state = IDLE ;
    endcase
end

//////////////////////////////////////////////////////////////////////////////
//     history for action
//////////////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        counter_action <= 3'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            counter_action <= 3'd0 ;
        end
        else if (Current_state == Read_action)
        begin
            counter_action <=  counter_action + 1'd1 ;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        for (i=0; i<8; i=i+1)
        begin
            action_history[i] <= 2'd0 ;
        end
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            for (i=0; i<8; i=i+1)
            begin
                action_history[i] <= 2'd0 ;
            end
        end
        else if (Current_state == Read_action)
        begin
            action_history[counter_action] <= action ;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        current_counter_action <= 3'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            current_counter_action <= 3'd1 ;
        end
        else if (Current_state == Decide_action)
        begin
            current_counter_action <= current_counter_action + 1'd1 ;
        end
    end
end


always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        current_action <= 2'd0 ;
    end
    else
    begin
        if (Current_state == Decide_action)
        begin
            current_action <= action_history[current_counter_action] ;
        end
        else if (Current_state == Read_action)
        begin
            current_action <= action_history[0] ;
        end
    end
end

//////////////////////////////////////////////////////////////////////////////
//     current size
//////////////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        current_size <= 5'd0 ;
    end
    else
    begin
        if (in_valid && counter_store_data == 4'd0)
        begin
            current_size <= img_size ;
        end
        else if (Current_state == Max_pooling_sub)
        begin
            current_size <= current_size >> 1 ;
        end
    end
end

//////////////////////////////////////////////////////////////////////////////
//     counter for size 4 8 16 skip number
//////////////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        counter_size4_skip <= 2'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            counter_size4_skip <= 2'd0 ;
        end
        else if (Current_state == Read_data && current_size == 5'd4 || Current_state == Action_3)
        begin
            counter_size4_skip <= counter_size4_skip + 1'd1 ;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        counter_size8_skip <= 3'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            counter_size8_skip <= 3'd0 ;
        end
        else if (Current_state == Read_data && current_size == 5'd8 || Current_state == Action_3)
        begin
            counter_size8_skip <= counter_size8_skip + 1'd1 ;
        end
        else if (Current_state == Action_1 && back_action1 == 2'd0)
        begin
            counter_size8_skip <= counter_size8_skip + 1'd1 ;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        counter_size16_skip <= 4'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            counter_size16_skip <= 4'd0 ;
        end
        else if (Current_state == Read_data && current_size == 5'd16 || Current_state == Action_3)
        begin
            counter_size16_skip <= counter_size16_skip + 1'd1 ;
        end
    end
end

assign skip4 = (((Current_state != Action_1) && current_size == 5'd4 && counter_size4_skip == 2'd3) || (Current_state == Action_1 && current_size == 5'd8 && counter_size8_sub == 4'd0))? 1'd1 : 1'd0 ;
assign skip8 = (((Current_state != Action_1) && current_size == 5'd8 && counter_size8_skip == 3'd7) || (current_size == 5'd16 && Current_state == Action_1 && counter_size8_skip == 3'd0 && back_action1 == 3'd0))? 1'd1 : 1'd0 ;
assign skip16 = ((Current_state != Action_1) &&current_size == 5'd16 && counter_size16_skip == 4'd15)? 1'd1 : 1'd0 ;

//////////////////////////////////////////////////////////////////////////////
//     counter for image && store image
//////////////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        counter_image <= 9'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            counter_image <= 9'd0 ;
        end
        else if ((in_valid && img_size == 5'd4) || (Current_state == Decide_action && current_size == 5'd4 || (Current_state == Action_1 && current_size == 5'd8 && counter_size8_action1 == 6'd0)))
        begin
            counter_image <= 9'd7 ;
        end
        else if ((in_valid && img_size == 5'd8) || (Current_state == Decide_action && current_size == 5'd8 || (Current_state == Action_1 && current_size == 5'd16 && counter_size16_action1 == 8'd0)))
        begin
            counter_image <= 9'd11 ;
        end
        else if ((in_valid && img_size == 5'd16) || (Current_state == Decide_action && current_size == 5'd16))
        begin
            counter_image <= 9'd19 ;
        end
        else if (Current_state == Decide_action)
        begin
            counter_image <= 9'd0 ;
        end
        else if (skip4 || skip8 || skip16)
        begin
            counter_image <= counter_image + 9'd3 ;
        end
        else if (Current_state == Read_data || Current_state == Action_3 || (Current_state == Action_1 && back_action1 == 2'd0))
        begin
            counter_image <= counter_image + 9 'd1 ;
        end

    end
end

//////////////////////////////////////////////////////////////////////////////
//     counter for template && store template && store image
//////////////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        current_image <= 15'd0 ;
    end
    else
    begin
        if (in_valid)
        begin
            current_image <= image ;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        for (i=0; i<324; i=i+1)
        begin
            store_image[i] <= 16'd0 ;
        end
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            for (i=0; i<324; i=i+1)
            begin
                store_image[i] <= 16'd0 ;
            end
        end
        else if (Current_state == Read_data)
        begin
            store_image[counter_image] <= current_image ;
        end
        else if (Current_state == Action_1 && back_action1 == 2'd0 && (current_size == 5'd8 || current_size == 5'd16))
        begin
            store_image[counter_image] <= max_number ;
        end
        else if (Current_state == Max_pooling_sub && current_size == 5'd8)
        begin
            store_image[counter_image] <= max_number ;
            store_image[6] <= 16'd0 ;
            store_image[12] <= 16'd0 ;
            store_image[18] <= 16'd0 ;
            store_image[24] <= 16'd0 ;
            store_image[30] <= 16'd0 ;
            store_image[11] <= 16'd0 ;
            store_image[17] <= 16'd0 ;
            store_image[23] <= 16'd0 ;
            store_image[29] <= 16'd0 ;
            store_image[30] <= 16'd0 ;
            store_image[31] <= 16'd0 ;
            store_image[32] <= 16'd0 ;
            store_image[33] <= 16'd0 ;
            store_image[34] <= 16'd0 ;
            store_image[35] <= 16'd0 ;
        end
        else if (Current_state == Max_pooling_sub && current_size == 5'd16)
        begin
            store_image[counter_image] <= max_number ;
            store_image[10] <= 16'd0 ;
            store_image[20] <= 16'd0 ;
            store_image[30] <= 16'd0 ;
            store_image[40] <= 16'd0 ;
            store_image[50] <= 16'd0 ;
            store_image[60] <= 16'd0 ;
            store_image[70] <= 16'd0 ;
            store_image[80] <= 16'd0 ;
            store_image[90] <= 16'd0 ;
            store_image[19] <= 16'd0 ;
            store_image[29] <= 16'd0 ;
            store_image[39] <= 16'd0 ;
            store_image[49] <= 16'd0 ;
            store_image[59] <= 16'd0 ;
            store_image[69] <= 16'd0 ;
            store_image[79] <= 16'd0 ;
            store_image[89] <= 16'd0 ;
            store_image[99] <= 16'd0 ;
            store_image[91] <= 16'd0 ;
            store_image[92] <= 16'd0 ;
            store_image[93] <= 16'd0 ;
            store_image[94] <= 16'd0 ;
            store_image[95] <= 16'd0 ;
            store_image[96] <= 16'd0 ;
            store_image[97] <= 16'd0 ;
            store_image[98] <= 16'd0 ;
            store_image[99] <= 16'd0 ;
        end
        else if (Current_state == Action_3)
        begin
            store_image[counter_image] <= ((store_image[counter_image] >>> 1) + $signed(16'd50)) ;
        end
        else if (Current_state == Action_2 && current_size == 5'd4)
        begin
            store_image[7] <= store_image[10]  ;
            store_image[13] <= store_image[16] ;
            store_image[19] <= store_image[22] ;
            store_image[25] <= store_image[28] ;

            store_image[10] <= store_image[7]  ;
            store_image[16] <= store_image[13] ;
            store_image[22] <= store_image[19] ;
            store_image[28] <= store_image[25] ;

            store_image[8] <= store_image[9]   ;
            store_image[14] <= store_image[15] ;
            store_image[20] <= store_image[21] ;
            store_image[26] <= store_image[27] ;

            store_image[9] <= store_image[8]   ;
            store_image[15] <= store_image[14] ;
            store_image[21] <= store_image[20] ;
            store_image[27] <= store_image[26] ;
        end
        else if (Current_state == Action_2 && current_size == 5'd8)
        begin
            store_image[11] <= store_image[18] ;
            store_image[21] <= store_image[28] ;
            store_image[31] <= store_image[38] ;
            store_image[41] <= store_image[48] ;
            store_image[51] <= store_image[58] ;
            store_image[61] <= store_image[68] ;
            store_image[71] <= store_image[78] ;
            store_image[81] <= store_image[88] ;

            store_image[18] <= store_image[11] ;
            store_image[28] <= store_image[21] ;
            store_image[38] <= store_image[31] ;
            store_image[48] <= store_image[41] ;
            store_image[58] <= store_image[51] ;
            store_image[68] <= store_image[61] ;
            store_image[78] <= store_image[71] ;
            store_image[88] <= store_image[81] ;

            store_image[12] <= store_image[17] ;
            store_image[22] <= store_image[27] ;
            store_image[32] <= store_image[37] ;
            store_image[42] <= store_image[47] ;
            store_image[52] <= store_image[57] ;
            store_image[62] <= store_image[67] ;
            store_image[72] <= store_image[77] ;
            store_image[82] <= store_image[87] ;

            store_image[17] <= store_image[12] ;
            store_image[27] <= store_image[22] ;
            store_image[37] <= store_image[32] ;
            store_image[47] <= store_image[42] ;
            store_image[57] <= store_image[52] ;
            store_image[67] <= store_image[62] ;
            store_image[77] <= store_image[72] ;
            store_image[87] <= store_image[82] ;

            store_image[13] <= store_image[16] ;
            store_image[23] <= store_image[26] ;
            store_image[33] <= store_image[36] ;
            store_image[43] <= store_image[46] ;
            store_image[53] <= store_image[56] ;
            store_image[63] <= store_image[66] ;
            store_image[73] <= store_image[76] ;
            store_image[83] <= store_image[86] ;

            store_image[16] <= store_image[13] ;
            store_image[26] <= store_image[23] ;
            store_image[36] <= store_image[33] ;
            store_image[46] <= store_image[43] ;
            store_image[56] <= store_image[53] ;
            store_image[66] <= store_image[63] ;
            store_image[76] <= store_image[73] ;
            store_image[86] <= store_image[83] ;

            store_image[14] <= store_image[15] ;
            store_image[24] <= store_image[25] ;
            store_image[34] <= store_image[35] ;
            store_image[44] <= store_image[45] ;
            store_image[54] <= store_image[55] ;
            store_image[64] <= store_image[65] ;
            store_image[74] <= store_image[75] ;
            store_image[84] <= store_image[85] ;

            store_image[15] <= store_image[14] ;
            store_image[25] <= store_image[24] ;
            store_image[35] <= store_image[34] ;
            store_image[45] <= store_image[44] ;
            store_image[55] <= store_image[54] ;
            store_image[65] <= store_image[64] ;
            store_image[75] <= store_image[74] ;
            store_image[85] <= store_image[84] ;
        end
        else if (Current_state == Action_2 && current_size == 5'd16)
        begin
            store_image[19] <= store_image[34]  ;
            store_image[37] <= store_image[52] ;
            store_image[55] <= store_image[70] ;
            store_image[73] <= store_image[88] ;
            store_image[91] <= store_image[106]  ;
            store_image[109] <= store_image[124] ;
            store_image[127] <= store_image[142] ;
            store_image[145] <= store_image[160] ;
            store_image[163] <= store_image[178]   ;
            store_image[181] <= store_image[196] ;
            store_image[199] <= store_image[214] ;
            store_image[217] <= store_image[232] ;
            store_image[235] <= store_image[250]   ;
            store_image[253] <= store_image[268] ;
            store_image[271] <= store_image[286] ;
            store_image[289] <= store_image[304] ;

            store_image[34] <= store_image[19]  ;
            store_image[52] <= store_image[37] ;
            store_image[70] <= store_image[55] ;
            store_image[88] <= store_image[73] ;
            store_image[106] <= store_image[91] ;
            store_image[124] <= store_image[109] ;
            store_image[142] <= store_image[127] ;
            store_image[160] <= store_image[145] ;
            store_image[178] <= store_image[163]  ;
            store_image[196] <= store_image[181] ;
            store_image[214] <= store_image[199] ;
            store_image[232] <= store_image[217] ;
            store_image[250] <= store_image[235]  ;
            store_image[268] <= store_image[253] ;
            store_image[286] <= store_image[271] ;
            store_image[304] <= store_image[289] ;

            store_image[19] <= store_image[34]  ;
            store_image[37] <= store_image[52] ;
            store_image[55] <= store_image[70] ;
            store_image[73] <= store_image[88] ;
            store_image[91] <= store_image[106]  ;
            store_image[109] <= store_image[124] ;
            store_image[127] <= store_image[142] ;
            store_image[145] <= store_image[160] ;
            store_image[163] <= store_image[178]   ;
            store_image[181] <= store_image[196] ;
            store_image[199] <= store_image[214] ;
            store_image[217] <= store_image[232] ;
            store_image[235] <= store_image[250]   ;
            store_image[253] <= store_image[268] ;
            store_image[271] <= store_image[286] ;
            store_image[289] <= store_image[304] ;

            store_image[20] <= store_image[33]  ;
            store_image[38] <= store_image[51] ;
            store_image[56] <= store_image[69] ;
            store_image[74] <= store_image[87] ;
            store_image[92] <= store_image[105] ;
            store_image[110] <= store_image[123] ;
            store_image[128] <= store_image[141] ;
            store_image[146] <= store_image[159] ;
            store_image[164] <= store_image[177]  ;
            store_image[182] <= store_image[195] ;
            store_image[200] <= store_image[213] ;
            store_image[218] <= store_image[231] ;
            store_image[236] <= store_image[249]  ;
            store_image[254] <= store_image[267] ;
            store_image[272] <= store_image[285] ;
            store_image[290] <= store_image[303] ;

            store_image[33]  <= store_image[20];
            store_image[51]  <= store_image[38];
            store_image[69]  <= store_image[56];
            store_image[87]  <= store_image[74];
            store_image[105] <= store_image[92];
            store_image[123] <= store_image[110] ;
            store_image[141] <= store_image[128] ;
            store_image[159] <= store_image[146] ;
            store_image[177] <= store_image[164]  ;
            store_image[195] <= store_image[182] ;
            store_image[213] <= store_image[200] ;
            store_image[231] <= store_image[218] ;
            store_image[249] <= store_image[236]  ;
            store_image[267] <= store_image[254] ;
            store_image[285] <= store_image[272] ;
            store_image[303] <= store_image[290] ;

            store_image[21] <= store_image[32]  ;
            store_image[39] <= store_image[50] ;
            store_image[57] <= store_image[68] ;
            store_image[75] <= store_image[86] ;
            store_image[93] <= store_image[104] ;
            store_image[111] <= store_image[122] ;
            store_image[129] <= store_image[140] ;
            store_image[147] <= store_image[158] ;
            store_image[165] <= store_image[176]  ;
            store_image[183] <= store_image[194] ;
            store_image[201] <= store_image[212] ;
            store_image[219] <= store_image[230] ;
            store_image[237] <= store_image[248]  ;
            store_image[255] <= store_image[266] ;
            store_image[273] <= store_image[284] ;
            store_image[291] <= store_image[302] ;

            store_image[32]  <= store_image[21]  ;
            store_image[50]  <= store_image[39] ;
            store_image[68]  <= store_image[57] ;
            store_image[86]  <= store_image[75] ;
            store_image[104] <= store_image[93]  ;
            store_image[122] <= store_image[111]  ;
            store_image[140] <= store_image[129]  ;
            store_image[158] <= store_image[147]  ;
            store_image[176] <= store_image[165]   ;
            store_image[194] <= store_image[183]  ;
            store_image[212] <= store_image[201]  ;
            store_image[230] <= store_image[219]  ;
            store_image[248] <= store_image[237]   ;
            store_image[266] <= store_image[255]  ;
            store_image[284] <= store_image[273]  ;
            store_image[302] <= store_image[291]  ;

            store_image[22]  <= store_image[31]  ;
            store_image[40]  <= store_image[49] ;
            store_image[58]  <= store_image[67] ;
            store_image[76]  <= store_image[85] ;
            store_image[94]  <= store_image[103] ;
            store_image[112] <= store_image[121] ;
            store_image[130] <= store_image[139] ;
            store_image[148] <= store_image[157] ;
            store_image[166] <= store_image[175]  ;
            store_image[184] <= store_image[193] ;
            store_image[202] <= store_image[211] ;
            store_image[220] <= store_image[229] ;
            store_image[238] <= store_image[247]  ;
            store_image[256] <= store_image[265] ;
            store_image[274] <= store_image[283] ;
            store_image[292] <= store_image[301] ;

            store_image[31]  <= store_image[22] ;
            store_image[49]  <= store_image[40] ;
            store_image[67]  <= store_image[58] ;
            store_image[85]  <= store_image[76] ;
            store_image[103] <= store_image[94] ;
            store_image[121] <= store_image[112] ;
            store_image[139] <= store_image[130] ;
            store_image[157] <= store_image[148] ;
            store_image[175] <= store_image[166]  ;
            store_image[193] <= store_image[184] ;
            store_image[211] <= store_image[202] ;
            store_image[229] <= store_image[220] ;
            store_image[247] <= store_image[238]  ;
            store_image[265] <= store_image[256] ;
            store_image[283] <= store_image[274] ;
            store_image[301] <= store_image[292] ;

            store_image[23]  <= store_image[30]  ;
            store_image[41]  <= store_image[48] ;
            store_image[59]  <= store_image[66] ;
            store_image[77]  <= store_image[84] ;
            store_image[95]  <= store_image[102] ;
            store_image[113] <= store_image[120] ;
            store_image[131] <= store_image[138] ;
            store_image[149] <= store_image[156] ;
            store_image[167] <= store_image[174]  ;
            store_image[185] <= store_image[192] ;
            store_image[203] <= store_image[210] ;
            store_image[221] <= store_image[228] ;
            store_image[239] <= store_image[246]  ;
            store_image[257] <= store_image[264] ;
            store_image[275] <= store_image[282] ;
            store_image[293] <= store_image[300] ;

            store_image[30]  <= store_image[23] ;
            store_image[48]  <= store_image[41];
            store_image[66]  <= store_image[59];
            store_image[84]  <= store_image[77];
            store_image[102] <= store_image[95] ;
            store_image[120] <= store_image[113] ;
            store_image[138] <= store_image[131] ;
            store_image[156] <= store_image[149] ;
            store_image[174] <= store_image[167]  ;
            store_image[192] <= store_image[185] ;
            store_image[210] <= store_image[203] ;
            store_image[228] <= store_image[221] ;
            store_image[246] <= store_image[239]  ;
            store_image[264] <= store_image[257] ;
            store_image[282] <= store_image[275] ;
            store_image[300] <= store_image[293] ;

            store_image[24]  <= store_image[29]  ;
            store_image[42]  <= store_image[47] ;
            store_image[60]  <= store_image[65] ;
            store_image[78]  <= store_image[83] ;
            store_image[96]  <= store_image[101] ;
            store_image[114] <= store_image[119] ;
            store_image[132] <= store_image[137] ;
            store_image[150] <= store_image[155] ;
            store_image[168] <= store_image[173]  ;
            store_image[186] <= store_image[191] ;
            store_image[204] <= store_image[209] ;
            store_image[222] <= store_image[227] ;
            store_image[240] <= store_image[245]  ;
            store_image[258] <= store_image[263] ;
            store_image[276] <= store_image[281] ;
            store_image[294] <= store_image[299] ;

            store_image[29]  <= store_image[24] ;
            store_image[47]  <= store_image[42];
            store_image[65]  <= store_image[60];
            store_image[83]  <= store_image[78];
            store_image[101] <= store_image[96] ;
            store_image[119] <= store_image[114] ;
            store_image[137] <= store_image[132] ;
            store_image[155] <= store_image[150] ;
            store_image[173] <= store_image[168]  ;
            store_image[191] <= store_image[186] ;
            store_image[209] <= store_image[204] ;
            store_image[227] <= store_image[222] ;
            store_image[245] <= store_image[240]  ;
            store_image[263] <= store_image[258] ;
            store_image[281] <= store_image[276] ;
            store_image[299] <= store_image[294] ;

            store_image[25]  <= store_image[28]  ;
            store_image[43]  <= store_image[46] ;
            store_image[61]  <= store_image[64] ;
            store_image[79]  <= store_image[82] ;
            store_image[97]  <= store_image[100] ;
            store_image[115] <= store_image[118] ;
            store_image[133] <= store_image[136] ;
            store_image[151] <= store_image[154] ;
            store_image[169] <= store_image[172]  ;
            store_image[187] <= store_image[190] ;
            store_image[205] <= store_image[208] ;
            store_image[223] <= store_image[226] ;
            store_image[241] <= store_image[244]  ;
            store_image[259] <= store_image[262] ;
            store_image[277] <= store_image[280] ;
            store_image[295] <= store_image[298] ;

            store_image[28]  <= store_image[25]  ;
            store_image[46]  <= store_image[43] ;
            store_image[64]  <= store_image[61] ;
            store_image[82]  <= store_image[79] ;
            store_image[100] <= store_image[97]  ;
            store_image[118] <= store_image[115]  ;
            store_image[136] <= store_image[133]  ;
            store_image[154] <= store_image[151]  ;
            store_image[172] <= store_image[169]   ;
            store_image[190] <= store_image[187]  ;
            store_image[208] <= store_image[205]  ;
            store_image[226] <= store_image[223]  ;
            store_image[244] <= store_image[241]   ;
            store_image[262] <= store_image[259]  ;
            store_image[280] <= store_image[277]  ;
            store_image[298] <= store_image[295]  ;

            store_image[26]  <= store_image[27]  ;
            store_image[44]  <= store_image[45] ;
            store_image[62]  <= store_image[63] ;
            store_image[80]  <= store_image[81] ;
            store_image[98]  <= store_image[99] ;
            store_image[116] <= store_image[117] ;
            store_image[134] <= store_image[135] ;
            store_image[152] <= store_image[153] ;
            store_image[170] <= store_image[171]  ;
            store_image[188] <= store_image[189] ;
            store_image[206] <= store_image[207] ;
            store_image[224] <= store_image[225] ;
            store_image[242] <= store_image[243]  ;
            store_image[260] <= store_image[261] ;
            store_image[278] <= store_image[279] ;
            store_image[296] <= store_image[297] ;

            store_image[27]  <= store_image[26]  ;
            store_image[45]  <= store_image[44] ;
            store_image[63]  <= store_image[62] ;
            store_image[81]  <= store_image[80] ;
            store_image[99]  <= store_image[98] ;
            store_image[117] <= store_image[116]  ;
            store_image[135] <= store_image[134]  ;
            store_image[153] <= store_image[152]  ;
            store_image[171] <= store_image[170]   ;
            store_image[189] <= store_image[188]  ;
            store_image[207] <= store_image[206]  ;
            store_image[225] <= store_image[224]  ;
            store_image[243] <= store_image[242]   ;
            store_image[261] <= store_image[260]  ;
            store_image[279] <= store_image[278]  ;
            store_image[297] <= store_image[296]  ;

        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        counter_store_data <= 4'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            counter_store_data <= 4'd0 ;
        end
        else if (counter_store_data == 4'd9)
        begin
            counter_store_data <= counter_store_data ;
        end
        else
        begin
            counter_store_data <= (in_valid)? counter_store_data + 1'd1 : counter_store_data ;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        for (i=0; i<9; i=i+1)
        begin
            store_template[i] <= 15'd0 ;
        end
    end
    else
    begin
        if (counter_store_data != 4'd9)
        begin
            store_template[counter_store_data] <= template ;
        end
    end
end

//////////////////////////////////////////////////////////////////////////////
//     Action 0
//////////////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        size_skip <= 2'd0 ;
    end
    else
    begin
        if (size_skip == 2'd2)
        begin
            size_skip <= 2'd0 ;
        end
        else if (Current_state == Action_0)
        begin
            size_skip <= size_skip + 1'd1 ;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        size_back <= 4'd0 ;
    end
    else
    begin
        if (size_back == 4'd8)
        begin
            size_back <= 4'd0 ;
        end
        else if (Current_state == Action_0)
        begin
            size_back <= size_back + 1'd1 ;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        counter_size4_column <= 3'd0 ;
    end
    else
    begin
        if (counter_size4_column == 3'd4)
        begin
            counter_size4_column <= 3'd0 ;
        end
        else if (size_back == 4'd8)
        begin
            counter_size4_column <= counter_size4_column + 1'd1 ;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        counter_size8_column <= 4'd0 ;
    end
    else
    begin
        if (counter_size8_column == 4'd8)
        begin
            counter_size8_column <= 4'd0 ;
        end
        else if (size_back == 4'd8)
        begin
            counter_size8_column <= counter_size8_column + 1'd1 ;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        counter_size16_column <= 5'd0 ;
    end
    else
    begin
        if (counter_size16_column == 5'd16)
        begin
            counter_size16_column <= 5'd0 ;
        end
        else if (current_size == 5'd16 && size_back == 4'd8)
        begin
            counter_size16_column <= counter_size16_column + 1'd1 ;
        end
    end
end

assign a = (current_size == 5'd16)? store_image[220] : 10'd0 ;

assign skip4_column = (current_size == 5'd4 && counter_size4_column == 3'd4)? 1'd1 : 1'd0 ;
assign skip8_column = (current_size == 5'd8 && counter_size8_column == 4'd8)? 1'd1 : 1'd0 ;
assign skip16_column = (current_size == 5'd16 && counter_size16_column == 5'd16)? 1'd1 : 1'd0 ;
assign skip_back = (size_back == 4'd0)? 1'd1 : 1'd0 ;
always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        number_action0 <= 9'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            number_action0 <= 9'd0 ;
        end
        else if (Current_state == Action_0_store)
        begin
            if (skip4_column)
            begin
                number_action0 <= number_action0 + 9'd2 ;
            end
            else if (skip8_column)
            begin
                number_action0 <= number_action0 - 9'd27 ;
            end
            else if (skip16_column)
            begin
                number_action0 <= number_action0 - 9'd51 ;
            end
            else if (current_size == 5'd8 && skip_back)
            begin
                number_action0 <= number_action0 - 9'd29 ;
            end
            else if (current_size == 5'd16 && skip_back)
            begin
                number_action0 <= number_action0 - 9'd53 ;
            end
        end
        else if (Current_state == Action_0)
        begin
            if (current_size == 5'd4 && size_back == 4'd8)
            begin
                number_action0 <= number_action0 - 9'd13 ;
            end
            else if (current_size == 5'd4 && size_skip == 2'd2)
            begin
                number_action0 <= number_action0 + 9'd4 ;
            end
            else if (current_size == 5'd8 && size_skip == 2'd2)
            begin
                number_action0 <= number_action0 + 9'd8 ;
            end
            else if (current_size == 5'd16 && size_skip == 2'd2)
            begin
                number_action0 <= number_action0 + 9'd16 ;
            end
            else
            begin
                number_action0 <= number_action0 + 1'd1 ;
            end
        end
    end
end

assign mul_action0 = store_image[number_action0] * store_template[size_back] ;

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        add_action0 <= 40'd0 ;
    end
    else
    begin
        if (Current_state == Action_0_store)
        begin
            add_action0 <= 40'd0 ;
        end
        else if (Current_state == Action_0)
        begin
            add_action0 <= add_action0 + mul_action0 ;
        end
    end
end


//////////////////////////////////////////////////////////////////////////////
//     counter for out action 0
//////////////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        counter_out <= 9'd0 ;
    end
    else
    begin
        if (Current_state == Out_data)
        begin
            counter_out <= counter_out + 1'd1 ;
        end
        else
        begin
            counter_out <= 9'd0 ;
        end
    end
end

//////////////////////////////////////////////////////////////////////////////
//     max_x max_y
//////////////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        max_number <= 40'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data || Current_state == Decide_action)
        begin
            max_number <= 40'd0 ;
        end
        else if (Current_state == Action_0_store && SRAM_a == 8'd0)
        begin
            max_number <= add_action0 ;
        end
        else if (Current_state == Action_0_store)
        begin
            max_number <= (add_action0 > max_number)? add_action0 : max_number ;
        end
        else if (Current_state == Action_1)
        begin
            case (back_action1)
                2'd0:
                    max_number <= max_action1 ;
                2'd1:
                    max_number <= (max_action1 > max_number)? max_action1 : max_number ;
                2'd2:
                    max_number <= (max_action1 > max_number)? max_action1 : max_number ;
                2'd3:
                    max_number <= (max_action1 > max_number)? max_action1 : max_number ;
            endcase
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        size_max_x <= 4'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            size_max_x <= 4'd0 ;
        end
        else if (Current_state == Action_0_store)
        begin
            if (current_size == 5'd4 && size_max_x == 4'd3)
            begin
                size_max_x <= size_max_x ;
            end
            else if (current_size == 5'd8 && size_max_x == 4'd7)
            begin
                size_max_x <= size_max_x ;
            end
            else if (current_size == 5'd16 && size_max_x == 4'd15)
            begin
                size_max_x <= size_max_x ;
            end
            else if (current_size == 5'd4 && size_max_y == 4'd3)
            begin
                size_max_x <= size_max_x + 4'd1 ;
            end
            else if (current_size == 5'd8 && size_max_y == 4'd7)
            begin
                size_max_x <= size_max_x + 4'd1 ;
            end
            else if (current_size == 5'd16 && size_max_y == 4'd15)
            begin
                size_max_x <= size_max_x + 4'd1 ;
            end
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        size_max_y <= 4'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            size_max_y <= 4'd0 ;
        end
        else if (Current_state == Action_0_store)
        begin
            if (current_size == 5'd4 && size_max_y == 4'd3)
            begin
                size_max_y <= 4'd0 ;
            end
            else if (current_size == 5'd8 && size_max_y == 4'd7)
            begin
                size_max_y <= 4'd0 ;
            end
            else if (current_size == 5'd16 && size_max_y == 4'd15)
            begin
                size_max_y <= 4'd0 ;
            end
            else
            begin
                size_max_y <= size_max_y + 4'd1 ;
            end
        end
    end
end


always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        max_x <= 4'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            max_x <= 4'd0 ;
        end
        else if (Current_state == Action_0_store)
        begin
            max_x <= (add_action0 > max_number)? size_max_x : max_x ;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        max_y <= 4'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            max_y <= 4'd0 ;
        end
        else if (Current_state == Action_0_store)
        begin
            max_y <= (add_action0 > max_number)? size_max_y : max_y ;
        end
    end
end

//////////////////////////////////////////////////////////////////////////////
//     current_pos
//////////////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        current_pos <= 8'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            current_pos <= 8'd0 ;
        end
        else if (Current_state == Action_0_store)
        begin
            current_pos <= (add_action0 > max_number)? SRAM_a : current_pos ;
        end
    end
end

//////////////////////////////////////////////////////////////////////////////
//     Action 1 and counter_Action 1
//////////////////////////////////////////////////////////////////////////////

assign max_action1 = (Current_state == Action_1 && current_size == 5'd16)? store_image[number_size16_action1] :
       (Current_state == Action_1 && current_size == 5'd8)?  store_image[number_size8_action1] : $signed(40'd0);


always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        counter_size8_sub <= 4'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            counter_size8_sub <= 4'd0 ;
        end
        else if (Current_state == Action_1 && current_size == 5'd8)
        begin
            counter_size8_sub <= counter_size8_sub + 1'd1 ;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        skip_action1 <= 1'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            skip_action1 <= 1'd0 ;
        end
        else if (Current_state == Action_1)
        begin
            skip_action1 <= skip_action1 + 1'd1 ;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        back_action1 <= 2'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            back_action1 <= 2'd0 ;
        end
        else if (Current_state == Action_1)
        begin
            back_action1 <= back_action1 + 1'd1 ;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        total_size8_action1 <= 2'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            total_size8_action1 <= 2'd0 ;
        end
        else if (Current_state == Action_1 && back_action1 == 2'd3)
        begin
            total_size8_action1 <= total_size8_action1 + 1'd1 ;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        total_size16_action1 <= 3'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            total_size16_action1 <= 2'd0 ;
        end
        else if (Current_state == Action_1 && back_action1 == 2'd3)
        begin
            total_size16_action1 <= total_size16_action1 + 1'd1 ;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        counter_size8_action1 <= 6'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            counter_size8_action1 <= 6'd0 ;
        end
        else if (Current_state == Action_1 && current_size == 5'd8)
        begin
            counter_size8_action1 <= counter_size8_action1 + 1'd1 ;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        counter_size16_action1 <= 8'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            counter_size16_action1 <= 8'd0 ;
        end
        else if (Current_state == Action_1 && current_size == 5'd16)
        begin
            counter_size16_action1 <= counter_size16_action1 + 1'd1 ;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        number_size8_action1 <= 7'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            number_size8_action1 <= 7'd0 ;
        end
        else if (Current_state == Decide_action && current_size == 5'd8)
        begin
            number_size8_action1 <= 7'd11 ;
        end
        else if (Current_state == Action_1 && current_size == 5'd8 && total_size8_action1 == 2'd3 && back_action1 == 2'd3)
        begin
            number_size8_action1 <= number_size8_action1 + 2'd3 ;
        end
        else if (Current_state == Action_1 && current_size == 5'd8 && back_action1 == 2'd3)
        begin
            number_size8_action1 <= number_size8_action1 - 7'd9 ;
        end
        else if (Current_state == Action_1 && skip_action1 && current_size == 5'd8)
        begin
            number_size8_action1 <= number_size8_action1 + 7'd9 ;
        end
        else if (Current_state == Action_1 && current_size == 5'd8)
        begin
            number_size8_action1 <= number_size8_action1 + 1'd1 ;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        number_size16_action1 <= 9'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            number_size16_action1 <= 9'd0 ;
        end
        else if (Current_state == Decide_action && current_size == 5'd16)
        begin
            number_size16_action1 <= 9'd19 ;
        end
        else if (Current_state == Action_1 && current_size == 5'd16 && total_size16_action1 == 3'd7 && back_action1 == 2'd3)
        begin
            number_size16_action1 <= number_size16_action1 + 2'd3 ;
        end
        else if (Current_state == Action_1 && current_size == 5'd16 && back_action1 == 2'd3)
        begin
            number_size16_action1 <= number_size16_action1 - 9'd17 ;
        end
        else if (Current_state == Action_1 && skip_action1 && current_size == 5'd16)
        begin
            number_size16_action1 <= number_size16_action1 + 9'd17 ;
        end
        else if (Current_state == Action_1 && current_size == 5'd16)
        begin
            number_size16_action1 <= number_size16_action1 + 1'd1 ;
        end
    end
end

//////////////////////////////////////////////////////////////////////////////
//     SRAM
//////////////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        SRAM_a <= 8'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            SRAM_a <= 8'd0 ;
        end
        else if (Current_state == Action_0_store && current_size == 5'd4 && SRAM_a == 8'd15)
        begin
            SRAM_a <= 8'd0 ;
        end
        else if (Current_state == Action_0_store && current_size == 5'd8 && SRAM_a == 8'd63)
        begin
            SRAM_a <= 8'd0 ;
        end
        else if (Current_state == Action_0_store && current_size == 5'd16 && SRAM_a == 8'd255)
        begin
            SRAM_a <= 8'd0 ;
        end
        else if (Current_state == Action_0_store || Current_state == Out_data || Current_state == Delay_out)
        begin
            SRAM_a <= SRAM_a + 1'd1 ;
        end
    end
end

assign SRAM1_wen = (Current_state == Action_0_store)? 1'd0 : 1'd1 ;

RA2SH SRAM1( .Q(SRAM1_out), .CLK(clk), .CEN(SRAM1_cen), .WEN(SRAM1_wen), .A(SRAM_a), .D(add_action0), .OEN(SRAM1_oen) ) ;


//////////////////////////////////////////////////////////////////////////////
//     counter for out action3
//////////////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        counter_size4_action3 <= 4'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            counter_size4_action3 <= 4'd0 ;
        end
        else if (Current_state == Action_3 && current_size == 5'd4)
        begin
            counter_size4_action3 <= counter_size4_action3 + 1'd1 ;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        counter_size8_action3 <= 6'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            counter_size8_action3 <= 6'd0 ;
        end
        else if (Current_state == Action_3 && current_size == 5'd8)
        begin
            counter_size8_action3 <= counter_size8_action3 + 1'd1 ;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        counter_size16_action3 <= 8'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            counter_size16_action3 <= 8'd0 ;
        end
        else if (Current_state == Action_3 && current_size == 5'd16)
        begin
            counter_size16_action3 <= counter_size16_action3 + 1'd1 ;
        end
    end
end

//////////////////////////////////////////////////////////////////////////////
//     Output
//////////////////////////////////////////////////////////////////////////////

assign size4_out = (current_size == 5'd4 && SRAM_a == 8'd15)? 1'd1 : 1'd0 ;
assign size8_out = (current_size == 5'd8 && SRAM_a == 8'd63)? 1'd1 : 1'd0 ;
assign size16_out = (current_size == 5'd16 && SRAM_a == 8'd255)? 1'd1 : 1'd0 ;

assign size4_finish = (current_size == 5'd4 && counter_out == 4'd15)? 1'd1 : 1'd0 ;
assign size8_finish = (current_size == 5'd8 && counter_out == 6'd63)? 1'd1 : 1'd0 ;
assign size16_finish = (current_size == 5'd16 && counter_out == 8'd255)? 1'd1 : 1'd0 ;

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        out_valid <= 1'd0 ;
    end
    else
    begin
        out_valid <= (Current_state == Out_data)? 1'd1 : 1'd0 ;
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        out_value <= 40'd0 ;
    end
    else
    begin
        if (Current_state == Out_data)
        begin
            out_value <= SRAM1_out ;
        end
        else if (Current_state == Reset_data)
        begin
            out_value <= 40'd0 ;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        out_x <= 4'd0 ;
    end
    else
    begin
        if (Current_state == Out_data)
        begin
            out_x <= max_x ;
        end
        else if (Current_state == Reset_data)
        begin
            out_x <= 4'd0 ;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        out_y <= 4'd0 ;
    end
    else
    begin
        if (Current_state == Out_data)
        begin
            out_y <= max_y ;
        end
        else if (Current_state == Reset_data)
        begin
            out_y <= 4'd0 ;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        out_img_pos <= 8'd0 ;
    end
    else
    begin
        if (Current_state == Reset_data)
        begin
            out_img_pos <= 8'd0 ;
        end
        else if (Current_state == Out_data)
        begin
            if(current_size == 5'd4)
            begin
                if (current_pos == 8'd0)
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos                       ;
                        8'd1:
                            out_img_pos <= current_pos + 1'd1                ;
                        8'd2:
                            out_img_pos <= current_pos + current_size        ;
                        8'd3:
                            out_img_pos <= current_pos + current_size  + 1'd1;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
                else if (current_pos == 8'd3)
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos - 1'd1 			   ;
                        8'd1:
                            out_img_pos <= current_pos        			   ;
                        8'd2:
                            out_img_pos <= current_pos + current_size - 1'd1 ;
                        8'd3:
                            out_img_pos <= current_pos + current_size  	   ;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
                else if (current_pos == 8'd12)
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos - current_size  	   ;
                        8'd1:
                            out_img_pos <= current_pos - current_size + 1'd1 ;
                        8'd2:
                            out_img_pos <= current_pos 				 	   ;
                        8'd3:
                            out_img_pos <= current_pos + 1'd1			 	   ;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
                else if (current_pos == 8'd15)
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos - current_size - 1'd1 ;
                        8'd1:
                            out_img_pos <= current_pos - current_size		   ;
                        8'd2:
                            out_img_pos <= current_pos - 1'd1				   ;
                        8'd3:
                            out_img_pos <= current_pos                 	   ;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
                else if (current_pos == 8'd1 || current_pos == 8'd2)
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos - 1'd1				   ;
                        8'd1:
                            out_img_pos <= current_pos 					   ;
                        8'd2:
                            out_img_pos <= current_pos + 1'd1				   ;
                        8'd3:
                            out_img_pos <= current_pos + current_size - 1'd1 ;
                        8'd4:
                            out_img_pos <= current_pos + current_size 	   ;
                        8'd5:
                            out_img_pos <= current_pos + current_size + 1'd1 ;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
                else if (current_pos == 8'd4 || current_pos == 8'd8)
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos - current_size  	   ;
                        8'd1:
                            out_img_pos <= current_pos - current_size + 1'd1 ;
                        8'd2:
                            out_img_pos <= current_pos 					   ;
                        8'd3:
                            out_img_pos <= current_pos + 1'd1				   ;
                        8'd4:
                            out_img_pos <= current_pos + current_size 	   ;
                        8'd5:
                            out_img_pos <= current_pos + current_size + 1'd1 ;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
                else if (current_pos == 8'd7 || current_pos == 8'd11)
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos - current_size - 1'd1 ;
                        8'd1:
                            out_img_pos <= current_pos - current_size        ;
                        8'd2:
                            out_img_pos <= current_pos - 1'd1				   ;
                        8'd3:
                            out_img_pos <= current_pos 					   ;
                        8'd4:
                            out_img_pos <= current_pos + current_size - 1'd1 ;
                        8'd5:
                            out_img_pos <= current_pos + current_size 	   ;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
                else if (current_pos == 8'd13 || current_pos == 8'd14)
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos - current_size - 1'd1 ;
                        8'd1:
                            out_img_pos <= current_pos - current_size        ;
                        8'd2:
                            out_img_pos <= current_pos - current_size + 1'd1 ;
                        8'd3:
                            out_img_pos <= current_pos - 1'd1				   ;
                        8'd4:
                            out_img_pos <= current_pos 					   ;
                        8'd5:
                            out_img_pos <= current_pos + 1'd1			 	   ;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
                else
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos - current_size - 1'd1 ;
                        8'd1:
                            out_img_pos <= current_pos - current_size        ;
                        8'd2:
                            out_img_pos <= current_pos - current_size + 1'd1 ;
                        8'd3:
                            out_img_pos <= current_pos - 1'd1				   ;
                        8'd4:
                            out_img_pos <= current_pos 					   ;
                        8'd5:
                            out_img_pos <= current_pos + 1'd1			 	   ;
                        8'd6:
                            out_img_pos <= current_pos + current_size - 1'd1 ;
                        8'd7:
                            out_img_pos <= current_pos + current_size 	   ;
                        8'd8:
                            out_img_pos <= current_pos + current_size + 1'd1 ;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
            end
            else if(current_size == 5'd8)
            begin
                if (current_pos == 8'd0)
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos                       ;
                        8'd1:
                            out_img_pos <= current_pos + 1'd1                ;
                        8'd2:
                            out_img_pos <= current_pos + current_size        ;
                        8'd3:
                            out_img_pos <= current_pos + current_size  + 1'd1;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
                else if (current_pos == 8'd7)
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos - 1'd1 			   ;
                        8'd1:
                            out_img_pos <= current_pos        			   ;
                        8'd2:
                            out_img_pos <= current_pos + current_size - 1'd1 ;
                        8'd3:
                            out_img_pos <= current_pos + current_size  	   ;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
                else if (current_pos == 8'd56)
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos - current_size  	   ;
                        8'd1:
                            out_img_pos <= current_pos - current_size + 1'd1 ;
                        8'd2:
                            out_img_pos <= current_pos 				 	   ;
                        8'd3:
                            out_img_pos <= current_pos + 1'd1			 	   ;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
                else if (current_pos == 8'd63)
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos - current_size - 1'd1 ;
                        8'd1:
                            out_img_pos <= current_pos - current_size		   ;
                        8'd2:
                            out_img_pos <= current_pos - 1'd1				   ;
                        8'd3:
                            out_img_pos <= current_pos                 	   ;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
                else if (current_pos < 8'd7)
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos - 1'd1				   ;
                        8'd1:
                            out_img_pos <= current_pos 					   ;
                        8'd2:
                            out_img_pos <= current_pos + 1'd1				   ;
                        8'd3:
                            out_img_pos <= current_pos + current_size - 1'd1 ;
                        8'd4:
                            out_img_pos <= current_pos + current_size 	   ;
                        8'd5:
                            out_img_pos <= current_pos + current_size + 1'd1 ;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
                else if (current_pos == 8'd8 || current_pos == 8'd16 || current_pos == 8'd24
                         || current_pos == 8'd32 || current_pos == 8'd40 || current_pos == 8'd48)
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos - current_size  	   ;
                        8'd1:
                            out_img_pos <= current_pos - current_size + 1'd1 ;
                        8'd2:
                            out_img_pos <= current_pos 					   ;
                        8'd3:
                            out_img_pos <= current_pos + 1'd1				   ;
                        8'd4:
                            out_img_pos <= current_pos + current_size 	   ;
                        8'd5:
                            out_img_pos <= current_pos + current_size + 1'd1 ;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
                else if (current_pos == 8'd15 || current_pos == 8'd23 || current_pos == 8'd31
                         || current_pos == 8'd39 || current_pos == 8'd47 || current_pos == 8'd55)
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos - current_size - 1'd1 ;
                        8'd1:
                            out_img_pos <= current_pos - current_size        ;
                        8'd2:
                            out_img_pos <= current_pos - 1'd1				   ;
                        8'd3:
                            out_img_pos <= current_pos 					   ;
                        8'd4:
                            out_img_pos <= current_pos + current_size - 1'd1 ;
                        8'd5:
                            out_img_pos <= current_pos + current_size 	   ;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
                else if (current_pos == 8'd57 || current_pos == 8'd58 || current_pos == 8'd59
                         || current_pos == 8'd60 || current_pos == 8'd61 || current_pos == 8'd62)
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos - current_size - 1'd1 ;
                        8'd1:
                            out_img_pos <= current_pos - current_size        ;
                        8'd2:
                            out_img_pos <= current_pos - current_size + 1'd1 ;
                        8'd3:
                            out_img_pos <= current_pos - 1'd1				   ;
                        8'd4:
                            out_img_pos <= current_pos 					   ;
                        8'd5:
                            out_img_pos <= current_pos + 1'd1			 	   ;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
                else
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos - current_size - 1'd1 ;
                        8'd1:
                            out_img_pos <= current_pos - current_size        ;
                        8'd2:
                            out_img_pos <= current_pos - current_size + 1'd1 ;
                        8'd3:
                            out_img_pos <= current_pos - 1'd1				   ;
                        8'd4:
                            out_img_pos <= current_pos 					   ;
                        8'd5:
                            out_img_pos <= current_pos + 1'd1			 	   ;
                        8'd6:
                            out_img_pos <= current_pos + current_size - 1'd1 ;
                        8'd7:
                            out_img_pos <= current_pos + current_size 	   ;
                        8'd8:
                            out_img_pos <= current_pos + current_size + 1'd1 ;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
            end
            if(current_size == 5'd16)
            begin
                if (current_pos == 8'd0)
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos                       ;
                        8'd1:
                            out_img_pos <= current_pos + 1'd1                ;
                        8'd2:
                            out_img_pos <= current_pos + current_size        ;
                        8'd3:
                            out_img_pos <= current_pos + current_size  + 1'd1;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
                else if (current_pos == 8'd17)
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos - 1'd1 			   ;
                        8'd1:
                            out_img_pos <= current_pos        			   ;
                        8'd2:
                            out_img_pos <= current_pos + current_size - 1'd1 ;
                        8'd3:
                            out_img_pos <= current_pos + current_size  	   ;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
                else if (current_pos == 8'd240)
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos - current_size  	   ;
                        8'd1:
                            out_img_pos <= current_pos - current_size + 1'd1 ;
                        8'd2:
                            out_img_pos <= current_pos 				 	   ;
                        8'd3:
                            out_img_pos <= current_pos + 1'd1			 	   ;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
                else if (current_pos == 8'd255)
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos - current_size - 1'd1 ;
                        8'd1:
                            out_img_pos <= current_pos - current_size		   ;
                        8'd2:
                            out_img_pos <= current_pos - 1'd1				   ;
                        8'd3:
                            out_img_pos <= current_pos                 	   ;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
                else if (current_pos < 8'd16)
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos - 1'd1				   ;
                        8'd1:
                            out_img_pos <= current_pos 					   ;
                        8'd2:
                            out_img_pos <= current_pos + 1'd1				   ;
                        8'd3:
                            out_img_pos <= current_pos + current_size - 1'd1 ;
                        8'd4:
                            out_img_pos <= current_pos + current_size 	   ;
                        8'd5:
                            out_img_pos <= current_pos + current_size + 1'd1 ;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
                else if (current_pos == 8'd16 || current_pos == 8'd32 || current_pos == 8'd48
                         || current_pos == 8'd64 || current_pos == 8'd80 || current_pos == 8'd96
                         || current_pos == 8'd112 || current_pos == 8'd128 || current_pos == 8'd144
                         || current_pos == 8'd160 || current_pos == 8'd176 || current_pos == 8'd192
                         || current_pos == 8'd208 || current_pos == 8'd224 )
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos - current_size  	   ;
                        8'd1:
                            out_img_pos <= current_pos - current_size + 1'd1 ;
                        8'd2:
                            out_img_pos <= current_pos 					   ;
                        8'd3:
                            out_img_pos <= current_pos + 1'd1				   ;
                        8'd4:
                            out_img_pos <= current_pos + current_size 	   ;
                        8'd5:
                            out_img_pos <= current_pos + current_size + 1'd1 ;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
                else if (current_pos == 8'd31 || current_pos == 8'd47  || current_pos == 8'd63
                         || current_pos == 8'd79  || current_pos == 8'd95  || current_pos == 8'd111
                         || current_pos == 8'd127 || current_pos == 8'd143 || current_pos == 8'd159
                         || current_pos == 8'd175 || current_pos == 8'd191 || current_pos == 8'd207
                         || current_pos == 8'd223 || current_pos == 8'd239 )
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos - current_size - 1'd1 ;
                        8'd1:
                            out_img_pos <= current_pos - current_size        ;
                        8'd2:
                            out_img_pos <= current_pos - 1'd1				   ;
                        8'd3:
                            out_img_pos <= current_pos 					   ;
                        8'd4:
                            out_img_pos <= current_pos + current_size - 1'd1 ;
                        8'd5:
                            out_img_pos <= current_pos + current_size 	   ;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
                else if (current_pos == 8'd241 || current_pos == 8'd242 || current_pos == 8'd243
                         || current_pos == 8'd244 || current_pos == 8'd245 || current_pos == 8'd246
                         || current_pos == 8'd247 || current_pos == 8'd248 || current_pos == 8'd249
                         || current_pos == 8'd250 || current_pos == 8'd251 || current_pos == 8'd252
                         || current_pos == 8'd253 || current_pos == 8'd254 )
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos - current_size - 1'd1 ;
                        8'd1:
                            out_img_pos <= current_pos - current_size        ;
                        8'd2:
                            out_img_pos <= current_pos - current_size + 1'd1 ;
                        8'd3:
                            out_img_pos <= current_pos - 1'd1				   ;
                        8'd4:
                            out_img_pos <= current_pos 					   ;
                        8'd5:
                            out_img_pos <= current_pos + 1'd1			 	   ;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
                else
                begin
                    case (counter_out)
                        8'd0:
                            out_img_pos <= current_pos - current_size - 1'd1 ;
                        8'd1:
                            out_img_pos <= current_pos - current_size        ;
                        8'd2:
                            out_img_pos <= current_pos - current_size + 1'd1 ;
                        8'd3:
                            out_img_pos <= current_pos - 1'd1				   ;
                        8'd4:
                            out_img_pos <= current_pos 					   ;
                        8'd5:
                            out_img_pos <= current_pos + 1'd1			 	   ;
                        8'd6:
                            out_img_pos <= current_pos + current_size - 1'd1 ;
                        8'd7:
                            out_img_pos <= current_pos + current_size 	   ;
                        8'd8:
                            out_img_pos <= current_pos + current_size + 1'd1 ;
                        default:
                            out_img_pos <= 8'd0 ;
                    endcase
                end
            end
        end
    end
end


endmodule
