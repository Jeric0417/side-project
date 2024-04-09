module huffman(clk, reset, gray_valid, gray_data, CNT_valid, CNT1, CNT2, CNT3, CNT4, CNT5, CNT6,code_valid, HC1, HC2, HC3, HC4, HC5, HC6, M1, M2, M3, M4, M5, M6);

input clk;
input reset;
input gray_valid;
input [7:0] gray_data;
output reg CNT_valid;
output reg [7:0] CNT1, CNT2, CNT3, CNT4, CNT5, CNT6;
output reg code_valid;
output reg [7:0] HC1, HC2, HC3, HC4, HC5, HC6;
output reg [7:0] M1, M2, M3, M4, M5, M6;
//----------------------------------------------------------------------------------
reg [2:0] counter_delay ;
reg [2:0] counter_HC ;
reg [4:0] counter_compare ;
reg [3:0] state, Next_state ;
reg [7:0] comb1_number=8'd0 ;
reg [7:0] comb2_number=8'd0 ;
reg [7:0] comb3_number=8'd0 ;
reg [7:0] comb4_number=8'd0 ;
reg [7:0] CNT_1, CNT_2, CNT_3, CNT_4, CNT_5, CNT_6 ;

reg [7:0] A [1:6] ;
reg [7:0] P [1:6] ;
reg [7:0] code [1:6] ; 
reg [7:0] M [1:6] ; 

integer i ;
parameter read_data = 4'd0 ; 
parameter count_data = 4'd1 ;
parameter count_out = 4'd2 ;
parameter give_data = 4'd3 ;
parameter compare_data = 4'd4 ;
parameter comb1 = 4'd5 ;
parameter comb2 = 4'd6 ;
parameter comb3 = 4'd7 ;
parameter comb4 = 4'd8 ;
parameter split1 = 4'd9 ;
parameter split2 = 4'd10 ;
parameter split3 = 4'd11 ;
parameter split4 = 4'd12 ;
parameter split5 = 4'd13 ;
parameter check = 4'd14 ;
parameter finish = 4'd15 ;


always @(posedge clk or posedge reset)  //delay for gray_valid
begin
	if (reset) 
	begin
	    counter_delay <= 3'd0 ;
	end
	else begin
		if (counter_delay == 3'd2)
		   counter_delay <= counter_delay ;
		else
		   counter_delay <= counter_delay + 1'd1 ;
	end
end

always @(posedge clk or posedge reset)  // counter for HC
begin
	if (reset) 
	begin
	    counter_HC <= 3'd0 ;
	end
	else begin
	   if (state == split5)
	      counter_HC <= 3'd1 ;
		else if (counter_HC == 3'd6)
		   counter_HC <= counter_HC ;
		else
		   counter_HC <= counter_HC + 1'd1 ;
	end
end

always @(posedge clk or posedge reset)  //counter for compare
begin
	if (reset) 
	begin
	    counter_compare <= 5'd0 ;
	end
	else begin
		if (counter_compare == 5'd20)
		   counter_compare <= counter_compare ;
		else if (Next_state == compare_data)
		   counter_compare <= counter_compare + 1'd1 ;
	end
end

always@ (posedge clk or posedge reset) // CN1 output
begin
	if (reset)
	    CNT1 <= 8'd0 ;
	else if (gray_data == 8'd1 && Next_state == count_data)
	    CNT1 <= CNT1 + 1'd1 ;
end

always@ (posedge clk or posedge reset) // CN2 output
begin
	if (reset)
	    CNT2 <= 8'd0 ;
	else if (gray_data == 8'd2 && Next_state == count_data)
	    CNT2 <= CNT2 + 1'd1 ;
end

always@ (posedge clk or posedge reset) // CN3 output
begin
	if (reset)
	    CNT3 <= 8'd0 ;
	else if (gray_data == 8'd3 && Next_state == count_data)
	    CNT3 <= CNT3 + 1'd1 ;
end

always@ (posedge clk or posedge reset) // CN4 output
begin
	if (reset)
	    CNT4 <= 8'd0 ;
	else if (gray_data == 8'd4 && Next_state == count_data)
	    CNT4 <= CNT4 + 1'd1 ;
end

always@ (posedge clk or posedge reset) // CN5 output
begin
	if (reset)
	    CNT5 <= 8'd0 ;
	else if (gray_data == 8'd5 && Next_state == count_data)
	    CNT5 <= CNT5 + 1'd1 ;
end

always@ (posedge clk or posedge reset) // CN6 output
begin
	if (reset)
	    CNT6 <= 8'd0 ;
	else if (gray_data == 8'd6 && Next_state == count_data)
	    CNT6 <= CNT6 + 1'd1 ;
end

always @(posedge clk or posedge reset) // code_valid output
begin
	if (reset) 
	    code_valid <= 1'd0 ;
	else 
		code_valid <= (state == finish)? 1'd1 : 1'd0 ;
end

always @(posedge clk or posedge reset) // CNT_vaild output
begin
	if (reset) 
	    CNT_valid <= 1'd0 ;
	else 
		CNT_valid <= (state == count_out)? 1'd1 : 1'd0 ;
end

always @(posedge clk or posedge reset)
begin
	if (reset)
	   state <= read_data ;
	else
	   state <= Next_state ;
end

always @(posedge clk or posedge reset) // give data for CNT_1~6
begin
 	if (reset)
 	begin
 		CNT_1 <= 8'd0 ;
 		CNT_2 <= 8'd0 ;
 		CNT_3 <= 8'd0 ;
 		CNT_4 <= 8'd0 ;
 		CNT_5 <= 8'd0 ;
 		CNT_6 <= 8'd0 ;
 	end
 	else if (state == give_data)
 	begin
 	   CNT_1 <= CNT1 ;
 		CNT_2 <= CNT2 ;
 		CNT_3 <= CNT3 ;
 		CNT_4 <= CNT4 ;
 		CNT_5 <= CNT5 ;
 		CNT_6 <= CNT6 ;
 	end
 	else if (state == compare_data)
 	begin
	   if (CNT_2 > CNT_1)
	   begin
	     	CNT_1 <= CNT_2 ;
	     	CNT_2 <= CNT_1 ;
	     	end
	   else if (CNT_3 > CNT_2)
	   begin
	     	CNT_2 <= CNT_3 ;
	     	CNT_3 <= CNT_2 ;

	    end
	    else if (CNT_4 > CNT_3)
	    begin
	     	CNT_3 <= CNT_4 ;
	     	CNT_4 <= CNT_3 ;
	   end
	   else if (CNT_5 > CNT_4)
	   begin
	     	CNT_4 <= CNT_5 ;
	     	CNT_5 <= CNT_4 ;
	   end
	   else if (CNT_6 > CNT_5)
	   begin
	     	CNT_5 <= CNT_6 ;
	     	CNT_6 <= CNT_5 ;
	   end
 	end
end

always @(posedge clk or posedge reset) // compare_data
begin
   if (reset)
   begin
      A[1]<= 8'd1 ;      
      A[2]<= 8'd2 ;
      A[3]<= 8'd3 ;
      A[4]<= 8'd4 ;
      A[5]<= 8'd5 ;
      A[6]<= 8'd6 ;      
   end
	else begin
	if (state == compare_data)
	begin
	   if (CNT_2 > CNT_1)
	   begin
	      A[1] <= A[2] ;
	      A[2] <= A[1] ;
	   end
	   else if (CNT_3 > CNT_2)
	   begin
	      A[2] <= A[3] ;
	      A[3] <= A[2] ;
	   end
	   else if (CNT_4 > CNT_3)
	   begin
	      A[3] <= A[4] ;
	      A[4] <= A[3] ;
	   end
	   else if (CNT_5 > CNT_4)
	   begin
	      A[4] <= A[5] ;
	      A[5] <= A[4] ;
	   end
	   else if (CNT_6 > CNT_5)
	   begin
	      A[5] <= A[6] ;
	      A[6] <= A[5] ;
	   end
	end
	end
end

always @(posedge clk or posedge reset) //for comb1
begin
	if (reset) 
	begin
	   for(i=1; i<7; i=i+1)
	   begin
	   	P[i] <= 8'd0 ;
	   end
	end
	else begin
	if (state == give_data)
	begin
	   P[1] <= CNT1 ;
	   P[2] <= CNT2 ;
	   P[3] <= CNT3 ;
	   P[4] <= CNT4 ;
	   P[5] <= CNT5 ;
	   P[6] <= CNT6 ;
	end
	else if (state == compare_data)
	begin
	      if (CNT_2 > CNT_1)
	      begin
	     	   P[1] <= P[2] ;
	     	   P[2] <= P[1] ;
	     	end
	      else if (CNT_3 > CNT_2)
	      begin
	     	   P[2] <= P[3] ;
	     	   P[3] <= P[2] ;
	     	end
	      else if (CNT_4 > CNT_3)
	      begin
	     	   P[3] <= P[4] ;
	     	   P[4] <= P[3] ;
	      end
	      else if (CNT_5 > CNT_4)
	      begin
	     	   P[4] <= P[5] ;
	     	   P[5] <= P[4] ;
	      end
	      else if (CNT_6 > CNT_5)
	      begin
	     	   P[5] <= P[6] ;
	     	   P[6] <= P[5] ;
	      end
	end
	else if (state == comb1)
		begin
		   if (P[1] < P[5]+P[6])
		   begin
		      comb1_number <= P[5]+P[6] ;
		      P[1] <= P[5]+P[6] ;
		      P[2] <= P[1] ;
		      P[3] <= P[2] ;
		      P[4] <= P[3] ;
		      P[5] <= P[4] ;
		   end
		   else if (P[2] < P[5]+P[6])
		   begin
		      comb1_number <= P[5]+P[6] ;
		      P[2] <= P[5]+P[6] ;
		      P[3] <= P[2] ;
		      P[4] <= P[3] ;
		      P[5] <= P[4] ;
		   end
		   else if (P[3] < P[5]+P[6])
		   begin
		      comb1_number <= P[5]+P[6] ;
		      P[3] <= P[5]+P[6] ;
		      P[4] <= P[3] ;
		      P[5] <= P[4] ;
		   end
		   else if (P[4] < P[5]+P[6])
		   begin
		      comb1_number <= P[5]+P[6] ;
		      P[4] <= P[5]+P[6] ;
		      P[5] <= P[4] ;
		   end
		   else if (P[5] < P[5]+P[6])
		   begin
		      comb1_number <= P[5]+P[6] ;
		      P[5] <= P[5]+P[6] ;
		   end
      end
      else if (state == comb2)                   // comb2
	   begin
		   if (P[1] < P[4]+P[5])
		   begin
		      comb2_number <= P[4]+P[5] ;
		      P[1] <= P[4]+P[5] ;
		      P[2] <= P[1];
		      P[3] <= P[2];
		      P[4] <= P[3];
		   end
		   else if (P[1] < P[4]+P[5])
		   begin
		      comb2_number <= P[4]+P[5] ;
		      P[1] <= P[4]+P[5] ;
		      P[2] <= P[2];
		      P[3] <= P[3];
		   end
		   else if (P[2] < P[4]+P[5])
		   begin
		      comb2_number <= P[4]+P[5] ;
		      P[2] <= P[4]+P[5] ;
		      P[3] <= P[3];
		   end
		   else if (P[3] < P[4]+P[5])
		   begin
		      comb2_number <= P[4]+P[5] ;
		      P[3] <= P[4]+P[5] ;
		      P[4] <= P[3] ;
		   end
		   else if (P[3] > P[4]+P[5 ])
		   begin
		      comb2_number <= P[4]+P[5] ;
		      P[4] <= P[4]+P[5] ;
		   end
	   end
	   else if (state == comb3)         //comb3
		begin
		   if (P[1] < P[3]+P[4])
		   begin
		      comb3_number <= P[3]+P[4] ;
		   	P[1] <= P[3]+P[4] ;
		   	P[2] <= P[1] ;
		   	P[3] <= P[2] ;
		   end 
		   else if (P[2] < P[3]+P[4])
		   begin
		      comb3_number <= P[3]+P[4] ;
		   	P[2] <= P[3]+P[4] ;
		   	P[3] <= P[2] ;
		   end
		   else if (P[2] > P[3]+P[4])
		   begin
		      comb3_number <= P[3]+P[4] ;
		   	P[3] <= P[3]+P[4] ;
		   end
		   else if (P[2] == P[3]+P[4])
		   begin
		   	comb3_number <= P[3]+P[4] ;
		   	P[3] <= P[3]+P[4] ;
		   end
      end
      else if (state == comb4)  //comb4
		begin
		   if (P[1] < P[2]+P[3]) 
		   begin
		      comb4_number <= P[2]+P[3] ;
		   	P[1] <= P[2]+P[3] ;
          	P[2] <= P[1] ;
		   end
		   else begin
		      comb4_number <= P[2]+P[3] ;
		      P[2] <= P[2]+P[3] ;
		   end
      end
      else if (state == split1) // for split1
		begin
		   if (P[1] == comb4_number)
		   begin
		      P[1] <= P[2] ;
		      P[2] <= P[1]-P[3] ;
		   end
		   else begin
		      P[2] <= P[2]-P[3] ;
		   end
	   end
	   else if (state == split2)
	   begin
		   if (P[2] == comb3_number) //for split2
		   begin
		      P[2] <= P[3] ;
		      P[3] <= P[2]-P[4] ;
		   end
		   else begin
            P[3] <= P[3]-P[4] ;
		   end
      end
      else if (state == split3) //for split3
	   begin
		   if (P[3] == comb2_number)
		   begin
		      P[3] <= P[4] ;
		      P[4] <= P[3]-P[5] ;
		   end
		   else begin
            P[4] <= P[4]-P[5] ;
		   end
      end
      else if (state == split4)
	   begin
		   if (P[4] == comb1_number || P[3] == comb1_number)
		   begin
		      P[3] <= CNT_3 ; 
		      P[4] <= P[5] ;
		      P[5] <= P[3]-P[6] ;
		   end
		   else begin
            P[5] <= P[5]-P[6] ; 
		   end
      end
	end
end

//-------------------------------------------  huffman_code
always @(posedge clk or posedge reset)  
begin
   if (reset)
   begin
   	code[1] <= 8'd0 ;
   end
   else begin
      if (state == split1)
      	code[1] <= (P[1] > comb4_number)? 8'd0 : 8'd1 ;
   end
end

always @(posedge clk or posedge reset)  
begin
   if (reset)
   begin
   	code[2] <= 8'd0 ;
   end
   else begin
      if (state == split1)
      	code[2] <= (P[1] > comb4_number)? 8'd1 : 8'd0 ;
      else if (state == split2 && P[2] == comb3_number)
         code[2] <= (P[2] >= comb3_number && CNT_2 == comb3_number)? code[2]<<1 : (code[2]<<1)+1 ;
      else if (state == split2)
      	code[2] <= (P[2] >= comb3_number)? code[2]<<1 : (code[2]<<1)+1 ;
   end
end

always @(posedge clk or posedge reset)  
begin
   if (reset)
   begin
   	code[3] <= 8'd0 ;
   end
   else begin
      if (state == split1)
      	code[3] <= (P[1] > comb4_number)? 8'd1 : 8'd0 ; 
      else if (state == split2 && P[2] == comb3_number)
         code[3] <= (P[2] >= comb3_number && CNT_2 == comb3_number)? (code[3]<<1)+1 : code[3]<<1 ;
      else if (state == split2)
         code[3] <= (P[2] >= comb3_number )? (code[3]<<1)+1 : code[3]<<1 ;
      else if (state == split3 && P[3] == comb2_number && P[4] == P[5])
         code[3] <= (code[3]<<1)+1 ;
      else if (state == split3 && P[3] == comb2_number)
         code[3] <= (P[3] > comb2_number)? (code[3]<<1)+1 : code[3]<<1 ;
      else if (state == split3)
      	code[3] <= (P[3] > comb2_number)? code[3]<<1 : (code[3]<<1)+1 ;
   end
end

always @(posedge clk or posedge reset)  
begin
   if (reset)
   begin
   	code[4] <= 8'd0 ;
   end
   else begin
      if (state == split1)
      	code[4] <= (P[1] > comb4_number)? 8'd1 : 8'd0 ;
      else if (state == split2 && P[2] == comb3_number && P[4] == P[5])
      	code[4] <= (code[4]<<1)+1 ;
      else if (state == split2 && P[2] == comb3_number && P[4] == comb1_number)
      	code[4] <= code[4]<<1 ;
      else if (state == split2)
      	code[4] <= (P[2] >= comb3_number)? (code[4]<<1)+1 : code[4]<<1 ;
      else if (state == split3 && P[3] == comb2_number)
      	code[4] <= (P[3] > comb1_number)? code[4]<<1 : (code[4]<<1)+1 ;
      else if (state == split3)
      	code[4] <= (P[3] > comb2_number)? (code[4]<<1)+1 : code[4]<<1 ;
      else if (state == split4)
      	code[4] <= (P[4] >= comb1_number)? code[4]<<1 : (code[4]<<1)+1 ;
   end
end

always @(posedge clk or posedge reset)  
begin
   if (reset)
   begin
   	code[5] <= 8'd0 ;
   end
   else begin
      if (state == split1)
      	code[5] <= (P[1] > comb4_number)? 8'd1 : 8'd0 ;
      else if (state == split2 && P[2] == comb3_number && P[4] == P[5])
      	code[5] <= (code[5]<<1)+1 ;
      else if (state == split2 && P[2] == comb3_number && P[3] == CNT2)
         code[5] <= code[5]<<1 ;
      else if (state == split2)
      	code[5] <= (P[2] >= comb3_number)? (code[5]<<1)+1 : code[5]<<1 ;
       else if (state == split3 && P[3] == comb2_number && P[4] == P[5])
           code[5] <= (P[3] > P[4])? code[5]<<1 : (code[5]<<1)+1 ;
      else if (state == split3 && P[3] == comb2_number)
           code[5] <= (P[3] > P[4])? (code[5]<<1)+1 : code[5]<<1 ;
      else if (state == split3)
      	code[5] <= (P[3] > comb2_number)? (code[5]<<1)+1 : code[5]<<1 ;
      else if (state == split4 && P[3] == comb1_number && P[3]==P[4])
      	code[5] <= (code[5]<<1)+1 ;
      else if (state == split4 && P[3] == comb1_number)
      	code[5] <= code[5] ;
      else if (state == split4)
      	code[5] <= (P[4] >= comb1_number)? (code[5]<<1)+1 : code[5]<<1 ;
      else if (state == split5)
      	code[5] <= (P[5] > P[6])? code[5]<<1 : (code[5]<<1)+1 ;

   end
end

always @(posedge clk or posedge reset)  
begin
   if (reset)
   begin
   	code[6] <= 8'd0 ;
   end
   else begin
      if (state == split1)
      	code[6] <= (P[1] > comb4_number)? 8'd1 : 8'd0 ;
      else if (state == split2 && P[2] == comb3_number && P[4] == P[5])
      	code[6] <= (code[6]<<1)+1 ;
      else if (state == split2 && P[2] == comb3_number && P[3] == CNT2)
         code[6] <= code[6]<<1 ;
      else if (state == split2)
      	code[6] <= (P[2] >= comb3_number)? (code[6]<<1)+1 : code[6]<<1 ;
      else if (state == split3 && P[3] == comb2_number && P[4] == P[5])
           code[6] <= code[6]<<1 ;
      else if (state == split3 && P[3] == comb2_number)
           code[6] <= (P[3] > P[4])? (code[6]<<1)+1 : code[6]<<1 ;
      else if (state == split3)
      	code[6] <= (P[3] > comb2_number)? (code[6]<<1)+1 : code[6]<<1 ;
      else if (state == split4 && P[3] == comb1_number && P[4] == P[5])
      	code[6] <= (code[6]<<1)+1 ;
      else if (state == split4 && P[3] == comb1_number)
      	code[6] <= code[6] ;
      else if (state == split4)
      	code[6] <= (P[4] >= comb1_number)? (code[6]<<1)+1 : code[6]<<1 ;
      else if (state == split5)
      	code[6] <= (code[6]<<1)+1 ;
   end
end

//-------------------------------------------  M_code
always @(posedge clk or posedge reset)  
begin
   if (reset)
   begin
   	M[1] <= 8'd0 ;
   end
   else begin
      if (state == split1)
      	M[1] <= (P[1] > comb4_number)? 8'd1 : 8'd1 ;
   end
end

always @(posedge clk or posedge reset)  
begin
   if (reset)
   begin
   	M[2] <= 8'd0 ;
   end
   else begin
      if (state == split1)
      	M[2] <= (P[1] > comb4_number)? 8'd1 : 8'd1 ;
      else if (state == split2)
      	M[2] <= (P[2] >= comb3_number && CNT2 == comb3_number)? (M[2]<<1)+1 : (M[2]<<1)+1 ;
   end
end

always @(posedge clk or posedge reset)  
begin
   if (reset)
   begin
   	M[3] <= 8'd0 ;
   end
   else begin
      if (state == split1)
      	M[3] <= (P[1] > comb4_number)? 8'd1 : 8'd1 ;
      else if (state == split2)
      	M[3] <= (P[2] >= comb3_number && CNT2 == comb3_number)? (M[3]<<1)+1 : (M[3]<<1)+1 ;
      else if (state == split3 && P[3] == comb2_number && P[4] != P[5])
         M[3] <= (M[3]<<2)+3 ;
      else if (state == split3)
      	M[3] <= (P[3] > comb2_number)? (M[3]<<1)+1 : (M[3]<<1)+1 ;
   end
end

always @(posedge clk or posedge reset)  
begin
   if (reset)
   begin
   	M[4] <= 8'd0 ;
   end
   else begin
      if (state == split1)
      	M[4] <= (P[1] > comb4_number)? 8'd1 : 8'd1 ;
      else if (state == split2)
      	M[4] <= (P[2] >= comb3_number && CNT2 == comb3_number)? (M[4]<<1)+1 : (M[4]<<1)+1 ;
      else if (state == split3)
      	M[4] <= (P[3] > comb2_number)? (M[4]<<1)+1 : (M[4]<<1)+1 ;
      else if (state == split4)
      	M[4] <= (P[4] > comb1_number)? (M[4]<<1)+1 : (M[4]<<1)+1 ;
   end
end

always @(posedge clk or posedge reset)  
begin
   if (reset)
   begin
   	M[5] <= 8'd0 ;
   end
   else begin
      if (state == split1)
      	M[5] <= (P[1] > comb4_number)? 8'd1 : 8'd1 ;
      else if (state == split2)
      	M[5] <= (P[2] >= comb3_number && CNT2 == comb3_number)? (M[5]<<1)+1 : (M[5]<<1)+1 ;
      else if (state == split3 && P[3] == comb2_number && P[4] != P[5])
         M[5] <= M[5] ;
      else if (state == split3)
      	M[5] <= (P[3] > comb2_number)? (M[5]<<1)+1 : (M[5]<<1)+1 ;
      else if (state == split4)
      	M[5] <= (P[4] > comb1_number)? (M[5]<<1)+1 : (M[5]<<1)+1 ;
      else if (state == split5)
      	M[5] <= (P[5] > P[6])? (M[5]<<1)+1 : (M[5]<<1)+1 ;

   end
end

always @(posedge clk or posedge reset)  
begin
   if (reset)
   begin
   	M[6] <= 8'd0 ;
   end
   else begin
      if (state == split1)
      	M[6] <= (P[1] > comb4_number)? 8'd1 : 8'd1 ;
      else if (state == split2)
      	M[6] <= (P[2] >= comb3_number && CNT2 == comb3_number)? (M[6]<<1)+1 : (M[6]<<1)+1 ;
      else if (state == split3 && P[3] == comb2_number && P[4] != P[5])
         M[6] <= M[6] ;
      else if (state == split3)
      	M[6] <= (P[3] > comb2_number)? (M[6]<<1)+1 : (M[6]<<1)+1 ;
      else if (state == split4)
      	M[6] <= (P[4] > comb1_number)? (M[6]<<1)+1 : (M[6]<<1)+1 ;
      else if (state == split5)
      	M[6] <= (M[6]<<1)+1 ;
   end
end
//---------------------------------------------------------  HC_OUT
always @(posedge clk or posedge reset)
begin
	if (reset)
	begin
		HC1 <= 8'd0 ;
	end
	else begin
	   if (state == check)
	   begin
	      HC1 <= (A[counter_HC] == 8'd1)? code[counter_HC] : HC1 ;
	   end
	end
end

always @(posedge clk or posedge reset)
begin
	if (reset)
	begin
		HC2 <= 8'd0 ;
	end
	else begin
	    if (state == check)
	   begin
	      HC2 <= (A[counter_HC] == 8'd2)? code[counter_HC] : HC2 ;
	   end
	end
end

always @(posedge clk or posedge reset)
begin
	if (reset)
	begin
		HC3 <= 8'd0 ;
	end
	else begin
	   if (state == check)
	   begin     
	      HC3 <= (A[counter_HC] == 8'd3)? code[counter_HC] : HC3 ;
	   end
	end
end

always @(posedge clk or posedge reset)
begin
	if (reset)
	begin
		HC4 <= 8'd0 ;
	end
	else begin
	   if (state == check)
	   begin
	      HC4 <= (A[counter_HC] == 8'd4)? code[counter_HC] : HC4 ;
	   end
	end
end

always @(posedge clk or posedge reset)
begin
	if (reset)
	begin
		HC5 <= 8'd0 ;
	end
	else begin
	   if (state == check)
	   begin
	      HC5 <= (A[counter_HC] == 8'd5)? code[counter_HC] : HC5 ;
	   end
	end
end

always @(posedge clk or posedge reset)
begin
	if (reset)
	begin
		HC6 <= 8'd0 ;
	end
	else begin
	   if (state == check)
	   begin
	      HC6 <= (A[counter_HC] == 8'd6)? code[counter_HC] : HC6 ;
	   end
	end
end
//---------------------------------------------------------  M_OUT
always @(posedge clk or posedge reset)
begin
	if (reset)
	begin
		M1 <= 8'd0 ;
	end
	else begin
	   if (state == check)
	   begin
	     M1 <= (A[counter_HC] == 8'd1)? M[counter_HC] : M1 ;
	   end
	end
end

always @(posedge clk or posedge reset)
begin
	if (reset)
	begin
		M2 <= 8'd0 ;
	end
	else begin
	    if (state == check)
	   begin
	      M2 <= (A[counter_HC] == 8'd2)? M[counter_HC] : M2 ;
	   end
	end
end

always @(posedge clk or posedge reset)
begin
	if (reset)
	begin
		M3 <= 8'd0 ;
	end
	else begin
	   if (state == check)
	   begin     
	      M3 <= (A[counter_HC] == 8'd3)? M[counter_HC] : M3 ;
	   end
	end
end

always @(posedge clk or posedge reset)
begin
	if (reset)
	begin
		M4 <= 8'd0 ;
	end
	else begin
	   if (state == check)
	   begin
	      M4 <= (A[counter_HC] == 8'd4)? M[counter_HC] : M4 ;
	   end
	end
end

always @(posedge clk or posedge reset)
begin
	if (reset)
	begin
		M5 <= 8'd0 ;
	end
	else begin
	   if (state == check)
	   begin
	      M5 <= (A[counter_HC] == 8'd5)? M[counter_HC] : M5 ;
	   end
	end
end

always @(posedge clk or posedge reset)
begin
	if (reset)
	begin
		M6 <= 8'd0 ;
	end
	else begin
	   if (state == check)
	   begin
	      M6 <= (A[counter_HC] == 8'd6)? M[counter_HC] : M6 ;
	   end
	end
end

//---------------------------------------------------------  stage_change
always @(*)
begin
	case(state)
	read_data:
	begin
	    if (counter_delay == 3'd2) 
	       Next_state = count_data ;
	    else
	       Next_state = read_data ;
	end
	count_data:
	begin
	 	if (gray_data == 1'd0)
	 	   Next_state = count_out ;
        else
         Next_state = count_data ;
	 end 
	 count_out: Next_state = give_data ;
	 give_data:
	        Next_state = compare_data ; 
	 compare_data: 
	 begin
	   if (counter_compare == 5'd20)
	      Next_state = comb1 ;
	   else
	      Next_state = compare_data ; 
	 end
	 comb1:
	     Next_state = comb2 ;
	 comb2:
	     Next_state = comb3 ;
	 comb3:
	     Next_state = comb4 ;
	 comb4:
	     Next_state = split1 ;
	 split1:
	     Next_state = split2 ;
	 split2:
	     Next_state = split3 ;
	 split3:
	     Next_state = split4 ;
	 split4:
	     Next_state = split5 ;
	 split5:
	     Next_state = check ;
	 check:
	 begin
	   if (counter_HC == 3'd6)
        Next_state = finish ;
      else
        Next_state = check ;
    end
	 finish: Next_state = finish ;
	 default: Next_state = read_data ;
	 endcase
end

endmodule