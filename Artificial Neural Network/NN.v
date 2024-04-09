//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   2021 ICLAB Spring Course
//   Lab03          : Artificial Neural Networ (ANN)
//   Author         : CHAN-HAO LIAO (jericc880417@gmail.com)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   File Name   : NN.v
//   Module Name : NN
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

//synopsys translate_off
`include "/cad/synopsys/synthesis/2022.03/dw/sim_ver/DW_fp_sub.v"
`include "/cad/synopsys/synthesis/2022.03/dw/sim_ver/DW_fp_add.v"
`include "/cad/synopsys/synthesis/2022.03/dw/sim_ver/DW_fp_dp3.v"
`include "/cad/synopsys/synthesis/2022.03/dw/sim_ver/DW_fp_dp4.v"
`include "/cad/synopsys/synthesis/2022.03/dw/sim_ver/DW_fp_mult.v"
//synopsys translate_on

//evince /RAID2/EDA/synopsys/synthesis/cur/dw/doc/dwbb_overview.pdf & remember execute Xwin and setenv DISPLAY youp_IP:0

module NN(
	// Input signals
	clk,
	rst_n,
	in_valid_d,
	in_valid_t,
	in_valid_w1,
	in_valid_w2,
	data_point,
	target,
	weight1,
	weight2,
	// Output signals
	out_valid,
	out
);

parameter inst_sig_width = 23 ;
parameter inst_exp_width = 8 ;

input clk, rst_n, in_valid_d, in_valid_t, in_valid_w1, in_valid_w2 ;
input [inst_sig_width+inst_exp_width:0] target ;
input [inst_sig_width+inst_exp_width:0] data_point ;
input [inst_sig_width+inst_exp_width:0] weight1 ;
input [inst_sig_width+inst_exp_width:0] weight2 ;

output reg out_valid ;
output reg [inst_sig_width+inst_exp_width:0] out ;

///////////////////////////////////////////////////////////////////////

wire bd1_1, bd1_2, bd1_3 ;

reg [inst_sig_width+inst_exp_width:0] store_w1         [0:11]               ;
reg [inst_sig_width+inst_exp_width:0] store_w2         [0:2]                ;
reg [inst_sig_width+inst_exp_width:0] store_data_point [0:3]                ;
reg [inst_sig_width+inst_exp_width:0] store_target                          ;
reg [inst_sig_width+inst_exp_width:0] y1_1, y1_2, y1_3                      ;
reg [inst_sig_width+inst_exp_width:0] store_y1_1, store_y1_2, store_y1_3    ;
reg [inst_sig_width+inst_exp_width:0] temp_g1, g2, g2_value					; 
reg [inst_sig_width+inst_exp_width:0] g1               [0:11]               ;
reg [inst_sig_width+inst_exp_width:0] temp_w2_1, temp_w2_2, temp_w2_3       ;
reg [inst_sig_width+inst_exp_width:0] temp_ww2_1, temp_ww2_2, temp_ww2_3    ;                   
reg [inst_sig_width+inst_exp_width:0] updata_w2_1, updata_w2_2, updata_w2_3 ;
reg [inst_sig_width+inst_exp_width:0] temp_w1_1, temp_w1_2, temp_w1_3, temp_w1_4, temp_w1_5, temp_w1_6, temp_w1_7, temp_w1_8, temp_w1_9,temp_w1_10, temp_w1_11, temp_w1_12 ;
reg [inst_sig_width+inst_exp_width:0] temp_ww1_1, temp_ww1_2, temp_ww1_3, temp_ww1_4, temp_ww1_5, temp_ww1_6, temp_ww1_7, temp_ww1_8, temp_ww1_9, temp_ww1_10, temp_ww1_11, temp_ww1_12 ;    ;                   
reg [inst_sig_width+inst_exp_width:0] updata_w1_1, updata_w1_2, updata_w1_3, updata_w1_4, updata_w1_5, updata_w1_6, updata_w1_7, updata_w1_8, updata_w1_9, updata_w1_10, updata_w1_11, updata_w1_12 ;
reg [inst_sig_width+inst_exp_width:0] y_out ;
								  

wire [31:0] aa = 32'h3A83126F ;

reg [3:0] counter_w1, counter_start ;
reg [1:0] counter_w2, counter_data_point ;

reg [2:0] counter_forward1_clear ;
reg [2:0] counter_forward1_data ;
reg [3:0] counter_forward1 ;
reg [inst_sig_width+inst_exp_width:0] current_w ;
reg [inst_sig_width+inst_exp_width:0] current_d ;
reg [inst_sig_width+inst_exp_width:0] forward1_mul_sum ;
reg [inst_sig_width+inst_exp_width:0] forward1_sum ;
reg [inst_sig_width+inst_exp_width:0] temp_sum ;

reg [1:0] counter_forward2 ;

reg [1:0] counter_updata_w2 ;
reg [3:0] Current_state, Next_state ;

reg [2:0] counter_back_layer1_w2 ;
reg [inst_sig_width+inst_exp_width:0] back_layer1_w2 ;
reg [inst_sig_width+inst_exp_width:0] temp_g1_1, temp_g1_2, temp_g1_3 ;

parameter IDLE      	   = 4'd0 ;
parameter Read_w     	   = 4'd1 ;
parameter Read_d 		   = 4'd2 ;
parameter Forward_layer1   = 4'd3 ;
parameter Forward_layer2   = 4'd4 ;
parameter Backward_layer2  = 4'd5 ;
parameter Backward_layer1  = 4'd6 ;
parameter Updata_w2        = 4'd7 ;
parameter Updata_w1        = 4'd8 ;
parameter Data_out         = 4'd9 ;
parameter decide           = 4'd10 ;

integer i ;

///////////////////////////////////////////////////////////////////////
//    Mult for w*d
///////////////////////////////////////////////////////////////////////

DW_fp_mult f1 (.a(current_w), .b(current_d), .rnd(3'd0), .z(forward1_mul_sum), .status(8'd0)) ;
DW_fp_add f1_ad (.a(forward1_mul_sum), .b(temp_sum), .rnd(3'd0), .z(forward1_sum), .status(8'd0));
DW_fp_sub b2_g2 (.a(y_out), .b(store_target), .rnd(3'd0), .z(g2), .status(8'd0)) ;
DW_fp_mult temp_g_1 (.a(back_layer1_w2), .b(g2), .rnd(3'd0), .z(temp_g1), .status(8'd0)) ;
DW_fp_mult temp__w_1 (.a(g2_value), .b(y1_1), .rnd(3'd0), .z(temp_w2_1), .status(8'd0)) ;
DW_fp_mult temp__w_2 (.a(g2_value), .b(y1_2), .rnd(3'd0), .z(temp_w2_2), .status(8'd0)) ;
DW_fp_mult temp__w_3 (.a(g2_value), .b(y1_3), .rnd(3'd0), .z(temp_w2_3), .status(8'd0)) ;

DW_fp_sub sub_w2_1 (.a(store_w2[0]), .b(temp_ww2_1), .rnd(3'd0), .z(updata_w2_1), .status(8'd0)) ;
DW_fp_sub sub_w2_2 (.a(store_w2[1]), .b(temp_ww2_2), .rnd(3'd0), .z(updata_w2_2), .status(8'd0)) ;
DW_fp_sub sub_w2_3 (.a(store_w2[2]), .b(temp_ww2_3), .rnd(3'd0), .z(updata_w2_3), .status(8'd0)) ;

DW_fp_mult updata_temp_1  (.a(g1[0]), .b(store_data_point[0]), .rnd(3'd0), .z(temp_w1_1), .status(8'd0));
DW_fp_mult updata_temp_2  (.a(g1[1]), .b(store_data_point[1]), .rnd(3'd0), .z(temp_w1_2), .status(8'd0));
DW_fp_mult updata_temp_3  (.a(g1[2]), .b(store_data_point[2]), .rnd(3'd0), .z(temp_w1_3), .status(8'd0));
DW_fp_mult updata_temp_4  (.a(g1[3]), .b(store_data_point[3]), .rnd(3'd0), .z(temp_w1_4), .status(8'd0));
DW_fp_mult updata_temp_5  (.a(g1[4]), .b(store_data_point[0]), .rnd(3'd0), .z(temp_w1_5), .status(8'd0));
DW_fp_mult updata_temp_6  (.a(g1[5]), .b(store_data_point[1]), .rnd(3'd0), .z(temp_w1_6), .status(8'd0));
DW_fp_mult updata_temp_7  (.a(g1[6]), .b(store_data_point[2]), .rnd(3'd0), .z(temp_w1_7), .status(8'd0));
DW_fp_mult updata_temp_8  (.a(g1[7]), .b(store_data_point[3]), .rnd(3'd0), .z(temp_w1_8), .status(8'd0));
DW_fp_mult updata_temp_9  (.a(g1[8]), .b(store_data_point[0]), .rnd(3'd0), .z(temp_w1_9), .status(8'd0));
DW_fp_mult updata_temp_10 (.a(g1[9]), .b(store_data_point[1]), .rnd(3'd0), .z(temp_w1_10), .status(8'd0));
DW_fp_mult updata_temp_11 (.a(g1[10]), .b(store_data_point[2]), .rnd(3'd0), .z(temp_w1_11), .status(8'd0));
DW_fp_mult updata_temp_12 (.a(g1[11]), .b(store_data_point[3]), .rnd(3'd0), .z(temp_w1_12), .status(8'd0));

DW_fp_sub updata_sun_w1_1  (.a(store_w1[0]), .b(temp_w1_1), .rnd(3'd0), .z(updata_w1_1), .status(8'd0));
DW_fp_sub updata_sun_w1_2  (.a(store_w1[1]), .b(temp_w1_2), .rnd(3'd0), .z(updata_w1_2), .status(8'd0));
DW_fp_sub updata_sun_w1_3  (.a(store_w1[2]), .b(temp_w1_3), .rnd(3'd0), .z(updata_w1_3), .status(8'd0));
DW_fp_sub updata_sun_w1_4  (.a(store_w1[3]), .b(temp_w1_4), .rnd(3'd0), .z(updata_w1_4), .status(8'd0));
DW_fp_sub updata_sun_w1_5  (.a(store_w1[4]), .b(temp_w1_5), .rnd(3'd0), .z(updata_w1_5), .status(8'd0));
DW_fp_sub updata_sun_w1_6  (.a(store_w1[5]), .b(temp_w1_6), .rnd(3'd0), .z(updata_w1_6), .status(8'd0));
DW_fp_sub updata_sun_w1_7  (.a(store_w1[6]), .b(temp_w1_7), .rnd(3'd0), .z(updata_w1_7), .status(8'd0));
DW_fp_sub updata_sun_w1_8  (.a(store_w1[7]), .b(temp_w1_8), .rnd(3'd0), .z(updata_w1_8), .status(8'd0));
DW_fp_sub updata_sun_w1_9  (.a(store_w1[8]), .b(temp_w1_9), .rnd(3'd0), .z(updata_w1_9), .status(8'd0));
DW_fp_sub updata_sun_w1_10 (.a(store_w1[9]), .b(temp_w1_10), .rnd(3'd0), .z(updata_w1_10), .status(8'd0));
DW_fp_sub updata_sun_w1_11 (.a(store_w1[10]), .b(temp_w1_11), .rnd(3'd0), .z(updata_w1_11), .status(8'd0));
DW_fp_sub updata_sun_w1_12 (.a(store_w1[11]), .b(temp_w1_12), .rnd(3'd0), .z(updata_w1_12), .status(8'd0));


///////////////////////////////////////////////////////////////////////
//    state change
///////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    Current_state <= IDLE ;
	end
	else begin
		Current_state <= Next_state ;
	end
end

always @(*)
begin
	case (Current_state)
	IDLE: Next_state = (in_valid_w1)? Read_w : IDLE ;
	Read_w: Next_state = (counter_start == 4'd12)? Read_d : Read_w ;
	Read_d: Next_state = (counter_data_point == 4'd3)? Forward_layer1 : Read_d ;
	Forward_layer1: Next_state = (counter_forward1 == 4'd12)? Forward_layer2 : Forward_layer1 ;
	Forward_layer2: Next_state = (counter_forward2 == 2'd2)? Backward_layer2 : Forward_layer2 ;
	Backward_layer2: Next_state = Backward_layer1 ;
	Backward_layer1: Next_state = (counter_back_layer1_w2 == 3'd5)? Updata_w2 : Backward_layer1 ;
	Updata_w2: Next_state = Updata_w1 ;
	Updata_w1: Next_state = Data_out ;
	Data_out: Next_state = decide ;
	decide:
	begin
		if (in_valid_w1)
		Next_state = Read_w ;
		else if (in_valid_d)
		Next_state = Read_d ;
		else
		Next_state = decide ;
	end
	default: Next_state = IDLE ;
	endcase
end

///////////////////////////////////////////////////////////////////////
//    counter for store data 
///////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	    counter_start <= 4'd0 ;
	else begin
		if (in_valid_w1 || in_valid_d)
			counter_start <= counter_start + 1'd1 ;
		else if (Current_state == decide)
		    counter_start <= 4'd0 ;
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	    counter_w1 <= 4'd0 ;
	else begin
		if (in_valid_w1)
			counter_w1 <= counter_w1 + 1'd1 ;
		else 
			counter_w1 <= 4'd0 ;
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	    counter_w2 <= 2'd0 ;
	else begin
		if (in_valid_w2)
			counter_w2 <= counter_w2 + 1'd1 ;
		else 
			counter_w2 <= 2'd0 ;
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	    counter_data_point <= 2'd0 ;
	else begin
		if (in_valid_d)
			counter_data_point <= counter_data_point + 1'd1 ;
		else 
			counter_data_point <= 2'd0 ;
	end
end

///////////////////////////////////////////////////////////////////////
//    counter for store data 
///////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	    counter_back_layer1_w2 <= 3'd0 ;
	else begin
		if (Current_state == Backward_layer1)
			counter_back_layer1_w2 <= counter_back_layer1_w2 + 1'd1 ;
		else
		    counter_back_layer1_w2 <= 3'd0 ;
		    
	end
end

///////////////////////////////////////////////////////////////////////
//    counter for forward1_weight / data / clear
///////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	    counter_forward1 <= 4'd0 ;
	else begin
	    if (counter_forward1_clear == 3'd4)
		    counter_forward1 <= counter_forward1 ;
		else if (Current_state == Forward_layer1)
			counter_forward1 <= counter_forward1 + 1'd1 ;
		else
		    counter_forward1 <= 4'd0 ;
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	    counter_forward1_data <= 3'd0 ;
	else begin
	    if (counter_forward1_clear == 3'd4)
	        counter_forward1_data <= counter_forward1_data ;
	    else if (counter_forward1_data == 3'd3)
	        counter_forward1_data <= 3'd0 ;
	    else if (Current_state == Forward_layer1)
			counter_forward1_data <= counter_forward1_data + 1'd1 ;
		else
		     counter_forward1_data <= 3'd0 ;
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	    counter_forward1_clear <= 3'd0 ;
	else begin
	    if (counter_forward1_clear == 3'd4)
	        counter_forward1_clear <= 3'd0 ;
	    else if (Current_state == Forward_layer1)
			counter_forward1_clear <= counter_forward1_clear + 1'd1 ;
		else
		     counter_forward1_clear <= 3'd0 ;
	end
end

///////////////////////////////////////////////////////////////////////
//    counter for forward2
///////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	    counter_forward2 <= 2'd0 ;
	else begin
		if (Current_state == Forward_layer2)
			counter_forward2 <= counter_forward2 + 1'd1 ;
		else
		    counter_forward2 <= 2'd0 ;
	end
end

///////////////////////////////////////////////////////////////////////
//    counter for updata_w2 
///////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	    counter_updata_w2 <= 2'd0 ;
	else begin
		if (Current_state == Updata_w2)
			counter_updata_w2 <= counter_updata_w2 + 1'd1 ;
		else
		    counter_updata_w2 <= 2'd0 ;
	end
end

///////////////////////////////////////////////////////////////////////
//    store w1 2 and updata w1 2
///////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) 
	begin
	   for (i=0; i<8; i=i+1)
	   begin
	    	store_w1[i] <= 32'd0 ;
	    end 
	end
	else begin
		if (in_valid_w1) 
		begin
			store_w1[counter_w1] <= weight1 ;
		end
		else if (Current_state == Updata_w1)
		begin
			store_w1[0] <= updata_w1_1 ;
			store_w1[1] <= updata_w1_2 ;
			store_w1[2] <= updata_w1_3 ;
			store_w1[3] <= updata_w1_4 ;
			store_w1[4] <= updata_w1_5 ;
			store_w1[5] <= updata_w1_6 ; 
			store_w1[6] <= updata_w1_7 ;
			store_w1[7] <= updata_w1_8 ;
			store_w1[8] <= updata_w1_9 ; 
			store_w1[9] <= updata_w1_10 ;
			store_w1[10] <= updata_w1_11 ;
			store_w1[11] <= updata_w1_12 ;  
		end
	end
end

always @(posedge clk or negedge rst_n)
begin
	if (!rst_n) 
	begin
	   for (i=0; i<3; i=i+1)
	   begin
	    	store_w2[i] <= 32'd0 ;
	    end 
	end
	else begin
		if (in_valid_w2) 
		begin
			store_w2[counter_w2] <= weight2 ;
		end
		else if (Current_state == Updata_w2)
		begin
			store_w2[0] <= updata_w2_1 ;
			store_w2[1] <= updata_w2_2 ;
			store_w2[2] <= updata_w2_3 ; 
		end
	end
end


///////////////////////////////////////////////////////////////////////
//    process forward layer 1 
///////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) 
	begin
	    current_w <= 32'd0 ;
	end
	else begin
	    if (counter_forward1_clear == 3'd4)
	    begin
	    	current_w <= 32'd0 ;
	    end
		else if (Current_state == Forward_layer1)
		begin
			current_w <= store_w1[counter_forward1] ;
		end
		else if (Current_state == Forward_layer2)
		begin
			current_w <= store_w2[counter_forward2] ;
		end
		else begin
			current_w <= current_w ; 
		end
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) 
	begin
	    current_d <= 32'd0 ;
	end
	else begin
	    if (counter_forward1_clear == 3'd4)
	    begin
	    	current_d <= 32'd0 ;
	    end
		else if (Current_state == Forward_layer1)
		begin
			current_d <= store_data_point[counter_forward1_data] ;
		end
		else if (Current_state == Forward_layer2)
		begin
			case(counter_forward2)
			2'd0: current_d <= y1_1 ;
			2'd1: current_d <= y1_2 ;
			2'd2: current_d <= y1_3 ;
			default: current_d <=32'd0 ;
			endcase
		end
		else begin
			current_d <= current_d ; 
		end
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) 
	begin
	    temp_sum <= 32'd0 ;
	end
	else begin
	    if (counter_forward1_clear == 3'd1 || counter_forward1_clear == 3'd2 || counter_forward1_clear == 3'd3 || counter_forward2 == 2'd1 || counter_forward2 == 2'd2)
	    begin
	    	temp_sum <= forward1_sum ;
	    end
	    else begin
	    	temp_sum <= 32'd0 ;  
	    end  
	end
end

///////////////////////////////////////////////////////////////////////
//    store g2
///////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) 
	begin
	    g2_value <= 32'd0 ;
	end
	else begin
	    if (Current_state == Backward_layer1 && (counter_back_layer1_w2 == 3'd2 || counter_back_layer1_w2 == 3'd3))
	    begin
	    	g2_value <= aa ;
	    end
	    else if (Current_state == Backward_layer1)
	    begin
	    	g2_value <= g2 ;
	    end
	end
end

///////////////////////////////////////////////////////////////////////
//    store data_point
///////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) 
	begin
	   for (i=0; i<4; i=i+1)
	   begin
	    	store_data_point[i] <= 32'd0 ;
	    end 
	end
	else begin
		if (in_valid_d)
		begin
			store_data_point[counter_data_point] <= data_point ;
		end
		else if (Current_state == Backward_layer1 && counter_back_layer1_w2 == 3'd4)
		begin
			store_data_point[0] <= aa ;
			store_data_point[1] <= aa ;
			store_data_point[2] <= aa ;
			store_data_point[3] <= aa ;
		end
	end
end

///////////////////////////////////////////////////////////////////////
//    store target
///////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) 
	begin
	    store_target <= 32'd0 ;
	end
	else begin
		if (in_valid_t) 
		begin
			store_target <= target ;
		end
	end
end

///////////////////////////////////////////////////////////////////////
//    Forward layer2
///////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	    y1_1 <= 32'd0 ;
	else begin
		if (Current_state == Forward_layer1 && counter_forward1_clear == 3'd4 && counter_forward1 == 4'd4)
			y1_1 <= (forward1_sum[31] == 1'd0)? forward1_sum : 32'd0 ;
		else if (Current_state == Backward_layer1 && counter_back_layer1_w2 == 3'd2)
		    y1_1 <= temp_w2_1 ;
	end
end


always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	    y1_2 <= 32'd0 ;
	else begin
		if (Current_state == Forward_layer1 && counter_forward1_clear == 3'd4 && counter_forward1 == 4'd8)
			y1_2 <= (forward1_sum[31] == 1'd0)? forward1_sum : 32'd0 ;
		else if (Current_state == Backward_layer1 && counter_back_layer1_w2 == 3'd2)
		    y1_2 <= temp_w2_2 ;
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	    y1_3 <= 32'd0 ;
	else begin
		if (Current_state == Forward_layer1 && counter_forward1_clear == 3'd4 && counter_forward1 == 4'd12)
			y1_3 <= (forward1_sum[31] == 1'd0)? forward1_sum : 32'd0 ;
		else if (Current_state == Backward_layer1 && counter_back_layer1_w2 == 3'd2)
		    y1_3 <= temp_w2_3 ;
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	    temp_ww2_1 <= 32'd0 ;
	else begin
		if (Current_state == Backward_layer1 && counter_back_layer1_w2 == 3'd4)
			temp_ww2_1 <= temp_w2_1 ;
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	    temp_ww2_2 <= 32'd0 ;
	else begin
		if (Current_state == Backward_layer1 && counter_back_layer1_w2 == 3'd4)
			temp_ww2_2 <= temp_w2_2 ;
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	    temp_ww2_3 <= 32'd0 ;
	else begin
		if (Current_state == Backward_layer1 && counter_back_layer1_w2 == 3'd4)
			temp_ww2_3 <= temp_w2_3 ;
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	    store_y1_1 <= 32'd0 ;
	else begin
		if (Current_state == Forward_layer2)
			store_y1_1 <= y1_1 ;
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	    store_y1_2 <= 32'd0 ;
	else begin
		if (Current_state == Forward_layer2)
			store_y1_2 <= y1_2 ;
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	    store_y1_3 <= 32'd0 ;
	else begin
		if (Current_state == Forward_layer2)
			store_y1_3 <= y1_3 ;
	end
end


///////////////////////////////////////////////////////////////////////

assign bd1_1 = (store_y1_1 == 32'd0)? 0 : 1'd1 ;
assign bd1_2 = (store_y1_2 == 32'd0)? 0 : 1'd1 ;
assign bd1_3 = (store_y1_3 == 32'd0)? 0 : 1'd1 ;

///////////////////////////////////////////////////////////////////////
//    Backward layer1
///////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    for (i=0; i<12; i=i+1)
	    begin
	        g1[i] <= 32'd0 ;
	    end
	end
	else begin
	    if (Current_state == Backward_layer1 && counter_back_layer1_w2 == 3'd5)
	    begin
	    	g1[0] <= temp_ww1_1 ;
			g1[1] <= temp_ww1_2 ;
			g1[2] <= temp_ww1_3 ;
			g1[3] <= temp_ww1_4 ;
			g1[4] <= temp_ww1_5 ;
			g1[5] <= temp_ww1_6 ;
			g1[6] <= temp_ww1_7 ;
			g1[7] <= temp_ww1_8 ;
			g1[8] <= temp_ww1_9 ;
			g1[9] <= temp_ww1_10 ;
			g1[10] <= temp_ww1_11 ;
			g1[11] <= temp_ww1_12 ;
	    end
		else if (Current_state == Backward_layer1)
		begin
			g1[0] <= (bd1_1)? temp_g1_1 : 32'd0 ;
			g1[1] <= (bd1_1)? temp_g1_1 : 32'd0 ;
			g1[2] <= (bd1_1)? temp_g1_1 : 32'd0 ;
			g1[3] <= (bd1_1)? temp_g1_1 : 32'd0 ;
			g1[4] <= (bd1_2)? temp_g1_2 : 32'd0 ;
			g1[5] <= (bd1_2)? temp_g1_2 : 32'd0 ;
			g1[6] <= (bd1_2)? temp_g1_2 : 32'd0 ;
			g1[7] <= (bd1_2)? temp_g1_2 : 32'd0 ;
			g1[8] <= (bd1_3)? temp_g1_3 : 32'd0 ;
			g1[9] <= (bd1_3)? temp_g1_3 : 32'd0 ;
			g1[10] <= (bd1_3)? temp_g1_3 : 32'd0 ;
			g1[11] <= (bd1_3)? temp_g1_3 : 32'd0 ;
	    end
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    temp_ww1_1  <= 32'd0 ;
	end
	else begin
	    if (Current_state == Backward_layer1 && counter_back_layer1_w2 == 3'd2)
	    begin
	    	temp_ww1_1 <= temp_w1_1 ;
	    end
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    temp_ww1_2  <= 32'd0 ;
	end
	else begin
	    if (Current_state == Backward_layer1 && counter_back_layer1_w2 == 3'd2)
	    begin
	    	temp_ww1_2 <= temp_w1_2 ;
	    end
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    temp_ww1_3  <= 32'd0 ;
	end
	else begin
	    if (Current_state == Backward_layer1 && counter_back_layer1_w2 == 3'd2)
	    begin
	    	temp_ww1_3 <= temp_w1_3 ;
	    end
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    temp_ww1_4  <= 32'd0 ;
	end
	else begin
	    if (Current_state == Backward_layer1 && counter_back_layer1_w2 == 3'd2)
	    begin
	    	temp_ww1_4 <= temp_w1_4 ;
	    end
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    temp_ww1_5  <= 32'd0 ;
	end
	else begin
	    if (Current_state == Backward_layer1 && counter_back_layer1_w2 == 3'd3)
	    begin
	    	temp_ww1_5 <= temp_w1_5 ;
	    end
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    temp_ww1_6  <= 32'd0 ;
	end
	else begin
	    if (Current_state == Backward_layer1 && counter_back_layer1_w2 == 3'd3)
	    begin
	    	temp_ww1_6 <= temp_w1_6 ;
	    end
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    temp_ww1_7  <= 32'd0 ;
	end
	else begin
	    if (Current_state == Backward_layer1 && counter_back_layer1_w2 == 3'd3)
	    begin
	    	temp_ww1_7 <= temp_w1_7 ;
	    end
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    temp_ww1_8  <= 32'd0 ;
	end
	else begin
	    if (Current_state == Backward_layer1 && counter_back_layer1_w2 == 3'd3)
	    begin
	    	temp_ww1_8 <= temp_w1_8 ;
	    end
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    temp_ww1_9  <= 32'd0 ;
	end
	else begin
	    if (Current_state == Backward_layer1 && counter_back_layer1_w2 == 3'd4)
	    begin
	    	temp_ww1_9 <= temp_w1_9 ;
	    end
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    temp_ww1_10  <= 32'd0 ;
	end
	else begin
	    if (Current_state == Backward_layer1 && counter_back_layer1_w2 == 3'd4)
	    begin
	    	temp_ww1_10 <= temp_w1_10 ;
	    end
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    temp_ww1_11  <= 32'd0 ;
	end
	else begin
	    if (Current_state == Backward_layer1 && counter_back_layer1_w2 == 3'd4)
	    begin
	    	temp_ww1_11 <= temp_w1_11 ;
	    end
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    temp_ww1_12  <= 32'd0 ;
	end
	else begin
	    if (Current_state == Backward_layer1 && counter_back_layer1_w2 == 3'd4)
	    begin
	    	temp_ww1_12 <= temp_w1_12 ;
	    end
	end
end


///////////////////////////////////////////////////////////////////////
//    change back_layer1_w2 0 ~ 2
///////////////////////////////////////////////////////////////////////

always @(*) 
begin
	back_layer1_w2 <= 32'd0 ;
	if (counter_back_layer1_w2 == 3'd3)
	    back_layer1_w2 <= store_w2[0] ;
	else if (Current_state ==  Backward_layer1)	
		back_layer1_w2 <= store_w2[counter_back_layer1_w2] ;
	else
		back_layer1_w2 <= store_w2[0] ;
end


///////////////////////////////////////////////////////////////////////
//    Backward layer1
///////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) 
	begin
	    temp_g1_1 <= 32'd0 ;
	end
	else begin
		if (Current_state ==  Backward_layer1 && counter_back_layer1_w2 == 2'd0)
		     temp_g1_1 <= temp_g1 ;
		else
		     temp_g1_1 <= temp_g1_1 ;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) 
	begin
	    temp_g1_2 <= 32'd0 ;
	end
	else begin
		if (Current_state ==  Backward_layer1 && counter_back_layer1_w2 == 2'd1)
		     temp_g1_2 <= temp_g1 ;
		else
		     temp_g1_2 <= temp_g1_2 ;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) 
	begin
	    temp_g1_3 <= 32'd0 ;
	end
	else begin
		if (Current_state ==  Backward_layer1 && counter_back_layer1_w2 == 2'd2)
		     temp_g1_3 <= temp_g1 ;
		else
		     temp_g1_3 <= temp_g1_3 ;
	end
end

///////////////////////////////////////////////////////////////////////
//    OUT data
///////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    y_out <= 32'd0 ;
	end
	else begin
		y_out <= (Current_state == Backward_layer2)? forward1_sum : y_out ;
	end
end

always @(posedge clk or negedge rst_n)
begin
	if (!rst_n) 
	begin
	    out_valid <= 1'd0 ;
	end
	else begin
		out_valid <= (Current_state == Data_out)? 1'd1 : 1'd0 ;
	end
end

always @(posedge clk or negedge rst_n)
begin
	if (!rst_n) 
	begin
	    out <= 32'd0 ;
	end
	else begin
		out <= (Current_state == Data_out)? y_out : 32'd0 ;
	end
end

endmodule