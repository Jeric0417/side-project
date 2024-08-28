module  CONV(clk, reset, busy, ready, iaddr, idata, cwr, caddr_wr, cdata_wr, crd, caddr_rd, cdata_rd, csel);
input		  clk;
input		  reset;
input         ready;
input [19:0] cdata_rd;
input signed [19:0] idata;
output reg busy;
output reg cwr;
output reg crd;
output reg [11:0] iaddr;
output reg [11:0] caddr_wr;
output reg [19:0] cdata_wr;
output reg [11:0] caddr_rd;
output reg [2:0] csel;
//====================================================================
reg [3:0] counter ; //conv counter
reg [2:0] counter_polling ; // for layer1 
reg [5:0] counter_polling_number ;
reg [6:0] counter_mid_zero_padding ; //conv counter 
reg [4:0] state , Next_state ;
reg [19:0] rd_number0, rd_number1 ;
reg [19:0] max_pooling_number ;
reg signed [19:0] kernel ; 
reg signed [19:0] bias ; 
reg signed [43:0] conv_mul ;
reg signed [43:0] conv_number ; 
// state ch
parameter read_idata= 5'd0 ;
parameter top_left_zero_padding= 5'd1 ;
parameter top_zero_padding= 5'd2 ;
parameter top_right_zero_padding= 5'd3 ;
parameter mid_lift_zero_padding= 5'd4 ;
parameter mid_zero_padding= 5'd5 ;
parameter mid_right_zero_padding= 5'd6 ;
parameter bottom_lift_zero_padding= 5'd7 ;
parameter bottom_zero_padding= 5'd8 ;
parameter bottom_right_zero_padding= 5'd9 ;
parameter read_data= 5'd10 ;
parameter choose_state = 5'd11 ;
parameter kernel0_finish= 5'd12 ;
parameter kernel1_finish= 5'd13 ;
parameter read_pooling0= 5'd14 ;
parameter write_pooling0= 5'd15 ;
parameter polling_change= 5'd16 ;
parameter read_pooling1= 5'd17 ;
parameter write_pooling1= 5'd18 ;
parameter max_pooling_finish = 5'd19 ;
parameter flatten_0 = 5'd20 ;
parameter flatten_1 = 5'd21 ;
parameter read_flatten_0 = 5'd22 ;
parameter read_flatten_1 = 5'd23 ;
parameter flatten_finish = 5'd24 ;
parameter change_flatten = 5'd25 ;

// kernel_0
parameter k_00=  20'H0A89E ;
parameter k_01=  20'H092D5 ;
parameter k_02=  20'H06D43 ; 
parameter k_03=  20'H01004 ;
parameter k_04=  20'HF8F71 ;
parameter k_05=  20'HF6E54 ;
parameter k_06=  20'HFA6D7 ;
parameter k_07=  20'HFC834 ;
parameter k_08=  20'HFAC19 ;
parameter bias_0= 20'H01310 ;

// kernel_1
parameter k_10=  20'HFDB55 ;
parameter k_11=  20'H02992 ;
parameter k_12=  20'HFC994 ; 
parameter k_13=  20'H050FD ;
parameter k_14=  20'H02F20 ;
parameter k_15=  20'H0202D ;
parameter k_16=  20'H03BD7 ;
parameter k_17=  20'HFD369 ;
parameter k_18=  20'H05E68 ;
parameter bias_1= 20'HF7295 ;

always @(*)      // give kernel
begin
    if (csel==3'd1)     // kernel 0 
    begin
	    if (Next_state == top_left_zero_padding)
	    begin
	    	case(counter)
	    	4'd0: kernel = 20'd0 ;
	    	4'd1: kernel = k_04 ;
            4'd2: kernel = k_05 ;
            4'd3: kernel = k_07 ;
            4'd4: kernel = k_08 ;
            4'd5: bias = bias_0 ;
	    	endcase
	    end
	    else if (Next_state == top_zero_padding)
	    begin
	    	case(counter)
	    	4'd0: kernel = k_03 ;
            4'd1: kernel = k_04 ;
            4'd2: kernel = k_05 ;
            4'd3: kernel = k_06 ;
            4'd4: kernel = k_07 ;
            4'd5: kernel = k_08 ;
            4'd6: bias = bias_0 ;
	    	endcase
	    end
	    else if (Next_state == top_right_zero_padding)
	    begin
	    	case(counter)
	    	4'd0: kernel = k_03 ;
            4'd1: kernel = k_04 ;
            4'd2: kernel = k_06 ;
            4'd3: kernel = k_07 ;
            4'd4: bias = bias_0 ;
	    	endcase
	    end
	    else if (Next_state == mid_lift_zero_padding)
	    begin
	    	case(counter)
	    	4'd0: kernel = 20'd0 ;
	    	4'd1: kernel = k_01 ;
            4'd2: kernel = k_02 ;
            4'd3: kernel = k_04 ;
            4'd4: kernel = k_05 ;
            4'd5: kernel = k_07 ;
            4'd6: kernel = k_08 ;
            4'd7: bias = bias_0 ;
	    	endcase
	    end
	    else if (Next_state == mid_zero_padding)
	    begin
	    	case(counter)
	    	4'd0: kernel = 20'd0 ;
	    	4'd1: kernel = k_00 ;
            4'd2: kernel = k_01 ;
            4'd3: kernel = k_02 ;
            4'd4: kernel = k_03 ;
            4'd5: kernel = k_04 ;
            4'd6: kernel = k_05 ;
            4'd7: kernel = k_06 ;
            4'd8: kernel = k_07 ;
            4'd9: kernel = k_08 ;
            4'd10: bias = bias_0 ;
	    	endcase
	    end
	    else if (Next_state == mid_right_zero_padding)
	    begin
	    	case(counter)
	    	4'd0: kernel = 20'd0 ;
            4'd1: kernel = k_00 ;
            4'd2: kernel = k_01 ;
            4'd3: kernel = k_03 ;
            4'd4: kernel = k_04 ;
            4'd5: kernel = k_06 ;
            4'd6: kernel = k_07 ;
	    	endcase
	    end
	    else if (Next_state == bottom_lift_zero_padding)
	    begin
	    	case(counter)
	    	4'd0: kernel = 20'd0 ;
	    	4'd1: kernel = k_01 ;
            4'd2: kernel = k_02 ;
            4'd3: kernel = k_04 ;
            4'd4: kernel = k_05 ;
            4'd5: bias = bias_0 ;
	    	endcase
	    end
	    else if (Next_state == bottom_zero_padding)
	    begin
	    	case(counter)
	    	4'd0: kernel = 20'd0 ;
	    	4'd1: kernel = k_00 ;
            4'd2: kernel = k_01 ;
            4'd3: kernel = k_02 ;
            4'd4: kernel = k_03 ;
            4'd5: kernel = k_04 ;
            4'd6: kernel = k_05 ;
            4'd7: bias = bias_0 ;
	    	endcase
	    end
	    else if (Next_state == bottom_right_zero_padding)
	    begin
	    	case(counter)
	    	4'd0: kernel = 20'd0 ;
	    	4'd1: kernel = k_00 ;
            4'd2: kernel = k_01 ;
            4'd3: kernel = k_03 ;
            4'd4: kernel = k_04 ;
            4'd5: bias = bias_0 ;
	    	endcase
	    end
	end

	else if (csel == 3'd2)   // for kernel 1
	    begin
	        if (Next_state == top_left_zero_padding)
	        begin
	        	case(counter)
	        	4'd0: kernel = 20'd0 ;
	        	4'd1: kernel = k_14 ;
                4'd2: kernel = k_15 ;
                4'd3: kernel = k_17 ;
                4'd4: kernel = k_18 ;
                4'd5: bias = bias_1 ;
	        	endcase
	        end
	        else if (Next_state == top_zero_padding)
	        begin
	        	case(counter)
	        	4'd0: kernel = k_13 ;
                4'd1: kernel = k_14 ;
                4'd2: kernel = k_15 ;
                4'd3: kernel = k_16 ;
                4'd4: kernel = k_17 ;
                4'd5: kernel = k_18 ;
                4'd6: bias = bias_1 ;
	        	endcase
	        end
	        else if (Next_state == top_right_zero_padding)
	        begin
	        	case(counter)
	        	4'd0: kernel = k_13 ;
                4'd1: kernel = k_14 ;
                4'd2: kernel = k_16 ;
                4'd3: kernel = k_17 ;
                4'd4: bias = bias_1 ;
	        	endcase
	        end
	        else if (Next_state == mid_lift_zero_padding)
	        begin
	        	case(counter)
	        	4'd0: kernel = 20'd0 ;
	        	4'd1: kernel = k_11 ;
                4'd2: kernel = k_12 ;
                4'd3: kernel = k_14 ;
                4'd4: kernel = k_15 ;
                4'd5: kernel = k_17 ;
                4'd6: kernel = k_18 ;
                4'd7: bias = bias_1 ;
	        	endcase
	        end
	        else if (Next_state == mid_zero_padding)
	        begin
	        	case(counter)
	        	4'd0: kernel = 20'd0 ;
	        	4'd1: kernel = k_10 ;
                4'd2: kernel = k_11 ;
                4'd3: kernel = k_12 ;
                4'd4: kernel = k_13 ;
                4'd5: kernel = k_14 ;
                4'd6: kernel = k_15 ;
                4'd7: kernel = k_16 ;
                4'd8: kernel = k_17 ;
                4'd9: kernel = k_18 ;
                4'd10: bias = bias_1 ;
	        	endcase
	        end
	        else if (Next_state == mid_right_zero_padding)
	        begin
	        	case(counter)
	        	4'd0: kernel = 20'd0 ;
                4'd1: kernel = k_10 ;
                4'd2: kernel = k_11 ;
                4'd3: kernel = k_13 ;
                4'd4: kernel = k_14 ;
                4'd5: kernel = k_16 ;
                4'd6: kernel = k_17 ;
	        	endcase
	        end
	        else if (Next_state == bottom_lift_zero_padding)
	        begin
	        	case(counter)
	        	4'd0: kernel = 20'd0 ;
	        	4'd1: kernel = k_11 ;
                4'd2: kernel = k_12 ;
                4'd3: kernel = k_14 ;
                4'd4: kernel = k_15 ;
                4'd5: bias = bias_1 ;
	        	endcase
	        end
	        else if (Next_state == bottom_zero_padding)
	        begin
	        	case(counter)
	        	4'd0: kernel = 20'd0 ;
	        	4'd1: kernel = k_10 ;
                4'd2: kernel = k_11 ;
                4'd3: kernel = k_12 ;
                4'd4: kernel = k_13 ;
                4'd5: kernel = k_14 ;
                4'd6: kernel = k_15 ;
                4'd7: bias = bias_1 ;
	        	endcase
	        end
	        else if (Next_state == bottom_right_zero_padding)
	        begin
	        	case(counter)
	        	4'd0: kernel = 20'd0 ;
	        	4'd1: kernel = k_10 ;
                4'd2: kernel = k_11 ;
                4'd3: kernel = k_13 ;
                4'd4: kernel = k_14 ;
                4'd5: bias = bias_1 ;
	        	endcase
	        end
	    end
end

always @(posedge clk or posedge reset) begin // output cdata_wr
	if (reset) 
	begin
	    cdata_wr <= 20'd0 ; 
	end
	else begin
		if (state == top_left_zero_padding || Next_state == top_left_zero_padding || counter == 4'd9)
		cdata_wr[19:0] <= conv_number[35:16] ;
		else if (state == top_zero_padding || Next_state == top_zero_padding || counter == 4'd10)
		cdata_wr[19:0] <= conv_number[35:16] ;
		else if (state == top_right_zero_padding || Next_state == top_right_zero_padding || counter == 4'd8)
		cdata_wr[19:0] <= conv_number[35:16] ;
		else if (state == mid_lift_zero_padding || Next_state == mid_lift_zero_padding || counter == 4'd11)
	    cdata_wr[19:0] <= conv_number[35:16] ;
	    else if (state == mid_zero_padding || Next_state == mid_zero_padding || counter == 4'd14)
	    cdata_wr[19:0] <= conv_number[35:16] ;
	    else if (state == mid_right_zero_padding || Next_state == mid_right_zero_padding || counter == 4'd11)
	    cdata_wr[19:0] <= conv_number[35:16] ;
	    else if (state == bottom_lift_zero_padding || Next_state == bottom_lift_zero_padding || counter == 4'd9)
	    cdata_wr[19:0] <= conv_number[35:16] ;
	    else if (state == bottom_zero_padding || Next_state == bottom_zero_padding || counter == 4'd11)
	    cdata_wr[19:0] <= conv_number[35:16] ;
	    else if (state == bottom_right_zero_padding || Next_state == bottom_right_zero_padding || counter == 4'd9)
	    cdata_wr[19:0] <= conv_number[35:16] ;
	    else if (Next_state == write_pooling0 || Next_state == write_pooling1)
	    cdata_wr[19:0] <= max_pooling_number[19:0] ;
	    else if (Next_state == flatten_0 || Next_state == flatten_1)
	    cdata_wr[19:0] <= cdata_rd[19:0] ;
	end
end

always @(posedge clk or posedge reset)      // calculate conv_number
begin
    if (reset)
    begin
    	conv_number <= 44'd0 ;
    end
    else begin
    if (state == read_data)
        conv_number <= 44'd0 ;
	else if (state == top_left_zero_padding || Next_state == top_left_zero_padding)
	begin
		case(counter)
		4'd1: conv_number <= conv_number + conv_mul ;
        4'd2: conv_number <= conv_number + conv_mul ;
        4'd3: conv_number <= conv_number + conv_mul ;
        4'd4: conv_number <= conv_number + conv_mul ;
        4'd5: conv_number <= conv_number + conv_mul ;
        4'd6: conv_number <= {conv_number[43:16] + bias, conv_number[15:0]} ;
        4'd7: conv_number <= (conv_number[15])? {conv_number[43:16]+ 20'd1,conv_number[15:0]} : conv_number ;
        4'd8: conv_number <= (conv_number[35])? 44'd0 : conv_number ; 
        default: conv_number <= conv_number ;
		endcase
	end
	else if (state == top_zero_padding || Next_state == top_zero_padding)
	begin
		case(counter)
		4'd1: conv_number <= conv_number + conv_mul ;
        4'd2: conv_number <= conv_number + conv_mul ;
        4'd3: conv_number <= conv_number + conv_mul ;
        4'd4: conv_number <= conv_number + conv_mul ;
        4'd5: conv_number <= conv_number + conv_mul ;
        4'd6: conv_number <= conv_number + conv_mul ;
        4'd7: conv_number <= {conv_number[43:16] + bias, conv_number[15:0]} ;
        4'd8: conv_number <= (conv_number[15])? {conv_number[43:16]+ 20'd1,conv_number[15:0]} : conv_number ;
        4'd9: conv_number <= (conv_number[35])? 44'd0 : conv_number ; 
        default: conv_number <= conv_number ;
		endcase
	end
	else if (state == top_right_zero_padding || Next_state == top_right_zero_padding)
	begin
		case(counter)
		4'd1: conv_number <= conv_number + conv_mul ;
        4'd2: conv_number <= conv_number + conv_mul ;
        4'd3: conv_number <= conv_number + conv_mul ;
        4'd4: conv_number <= conv_number + conv_mul ;
        4'd5: conv_number <= {conv_number[43:16] + bias, conv_number[15:0]} ;
        4'd6: conv_number <= (conv_number[15])? {conv_number[43:16]+ 20'd1,conv_number[15:0]} : conv_number ;
        4'd7: conv_number <= (conv_number[35])? 44'd0 : conv_number ; 
        default: conv_number <= conv_number ;
		endcase
	end
	else if (state == mid_lift_zero_padding || Next_state == mid_lift_zero_padding)
	begin
		case(counter)
		4'd1: conv_number <= conv_number + conv_mul ;
        4'd2: conv_number <= conv_number + conv_mul ;
        4'd3: conv_number <= conv_number + conv_mul ;
        4'd4: conv_number <= conv_number + conv_mul ;
        4'd5: conv_number <= conv_number + conv_mul ;
        4'd6: conv_number <= conv_number + conv_mul ;
        4'd7: conv_number <= conv_number + conv_mul ;
        4'd8: conv_number <= {conv_number[43:16] + bias, conv_number[15:0]} ;
        4'd9: conv_number <= (conv_number[15])? {conv_number[43:16]+ 20'd1,conv_number[15:0]} : conv_number ;
        4'd10: conv_number <= (conv_number[35])? 44'd0 : conv_number ; 
        default: conv_number <= conv_number ;
		endcase
	end
	else if (state == mid_zero_padding || Next_state == mid_zero_padding)
	begin
		case(counter)
		4'd1: conv_number <= conv_number + conv_mul ;
        4'd2: conv_number <= conv_number + conv_mul ;
        4'd3: conv_number <= conv_number + conv_mul ;
        4'd4: conv_number <= conv_number + conv_mul ;
        4'd5: conv_number <= conv_number + conv_mul ;
        4'd6: conv_number <= conv_number + conv_mul ;
        4'd7: conv_number <= conv_number + conv_mul ;
        4'd8: conv_number <= conv_number + conv_mul ;
        4'd9: conv_number <= conv_number + conv_mul ;
        4'd10: conv_number <= conv_number + conv_mul ;
        4'd11: conv_number <= {conv_number[43:16] + bias, conv_number[15:0]} ;
        4'd12: conv_number <= (conv_number[15])? {conv_number[43:16]+ 20'd1,conv_number[15:0]} : conv_number ;
        4'd13: conv_number <= (conv_number[35])? 44'd0 : conv_number ; 
        default: conv_number <= conv_number ;
		endcase
	end
	else if (state == mid_right_zero_padding || Next_state == mid_right_zero_padding)
	begin
		case(counter)
		4'd1: conv_number <= conv_number + conv_mul ;
        4'd2: conv_number <= conv_number + conv_mul ;
        4'd3: conv_number <= conv_number + conv_mul ;
        4'd4: conv_number <= conv_number + conv_mul ;
        4'd5: conv_number <= conv_number + conv_mul ;
        4'd6: conv_number <= conv_number + conv_mul ;
        4'd7: conv_number <= conv_number + conv_mul ;
        4'd8: conv_number <= {conv_number[43:16] + bias, conv_number[15:0]} ;
        4'd9: conv_number <= (conv_number[15])? {conv_number[43:16]+ 20'd1,conv_number[15:0]} : conv_number ;
        4'd10: conv_number <= (conv_number[35])? 44'd0 : conv_number ; 
        default: conv_number <= conv_number ;
		endcase
	end
	else if (state == bottom_lift_zero_padding || Next_state == bottom_lift_zero_padding)
	begin
		case(counter)
		4'd1: conv_number <= conv_number + conv_mul ;
        4'd2: conv_number <= conv_number + conv_mul ;
        4'd3: conv_number <= conv_number + conv_mul ;
        4'd4: conv_number <= conv_number + conv_mul ;
        4'd5: conv_number <= conv_number + conv_mul ;
        4'd6: conv_number <= {conv_number[43:16] + bias, conv_number[15:0]} ;
        4'd7: conv_number <= (conv_number[15])? {conv_number[43:16]+ 20'd1,conv_number[15:0]} : conv_number ;
        4'd8: conv_number <= (conv_number[35])? 44'd0 : conv_number ; 
        default: conv_number <= conv_number ;
		endcase
	end
	else if (state == bottom_zero_padding || Next_state == bottom_zero_padding)
	begin
		case(counter)
		4'd1: conv_number <= conv_number + conv_mul ;
        4'd2: conv_number <= conv_number + conv_mul ;
        4'd3: conv_number <= conv_number + conv_mul ;
        4'd4: conv_number <= conv_number + conv_mul ;
        4'd5: conv_number <= conv_number + conv_mul ;
        4'd6: conv_number <= conv_number + conv_mul ;
        4'd7: conv_number <= conv_number + conv_mul ;
        4'd8: conv_number <= {conv_number[43:16] + bias, conv_number[15:0]} ;
        4'd9: conv_number <= (conv_number[15])? {conv_number[43:16]+ 20'd1,conv_number[15:0]} : conv_number ;
        4'd10: conv_number <= (conv_number[35])? 44'd0 : conv_number ; 
        default: conv_number <= conv_number ;
		endcase
	end
	else if (state == bottom_right_zero_padding || Next_state == bottom_right_zero_padding)
	begin
		case(counter)
		4'd1: conv_number <= conv_number + conv_mul ;
        4'd2: conv_number <= conv_number + conv_mul ;
        4'd3: conv_number <= conv_number + conv_mul ;
        4'd4: conv_number <= conv_number + conv_mul ;
        4'd5: conv_number <= conv_number + conv_mul ;
        4'd6: conv_number <= {conv_number[43:16] + bias, conv_number[15:0]} ;
        4'd7: conv_number <= (conv_number[15])? {conv_number[43:16]+ 20'd1,conv_number[15:0]} : conv_number ;
        4'd8: conv_number <= (conv_number[35])? 44'd0 : conv_number ; 
        default: conv_number <= conv_number ;
		endcase
	end
	end
end

always @(posedge clk or posedge reset)    // calculate mul kernel and idata 
begin
    if (reset)
    begin
    	conv_mul <= 40'd0 ;
    end
    else begin 
    if (Next_state == top_left_zero_padding)
	begin
		case(counter)
		4'd0: conv_mul <= 40'd0 ;
		4'd1: conv_mul <= kernel * idata ;
        4'd2: conv_mul <= kernel * idata ;
        4'd3: conv_mul <= kernel * idata ;
        4'd4: conv_mul <= kernel * idata ;
        4'd5: conv_mul <= 40'd0 ;
		endcase
	end
	else if (Next_state == top_zero_padding)
	begin
		case(counter)
		4'd0: conv_mul <= kernel * idata ;
        4'd1: conv_mul <= kernel * idata ;
        4'd2: conv_mul <= kernel * idata ;
        4'd3: conv_mul <= kernel * idata ;
        4'd4: conv_mul <= kernel * idata ;
        4'd5: conv_mul <= kernel * idata ;
        4'd6: conv_mul <= 40'd0 ;
		endcase
	end
	else if (Next_state == top_right_zero_padding)
	begin
		case(counter)
		4'd0: conv_mul <= kernel * idata ;
        4'd1: conv_mul <= kernel * idata ;
        4'd2: conv_mul <= kernel * idata ;
        4'd3: conv_mul <= kernel * idata ;
        4'd4: conv_mul <= 40'd0 ;
		endcase
	end
	else if (Next_state == mid_lift_zero_padding)
	begin
		case(counter)
		4'd0: conv_mul <= kernel * idata ;
        4'd1: conv_mul <= kernel * idata ;
        4'd2: conv_mul <= kernel * idata ;
        4'd3: conv_mul <= kernel * idata ;
        4'd4: conv_mul <= kernel * idata ;
        4'd5: conv_mul <= kernel * idata ;
        4'd6: conv_mul <= kernel * idata ;
        4'd7: conv_mul <= 40'd0 ;
		endcase
	end
	else if (Next_state == mid_zero_padding)
	begin
		case(counter)
		4'd0: conv_mul <= kernel * idata ;
        4'd1: conv_mul <= kernel * idata ;
        4'd2: conv_mul <= kernel * idata ;
        4'd3: conv_mul <= kernel * idata ;
        4'd4: conv_mul <= kernel * idata ;
        4'd5: conv_mul <= kernel * idata ;
        4'd6: conv_mul <= kernel * idata ;
        4'd7: conv_mul <= kernel * idata ;
        4'd8: conv_mul <= kernel * idata ;
        4'd9: conv_mul <= kernel * idata ;
        4'd10: conv_mul <= 40'd0 ;
		endcase
	end
	else if (Next_state == mid_right_zero_padding)
	begin
		case(counter)
		4'd0: conv_mul <= kernel * idata ;
        4'd1: conv_mul <= kernel * idata ;
        4'd2: conv_mul <= kernel * idata ;
        4'd3: conv_mul <= kernel * idata ;
        4'd4: conv_mul <= kernel * idata ;
        4'd5: conv_mul <= kernel * idata ;
        4'd6: conv_mul <= kernel * idata ;
        4'd7: conv_mul <= 40'd0 ;
		endcase
	end
	else if (Next_state == bottom_lift_zero_padding)
	begin
		case(counter)
		4'd0: conv_mul <= kernel * idata ;
        4'd1: conv_mul <= kernel * idata ;
        4'd2: conv_mul <= kernel * idata ;
        4'd3: conv_mul <= kernel * idata ;
        4'd4: conv_mul <= kernel * idata ;
        4'd5: conv_mul <= 40'd0 ;
		endcase
	end
	else if (Next_state == bottom_zero_padding)
	begin
		case(counter)
		4'd0: conv_mul <= kernel * idata ;
        4'd1: conv_mul <= kernel * idata ;
        4'd2: conv_mul <= kernel * idata ;
        4'd3: conv_mul <= kernel * idata ;
        4'd4: conv_mul <= kernel * idata ;
        4'd5: conv_mul <= kernel * idata ;
        4'd6: conv_mul <= kernel * idata ;
        4'd7: conv_mul <= 40'd0 ;
		endcase
	end
	else if (Next_state == bottom_right_zero_padding)
	begin
		case(counter)
		4'd0: conv_mul <= kernel * idata ;
        4'd1: conv_mul <= kernel * idata ;
        4'd2: conv_mul <= kernel * idata ;
        4'd3: conv_mul <= kernel * idata ;
        4'd4: conv_mul <= kernel * idata ;
        4'd5: conv_mul <= 40'd0 ;
		endcase
	end
	end
end

always @(posedge clk or posedge reset)  // conv_counter
begin
	if (reset) 
	begin
	    counter <= 4'd0 ; 
	end
	else begin
	    if (Next_state == choose_state || Next_state ==read_pooling0 || Next_state == read_pooling1 || Next_state == flatten_1 || Next_state == flatten_0)	    
	    	counter <= 4'd0 ;
	    else
		    counter <= counter + 1'd1 ;
	end
end

always @(posedge clk or posedge reset)  // counter for counter_mid_zero_padding
begin
	if (reset) 
	begin
	    counter_mid_zero_padding <= 7'd0 ; 
	end
	else begin
	    if (counter_mid_zero_padding == 7'd64 )
	        counter_mid_zero_padding <= 7'd0 ;
	    else if (state == choose_state && (Next_state == mid_zero_padding || Next_state == mid_lift_zero_padding || Next_state == mid_right_zero_padding))	    
	    	counter_mid_zero_padding <= counter_mid_zero_padding + 1'd1 ;
	    else
		    counter_mid_zero_padding <= counter_mid_zero_padding  ;
	end
end

always @(posedge clk or posedge reset) begin // output caddr_wr
	if (reset) 
	begin
	    caddr_wr <= 12'd0 ;
	end
	else begin
	    if (Next_state == change_flatten)
	    caddr_wr <= 12'd0 ;
		else if (state == read_data)
		caddr_wr <= caddr_wr + 1'd1 ;
		else if (Next_state == polling_change)
		caddr_wr <= 12'd0 ;
		else if (Next_state == write_pooling0 || Next_state == write_pooling1)
		caddr_wr <= caddr_rd ;
		else if ((Next_state == read_flatten_0 && state == flatten_1) || (Next_state == read_flatten_1 && state == flatten_0))
	    caddr_wr <= caddr_wr + 1'd1 ;
	end
end

always @(posedge clk or posedge reset) // output iaddr
begin
	if (reset)
	begin
	    iaddr <= 12'd0 ;
	end
	else begin 
		if (!ready)
		begin
		    if (Next_state == kernel0_finish)
		          iaddr <= 12'd0 ;
		    else if(Next_state == top_left_zero_padding)
		    begin
		    case (counter)
			4'd0: iaddr <= iaddr  ;
			4'd1: iaddr <= iaddr + 7'd1 ;
			4'd2: iaddr <= iaddr + 7'd63 ;
			4'd3: iaddr <= iaddr + 7'd1 ;
			4'd4: iaddr <= iaddr - 7'd65 ;
			default: iaddr <= iaddr ;
			endcase
			end
            else if (Next_state == top_zero_padding)
            begin
			case (counter)
			4'd0: iaddr <= iaddr + 7'd1 ;
			4'd1: iaddr <= iaddr + 7'd1 ;
			4'd2: iaddr <= iaddr + 7'd62 ;
			4'd3: iaddr <= iaddr + 7'd1 ;
			4'd4: iaddr <= iaddr + 7'd1 ;
			4'd5: iaddr <= iaddr - 7'd65 ;
			default: iaddr <= iaddr ;
			endcase
			end
			else if (Next_state == top_right_zero_padding)
			begin
			case (counter)
			4'd0: iaddr <= iaddr + 7'd1 ;
			4'd1: iaddr <= iaddr + 7'd63 ;
			4'd2: iaddr <= iaddr + 7'd1 ;
			4'd3: iaddr <= iaddr - 7'd64 ;
			default: iaddr <= iaddr ;
			endcase
			end
			else if (Next_state == mid_lift_zero_padding)
			begin
			case (counter)
			4'd0: iaddr <= iaddr - 7'd63 ;
			4'd1: iaddr <= iaddr + 7'd1 ;
			4'd2: iaddr <= iaddr + 7'd63 ;
			4'd3: iaddr <= iaddr + 7'd1 ;
			4'd4: iaddr <= iaddr + 7'd63 ;
			4'd5: iaddr <= iaddr + 7'd1 ;
			4'd6: iaddr <= iaddr - 7'd65 ;
			default: iaddr <= iaddr ;
			endcase
			end
			else if (Next_state == mid_zero_padding)
			begin
			case (counter)
			4'd0: iaddr <= iaddr - 7'd64  ;
			4'd1: iaddr <= iaddr + 7'd1 ;
			4'd2: iaddr <= iaddr + 7'd1 ;
			4'd3: iaddr <= iaddr + 7'd62 ;
			4'd4: iaddr <= iaddr + 7'd1 ;
			4'd5: iaddr <= iaddr + 7'd1 ;
			4'd6: iaddr <= iaddr + 7'd62 ;
			4'd7: iaddr <= iaddr + 7'd1 ;
			4'd8: iaddr <= iaddr + 7'd1 ;
			4'd9: iaddr <= iaddr - 7'd65 ;
			default: iaddr <= iaddr ;
			endcase
			end
			else if (Next_state == mid_right_zero_padding)
			begin
			case (counter)
			4'd0: iaddr <= iaddr - 7'd64 ;
			4'd1: iaddr <= iaddr + 7'd1 ;
			4'd2: iaddr <= iaddr + 7'd63 ;
			4'd3: iaddr <= iaddr + 7'd1 ;
			4'd4: iaddr <= iaddr + 7'd63 ;
			4'd5: iaddr <= iaddr + 7'd1 ;
			4'd6: iaddr <= iaddr +-7'd64 ;
			default: iaddr <= iaddr ;
			endcase
			end
			else if (Next_state == bottom_lift_zero_padding)
			begin
			case (counter)
			4'd0: iaddr <= iaddr - 7'd63 ;
			4'd1: iaddr <= iaddr + 7'd1 ;
			4'd2: iaddr <= iaddr + 7'd63 ;
			4'd3: iaddr <= iaddr + 7'd1 ;
			4'd4: iaddr <= iaddr - 7'd1 ;
			default: iaddr <= iaddr ;
			endcase
			end
			else if (Next_state == bottom_zero_padding)
			begin
			case (counter)
			4'd0: iaddr <= iaddr - 7'd64 ;
			4'd1: iaddr <= iaddr + 7'd1 ;
			4'd2: iaddr <= iaddr + 7'd1 ;
			4'd3: iaddr <= iaddr + 7'd62 ;
			4'd4: iaddr <= iaddr + 7'd1 ;
			4'd5: iaddr <= iaddr + 7'd1 ;
			4'd6: iaddr <= iaddr - 7'd1 ;
			default: iaddr <= iaddr ;
			endcase
			end
			else if (Next_state == bottom_right_zero_padding)
			begin
			case (counter)
			4'd0: iaddr <= iaddr - 7'd64 ;
			4'd1: iaddr <= iaddr + 7'd1 ;
			4'd2: iaddr <= iaddr + 7'd63 ;
			4'd3: iaddr <= iaddr + 7'd1 ;
			default: iaddr <= iaddr ;
			endcase
			end
		end	
	end
end
//-----------------------------------------------------------layer1
always @(posedge clk or posedge reset)  // counter for max_polling 
begin
	if (reset) 
	begin
	    counter_polling <= 3'd0 ; 
	end
	else begin
	    if (counter_polling == 3'd6)
	    counter_polling <= 3'd0 ;    
	    else if (Next_state == read_pooling0 || Next_state == read_pooling1 || Next_state == polling_change)	
	    counter_polling <= counter_polling + 1'd1 ;
	end
end

always @(posedge clk or posedge reset)  // counter for polling + 64 
begin
	if (reset) 
	begin
	    counter_polling_number <= 6'd0 ; 
	end
	else begin
	    if (counter_polling_number == 6'd32)
	    counter_polling_number <= 6'd0 ;    
	    else if (Next_state == write_pooling0 || Next_state == write_pooling1)	
	    counter_polling_number <= counter_polling_number + 1'd1 ;
	end
end

always @(posedge clk or posedge reset) begin // output read caddr_rd
	if (reset) 
	begin
	    caddr_rd <= 12'd0 ;
	    rd_number0 <= 12'd0 ;
	    rd_number1 <= 12'd0 ;
	end
	else begin
	    if (state == polling_change || Next_state == change_flatten)
	    begin
	        caddr_rd <= 12'd0 ;
	        rd_number0 <= 12'd0 ;
	        rd_number1 <= 12'd0 ;
	    end
	    else if (counter_polling_number == 6'd32)
	    begin
	        rd_number0 <= rd_number0 + 7'd66 ;
	    end
		else if (Next_state == read_pooling0 || Next_state == read_pooling1)
		begin
		    case (counter_polling)
		    3'd0: caddr_rd <= rd_number0 ;
		    3'd1: caddr_rd <= rd_number0 + 7'd1 ;
		    3'd2: caddr_rd <= rd_number0 + 7'd64 ;
		    3'd3: caddr_rd <= rd_number0 + 7'd65 ;
		    3'd4: caddr_rd <= rd_number1 ;
		    3'd5: rd_number0 <= rd_number0 + 7'd2 ;
		    3'd6: rd_number1 <= rd_number1 + 7'd1 ;
		    default: caddr_rd <= caddr_rd ;
		    endcase
		end
		else if (state == read_flatten_1)
		begin
		    caddr_rd <= caddr_rd + 1'd1 ;
		end
	end
end

always @(posedge clk or posedge reset)  // output crd
begin
	if (reset) 
	begin
	    crd <= 1'd0 ;
	end
	else begin
		if (Next_state == read_pooling0 || Next_state == read_pooling1 || Next_state == polling_change || Next_state == read_flatten_0 || Next_state == read_flatten_1)
		crd <= 1'd1 ;
		else
		crd <= 1'd0 ;
	end
end

always @(posedge clk or posedge reset) begin // output cwr
	if (reset) 
	begin
	    cwr <= 1'd0 ;
	end
	else begin
		if (Next_state == read_data || Next_state == write_pooling0 || Next_state == write_pooling1 || Next_state == flatten_1 || Next_state == flatten_0)
		cwr <=  1'd1 ;
		else
		cwr <= 1'd0 ;
	end
end

always @(posedge clk or posedge reset)  // compare max_pooling_number
begin
	if (reset) 
	begin
	    max_pooling_number <= 20'd0 ;
	end
	else begin
	    if (state == polling_change)
	    max_pooling_number <= 20'd0 ;
	    else if (state == read_pooling0 )
	    begin
            case (counter_polling)
            3'd1: max_pooling_number <= (max_pooling_number > cdata_rd)? max_pooling_number : cdata_rd ;
            3'd2: max_pooling_number <= (max_pooling_number > cdata_rd)? max_pooling_number : cdata_rd ;
            3'd3: max_pooling_number <= (max_pooling_number > cdata_rd)? max_pooling_number : cdata_rd ;
            3'd4: max_pooling_number <= (max_pooling_number > cdata_rd)? max_pooling_number : cdata_rd ;
            3'd5: max_pooling_number <= max_pooling_number ;
            default: max_pooling_number <= 20'd0 ;
            endcase
        end
	else begin
	    if (state == read_pooling1)
            case (counter_polling)
            3'd1: max_pooling_number <= (max_pooling_number > cdata_rd)? max_pooling_number : cdata_rd ;
            3'd2: max_pooling_number <= (max_pooling_number > cdata_rd)? max_pooling_number : cdata_rd ;
            3'd3: max_pooling_number <= (max_pooling_number > cdata_rd)? max_pooling_number : cdata_rd ;
            3'd4: max_pooling_number <= (max_pooling_number > cdata_rd)? max_pooling_number : cdata_rd ;
            3'd5: max_pooling_number <= max_pooling_number ;
            default: max_pooling_number <= 20'd0 ;
        endcase
	end
	end
end


//------------------------------------------------------- layer2
always @(posedge clk or posedge reset)  // output csel
begin
	if (reset) 
	begin
	    csel <= 3'd0 ;
	end
	else begin
	   if (state == read_idata)
	   csel <= csel + 3'd1 ;
	   else if (Next_state == kernel0_finish)
	   csel <= csel + 3'd1 ;
	   else if (Next_state == kernel1_finish)
	   csel <= csel - 3'd1 ;
	   else if (Next_state == read_pooling0)
	   csel <= 3'd1 ;
	   else if (Next_state == write_pooling0)
	   csel <= 3'd3 ;
	   else if (Next_state == read_pooling1)
	   csel <= 3'd2 ;
	   else if (Next_state == write_pooling1)
	   csel <= 3'd4 ;
	   else if (Next_state == read_flatten_0)
	   csel <= 3'd3 ;
	   else if (Next_state == read_flatten_1)
	   csel <= 3'd4 ;
	   else if (Next_state == flatten_0 || Next_state == flatten_1)
	   csel <= 3'd5 ;
	end
end

always @(posedge clk or posedge reset)  //ooutput busy
begin
	if (reset) begin
	    busy <= 1'd0 ;
	end
	else begin
		busy <= (state == flatten_finish)? 1'd0 : 1'd1 ;
	end
end

always @(posedge clk or posedge reset) // state
begin
	if (reset) 
	begin
	    state <= read_idata ;
	end
	else begin
		state <= Next_state ;
	end
end

always @(*) // state change
begin
	case (state)
	read_idata: Next_state = top_left_zero_padding ;
    top_left_zero_padding:
    begin
        if (counter == 4'd9)
        Next_state = read_data ;
        else 
        Next_state = top_left_zero_padding ;
    end
    top_zero_padding:
    begin
    	if (counter == 4'd10)
        Next_state = read_data ;
        else 
        Next_state = top_zero_padding ;
    end
    top_right_zero_padding: 
    begin
    	if (counter == 4'd8)
        Next_state = read_data ;
        else 
        Next_state = top_right_zero_padding ;
    end
	mid_lift_zero_padding:
	begin
		if (counter == 4'd11)
        Next_state = read_data ;
        else 
        Next_state = mid_lift_zero_padding ;
    end
    mid_zero_padding:
	begin
		if (counter == 4'd14)
        Next_state = read_data ;
        else 
        Next_state = mid_zero_padding ;
    end
    mid_right_zero_padding:
	begin
		if (counter == 4'd11)
        Next_state = read_data ;
        else 
        Next_state = mid_right_zero_padding ;
    end
    bottom_lift_zero_padding:
	begin
		if (counter == 4'd9)
        Next_state = read_data ;
        else 
        Next_state = bottom_lift_zero_padding ;
    end
    bottom_zero_padding:
	begin
		if (counter == 4'd11)
        Next_state = read_data ;
        else 
        Next_state = bottom_zero_padding ;
    end
    bottom_right_zero_padding:
	begin
	    if (counter == 4'd9)
        Next_state = read_data ;
        else 
        Next_state = bottom_right_zero_padding ;
    end
    read_data: Next_state = choose_state ;
    choose_state:
	begin
        if (iaddr < 12'd62)
        Next_state = top_zero_padding ;
        else if (iaddr == 12'd62)
        Next_state = top_right_zero_padding ;
        else if (counter_mid_zero_padding == 7'd0 && iaddr < 12'd4031)
        Next_state = mid_lift_zero_padding ;
        else if (counter_mid_zero_padding < 63 && iaddr < 12'd4031)
        Next_state = mid_zero_padding ;
        else if (counter_mid_zero_padding == 63 && iaddr < 12'd4031)
        Next_state = mid_right_zero_padding ;
        else if (iaddr == 12'd4031)
        Next_state = bottom_lift_zero_padding ;
        else if (iaddr < 12'd4094)
        Next_state = bottom_zero_padding ;
        else if (iaddr == 12'd4094)
        Next_state = bottom_right_zero_padding ;
        else if (iaddr == 12'd4095 && csel == 3'd2)
        begin
        Next_state = kernel1_finish ;
        end
        else if (iaddr == 12'd4095)
        begin
        Next_state = kernel0_finish ;
        end
    end
    kernel0_finish: Next_state = top_left_zero_padding ;
    kernel1_finish: Next_state = read_pooling0 ;
    read_pooling0:
    begin 
        if (counter_polling == 3'd5)
        Next_state = write_pooling0 ;
        else
        Next_state = read_pooling0 ; 
    end
    write_pooling0:
    begin
        if (caddr_wr == 12'd1023)
        Next_state = polling_change ;
        else
        Next_state = read_pooling0 ;
    end
    polling_change: Next_state = read_pooling1 ;
    read_pooling1:
    begin 
        if (caddr_wr == 12'd1023)
        Next_state = max_pooling_finish ;
        else if (counter_polling == 3'd5)
        Next_state = write_pooling1 ;
        else
        Next_state = read_pooling1; 
    end
    write_pooling1:Next_state = read_pooling1 ;
    max_pooling_finish : Next_state = change_flatten ;
    change_flatten: Next_state = read_flatten_0 ;
    read_flatten_0: Next_state = flatten_0 ;
    flatten_0: Next_state = read_flatten_1 ;
    flatten_1:
    begin
        if (caddr_wr == 12'd2047)
        Next_state = flatten_finish ;
        else
     	Next_state = read_flatten_0 ;
    end
    read_flatten_1:
        Next_state = flatten_1 ;
    flatten_finish: Next_state = flatten_finish ;
	endcase
end

endmodule