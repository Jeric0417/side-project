//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   2021 ICLAB Spring Course
//   Lab01          : Supper MOSFET Calculator (SMC)
//   Author         : CHAN-HAO LIAO (jericc880417@gmail.com)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   File Name   : MAZE.v
//   Module Name : MAZE
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module MAZE(
    //Input
    clk,
    rst_n,
    in,
    in_valid,
    //Optput
    out_valid,
    out
);

//================================================================
//   INPUT AND OUTPUT DECLARATION                         
//================================================================
input            clk, rst_n, in_valid, in ;
output reg       out_valid ;
output reg [1:0] out ; //right:00 down:01 left:10 up:11

//////////////////////////////////////////////////////////////////

reg [3:0] Current_state, Next_state ;
reg [4:0] current_x, current_y ;
reg [4:0] temp_x_up, temp_y_up ;
reg [4:0] temp_x_down, temp_y_down ;
reg [4:0] temp_x_left, temp_y_left ;
reg [4:0] temp_x_right, temp_y_right ;

reg [4:0] counter_0, counter_1 ;
reg [5:0] counter_reduce_maze ;

reg [18:0] maze_xy [0:18] ;

parameter IDLE = 4'd0 ;
parameter Read_data = 4'd1 ;
parameter Reduce_maze = 4'd2 ;
parameter Best_path = 4'd3 ;
parameter Right = 4'd4 ;
parameter Down = 4'd5 ;
parameter Left = 4'd6 ;
parameter Up = 4'd7 ;
parameter Reset = 4'd8 ;

integer i, j ;


wire [4:0] current_x_add ;
wire [4:0] current_y_add ;
wire [4:0] current_y_sub ;

assign current_x_add = current_x + 5'd1 ;
assign current_y_add = current_y + 5'd1 ;
assign current_y_sub = current_y - 5'd1 ;

//================================================================
//   State change                     
//================================================================

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
    case(Current_state)
    IDLE: Next_state = (in_valid)? Read_data : IDLE ;
    Read_data: Next_state = (in_valid)? Read_data : Reduce_maze ;
    Reduce_maze: Next_state = (counter_reduce_maze == 6'd45)? Best_path : Reduce_maze ;
    Best_path:
    begin
        if (current_x == 5'd17 && current_y == 5'd17)
        Next_state = Reset ;
        else if (maze_xy[current_y][current_x_add])
        Next_state = Right ;
        else if (maze_xy[current_y_add][current_x])
        Next_state = Down ;
        else if (maze_xy[current_y_sub][current_x])
        Next_state = Up ;
        else 
        Next_state = Left ;
    end
    Down:
    begin
        if (current_x == 5'd17 && current_y == 5'd17)
        Next_state = Reset ;
        else if (maze_xy[current_y][current_x_add] )
        Next_state = Right ;
        else if (maze_xy[current_y_add][current_x] )
        Next_state = Down ;
        else 
        Next_state = Left ;
    end
    Right:
    begin
        if (current_x == 5'd17 && current_y == 5'd17)
        Next_state = Reset ;
        else if (maze_xy[current_y][current_x_add] )
        Next_state = Right ;
        else if (maze_xy[current_y_add][current_x] )
        Next_state = Down ;
        else
        Next_state = Up ;
    end
    Left:
    begin
        if (current_x == 5'd16 && current_y == 5'd16)
        Next_state = Reset ;
        else if (maze_xy[current_y_add][current_x] )
        Next_state = Down ;
        else if (maze_xy[current_y_sub][current_x] )
        Next_state = Up ;
        else 
        Next_state = Left ;
    end
    Up:
    begin
        if (current_x == 5'd16 && current_y == 5'd16)
        Next_state = Reset ;
        else if (maze_xy[current_y][current_x_add] )
        Next_state = Right ;
        else if (maze_xy[current_y_sub][current_x] )
        Next_state = Up ;
        else 
        Next_state = Left ;
    end
    Reset: Next_state = IDLE ;
    default: Next_state = Reset ;
    endcase
end

//================================================================
//   Counter for Maze [1~17][1~17]                     
//================================================================

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        counter_0 <= 5'd1 ;    
    end
    else begin
        if (counter_0 == 5'd17)
        begin
            counter_0 <= 5'd1 ;
        end
        else begin
            counter_0 <= (in_valid)? counter_0 + 1 : 5'd1 ;
        end
    end
end

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        counter_1 <= 5'd1 ;    
    end
    else begin
        if (in_valid)
        begin
            counter_1 <= (counter_0 == 17)? counter_1 + 1 : counter_1 ;
        end
        else begin
            counter_1 <= 5'd1 ;
        end
    end
end

//================================================================
//   Counter for reduce maze                
//================================================================

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        counter_reduce_maze <= 5'd1 ;    
    end
    else begin
        if (Next_state == Reduce_maze)
        begin
            counter_reduce_maze <= counter_reduce_maze + 5'd1 ;
        end
        else begin
            counter_reduce_maze <= 5'd0 ;
        end
    end
end

//================================================================
//   Store Maze                       
//================================================================

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        for (i=0; i<19; i=i+1)
        begin
            for (j=0; j<19; j=j+1)
            begin
                maze_xy[i][j] <= 1'd0 ;
            end
        end
    end
    else begin
        if (Next_state == Read_data)
        begin
            maze_xy[counter_1][counter_0] <= in ;
        end
        else if (Next_state == Reduce_maze)
        begin
            for (i=1; i<19; i=i+1)
            begin
                for (j=1; j<19; j=j+1)
                begin
                    if ((i == 1 && j == 1) || (i == 5'd17 && j == 5'd17)) 
                    begin
                        maze_xy[i][j] <= maze_xy[i][j] ;
                    end
                    else if (maze_xy[i][j] == 0)
                    begin
                        maze_xy[i][j] <= 1'd0 ;
                    end
                    else if (((!maze_xy[i][j-1])&&(!maze_xy[i-1][j])&&(!maze_xy[i+1][j])) || (!maze_xy[i-1][j])&&(!maze_xy[i+1][j])&&(!maze_xy[i][j+1])
                             || ((!maze_xy[i][j-1])&&(!maze_xy[i-1][j])&&(!maze_xy[i][j+1])) || ((!maze_xy[i][j-1])&&(!maze_xy[i+1][j])&&(!maze_xy [i][j+1])))
                    begin
                        maze_xy[i][j] <= 1'd0 ;
                    end
                    else begin
                        maze_xy[i][j] <= 1'd1 ;
                    end
                end
            end
        end
    end
end

//================================================================
//   Current_maze xy                     
//================================================================

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        current_x <= 5'd1 ;
    end
    else begin
        case(Next_state)
            Reset :
            begin
                if(Current_state == Down || Current_state == Right || Current_state == Left || Current_state == Up)
                    current_x <= 5'd1 ;
                else
                    current_x <= current_x;
            end
            Right :
                current_x <= current_x + 5'd1 ;
            Down :
                current_x <= current_x ;
            Left :
                current_x <= current_x - 5'd1;
            Up :
                current_x <= current_x ;
            default :
                current_x <= current_x ;
        endcase
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        current_y <= 5'd1 ;
    end
    else begin
        case(Next_state)
            Reset :
            begin
                if(Current_state == Down || Current_state == Right || Current_state == Left || Current_state == Up)
                    current_y <= 5'd1 ;
                else
                    current_y <= current_y ;
            end
            Right :
                current_y <= current_y ;
            Down :
                current_y <= current_y + 5'd1;
            Left :
                current_y <= current_y ;
            Up :
                current_y <= current_y - 5'd1 ;
            default :
                current_y <= current_y ;
        endcase
    end
end

//================================================================
//   temp_xy up down rgiht left             
//================================================================

always@ (posedge clk or negedge rst_n)
begin
    if (!rst_n)
        temp_x_up <= 5'd1 ;
    else if (Next_state == Reset)
        temp_x_up <= 5'd1 ;
    else if (Next_state == Up)
        temp_x_up <= current_x ;
    else
        temp_x_up <= temp_x_up ;
end

always@ (posedge clk or negedge rst_n)
begin
    if (!rst_n)
        temp_y_up <= 5'd1 ;
    else if (Next_state == Reset)
        temp_y_up <= 5'd1 ;
    else if (Next_state == Up)
        temp_y_up <= current_y ;
    else
        temp_y_up <= temp_y_up ;
end

always@ (posedge clk or negedge rst_n)
begin
    if (!rst_n)
        temp_x_right <= 5'd1 ;
    else if (Next_state == Reset)
        temp_x_right <= 5'd1 ;
    else if (Next_state == Right)
        temp_x_right <= current_x ;
    else
        temp_x_right <= temp_x_right ;
end


always@ (posedge clk or negedge rst_n)
begin
    if (!rst_n)
        temp_y_right<= 5'd1 ;
    else if (Next_state == Reset)
        temp_y_right <= 5'd1 ;
    else if (Next_state == Right)
        temp_y_right <= current_y ;
    else
        temp_y_right <= temp_y_right ;
end


always@ (posedge clk or negedge rst_n)
begin
    if (!rst_n)
        temp_x_down <= 5'd1 ;
    else if (Next_state == Reset)
        temp_x_down <= 5'd1 ;
    else if (Next_state == Down)
        temp_x_down <= current_x ;
    else
        temp_x_down <= temp_x_down ;
end


always@ (posedge clk or negedge rst_n)
begin
    if (!rst_n)
        temp_y_down <= 5'd1 ;
    else if (Next_state == Reset)
        temp_y_down <= 5'd1 ;
    else if (Next_state == Down)
        temp_y_down <= current_y ;
    else
        temp_y_down <= temp_y_down ;
end


always@ (posedge clk or negedge rst_n)
begin
    if (!rst_n)
        temp_x_left <= 5'd1 ;
    else if (Next_state == Reset)
        temp_x_left <= 5'd1 ;
    else if (Next_state == Left)
        temp_x_left <= current_x ;
    else
        temp_x_left <= temp_x_left ;
end


always@ (posedge clk or negedge rst_n)
begin
    if (!rst_n)
        temp_y_left <= 5'd1 ;
     else if (Next_state == Reset)
        temp_y_left <= 5'd1 ;
    else if (Next_state == Left)
        temp_y_left <= current_y ;
    else
        temp_y_left <= temp_y_left ;
end

//================================================================
//   Output           
//================================================================

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        out_valid <= 1'd0 ;
    end
    else begin
        if  (Current_state == Right || Current_state == Down || Current_state == Left || Current_state == Up)
        begin
            out_valid <= 1'd1 ;
        end
        else begin
            out_valid <= 1'd0 ;
        end
    end
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        out <= 1'd0 ;
    end
    else begin
        if (Current_state == Right || Current_state == Down || Current_state == Left || Current_state == Up)
        begin
            case(Current_state)
            Right: out <= 2'd0 ;
            Down: out <= 2'd1 ;
            Left: out <= 2'd2 ;
            Up: out <= 2'd3 ;
            default: out <= 2'd0 ;
            endcase
        end
        else begin
            out <= 2'd0 ;
        end
    end
end


endmodule