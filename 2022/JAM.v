module JAM (CLK, RST, W, J, Cost, MatchCount, MinCost, Valid);
input CLK;
input RST;
input [6:0] Cost;
output reg [2:0] W; //row
output reg [2:0] J; //column
output reg [3:0] MatchCount;
output reg [9:0] MinCost;
output reg Valid;
//====================================================================
reg [9:0] number ;
reg [2:0] state, Next_state ;
reg [2:0] compare_0= 3'd0, compare_1= 3'd1, compare_2= 3'd2, compare_3= 3'd3, compare_4= 3'd4, compare_5= 3'd5, compare_6= 3'd6, compare_7= 3'd7 ;
reg [3:0] counter ;
parameter first_compare= 3'd0, compare= 3'd1, min_count= 3'd2 ;

always @(negedge CLK or posedge RST) // counter 計數0~9
begin
	if (RST) 
	begin
	    counter <= 4'd0 ;
	end
	else begin
	if (counter == 4'd9)
	    counter <= 4'd0 ;
	else
	    counter <= counter + 1'd1 ;
	end
end

always @(negedge CLK or posedge RST) // 輸出 W
begin
	if (RST) 
	begin
	    W <= 3'd0 ;
	end
	else begin
	    if (counter > 4'd7)
	    W <= W ;
	    else
	    W <= W + 1'd1 ;
	end
end

always @(negedge CLK or posedge RST) // 輸出 J
begin
	if (RST) 
	begin
	    J <= 3'd0 ;
	end
	else begin
	    if (Next_state == first_compare || Next_state == compare || Next_state == min_count)
	    case (counter)
	    3'd0: J <= compare_1 ;
	    3'd1: J <= compare_2 ;
	    3'd2: J <= compare_3 ;
	    3'd3: J <= compare_4 ;
	    3'd4: J <= compare_5 ;
	    3'd5: J <= compare_6 ;
	    3'd6: J <= compare_7 ;
	    3'd7: J <= compare_0 ;
	    endcase
	end
end

always @(negedge CLK or posedge RST) // 輸出 MinCost
begin
    if (RST) begin
        MinCost <= 10'd0;
    end 
    else begin 
        if (Next_state == first_compare)
        begin
            MinCost <= MinCost + Cost ;
        end
        else if (Next_state == min_count) 
        begin
            MinCost <= (MinCost < number) ? MinCost : number;
        end
        else begin
        	MinCost <= MinCost ;
        end
    end
end

always @(negedge CLK or posedge RST) // 輸出 MatchCount
begin
    if (RST) begin
        MatchCount <= 4'd1;
    end 
    else begin 
        if (state == compare && Next_state == min_count)
        begin
            if ( number < MinCost)
            MatchCount <= 4'd1 ;
            else
            MatchCount <= (number == MinCost)? MatchCount + 1'd1 : MatchCount ; 
        end
    end
end


always @(negedge CLK or posedge RST) // 計算min count
begin
    if (RST) begin
        number <= 10'd0;
    end
    else begin 
        if (counter > 4'd7) 
        begin
            number <= 10'd0 ;
        end
        else begin
            number <= number + Cost;
        end
    end
end

always @(negedge CLK or posedge RST) // 輸出 Valid
begin
    if (RST)
    begin
    	Valid <= 1'd0 ;
    end
    else begin
    	if (compare_0 == 3'd7 && compare_1 == 3'd6 && compare_2 == 3'd5 && compare_3 == 3'd4 && compare_4 == 3'd3 && compare_5 == 3'd2 && compare_6 == 3'd1 && compare_7 == 3'd0 )
    	    Valid <= 1'd1 ;
    	else begin
    		Valid <= 1'd0 ;
    	end
    end
end

always @(negedge CLK or posedge RST) // compare
begin
	if (RST)
	begin
	    compare_0 <= 3'd0 ;
	end
	else begin
	if (counter == 4'd9)
	begin   

	if (compare_6 < compare_7)  //右邊2交換
	begin
	   compare_7 <= compare_6 ;
	   compare_6 <= compare_7 ;
	end
    else if (compare_5 < compare_6)   //右邊3個交換
	begin
	if (compare_5 < compare_7 && compare_7 < compare_6) 
	begin
	   compare_5 <= compare_7 ;
	   compare_6 <= compare_5 ;
	   compare_7 <= compare_6 ;
	end
	else if (compare_7 < compare_5)
	begin
	   compare_5 <= compare_6 ;
	   compare_6 <= compare_7 ;
	   compare_7 <= compare_5 ;
    end
    end
    else if (compare_4 < compare_5)   //右邊4個交換
	begin
	    if (compare_4 < compare_7 && compare_7 < compare_6 && compare_7 < compare_5)
	    begin
	        compare_4 <= compare_7 ;
	        compare_5 <= compare_4 ;
	        compare_6 <= compare_6 ;
	        compare_7 <= compare_5 ;
	    end
	    else if (compare_4 < compare_6 && compare_7 < compare_4 && compare_7 < compare_6)
	    begin   
	        compare_4 <= compare_6 ;
	        compare_5 <= compare_7 ;
	        compare_6 <= compare_4 ;
	        compare_7 <= compare_5 ;
    	end
    	else if (compare_6 < compare_4 && compare_7 < compare_4)
    	begin
            compare_4 <= compare_5 ;
            compare_5 <= compare_7 ;
            compare_6 <= compare_6 ;
            compare_7 <= compare_4 ;
        end
    end
    else if (compare_4 > compare_3)      //右邊5個交換
    begin
    	if (compare_3 < compare_7 && compare_3 < compare_6 && compare_3 < compare_5 && compare_7 < compare_6 && compare_7 < compare_5 && compare_7 < compare_4)
    	begin
    	   compare_3 <= compare_7 ;
    	   compare_4 <= compare_3 ;
    	   compare_5 <= compare_6 ;
    	   compare_6 <= compare_5 ;
    	   compare_7 <= compare_4 ;
    	end
        else if (compare_3 < compare_6 && compare_3 < compare_5 && compare_3 < compare_4 && compare_6 < compare_5 && compare_6 < compare_4)
        begin
    	   compare_3 <= compare_6 ;
    	   compare_4 <= compare_7 ;
    	   compare_5 <= compare_3 ;
    	   compare_6 <= compare_5 ;
    	   compare_7 <= compare_4 ;
    	end
    	else if (compare_3 < compare_5 && compare_5 < compare_4)
        begin
    	   compare_3 <= compare_5 ;
    	   compare_4 <= compare_7 ;
    	   compare_5 <= compare_6 ;
    	   compare_6 <= compare_3 ;
    	   compare_7 <= compare_4 ;
    	end
    	else if (compare_7 < compare_3 && compare_6 < compare_3 && compare_5 < compare_3)
        begin
    	   compare_3 <= compare_4 ;
    	   compare_4 <= compare_7 ;
    	   compare_5 <= compare_6 ;
    	   compare_6 <= compare_5 ;
    	   compare_7 <= compare_3 ;
    	end
    end
    else if (compare_3 > compare_2)    //右邊6個交換
    begin
    	if (compare_2 < compare_7 && compare_2 < compare_6 && compare_2 < compare_5 && compare_2 < compare_4 && compare_7 < compare_6 && compare_7 < compare_5 && compare_7 < compare_4 && compare_7 < compare_3)
    	begin
    	   compare_2 <= compare_7 ;
    	   compare_3 <= compare_2 ;
    	   compare_4 <= compare_6 ;
    	   compare_5 <= compare_5 ;
    	   compare_6 <= compare_4 ;
    	   compare_7 <= compare_3 ;
    	end
    	else if (compare_2 < compare_6 && compare_2 < compare_5 && compare_2 < compare_4 &&  compare_6 < compare_5 && compare_6 < compare_4 && compare_6 < compare_3)
        begin
    	   compare_2 <= compare_6 ;
    	   compare_3 <= compare_7 ;
    	   compare_4 <= compare_2 ;
    	   compare_5 <= compare_5 ;
    	   compare_6 <= compare_4 ;
    	   compare_7 <= compare_3 ;
    	end
    	else if (compare_2 < compare_5 && compare_2 < compare_4 && compare_5 < compare_4 && compare_5 < compare_3)
        begin
    	   compare_2 <= compare_5 ;
    	   compare_3 <= compare_7 ;
    	   compare_4 <= compare_6 ;
    	   compare_5 <= compare_2 ;
    	   compare_6 <= compare_4 ;
    	   compare_7 <= compare_3 ;
    	end
    	else if (compare_2 < compare_4 && compare_2 < compare_3 && compare_4 < compare_3)
        begin
    	   compare_2 <= compare_4 ;
    	   compare_3 <= compare_7 ;
    	   compare_4 <= compare_6 ;
    	   compare_5 <= compare_5 ;
    	   compare_6 <= compare_2 ;
    	   compare_7 <= compare_3 ;
    	end
    	else if (compare_7 < compare_2 && compare_6 < compare_2 && compare_5 < compare_2 && compare_4 < compare_2)
        begin
    	   compare_2 <= compare_3 ;
    	   compare_3 <= compare_7 ;
    	   compare_4 <= compare_6 ;
    	   compare_5 <= compare_5 ;
    	   compare_6 <= compare_4 ;
    	   compare_7 <= compare_2 ;
    	end
    end
    else if (compare_2 > compare_1)       //右邊7個交換
    begin
    	if (compare_1 < compare_7 && compare_1 < compare_6 && compare_1 < compare_5 && compare_1 < compare_4 && compare_1 < compare_3 && compare_7 < compare_6 && compare_7 < compare_5 && compare_7 < compare_4 && compare_7 < compare_3 && compare_7 < compare_2)
    	begin
    	   compare_1 <= compare_7 ;
    	   compare_2 <= compare_1 ;
    	   compare_3 <= compare_6 ;
    	   compare_4 <= compare_5 ;
    	   compare_5 <= compare_4 ;
    	   compare_6 <= compare_3 ;
    	   compare_7 <= compare_2 ;
    	end
    	else if (compare_1 < compare_6 && compare_1 < compare_5 && compare_1 < compare_4 && compare_1 < compare_3 && compare_6 < compare_5 && compare_6 < compare_4 && compare_6 < compare_3 && compare_6 < compare_2)
        begin
           compare_1 <= compare_6 ;
    	   compare_2 <= compare_7 ;
    	   compare_3 <= compare_1 ;
    	   compare_4 <= compare_5 ;
    	   compare_5 <= compare_4 ;
    	   compare_6 <= compare_3 ;
    	   compare_7 <= compare_2 ;
    	end
    	else if (compare_1 < compare_5 && compare_1 < compare_4 && compare_1 < compare_3 && compare_5 < compare_4 && compare_5 < compare_3 && compare_5 < compare_2)
        begin
           compare_1 <= compare_5 ;
    	   compare_2 <= compare_7 ;
    	   compare_3 <= compare_6 ;
    	   compare_4 <= compare_1 ;
    	   compare_5 <= compare_4 ;
    	   compare_6 <= compare_3 ;
    	   compare_7 <= compare_2 ;
    	end
    	else if (compare_1 < compare_4 && compare_1 < compare_3 && compare_4 < compare_3 && compare_4 < compare_2)
        begin
           compare_1 <= compare_4 ;
    	   compare_2 <= compare_7 ;
    	   compare_3 <= compare_6 ;
    	   compare_4 <= compare_5 ;
    	   compare_5 <= compare_1 ;
    	   compare_6 <= compare_3 ;
    	   compare_7 <= compare_2 ;
    	end
    	else if (compare_1 < compare_3 && compare_3 < compare_2 )
        begin
           compare_1 <= compare_3 ;
    	   compare_2 <= compare_7 ;
    	   compare_3 <= compare_6 ;
    	   compare_4 <= compare_5 ;
    	   compare_5 <= compare_4 ;
    	   compare_6 <= compare_1 ;
    	   compare_7 <= compare_2 ;
    	end
    	else if (compare_3 < compare_2 )
        begin
           compare_1 <= compare_2 ;
    	   compare_2 <= compare_7 ;
    	   compare_3 <= compare_6 ;
    	   compare_4 <= compare_5 ;
    	   compare_5 <= compare_4 ;
    	   compare_6 <= compare_3 ;
    	   compare_7 <= compare_1 ;
    	end
    end

    else if (compare_1 > compare_0)       //右邊8個交換
    begin
    	if (compare_0 < compare_7 && compare_0 < compare_6 && compare_0 < compare_5 && compare_0 < compare_4 && compare_0 < compare_3 && compare_0 < compare_2 && compare_7 < compare_6 && compare_7 < compare_5 && compare_7 < compare_4 && compare_7 < compare_3 && compare_7 < compare_2 && compare_7 < compare_1)
    	begin
    	   compare_0 <= compare_7 ;
    	   compare_1 <= compare_0 ;
    	   compare_2 <= compare_6 ;
    	   compare_3 <= compare_5 ;
    	   compare_4 <= compare_4 ;
    	   compare_5 <= compare_3 ;
    	   compare_6 <= compare_2 ;
    	   compare_7 <= compare_1 ;
    	end
    	else if (compare_0 < compare_6 && compare_0 < compare_5 && compare_0 < compare_4 && compare_0 < compare_3 && compare_0 < compare_2 && compare_6 < compare_5 && compare_6 < compare_4 && compare_6 < compare_3 && compare_6 < compare_2 && compare_6 < compare_1)
        begin
           compare_0 <= compare_6 ;
           compare_1 <= compare_7 ;
    	   compare_2 <= compare_0 ;
    	   compare_3 <= compare_5 ;
    	   compare_4 <= compare_4 ;
    	   compare_5 <= compare_3 ;
    	   compare_6 <= compare_2 ;
    	   compare_7 <= compare_1 ;
    	end
    	else if (compare_0 < compare_5 && compare_0 < compare_4 && compare_0 < compare_3 && compare_0 < compare_2 && compare_5 < compare_4 && compare_5 < compare_3 && compare_5 < compare_2 && compare_5 < compare_1)
        begin
           compare_0 <= compare_5 ;
           compare_1 <= compare_7 ;
    	   compare_2 <= compare_6 ;
    	   compare_3 <= compare_0 ;
    	   compare_4 <= compare_4 ;
    	   compare_5 <= compare_3 ;
    	   compare_6 <= compare_2 ;
    	   compare_7 <= compare_1 ;
    	end
    	else if (compare_0 < compare_4 && compare_0 < compare_3 && compare_0 < compare_2 && compare_4 < compare_3 && compare_4 < compare_2 && compare_4 < compare_1)
        begin
           compare_0 <= compare_4 ;
           compare_1 <= compare_7 ;
    	   compare_2 <= compare_6 ;
    	   compare_3 <= compare_5 ;
    	   compare_4 <= compare_0 ;
    	   compare_5 <= compare_3 ;
    	   compare_6 <= compare_2 ;
    	   compare_7 <= compare_1 ;
    	end
    	else if (compare_0 < compare_3 && compare_0 < compare_2 && compare_3 < compare_2 && compare_3 < compare_1)
        begin
           compare_0 <= compare_3 ;
           compare_1 <= compare_7 ;
    	   compare_2 <= compare_6 ;
    	   compare_3 <= compare_5 ;
    	   compare_4 <= compare_4 ;
    	   compare_5 <= compare_0 ;
    	   compare_6 <= compare_2 ;
    	   compare_7 <= compare_1 ;
    	end
    	else if (compare_0 < compare_2 && compare_2 < compare_1)
        begin
           compare_0 <= compare_2 ;
           compare_1 <= compare_7 ;
    	   compare_2 <= compare_6 ;
    	   compare_3 <= compare_5 ;
    	   compare_4 <= compare_4 ;
    	   compare_5 <= compare_3 ;
    	   compare_6 <= compare_0 ;
    	   compare_7 <= compare_1 ;
    	end
    	else if (compare_0 < compare_1 && compare_7 < compare_0 && compare_6 < compare_0 && compare_5 < compare_0 && compare_4 < compare_0 &&  compare_7 < compare_3 && compare_7 < compare_2 )
        begin
           compare_0 <= compare_1 ;
           compare_1 <= compare_7 ;
    	   compare_2 <= compare_6 ;
    	   compare_3 <= compare_5 ;
    	   compare_4 <= compare_4 ;
    	   compare_5 <= compare_3 ;
    	   compare_6 <= compare_2 ;
    	   compare_7 <= compare_0 ;
    	end
    end
    end
    end
end
always @(negedge CLK or posedge RST)
begin
	if (RST)
	begin
		state <= first_compare ;
	end
	else begin
	    state <= Next_state ;
	end
end

always @(*)     //狀態轉換
begin
	case(state)

	first_compare:
	begin
	    if (counter == 4'd8 )
	    Next_state = min_count ;
	    else
	    Next_state = first_compare ;
	end

	compare:
	begin
	    if (counter == 4'd8 )
	    Next_state = min_count ;
	    else
	    Next_state = compare ;
	end
	min_count:
	begin
	    if (counter == 4'd9 )
	    Next_state = compare ;
	    else
	    Next_state = min_count ;
	end

	endcase
end

endmodule