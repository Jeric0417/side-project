//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   2021 ICC Geofence
//   Design         : Geofence
//   Author         : CHAN-HAO LIAO (jericc880417@gmail.com)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   File Name   : geofence.v
//   Module Name : geofence
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

//synopsys translate_off
`include "/home/lab911_1/Desktop/7112064131/ICC/2021/DW_sqrt.v"
//synopsys translate_on
module geofence(clk,reset,X,Y,R,valid,is_inside);
input clk;
input reset;
input [9:0] X;
input [9:0] Y;
input [10:0] R;
output  valid;
output  is_inside;
//============================================================================
/////////////////////////////////////////////////////
//  Register 、 Parameter
/////////////////////////////////////////////////////
reg [2:0] Current_state, Next_state;
reg [3:0] Counter_read;
reg [4:0] Counter_area;

reg [9:0]  read_point_x   [0:5];
reg [9:0]  read_point_y   [0:5];
reg [10:0] read_point_r   [0:5];

wire [20:0] c_0                ;
wire [10:0] c_c                ;
reg  [10:0] c [0:5]            ;
reg  [10:0] s [0:5]            ;

reg signed [10:0] D,E          ;
reg        [19:0] E_E,F_F      ;
wire       [22:0] D_D          ;
reg        [9:0 ] I_I          ;
reg        [10:0] G_G,L_L,K_K  ;
wire       [20:0] H_H,J_J,Q    ;
reg        [9:0]  d_1,d_2,e_1,e_2,f_1,f_2,g_1,g_2;
reg signed [22:0] area_c;
reg signed [22:0] area_d;

reg [20:0] triangle_A; 
reg [20:0] triangle_B;
reg [10:0] a;
reg [10:0] b;
reg [19:0] trianlge_d [0:5]    ;
reg [19:0] trianlge_e [0:5]    ;

reg signed [22:0] area [0:5]         ;
reg signed [22:0] triangle_area [0:5];

parameter Read_data             = 3'd0;
parameter Cal_area              = 3'd1;
parameter Decide_order          = 3'd2;
parameter Data_out              = 3'd3;

integer i;

/////////////////////////////////////////////////////
//  State change
/////////////////////////////////////////////////////
always @(posedge clk or posedge reset) 
begin
    if (reset) 
        Current_state <= Read_data;
    else 
        Current_state <= Next_state;
end

always @(*)
begin
    case(Current_state)
    Read_data: Next_state = (Counter_read == 4'd6)? Cal_area : Read_data;
    Cal_area: Next_state = (Counter_area == 5'd15)? Decide_order : Cal_area;
    Decide_order: Next_state = Data_out;
    Data_out: Next_state = Read_data;
    default: Next_state = Current_state;
    endcase
end

/////////////////////////////////////////////////////
//  Counter_read data and area
/////////////////////////////////////////////////////
always @(posedge clk or posedge reset) 
begin
    if (reset) 
        Counter_read <= 4'd0;
    else
        Counter_read <= (Current_state == Read_data)? Counter_read+1 : 4'd0;
end

always @(posedge clk or posedge reset) 
begin
    if (reset) 
        Counter_area <= 5'd0;
    else
        Counter_area <= (Current_state == Cal_area)? Counter_area+1 : 5'd0;
end

/////////////////////////////////////////////////////
//  Store Fix point and Sort point
/////////////////////////////////////////////////////
always @(posedge clk or posedge reset) 
begin
    if (reset)
    begin
        for (i=0; i<=6; i=i+1)
        begin
            read_point_x[i] <= 10'd0;
        end
    end 
    else begin
        if (Current_state == Data_out)
        begin
            for (i=0; i<=6; i=i+1)
            begin
                read_point_x[i] <= 10'd0;
            end
        end
        else if (Current_state == Read_data)
        begin
            case (Counter_read)
            4'd0: read_point_x[0] <= X;
            4'd1:
            begin
                if (read_point_y[0] < Y)
                begin
                    read_point_x[0] <= X;
                    read_point_x[1] <= read_point_x[0];
                end
                else 
                    read_point_x[1] <= X;
            end
            4'd2:
            begin
                if (read_point_y[0] < Y)
                begin
                    read_point_x[0] <= X;
                    read_point_x[1] <= read_point_x[0];
                    read_point_x[2] <= read_point_x[1];
                end
                else if (read_point_y[1] < Y)
                begin
                    read_point_x[1] <= X;
                    read_point_x[2] <= read_point_x[1];
                end
                else
                    read_point_x[2] <= X;
            end
            4'd3:
            begin
                if (read_point_y[0] < Y)
                begin
                    read_point_x[0] <= X;
                    read_point_x[1] <= read_point_x[0];
                    read_point_x[2] <= read_point_x[1];
                    read_point_x[3] <= read_point_x[2];
                end
                else if (read_point_y[1] < Y)
                begin
                    read_point_x[1] <= X;
                    read_point_x[2] <= read_point_x[1];
                    read_point_x[3] <= read_point_x[2];
                end
                else if (read_point_y[2] < Y)
                begin
                    read_point_x[2] <= X;
                    read_point_x[3] <= read_point_x[2];
                end
                else
                    read_point_x[3] <= X;
            end
            4'd4:
            begin
                if (read_point_y[0] < Y)
                begin
                    read_point_x[0] <= X;
                    read_point_x[1] <= read_point_x[0];
                    read_point_x[2] <= read_point_x[1];
                    read_point_x[3] <= read_point_x[2];
                    read_point_x[4] <= read_point_x[3];
                end
                else if (read_point_y[1] < Y)
                begin
                    read_point_x[1] <= X;
                    read_point_x[2] <= read_point_x[1];
                    read_point_x[3] <= read_point_x[2];
                    read_point_x[4] <= read_point_x[3];
                end
                else if (read_point_y[2] < Y)
                begin
                    read_point_x[2] <= X;
                    read_point_x[3] <= read_point_x[2];
                    read_point_x[4] <= read_point_x[3];
                end
                else if (read_point_y[3] < Y)
                begin
                    read_point_x[3] <= X;
                    read_point_x[4] <= read_point_x[3];
                end
                else
                    read_point_x[4] <= X;
            end
            4'd5:
            begin
                if (read_point_y[0] < Y)
                begin
                    read_point_x[0] <= X;
                    read_point_x[1] <= read_point_x[0];
                    read_point_x[2] <= read_point_x[1];
                    read_point_x[3] <= read_point_x[2];
                    read_point_x[4] <= read_point_x[3];
                    read_point_x[5] <= read_point_x[4];
                end
                else if (read_point_y[1] < Y)
                begin
                    read_point_x[1] <= X;
                    read_point_x[2] <= read_point_x[1];
                    read_point_x[3] <= read_point_x[2];
                    read_point_x[4] <= read_point_x[3];
                    read_point_x[5] <= read_point_x[4];
                end
                else if (read_point_y[2] < Y)
                begin
                    read_point_x[2] <= X;
                    read_point_x[3] <= read_point_x[2];
                    read_point_x[4] <= read_point_x[3];
                    read_point_x[5] <= read_point_x[4];
                end
                else if (read_point_y[3] < Y)
                begin
                    read_point_x[3] <= X;
                    read_point_x[4] <= read_point_x[3];
                    read_point_x[5] <= read_point_x[4];
                end
                else if (read_point_y[4] < Y)
                begin
                    read_point_x[4] <= X;
                    read_point_x[5] <= read_point_x[4];
                end
                else
                    read_point_x[5] <= X;
            end
            4'd6:
            begin
                if (read_point_x[0] < read_point_x[1])
                begin
                    if (read_point_x[1] < read_point_x[2])
                    begin
                        if (read_point_x[2] < read_point_x[3])
                        begin
                            read_point_x[5] <= read_point_x[1];
                            read_point_x[4] <= read_point_x[2];
                            read_point_x[2] <= read_point_x[5];
                            read_point_x[1] <= read_point_x[4];
                        end
                        else begin
                            read_point_x[5] <= read_point_x[1];
                            read_point_x[4] <= read_point_x[2];
                            read_point_x[3] <= read_point_x[5];
                            read_point_x[2] <= read_point_x[4];
                            read_point_x[1] <= read_point_x[3];
                        end
                    end
                    else begin
                        if (read_point_y[4] == read_point_y[5] && read_point_x[4] > read_point_x[5])
                        begin
                            read_point_x[5] <= read_point_x[1];
                            read_point_x[4] <= read_point_x[3];
                            read_point_x[1] <= read_point_x[2];
                            read_point_x[3] <= read_point_x[4];
                            read_point_x[2] <= read_point_x[5];
                        end
                        else if (read_point_x[4] > read_point_x[5])
                        begin
                            read_point_x[5] <= read_point_x[1];
                            read_point_x[1] <= read_point_x[2];
                            read_point_x[2] <= read_point_x[3];
                            read_point_x[3] <= read_point_x[5];
                        end
                        else begin
                            read_point_x[5] <= read_point_x[1];
                            read_point_x[4] <= read_point_x[3];
                            read_point_x[1] <= read_point_x[2];
                            read_point_x[2] <= read_point_x[4];
                            read_point_x[3] <= read_point_x[5];
                        end
                    end
                end
                else begin
                    if (read_point_x[2] > read_point_x[3] &&  read_point_x[3] > read_point_x[4])
                    begin
                        read_point_x[5] <= read_point_x[2];
                        read_point_x[3] <= read_point_x[5];
                        read_point_x[2] <= read_point_x[4];
                        read_point_x[4] <= read_point_x[3];
                    end
                    else if (read_point_x[2] > read_point_x[3])
                    begin
                        read_point_x[2] <= read_point_x[3];
                        read_point_x[5] <= read_point_x[2];
                        read_point_x[3] <= read_point_x[5];
                    end
                    else if (read_point_y[4] == read_point_y[5] && read_point_x[4] > read_point_x[5])
                    begin
                        read_point_x[5] <= read_point_x[2];
                        read_point_x[4] <= read_point_x[3];
                        read_point_x[2] <= read_point_x[5];
                        read_point_x[3] <= read_point_x[4];
                    end
                    else begin
                        read_point_x[5] <= read_point_x[2];
                        read_point_x[4] <= read_point_x[3];
                        read_point_x[3] <= read_point_x[5];
                        read_point_x[2] <= read_point_x[4];
                    end
                end
            end
            endcase
        end        
    end
end

always @(posedge clk or posedge reset) 
begin
    if (reset)
    begin
        for (i=0; i<=6; i=i+1)
        begin
            read_point_y[i] <= 10'd0;
        end
    end 
    else begin
        if (Current_state == Data_out)
        begin
            for (i=0; i<=6; i=i+1)
            begin
                read_point_y[i] <= 10'd0;
            end
        end
        else if (Current_state == Read_data)
        begin
            case (Counter_read)
            4'd0: read_point_y[0] <= Y;
            4'd1:
            begin
                if (read_point_y[0] < Y)
                begin
                    read_point_y[0] <= Y;
                    read_point_y[1] <= read_point_y[0];
                end
                else 
                    read_point_y[1] <= Y;
            end
            4'd2:
            begin
                if (read_point_y[0] < Y)
                begin
                    read_point_y[0] <= Y;
                    read_point_y[1] <= read_point_y[0];
                    read_point_y[2] <= read_point_y[1];
                end
                else if (read_point_y[1] < Y)
                begin
                    read_point_y[1] <= Y;
                    read_point_y[2] <= read_point_y[1];
                end
                else
                    read_point_y[2] <= Y;
            end
            4'd3:
            begin
                if (read_point_y[0] < Y)
                begin
                    read_point_y[0] <= Y;
                    read_point_y[1] <= read_point_y[0];
                    read_point_y[2] <= read_point_y[1];
                    read_point_y[3] <= read_point_y[2];
                end
                else if (read_point_y[1] < Y)
                begin
                    read_point_y[1] <= Y;
                    read_point_y[2] <= read_point_y[1];
                    read_point_y[3] <= read_point_y[2];
                end
                else if (read_point_y[2] < Y)
                begin
                    read_point_y[2] <= Y;
                    read_point_y[3] <= read_point_y[2];
                end
                else
                    read_point_y[3] <= Y;
            end
            4'd4:
            begin
                if (read_point_y[0] < Y)
                begin
                    read_point_y[0] <= Y;
                    read_point_y[1] <= read_point_y[0];
                    read_point_y[2] <= read_point_y[1];
                    read_point_y[3] <= read_point_y[2];
                    read_point_y[4] <= read_point_y[3];
                end
                else if (read_point_y[1] < Y)
                begin
                    read_point_y[1] <= Y;
                    read_point_y[2] <= read_point_y[1];
                    read_point_y[3] <= read_point_y[2];
                    read_point_y[4] <= read_point_y[3];
                end
                else if (read_point_y[2] < Y)
                begin
                    read_point_y[2] <= Y;
                    read_point_y[3] <= read_point_y[2];
                    read_point_y[4] <= read_point_y[3];
                end
                else if (read_point_y[3] < Y)
                begin
                    read_point_y[3] <= Y;
                    read_point_y[4] <= read_point_y[3];
                end
                else
                    read_point_y[4] <= Y;
            end
            4'd5:
            begin
                if (read_point_y[0] < Y)
                begin
                    read_point_y[0] <= Y;
                    read_point_y[1] <= read_point_y[0];
                    read_point_y[2] <= read_point_y[1];
                    read_point_y[3] <= read_point_y[2];
                    read_point_y[4] <= read_point_y[3];
                    read_point_y[5] <= read_point_y[4];
                end
                else if (read_point_y[1] < Y)
                begin
                    read_point_y[1] <= Y;
                    read_point_y[2] <= read_point_y[1];
                    read_point_y[3] <= read_point_y[2];
                    read_point_y[4] <= read_point_y[3];
                    read_point_y[5] <= read_point_y[4];
                end
                else if (read_point_y[2] < Y)
                begin
                    read_point_y[2] <= Y;
                    read_point_y[3] <= read_point_y[2];
                    read_point_y[4] <= read_point_y[3];
                    read_point_y[5] <= read_point_y[4];
                end
                else if (read_point_y[3] < Y)
                begin
                    read_point_y[3] <= Y;
                    read_point_y[4] <= read_point_y[3];
                    read_point_y[5] <= read_point_y[4];
                end
                else if (read_point_y[4] < Y)
                begin
                    read_point_y[4] <= Y;
                    read_point_y[5] <= read_point_y[4];
                end
                else
                    read_point_y[5] <= Y;
            end
            4'd6:
            begin
                if (read_point_x[0] < read_point_x[1])
                begin
                    if (read_point_x[1] < read_point_x[2])
                    begin
                        if (read_point_x[2] < read_point_x[3])
                        begin
                            read_point_y[5] <= read_point_y[1];
                            read_point_y[4] <= read_point_y[2];
                            read_point_y[2] <= read_point_y[5];
                            read_point_y[1] <= read_point_y[4];
                        end
                        else begin
                            read_point_y[5] <= read_point_y[1];
                            read_point_y[4] <= read_point_y[2];
                            read_point_y[3] <= read_point_y[5];
                            read_point_y[2] <= read_point_y[4];
                            read_point_y[1] <= read_point_y[3];
                        end
                    end
                    else begin
                        if (read_point_y[4] == read_point_y[5] && read_point_x[4] > read_point_x[5])
                        begin
                            read_point_y[5] <= read_point_y[1];
                            read_point_y[4] <= read_point_y[3];
                            read_point_y[1] <= read_point_y[2];
                            read_point_y[3] <= read_point_y[4];
                            read_point_y[2] <= read_point_y[5];
                        end
                        else if (read_point_x[4] > read_point_x[5])
                        begin
                            read_point_y[5] <= read_point_y[1];
                            read_point_y[1] <= read_point_y[2];
                            read_point_y[2] <= read_point_y[3];
                            read_point_y[3] <= read_point_y[5];
                        end
                        else begin
                            read_point_y[5] <= read_point_y[1];
                            read_point_y[4] <= read_point_y[3];
                            read_point_y[1] <= read_point_y[2];
                            read_point_y[2] <= read_point_y[4];
                            read_point_y[3] <= read_point_y[5];
                        end
                    end
                end
                else begin
                    if (read_point_x[2] > read_point_x[3] &&  read_point_x[3] > read_point_x[4])
                    begin
                        read_point_y[5] <= read_point_y[2];
                        read_point_y[3] <= read_point_y[5];
                        read_point_y[2] <= read_point_y[4];
                        read_point_y[4] <= read_point_y[3];
                    end
                    else if (read_point_x[2] > read_point_x[3])
                    begin
                        read_point_y[2] <= read_point_y[3];
                        read_point_y[5] <= read_point_y[2];
                        read_point_y[3] <= read_point_y[5];
                    end
                    else if (read_point_y[4] == read_point_y[5] && read_point_x[4] > read_point_x[5])
                    begin
                        read_point_y[5] <= read_point_y[2];
                        read_point_y[4] <= read_point_y[3];
                        read_point_y[2] <= read_point_y[5];
                        read_point_y[3] <= read_point_y[4];
                    end
                    else begin
                        read_point_y[5] <= read_point_y[2];
                        read_point_y[4] <= read_point_y[3];
                        read_point_y[3] <= read_point_y[5];
                        read_point_y[2] <= read_point_y[4];
                    end
                end
            end
            endcase
        end        
    end
end

always @(posedge clk or posedge reset) 
begin
    if (reset)
    begin
        for (i=0; i<=6; i=i+1)
        begin
            read_point_r[i] <= 10'd0;
        end
    end 
    else begin
        if (Current_state == Data_out)
        begin
            for (i=0; i<=6; i=i+1)
            begin
                read_point_r[i] <= 10'd0;
            end
        end
        else if (Current_state == Read_data)
        begin
            case (Counter_read)
            4'd0: read_point_r[0] <= R;
            4'd1:
            begin
                if (read_point_y[0] < Y)
                begin
                    read_point_r[0] <= R;
                    read_point_r[1] <= read_point_r[0];
                end
                else 
                    read_point_r[1] <= R;
            end
            4'd2:
            begin
                if (read_point_y[0] < Y)
                begin
                    read_point_r[0] <= R;
                    read_point_r[1] <= read_point_r[0];
                    read_point_r[2] <= read_point_r[1];
                end
                else if (read_point_y[1] < Y)
                begin
                    read_point_r[1] <= R;
                    read_point_r[2] <= read_point_r[1];
                end
                else
                    read_point_r[2] <= R;
            end
            4'd3:
            begin
                if (read_point_y[0] < Y)
                begin
                    read_point_r[0] <= R;
                    read_point_r[1] <= read_point_r[0];
                    read_point_r[2] <= read_point_r[1];
                    read_point_r[3] <= read_point_r[2];
                end
                else if (read_point_y[1] < Y)
                begin
                    read_point_r[1] <= R;
                    read_point_r[2] <= read_point_r[1];
                    read_point_r[3] <= read_point_r[2];
                end
                else if (read_point_y[2] < Y)
                begin
                    read_point_r[2] <= R;
                    read_point_r[3] <= read_point_r[2];
                end
                else
                    read_point_r[3] <= R;
            end
            4'd4:
            begin
                if (read_point_y[0] < Y)
                begin
                    read_point_r[0] <= R;
                    read_point_r[1] <= read_point_r[0];
                    read_point_r[2] <= read_point_r[1];
                    read_point_r[3] <= read_point_r[2];
                    read_point_r[4] <= read_point_r[3];
                end
                else if (read_point_y[1] < Y)
                begin
                    read_point_r[1] <= R;
                    read_point_r[2] <= read_point_r[1];
                    read_point_r[3] <= read_point_r[2];
                    read_point_r[4] <= read_point_r[3];
                end
                else if (read_point_y[2] < Y)
                begin
                    read_point_r[2] <= R;
                    read_point_r[3] <= read_point_r[2];
                    read_point_r[4] <= read_point_r[3];
                end
                else if (read_point_y[3] < Y)
                begin
                    read_point_r[3] <= R;
                    read_point_r[4] <= read_point_r[3];
                end
                else
                    read_point_r[4] <= R;
            end
            4'd5:
            begin
                if (read_point_y[0] < Y)
                begin
                    read_point_r[0] <= R;
                    read_point_r[1] <= read_point_r[0];
                    read_point_r[2] <= read_point_r[1];
                    read_point_r[3] <= read_point_r[2];
                    read_point_r[4] <= read_point_r[3];
                    read_point_r[5] <= read_point_r[4];
                end
                else if (read_point_y[1] < Y)
                begin
                    read_point_r[1] <= R;
                    read_point_r[2] <= read_point_r[1];
                    read_point_r[3] <= read_point_r[2];
                    read_point_r[4] <= read_point_r[3];
                    read_point_r[5] <= read_point_r[4];
                end
                else if (read_point_y[2] < Y)
                begin
                    read_point_r[2] <= R;
                    read_point_r[3] <= read_point_r[2];
                    read_point_r[4] <= read_point_r[3];
                    read_point_r[5] <= read_point_r[4];
                end
                else if (read_point_y[3] < Y)
                begin
                    read_point_r[3] <= R;
                    read_point_r[4] <= read_point_r[3];
                    read_point_r[5] <= read_point_r[4];
                end
                else if (read_point_y[4] < Y)
                begin
                    read_point_r[4] <= R;
                    read_point_r[5] <= read_point_r[4];
                end
                else
                    read_point_r[5] <= R;
            end
            4'd6:
            begin
                if (read_point_x[0] < read_point_x[1])
                begin
                    if (read_point_x[1] < read_point_x[2])
                    begin
                        if (read_point_x[2] < read_point_x[3])
                        begin
                            read_point_r[5] <= read_point_r[1];
                            read_point_r[4] <= read_point_r[2];
                            read_point_r[2] <= read_point_r[5];
                            read_point_r[1] <= read_point_r[4];
                        end
                        else begin
                            read_point_r[5] <= read_point_r[1];
                            read_point_r[4] <= read_point_r[2];
                            read_point_r[3] <= read_point_r[5];
                            read_point_r[2] <= read_point_r[4];
                            read_point_r[1] <= read_point_r[3];
                        end
                    end
                    else begin
                        if (read_point_y[4] == read_point_y[5] && read_point_x[4] > read_point_x[5])
                        begin
                            read_point_r[5] <= read_point_r[1];
                            read_point_r[4] <= read_point_r[3];
                            read_point_r[1] <= read_point_r[2];
                            read_point_r[3] <= read_point_r[4];
                            read_point_r[2] <= read_point_r[5];
                        end
                        else if (read_point_x[4] > read_point_x[5])
                        begin
                            read_point_r[5] <= read_point_r[1];
                            read_point_r[1] <= read_point_r[2];
                            read_point_r[2] <= read_point_r[3];
                            read_point_r[3] <= read_point_r[5];
                        end
                        else begin
                            read_point_r[5] <= read_point_r[1];
                            read_point_r[4] <= read_point_r[3];
                            read_point_r[1] <= read_point_r[2];
                            read_point_r[2] <= read_point_r[4];
                            read_point_r[3] <= read_point_r[5];
                        end
                    end
                end
                else begin
                    if (read_point_x[2] > read_point_x[3] &&  read_point_x[3] > read_point_x[4])
                    begin
                        read_point_r[5] <= read_point_r[2];
                        read_point_r[3] <= read_point_r[5];
                        read_point_r[2] <= read_point_r[4];
                        read_point_r[4] <= read_point_r[3];
                    end
                    else if (read_point_x[2] > read_point_x[3])
                    begin
                        read_point_r[2] <= read_point_r[3];
                        read_point_r[5] <= read_point_r[2];
                        read_point_r[3] <= read_point_r[5];
                    end
                    else if (read_point_y[4] == read_point_y[5] && read_point_x[4] > read_point_x[5])
                    begin
                        read_point_r[5] <= read_point_r[2];
                        read_point_r[4] <= read_point_r[3];
                        read_point_r[2] <= read_point_r[5];
                        read_point_r[3] <= read_point_r[4];
                    end
                    else begin
                        read_point_r[5] <= read_point_r[2];
                        read_point_r[4] <= read_point_r[3];
                        read_point_r[3] <= read_point_r[5];
                        read_point_r[2] <= read_point_r[4];
                    end
                end
            end
            endcase
        end        
    end
end

/////////////////////////////////////////////////////
//  Calculate C
/////////////////////////////////////////////////////
always @(*) 
begin
    D = 10'd0;         
    if (Current_state == Cal_area && Counter_area == 5'd0)
        D = read_point_x[0]-read_point_x[1];
    else if (Current_state == Cal_area && Counter_area == 5'd1)
        D = read_point_x[1]-read_point_x[2];
    else if (Current_state == Cal_area && Counter_area == 5'd2)
        D = read_point_x[2]-read_point_x[3];
    else if (Current_state == Cal_area && Counter_area == 5'd3)
        D = read_point_x[3]-read_point_x[4];
    else if (Current_state == Cal_area && Counter_area == 5'd4)
        D = read_point_x[4]-read_point_x[5];
    else if (Current_state == Cal_area && Counter_area == 5'd5)
        D = read_point_x[5]-read_point_x[0];
    else
        D = 10'd0;
end
always @(*) 
begin
    E = 10'd0;         
    if (Current_state == Cal_area && Counter_area == 5'd0)
        E = read_point_y[0]-read_point_y[1];
    else if (Current_state == Cal_area && Counter_area == 5'd1)
        E = read_point_y[1]-read_point_y[2];
    else if (Current_state == Cal_area && Counter_area == 5'd2)
        E = read_point_y[2]-read_point_y[3];
    else if (Current_state == Cal_area && Counter_area == 5'd3)
        E = read_point_y[3]-read_point_y[4];
    else if (Current_state == Cal_area && Counter_area == 5'd4)
        E = read_point_y[4]-read_point_y[5];
    else if (Current_state == Cal_area && Counter_area == 5'd5)
        E = read_point_y[5]-read_point_y[0];
    else
        E = 10'd0;
end

assign c_0 = (D*D)+(E*E);

DW_sqrt #(21, 1'd0) U1(.a(c_0), .root(c_c));

/////////////////////////////////////////////////////
//  Store S  and c
/////////////////////////////////////////////////////
always @(posedge clk or posedge reset) 
begin
    if (reset) 
    begin
        for (i=0; i<6; i=i+1)
        begin
            c[i] <= 10'd0;        
        end    
    end
    else begin
        if(Current_state == Cal_area)
        begin
            case(Counter_area)
            5'd0: c[0] <= c_c;
            5'd1: c[1] <= c_c;
            5'd2: c[2] <= c_c;
            5'd3: c[3] <= c_c;
            5'd4: c[4] <= c_c;
            5'd5: c[5] <= c_c;
            default: c[0] <= c[0];
            endcase
        end
    end
end

always @(posedge clk or posedge reset) 
begin
    if (reset) 
    begin
        for (i=0; i<6; i=i+1)
        begin
            s[i] <= 10'd0;        
        end    
    end
    else begin
        if(Current_state == Cal_area)
        begin
            case(Counter_area)
            5'd6   : s[0] <= (read_point_r[0]+read_point_r[1]+c[0])>>1;
            5'd7   : s[1] <= (read_point_r[1]+read_point_r[2]+c[1])>>1;
            5'd8   : s[2] <= (read_point_r[2]+read_point_r[3]+c[2])>>1;
            5'd9   : s[3] <= (read_point_r[3]+read_point_r[4]+c[3])>>1;
            5'd10  : s[4] <= (read_point_r[4]+read_point_r[5]+c[4])>>1;
            5'd11  : s[5] <= (read_point_r[5]+read_point_r[0]+c[5])>>1;
            default: s[0] <= s[0];
            endcase
        end
    end
end

/////////////////////////////////////////////////////
//  Calculate Triangle area
/////////////////////////////////////////////////////

always @(*) 
begin
    case(Counter_area)
    5'd7 : G_G = s[0];
    5'd8 : G_G = s[1];
    5'd9 : G_G = s[2];
    5'd10: G_G = s[3];
    5'd11: G_G = s[4];
    5'd12: G_G = s[5];
    endcase
end
always @(*) 
begin
    case(Counter_area)
    5'd7 : I_I = read_point_r[0];
    5'd8 : I_I = read_point_r[1];
    5'd9 : I_I = read_point_r[2];
    5'd10: I_I = read_point_r[3];
    5'd11: I_I = read_point_r[4];
    5'd12: I_I = read_point_r[5];
    endcase
end
assign H_H = G_G*G_G;
assign J_J = G_G*I_I;

always @(posedge clk or posedge reset) 
begin
    if (reset) 
    begin
        triangle_A <= 21'd0;   
    end
    else begin
        if (Current_state == Data_out)
            triangle_A <= 21'd0;
        else if(Current_state == Cal_area)
        begin
            case (Counter_area)
            5'd7 : triangle_A <= H_H-J_J;
            5'd8 : triangle_A <= H_H-J_J;
            5'd9 : triangle_A <= H_H-J_J;
            5'd10: triangle_A <= H_H-J_J;
            5'd11: triangle_A <= H_H-J_J;
            5'd12: triangle_A <= H_H-J_J;
            endcase
        end
    end
end

always @(*) 
begin
    case(Counter_area)
    5'd7 : K_K = read_point_r[1];
    5'd8 : K_K = read_point_r[2];
    5'd9 : K_K = read_point_r[3];
    5'd10: K_K = read_point_r[4];
    5'd11: K_K = read_point_r[5];
    5'd12: K_K = read_point_r[0];
    endcase
end
always @(*) 
begin
    case(Counter_area)
    5'd7 : L_L = c[0];
    5'd8 : L_L = c[1];
    5'd9 : L_L = c[2];
    5'd10: L_L = c[3];
    5'd11: L_L = c[4];
    5'd12: L_L = c[5];
    endcase
end
assign Q = (G_G-K_K)*(G_G-L_L);

always @(posedge clk or posedge reset) 
begin
    if (reset) 
    begin
        triangle_B <= 21'd0;   
    end
    else begin
        if (Current_state == Data_out)
            triangle_B <= 21'd0;
        else if(Current_state == Cal_area)
        begin
            case (Counter_area)
            5'd7 : triangle_B <= Q;
            5'd8 : triangle_B <= Q;
            5'd9 : triangle_B <= Q;
            5'd10: triangle_B <= Q;
            5'd11: triangle_B <= Q;
            5'd12: triangle_B <= Q;
            endcase
        end
    end
end

DW_sqrt #(21, 1'd0) U2(.a(triangle_A), .root(a));
DW_sqrt #(21, 1'd0) U3(.a(triangle_B), .root(b));

always @(posedge clk or posedge reset) 
begin
    if (reset) 
    begin
        for (i=0; i<6; i=i+1)
        begin
            trianlge_d[i] <= 11'd0;        
        end    
    end
    else begin
        if (Current_state == Data_out)
        for (i=0; i<6; i=i+1)
        begin
            trianlge_d[i] <= 11'd0;        
        end
        else if (Current_state == Cal_area)
        begin
            case(Counter_area)
            5'd8 : trianlge_d[0] <= a;
            5'd9 : trianlge_d[1] <= a;
            5'd10: trianlge_d[2] <= a;
            5'd11: trianlge_d[3] <= a;
            5'd12: trianlge_d[4] <= a;
            5'd13: trianlge_d[5] <= a;
            endcase
        end
    end
end

always @(posedge clk or posedge reset) 
begin
    if (reset) 
    begin
        for (i=0; i<6; i=i+1)
        begin
            trianlge_e[i] <= 11'd0;        
        end    
    end
    else begin
        if (Current_state == Data_out)
        for (i=0; i<6; i=i+1)
        begin
            trianlge_e[i] <= 11'd0;        
        end
        else if (Current_state == Cal_area)
        begin
            case(Counter_area)
            5'd8 : trianlge_e[0] <= b;
            5'd9 : trianlge_e[1] <= b;
            5'd10: trianlge_e[2] <= b;
            5'd11: trianlge_e[3] <= b;
            5'd12: trianlge_e[4] <= b;
            5'd13: trianlge_e[5] <= b;
            endcase
        end
    end
end

always @(*) 
begin
    case(Counter_area)
    5'd9 : E_E = trianlge_d[0];
    5'd10: E_E = trianlge_d[1];
    5'd11: E_E = trianlge_d[2];
    5'd12: E_E = trianlge_d[3];
    5'd13: E_E = trianlge_d[4];
    5'd14: E_E = trianlge_d[5];
    endcase
end
always @(*) 
begin
    case(Counter_area)
    5'd9 : F_F = trianlge_e[0];
    5'd10: F_F = trianlge_e[1];
    5'd11: F_F = trianlge_e[2];
    5'd12: F_F = trianlge_e[3];
    5'd13: F_F = trianlge_e[4];
    5'd14: F_F = trianlge_e[5];
    endcase
end

assign D_D = E_E*F_F;

always @(posedge clk or posedge reset) 
begin
    if (reset) 
    begin
        for (i=0; i<6; i=i+1)
        begin
            triangle_area[i] <= 23'd0;        
        end    
    end
    else begin
        if (Current_state == Cal_area)
        begin
            case (Counter_area)
            5'd9 : triangle_area[0] <= D_D;
            5'd10: triangle_area[1] <= D_D;
            5'd11: triangle_area[2] <= D_D;
            5'd12: triangle_area[3] <= D_D;
            5'd13: triangle_area[4] <= D_D;
            5'd14: triangle_area[5] <= D_D;
            5'd15: triangle_area[0] <= triangle_area[0]+triangle_area[1]+triangle_area[2]+triangle_area[3]+triangle_area[4]+triangle_area[5];
            endcase
        end
    end
end

/////////////////////////////////////////////////////
//  Calculate Triangle area
/////////////////////////////////////////////////////
always @(*) 
begin
    area_c = d_1*e_1 - f_1*g_1;
    area_d = d_2*e_2 - f_2*g_2;
end

always @(*) 
begin
    case(Counter_area)
    5'd0: d_1 = read_point_x[0];
    5'd1: d_1 = read_point_x[2];
    5'd2: d_1 = read_point_x[4];
    endcase
end
always @(*) 
begin
    case(Counter_area)
    5'd0: d_2 = read_point_x[1];
    5'd1: d_2 = read_point_x[3];
    5'd2: d_2 = read_point_x[5];
    endcase
end
always @(*) 
begin
    case(Counter_area)
    5'd0: e_1 = read_point_y[1];
    5'd1: e_1 = read_point_y[3];
    5'd2: e_1 = read_point_y[5];
    endcase
end
always @(*) 
begin
    case(Counter_area)
    5'd0: e_2 = read_point_y[2];
    5'd1: e_2 = read_point_y[4];
    5'd2: e_2 = read_point_y[0];
    endcase
end
always @(*) 
begin
    case(Counter_area)
    5'd0: f_1 = read_point_x[1];
    5'd1: f_1 = read_point_x[3];
    5'd2: f_1 = read_point_x[5];
    endcase
end
always @(*) 
begin
    case(Counter_area)
    5'd0: f_2 = read_point_x[2];
    5'd1: f_2 = read_point_x[4];
    5'd2: f_2 = read_point_x[0];
    endcase
end
always @(*) 
begin
    case(Counter_area)
    5'd0: g_1 = read_point_y[0];
    5'd1: g_1 = read_point_y[2];
    5'd2: g_1 = read_point_y[4];
    endcase
end
always @(*) 
begin
    case(Counter_area)
    5'd0: g_2 = read_point_y[1];
    5'd1: g_2 = read_point_y[3];
    5'd2: g_2 = read_point_y[5];
    endcase
end

always @(posedge clk or posedge reset) 
begin
    if (reset) 
    begin
        for (i=0; i<6; i=i+1)
        begin
            area[i] <= 23'd0;        
        end    
    end
    else begin
        if (Current_state == Cal_area)
        begin
            case (Counter_area)
            5'd0:
            begin
                area[0] <= area_c;
                area[1] <= area_d;
            end
            5'd1:
            begin
                area[2] <= area_c;
                area[3] <= area_d;
            end
            5'd2:
            begin
                area[4] <= area_c;
                area[5] <= area_d;
            end
            5'd3:
            begin
                area[0] <= (area[0]+area[1]+area[2]+area[3]+area[4]+area[5])>>1;
            end
            endcase
        end
    end
end

/////////////////////////////////////////////////////
//  Temp output
/////////////////////////////////////////////////////
assign valid = (Current_state == Data_out)? 1'd1 : 1'd0;
assign is_inside = (Current_state == Data_out)? ((area[0] > triangle_area[0])? 1'd1 : 1'd0) : 1'd0;

endmodule