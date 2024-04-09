//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   2021 ICLAB Spring Course
//   Lab03          : Knight’s Tour (KT)
//   Author         : CHAN-HAO LIAO (jericc880417@gmail.com)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   File Name   : KT.v
//   Module Name : KT
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module KT(
  input clk,
  input rst_n,
  input in_valid,
  input [2:0] in_x,
  input [2:0] in_y,
  input [4:0] move_num,
  input [2:0] priority_num,
  
  output reg out_valid,
  output reg [4:0] move_out,
  output reg [2:0] out_x,
  output reg [2:0] out_y

);
 
/////////////////////////////////////////////////////////////
reg [4:0] counter_record_xy ;
reg [4:0] counter_out ;
reg [4:0] counter_count_number ;

reg [2:0] c_x, c_y ;
reg [2:0] p_x, p_y ;
reg [2:0] s_priority ;
reg [2:0] c_priority ;
reg [4:0] c_move ;
reg [2:0] history_priority [0:24] ;
reg [2:0] record_x [0:24] ;
reg [2:0] record_y [0:24] ;
reg [0:24] check ;

reg [3:0] Current_state, Next_state ;
parameter IDLE              = 4'd0  ;
parameter Read_path         = 4'd1  ;
parameter Prediction_Move   = 4'd2  ;
parameter Back              = 4'd3  ;
parameter Continue_back     = 4'd4  ;
parameter Check_back_value  = 4'd5  ;
parameter Confirm_Move      = 4'd6  ;
parameter Data_Out          = 4'd14 ;
parameter Reset             = 4'd15 ;

integer i, j ;

/////////////////////////////////////////////////////////////
//    State change
////////////////////////////////////////////////////////////

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
	IDLE: Next_state = (in_valid)? Read_path : IDLE ;
	Read_path: Next_state = (in_valid)? Read_path : Prediction_Move ;
	Prediction_Move:
	begin
	    if(c_move == 5'd25)
	    Next_state = Data_Out ;
	    else if (check && (s_priority-1'd1 == c_priority))
	    Next_state = Back ;
	    else if ((p_x > 3'd4 || p_y > 3'd4) && (s_priority-1'd1 == c_priority))
	    Next_state = Back ;
	    else if (p_x > 3'd4 || p_y > 3'd4 || check) 
	    Next_state = Prediction_Move ;
	    else
	    Next_state = Confirm_Move ;
	end
	Back: Next_state = Continue_back ;
	Continue_back: Next_state = (s_priority == c_priority)? Back : Check_back_value ;
	Check_back_value: 
	begin
	    if (p_x > 3'd4 || p_y > 3'd4 && c_priority == s_priority)
	    Next_state = Back ;
	    else if (check && (c_priority == s_priority - 1'd1))
	    Next_state = Back ;
	    else
	    Next_state = Prediction_Move ;  
	end
	Confirm_Move: Next_state = Prediction_Move ; 
	Data_Out: Next_state = (counter_out == 5'd24)? Reset : Data_Out ;
	Reset: Next_state = IDLE ;
	default: Next_state = Current_state ;
	endcase
end

/////////////////////////////////////////////////////////////
//    counter_record_xy 
////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    counter_record_xy <= 5'd0 ;    
	end
	else begin
	   if (Current_state == Reset)
	   begin
	    	counter_record_xy <= 5'd0 ;
	   end
		 else if (in_valid == 1'd1)
		 begin
		 	  counter_record_xy <= counter_record_xy + 1'd1 ;
		 end
		 else if (Current_state == Confirm_Move) 
		 begin
		 	  counter_record_xy <= counter_record_xy + 1'd1 ;
		 end
		 else if (Current_state == Back) 
		 begin
		    counter_record_xy <= counter_record_xy - 1'd1 ;
		 end
	end
end		

/////////////////////////////////////////////////////////////
//    counter_out data 
////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    counter_out <= 5'd0 ;    
	end
	else begin
	   if (Current_state == Reset)
	   begin
	      counter_out <= 5'd0 ;
	   end
		 else if (Current_state == Data_Out)
		 begin
			  counter_out <= (counter_out == 5'd25)? 5'd0 : counter_out + 1'd1 ;
		 end
		 else begin
			  counter_out <= 5'd0 ;
	   end
	end
end		
		
/////////////////////////////////////////////////////////////
//    source_priority  
////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    s_priority <= 3'd0 ;    
	end
	else begin
	  if (Current_state == IDLE && in_valid)
	  begin
	 	  s_priority <= priority_num ;
	  end else 
	  begin
		  s_priority <= s_priority ; 
		end
	end
end

/////////////////////////////////////////////////////////////
//    record the current_priority
////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    for (i=0; i<3; i=i+1)
	    begin
	        for (j=0; j<25; j=j+1)
	        begin
	        	history_priority[j][i] <= 1'd0 ;
	        end
	    end    
	end
	else begin
	    if (Current_state == Reset)
	    begin
	    	for (i=0; i<3; i=i+1)
	        begin
	            for (j=0; j<25; j=j+1)
	            begin
	        	    history_priority[j][i] <= 1'd0 ;
	            end
	        end    
	    end
		else if (Current_state == Confirm_Move)
		begin
		    history_priority[counter_record_xy] <= c_priority - 1'd1  ;
		end
		else if (Current_state == Back) 
		begin
		    for (i=0; i<3; i=i+1)
		    begin
		    	history_priority[counter_record_xy][i] <= 1'd0 ;
		    end	
		end
	end
end


/////////////////////////////////////////////////////////////
//    record the current_priority
////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    c_priority <= 3'd0 ;    
	end
	else begin
	    if (Current_state == Reset)
	    begin
	    	c_priority <= 3'd0 ;
	    end
		else if (Current_state == IDLE && in_valid)
		begin
			c_priority <= priority_num ;
		end
		else if (Current_state == Confirm_Move)
	    begin
	    	c_priority <= s_priority ;
	    end
		else if (Current_state == Prediction_Move)
		begin
			 c_priority <= c_priority + 1'd1  ;
		end
		else if (Current_state == Back)
		begin
			c_priority <= history_priority[counter_record_xy - 1'd1] + 1'd1 ;
		end
	end
end

/////////////////////////////////////////////////////////////
//    record the prediction_x
////////////////////////////////////////////////////////////

always @(*) 
begin
	  p_x = 3'd0 ;    
	  if (Current_state == Reset || Current_state == IDLE)
	  begin
	    	p_x = 3'd0 ;    
	  end
		else if (in_valid)
		begin
			  p_x = in_x ;
		end
		else if (Current_state == Prediction_Move || (Current_state == Continue_back && s_priority - 1'd1 == c_priority)) 
		begin
			case(c_priority)
			3'd0: p_x = c_x - 3'd1 ;
      3'd1: p_x = c_x + 3'd1 ;
      3'd2: p_x = c_x + 3'd2 ;
      3'd3: p_x = c_x + 3'd2 ;
      3'd4: p_x = c_x + 3'd1 ;
      3'd5: p_x = c_x - 3'd1 ;
      3'd6: p_x = c_x - 3'd2 ;
      3'd7: p_x = c_x - 3'd2 ;	
      default: p_x = 3'd0 ;	
			endcase 
		end
		else if (Current_state == Confirm_Move)
		begin
			  case(c_priority - 1'd1)
			3'd0: p_x = c_x - 3'd1 ;
      3'd1: p_x = c_x + 3'd1 ;
      3'd2: p_x = c_x + 3'd2 ;
      3'd3: p_x = c_x + 3'd2 ;
      3'd4: p_x = c_x + 3'd1 ;
      3'd5: p_x = c_x - 3'd1 ;
      3'd6: p_x = c_x - 3'd2 ;
      3'd7: p_x = c_x - 3'd2 ;	
      default: p_x = 3'd0 ;	
			endcase 
		end
		else if (Current_state == Back)
		begin
		    for (i=0; i<3; i=i+1)
		    begin
			    p_x[i] = record_y[counter_record_xy-3'd2][i] ;
			  end
		end
		else begin
			p_x = record_x[counter_record_xy-1'd1] ;
		end
end

/////////////////////////////////////////////////////////////
//    record the prediction_y
////////////////////////////////////////////////////////////

always @(*) 
begin
	  p_y = 3'd0 ;    
	  if (Current_state == Reset || Current_state == IDLE)
	  begin
	    	p_y = 3'd0 ;    
	  end
		else if (in_valid)
		begin
			  p_y = in_y ;
		end
		else if (Current_state == Prediction_Move || (Current_state == Continue_back && s_priority - 1'd1 == c_priority)) 
		begin
			case(c_priority)
			3'd0: p_y = c_y + 3'd2 ;
      3'd1: p_y = c_y + 3'd2 ;
      3'd2: p_y = c_y + 3'd1 ;
      3'd3: p_y = c_y - 3'd1 ;
      3'd4: p_y = c_y - 3'd2 ;
      3'd5: p_y = c_y - 3'd2 ;
      3'd6: p_y = c_y - 3'd1 ;
      3'd7: p_y = c_y + 3'd1 ;	
      default: p_y = 3'd0 ;		
			endcase 
		end
		else if (Current_state == Confirm_Move)
		begin
			case(c_priority - 1'd1)
			3'd0: p_y = c_y + 3'd2 ;
      3'd1: p_y = c_y + 3'd2 ;
      3'd2: p_y = c_y + 3'd1 ;
      3'd3: p_y = c_y - 3'd1 ;
      3'd4: p_y = c_y - 3'd2 ;
      3'd5: p_y = c_y - 3'd2 ;
      3'd6: p_y = c_y - 3'd1 ;
      3'd7: p_y = c_y + 3'd1 ;	
      default: p_y = 3'd0 ;		
			endcase 
		end
		else if (Current_state == Back)
		begin
		    for (i=0; i<3; i=i+1)
		    begin
			    p_y[i] = record_y[counter_record_xy-3'd2][i] ;
			  end
		end
		else begin
			p_y = record_y[counter_record_xy-1'd1] ;
		end
end

/////////////////////////////////////////////////////////////
//    record the current_x
////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    c_x <= 3'd0 ;    
	end
	else begin
	  if (Current_state == Reset)
	  begin
	    c_x <= 3'd0 ;    
	  end
		else if (in_valid)
		begin
			c_x <= in_x ;
		end
		else if (Current_state == Confirm_Move) 
		begin
        c_x <= p_x ;		
		end
		else if (Current_state == Back)
		begin
		    for (i=0; i<3; i=i+1)
		    begin
			    c_x[i] <= record_x[c_move-3'd2][i] ;
			  end
		end
	end
end

/////////////////////////////////////////////////////////////
//    record the current_y
////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    c_y <= 3'd0 ;    
	end
	else begin
	    if (Current_state == Reset)
	    begin
	    	c_y <= 3'd0 ;    
	    end
		else if (in_valid)
		begin
			c_y <= in_y ;
		end
		else if (Current_state == Confirm_Move) 
		begin
			c_y <= p_y ;
		end
		else if (Current_state == Back)
		begin
		    for (i=0; i<3; i=i+1)
		    begin
			    c_y[i] <= record_y[c_move-3'd2][i] ;
			  end
		end
	end
end

/////////////////////////////////////////////////////////////
//    record the C_move
////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    c_move <= 5'd0 ;    
	end
	else begin
	    if (Current_state == Reset)
	    begin
	    	c_move <= 5'd0 ;
	    end
		else if (Current_state == IDLE && in_valid)
		begin
			c_move <= move_num ;
		end
		else if (Current_state == Confirm_Move) 
		begin
			c_move <= c_move + 1'd1 ;
		end
		else if (Current_state == Back)
		begin
			c_move <= c_move - 1'd1 ;
		end
	end
end

///////////////////////////////////////////////////////////
//   Check path replit 
//////////////////////////////////////////////////////////

always @(*) 
begin
	  check = 25'd0 ;
	if (Current_state == Back)
	begin
		check = 25'd0 ; 
	end
	else if (Current_state == Prediction_Move)
	begin
	    for (i=0; i<counter_record_xy; i=i+1)
	    begin
	        check[i] = (record_x[i] == p_x && record_y[i] == p_y)? 1'd1 : 1'd0 ;	
	    end
	end
end

///////////////////////////////////////////////////////////
//   record_path 
//////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    for (i=0; i<3; i=i+1)
	    begin
	        for (j=0; j<25; j=j+1)
            begin
	            record_x[j][i] <= 3'd0 ;	
	         end
	    end
	end 
	else begin
	if (Current_state == Reset)
	begin
	    for (i=0; i<3; i=i+1)
	    begin
	        for (j=0; j<25; j=j+1)
            begin
	            record_x[j][i] <= 3'd0 ;	
	         end
	    end
	end 
	else if (in_valid)
	begin
	    for (i=0; i<3; i=i+1)
	    begin
		    record_x[counter_record_xy][i] <= in_x[i] ;
		end
	end
	else if (Current_state == Confirm_Move)
	begin
		for (i=0; i<3; i=i+1)
		begin
			record_x[c_move][i] <= p_x[i] ;
		end
	end
	else if (Current_state == Back)
	begin
		for (i=0; i<3; i=i+1)
		begin
			record_x[c_move][i] <= 1'd0 ;
		end
	end
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    for (i=0; i<3; i=i+1)
	    begin
	        for (j=0; j<25; j=j+1)
            begin
	            record_y[j][i] <= 3'd0 ;	
	         end
	    end
	end 
	else begin
	if (Current_state == Reset)
	begin
	    for (i=0; i<3; i=i+1)
	    begin
	        for (j=0; j<25; j=j+1)
            begin
	            record_y[j][i] <= 3'd0 ;	
	         end
	    end
	end 
	else if (in_valid)
	begin
	    for (i=0; i<3; i=i+1)
	    begin
		    record_y[counter_record_xy][i] <= in_y[i] ;
		end
	end
	else if (Current_state == Confirm_Move)
	begin
		for (i=0; i<3; i=i+1)
		begin
			record_y[c_move][i] <= p_y[i] ;
		end
	end
	else if (Current_state == Back)
	begin
		for (i=0; i<3; i=i+1)
		begin
			record_y[c_move][i] <= 1'd0 ;
		end
	end
	end
end

///////////////////////////////////////////////////////////
//   Data_Out
//////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    out_x <= 3'd0 ;    
	end
	else if (Current_state == Data_Out)
	begin
	    for (i=0; i<3; i=i+1)
	    begin
	 	    out_x[i] <= (Current_state == Data_Out)? record_x[counter_out][i] : 3'd0 ;
	 	end
	end
	else begin
		out_x <= 3'd0 ;
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    out_y <= 3'd0 ;    
	end
	else if (Current_state == Data_Out)
	begin
	    for (i=0; i<3; i=i+1)
	    begin
	 	    out_y[i] <= (Current_state == Data_Out)? record_y[counter_out][i] : 3'd0 ;
	 	end
	end
	else begin
		out_y <= 3'd0 ;
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    out_valid <= 1'd0 ;    
	end
	else if (Current_state == Data_Out)
	begin
	    out_valid <= 1'd1 ;
	end
	else begin
		out_valid <= 1'd0 ;
	end
end

always @(posedge clk or negedge rst_n) 
begin
	if (!rst_n) 
	begin
	    move_out <= 5'd0 ;    
	end
	else if (Current_state == Data_Out)
	begin
	    move_out <= move_out + 1'd1 ;
	end
	else if (Current_state == Reset)
	begin
		move_out <= 5'd0 ;
	end
end

endmodule
