//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   2023 ICC Laser Treatment
//   Design         : LASER
//   Author         : CHAN-HAO LIAO (jericc880417@gmail.com)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   File Name   : LASER.v
//   Module Name : LASER
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################
module LASER (
           input CLK,
           input RST,
           input [3:0] X,
           input [3:0] Y,
           output reg [3:0] C1X,
           output reg [3:0] C1Y,
           output reg [3:0] C2X,
           output reg [3:0] C2Y,
           output reg DONE);

//================================================================
//  Parameter 、 Resgister    
//================================================================
wire chang_up_0, chang_up_1, chang_up_2, chang_up_3, chang_up_4;
wire chang_down_0, chang_down_1, chang_down_2, chang_down_3    ;
wire scan_end                      ;
reg  second                        ;
reg  check                         ;
reg  a                             ;
reg [5:0] counter_stoer            ;
reg [3:0] soter_x [0:39]           ;
reg [3:0] soter_y [0:39]           ;
reg [3:0] scan_x, scan_y           ; 
reg [3:0] scan_max_x, scan_max_y   ;
reg [3:0] point_x, point_y         ;
reg [3:0] record_x, record_y       ;
reg [3:0] b_x, b_y, b_x2, b_y2     ;
reg [4:0] number                   ;
reg [4:0] big_number               ;
reg [3:0] circular_x [0:20]        ;
reg [3:0] circular_y [0:20]        ;
reg [39:0] target_point            ;
reg [20:0] target_point2           ;

reg [3:0] Current_state, Next_state;
parameter Read_data    = 4'd0;
parameter Scan_up      = 4'd1;
parameter Scan_down    = 4'd2;
parameter Scan_up2     = 4'd3;
parameter Scan_down2   = 4'd4;
parameter Calculate    = 4'd5;
parameter Second_poing = 4'd6;
parameter Store_max_p  = 4'd7;
parameter Out_data     = 4'd8;
parameter Wait         = 4'd9;
integer i;
//================================================================
//  State change
//================================================================
always @(posedge CLK or posedge RST) 
begin
    if (RST)
        Current_state <= Read_data; 
    else
        Current_state <= Next_state;
end

always @(*)
begin
    case(Current_state)
        4'd0: Next_state = (counter_stoer==6'd39)? Scan_up : Read_data;
        4'd1:
        begin
            if(point_y==4'd0 && chang_up_0)
                Next_state = Scan_down;
            else if(point_y==4'd1 && chang_up_1)
                Next_state = Scan_down;
            else if(point_y==4'd2 && chang_up_2)
                 Next_state = Scan_down;
            else if(point_y==4'd3 && chang_up_3)
                 Next_state = Scan_down;
            else if(chang_up_4)
                 Next_state = Scan_down;
            else
                Next_state = Scan_up;
        end
        4'd2:
         begin
            if(chang_down_3)
                Next_state = Calculate;
            else
                Next_state = Scan_down;
        end
        4'd3:
        begin
            if(point_y==4'd0 && chang_up_0)
                Next_state = Scan_down;
            else if(point_y==4'd1 && chang_up_1)
                Next_state = Scan_down2;
            else if(point_y==4'd2 && chang_up_2)
                 Next_state = Scan_down2;
            else if(point_y==4'd3 && chang_up_3)
                 Next_state = Scan_down2;
            else if(chang_up_4)
                 Next_state = Scan_down2;
            else
                Next_state = Scan_up2;
        end
        4'd4:
         begin
            if(chang_down_3)
                Next_state = Calculate;
            else
                Next_state = Scan_down2;
        end
        4'd5: 
        begin
            if(scan_end && check)
                Next_state = Scan_up;
            else if(point_x==4'd15 && point_y==4'd11)
                Next_state = Second_poing;
            else if(second)
                Next_state = Scan_up2;
            else
                Next_state = Scan_up;
        end
        4'd6: 
        begin
            if(a && record_x==b_x && record_y==b_y)
                Next_state = Out_data;
             else
                Next_state = Store_max_p;
        end 
        4'd7: Next_state = Scan_up;
        4'd8: Next_state = Wait;
        4'd9: Next_state = Read_data;
    endcase
end
//================================================================
//  Counter
//================================================================
always @(posedge CLK or posedge RST)
begin
    if(RST)
        counter_stoer <= 6'd0;
    else
        if(counter_stoer==6'd40)
            counter_stoer <= 6'd0;
        else if(Current_state==Read_data && counter_stoer==6'd39)
            counter_stoer <= 6'd0;
        else if(Current_state==Second_poing)
            counter_stoer <= 6'd0;
        else if(Current_state==Read_data || Current_state==Scan_up || Current_state==Scan_down || Current_state==Scan_up2 || Current_state==Scan_down2)
            counter_stoer <= counter_stoer+6'd1;
        else
            counter_stoer <= 6'd0;
end

//================================================================
//  Store Input X Y and Renew X Y
//================================================================
always @(posedge CLK or posedge RST)
begin
    if(RST)
        for(i=0; i<40; i=i+1)
        begin
            soter_x[i] <= 4'd0;
        end
    else
        if(Current_state==Read_data)
            soter_x[counter_stoer] <= X;
end

always @(posedge CLK or posedge RST)
begin
    if(RST)
        for(i=0; i<40; i=i+1)
        begin
            soter_y[i] <= 4'd0;
        end
    else
        if(Current_state==Read_data)
            soter_y[counter_stoer] <= Y;
end
//================================================================
//  Center of circle point X Y
//================================================================
always @(posedge CLK or posedge RST)
begin
    if(RST)
        second <= 1'd0;
    else if(Current_state==Out_data)
        second <= 1'd0;
    else if(scan_end && point_y==4'd11 && point_x==4'd15 && second && Current_state==Calculate)
        second <= 1'd0;
    else if(scan_end && point_y==4'd11 && point_x==4'd15 && Current_state==Calculate)
        second <= 1'd1;
end

always @(posedge CLK or posedge RST)
begin
    if(RST)
        a <= 1'd0;
    else if(Current_state==Out_data)
        a <= 1'd0;
    else if(Current_state==Second_poing && second)
        a <= 1'd1;

end

always @(posedge CLK or posedge RST)
begin
    if(RST)
        check <= 1'd0;
    else if(Current_state==Out_data)
        check <= 1'd0;
    else if(Current_state==Store_max_p)
        check <= 1'd1;
    else if(Current_state==Calculate && check && scan_end)
        check <= 1'd0;
end

always @(posedge CLK or posedge RST)
begin
    if(RST)
        point_x <= 4'd0;
    else if(Current_state==Calculate && point_x==4'd15  && point_y==4'd11)
        point_x <= record_x;
    else if(Current_state==Calculate && scan_end && check)
        point_x <= 4'd0;
    else if(Current_state==Out_data || (Current_state==Calculate && point_x==4'd15 && point_y==4'd11 && second))
        point_x <= 4'd0;
    else
        point_x <= (Current_state==Calculate && point_y==4'd11)? point_x+4'd1 : point_x;
end

always @(posedge CLK or posedge RST)
begin
    if(RST)
        point_y <= 4'd0;
    else if(Current_state==Calculate && point_x==4'd15  && point_y==4'd11)
        point_y <= record_y;
    else if(Current_state==Calculate && scan_end && check)
        point_y <= 4'd0;
    else if(Current_state==Out_data || (Current_state==Calculate && point_x==4'd15 && point_y==4'd11 && second))
        point_y <= 4'd0;
    else if(Current_state==Calculate && point_y==4'd11)
        point_y <= 4'd0;
    else
        point_y <= (Current_state==Calculate)? point_y+4'd1 : point_y;
end
//================================================================
//  Scan circle point X Y  
//================================================================
assign scan_end     = (point_y+4'd4==scan_y)? 1'd1 : 1'd0;
assign chang_up_0   = (point_y==scan_y   && scan_max_x==scan_x)? 1'd1 : 1'd0;
assign chang_up_1   = (point_y-1==scan_y && scan_max_x==scan_x)? 1'd1 : 1'd0;
assign chang_up_2   = (point_y-2==scan_y && scan_max_x==scan_x)? 1'd1 : 1'd0;
assign chang_up_3   = (point_y-3==scan_y && scan_max_x==scan_x)? 1'd1 : 1'd0;
assign chang_up_4   = (point_y-4==scan_y)? 1'd1 : 1'd0;
assign chang_down_0 = (point_y==scan_y-1 && scan_max_x==scan_x)? 1'd1 : 1'd0;
assign chang_down_1 = (point_y==scan_y-2 && scan_max_x==scan_x)? 1'd1 : 1'd0;
assign chang_down_2 = (point_y==scan_y-3 && scan_max_x==scan_x)? 1'd1 : 1'd0;
assign chang_down_3 = (point_y==scan_y-4)? 1'd1 : 1'd0;

always @(posedge CLK or posedge RST)
begin
    if(RST)
        scan_max_x <= 4'd4;
    else begin
        if(Current_state==Calculate && point_y==4'd11 && point_x==4'd15)
            scan_max_x <= 4'd4;
        else if(Current_state==Calculate && scan_end && check)
            scan_max_x <= 4'd4;
        else if(Current_state==Calculate || Current_state==Second_poing)
        begin
            if(point_x==4'd0 && point_y==4'd11)
                scan_max_x <= 4'd5;
            else 
                scan_max_x <= (point_x<12)? point_x+4'd4 : 4'd15;
        end
        else if(Current_state==Scan_up || Current_state==Scan_down || Current_state==Scan_up2 || Current_state==Scan_down2 || Current_state==Second_poing)
        begin
            if((chang_up_3 || chang_up_2) && scan_y==4'd0)
                 scan_max_x <= (point_x<12)? point_x+4'd3 : 4'd15; 
            else if(chang_up_0 || chang_up_1 || chang_up_4 ||chang_down_0)
                scan_max_x <= (point_x<12)? point_x+4'd3 : 4'd15; 
            else if(chang_up_2 || chang_down_1)
                scan_max_x <= (point_x<13)? point_x+4'd2 : 4'd15;
            else if(chang_up_3 || chang_down_2)
                scan_max_x <= point_x;
        end
    end
end

always @(posedge CLK or posedge RST)
begin
    if(RST)
        scan_max_y <= 4'd0;
    else begin
        if(Current_state==Calculate && scan_end && check)
            scan_max_y <= 4'd0;
        else if(Current_state==Current_state==Scan_up || Current_state==Scan_up2 || Current_state==Scan_down2 || Current_state==Second_poing)
            scan_max_y <= (point_y>11)? 4'd15 : point_y+4'd4;
    end
end

always @(posedge CLK or posedge RST)
begin
    if(RST)
        scan_x <= 4'd0;
    else begin
        if(Current_state==Out_data || (Current_state==Calculate && point_x==4'd15 && point_y==4'd11))
            scan_x <= 4'd0;
        else if(Current_state==Calculate && scan_end && check)
            scan_x <= 4'd0;
        else if(Current_state==Calculate || Current_state==Second_poing)
            scan_x <= (point_x>4'd3)? point_x-4'd4 : 4'd0;
        else if(scan_end)
            scan_x <= scan_x;
        else if(Current_state==Scan_up || Current_state==Scan_down || Current_state==Scan_up2 || Current_state==Scan_down2)
        begin
            if((chang_up_3 || chang_up_2) && scan_y==4'd0)
                scan_x <= (point_x>4'd3)? point_x-4'd3 : 4'd0;
            else if(chang_up_0 || chang_up_1 || chang_down_0 || chang_up_4)
                scan_x <= (point_x>4'd3)? point_x-4'd3 : 4'd0;
            else if(chang_up_2 || chang_up_2 || chang_down_1)
                scan_x <= (point_x>4'd2)? point_x-4'd2 : 4'd0;
            else if(chang_up_3 || chang_down_2)
                scan_x <= point_x;
            else
                scan_x <= scan_x+4'd1;
        end
    end 
end

always @(posedge CLK or posedge RST)
begin
    if(RST)
        scan_y <= 4'd0;
    else begin
        if(Current_state==Out_data || (Current_state==Calculate && point_x==4'd15 && point_y==4'd11))
            scan_y <= 4'd0;
        else if(Current_state==Calculate && scan_end && check)
            scan_y <= 4'd0;
        else if(Current_state==Calculate)
            scan_y <= (point_y==4'd11)? 4'd0 : point_y+4'd1;
        else if(Current_state==Second_poing)
            scan_y <= point_y;
        else if(Current_state==Scan_down || Current_state==Scan_down2)
        begin
            if(scan_end)
                scan_y <= scan_y;
            else
                scan_y <=(scan_x==scan_max_x)? scan_y+4'd1 : scan_y;
        end
        else if(Current_state==Scan_up || Current_state==Scan_up2 || Current_state==Scan_down || Current_state==Scan_down2)
        begin
            if(chang_up_4)
                scan_y <= point_y+4'd1;
            else if(scan_end)
                scan_y <= (point_y>4'd4)? point_y-4'd4 : 4'd0;
            else if(scan_x==scan_max_x && scan_y==4'd0)
                scan_y <= point_y+4'd1;
            else if (scan_x==scan_max_x)
                scan_y <= scan_y-4'd1;
        end
    end 
end
//================================================================
//  Scan target
//================================================================
always @(*)
begin
    if(Current_state==Scan_up || Current_state==Scan_up2 || Current_state==Scan_down || Current_state==Scan_down2)
    begin
        for(i=0; i<40; i=i+1)
        begin
            target_point[i] = (soter_x[i]==scan_x && soter_y[i]==scan_y)? 1'd1 : 1'd0;
        end
    end
    else begin
        target_point = 40'd0;
    end
end

always @(*)
begin
    if(a==1'd1 && check==1'd0)
    begin
        for(i=0; i<21; i=i+1)
        begin
            if(circular_x[i]==scan_x && circular_y[i]==scan_y)
            begin
                target_point2[i] = 1'd1;
            end
            else begin
                target_point2[i] = 1'd0;
            end
        end
    end
    else begin
        target_point2 = 20'd0; 
    end
end
//================================================================
// Record_position X Y
//================================================================
always @(posedge CLK or posedge RST)
begin
    if(RST)
    begin
        for(i=0; i<21; i=i+1)
        begin
            circular_x[i] = 4'd0;
        end
    end
    else begin
        if(check)
        begin
            circular_x[number] = (target_point!==40'd0)? scan_x : 4'd0;
        end
        else begin
            if(Current_state==Calculate && point_x==4'd15 && point_y==4'd11)
            begin
                for(i=0; i<21; i=i+1)
                begin
                    circular_x[i] = 4'd0;
                end
            end
        end
    end
end

always @(posedge CLK or posedge RST)
begin
    if(RST)
    begin
        for(i=0; i<21; i=i+1)
        begin
            circular_y[i] = 4'd0;
        end
    end
    else begin
        if(check)
        begin
            circular_y[number] = (target_point!==40'd0)? scan_y : 4'd0;
        end
        else begin
            if(Current_state==Calculate && point_x==4'd15 && point_y==4'd11)
            begin
                for(i=0; i<21; i=i+1)
                begin
                    circular_y[i] = 4'd0;
                end
            end
        end
    end
end
//================================================================
//  count sum number
//================================================================
always @(posedge CLK or posedge RST)
begin
    if(RST)
        number <= 5'd0;
    else
        if(Current_state==Scan_up || Current_state==Scan_down || Current_state==Scan_up2 || Current_state==Scan_down2)
            number <= (target_point!==40'd0 && target_point2==21'd0)? number+5'd1 : number;   
        else if(Current_state==Calculate || Current_state==Second_poing)
            number <= 5'd0;   
end

always @(posedge CLK or posedge RST)
begin
    if(RST)
        big_number <= 5'd0;
    else
        if(Current_state==Calculate && check && scan_end)
            big_number <= 5'd0;
        else if(Current_state==Calculate && point_x==4'd15 && point_y==4'd11 && second)
            big_number <= 5'd0;
        else if(Current_state==Calculate)
            big_number <= (big_number>=number)? big_number : number;
        else if(Current_state==Second_poing)
            big_number <= 5'd0;     
end

always @(posedge CLK or posedge RST)
begin
    if(RST)
        record_x <= 4'd0;
    else
        if(Current_state==Second_poing)
            record_x <= 4'd0;     
        else if(Current_state==Calculate)
            record_x <= (big_number>=number)? record_x : point_x;
end

always @(posedge CLK or posedge RST)
begin
    if(RST)
        record_y <= 4'd0;
    else
        if(Current_state==Second_poing)
            record_y <= 4'd0;  
        else if(Current_state==Calculate)
            record_y <= (big_number>=number)? record_y : point_y;
end

always @(posedge CLK or posedge RST)
begin
    if(RST)
        b_x <= 4'd0;
    else
        if(point_x==4'd15 && point_y==4'd11 && second==1'd0 && scan_end)
            b_x <= record_x;     
end

always @(posedge CLK or posedge RST)
begin
    if(RST)
        b_y <= 4'd0;
    else
        if(point_x==4'd15 && point_y==4'd11 && second==1'd0 && scan_end)
            b_y <= record_y;     
end

always @(posedge CLK or posedge RST)
begin
    if(RST)
        b_x2 <= 4'd0;
    else
        if(point_x==4'd15 && point_y==4'd11 && second==1'd1)
            b_x2 <= record_x;     
end

always @(posedge CLK or posedge RST)
begin
    if(RST)
        b_y2 <= 4'd0;
    else
        if(point_x==4'd15 && point_y==4'd11 && second==1'd1)
            b_y2 <= record_y;     
end
//================================================================
//  Output
//================================================================
always @(posedge CLK or posedge RST)
begin
    if(RST)
        DONE <= 1'd0;
    else
        if(Current_state==Out_data)
            DONE <= 1'd1;
        else
            DONE <= 1'd0;
end

always @(posedge CLK or posedge RST)
begin
    if(RST)
        C1Y <= 4'd0;
    else
        if(Current_state==Out_data)
            C1Y <= b_y;
        else
            C1Y <= 4'd0;
end

always @(posedge CLK or posedge RST)
begin
    if(RST)
        C1X <= 1'd0;
    else
        if(Current_state==Out_data)
            C1X <= b_x;
        else
            C1X <= 4'd0;
end

always @(posedge CLK or posedge RST)
begin
    if(RST)
        C2Y <= 1'd0;
    else
        if(Current_state==Out_data)
            C2Y <= b_y2;
        else
            C2Y <= 4'd0;
end

always @(posedge CLK or posedge RST)
begin
    if(RST)
        C2X <= 1'd0;
    else
        if(Current_state==Out_data)
            C2X <= b_x2;
        else
            C2X <= 4'd0;
end
endmodule