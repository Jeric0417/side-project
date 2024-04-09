//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   2022 ICLAB Spring Course                                                 
//   Lab02          : TT 
//   Author         : CHAN-HAO LIAO (jericc880417@gmail.com)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   File Name   : TT.v
//   Module Name : TT
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module TT(
    //Input Port
    clk,
    rst_n,
    in_valid,
    source,
    destination,

    //Output Port
    out_valid,
    cost
    );

//================================================================
//   INPUT AND OUTPUT DECLARATION                         
//================================================================

input               clk, rst_n, in_valid;
input       [3:0]   source;
input       [3:0]   destination;

output reg          out_valid;
output reg  [3:0]   cost;

reg [3:0] Current_state, Next_state ;
reg [3:0] current_station, source_station, destination_station;
reg [9:0] path_cost ;
reg [6:0] match ;
reg [6:0] non_solution ;
reg non_source, non_destination ;

parameter [3:0] IDLE = 4'd0 ;
parameter [3:0] Station_store = 4'd1 ;
parameter [3:0] Station_change = 4'd2 ;
parameter [3:0] Change_1 = 4'd3 ;
parameter [3:0] Change_2 = 4'd4 ;
parameter [3:0] Change_3 = 4'd5 ;
parameter [3:0] Change_4 = 4'd6 ;
parameter [3:0] Change_5 = 4'd7 ;
parameter [3:0] Change_6 = 4'd8 ;
parameter [3:0] Change_7 = 4'd9 ;
parameter [3:0] Change_reset = 4'd10 ;
parameter [3:0] Cost_out = 4'd11 ;
parameter [3:0] reset_path = 4'd12 ;
parameter [3:0] Change_current_station = 4'd13 ;

reg [3:0] station_path0 [0:7] ;
reg [3:0] station_path1 [0:7] ;
reg [3:0] station_path2 [0:7] ;
reg [3:0] station_path3 [0:7] ;
reg [3:0] station_path4 [0:7] ;
reg [3:0] station_path5 [0:7] ;
reg [3:0] station_path6 [0:7] ;
reg [3:0] station_path7 [0:7] ;

reg [4:0] counter_store ;
reg [2:0] counter_change ;
reg [2:0] counter_wait_change ;
reg [2:0] counter_current_station ;

reg [2:0] counter_path0 ;
reg [2:0] counter_path1 ;
reg [2:0] counter_path2 ;
reg [2:0] counter_path3 ;
reg [2:0] counter_path4 ;
reg [2:0] counter_path5 ;
reg [2:0] counter_path6 ;
reg [2:0] counter_path7 ;

reg[4:0] temp_station_0, temp_station_1, temp_station_2, temp_station_3, temp_station_4, temp_station_5, temp_station_6, temp_station_7;

integer i ;

///////////////////////////////////////////
//            state_change
///////////////////////////////////////////

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

///////////////////////////////////////////
//            counter_wait_change 
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        counter_wait_change <= 3'd0 ;
    end
    else begin
        if (Next_state == Station_change)
        begin
            counter_wait_change <= 3'd0 ;
        end
        else if (Next_state == Change_current_station ) 
        begin
            counter_wait_change <= counter_wait_change + 1'd1 ;
        end
        else begin
            counter_wait_change <= counter_wait_change  ;
        end
    end
end

///////////////////////////////////////////
//            counter_change 
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        counter_change <= 3'd0 ;
    end
    else begin
        if (Current_state == Change_current_station || Current_state == Station_change) 
        begin
            counter_change <= 3'd0 ;
        end
        else begin
            counter_change <= counter_change + 1'd1 ;
        end
    end
end

///////////////////////////////////////////
//            counter_store for process cost
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        counter_store <= 5'd0 ;
    end
    else begin
        if (counter_store == 5'd30) 
        begin
            counter_store <= 5'd0 ;
        end
        else begin
            counter_store <= (in_valid)?  counter_store + 1'd1 : 5'd0 ;
        end
    end
end

///////////////////////////////////////////
//            temp_station
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        temp_station_0 <= 3'd0 ;
    end
    else begin
        if (Current_state == Change_1 && counter_change == 3'd1)
        temp_station_0 <= current_station ;
        else if (Current_state == Change_1 && counter_change == 3'd2)
        temp_station_1 <= current_station ;
        else if (Current_state == Change_1 && counter_change == 3'd3)
        temp_station_2 <= current_station ;
        else if (Current_state == Change_1 && counter_change == 3'd4)
        temp_station_3 <= current_station ;
        else if (Current_state == Change_1 && counter_change == 3'd5)
        temp_station_4 <= current_station ;
        else if (Current_state == Change_1 && counter_change == 3'd6)
        temp_station_5 <= current_station ;
        else if (Current_state == Change_1 && counter_change == 3'd7)
        temp_station_6 <= current_station ;

    end
end


///////////////////////////////////////////
//            counter_current_station 
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        counter_current_station <= 3'd0 ;
    end
    else begin
        if (Next_state == Change_current_station) 
        begin
            counter_current_station <= counter_current_station + 1'd1 ;
        end
        else if (Next_state == Cost_out)
        begin
            counter_current_station <=  3'd0 ;
        end
        else begin
            counter_current_station <= counter_current_station ;
        end
    end
end

///////////////////////////////////////////
//           non_source 
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        non_source <= 1'd0 ;
    end
    else begin
        if (Next_state == reset_path)
        begin
            non_source <= 1'd0 ;
        end
        else if ((Current_state == Station_store) && in_valid)
        begin
            non_source <= (current_station == source)? 1'd1 : non_source ;
        end
    end
end

///////////////////////////////////////////
//           non_destination 
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        non_destination <= 1'd0 ;
    end
    else begin
        if (Next_state == reset_path)
        begin
            non_destination <= 1'd0 ;
        end
        else if ((Current_state == Station_store) && in_valid)
        begin
            non_destination <= ( destination_station == destination)? 1'd1 : non_destination ;
        end
    end
end

///////////////////////////////////////////
//            counter_path0
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
        counter_path0 <= 3'd0 ;
    else begin
        if (counter_store > 0)
            counter_path0 <= ((source == 0) || (destination == 0))? counter_path0 +1 : counter_path0 ;
        else
            counter_path0 <= 3'd0 ;
    end
end

///////////////////////////////////////////
//            counter_path1
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
        counter_path1 <= 3'd0 ;
    else begin
        if (counter_store > 0)
            counter_path1 <= ((source == 1) || (destination == 1))? counter_path1 +1 : counter_path1 ;
        else
            counter_path1 <= 3'd0 ;
    end
end

///////////////////////////////////////////
//            counter_path2
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
        counter_path2 <= 3'd0 ;
    else begin
        if (counter_store > 0)
            counter_path2 <= ((source == 2) || (destination == 2))? counter_path2 +1 : counter_path2 ;
        else
            counter_path2 <= 3'd0 ;
    end
end

///////////////////////////////////////////
//            counter_path3
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
        counter_path3 <= 3'd0 ;
    else begin
        if (counter_store > 0)
            counter_path3 <= ((source == 3) || (destination == 3))? counter_path3 +1 : counter_path3 ;
        else
            counter_path3 <= 3'd0 ;
    end
end

///////////////////////////////////////////
//            counter_path4
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
        counter_path4 <= 3'd0 ;
    else begin
        if (counter_store > 0)
            counter_path4 <= ((source == 4) || (destination == 4))? counter_path4 +1 : counter_path4 ;
        else
            counter_path4 <= 3'd0 ;
    end
end

///////////////////////////////////////////
//            counter_path5
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
        counter_path5 <= 3'd0 ;
    else begin
        if (counter_store > 0)
            counter_path5 <= ((source == 5) || (destination == 5))? counter_path5 +1 : counter_path5 ;
        else
            counter_path5 <= 3'd0 ;
    end
end

///////////////////////////////////////////
//            counter_path6
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
        counter_path6 <= 3'd0 ;
    else begin
        if (counter_store > 0)
            counter_path6 <= ((source == 6) || (destination == 6))? counter_path6 +1 : counter_path6 ;
        else
            counter_path6 <= 3'd0 ;
    end
end

///////////////////////////////////////////
//            counter_path7
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
        counter_path7 <= 3'd0 ;
    else begin
        if (counter_store > 0)
            counter_path7 <= ((source == 7) || (destination == 7))? counter_path7 +1 : counter_path7 ;
        else
            counter_path7 <= 3'd0 ;
    end
end

///////////////////////////////////////////
//            store station_path0  
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        for (i=0; i<8; i=i+1)
        begin
            station_path0[i] <= 4'd0 ;
        end
    end
    else begin
        if (Next_state == reset_path)
        begin
            for (i=0; i<8; i=i+1)
            begin
                station_path0[i] <= 4'd10 ;
            end
        end
        else if (Next_state == Station_store && in_valid)
        begin
        case(counter_path0)
        4'd0: station_path0[0] <= (source == 0)? destination : ((destination == 0)? source : station_path0[0]) ;
        4'd1: station_path0[1] <= (source == 0)? destination : ((destination == 0)? source : station_path0[1]) ;
        4'd2: station_path0[2] <= (source == 0)? destination : ((destination == 0)? source : station_path0[2]) ;
        4'd3: station_path0[3] <= (source == 0)? destination : ((destination == 0)? source : station_path0[3]) ;
        4'd4: station_path0[4] <= (source == 0)? destination : ((destination == 0)? source : station_path0[4]) ;
        4'd5: station_path0[5] <= (source == 0)? destination : ((destination == 0)? source : station_path0[5]) ;
        4'd6: station_path0[6] <= (source == 0)? destination : ((destination == 0)? source : station_path0[6]) ;
        4'd7: station_path0[7] <= (source == 0)? destination : ((destination == 0)? source : station_path0[7]) ;
        endcase
        end
    end
end

///////////////////////////////////////////
//            store station_path1  
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        for (i=0; i<8; i=i+1)
        begin
            station_path1[i] <= 4'd0 ;
        end
    end
    else begin
        if (Next_state == reset_path)
        begin
            for (i=0; i<8; i=i+1)
            begin
                station_path1[i] <= 4'd10 ;
            end
        end
        else if (Current_state == Station_store && in_valid)
        begin
        case(counter_path1)
        4'd0: station_path1[0] <= (source == 1)? destination : ((destination == 1)? source : station_path1[0]) ;
        4'd1: station_path1[1] <= (source == 1)? destination : ((destination == 1)? source : station_path1[1]) ;
        4'd2: station_path1[2] <= (source == 1)? destination : ((destination == 1)? source : station_path1[2]) ;
        4'd3: station_path1[3] <= (source == 1)? destination : ((destination == 1)? source : station_path1[3]) ;
        4'd4: station_path1[4] <= (source == 1)? destination : ((destination == 1)? source : station_path1[4]) ;
        4'd5: station_path1[5] <= (source == 1)? destination : ((destination == 1)? source : station_path1[5]) ;
        4'd6: station_path1[6] <= (source == 1)? destination : ((destination == 1)? source : station_path1[6]) ;
        4'd7: station_path1[7] <= (source == 1)? destination : ((destination == 1)? source : station_path1[7]) ;
        endcase
        end
    end
end

///////////////////////////////////////////
//            store station_path2  
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        for (i=0; i<8; i=i+1)
        begin
            station_path2[i] <= 4'd0 ;
        end
    end
    else begin
        if (Next_state == reset_path)
        begin
            for (i=0; i<8; i=i+1)
            begin
                station_path2[i] <= 4'd10 ;
            end
        end
        else if (Current_state == Station_store && in_valid)
        begin
        case(counter_path2)
        4'd0: station_path2[0] <= (source == 2)? destination : ((destination == 2)? source : station_path2[0]) ;
        4'd1: station_path2[1] <= (source == 2)? destination : ((destination == 2)? source : station_path2[1]) ;
        4'd2: station_path2[2] <= (source == 2)? destination : ((destination == 2)? source : station_path2[2]) ;
        4'd3: station_path2[3] <= (source == 2)? destination : ((destination == 2)? source : station_path2[3]) ;
        4'd4: station_path2[4] <= (source == 2)? destination : ((destination == 2)? source : station_path2[4]) ;
        4'd5: station_path2[5] <= (source == 2)? destination : ((destination == 2)? source : station_path2[5]) ;
        4'd6: station_path2[6] <= (source == 2)? destination : ((destination == 2)? source : station_path2[6]) ;
        4'd7: station_path2[7] <= (source == 2)? destination : ((destination == 2)? source : station_path2[7]) ;
        endcase
        end
    end
end

///////////////////////////////////////////
//            store station_path3  
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        for (i=0; i<8; i=i+1)
        begin
            station_path3[i] <= 4'd0 ;
        end
    end
    else begin
        if (Next_state == reset_path)
        begin
            for (i=0; i<8; i=i+1)
            begin
                station_path3[i] <= 4'd10 ;
            end
        end
        else if (Current_state == Station_store && in_valid)
        begin
        case(counter_path3)
        4'd0: station_path3[0] <= (source == 3)? destination : ((destination == 3)? source : station_path3[0]) ;
        4'd1: station_path3[1] <= (source == 3)? destination : ((destination == 3)? source : station_path3[1]) ;
        4'd2: station_path3[2] <= (source == 3)? destination : ((destination == 3)? source : station_path3[2]) ;
        4'd3: station_path3[3] <= (source == 3)? destination : ((destination == 3)? source : station_path3[3]) ;
        4'd4: station_path3[4] <= (source == 3)? destination : ((destination == 3)? source : station_path3[4]) ;
        4'd5: station_path3[5] <= (source == 3)? destination : ((destination == 3)? source : station_path3[5]) ;
        4'd6: station_path3[6] <= (source == 3)? destination : ((destination == 3)? source : station_path3[6]) ;
        4'd7: station_path3[7] <= (source == 3)? destination : ((destination == 3)? source : station_path3[7]) ;
        endcase
        end
    end
end

///////////////////////////////////////////
//            store station_path4
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        for (i=0; i<8; i=i+1)
        begin
            station_path4[i] <= 4'd0 ;
        end
    end
    else begin
        if (Next_state == reset_path)
        begin
            for (i=0; i<8; i=i+1)
            begin
                station_path4[i] <= 4'd10 ;
            end
        end
        else if (Current_state == Station_store && in_valid)
        begin
        case(counter_path4)
        4'd0: station_path4[0] <= (source == 4)? destination : ((destination == 4)? source : station_path4[0]) ;
        4'd1: station_path4[1] <= (source == 4)? destination : ((destination == 4)? source : station_path4[1]) ;
        4'd2: station_path4[2] <= (source == 4)? destination : ((destination == 4)? source : station_path4[2]) ;
        4'd3: station_path4[3] <= (source == 4)? destination : ((destination == 4)? source : station_path4[3]) ;
        4'd4: station_path4[4] <= (source == 4)? destination : ((destination == 4)? source : station_path4[4]) ;
        4'd5: station_path4[5] <= (source == 4)? destination : ((destination == 4)? source : station_path4[5]) ;
        4'd6: station_path4[6] <= (source == 4)? destination : ((destination == 4)? source : station_path4[6]) ;
        4'd7: station_path4[7] <= (source == 4)? destination : ((destination == 4)? source : station_path4[7]) ;
        endcase
        end
    end
end

///////////////////////////////////////////
//            store station_path5  
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        for (i=0; i<8; i=i+1)
        begin
            station_path5[i] <= 4'd0 ;
        end
    end
    else begin
        if (Next_state == reset_path)
        begin
            for (i=0; i<8; i=i+1)
            begin
                station_path5[i] <= 4'd10 ;
            end
        end
        else if (Current_state == Station_store && in_valid)
        begin
        case(counter_path5)
        4'd0: station_path5[0] <= (source == 5)? destination : ((destination == 5)? source : station_path5[0]) ;
        4'd1: station_path5[1] <= (source == 5)? destination : ((destination == 5)? source : station_path5[1]) ;
        4'd2: station_path5[2] <= (source == 5)? destination : ((destination == 5)? source : station_path5[2]) ;
        4'd3: station_path5[3] <= (source == 5)? destination : ((destination == 5)? source : station_path5[3]) ;
        4'd4: station_path5[4] <= (source == 5)? destination : ((destination == 5)? source : station_path5[4]) ;
        4'd5: station_path5[5] <= (source == 5)? destination : ((destination == 5)? source : station_path5[5]) ;
        4'd6: station_path5[6] <= (source == 5)? destination : ((destination == 5)? source : station_path5[6]) ;
        4'd7: station_path5[7] <= (source == 5)? destination : ((destination == 5)? source : station_path5[7]) ;
        endcase
        end
    end
end

///////////////////////////////////////////
//            store station_path6  
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        for (i=0; i<8; i=i+1)
        begin
            station_path6[i] <= 4'd0 ;
        end
    end
    else begin
        if (Next_state == reset_path)
        begin
            for (i=0; i<8; i=i+1)
            begin
                station_path6[i] <= 4'd10 ;
            end
        end
        else if (Current_state == Station_store && in_valid)
        begin
        case(counter_path6)
        4'd0: station_path6[0] <= (source == 6)? destination : ((destination == 6)? source : station_path6[0]) ;
        4'd1: station_path6[1] <= (source == 6)? destination : ((destination == 6)? source : station_path6[1]) ;
        4'd2: station_path6[2] <= (source == 6)? destination : ((destination == 6)? source : station_path6[2]) ;
        4'd3: station_path6[3] <= (source == 6)? destination : ((destination == 6)? source : station_path6[3]) ;
        4'd4: station_path6[4] <= (source == 6)? destination : ((destination == 6)? source : station_path6[4]) ;
        4'd5: station_path6[5] <= (source == 6)? destination : ((destination == 6)? source : station_path6[5]) ;
        4'd6: station_path6[6] <= (source == 6)? destination : ((destination == 6)? source : station_path6[6]) ;
        4'd7: station_path6[7] <= (source == 6)? destination : ((destination == 6)? source : station_path6[7]) ;
        endcase
        end
    end
end

///////////////////////////////////////////
//            store station_path7  
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        for (i=0; i<8; i=i+1)
        begin
            station_path7[i] <= 4'd0 ;
        end
    end
    else begin
        if (Next_state == reset_path)
        begin
            for (i=0; i<8; i=i+1)
            begin
                station_path7[i] <= 4'd10 ;
            end
        end
        else if (Current_state == Station_store && in_valid)
        begin
        case(counter_path7)
        4'd0: station_path7[0] <= (source == 7)? destination : ((destination == 7)? source : station_path7[0]) ;
        4'd1: station_path7[1] <= (source == 7)? destination : ((destination == 7)? source : station_path7[1]) ;
        4'd2: station_path7[2] <= (source == 7)? destination : ((destination == 7)? source : station_path7[2]) ;
        4'd3: station_path7[3] <= (source == 7)? destination : ((destination == 7)? source : station_path7[3]) ;
        4'd4: station_path7[4] <= (source == 7)? destination : ((destination == 7)? source : station_path7[4]) ;
        4'd5: station_path7[5] <= (source == 7)? destination : ((destination == 7)? source : station_path7[5]) ;
        4'd6: station_path7[6] <= (source == 7)? destination : ((destination == 7)? source : station_path7[6]) ;
        4'd7: station_path7[7] <= (source == 7)? destination : ((destination == 7)? source : station_path7[7]) ;
        endcase
        end
    end
end
///////////////////////////////////////////
//            source_station  
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        source_station <= 4'd0 ;
    end
    else begin
        if (Next_state == Station_store) 
        begin
            source_station <= (counter_store == 0)? source : source_station ; 
        end
        else if (Current_state == Change_current_station && counter_wait_change == 3'd1)
        begin
            source_station <= temp_station_0 ;
        end
        else if (Current_state == Change_current_station && counter_wait_change == 3'd2)
        begin
            source_station <= temp_station_1 ;
        end
        else if (Current_state == Change_current_station && counter_wait_change == 3'd3)
        begin
            source_station <= temp_station_2 ;
        end
        else if (Current_state == Change_current_station && counter_wait_change == 3'd4)
        begin
            source_station <= temp_station_3 ;
        end
        else if (Current_state == Change_current_station && counter_wait_change == 3'd5)
        begin
            source_station <= temp_station_4 ;
        end
        else if (Current_state == Change_current_station && counter_wait_change == 3'd6)
        begin
            source_station <= temp_station_5 ;
        end
        else if (Current_state == Change_current_station && counter_wait_change == 3'd7)
        begin
            source_station <= temp_station_6 ;
        end
        
    end
end


///////////////////////////////////////////
//            destination_station  
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        destination_station <= 4'd0 ;
    end
    else begin
        if (Next_state == Station_store) 
        begin
            destination_station <= (counter_store == 0)? destination : destination_station ; 
        end
    end
end

///////////////////////////////////////////
//            current_station  
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        current_station <= 4'd0 ;
    end
    else begin
        if (Next_state == Station_store) 
        begin
            current_station <= (counter_store == 0)? source : current_station ; 
        end
        else if (Next_state == Change_1)
        begin
            if (match == 0)
            begin
                if (source_station == 4'd0)
                    current_station <= station_path0[counter_change] ;
                else if (source_station == 4'd1)
                    current_station <= station_path1[counter_change] ;
                else if (source_station == 4'd2)
                    current_station <= station_path2[counter_change] ;
                else if (source_station == 4'd3)
                    current_station <= station_path3[counter_change] ;
                else if (source_station == 4'd4)
                    current_station <= station_path4[counter_change] ;
                else if (source_station == 4'd5)
                    current_station <= station_path5[counter_change] ;
                else if (source_station == 4'd6)
                    current_station <= station_path6[counter_change] ;
                else if (source_station == 4'd7)
                    current_station <= station_path7[counter_change] ;
                else 
                    current_station <= current_station ;
            end
        end
        else if (Current_state == Change_2)
        begin
            if (source_station == 4'd0)
                current_station <= station_path0[counter_change] ;
            else if (source_station == 4'd1)
                current_station <= station_path1[counter_change] ;
            else if (source_station == 4'd2)
                current_station <= station_path2[counter_change] ;
            else if (source_station == 4'd3)
                current_station <= station_path3[counter_change] ;
            else if (source_station == 4'd4)
                current_station <= station_path4[counter_change] ;
            else if (source_station == 4'd5)
                current_station <= station_path5[counter_change] ;
            else if (source_station == 4'd6)
                current_station <= station_path6[counter_change] ;
            else if (source_station == 4'd7)
                current_station <= station_path7[counter_change] ;
            else 
                current_station <= current_station ;
        end
    end
end



///////////////////////////////////////////
//            match  
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n)
    begin
        for (i=0; i<7; i=i+1)
        begin
            match[i] <= 1'd0 ;
        end
    end
    else begin
        if (Next_state == reset_path)
        begin
            for (i=0; i<7; i=i+1)
            begin
                match[i] <= 1'd0 ;
            end
        end
        else if (Next_state == Station_change | Next_state == Change_1 | Next_state == Change_2 | Next_state == Change_3 | Next_state == Change_4 | Next_state == Change_5 | Next_state == Change_6 | Next_state == Change_7) 
        begin
            if (current_station == 4'd0)
            begin
                for (i=0; i<7; i=i+1)
                begin
                    match[i] <= (station_path0[i] == destination_station)? 1'd1 : 1'd0 ;
                end
            end
            else if (current_station == 4'd1)
            begin
                for (i=0; i<7; i=i+1)
                begin
                    match[i] <= (station_path1[i] == destination_station)? 1'd1 : 1'd0 ;
                end
            end
            else if (current_station == 4'd2)
            begin
                for (i=0; i<7; i=i+1)
                begin
                    match[i] <= (station_path2[i] == destination_station)? 1'd1 : 1'd0 ;
                end
            end
            else if (current_station == 4'd3)
            begin
                for (i=0; i<7; i=i+1)
                begin
                    match[i] <= (station_path3[i] == destination_station)? 1'd1 : 1'd0 ;
                end
            end
            else if (current_station == 4'd4)
            begin
                for (i=0; i<7; i=i+1)
                begin
                    match[i] <= (station_path4[i] == destination_station)? 1'd1 : 1'd0 ;
                end
            end
            else if (current_station == 4'd5)
            begin
                for (i=0; i<7; i=i+1)
                begin
                    match[i] <= (station_path5[i] == destination_station)? 1'd1 : 1'd0 ;
                end
            end
            else if (current_station == 4'd6)
            begin
                for (i=0; i<7; i=i+1)
                begin
                    match[i] <= (station_path6[i] == destination_station)? 1'd1 : 1'd0 ;
                end
            end
            else if (current_station == 4'd7)
            begin
                for (i=0; i<7; i=i+1)
                begin
                    match[i] <= (station_path7[i] == destination_station)? 1'd1 : 1'd0 ;
                end
            end
        end
    end    
end

///////////////////////////////////////////
//            non_solution 
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n)
    begin
        for (i=0; i<7; i=i+1)
        begin
            non_solution[i] <= 1'd0 ;
        end
    end
    else begin
        if (Next_state == reset_path)
        begin
            for (i=0; i<7; i=i+1)
            begin
                non_solution[i] <= 1'd0 ;
            end
        end
        else if (Next_state == Station_change) 
        begin
            if (current_station == 4'd0)
            begin
                for (i=0; i<7; i=i+1)
                begin
                    non_solution[i] <= (station_path0[i] > 4'd8)? 1'd1 : 1'd0 ;
                end
            end
            else if (current_station == 4'd1)
            begin
                for (i=0; i<7; i=i+1)
                begin
                    non_solution[i] <= (station_path1[i] > 4'd8)? 1'd1 : 1'd0 ;
                end
            end
            else if (current_station == 4'd2)
            begin
                for (i=0; i<7; i=i+1)
                begin
                    non_solution[i] <= (station_path2[i] > 4'd8)? 1'd1 : 1'd0 ;
                end
            end
            else if (current_station == 4'd3)
            begin
                for (i=0; i<7; i=i+1)
                begin
                    non_solution[i] <= (station_path3[i] > 4'd8)? 1'd1 : 1'd0 ;
                end
            end
            else if (current_station == 4'd4)
            begin
                for (i=0; i<7; i=i+1)
                begin
                    non_solution[i] <= (station_path4[i] > 4'd8)? 1'd1 : 1'd0 ;
                end
            end
            else if (current_station == 4'd5)
            begin
                for (i=0; i<7; i=i+1)
                begin
                    non_solution[i] <= (station_path5[i] > 4'd8)? 1'd1 : 1'd0 ;
                end
            end
            else if (current_station == 4'd6)
            begin
                for (i=0; i<7; i=i+1)
                begin
                    non_solution[i] <= (station_path6[i] > 4'd8)? 1'd1 : 1'd0 ;
                end
            end
            else if (current_station == 4'd7)
            begin
                for (i=0; i<7; i=i+1)
                begin
                    non_solution[i] <= (station_path7[i] > 4'd8)? 1'd1 : 1'd0 ;
                end
            end
        end
    end    
end

///////////////////////////////////////////
//              path_cost
///////////////////////////////////////////

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        path_cost <= 10'd0 ;
    end
    else begin
        if ((Current_state == Station_change) | Current_state == Change_reset)
        begin
            if (Next_state == Change_6)
            begin
                path_cost <= 10'd0 ;
            end
            else if ((!non_source) & (!non_destination) & (non_solution[0]&non_solution[1]&non_solution[2]&non_solution[3]&non_solution[4]&non_solution[5]&non_solution[6]))
            begin
                path_cost <= 10'd0 ;
            end
            else if (!non_source & (non_solution[0]&non_solution[1]&non_solution[2]&non_solution[3]&non_solution[4]&non_solution[5]&non_solution[6]))
            begin
                path_cost <= 10'd0 ; 
            end
            else begin
                path_cost <= path_cost + 1'd1 ; 
            end
        end
        else if (Next_state == Change_current_station && counter_current_station == 3'd0)
        begin
            path_cost <= path_cost + 1'd1 ; 
        end
        else if (Next_state == Change_7 || Next_state == Change_6)
        begin
            path_cost <= 10'd0 ;
        end
        else if (Next_state == reset_path)
        begin
            path_cost <= 10'd0 ;
        end
    end
end

///////////////////////////////////////////
//            output_valid  
///////////////////////////////////////////


always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        out_valid <= 1'd0 ;
    end
    else begin
        out_valid <= (Current_state == Cost_out)? 1'd1 : 1'd0 ;
    end
end

///////////////////////////////////////////
//            output_cost  
///////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        cost <= 3'd0 ;
    end
    else begin
        cost <= (Current_state == Cost_out)? path_cost : 3'd0 ;
    end
end

///////////////////////////////////////////
//            state_change  
///////////////////////////////////////////

always @(*)
begin
    case(Current_state)
    IDLE:
    begin
        Next_state = (in_valid)? Station_store : IDLE ; 
    end
    Station_store: Next_state = (in_valid)? Station_store : Station_change ;
    Station_change: 
    begin
        if ((match != 0) | (non_solution[0]&non_solution[1]&non_solution[2]&non_solution[3]&non_solution[4]&non_solution[5]&non_solution[6]))
        Next_state = Cost_out ;
        else
        Next_state = Change_reset ;
    end
    Change_reset:
    begin
        case (counter_wait_change)
        3'd0: Next_state = Change_1 ;
        3'd1: Next_state = Change_2 ;
        3'd2: Next_state = Change_3 ;
        3'd3: Next_state = Change_4 ;
        3'd4: Next_state = Change_5 ;
        3'd5: Next_state = Change_6 ;
        3'd6: Next_state = Change_7 ;
        3'd7: Next_state = Change_7 ;
        default: Next_state = Change_reset ;
        endcase 
    end
    Change_1: Next_state = (match)? Cost_out : ((counter_change==3'd7)? Change_current_station : Change_1) ;
    Change_2: Next_state = (match)? Cost_out : ((counter_change==3'd7)? Change_current_station : Change_2) ;
    Change_3: Next_state = (match)? Cost_out : ((counter_change==3'd7)? Change_current_station : Change_3) ;
    Change_4: Next_state = (match)? Cost_out : ((counter_change==3'd7)? Change_current_station : Change_4) ;
    Change_5: Next_state = (match)? Cost_out : ((counter_change==3'd7)? Change_current_station : Change_5) ;
    Change_6: Next_state = Cost_out ;
    Change_7: Next_state = Cost_out ;
    Change_current_station:    
    begin
        case (counter_wait_change)
        3'd0: Next_state = Change_1 ;
        3'd1: Next_state = Change_2 ;
        3'd2: Next_state = Change_2 ;
        3'd3: Next_state = Change_3 ;
        3'd4: Next_state = Change_4 ;
        3'd5: Next_state = Change_5 ;
        3'd6: Next_state = Change_6 ;
        3'd7: Next_state = Change_7 ;
        default: Next_state = Change_current_station ;
        endcase 
    end
    Cost_out: Next_state = reset_path ;
    reset_path: Next_state = (in_valid)? Station_store : reset_path ;
    default: Next_state = IDLE ;
    endcase
end

endmodule 