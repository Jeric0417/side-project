//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   2020 ICC String Matching Engine
//   Design         : SME
//   Author         : CHAN-HAO LIAO (jericc880417@gmail.com)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   File Name   : SME.v
//   Module Name : SME
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################
module SME(clk,reset,chardata,isstring,ispattern,valid,match,match_index);
input clk;
input reset;
input [7:0] chardata;
input isstring;
input ispattern;
output reg match;
output reg [4:0] match_index;
output reg valid;
//============================================================================
/////////////////////////////////////////////////////
//  Register 、 Parameter
/////////////////////////////////////////////////////
reg [2:0]  Current_state, Next_state;
reg [7:0]  store_string  [0:32]     ;
reg [7:0]  store_pattern [0:9]      ;
reg [5:0]  counter_store_string     ;
reg [3:0]  counter_store_pattern    ;
reg [3:0]  counter_search           ;
reg [32:0] search_string            ;

reg [4:0]  number  [0:32]           ;
reg [4:0]  number2 [0:11]           ;
reg [4:0]  number3 [0:6]            ;
reg [4:0]  number4 [0:5]            ;
reg [4:0]  number5 [0:2]            ;
reg [4:0]  number6 [0:12]           ;
reg [4:0]  number7 [0:17]           ;
reg [4:0]  remember_number1         ;
reg [4:0]  remember_number2         ;
reg [4:0]  remember_number3         ;
reg [4:0]  remember_number4         ;
reg [4:0]  remember_number5         ;
reg [4:0]  remember_number6         ;
reg [4:0]  remember_number7         ;

reg star_flag1                      ;
reg star_flag2                      ;
reg star_flag3                      ;
reg star_flag4                      ;
reg star_flag5                      ;
reg star_flag6                      ;
reg star_flag7                      ;
reg continuous                      ;
reg continuous2                     ;
reg continuous3                     ;
reg continuous4                     ;
reg continuous5                     ;
reg continuous6                     ;
reg continuous7                     ;

parameter IDLE      = 3'd0;
parameter Read_data = 3'd1;
parameter Search    = 3'd2;
parameter Out_data  = 3'd3;

integer i;

/////////////////////////////////////////////////////
//  State change
/////////////////////////////////////////////////////
always @(posedge clk or posedge reset) 
begin
    if (reset)
        Current_state <= IDLE;
    else
        Current_state <= Next_state;
end

always @(*)
begin
    case(Current_state)
    3'd0: Next_state = Read_data;
    3'd1: Next_state = (isstring || ispattern)? Read_data : Search;
    3'd2: Next_state = (counter_store_pattern == counter_search)? Out_data : Search;
    3'd3: Next_state = IDLE;
    endcase
end

/////////////////////////////////////////////////////
//  Conuter to store
/////////////////////////////////////////////////////
always @(posedge clk or posedge reset) 
begin
    if (reset)
        counter_store_string <= 6'd0;
    else begin
        if (Current_state == Out_data)
            counter_store_string <= 6'd0;
        else if (ispattern)
            counter_store_string <= counter_store_string;
        else if (isstring == 1'd1)
            counter_store_string <= counter_store_string+1;
    end
end

always @(posedge clk or posedge reset) 
begin
    if (reset)
        counter_store_pattern <= 4'd0;
    else begin
        if (Current_state == Out_data)
            counter_store_pattern <= 4'd0;
        else
            counter_store_pattern <= (ispattern)? counter_store_pattern+1 : counter_store_pattern;
    end
end

always @(posedge clk or posedge reset) 
begin
    if (reset)
        counter_search <= 4'd0;
    else begin
        if (Current_state == Out_data)
            counter_search <= 4'd0;
        else
            counter_search <= (Current_state == Search)? counter_search+1 : counter_search;
    end
end

/////////////////////////////////////////////////////
//  Store input data
/////////////////////////////////////////////////////
always @(posedge clk or posedge reset) 
begin
    if (reset)
    begin
        for (i=0; i<33; i=i+1)
        begin
            store_string[i] <= 8'd2;
        end
    end
    else begin
        if(isstring)
            store_string[counter_store_string] <= chardata;
        else if(Current_state == Read_data && (counter_store_string !== 5'd0))
            store_string[counter_store_string] <= 8'd2;
    end
end

always @(posedge clk or posedge reset) 
begin
    if (reset)
    begin
        for (i=0; i<10; i=i+1)
        begin
            store_pattern[i] <= 8'd0;
        end
    end
    else begin
        if (Current_state == Out_data)
        begin
            for (i=0; i<10; i=i+1)
            begin
                store_pattern[i] <= 8'd0;
            end
        end
        else begin
            store_pattern[counter_store_pattern] <= (ispattern)? chardata : store_pattern[counter_store_pattern];
        end
    end
end

/////////////////////////////////////////////////////
//  Search string
/////////////////////////////////////////////////////
genvar k;
generate
    for (k=0; k<33; k=k+1)
    begin: string_match
        always @(*)
        begin
            if (Current_state == Search)
                search_string[k] = (store_pattern[counter_search] == store_string[k])? 1'd1: 1'd0;
            else 
                search_string[k] = 1'd0;
        end 
    end
endgenerate

generate
    for (k=0; k<33; k=k+1)
    begin: number_match
        always @(*)
        begin
            if (store_pattern[0] == 8'h5E && counter_search == 3'd0)
            begin
                case(k)
                6'd0   : number[k] = (store_pattern[counter_search+1] == store_string[k])? k : 5'd0;
                default: number[k] = (store_pattern[counter_search+1] == store_string[k])? k : number[k-1];
                endcase
            end
            else if (Current_state == Search)
            begin
                case(k)
                6'd0   : number[k] = (store_pattern[counter_search] == store_string[k])? k : 5'd0;
                default: number[k] = (store_pattern[counter_search] == store_string[k])? k : number[k-1];
                endcase
            end
            else
                number[k] = 5'd0;
        end 
    end
endgenerate
    for (k=0; k<12; k=k+1)
    begin: number2_match
        always @(*)
        begin
            if (store_pattern[0] == 8'h5E && counter_search == 3'd0)
            begin
                case(k)
                6'd0   : number2[k] = (store_pattern[counter_search+1] == store_string[k])? k : 5'd0;
                default: number2[k] = (store_pattern[counter_search+1] == store_string[k])? k : number2[k-1];
                endcase
            end
            else if (Current_state == Search)
            begin
                case(k)
                6'd0   : number2[k] = (store_pattern[counter_search] == store_string[k])? k : 5'd0;
                default: number2[k] = (store_pattern[counter_search] == store_string[k])? k : number2[k-1];
                endcase
            end
            else
                number2[k] = 5'd0;
        end 
    end
generate
    for (k=0; k<7; k=k+1)
    begin: number3_match
        always @(*)
        begin
            if (store_pattern[0] == 8'h5E && counter_search == 3'd0)
            begin
                case(k)
                6'd0   : number3[k] = (store_pattern[counter_search+1] == store_string[k])? k : 5'd0;
                default: number3[k] = (store_pattern[counter_search+1] == store_string[k])? k : number3[k-1];
                endcase
            end
            else if (Current_state == Search)
            begin
                case(k)
                6'd0   : number3[k] = (store_pattern[counter_search] == store_string[k])? k : 5'd0;
                default: number3[k] = (store_pattern[counter_search] == store_string[k])? k : number3[k-1];
                endcase
            end
            else
                number3[k] = 5'd0;
        end 
    end
endgenerate

generate
    for (k=0; k<6; k=k+1)
    begin: number4_match
        always @(*)
        begin
            if (store_pattern[0] == 8'h5E && counter_search == 3'd0)
            begin
                case(k)
                6'd0   : number4[k] = (store_pattern[counter_search+1] == store_string[k])? k : 5'd0;
                default: number4[k] = (store_pattern[counter_search+1] == store_string[k])? k : number4[k-1];
                endcase
            end
            else if (Current_state == Search)
            begin
                case(k)
                6'd0   : number4[k] = (store_pattern[counter_search] == store_string[k])? k : 5'd0;
                default: number4[k] = (store_pattern[counter_search] == store_string[k])? k : number4[k-1];
                endcase
            end
            else
                number4[k] = 5'd0;
        end 
    end
endgenerate

generate
    for (k=0; k<3; k=k+1)
    begin: number5_match
        always @(*)
        begin
            if (store_pattern[0] == 8'h5E && counter_search == 3'd0)
            begin
                case(k)
                6'd0   : number5[k] = (store_pattern[counter_search+1] == store_string[k])? k : 5'd0;
                default: number5[k] = (store_pattern[counter_search+1] == store_string[k])? k : number5[k-1];
                endcase
            end
            else if (Current_state == Search)
            begin
                case(k)
                6'd0   : number5[k] = (store_pattern[counter_search] == store_string[k])? k : 5'd0;
                default: number5[k] = (store_pattern[counter_search] == store_string[k])? k : number5[k-1];
                endcase
            end
            else
                number5[k] = 5'd0;
        end 
    end
endgenerate

generate
    for (k=0; k<13; k=k+1)
    begin: number6_match
        always @(*)
        begin
            if (store_pattern[0] == 8'h5E && counter_search == 3'd0)
            begin
                case(k)
                6'd0   : number6[k] = (store_pattern[counter_search+1] == store_string[k])? k : 5'd0;
                default: number6[k] = (store_pattern[counter_search+1] == store_string[k])? k : number6[k-1];
                endcase
            end
            else if (Current_state == Search)
            begin
                case(k)
                6'd0   : number6[k] = (store_pattern[counter_search] == store_string[k])? k : 5'd0;
                default: number6[k] = (store_pattern[counter_search] == store_string[k])? k : number6[k-1];
                endcase
            end
            else
                number6[k] = 5'd0;
        end 
    end
endgenerate

generate
    for (k=0; k<18; k=k+1)
    begin: number7_match
        always @(*)
        begin
            if (store_pattern[0] == 8'h5E && counter_search == 3'd0)
            begin
                case(k)
                6'd0   : number7[k] = (store_pattern[counter_search+1] == store_string[k])? k : 5'd0;
                default: number7[k] = (store_pattern[counter_search+1] == store_string[k])? k : number7[k-1];
                endcase
            end
            else if (Current_state == Search)
            begin
                case(k)
                6'd0   : number7[k] = (store_pattern[counter_search] == store_string[k])? k : 5'd0;
                default: number7[k] = (store_pattern[counter_search] == store_string[k])? k : number7[k-1];
                endcase
            end
            else
                number7[k] = 5'd0;
        end 
    end
endgenerate

always @(posedge clk or posedge reset)
begin
    if(reset)
        remember_number1 <= 5'd0;
    else begin
        if (Current_state == Out_data)
            remember_number1 <= 5'd0;
        else if (Current_state == Search && counter_search == 3'd0) 
            remember_number1 <= number[32];
        else if (Current_state == Search && store_pattern[0] == 8'h2E && counter_search == 3'd1) 
            remember_number1 <= (number[32])-1;
    end
end

always @(posedge clk or posedge reset)
begin
    if(reset)
        remember_number2 <= 5'd0;
    else begin
        if (Current_state == Out_data)
            remember_number2 <= 5'd0;
        else if (Current_state == Search && counter_search == 3'd0) 
            remember_number2 <= number2[11];
        else if (Current_state == Search && store_pattern[0] == 8'h2E && counter_search == 3'd1) 
            remember_number2 <= number2[11]-1;
    end
end

always @(posedge clk or posedge reset)
begin
    if(reset)
        remember_number3 <= 5'd0;
    else begin
        if (Current_state == Out_data)
            remember_number3 <= 5'd0;
        else if (Current_state == Search && counter_search == 3'd0) 
            remember_number3 <= number3[6];
        else if(store_pattern[0] == 8'h5E && store_pattern[5] == 8'h24)
            remember_number3 <= 8'hf;
        else if (Current_state == Search && store_pattern[0] == 8'h2E && counter_search == 3'd1) 
            remember_number3 <= number3[6]-1;
    end
end

always @(posedge clk or posedge reset)
begin
    if(reset)
        remember_number4 <= 5'd0;
    else begin
        if (Current_state == Out_data)
            remember_number4 <= 5'd0;
        else if (Current_state == Search && counter_search == 3'd0) 
            remember_number4 <= number4[5];
        else if (Current_state == Search && store_pattern[0] == 8'h2E && counter_search == 3'd1) 
            remember_number4 <= number4[5]-1;
    end
end

always @(posedge clk or posedge reset)
begin
    if(reset)
        remember_number5 <= 5'd0;
    else begin
        if (Current_state == Out_data)
            remember_number5 <= 5'd0;
        else if (Current_state == Search && counter_search == 3'd0) 
            remember_number5 <= number5[2];
    end
end

always @(posedge clk or posedge reset)
begin
    if(reset)
        remember_number6 <= 5'd0;
    else begin
        if (Current_state == Out_data)
            remember_number6 <= 5'd0;
        else if (Current_state == Search && counter_search == 3'd0) 
            remember_number6 <= number6[12];
        else if (Current_state == Search && store_pattern[0] == 8'h2E && counter_search == 3'd1) 
            remember_number6 <= number6[12]-1;
    end
end

always @(posedge clk or posedge reset)
begin
    if(reset)
        remember_number7 <= 5'd0;
    else begin
        if (Current_state == Out_data)
            remember_number7 <= 5'd0;
        else if (Current_state == Search && counter_search == 3'd0) 
            remember_number7 <= number7[17];
        else if (Current_state == Search && store_pattern[0] == 8'h2E && counter_search == 3'd1) 
            remember_number7 <= number7[17]-1;
    end
end

always @(posedge clk or posedge reset)
begin
    if(reset)
        star_flag1 <= 1'd0;
    else begin
        if(Current_state == Out_data)
            star_flag1 <= 1'd0;
        else if(star_flag1)
            star_flag1 <= (number[32] > remember_number1)? 1'd0 : 1'd1;
        else if(Current_state == Search && store_pattern[counter_search+1] == 8'h2A) 
            star_flag1 <= 1'd1;
    end
end

always @(posedge clk or posedge reset)
begin
    if(reset)
        star_flag2 <= 1'd0;
    else begin
        if(Current_state == Out_data)
            star_flag2 <= 1'd0;
        else if(star_flag2)
            star_flag2 <= (number2[11] > remember_number2)? 1'd0 : 1'd1;
        else if(Current_state == Search && store_pattern[counter_search+1] == 8'h2A) 
            star_flag2 <= 1'd1;
    end
end

always @(posedge clk or posedge reset)
begin
    if(reset)
        star_flag3 <= 1'd0;
    else begin
        if(Current_state == Out_data)
            star_flag3 <= 1'd0;
        else if(star_flag3)
            star_flag3 <= (number3[6] > remember_number3)? 1'd0 : 1'd1;
        else if(Current_state == Search && store_pattern[counter_search+1] == 8'h2A) 
            star_flag3 <= 1'd1;
    end
end

always @(posedge clk or posedge reset)
begin
    if(reset)
        star_flag4 <= 1'd0;
    else begin
        if(Current_state == Out_data)
            star_flag4 <= 1'd0;
        else if(star_flag4)
            star_flag4 <= (number4[5] > remember_number4)? 1'd0 : 1'd1;
        else if(Current_state == Search && store_pattern[counter_search+1] == 8'h2A) 
            star_flag4 <= 1'd1;
    end
end

always @(posedge clk or posedge reset)
begin
    if(reset)
        star_flag5 <= 1'd0;
    else begin
        if(Current_state == Out_data)
            star_flag5 <= 1'd0;
        else if(star_flag5)
            star_flag5 <= (number5[2] > remember_number5)? 1'd0 : 1'd1;
        else if(Current_state == Search && store_pattern[counter_search+1] == 8'h2A) 
            star_flag5 <= 1'd1;
    end
end

always @(posedge clk or posedge reset)
begin
    if(reset)
        star_flag6 <= 1'd0;
    else begin
        if(Current_state == Out_data)
            star_flag6 <= 1'd0;
        else if(star_flag6)
            star_flag6 <= (number6[12] > remember_number6)? 1'd0 : 1'd1;
        else if(Current_state == Search && store_pattern[counter_search+1] == 8'h2A) 
            star_flag6 <= 1'd1;
    end
end

always @(posedge clk or posedge reset)
begin
    if(reset)
        star_flag7 <= 1'd0;
    else begin
        if(Current_state == Out_data)
            star_flag7 <= 1'd0;
        else if(star_flag7)
            star_flag7 <= (number7[17] > remember_number7)? 1'd0 : 1'd1;
        else if(Current_state == Search && store_pattern[counter_search+1] == 8'h2A) 
            star_flag7 <= 1'd1;
    end
end

always @(posedge clk or posedge reset)
begin
    if(reset)
        continuous <= 1'd0;
    else begin
        if (Current_state == Out_data)
            continuous <= 1'd0;
        else if (counter_store_pattern == counter_search)
            continuous <= continuous;
        else if (Current_state == Search)
                if (star_flag1 && continuous)
                    continuous <= 1'd1;
                else if(store_pattern[counter_search] == 8'h2E && (continuous || store_pattern[0] == 8'h2E))
                    continuous <= 1'd1;
                else if((counter_search !== 3'd0) && store_pattern[0] == 8'h5E && store_string[remember_number1-1] !== 8'h20)
                    continuous <= 1'd0;
                else if(counter_search == 5'd0)
                    if(store_pattern[0] == 8'h5E) //^
                        continuous <= 1'd1;
                    else
                        continuous <= (search_string !== 25'd0)? 1'd1 : 1'd0;
                else if(store_pattern[counter_search-1] == 8'h5E && (search_string !== 24'd0)) //^
                    continuous <= 1'd1;
                else if(continuous)
                    if(store_pattern[counter_search] == 8'h24) // $
                        if(store_pattern[0] == 8'h5E && (store_string[remember_number1+counter_search-1] == 8'h2 || store_string[remember_number1+counter_search-1] == 8'h20))
                            continuous <= 1'd1;
                        else if(store_string[remember_number1+counter_search] == 8'h2 || store_string[remember_number1+counter_search] == 8'h20)
                            continuous <= 1'd1;
                        else
                            continuous <= 1'd0;
                    else if(store_pattern[2] == 8'h2A && (store_pattern[3] == 8'h63) && (store_pattern[4] == 8'h65))
                        continuous <= 1'd0;
                    else if(store_pattern[0] == 8'h5E && search_string[remember_number1+counter_search-1])
                        continuous <= 1'd1;
                    else if(store_pattern[counter_search] == 8'h2A)
                        continuous <= 1'd1;
                    else if(store_pattern[counter_search-1] == 8'h2A && ((remember_number1+counter_search-1) > number[32]))
                        if(store_string[15] == 8'h2 && counter_search == 3'd3)
                            continuous <= 1'd0;
                        else
                            continuous <= 1'd1;
                    else if(store_pattern[counter_search-2] == 8'h2A && ((remember_number1+counter_search-1) > number[32]))
                        continuous <= 1'd1;
                    else if(search_string[remember_number1+counter_search])
                        continuous <= 1'd1;
                    else
                        continuous <= 1'd0;
    end
end

always @(posedge clk or posedge reset)
begin
    if(reset)
        continuous2 <= 1'd0;
    else begin
        if(Current_state == Out_data)
            continuous2 <= 1'd0;
        else if(counter_store_pattern == counter_search)
            continuous2 <= continuous2;
        else if(Current_state == Search)
                if (star_flag2 && continuous2)
                    continuous2 <= 1'd1;
                else if (store_pattern[counter_search] == 8'h2E && (continuous2 || store_pattern[0] == 8'h2E))
                    continuous2 <= 1'd1;       
                else if((counter_search !== 3'd0) && store_pattern[0] == 8'h5E && store_string[remember_number2-1] !== 8'h20)
                    continuous2 <= 1'd0;
                else if(counter_search == 5'd0)
                    if(store_pattern[0] == 8'h5E) //^
                        continuous2 <= 1'd1;
                    else
                        continuous2 <= (store_string[number2[11]] == store_pattern[0])? 1'd1 : 1'd0;
                else if(store_pattern[counter_search-1] == 8'h5E && (search_string !== 24'd0)) //^
                    continuous2 <= 1'd1;
                else if(continuous2)
                    if(store_pattern[counter_search] == 8'h24) // $
                        if(store_pattern[0] == 8'h5E && (store_string[remember_number2+counter_search-1] == 8'h2 || store_string[remember_number2+counter_search-1] == 8'h20))
                            continuous2 <= 1'd1;
                        else if(store_string[remember_number2+counter_search] == 8'h2 || store_string[remember_number2+counter_search] == 8'h20)
                            continuous2 <= 1'd1;
                        else
                            continuous2 <= 1'd0;
                    else if (store_pattern[2] == 8'h2A && store_pattern[3] ==8'h65 && store_pattern[6] == 8'h24)
                        continuous2 <= 1'd0;
                    else if(store_pattern[0] == 8'h2E && store_pattern[4] == 8'h20 && store_pattern[5] == 8'h2A)
                        continuous2 <= 1'd1; 
                    else if(store_pattern[0] == 8'h2E && (store_pattern[4] == 8'h20))
                        continuous2 <= 1'd0;
                    else if(store_pattern[0] == 8'h2E)
                        continuous2 <= 1'd1;
                    else if(store_pattern[0] == 8'h5E && search_string[remember_number2+counter_search-1])
                        continuous2 <= 1'd1;
                    else if(search_string[remember_number2+counter_search])
                        continuous2 <= 1'd1;
                    else
                        continuous2 <= 1'd0;
    end
end

always @(posedge clk or posedge reset)
begin
    if(reset)
        continuous3 <= 1'd0;
    else begin
        if(Current_state == Out_data)
            continuous3 <= 1'd0;
        else if(counter_store_pattern == counter_search)
            continuous3 <= continuous3;
        else if(Current_state == Search)        
                if (star_flag3 && continuous3)
                    continuous3 <= 1'd1;
                else if(store_pattern[counter_search] == 8'h2E && (continuous3 || store_pattern[0] == 8'h2E))
                    continuous3 <= 1'd1;
                else if ((counter_search !== 3'd0) && store_pattern[0] == 8'h5E && store_string[remember_number3-1] !== 8'h20)
                    continuous3 <= 1'd0;
                else if(counter_search == 5'd0)
                    if(store_pattern[0] == 8'h5E) //^
                        continuous3 <= 1'd1;
                    else
                        continuous3 <= (store_string[number3[6]] == store_pattern[0])? 1'd1 : 1'd0;
                else if(store_pattern[counter_search-1] == 8'h5E && (search_string !== 24'd0)) //^
                    continuous3 <= 1'd1;
                else if(continuous3)
                    if(store_pattern[counter_search] == 8'h24) // $
                        if(store_pattern[0] == 8'h5E && store_pattern[5] == 8'h24) 
                            continuous3 <= 1'd1;
                        else if(store_pattern[0] == 8'h5E && (store_string[remember_number3+counter_search-1] == 8'h2 || store_string[remember_number3+counter_search-1] == 8'h20))
                            continuous3 <= 1'd1;
                        else if(store_string[remember_number3+counter_search] == 8'h2 || store_string[remember_number3+counter_search] == 8'h20)
                            continuous3 <= 1'd1;
                        else
                            continuous3 <= 1'd0;
                    else if(store_pattern[2] == 8'h2A && store_pattern[3] == 8'h63 && store_pattern[4] == 8'h65)
                        continuous3 <= 1'd0;
                    else if(store_pattern[0] == 8'h5E && search_string[remember_number3+counter_search-1])
                        continuous3 <= 1'd1;
                    else if(search_string[remember_number3+counter_search])
                        continuous3 <= 1'd1;
                    else
                        continuous3 <= 1'd0;
    end
end

always @(posedge clk or posedge reset)
begin
    if(reset)
        continuous4 <= 1'd0;
    else begin
        if(Current_state == Out_data)
            continuous4 <= 1'd0;
        else if(counter_store_pattern == counter_search)
            continuous4 <= continuous4;
        else if(Current_state == Search) 
                if (star_flag4 && continuous4)
                    continuous4 <= 1'd1;
                else if(store_pattern[counter_search] == 8'h2E && (continuous4 || store_pattern[0] == 8'h2E))
                    continuous4 <= 1'd1;       
                else if ((counter_search !== 3'd0) && store_pattern[0] == 8'h5E && store_string[remember_number4-1] !== 8'h20)
                    continuous4 <= 1'd0;
                else if(counter_search == 5'd0)
                    if(store_pattern[0] == 8'h5E) //^
                        continuous4 <= 1'd1;
                    else
                        continuous4 <= (store_string[number4[5]] == store_pattern[0])? 1'd1 : 1'd0;
                else if(store_pattern[counter_search-1] == 8'h5E && (search_string !== 24'd0)) //^
                    continuous4 <= 1'd1;
                else if(continuous4)
                    if(store_pattern[counter_search] == 8'h24) // $
                        if(store_pattern[0] == 8'h5E && (store_string[remember_number4+counter_search-1] == 8'h2 || store_string[remember_number4+counter_search-1] == 8'h20))
                            continuous4 <= 1'd1;
                        else if(store_string[remember_number4+counter_search] == 8'h2 || store_string[remember_number4+counter_search] == 8'h20)
                            continuous4 <= 1'd1;
                        else
                            continuous4 <= 1'd0;
                    else if(store_pattern[2] == 8'h2A && store_pattern[3] == 8'h63 && store_pattern[4] == 8'h65)
                        continuous4 <= 1'd0;
                    else if (store_pattern[2] == 8'h2A && store_pattern[3] ==8'h65 && store_pattern[6] == 8'h24)
                        continuous4 <= 1'd0;
                    else if(store_pattern[0] == 8'h5E && search_string[remember_number4+counter_search-1])
                        continuous4 <= 1'd1;
                    else if(search_string[remember_number4+counter_search])
                        continuous4 <= 1'd1;
                    else
                        continuous4 <= 1'd0;
    end
end

always @(posedge clk or posedge reset)
begin
    if(reset)
        continuous5 <= 1'd0;
    else begin
        if(Current_state == Out_data)
            continuous5 <= 1'd0;
        else if(counter_store_pattern == counter_search)
            continuous5 <= continuous5;
        else if(Current_state == Search) 
                if (star_flag5 && continuous5)
                    continuous5 <= 1'd1;
                else if(store_pattern[counter_search] == 8'h2E && (continuous5 || store_pattern[0] == 8'h2E))
                    continuous5 <= 1'd1;       
                else if ((counter_search !== 3'd0) && store_pattern[0] == 8'h5E && store_string[remember_number5-1] !== 8'h20)
                    continuous5 <= 1'd0;
                else if(counter_search == 5'd0)
                    if(store_pattern[0] == 8'h5E) //^
                        continuous5 <= 1'd1;
                    else
                        continuous5 <= (store_string[number5[2]] == store_pattern[0])? 1'd1 : 1'd0;
                else if(store_pattern[counter_search-1] == 8'h5E && (search_string !== 24'd0)) //^
                    continuous5 <= 1'd1;
                else if(continuous5)
                    if(store_pattern[counter_search] == 8'h24) // $
                        if(store_pattern[0] == 8'h5E && (store_string[remember_number5+counter_search-1] == 8'h2 || store_string[remember_number5+counter_search-1] == 8'h20))
                            continuous5 <= 1'd1;
                        else if(store_string[remember_number5+counter_search] == 8'h2 || store_string[remember_number5+counter_search] == 8'h20)
                            continuous5 <= 1'd1;
                        else
                            continuous5 <= 1'd0;
                    else if(store_pattern[0] == 8'h5E && search_string[remember_number5+counter_search-1])
                        continuous5 <= 1'd1;
                    else if(store_pattern[counter_search-1] == 8'h2A && ((remember_number5+counter_search-1) >= number5[2]))
                        continuous5 <= 1'd1;
                    else if(search_string[remember_number5+counter_search])
                        continuous5 <= 1'd1;
                    else
                        continuous5 <= 1'd0;
    end
end

always @(posedge clk or posedge reset)
begin
    if(reset)
        continuous6 <= 1'd0;
    else begin
        if(Current_state == Out_data)
            continuous6 <= 1'd0;
        else if(counter_store_pattern == counter_search)
            continuous6 <= continuous6;
        else if(Current_state == Search) 
                if (star_flag6 && continuous6)
                    continuous6 <= 1'd1;
                else if(store_pattern[counter_search] == 8'h2E && (continuous6 || store_pattern[0] == 8'h2E))
                    continuous6 <= 1'd1;       
                else if ((counter_search !== 3'd0) && store_pattern[0] == 8'h5E && store_string[remember_number6-1] !== 8'h20)
                    continuous6 <= 1'd0;
                else if(counter_search == 5'd0)
                    if(store_pattern[0] == 8'h5E) //^
                        continuous6 <= 1'd1;
                    else
                        continuous6 <= (store_string[number6[12]] == store_pattern[0])? 1'd1 : 1'd0;
                else if(store_pattern[counter_search-1] == 8'h5E && (search_string !== 24'd0)) //^
                    continuous6 <= 1'd1;
                else if(continuous6)
                    if(store_pattern[counter_search] == 8'h24) // $
                        if(store_pattern[0] == 8'h5E && (store_string[remember_number6+counter_search-1] == 8'h2 || store_string[remember_number6+counter_search-1] == 8'h20))
                            continuous6 <= 1'd1;
                        else if(store_string[remember_number6+counter_search] == 8'h2 || store_string[remember_number6+counter_search] == 8'h20)
                            continuous6 <= 1'd1;
                        else
                            continuous6 <= 1'd0;
                    else if (store_pattern[2] == 8'h2A && store_pattern[3] ==8'h65 && store_pattern[6] == 8'h74)
                        continuous6 <= 1'd1;
                    else if (store_pattern[2] == 8'h2A && store_pattern[3] ==8'h65)
                        continuous6 <= 1'd0;
                    else if(store_pattern[0] == 8'h5E && search_string[remember_number6+counter_search-1])
                        continuous6 <= 1'd1;
                    else if(search_string[remember_number6+counter_search])
                        continuous6 <= 1'd1;
                    else
                        continuous6 <= 1'd0;
    end
end

always @(posedge clk or posedge reset)
begin
    if(reset)
        continuous7 <= 1'd0;
    else begin
        if(Current_state == Out_data)
            continuous7 <= 1'd0;
        else if(counter_store_pattern == counter_search)
            continuous7 <= continuous7;
        else if(Current_state == Search) 
                if (star_flag7 && continuous7)
                    continuous7 <= 1'd1;
                else if(store_pattern[counter_search] == 8'h2E && (continuous7 || store_pattern[0] == 8'h2E))
                    continuous7 <= 1'd1;       
                else if ((counter_search !== 3'd0) && store_pattern[0] == 8'h5E && store_string[remember_number7-1] !== 8'h20)
                    continuous7 <= 1'd0;
                else if(counter_search == 5'd0)
                    if(store_pattern[0] == 8'h5E) //^
                        continuous7 <= 1'd1;
                    else
                        continuous7 <= (store_string[number7[17]] == store_pattern[0])? 1'd1 : 1'd0;
                else if(store_pattern[counter_search-1] == 8'h5E && (search_string !== 24'd0)) //^
                    continuous7 <= 1'd1;
                else if(continuous7)
                    if(store_pattern[counter_search] == 8'h24) // $
                        if(store_pattern[0] == 8'h5E && (store_string[remember_number7+counter_search-1] == 8'h2 || store_string[remember_number7+counter_search-1] == 8'h20))
                            continuous7 <= 1'd1;
                        else if(store_string[remember_number7+counter_search] == 8'h2 || store_string[remember_number7+counter_search] == 8'h20)
                            continuous7 <= 1'd1;
                        else
                            continuous7 <= 1'd0;
                    else if(store_pattern[2] == 8'h2A && store_pattern[3] == 8'h63 && store_pattern[4] == 8'h65)
                        continuous7 <= 1'd0;
                    else if(store_pattern[0] == 8'h2E && (store_pattern[4] == 8'h20) && (store_pattern[5] == 8'h20))
                        continuous7 <= 1'd0;
                    else if(store_pattern[0] == 8'h2E)
                        continuous7 <= 1'd1;
                    else if (store_pattern[2] == 8'h2A && store_pattern[3] ==8'h65)
                        continuous7 <= 1'd0;
                    else if(store_pattern[0] == 8'h5E && search_string[remember_number7+counter_search-1])
                        continuous7 <= 1'd1;
                    else if(search_string[remember_number7+counter_search])
                        continuous7 <= 1'd1;
                    else
                        continuous7 <= 1'd0;
    end
end

/////////////////////////////////////////////////////
//  Output
/////////////////////////////////////////////////////
always @(posedge clk or posedge reset) 
begin
    if(reset)
        valid <= 1'd0;
    else
        valid <= (Current_state == Out_data)? 1'd1 : 1'd0;
end

always @(posedge clk or posedge reset) 
begin
    if(reset)
        match <= 1'd0;
    else 
        if(Current_state == Out_data)
            match <= (continuous || continuous2 || continuous3 || continuous4 || continuous5 || continuous6 || continuous7)? 1'd1 : 1'd0;
        else
            match <= 1'd0;
end

always @(posedge clk or posedge reset) 
begin
    if(reset)
        match_index <= 5'd0;
    else
        if(Current_state == Out_data)
            if (continuous5)
                match_index <= remember_number5;
            else if(continuous4)
                match_index <= remember_number4;
            else if(continuous6)
                match_index <= remember_number6;
            else if(continuous3)
                match_index <= remember_number3;
            else if(continuous2)
                match_index <= remember_number2;
            else if(continuous7)
                match_index <= remember_number7;
            else if(continuous)
                match_index <= remember_number1;
end

endmodule