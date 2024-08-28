module DT(clk, reset, done, sti_rd, sti_addr, sti_di, res_wr, res_rd, res_addr, res_do, res_di);
input            clk;
input            reset;
input[15:0]      sti_di;
input[7:0]       res_di;
output reg       sti_rd;
output reg[9:0]  sti_addr;
output reg       res_wr;
output reg       res_rd;
output reg[13:0] res_addr;
output reg[7:0]  res_do;
output reg       done;
//====================================================================
reg [3:0] data, data_compare ;
reg [4:0] counter ;
reg [2:0] counter_05 ; //計算forward
reg [3:0] counter_15 ; // 計數15~0
reg [3:0] state, Next_state ;
parameter get_di= 4'd0, compare_di= 4'd1, forward= 4'd2 , forward_wr= 4'd3, forward_rd= 4'd4, forward_finish= 4'd5 ,backward= 4'd6, backward_wr= 4'd7, backward_rd= 4'd8, backward_finish= 4'd9 ;

always @(posedge clk or negedge reset) // 15~0clk計數
begin
    if (!reset)
    begin
        counter_15 <= 4'd14 ;
    end 
    else begin
    if (counter == 4'd15)
        counter_15 <= counter_15 ;
    else if (counter_15 == 4'd0 )
    begin
       counter_15 <= 4'd15 ;
    end
    else begin
       counter_15 <= counter_15 - 1'd1 ;
    end
    end
end

always @(posedge clk or negedge reset) // counter_05 6次計數
begin
    if (!reset)
    begin
        counter_05 <= 3'd0 ;
    end 
    else begin
        if (Next_state == forward || Next_state == backward)
            counter_05 <= counter_05 + 1'd1 ;
        else if (Next_state == forward_wr || Next_state == backward_wr)
            counter_05 <= 4'd0 ;
    end
end

always @(posedge clk or negedge reset) // 往後一個接收sti_di
begin
    if (!reset)
    begin
        counter <= 5'd0 ;
    end
    else begin
    if (counter > 5'd15)
        counter <= counter ;
    else
        counter <= counter + 1'd1 ;
    end

end
always @(posedge clk or negedge reset) //sti_addr輸出
begin
    if (!reset)
    begin
        sti_addr <= 10'd0 ;
    end
    else begin
    if (!sti_rd)
        sti_addr <= 10'd0 ;
    else if (counter == 4'd15)
        sti_addr <= sti_addr ;
    else if (counter_15 == 4'd0)
        begin
        sti_addr <= sti_addr + 1'd1 ;
        end
        else begin
        sti_addr <= sti_addr ;
        end
    end
end

always @(posedge clk or negedge reset) // sti_rd輸出
begin
    if (!reset)
    begin
        sti_rd <= 1'd0 ;
    end
    else begin
        sti_rd <= 1'd1 ;
    end
end

always @ (posedge clk or negedge reset) // res_addr輸出 
begin
    if (!reset)
    begin
        res_addr <= 14'd0 ;
    end
    else if (counter == 4'd15)
        res_addr <= res_addr ;
    else if (Next_state == get_di || Next_state == compare_di || Next_state == forward_rd)
        res_addr <= res_addr + 1'd1 ;      //判斷是否為1
    else if (Next_state == backward_rd)
        res_addr <= res_addr - 1'd1 ;      //判斷是否為1
    else if (Next_state == forward || state == forward)
    begin
        case (counter_05)            // 往下addr計算
        3'd0: res_addr <= res_addr - 1'd1 ; 
        3'd1: res_addr <= res_addr - 14'd126 ; 
        3'd2: res_addr <= res_addr - 14'd1 ; 
        3'd3: res_addr <= res_addr - 14'd1 ;
        3'd4: res_addr <= res_addr + 14'd129 ;
        endcase  
    end 
    else if (Next_state == backward || state == backward)
    begin
        case (counter_05)            // 往上addr計算
        3'd0: res_addr <= res_addr + 1'd1 ; 
        3'd1: res_addr <= res_addr + 14'd126 ; 
        3'd2: res_addr <= res_addr + 14'd1 ; 
        3'd3: res_addr <= res_addr + 14'd1 ;
        3'd4: res_addr <= res_addr - 14'd129 ; 
        endcase  
    end
end

always @(posedge clk or negedge reset) // res_do輸出
begin
    if (!reset)
    begin
        res_do <= 8'd0 ;
    end 
    else begin
        if (!sti_rd)
        res_do <= 1'd0 ;
        else if (Next_state == get_di )
        res_do <= sti_di[counter_15] ;
        else if (Next_state == forward_wr)
        res_do <= data_compare + 1'd1 ;
        else if (Next_state == backward_wr)
        res_do <= data ;
    end
end

always @(posedge clk or negedge reset) // res_wr 寫入
begin
    if (!reset)
    begin
        res_wr <= 1'd0 ;
    end 
    else begin
        res_wr <= (Next_state == get_di || Next_state == forward_wr || Next_state == backward_wr)? 1'd1 : 1'd0 ;
    end
end

always @(posedge clk or negedge reset) // res_rd 讀出
begin
    if (!reset)
    begin
        res_rd <= 1'd0 ;
    end 
    else begin
        res_rd <= (Next_state == compare_di || Next_state == forward  || Next_state == forward_rd || Next_state == backward_rd || Next_state == backward) ? 1'd1 : 1'd0;
    end
end

always @(posedge clk or negedge reset) // done 輸出
begin
    if (!reset)
    begin
        done <= 1'd0 ;
    end 
    else begin
        done <= (Next_state == backward_finish)? 1'd1 : 1'd0 ;
    end
end

always @ (posedge clk or negedge reset) // forward 比較
begin
    if (!reset)
    begin
        data <= 1'd0;
        data_compare <= 1'd0 ;
    end
    else begin
        if (Next_state == forward)
        data_compare <= (counter_05 == 3'd1)? res_di : ((data_compare > res_di)? res_di : data_compare) ;
    else if (state == backward_rd)
        data <= res_di ;
    else if (Next_state == backward)   
        data <= (data > res_di + 1'd1)? res_di + 1'd1 : data ;

    end
end

always @(posedge clk or negedge reset) //state
begin
    if (!reset)
    begin
        state <= get_di ;
    end
    else begin
        state <= Next_state ;
    end
end

always @(*) // state切換
begin
    case(state)

    get_di:
    begin
        if (res_addr == 14'd16383)
        Next_state = compare_di ;
        else
        Next_state = get_di ;
    end
    compare_di: 
    begin
        if (res_addr == 14'd16254)
        Next_state = forward_finish ;
        else if (res_di)
        Next_state = forward;
        else
        Next_state = compare_di ;
    end
    forward:
    begin
          if (res_addr == 14'd16254)
          Next_state = forward_finish ;
          else if (counter_05 == 3'd5)                  
          Next_state = forward_wr ;
          else
          Next_state = forward ;
    end
    forward_wr:
    begin
        if(res_addr == 14'd16254) Next_state = forward_finish ;
        else
        Next_state = forward_rd ;
    end
    forward_rd:
    begin
        if (res_di)  
        Next_state = forward;
        else if(res_addr == 14'd16254) Next_state = forward_finish ;
        else Next_state = forward_rd;
    end
    forward_finish:
        Next_state = backward_rd ;
    backward:
    begin
        if (res_addr == 14'd129)
        Next_state = backward_finish ;
        else if (counter_05 == 3'd5)
        Next_state = backward_wr ;
        else
        Next_state = backward ;
    end
    backward_wr:
        Next_state = backward_rd ;
    backward_rd:
        if (res_di)  
        Next_state = backward;
        else if(res_addr == 14'd129) Next_state = backward_finish ;
        else Next_state = backward_rd ;
    backward_finish:
        Next_state = backward_finish ;
    default: Next_state = get_di ;

    endcase
end

endmodule