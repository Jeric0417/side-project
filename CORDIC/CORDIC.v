//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   2024 DSP 
//   HW04        : CORDIC
//   Author      : CHAN-HAO LIAO (jericc880417@gmail.com)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   File Name   : cordic.v
//   Module Name : CORDIC
//   Release version : v2.0
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module CORDIC
(
    clk,
    rst_n,
    in_valid,
    matrix_0,
    matrix_1,
    matrix_2,
    matrix_3,
    out_valid,
    out_matrix
);

parameter matrix_integer = 8 ;
parameter decimal_point  = 3 ;

input clk, rst_n, in_valid ;
input  [matrix_integer-1:0] matrix_0, matrix_1, matrix_2, matrix_3 ; 

output out_valid ;
output reg [matrix_integer+decimal_point:0] out_matrix ;

////////////////////////////////////////////////////////

reg [2:0] Counter_store_data ;
reg [1:0] Counter_Iteratin   ;
reg [1:0] Counter_out_data   ;
reg [2:0] Counter_change     ;
reg [4:0] Counter_over_data  ;
reg [4:0] Iteration_number   ;

reg signed [matrix_integer+15:0] Result_R_1 [0:3]   ;
reg signed [matrix_integer+15:0] Result_R_2 [0:3]   ;
reg signed [matrix_integer+15:0] Result_R_3 [0:3]   ;
reg signed [matrix_integer+15:0] Result_R_4 [0:3]   ;
reg signed [matrix_integer+15:0] Result_R_5 [0:3]   ;
reg signed [matrix_integer+15:0] Result_R_6 [0:3]   ;
reg signed [matrix_integer+15:0] Result_R_7 [0:3]   ;
reg signed [matrix_integer+15:0] Result_R_8 [0:3]   ;

reg signed [matrix_integer+11:0] test        ;
reg signed [matrix_integer+15:0] R_1 [0:3]   ;
reg signed [matrix_integer+15:0] R_2 [0:3]   ;
reg signed [matrix_integer+15:0] R_3 [0:3]   ;
reg signed [matrix_integer+15:0] R_4 [0:3]   ;
reg signed [matrix_integer+15:0] R_5 [0:3]   ;
reg signed [matrix_integer+15:0] R_6 [0:3]   ;
reg signed [matrix_integer+15:0] R_7 [0:3]   ;
reg signed [matrix_integer+15:0] R_8 [0:3]   ;

reg signed [matrix_integer+15:0] N_R_1 [0:11][0:3];
reg signed [matrix_integer+15:0] N_R_2 [0:11][0:3];
reg signed [matrix_integer+15:0] N_R_3 [0:11][0:3];
reg signed [matrix_integer+15:0] N_R_4 [0:11][0:3];
reg signed [matrix_integer+15:0] N_R_5 [0:11][0:3];
reg signed [matrix_integer+15:0] N_R_6 [0:11][0:3];
reg signed [matrix_integer+15:0] N_R_7 [0:11][0:3];
reg signed [matrix_integer+15:0] N_R_8 [0:11][0:3];

reg [2:0] Current_state, Next_state ;

parameter IDLE           = 3'd0  ;
parameter Read           = 3'd1  ;
parameter QR             = 3'd2  ;
parameter R_give         = 3'd3  ;
parameter Out_data       = 3'd4  ;
parameter Reset          = 3'd5  ;

integer i ;

////////////////////////////////////////////////////////
// State change
////////////////////////////////////////////////////////

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
    IDLE: Next_state = Read ;
    Read: Next_state = (Counter_store_data == 3'd7)? QR : Read ;
    QR :
    begin 
        if (Iteration_number == 5'd30)
        Next_state = Out_data ;
        else if (Counter_Iteratin ==2'd3 && (Iteration_number == 5'd6 || Iteration_number == 5'd12 || Iteration_number == 5'd17 || Iteration_number == 5'd21))
        Next_state = R_give ;
        else
        Next_state = QR ;
    end
    R_give: Next_state = (Iteration_number == 5'd22)? Out_data : QR ;
    Out_data: Next_state = (Counter_over_data == 5'd31)? Reset : Out_data ;
    Reset: Next_state = IDLE ;
    default: Next_state = IDLE ;
    endcase
end

////////////////////////////////////////////////////////
// Counter to store_data
////////////////////////////////////////////////////////

always@ (posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        Counter_store_data <= 3'd0 ;
    end
    else begin
        if (in_valid)
        begin
            Counter_store_data <= Counter_store_data + 1'd1 ;
        end else begin
            Counter_store_data <= Counter_store_data ;
        end
    end
end

////////////////////////////////////////////////////////
// Iteration counter 
////////////////////////////////////////////////////////

always@ (posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        Counter_Iteratin <= 2'd0 ;
    end
    else begin
        if (Current_state == QR)
        begin
            Counter_Iteratin <= Counter_Iteratin + 1'd1 ;
        end 
        else begin
            Counter_Iteratin <= Counter_Iteratin ;
        end
    end
end

always@ (posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        Iteration_number <= 5'd0 ;
    end
    else begin
        if (Current_state == QR && Counter_Iteratin == 2'd3)
        begin
            Iteration_number <= Iteration_number + 1'd1 ;
        end 
    end
end

////////////////////////////////////////////////////////
// Counter to Output
////////////////////////////////////////////////////////

always@ (posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        Counter_out_data <= 2'd0 ;
    end
    else begin
        if (Current_state == Out_data)
        begin
            Counter_out_data <= Counter_out_data + 1'd1 ;
        end 
        else begin
            Counter_out_data <= Counter_out_data ;
        end
    end
end

always@ (posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        Counter_over_data <= 5'd0 ;
    end
    else begin
        if (Current_state == Out_data)
        begin
            Counter_over_data <= Counter_over_data + 1'd1 ;
        end 
        else begin
            Counter_over_data <= Counter_over_data ;
        end
    end
end

always@ (posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        Counter_change <= 3'd0 ;
    end
    else begin
        if (Counter_out_data == 2'd3)
        begin
            Counter_change <= Counter_change + 1'd1 ;
        end 
        else begin
            Counter_change <= Counter_change ;
        end
    end
end

////////////////////////////////////////////////////////
//  Final R
////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        for (i=0; i<4; i=i+1)
        begin
            Result_R_1[i] <= 24'd0 ;
        end   
    end
    else begin
        if (Current_state == R_give)
        begin
            Result_R_1[0] <= R_1[0] ;
            Result_R_1[1] <= R_1[1] ;
            Result_R_1[2] <= R_1[2] ;
            Result_R_1[3] <= R_1[3] ;
        end
    end
end

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        for (i=0; i<4; i=i+1)
        begin
            Result_R_2[i] <= 24'd0 ;
        end   
    end
    else begin
        if (Current_state == R_give)
        begin
            Result_R_2[0] <= 24'd0  ;
            Result_R_2[1] <= R_2[1] ;
            Result_R_2[2] <= R_2[2] ;
            Result_R_2[3] <= R_2[3] ;
        end
    end
end

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        for (i=0; i<4; i=i+1)
        begin
            Result_R_3[i] <= 24'd0 ;
        end   
    end
    else begin
        if (Current_state == R_give)
        begin
            Result_R_3[0] <= 24'd0  ;
            Result_R_3[1] <= 24'd0  ;
            Result_R_3[2] <= R_3[2] ;
            Result_R_3[3] <= R_3[3] ;
        end
    end
end

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        for (i=0; i<4; i=i+1)
        begin
            Result_R_4[i] <= 24'd0 ;
        end   
    end
    else begin
        if (Current_state == R_give)
        begin
            Result_R_4[0] <= 24'd0  ;
            Result_R_4[1] <= 24'd0  ;
            Result_R_4[2] <= 24'd0  ;
            Result_R_4[3] <= R_4[3] ;
        end
    end
end

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        for (i=0; i<4; i=i+1)
        begin
            Result_R_5[i] <= 24'd0 ;
        end   
    end
    else begin
        if (Current_state == R_give)
        begin
            Result_R_5[0] <= 24'd0  ;
            Result_R_5[1] <= 24'd0  ;
            Result_R_5[2] <= 24'd0  ;
            Result_R_5[3] <= 24'd0 ;
        end
    end
end

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        for (i=0; i<4; i=i+1)
        begin
            Result_R_6[i] <= 24'd0 ;
        end   
    end
    else begin
        if (Current_state == R_give)
        begin
            Result_R_6[0] <= 24'd0  ;
            Result_R_6[1] <= 24'd0  ;
            Result_R_6[2] <= 24'd0  ;
            Result_R_6[3] <= 24'd0 ;
        end
    end
end

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        for (i=0; i<4; i=i+1)
        begin
            Result_R_7[i] <= 24'd0 ;
        end   
    end
    else begin
        if (Current_state == R_give)
        begin
            Result_R_7[0] <= 24'd0  ;
            Result_R_7[1] <= 24'd0  ;
            Result_R_7[2] <= 24'd0  ;
            Result_R_7[3] <= 24'd0 ;
        end
    end
end

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        for (i=0; i<4; i=i+1)
        begin
            Result_R_8[i] <= 24'd0 ;
        end   
    end
    else begin
        if (Current_state == R_give)
        begin
            Result_R_8[0] <= 24'd0  ;
            Result_R_8[1] <= 24'd0  ;
            Result_R_8[2] <= 24'd0  ;
            Result_R_8[3] <= 24'd0 ;
        end
    end
end

////////////////////////////////////////////////////////
// Store Row data R1~R8 and Decomposition R
////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        for (i=0; i<4; i=i+1)
        begin
            R_1[i] <= 24'd0 ;
        end   
    end
    else if (Current_state == Read && Counter_store_data == 3'd0)
    begin
        R_1[0] <= matrix_0 <<12 ;
        R_1[1] <= matrix_1 <<12 ;
        R_1[2] <= matrix_2 <<12 ;
        R_1[3] <= matrix_3 <<12 ;    
    end
    else if (Current_state == QR && Counter_Iteratin == 2'd3 && Iteration_number == 5'd6)
    begin
        R_1[0] <= (N_R_1[11][0] >>>1) + (N_R_1[11][0] >>>4) + (N_R_1[11][0] >>>5) + (N_R_1[11][0] >>>7) + (N_R_1[11][0] >>>8) + (N_R_1[11][0] >>>10) + (N_R_1[11][0] >>>11) + (N_R_1[11][0] >>>12) + (N_R_1[11][0] >>>14)  ;
        R_1[1] <= (N_R_1[11][1] >>>1) + (N_R_1[11][1] >>>4) + (N_R_1[11][1] >>>5) + (N_R_1[11][1] >>>7) + (N_R_1[11][1] >>>8) + (N_R_1[11][1] >>>10) + (N_R_1[11][1] >>>11) + (N_R_1[11][1] >>>12) + (N_R_1[11][1] >>>14)  ;
        R_1[2] <= (N_R_1[11][2] >>>1) + (N_R_1[11][2] >>>4) + (N_R_1[11][2] >>>5) + (N_R_1[11][2] >>>7) + (N_R_1[11][2] >>>8) + (N_R_1[11][2] >>>10) + (N_R_1[11][2] >>>11) + (N_R_1[11][2] >>>12) + (N_R_1[11][2] >>>14)  ;
        R_1[3] <= (N_R_1[11][3] >>>1) + (N_R_1[11][3] >>>4) + (N_R_1[11][3] >>>5) + (N_R_1[11][3] >>>7) + (N_R_1[11][3] >>>8) + (N_R_1[11][3] >>>10) + (N_R_1[11][3] >>>11) + (N_R_1[11][3] >>>12) + (N_R_1[11][3] >>>14)  ;
    end
end

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        for (i=0; i<4; i=i+1)
        begin
            R_2[i] <= 24'd0 ;
        end   
    end
    else if (Current_state == Read && Counter_store_data == 3'd1)
    begin
        R_2[0] <= matrix_0 <<12 ;
        R_2[1] <= matrix_1 <<12 ;
        R_2[2] <= matrix_2 <<12 ;
        R_2[3] <= matrix_3 <<12 ;    
    end
    else if (Current_state == QR && Counter_Iteratin == 2'd3 && (Iteration_number == 5'd5 || Iteration_number == 5'd6 || Iteration_number == 5'd12))
    begin
        R_2[0] <= (N_R_2[11][0] >>>1) + (N_R_2[11][0] >>>4) + (N_R_2[11][0] >>>5) + (N_R_2[11][0] >>>7) + (N_R_2[11][0] >>>8) + (N_R_2[11][0] >>>10) + (N_R_2[11][0] >>>11) + (N_R_2[11][0] >>>12) + (N_R_2[11][0] >>>14)  ;
        R_2[1] <= (N_R_2[11][1] >>>1) + (N_R_2[11][1] >>>4) + (N_R_2[11][1] >>>5) + (N_R_2[11][1] >>>7) + (N_R_2[11][1] >>>8) + (N_R_2[11][1] >>>10) + (N_R_2[11][1] >>>11) + (N_R_2[11][1] >>>12) + (N_R_2[11][1] >>>14)  ;
        R_2[2] <= (N_R_2[11][2] >>>1) + (N_R_2[11][2] >>>4) + (N_R_2[11][2] >>>5) + (N_R_2[11][2] >>>7) + (N_R_2[11][2] >>>8) + (N_R_2[11][2] >>>10) + (N_R_2[11][2] >>>11) + (N_R_2[11][2] >>>12) + (N_R_2[11][2] >>>14)  ;
        R_2[3] <= (N_R_2[11][3] >>>1) + (N_R_2[11][3] >>>4) + (N_R_2[11][3] >>>5) + (N_R_2[11][3] >>>7) + (N_R_2[11][3] >>>8) + (N_R_2[11][3] >>>10) + (N_R_2[11][3] >>>11) + (N_R_2[11][3] >>>12) + (N_R_2[11][3] >>>14)  ;
    end
    else if (Current_state == R_give)
    begin
        R_2[0] <= R_2[1] ;
    end
end

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        for (i=0; i<4; i=i+1)
        begin
            R_3[i] <= 24'd0 ;
        end   
    end
    else if (Current_state == Read && Counter_store_data == 3'd2)
    begin
        R_3[0] <= matrix_0 <<12 ;
        R_3[1] <= matrix_1 <<12 ;
        R_3[2] <= matrix_2 <<12 ;
        R_3[3] <= matrix_3 <<12 ;    
    end
    else if (Current_state == QR && Counter_Iteratin == 2'd3 && (Iteration_number == 5'd4 || Iteration_number == 5'd5 || Iteration_number == 5'd11 || Iteration_number == 5'd12 || Iteration_number == 5'd17))
    begin
        R_3[0] <= (N_R_3[11][0] >>>1) + (N_R_3[11][0] >>>4) + (N_R_3[11][0] >>>5) + (N_R_3[11][0] >>>7) + (N_R_3[11][0] >>>8) + (N_R_3[11][0] >>>10) + (N_R_3[11][0] >>>11) + (N_R_3[11][0] >>>12) + (N_R_3[11][0] >>>14)  ;
        R_3[1] <= (N_R_3[11][1] >>>1) + (N_R_3[11][1] >>>4) + (N_R_3[11][1] >>>5) + (N_R_3[11][1] >>>7) + (N_R_3[11][1] >>>8) + (N_R_3[11][1] >>>10) + (N_R_3[11][1] >>>11) + (N_R_3[11][1] >>>12) + (N_R_3[11][1] >>>14)  ;
        R_3[2] <= (N_R_3[11][2] >>>1) + (N_R_3[11][2] >>>4) + (N_R_3[11][2] >>>5) + (N_R_3[11][2] >>>7) + (N_R_3[11][2] >>>8) + (N_R_3[11][2] >>>10) + (N_R_3[11][2] >>>11) + (N_R_3[11][2] >>>12) + (N_R_3[11][2] >>>14)  ;
        R_3[3] <= (N_R_3[11][3] >>>1) + (N_R_3[11][3] >>>4) + (N_R_3[11][3] >>>5) + (N_R_3[11][3] >>>7) + (N_R_3[11][3] >>>8) + (N_R_3[11][3] >>>10) + (N_R_3[11][3] >>>11) + (N_R_3[11][3] >>>12) + (N_R_3[11][3] >>>14)  ;
    end
    else if (Current_state == R_give && Iteration_number == 5'd13)
    begin
        R_3[0] <= R_3[2] ;
        R_3[1] <= R_3[2] ;
    end
    else if (Current_state == R_give)
    begin
        R_3[0] <= R_3[1] ;
    end
end

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        for (i=0; i<4; i=i+1)
        begin
            R_4[i] <= 24'd0 ;
        end   
    end
    else if (Current_state == Read && Counter_store_data == 3'd3)
    begin
        R_4[0] <= matrix_0 <<12;
        R_4[1] <= matrix_1 <<12;
        R_4[2] <= matrix_2 <<12;
        R_4[3] <= matrix_3 <<12;    
    end
    else if (Current_state == QR && Counter_Iteratin == 2'd3 && (Iteration_number == 5'd3 || Iteration_number == 5'd4 || Iteration_number == 5'd10 || Iteration_number == 5'd11 || Iteration_number == 5'd16 || Iteration_number == 5'd17 ||  Iteration_number == 5'd21))
    begin
        R_4[0] <= (N_R_4[11][0] >>>1) + (N_R_4[11][0] >>>4) + (N_R_4[11][0] >>>5) + (N_R_4[11][0] >>>7) + (N_R_4[11][0] >>>8) + (N_R_4[11][0] >>>10) + (N_R_4[11][0] >>>11) + (N_R_4[11][0] >>>12) + (N_R_4[11][0] >>>14)  ;
        R_4[1] <= (N_R_4[11][1] >>>1) + (N_R_4[11][1] >>>4) + (N_R_4[11][1] >>>5) + (N_R_4[11][1] >>>7) + (N_R_4[11][1] >>>8) + (N_R_4[11][1] >>>10) + (N_R_4[11][1] >>>11) + (N_R_4[11][1] >>>12) + (N_R_4[11][1] >>>14)  ;
        R_4[2] <= (N_R_4[11][2] >>>1) + (N_R_4[11][2] >>>4) + (N_R_4[11][2] >>>5) + (N_R_4[11][2] >>>7) + (N_R_4[11][2] >>>8) + (N_R_4[11][2] >>>10) + (N_R_4[11][2] >>>11) + (N_R_4[11][2] >>>12) + (N_R_4[11][2] >>>14)  ;
        R_4[3] <= (N_R_4[11][3] >>>1) + (N_R_4[11][3] >>>4) + (N_R_4[11][3] >>>5) + (N_R_4[11][3] >>>7) + (N_R_4[11][3] >>>8) + (N_R_4[11][3] >>>10) + (N_R_4[11][3] >>>11) + (N_R_4[11][3] >>>12) + (N_R_4[11][3] >>>14)  ;
    end
    else if (Current_state == R_give && Iteration_number == 5'd18)
    begin
        R_4[0] <= R_4[3] ;
        R_4[1] <= R_4[3] ;
        R_4[2] <= R_4[3] ;
    end
    else if (Current_state == R_give && Iteration_number == 5'd13)
    begin
        R_4[0] <= R_4[2] ;
        R_4[1] <= R_4[2] ;
    end
    else if (Current_state == R_give)
    begin
        R_4[0] <= R_4[1] ;
    end
end

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        for (i=0; i<4; i=i+1)
        begin
            R_5[i] <= 24'd0 ;
        end   
    end
    else if (Current_state == Read && Counter_store_data == 3'd4)
    begin
        R_5[0] <= matrix_0 <<12 ;
        R_5[1] <= matrix_1 <<12 ;
        R_5[2] <= matrix_2 <<12 ;
        R_5[3] <= matrix_3 <<12 ;    
    end
    else if (Current_state == QR && Counter_Iteratin == 2'd3 && (Iteration_number == 5'd2 || Iteration_number == 5'd3 || Iteration_number == 5'd9 || Iteration_number == 5'd10 || Iteration_number == 5'd15 || Iteration_number == 5'd16 || Iteration_number == 5'd20 || Iteration_number == 5'd21))
    begin
        R_5[0] <= (N_R_5[11][0] >>>1) + (N_R_5[11][0] >>>4) + (N_R_5[11][0] >>>5) + (N_R_5[11][0] >>>7) + (N_R_5[11][0] >>>8) + (N_R_5[11][0] >>>10) + (N_R_5[11][0] >>>11) + (N_R_5[11][0] >>>12) + (N_R_5[11][0] >>>14)  ;
        R_5[1] <= (N_R_5[11][1] >>>1) + (N_R_5[11][1] >>>4) + (N_R_5[11][1] >>>5) + (N_R_5[11][1] >>>7) + (N_R_5[11][1] >>>8) + (N_R_5[11][1] >>>10) + (N_R_5[11][1] >>>11) + (N_R_5[11][1] >>>12) + (N_R_5[11][1] >>>14)  ;
        R_5[2] <= (N_R_5[11][2] >>>1) + (N_R_5[11][2] >>>4) + (N_R_5[11][2] >>>5) + (N_R_5[11][2] >>>7) + (N_R_5[11][2] >>>8) + (N_R_5[11][2] >>>10) + (N_R_5[11][2] >>>11) + (N_R_5[11][2] >>>12) + (N_R_5[11][2] >>>14)  ;
        R_5[3] <= (N_R_5[11][3] >>>1) + (N_R_5[11][3] >>>4) + (N_R_5[11][3] >>>5) + (N_R_5[11][3] >>>7) + (N_R_5[11][3] >>>8) + (N_R_5[11][3] >>>10) + (N_R_5[11][3] >>>11) + (N_R_5[11][3] >>>12) + (N_R_5[11][3] >>>14)  ;
    end
    else if (Current_state == R_give && Iteration_number == 5'd18)
    begin
        R_5[0] <= R_5[3] ;
        R_5[1] <= R_5[3] ;
        R_5[2] <= R_5[3] ;
    end
    else if (Current_state == R_give && Iteration_number == 5'd13)
    begin
        R_5[0] <= R_5[2] ;
        R_5[1] <= R_5[2] ;
    end
    else if (Current_state == R_give)
    begin
        R_5[0] <= R_5[1] ;
    end
end

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        for (i=0; i<4; i=i+1)
        begin
            R_6[i] <= 24'd0 ;
        end   
    end
    else if (Current_state == Read && Counter_store_data == 3'd5)
    begin
        R_6[0] <= matrix_0 <<12 ;
        R_6[1] <= matrix_1 <<12 ;
        R_6[2] <= matrix_2 <<12 ;
        R_6[3] <= matrix_3 <<12 ;    
    end
    else if (Current_state == QR && Counter_Iteratin == 2'd3 && (Iteration_number == 5'd1 || Iteration_number == 5'd2 || Iteration_number == 5'd8 || Iteration_number == 5'd9 || Iteration_number == 5'd14 || Iteration_number == 5'd15 || Iteration_number == 5'd19 || Iteration_number == 5'd20))
    begin
        R_6[0] <= (N_R_6[11][0] >>>1) + (N_R_6[11][0] >>>4) + (N_R_6[11][0] >>>5) + (N_R_6[11][0] >>>7) + (N_R_6[11][0] >>>8) + (N_R_6[11][0] >>>10) + (N_R_6[11][0] >>>11) + (N_R_6[11][0] >>>12) + (N_R_6[11][0] >>>14)  ; 
        R_6[1] <= (N_R_6[11][1] >>>1) + (N_R_6[11][1] >>>4) + (N_R_6[11][1] >>>5) + (N_R_6[11][1] >>>7) + (N_R_6[11][1] >>>8) + (N_R_6[11][1] >>>10) + (N_R_6[11][1] >>>11) + (N_R_6[11][1] >>>12) + (N_R_6[11][1] >>>14)  ; 
        R_6[2] <= (N_R_6[11][2] >>>1) + (N_R_6[11][2] >>>4) + (N_R_6[11][2] >>>5) + (N_R_6[11][2] >>>7) + (N_R_6[11][2] >>>8) + (N_R_6[11][2] >>>10) + (N_R_6[11][2] >>>11) + (N_R_6[11][2] >>>12) + (N_R_6[11][2] >>>14)  ; 
        R_6[3] <= (N_R_6[11][3] >>>1) + (N_R_6[11][3] >>>4) + (N_R_6[11][3] >>>5) + (N_R_6[11][3] >>>7) + (N_R_6[11][3] >>>8) + (N_R_6[11][3] >>>10) + (N_R_6[11][3] >>>11) + (N_R_6[11][3] >>>12) + (N_R_6[11][3] >>>14)  ; 
    end
    else if (Current_state == R_give && Iteration_number == 5'd18)
    begin
        R_6[0] <= R_6[3] ;
        R_6[1] <= R_6[3] ;
        R_6[2] <= R_6[3] ;
    end
    else if (Current_state == R_give && Iteration_number == 5'd13)
    begin
        R_6[0] <= R_6[2] ;
        R_6[1] <= R_6[2] ;
    end
    else if (Current_state == R_give)
    begin
        R_6[0] <= R_6[1] ;
    end
end

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        for (i=0; i<4; i=i+1)
        begin
            R_7[i] <= 24'd0 ;
        end   
    end
    else if (Current_state == Read && Counter_store_data == 3'd6)
    begin
        R_7[0] <= matrix_0 <<12 ;
        R_7[1] <= matrix_1 <<12 ;
        R_7[2] <= matrix_2 <<12 ;
        R_7[3] <= matrix_3 <<12 ;    
    end
    else if (Current_state == QR && Counter_Iteratin == 2'd3 && (Iteration_number == 5'd0 || Iteration_number == 5'd1 || Iteration_number == 5'd7 || Iteration_number == 5'd8 || Iteration_number == 5'd13 || Iteration_number == 5'd14 || Iteration_number == 5'd18 || Iteration_number == 5'd19))
    begin
        R_7[0] <= (N_R_7[11][0] >>>1) + (N_R_7[11][0] >>>4) + (N_R_7[11][0] >>>5) + (N_R_7[11][0] >>>7) + (N_R_7[11][0] >>>8) + (N_R_7[11][0] >>>10) + (N_R_7[11][0] >>>11) + (N_R_7[11][0] >>>12) + (N_R_7[11][0] >>>14)  ; 
        R_7[1] <= (N_R_7[11][1] >>>1) + (N_R_7[11][1] >>>4) + (N_R_7[11][1] >>>5) + (N_R_7[11][1] >>>7) + (N_R_7[11][1] >>>8) + (N_R_7[11][1] >>>10) + (N_R_7[11][1] >>>11) + (N_R_7[11][1] >>>12) + (N_R_7[11][1] >>>14)  ; 
        R_7[2] <= (N_R_7[11][2] >>>1) + (N_R_7[11][2] >>>4) + (N_R_7[11][2] >>>5) + (N_R_7[11][2] >>>7) + (N_R_7[11][2] >>>8) + (N_R_7[11][2] >>>10) + (N_R_7[11][2] >>>11) + (N_R_7[11][2] >>>12) + (N_R_7[11][2] >>>14)  ; 
        R_7[3] <= (N_R_7[11][3] >>>1) + (N_R_7[11][3] >>>4) + (N_R_7[11][3] >>>5) + (N_R_7[11][3] >>>7) + (N_R_7[11][3] >>>8) + (N_R_7[11][3] >>>10) + (N_R_7[11][3] >>>11) + (N_R_7[11][3] >>>12) + (N_R_7[11][3] >>>14)  ; 
    end
    else if (Current_state == R_give && Iteration_number == 5'd18)
    begin
        R_7[0] <= R_7[3] ;
        R_7[1] <= R_7[3] ;
        R_7[2] <= R_7[3] ;
    end
    else if (Current_state == R_give && Iteration_number == 5'd13)
    begin
        R_7[0] <= R_7[2] ;
        R_7[1] <= R_7[2] ;
    end
    else if (Current_state == R_give)
    begin
        R_7[0] <= R_7[1] ;
    end
end

always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        for (i=0; i<4; i=i+1)
        begin
            R_8[i] <= 8'd0 ;
        end   
    end
    else if (Current_state == Read && Counter_store_data == 3'd7)
    begin
        R_8[0] <= matrix_0 <<12 ;
        R_8[1] <= matrix_1 <<12 ;
        R_8[2] <= matrix_2 <<12 ;
        R_8[3] <= matrix_3 <<12 ;    
    end
    else if (Current_state == QR && Counter_Iteratin == 2'd3 && (Iteration_number == 5'd0 || Iteration_number == 5'd7 || Iteration_number == 5'd13 || Iteration_number == 5'd18))
    begin
        R_8[0] <= (N_R_8[11][0] >>>1) + (N_R_8[11][0] >>>4) + (N_R_8[11][0] >>>5) + (N_R_8[11][0] >>>7) + (N_R_8[11][0] >>>8) + (N_R_8[11][0] >>>10) + (N_R_8[11][0] >>>11) + (N_R_8[11][0] >>>12) + (N_R_8[11][0] >>>14)  ;
        R_8[1] <= (N_R_8[11][1] >>>1) + (N_R_8[11][1] >>>4) + (N_R_8[11][1] >>>5) + (N_R_8[11][1] >>>7) + (N_R_8[11][1] >>>8) + (N_R_8[11][1] >>>10) + (N_R_8[11][1] >>>11) + (N_R_8[11][1] >>>12) + (N_R_8[11][1] >>>14)  ;
        R_8[2] <= (N_R_8[11][2] >>>1) + (N_R_8[11][2] >>>4) + (N_R_8[11][2] >>>5) + (N_R_8[11][2] >>>7) + (N_R_8[11][2] >>>8) + (N_R_8[11][2] >>>10) + (N_R_8[11][2] >>>11) + (N_R_8[11][2] >>>12) + (N_R_8[11][2] >>>14)  ;
        R_8[3] <= (N_R_8[11][3] >>>1) + (N_R_8[11][3] >>>4) + (N_R_8[11][3] >>>5) + (N_R_8[11][3] >>>7) + (N_R_8[11][3] >>>8) + (N_R_8[11][3] >>>10) + (N_R_8[11][3] >>>11) + (N_R_8[11][3] >>>12) + (N_R_8[11][3] >>>14)  ;
    end
    else if (Current_state == R_give && Iteration_number == 5'd18)
    begin
        R_8[0] <= R_8[3] ;
        R_8[1] <= R_8[3] ;
        R_8[2] <= R_8[3] ;
    end
    else if (Current_state == R_give && Iteration_number == 5'd13)
    begin
        R_8[0] <= R_8[2] ;
        R_8[1] <= R_8[2] ;
    end
    else if (Current_state == R_give)
    begin
        R_8[0] <= R_8[1] ;
    end
end

//////////////////////////////////////////////////////
//docomposition R
//////////////////////////////////////////////////////

genvar j, k ;
generate
for (j=0; j<4; j=j+1)
        for (k=0; k<4; k=k+1)
    begin: gen_block_NEW_R_1
        always @(*)
        begin 
            if (Current_state == QR && Counter_Iteratin == 2'd0 && Iteration_number == 5'd6)
            begin
                case (j)
                2'd0: N_R_1[j][k] = (R_2[0] > 0)? R_1[k] + (R_2[k]>>>j) : R_1[k] - (R_2[k]>>>j);
                2'd1: N_R_1[j][k] = (N_R_2[j-1][0] > 0)? N_R_1[j-1][k] + (N_R_2[j-1][k]>>>j) : N_R_1[j-1][k] - (N_R_2[j-1][k]>>>j);
                2'd2: N_R_1[j][k] = (N_R_2[j-1][0] > 0)? N_R_1[j-1][k] + (N_R_2[j-1][k]>>>j) : N_R_1[j-1][k] - (N_R_2[j-1][k]>>>j);
                2'd3: N_R_1[j][k] = (N_R_2[j-1][0] > 0)? N_R_1[j-1][k] + (N_R_2[j-1][k]>>>j) : N_R_1[j-1][k] - (N_R_2[j-1][k]>>>j);
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd1 && Iteration_number == 5'd6)
            begin
                case (j)
                2'd0: N_R_1[j+4][k] = (N_R_2[j+3][0] > 0)? N_R_1[j+3][k] + (N_R_2[j+3][k]>>>j+4) : N_R_1[j+3][k] - (N_R_2[j+3][k]>>>j+4);
                2'd1: N_R_1[j+4][k] = (N_R_2[j+3][0] > 0)? N_R_1[j+3][k] + (N_R_2[j+3][k]>>>j+4) : N_R_1[j+3][k] - (N_R_2[j+3][k]>>>j+4);
                2'd2: N_R_1[j+4][k] = (N_R_2[j+3][0] > 0)? N_R_1[j+3][k] + (N_R_2[j+3][k]>>>j+4) : N_R_1[j+3][k] - (N_R_2[j+3][k]>>>j+4);
                2'd3: N_R_1[j+4][k] = (N_R_2[j+3][0] > 0)? N_R_1[j+3][k] + (N_R_2[j+3][k]>>>j+4) : N_R_1[j+3][k] - (N_R_2[j+3][k]>>>j+4);
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd2 && Iteration_number == 5'd6)
            begin
                case (j)
                2'd0: N_R_1[j+8][k] = (N_R_2[j+7][0] > 0)? N_R_1[j+7][k] + (N_R_2[j+7][k]>>>j+8) : N_R_1[j+7][k] - (N_R_2[j+7][k]>>>j+8);
                2'd1: N_R_1[j+8][k] = (N_R_2[j+7][0] > 0)? N_R_1[j+7][k] + (N_R_2[j+7][k]>>>j+8) : N_R_1[j+7][k] - (N_R_2[j+7][k]>>>j+8);
                2'd2: N_R_1[j+8][k] = (N_R_2[j+7][0] > 0)? N_R_1[j+7][k] + (N_R_2[j+7][k]>>>j+8) : N_R_1[j+7][k] - (N_R_2[j+7][k]>>>j+8);
                2'd3: N_R_1[j+8][k] = (N_R_2[j+7][0] > 0)? N_R_1[j+7][k] + (N_R_2[j+7][k]>>>j+8) : N_R_1[j+7][k] - (N_R_2[j+7][k]>>>j+8);
                endcase
            end
        end
    end

for (j=0; j<4; j=j+1)
        for (k=0; k<4; k=k+1)
    begin: gen_block_NEW_R_2
        always @(*)
        begin 
            if (Current_state == QR && Counter_Iteratin == 2'd0 && Iteration_number == 5'd6)
            begin
                case (j)
                2'd0: N_R_2[j][k] = (R_2[0] > 0)? R_2[k] - (R_1[k]>>>j) : R_2[k] + (R_1[k]>>>j);
                2'd1: N_R_2[j][k] = (N_R_2[j-1][0] > 0)? N_R_2[j-1][k] - (N_R_1[j-1][k]>>>j) : N_R_2[j-1][k] + (N_R_1[j-1][k]>>>j);
                2'd2: N_R_2[j][k] = (N_R_2[j-1][0] > 0)? N_R_2[j-1][k] - (N_R_1[j-1][k]>>>j) : N_R_2[j-1][k] + (N_R_1[j-1][k]>>>j);
                2'd3: N_R_2[j][k] = (N_R_2[j-1][0] > 0)? N_R_2[j-1][k] - (N_R_1[j-1][k]>>>j) : N_R_2[j-1][k] + (N_R_1[j-1][k]>>>j);
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd1 && Iteration_number == 5'd6)
            begin
                case (j)
                2'd0: N_R_2[j+4][k] = (N_R_2[j+3][0] > 0)? N_R_2[j+3][k] - (N_R_1[j+3][k]>>>j+4) : N_R_2[j+3][k] + (N_R_1[j+3][k]>>>j+4);
                2'd1: N_R_2[j+4][k] = (N_R_2[j+3][0] > 0)? N_R_2[j+3][k] - (N_R_1[j+3][k]>>>j+4) : N_R_2[j+3][k] + (N_R_1[j+3][k]>>>j+4);
                2'd2: N_R_2[j+4][k] = (N_R_2[j+3][0] > 0)? N_R_2[j+3][k] - (N_R_1[j+3][k]>>>j+4) : N_R_2[j+3][k] + (N_R_1[j+3][k]>>>j+4);
                2'd3: N_R_2[j+4][k] = (N_R_2[j+3][0] > 0)? N_R_2[j+3][k] - (N_R_1[j+3][k]>>>j+4) : N_R_2[j+3][k] + (N_R_1[j+3][k]>>>j+4);
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd2 && Iteration_number == 5'd6)
            begin
                case (j)
                2'd0: N_R_2[j+8][k] = (N_R_2[j+7][0] > 0)? N_R_2[j+7][k] - (N_R_1[j+7][k]>>>j+8) : N_R_2[j+7][k] + (N_R_1[j+7][k]>>>j+8);
                2'd1: N_R_2[j+8][k] = (N_R_2[j+7][0] > 0)? N_R_2[j+7][k] - (N_R_1[j+7][k]>>>j+8) : N_R_2[j+7][k] + (N_R_1[j+7][k]>>>j+8);
                2'd2: N_R_2[j+8][k] = (N_R_2[j+7][0] > 0)? N_R_2[j+7][k] - (N_R_1[j+7][k]>>>j+8) : N_R_2[j+7][k] + (N_R_1[j+7][k]>>>j+8);
                2'd3: N_R_2[j+8][k] = (N_R_2[j+7][0] > 0)? N_R_2[j+7][k] - (N_R_1[j+7][k]>>>j+8) : N_R_2[j+7][k] + (N_R_1[j+7][k]>>>j+8);
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd0 && (Iteration_number == 5'd5 || Iteration_number == 5'd12))
            begin
                case (j)
                2'd0: N_R_2[j][k] = (R_2[0] > 0)? ((R_3[0] > 0)? R_2[k] + (R_3[k]>>>j) : R_2[k] - (R_3[k]>>>j)) : ((R_3[0] > 0)? -R_2[k] + (R_3[k]>>>j) : -R_2[k] - (R_3[k]>>>j));
                2'd1: N_R_2[j][k] = (N_R_2[j-1][0] > 0)? ((N_R_3[j-1][0] > 0)? N_R_2[j-1][k] + (N_R_3[j-1][k]>>>j) : N_R_2[j-1][k] - (N_R_3[j-1][k]>>>j)) : ((N_R_3[j-1][0] > 0)? -N_R_2[j-1][k] + (N_R_3[j-1][k]>>>j) : -N_R_2[j-1][k] - (N_R_3[j-1][k]>>>j));
                2'd2: N_R_2[j][k] = (N_R_2[j-1][0] > 0)? ((N_R_3[j-1][0] > 0)? N_R_2[j-1][k] + (N_R_3[j-1][k]>>>j) : N_R_2[j-1][k] - (N_R_3[j-1][k]>>>j)) : ((N_R_3[j-1][0] > 0)? -N_R_2[j-1][k] + (N_R_3[j-1][k]>>>j) : -N_R_2[j-1][k] - (N_R_3[j-1][k]>>>j));
                2'd3: N_R_2[j][k] = (N_R_2[j-1][0] > 0)? ((N_R_3[j-1][0] > 0)? N_R_2[j-1][k] + (N_R_3[j-1][k]>>>j) : N_R_2[j-1][k] - (N_R_3[j-1][k]>>>j)) : ((N_R_3[j-1][0] > 0)? -N_R_2[j-1][k] + (N_R_3[j-1][k]>>>j) : -N_R_2[j-1][k] - (N_R_3[j-1][k]>>>j));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd1 && (Iteration_number == 5'd5 || Iteration_number == 5'd12))
            begin
                case (j)
                2'd0: N_R_2[j+4][k] = (N_R_2[j+3][0] > 0)? ((N_R_3[j+3][0] > 0)? N_R_2[j+3][k] + (N_R_3[j+3][k]>>>j+4) : N_R_2[j+3][k] - (N_R_3[j+3][k]>>>j+4)) : ((N_R_3[j+3][0] > 0)? -N_R_2[j+3][k] + (N_R_3[j+3][k]>>>j+4) : -N_R_2[j+3][k] - (N_R_3[j+3][k]>>>j+4));
                2'd1: N_R_2[j+4][k] = (N_R_2[j+3][0] > 0)? ((N_R_3[j+3][0] > 0)? N_R_2[j+3][k] + (N_R_3[j+3][k]>>>j+4) : N_R_2[j+3][k] - (N_R_3[j+3][k]>>>j+4)) : ((N_R_3[j+3][0] > 0)? -N_R_2[j+3][k] + (N_R_3[j+3][k]>>>j+4) : -N_R_2[j+3][k] - (N_R_3[j+3][k]>>>j+4));
                2'd2: N_R_2[j+4][k] = (N_R_2[j+3][0] > 0)? ((N_R_3[j+3][0] > 0)? N_R_2[j+3][k] + (N_R_3[j+3][k]>>>j+4) : N_R_2[j+3][k] - (N_R_3[j+3][k]>>>j+4)) : ((N_R_3[j+3][0] > 0)? -N_R_2[j+3][k] + (N_R_3[j+3][k]>>>j+4) : -N_R_2[j+3][k] - (N_R_3[j+3][k]>>>j+4));
                2'd3: N_R_2[j+4][k] = (N_R_2[j+3][0] > 0)? ((N_R_3[j+3][0] > 0)? N_R_2[j+3][k] + (N_R_3[j+3][k]>>>j+4) : N_R_2[j+3][k] - (N_R_3[j+3][k]>>>j+4)) : ((N_R_3[j+3][0] > 0)? -N_R_2[j+3][k] + (N_R_3[j+3][k]>>>j+4) : -N_R_2[j+3][k] - (N_R_3[j+3][k]>>>j+4));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd2 && (Iteration_number == 5'd5 || Iteration_number == 5'd12))
            begin
                case (j)
                2'd0: N_R_2[j+8][k] = (N_R_2[j+7][0] > 0)? ((N_R_3[j+7][0] > 0)? N_R_2[j+7][k] + (N_R_3[j+7][k]>>>j+8) : N_R_2[j+7][k] - (N_R_3[j+7][k]>>>j+8)) : ((N_R_3[j+7][0] > 0)? -N_R_2[j+7][k] + (N_R_3[j+7][k]>>>j+8) : -N_R_2[j+7][k] - (N_R_3[j+7][k]>>>j+8));
                2'd1: N_R_2[j+8][k] = (N_R_2[j+7][0] > 0)? ((N_R_3[j+7][0] > 0)? N_R_2[j+7][k] + (N_R_3[j+7][k]>>>j+8) : N_R_2[j+7][k] - (N_R_3[j+7][k]>>>j+8)) : ((N_R_3[j+7][0] > 0)? -N_R_2[j+7][k] + (N_R_3[j+7][k]>>>j+8) : -N_R_2[j+7][k] - (N_R_3[j+7][k]>>>j+8));
                2'd2: N_R_2[j+8][k] = (N_R_2[j+7][0] > 0)? ((N_R_3[j+7][0] > 0)? N_R_2[j+7][k] + (N_R_3[j+7][k]>>>j+8) : N_R_2[j+7][k] - (N_R_3[j+7][k]>>>j+8)) : ((N_R_3[j+7][0] > 0)? -N_R_2[j+7][k] + (N_R_3[j+7][k]>>>j+8) : -N_R_2[j+7][k] - (N_R_3[j+7][k]>>>j+8));
                2'd3: N_R_2[j+8][k] = (N_R_2[j+7][0] > 0)? ((N_R_3[j+7][0] > 0)? N_R_2[j+7][k] + (N_R_3[j+7][k]>>>j+8) : N_R_2[j+7][k] - (N_R_3[j+7][k]>>>j+8)) : ((N_R_3[j+7][0] > 0)? -N_R_2[j+7][k] + (N_R_3[j+7][k]>>>j+8) : -N_R_2[j+7][k] - (N_R_3[j+7][k]>>>j+8));
                endcase
            end
        end
    end

for (j=0; j<4; j=j+1)
        for (k=0; k<4; k=k+1)
    begin: gen_block_NEW_R_3
        always @(*)
        begin 
            if (Current_state == QR && Counter_Iteratin == 2'd0 && (Iteration_number == 5'd5 || Iteration_number == 5'd12))
            begin
                case (j)
                2'd0: N_R_3[j][k] = (R_2[0] > 0)? ((R_3[0] > 0)? R_3[k] - (R_2[k]>>>j) : R_3[k] + (R_2[k]>>>j)) : ((R_3[0] > 0)? R_3[k] + (R_2[k]>>>j) : R_3[k] - (R_2[k]>>>j));
                2'd1: N_R_3[j][k] = (N_R_2[j-1][0] > 0)? ((N_R_3[j-1][0] > 0)? N_R_3[j-1][k] - (N_R_2[j-1][k]>>>j) : N_R_3[j-1][k] + (N_R_2[j-1][k]>>>j)) : ((N_R_3[j-1][0] > 0)? N_R_3[j-1][k] + (N_R_2[j-1][k]>>>j) : N_R_3[j-1][k] - (N_R_2[j-1][k]>>>j));
                2'd2: N_R_3[j][k] = (N_R_2[j-1][0] > 0)? ((N_R_3[j-1][0] > 0)? N_R_3[j-1][k] - (N_R_2[j-1][k]>>>j) : N_R_3[j-1][k] + (N_R_2[j-1][k]>>>j)) : ((N_R_3[j-1][0] > 0)? N_R_3[j-1][k] + (N_R_2[j-1][k]>>>j) : N_R_3[j-1][k] - (N_R_2[j-1][k]>>>j));
                2'd3: N_R_3[j][k] = (N_R_2[j-1][0] > 0)? ((N_R_3[j-1][0] > 0)? N_R_3[j-1][k] - (N_R_2[j-1][k]>>>j) : N_R_3[j-1][k] + (N_R_2[j-1][k]>>>j)) : ((N_R_3[j-1][0] > 0)? N_R_3[j-1][k] + (N_R_2[j-1][k]>>>j) : N_R_3[j-1][k] - (N_R_2[j-1][k]>>>j));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd1 && (Iteration_number == 5'd5 || Iteration_number == 5'd12))
            begin
                case (j)
                2'd0: N_R_3[j+4][k] = (N_R_2[j+3][0] > 0)? ((N_R_3[j+3][0] > 0)? N_R_3[j+3][k] - (N_R_2[j+3][k]>>>j+4) : N_R_3[j+3][k] + (N_R_2[j+3][k]>>>j+4)) : ((N_R_3[j+3][0] > 0)? N_R_3[j+3][k] + (N_R_2[j+3][k]>>>j+4) : N_R_3[j+3][k] - (N_R_2[j+3][k]>>>j+4));
                2'd1: N_R_3[j+4][k] = (N_R_2[j+3][0] > 0)? ((N_R_3[j+3][0] > 0)? N_R_3[j+3][k] - (N_R_2[j+3][k]>>>j+4) : N_R_3[j+3][k] + (N_R_2[j+3][k]>>>j+4)) : ((N_R_3[j+3][0] > 0)? N_R_3[j+3][k] + (N_R_2[j+3][k]>>>j+4) : N_R_3[j+3][k] - (N_R_2[j+3][k]>>>j+4));
                2'd2: N_R_3[j+4][k] = (N_R_2[j+3][0] > 0)? ((N_R_3[j+3][0] > 0)? N_R_3[j+3][k] - (N_R_2[j+3][k]>>>j+4) : N_R_3[j+3][k] + (N_R_2[j+3][k]>>>j+4)) : ((N_R_3[j+3][0] > 0)? N_R_3[j+3][k] + (N_R_2[j+3][k]>>>j+4) : N_R_3[j+3][k] - (N_R_2[j+3][k]>>>j+4));
                2'd3: N_R_3[j+4][k] = (N_R_2[j+3][0] > 0)? ((N_R_3[j+3][0] > 0)? N_R_3[j+3][k] - (N_R_2[j+3][k]>>>j+4) : N_R_3[j+3][k] + (N_R_2[j+3][k]>>>j+4)) : ((N_R_3[j+3][0] > 0)? N_R_3[j+3][k] + (N_R_2[j+3][k]>>>j+4) : N_R_3[j+3][k] - (N_R_2[j+3][k]>>>j+4));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd2 && (Iteration_number == 5'd5 || Iteration_number == 5'd12))
            begin
                case (j)
                2'd0: N_R_3[j+8][k] = (N_R_2[j+7][0] > 0)? ((N_R_3[j+7][0] > 0)? N_R_3[j+7][k] - (N_R_2[j+7][k]>>>j+8) : N_R_3[j+7][k] + (N_R_2[j+7][k]>>>j+8)) : ((N_R_3[j+7][0] > 0)? N_R_3[j+7][k] + (N_R_2[j+7][k]>>>j+8) : N_R_3[j+7][k] - (N_R_2[j+7][k]>>>j+8));
                2'd1: N_R_3[j+8][k] = (N_R_2[j+7][0] > 0)? ((N_R_3[j+7][0] > 0)? N_R_3[j+7][k] - (N_R_2[j+7][k]>>>j+8) : N_R_3[j+7][k] + (N_R_2[j+7][k]>>>j+8)) : ((N_R_3[j+7][0] > 0)? N_R_3[j+7][k] + (N_R_2[j+7][k]>>>j+8) : N_R_3[j+7][k] - (N_R_2[j+7][k]>>>j+8));
                2'd2: N_R_3[j+8][k] = (N_R_2[j+7][0] > 0)? ((N_R_3[j+7][0] > 0)? N_R_3[j+7][k] - (N_R_2[j+7][k]>>>j+8) : N_R_3[j+7][k] + (N_R_2[j+7][k]>>>j+8)) : ((N_R_3[j+7][0] > 0)? N_R_3[j+7][k] + (N_R_2[j+7][k]>>>j+8) : N_R_3[j+7][k] - (N_R_2[j+7][k]>>>j+8));
                2'd3: N_R_3[j+8][k] = (N_R_2[j+7][0] > 0)? ((N_R_3[j+7][0] > 0)? N_R_3[j+7][k] - (N_R_2[j+7][k]>>>j+8) : N_R_3[j+7][k] + (N_R_2[j+7][k]>>>j+8)) : ((N_R_3[j+7][0] > 0)? N_R_3[j+7][k] + (N_R_2[j+7][k]>>>j+8) : N_R_3[j+7][k] - (N_R_2[j+7][k]>>>j+8));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd0 && (Iteration_number == 5'd4 || Iteration_number == 5'd11 || Iteration_number == 5'd17))
            begin
                case (j)
                2'd0: N_R_3[j][k] = (R_3[0] > 0)? ((R_4[0] > 0)? R_4[k] + (R_3[k]>>>j) : R_4[k] - (R_3[k]>>>j)) : ((R_4[0] > 0)? R_4[k] - (R_3[k]>>>j) : R_4[k] + (R_3[k]>>>j));
                2'd1: N_R_3[j][k] = (N_R_3[j-1][0] > 0)? ((N_R_4[j-1][0] > 0)? N_R_3[j-1][k] + (N_R_4[j-1][k]>>>j) : N_R_3[j-1][k] - (N_R_4[j-1][k]>>>j)) : ((N_R_4[j-1][0] > 0)? -N_R_3[j-1][k] + (N_R_4[j-1][k]>>>j) : -N_R_3[j-1][k] - (N_R_4[j-1][k]>>>j));
                2'd2: N_R_3[j][k] = (N_R_3[j-1][0] > 0)? ((N_R_4[j-1][0] > 0)? N_R_3[j-1][k] + (N_R_4[j-1][k]>>>j) : N_R_3[j-1][k] - (N_R_4[j-1][k]>>>j)) : ((N_R_4[j-1][0] > 0)? -N_R_3[j-1][k] + (N_R_4[j-1][k]>>>j) : -N_R_3[j-1][k] - (N_R_4[j-1][k]>>>j));
                2'd3: N_R_3[j][k] = (N_R_3[j-1][0] > 0)? ((N_R_4[j-1][0] > 0)? N_R_3[j-1][k] + (N_R_4[j-1][k]>>>j) : N_R_3[j-1][k] - (N_R_4[j-1][k]>>>j)) : ((N_R_4[j-1][0] > 0)? -N_R_3[j-1][k] + (N_R_4[j-1][k]>>>j) : -N_R_3[j-1][k] - (N_R_4[j-1][k]>>>j));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd1 && (Iteration_number == 5'd4 || Iteration_number == 5'd11 || Iteration_number == 5'd17))
            begin
                case (j)
                2'd0: N_R_3[j+4][k] = (N_R_3[j+3][0] > 0)? ((N_R_4[j+3][0] > 0)? N_R_3[j+3][k] + (N_R_4[j+3][k]>>>j+4) : N_R_3[j+3][k] - (N_R_4[j+3][k]>>>j+4)) : ((N_R_4[j+3][0] > 0)? -N_R_3[j+3][k] + (N_R_4[j+3][k]>>>j+4) : -N_R_3[j+3][k] - (N_R_4[j+3][k]>>>j+4));
                2'd1: N_R_3[j+4][k] = (N_R_3[j+3][0] > 0)? ((N_R_4[j+3][0] > 0)? N_R_3[j+3][k] + (N_R_4[j+3][k]>>>j+4) : N_R_3[j+3][k] - (N_R_4[j+3][k]>>>j+4)) : ((N_R_4[j+3][0] > 0)? -N_R_3[j+3][k] + (N_R_4[j+3][k]>>>j+4) : -N_R_3[j+3][k] - (N_R_4[j+3][k]>>>j+4));
                2'd2: N_R_3[j+4][k] = (N_R_3[j+3][0] > 0)? ((N_R_4[j+3][0] > 0)? N_R_3[j+3][k] + (N_R_4[j+3][k]>>>j+4) : N_R_3[j+3][k] - (N_R_4[j+3][k]>>>j+4)) : ((N_R_4[j+3][0] > 0)? -N_R_3[j+3][k] + (N_R_4[j+3][k]>>>j+4) : -N_R_3[j+3][k] - (N_R_4[j+3][k]>>>j+4));
                2'd3: N_R_3[j+4][k] = (N_R_3[j+3][0] > 0)? ((N_R_4[j+3][0] > 0)? N_R_3[j+3][k] + (N_R_4[j+3][k]>>>j+4) : N_R_3[j+3][k] - (N_R_4[j+3][k]>>>j+4)) : ((N_R_4[j+3][0] > 0)? -N_R_3[j+3][k] + (N_R_4[j+3][k]>>>j+4) : -N_R_3[j+3][k] - (N_R_4[j+3][k]>>>j+4));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd2 && (Iteration_number == 5'd4 || Iteration_number == 5'd11 || Iteration_number == 5'd17))
            begin
                case (j)
                2'd0: N_R_3[j+8][k] = (N_R_3[j+7][0] > 0)? ((N_R_4[j+7][0] > 0)? N_R_3[j+7][k] + (N_R_4[j+7][k]>>>j+8) : N_R_3[j+7][k] - (N_R_4[j+7][k]>>>j+8)) : ((N_R_4[j+7][0] > 0)? -N_R_3[j+7][k] + (N_R_4[j+7][k]>>>j+8) : -N_R_3[j+7][k] - (N_R_4[j+7][k]>>>j+8));
                2'd1: N_R_3[j+8][k] = (N_R_3[j+7][0] > 0)? ((N_R_4[j+7][0] > 0)? N_R_3[j+7][k] + (N_R_4[j+7][k]>>>j+8) : N_R_3[j+7][k] - (N_R_4[j+7][k]>>>j+8)) : ((N_R_4[j+7][0] > 0)? -N_R_3[j+7][k] + (N_R_4[j+7][k]>>>j+8) : -N_R_3[j+7][k] - (N_R_4[j+7][k]>>>j+8));
                2'd2: N_R_3[j+8][k] = (N_R_3[j+7][0] > 0)? ((N_R_4[j+7][0] > 0)? N_R_3[j+7][k] + (N_R_4[j+7][k]>>>j+8) : N_R_3[j+7][k] - (N_R_4[j+7][k]>>>j+8)) : ((N_R_4[j+7][0] > 0)? -N_R_3[j+7][k] + (N_R_4[j+7][k]>>>j+8) : -N_R_3[j+7][k] - (N_R_4[j+7][k]>>>j+8));
                2'd3: N_R_3[j+8][k] = (N_R_3[j+7][0] > 0)? ((N_R_4[j+7][0] > 0)? N_R_3[j+7][k] + (N_R_4[j+7][k]>>>j+8) : N_R_3[j+7][k] - (N_R_4[j+7][k]>>>j+8)) : ((N_R_4[j+7][0] > 0)? -N_R_3[j+7][k] + (N_R_4[j+7][k]>>>j+8) : -N_R_3[j+7][k] - (N_R_4[j+7][k]>>>j+8));
                endcase
            end
        end
    end

for (j=0; j<4; j=j+1)
        for (k=0; k<4; k=k+1)
    begin: gen_block_NEW_R_4
        always @(*)
        begin 
            if (Current_state == QR && Counter_Iteratin == 2'd0 && (Iteration_number == 5'd4 || Iteration_number == 5'd11 || Iteration_number == 5'd17))
            begin
                case (j)
                2'd0: N_R_4[j][k] = (R_3[0] > 0)? ((R_4[0] > 0)? R_4[k] - (R_3[k]>>>j) : R_4[k] + (R_3[k]>>>j)) : ((R_4[0] > 0)? R_4[k] + (R_3[k]>>>j) : R_4[k] - (R_3[k]>>>j));
                2'd1: N_R_4[j][k] = (N_R_3[j-1][0] > 0)? ((N_R_4[j-1][0] > 0)? N_R_4[j-1][k] - (N_R_3[j-1][k]>>>j) : N_R_4[j-1][k] + (N_R_3[j-1][k]>>>j)) : ((N_R_4[j-1][0] > 0)? N_R_4[j-1][k] + (N_R_3[j-1][k]>>>j) : N_R_4[j-1][k] - (N_R_3[j-1][k]>>>j));
                2'd2: N_R_4[j][k] = (N_R_3[j-1][0] > 0)? ((N_R_4[j-1][0] > 0)? N_R_4[j-1][k] - (N_R_3[j-1][k]>>>j) : N_R_4[j-1][k] + (N_R_3[j-1][k]>>>j)) : ((N_R_4[j-1][0] > 0)? N_R_4[j-1][k] + (N_R_3[j-1][k]>>>j) : N_R_4[j-1][k] - (N_R_3[j-1][k]>>>j));
                2'd3: N_R_4[j][k] = (N_R_3[j-1][0] > 0)? ((N_R_4[j-1][0] > 0)? N_R_4[j-1][k] - (N_R_3[j-1][k]>>>j) : N_R_4[j-1][k] + (N_R_3[j-1][k]>>>j)) : ((N_R_4[j-1][0] > 0)? N_R_4[j-1][k] + (N_R_3[j-1][k]>>>j) : N_R_4[j-1][k] - (N_R_3[j-1][k]>>>j));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd1 && (Iteration_number == 5'd4 || Iteration_number == 5'd11 || Iteration_number == 5'd17))
            begin
                case (j)
                2'd0: N_R_4[j+4][k] = (N_R_3[j+3][0] > 0)? ((N_R_4[j+3][0] > 0)? N_R_4[j+3][k] - (N_R_3[j+3][k]>>>j+4) : N_R_4[j+3][k] + (N_R_3[j+3][k]>>>j+4)) : ((N_R_4[j+3][0] > 0)? N_R_4[j+3][k] + (N_R_3[j+3][k]>>>j+4) : N_R_4[j+3][k] - (N_R_3[j+3][k]>>>j+4));
                2'd1: N_R_4[j+4][k] = (N_R_3[j+3][0] > 0)? ((N_R_4[j+3][0] > 0)? N_R_4[j+3][k] - (N_R_3[j+3][k]>>>j+4) : N_R_4[j+3][k] + (N_R_3[j+3][k]>>>j+4)) : ((N_R_4[j+3][0] > 0)? N_R_4[j+3][k] + (N_R_3[j+3][k]>>>j+4) : N_R_4[j+3][k] - (N_R_3[j+3][k]>>>j+4));
                2'd2: N_R_4[j+4][k] = (N_R_3[j+3][0] > 0)? ((N_R_4[j+3][0] > 0)? N_R_4[j+3][k] - (N_R_3[j+3][k]>>>j+4) : N_R_4[j+3][k] + (N_R_3[j+3][k]>>>j+4)) : ((N_R_4[j+3][0] > 0)? N_R_4[j+3][k] + (N_R_3[j+3][k]>>>j+4) : N_R_4[j+3][k] - (N_R_3[j+3][k]>>>j+4));
                2'd3: N_R_4[j+4][k] = (N_R_3[j+3][0] > 0)? ((N_R_4[j+3][0] > 0)? N_R_4[j+3][k] - (N_R_3[j+3][k]>>>j+4) : N_R_4[j+3][k] + (N_R_3[j+3][k]>>>j+4)) : ((N_R_4[j+3][0] > 0)? N_R_4[j+3][k] + (N_R_3[j+3][k]>>>j+4) : N_R_4[j+3][k] - (N_R_3[j+3][k]>>>j+4));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd2 && (Iteration_number == 5'd4 || Iteration_number == 5'd11 || Iteration_number == 5'd17))
            begin
                case (j)
                2'd0: N_R_4[j+8][k] = (N_R_3[j+7][0] > 0)? ((N_R_4[j+7][0] > 0)? N_R_4[j+7][k] - (N_R_3[j+7][k]>>>j+8) : N_R_4[j+7][k] + (N_R_3[j+7][k]>>>j+8)) : ((N_R_4[j+7][0] > 0)? N_R_4[j+7][k] + (N_R_3[j+7][k]>>>j+8) : N_R_4[j+7][k] - (N_R_3[j+7][k]>>>j+8));
                2'd1: N_R_4[j+8][k] = (N_R_3[j+7][0] > 0)? ((N_R_4[j+7][0] > 0)? N_R_4[j+7][k] - (N_R_3[j+7][k]>>>j+8) : N_R_4[j+7][k] + (N_R_3[j+7][k]>>>j+8)) : ((N_R_4[j+7][0] > 0)? N_R_4[j+7][k] + (N_R_3[j+7][k]>>>j+8) : N_R_4[j+7][k] - (N_R_3[j+7][k]>>>j+8));
                2'd2: N_R_4[j+8][k] = (N_R_3[j+7][0] > 0)? ((N_R_4[j+7][0] > 0)? N_R_4[j+7][k] - (N_R_3[j+7][k]>>>j+8) : N_R_4[j+7][k] + (N_R_3[j+7][k]>>>j+8)) : ((N_R_4[j+7][0] > 0)? N_R_4[j+7][k] + (N_R_3[j+7][k]>>>j+8) : N_R_4[j+7][k] - (N_R_3[j+7][k]>>>j+8));
                2'd3: N_R_4[j+8][k] = (N_R_3[j+7][0] > 0)? ((N_R_4[j+7][0] > 0)? N_R_4[j+7][k] - (N_R_3[j+7][k]>>>j+8) : N_R_4[j+7][k] + (N_R_3[j+7][k]>>>j+8)) : ((N_R_4[j+7][0] > 0)? N_R_4[j+7][k] + (N_R_3[j+7][k]>>>j+8) : N_R_4[j+7][k] - (N_R_3[j+7][k]>>>j+8));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd0 && (Iteration_number == 5'd3 || Iteration_number == 5'd10 || Iteration_number == 5'd16 || Iteration_number == 5'd21))
            begin
                case (j)
                2'd0: N_R_4[j][k] = (R_4[0] > 0)? ((R_5[0] > 0)? R_4[k] + (R_5[k]>>>j) : R_4[k] - (R_5[k]>>>j)) : ((R_5[0] > 0)? -R_4[k] + (R_5[k]>>>j) : -R_4[k] - (R_5[k]>>>j));
                2'd1: N_R_4[j][k] = (N_R_4[j-1][0] > 0)? ((N_R_5[j-1][0] > 0)? N_R_4[j-1][k] + (N_R_5[j-1][k]>>>j) : N_R_4[j-1][k] - (N_R_5[j-1][k]>>>j)) : ((N_R_5[j-1][0] > 0)? -N_R_4[j-1][k] + (N_R_5[j-1][k]>>>j) : -N_R_4[j-1][k] - (N_R_5[j-1][k]>>>j));
                2'd2: N_R_4[j][k] = (N_R_4[j-1][0] > 0)? ((N_R_5[j-1][0] > 0)? N_R_4[j-1][k] + (N_R_5[j-1][k]>>>j) : N_R_4[j-1][k] - (N_R_5[j-1][k]>>>j)) : ((N_R_5[j-1][0] > 0)? -N_R_4[j-1][k] + (N_R_5[j-1][k]>>>j) : -N_R_4[j-1][k] - (N_R_5[j-1][k]>>>j));
                2'd3: N_R_4[j][k] = (N_R_4[j-1][0] > 0)? ((N_R_5[j-1][0] > 0)? N_R_4[j-1][k] + (N_R_5[j-1][k]>>>j) : N_R_4[j-1][k] - (N_R_5[j-1][k]>>>j)) : ((N_R_5[j-1][0] > 0)? -N_R_4[j-1][k] + (N_R_5[j-1][k]>>>j) : -N_R_4[j-1][k] - (N_R_5[j-1][k]>>>j));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd1 && (Iteration_number == 5'd3 || Iteration_number == 5'd10 || Iteration_number == 5'd16 || Iteration_number == 5'd21))
            begin
                case (j)
                2'd0: N_R_4[j+4][k] = (N_R_4[j+3][0] > 0)? ((N_R_5[j+3][0] > 0)? N_R_4[j+3][k] + (N_R_5[j+3][k]>>>j+4) : N_R_4[j+3][k] - (N_R_5[j+3][k]>>>j+4)) : ((N_R_5[j+3][0] > 0)? -N_R_4[j+3][k] + (N_R_5[j+3][k]>>>j+4) : -N_R_4[j+3][k] - (N_R_5[j+3][k]>>>j+4));
                2'd1: N_R_4[j+4][k] = (N_R_4[j+3][0] > 0)? ((N_R_5[j+3][0] > 0)? N_R_4[j+3][k] + (N_R_5[j+3][k]>>>j+4) : N_R_4[j+3][k] - (N_R_5[j+3][k]>>>j+4)) : ((N_R_5[j+3][0] > 0)? -N_R_4[j+3][k] + (N_R_5[j+3][k]>>>j+4) : -N_R_4[j+3][k] - (N_R_5[j+3][k]>>>j+4));
                2'd2: N_R_4[j+4][k] = (N_R_4[j+3][0] > 0)? ((N_R_5[j+3][0] > 0)? N_R_4[j+3][k] + (N_R_5[j+3][k]>>>j+4) : N_R_4[j+3][k] - (N_R_5[j+3][k]>>>j+4)) : ((N_R_5[j+3][0] > 0)? -N_R_4[j+3][k] + (N_R_5[j+3][k]>>>j+4) : -N_R_4[j+3][k] - (N_R_5[j+3][k]>>>j+4));
                2'd3: N_R_4[j+4][k] = (N_R_4[j+3][0] > 0)? ((N_R_5[j+3][0] > 0)? N_R_4[j+3][k] + (N_R_5[j+3][k]>>>j+4) : N_R_4[j+3][k] - (N_R_5[j+3][k]>>>j+4)) : ((N_R_5[j+3][0] > 0)? -N_R_4[j+3][k] + (N_R_5[j+3][k]>>>j+4) : -N_R_4[j+3][k] - (N_R_5[j+3][k]>>>j+4));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd2 && (Iteration_number == 5'd3 || Iteration_number == 5'd10 || Iteration_number == 5'd16 || Iteration_number == 5'd21))
            begin
                case (j)
                2'd0: N_R_4[j+8][k] = (N_R_4[j+7][0] > 0)? ((N_R_5[j+7][0] > 0)? N_R_4[j+7][k] + (N_R_5[j+7][k]>>>j+8) : N_R_4[j+7][k] - (N_R_5[j+7][k]>>>j+8)) : ((N_R_5[j+7][0] > 0)? -N_R_4[j+7][k] + (N_R_5[j+7][k]>>>j+8) : -N_R_4[j+7][k] - (N_R_5[j+7][k]>>>j+8));
                2'd1: N_R_4[j+8][k] = (N_R_4[j+7][0] > 0)? ((N_R_5[j+7][0] > 0)? N_R_4[j+7][k] + (N_R_5[j+7][k]>>>j+8) : N_R_4[j+7][k] - (N_R_5[j+7][k]>>>j+8)) : ((N_R_5[j+7][0] > 0)? -N_R_4[j+7][k] + (N_R_5[j+7][k]>>>j+8) : -N_R_4[j+7][k] - (N_R_5[j+7][k]>>>j+8));
                2'd2: N_R_4[j+8][k] = (N_R_4[j+7][0] > 0)? ((N_R_5[j+7][0] > 0)? N_R_4[j+7][k] + (N_R_5[j+7][k]>>>j+8) : N_R_4[j+7][k] - (N_R_5[j+7][k]>>>j+8)) : ((N_R_5[j+7][0] > 0)? -N_R_4[j+7][k] + (N_R_5[j+7][k]>>>j+8) : -N_R_4[j+7][k] - (N_R_5[j+7][k]>>>j+8));
                2'd3: N_R_4[j+8][k] = (N_R_4[j+7][0] > 0)? ((N_R_5[j+7][0] > 0)? N_R_4[j+7][k] + (N_R_5[j+7][k]>>>j+8) : N_R_4[j+7][k] - (N_R_5[j+7][k]>>>j+8)) : ((N_R_5[j+7][0] > 0)? -N_R_4[j+7][k] + (N_R_5[j+7][k]>>>j+8) : -N_R_4[j+7][k] - (N_R_5[j+7][k]>>>j+8));
                endcase
            end
        end
    end

for (j=0; j<4; j=j+1)
        for (k=0; k<4; k=k+1)
    begin: gen_block_NEW_R_5
        always @(*)
        begin 
            if (Current_state == QR && Counter_Iteratin == 2'd0 && (Iteration_number == 5'd3 || Iteration_number == 5'd10 || Iteration_number == 5'd16 || Iteration_number == 5'd21))
            begin
                case (j)
                2'd0: N_R_5[j][k] = (R_4[0] > 0)? ((R_5[0] > 0)? R_5[k] - (R_4[k]>>>j) : R_5[k] + (R_4[k]>>>j)) : ((R_5[0] > 0)? R_5[k] + (R_4[k]>>>j) : R_5[k] - (R_4[k]>>>j));
                2'd1: N_R_5[j][k] = (N_R_4[j-1][0] > 0)? ((N_R_5[j-1][0] > 0)? N_R_5[j-1][k] - (N_R_4[j-1][k]>>>j) : N_R_5[j-1][k] + (N_R_4[j-1][k]>>>j)) : ((N_R_5[j-1][0] > 0)? N_R_5[j-1][k] + (N_R_4[j-1][k]>>>j) : N_R_5[j-1][k] - (N_R_4[j-1][k]>>>j));
                2'd2: N_R_5[j][k] = (N_R_4[j-1][0] > 0)? ((N_R_5[j-1][0] > 0)? N_R_5[j-1][k] - (N_R_4[j-1][k]>>>j) : N_R_5[j-1][k] + (N_R_4[j-1][k]>>>j)) : ((N_R_5[j-1][0] > 0)? N_R_5[j-1][k] + (N_R_4[j-1][k]>>>j) : N_R_5[j-1][k] - (N_R_4[j-1][k]>>>j));
                2'd3: N_R_5[j][k] = (N_R_4[j-1][0] > 0)? ((N_R_5[j-1][0] > 0)? N_R_5[j-1][k] - (N_R_4[j-1][k]>>>j) : N_R_5[j-1][k] + (N_R_4[j-1][k]>>>j)) : ((N_R_5[j-1][0] > 0)? N_R_5[j-1][k] + (N_R_4[j-1][k]>>>j) : N_R_5[j-1][k] - (N_R_4[j-1][k]>>>j));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd1 && (Iteration_number == 5'd3 || Iteration_number == 5'd10 || Iteration_number == 5'd16 || Iteration_number == 5'd21))
            begin
                case (j)
                2'd0: N_R_5[j+4][k] = (N_R_4[j+3][0] > 0)? ((N_R_5[j+3][0] > 0)? N_R_5[j+3][k] - (N_R_4[j+3][k]>>>j+4) : N_R_5[j+3][k] + (N_R_4[j+3][k]>>>j+4)) : ((N_R_5[j+3][0] > 0)? N_R_5[j+3][k] + (N_R_4[j+3][k]>>>j+4) : N_R_5[j+3][k] - (N_R_4[j+3][k]>>>j+4));
                2'd1: N_R_5[j+4][k] = (N_R_4[j+3][0] > 0)? ((N_R_5[j+3][0] > 0)? N_R_5[j+3][k] - (N_R_4[j+3][k]>>>j+4) : N_R_5[j+3][k] + (N_R_4[j+3][k]>>>j+4)) : ((N_R_5[j+3][0] > 0)? N_R_5[j+3][k] + (N_R_4[j+3][k]>>>j+4) : N_R_5[j+3][k] - (N_R_4[j+3][k]>>>j+4));
                2'd2: N_R_5[j+4][k] = (N_R_4[j+3][0] > 0)? ((N_R_5[j+3][0] > 0)? N_R_5[j+3][k] - (N_R_4[j+3][k]>>>j+4) : N_R_5[j+3][k] + (N_R_4[j+3][k]>>>j+4)) : ((N_R_5[j+3][0] > 0)? N_R_5[j+3][k] + (N_R_4[j+3][k]>>>j+4) : N_R_5[j+3][k] - (N_R_4[j+3][k]>>>j+4));
                2'd3: N_R_5[j+4][k] = (N_R_4[j+3][0] > 0)? ((N_R_5[j+3][0] > 0)? N_R_5[j+3][k] - (N_R_4[j+3][k]>>>j+4) : N_R_5[j+3][k] + (N_R_4[j+3][k]>>>j+4)) : ((N_R_5[j+3][0] > 0)? N_R_5[j+3][k] + (N_R_4[j+3][k]>>>j+4) : N_R_5[j+3][k] - (N_R_4[j+3][k]>>>j+4));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd2 && (Iteration_number == 5'd3 || Iteration_number == 5'd10 || Iteration_number == 5'd16 || Iteration_number == 5'd21))
            begin
                case (j)
                2'd0: N_R_5[j+8][k] = (N_R_4[j+7][0] > 0)? ((N_R_5[j+7][0] > 0)? N_R_5[j+7][k] - (N_R_4[j+7][k]>>>j+8) : N_R_5[j+7][k] + (N_R_4[j+7][k]>>>j+8)) : ((N_R_5[j+7][0] > 0)? N_R_5[j+7][k] + (N_R_4[j+7][k]>>>j+8) : N_R_5[j+7][k] - (N_R_4[j+7][k]>>>j+8));
                2'd1: N_R_5[j+8][k] = (N_R_4[j+7][0] > 0)? ((N_R_5[j+7][0] > 0)? N_R_5[j+7][k] - (N_R_4[j+7][k]>>>j+8) : N_R_5[j+7][k] + (N_R_4[j+7][k]>>>j+8)) : ((N_R_5[j+7][0] > 0)? N_R_5[j+7][k] + (N_R_4[j+7][k]>>>j+8) : N_R_5[j+7][k] - (N_R_4[j+7][k]>>>j+8));
                2'd2: N_R_5[j+8][k] = (N_R_4[j+7][0] > 0)? ((N_R_5[j+7][0] > 0)? N_R_5[j+7][k] - (N_R_4[j+7][k]>>>j+8) : N_R_5[j+7][k] + (N_R_4[j+7][k]>>>j+8)) : ((N_R_5[j+7][0] > 0)? N_R_5[j+7][k] + (N_R_4[j+7][k]>>>j+8) : N_R_5[j+7][k] - (N_R_4[j+7][k]>>>j+8));
                2'd3: N_R_5[j+8][k] = (N_R_4[j+7][0] > 0)? ((N_R_5[j+7][0] > 0)? N_R_5[j+7][k] - (N_R_4[j+7][k]>>>j+8) : N_R_5[j+7][k] + (N_R_4[j+7][k]>>>j+8)) : ((N_R_5[j+7][0] > 0)? N_R_5[j+7][k] + (N_R_4[j+7][k]>>>j+8) : N_R_5[j+7][k] - (N_R_4[j+7][k]>>>j+8));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd0 && (Iteration_number == 5'd2 || Iteration_number == 5'd9 || Iteration_number == 5'd15 || Iteration_number == 5'd20))
            begin
                case (j)
                2'd0: N_R_5[j][k] = (R_5[0] > 0)? ((R_6[0] > 0)? R_5[k] + (R_6[k]>>>j) : R_5[k] - (R_6[k]>>>j)) : ((R_6[0] > 0)? -R_5[k] + (R_6[k]>>>j) : -R_5[k] - (R_6[k]>>>j));
                2'd1: N_R_5[j][k] = (N_R_5[j-1][0] > 0)? ((N_R_6[j-1][0] > 0)? N_R_5[j-1][k] + (N_R_6[j-1][k]>>>j) : N_R_5[j-1][k] - (N_R_6[j-1][k]>>>j)) : ((N_R_6[j-1][0] > 0)? -N_R_5[j-1][k] + (N_R_6[j-1][k]>>>j) : -N_R_5[j-1][k] - (N_R_6[j-1][k]>>>j));
                2'd2: N_R_5[j][k] = (N_R_5[j-1][0] > 0)? ((N_R_6[j-1][0] > 0)? N_R_5[j-1][k] + (N_R_6[j-1][k]>>>j) : N_R_5[j-1][k] - (N_R_6[j-1][k]>>>j)) : ((N_R_6[j-1][0] > 0)? -N_R_5[j-1][k] + (N_R_6[j-1][k]>>>j) : -N_R_5[j-1][k] - (N_R_6[j-1][k]>>>j));
                2'd3: N_R_5[j][k] = (N_R_5[j-1][0] > 0)? ((N_R_6[j-1][0] > 0)? N_R_5[j-1][k] + (N_R_6[j-1][k]>>>j) : N_R_5[j-1][k] - (N_R_6[j-1][k]>>>j)) : ((N_R_6[j-1][0] > 0)? -N_R_5[j-1][k] + (N_R_6[j-1][k]>>>j) : -N_R_5[j-1][k] - (N_R_6[j-1][k]>>>j));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd1 && (Iteration_number == 5'd2 || Iteration_number == 5'd9 || Iteration_number == 5'd15 || Iteration_number == 5'd20))
            begin
                case (j)
                2'd0: N_R_5[j+4][k] = (N_R_5[j+3][0] > 0)? ((N_R_6[j+3][0] > 0)? N_R_5[j+3][k] + (N_R_6[j+3][k]>>>j+4) : N_R_5[j+3][k] - (N_R_6[j+3][k]>>>j+4)) : ((N_R_6[j+3][0] > 0)? -N_R_5[j+3][k] + (N_R_6[j+3][k]>>>j+4) : -N_R_5[j+3][k] - (N_R_6[j+3][k]>>>j+4));
                2'd1: N_R_5[j+4][k] = (N_R_5[j+3][0] > 0)? ((N_R_6[j+3][0] > 0)? N_R_5[j+3][k] + (N_R_6[j+3][k]>>>j+4) : N_R_5[j+3][k] - (N_R_6[j+3][k]>>>j+4)) : ((N_R_6[j+3][0] > 0)? -N_R_5[j+3][k] + (N_R_6[j+3][k]>>>j+4) : -N_R_5[j+3][k] - (N_R_6[j+3][k]>>>j+4));
                2'd2: N_R_5[j+4][k] = (N_R_5[j+3][0] > 0)? ((N_R_6[j+3][0] > 0)? N_R_5[j+3][k] + (N_R_6[j+3][k]>>>j+4) : N_R_5[j+3][k] - (N_R_6[j+3][k]>>>j+4)) : ((N_R_6[j+3][0] > 0)? -N_R_5[j+3][k] + (N_R_6[j+3][k]>>>j+4) : -N_R_5[j+3][k] - (N_R_6[j+3][k]>>>j+4));
                2'd3: N_R_5[j+4][k] = (N_R_5[j+3][0] > 0)? ((N_R_6[j+3][0] > 0)? N_R_5[j+3][k] + (N_R_6[j+3][k]>>>j+4) : N_R_5[j+3][k] - (N_R_6[j+3][k]>>>j+4)) : ((N_R_6[j+3][0] > 0)? -N_R_5[j+3][k] + (N_R_6[j+3][k]>>>j+4) : -N_R_5[j+3][k] - (N_R_6[j+3][k]>>>j+4));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd2 && (Iteration_number == 5'd2 || Iteration_number == 5'd9 || Iteration_number == 5'd15 || Iteration_number == 5'd20))
            begin
                case (j)
                2'd0: N_R_5[j+8][k] = (N_R_5[j+7][0] > 0)? ((N_R_6[j+7][0] > 0)? N_R_5[j+7][k] + (N_R_6[j+7][k]>>>j+8) : N_R_5[j+7][k] - (N_R_6[j+7][k]>>>j+8)) : ((N_R_6[j+7][0] > 0)? -N_R_5[j+7][k] + (N_R_6[j+7][k]>>>j+8) : -N_R_5[j+7][k] - (N_R_6[j+7][k]>>>j+8));
                2'd1: N_R_5[j+8][k] = (N_R_5[j+7][0] > 0)? ((N_R_6[j+7][0] > 0)? N_R_5[j+7][k] + (N_R_6[j+7][k]>>>j+8) : N_R_5[j+7][k] - (N_R_6[j+7][k]>>>j+8)) : ((N_R_6[j+7][0] > 0)? -N_R_5[j+7][k] + (N_R_6[j+7][k]>>>j+8) : -N_R_5[j+7][k] - (N_R_6[j+7][k]>>>j+8));
                2'd2: N_R_5[j+8][k] = (N_R_5[j+7][0] > 0)? ((N_R_6[j+7][0] > 0)? N_R_5[j+7][k] + (N_R_6[j+7][k]>>>j+8) : N_R_5[j+7][k] - (N_R_6[j+7][k]>>>j+8)) : ((N_R_6[j+7][0] > 0)? -N_R_5[j+7][k] + (N_R_6[j+7][k]>>>j+8) : -N_R_5[j+7][k] - (N_R_6[j+7][k]>>>j+8));
                2'd3: N_R_5[j+8][k] = (N_R_5[j+7][0] > 0)? ((N_R_6[j+7][0] > 0)? N_R_5[j+7][k] + (N_R_6[j+7][k]>>>j+8) : N_R_5[j+7][k] - (N_R_6[j+7][k]>>>j+8)) : ((N_R_6[j+7][0] > 0)? -N_R_5[j+7][k] + (N_R_6[j+7][k]>>>j+8) : -N_R_5[j+7][k] - (N_R_6[j+7][k]>>>j+8));
                endcase
            end
        end
    end

for (j=0; j<4; j=j+1)
        for (k=0; k<4; k=k+1)
    begin: gen_block_NEW_R_6
        always @(*)
        begin 
            if (Current_state == QR && Counter_Iteratin == 2'd0 && (Iteration_number == 5'd2 || Iteration_number == 5'd9 || Iteration_number == 5'd15 || Iteration_number == 5'd20))
            begin
                case (j)
                2'd0: N_R_6[j][k] = (R_5[0] > 0)? ((R_6[0] > 0)? R_6[k] - (R_5[k]>>>j) : R_6[k] + (R_5[k]>>>j)) : ((R_6[0] > 0)? R_6[k] + (R_5[k]>>>j) : R_6[k] - (R_5[k]>>>j));
                2'd1: N_R_6[j][k] = (N_R_5[j-1][0] > 0)? ((N_R_6[j-1][0] > 0)? N_R_6[j-1][k] - (N_R_5[j-1][k]>>>j) : N_R_6[j-1][k] + (N_R_5[j-1][k]>>>j)) : ((N_R_6[j-1][0] > 0)? N_R_6[j-1][k] + (N_R_5[j-1][k]>>>j) : N_R_6[j-1][k] - (N_R_5[j-1][k]>>>j));
                2'd2: N_R_6[j][k] = (N_R_5[j-1][0] > 0)? ((N_R_6[j-1][0] > 0)? N_R_6[j-1][k] - (N_R_5[j-1][k]>>>j) : N_R_6[j-1][k] + (N_R_5[j-1][k]>>>j)) : ((N_R_6[j-1][0] > 0)? N_R_6[j-1][k] + (N_R_5[j-1][k]>>>j) : N_R_6[j-1][k] - (N_R_5[j-1][k]>>>j));
                2'd3: N_R_6[j][k] = (N_R_5[j-1][0] > 0)? ((N_R_6[j-1][0] > 0)? N_R_6[j-1][k] - (N_R_5[j-1][k]>>>j) : N_R_6[j-1][k] + (N_R_5[j-1][k]>>>j)) : ((N_R_6[j-1][0] > 0)? N_R_6[j-1][k] + (N_R_5[j-1][k]>>>j) : N_R_6[j-1][k] - (N_R_5[j-1][k]>>>j));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd1 && (Iteration_number == 5'd2 || Iteration_number == 5'd9 || Iteration_number == 5'd15 || Iteration_number == 5'd20))
            begin
                case (j)
                2'd0: N_R_6[j+4][k] = (N_R_5[j+3][0] > 0)? ((N_R_6[j+3][0] > 0)? N_R_6[j+3][k] - (N_R_5[j+3][k]>>>j+4) : N_R_6[j+3][k] + (N_R_5[j+3][k]>>>j+4)) : ((N_R_6[j+3][0] > 0)? N_R_6[j+3][k] + (N_R_5[j+3][k]>>>j+4) : N_R_6[j+3][k] - (N_R_5[j+3][k]>>>j+4));
                2'd1: N_R_6[j+4][k] = (N_R_5[j+3][0] > 0)? ((N_R_6[j+3][0] > 0)? N_R_6[j+3][k] - (N_R_5[j+3][k]>>>j+4) : N_R_6[j+3][k] + (N_R_5[j+3][k]>>>j+4)) : ((N_R_6[j+3][0] > 0)? N_R_6[j+3][k] + (N_R_5[j+3][k]>>>j+4) : N_R_6[j+3][k] - (N_R_5[j+3][k]>>>j+4));
                2'd2: N_R_6[j+4][k] = (N_R_5[j+3][0] > 0)? ((N_R_6[j+3][0] > 0)? N_R_6[j+3][k] - (N_R_5[j+3][k]>>>j+4) : N_R_6[j+3][k] + (N_R_5[j+3][k]>>>j+4)) : ((N_R_6[j+3][0] > 0)? N_R_6[j+3][k] + (N_R_5[j+3][k]>>>j+4) : N_R_6[j+3][k] - (N_R_5[j+3][k]>>>j+4));
                2'd3: N_R_6[j+4][k] = (N_R_5[j+3][0] > 0)? ((N_R_6[j+3][0] > 0)? N_R_6[j+3][k] - (N_R_5[j+3][k]>>>j+4) : N_R_6[j+3][k] + (N_R_5[j+3][k]>>>j+4)) : ((N_R_6[j+3][0] > 0)? N_R_6[j+3][k] + (N_R_5[j+3][k]>>>j+4) : N_R_6[j+3][k] - (N_R_5[j+3][k]>>>j+4));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd2 && (Iteration_number == 5'd2 || Iteration_number == 5'd9 || Iteration_number == 5'd15 ||Iteration_number == 5'd20))
            begin
                case (j)
                2'd0: N_R_6[j+8][k] = (N_R_5[j+7][0] > 0)? ((N_R_6[j+7][0] > 0)? N_R_6[j+7][k] - (N_R_5[j+7][k]>>>j+8) : N_R_6[j+7][k] + (N_R_5[j+7][k]>>>j+8)) : ((N_R_6[j+7][0] > 0)? N_R_6[j+7][k] + (N_R_5[j+7][k]>>>j+8) : N_R_6[j+7][k] - (N_R_5[j+7][k]>>>j+8));
                2'd1: N_R_6[j+8][k] = (N_R_5[j+7][0] > 0)? ((N_R_6[j+7][0] > 0)? N_R_6[j+7][k] - (N_R_5[j+7][k]>>>j+8) : N_R_6[j+7][k] + (N_R_5[j+7][k]>>>j+8)) : ((N_R_6[j+7][0] > 0)? N_R_6[j+7][k] + (N_R_5[j+7][k]>>>j+8) : N_R_6[j+7][k] - (N_R_5[j+7][k]>>>j+8));
                2'd2: N_R_6[j+8][k] = (N_R_5[j+7][0] > 0)? ((N_R_6[j+7][0] > 0)? N_R_6[j+7][k] - (N_R_5[j+7][k]>>>j+8) : N_R_6[j+7][k] + (N_R_5[j+7][k]>>>j+8)) : ((N_R_6[j+7][0] > 0)? N_R_6[j+7][k] + (N_R_5[j+7][k]>>>j+8) : N_R_6[j+7][k] - (N_R_5[j+7][k]>>>j+8));
                2'd3: N_R_6[j+8][k] = (N_R_5[j+7][0] > 0)? ((N_R_6[j+7][0] > 0)? N_R_6[j+7][k] - (N_R_5[j+7][k]>>>j+8) : N_R_6[j+7][k] + (N_R_5[j+7][k]>>>j+8)) : ((N_R_6[j+7][0] > 0)? N_R_6[j+7][k] + (N_R_5[j+7][k]>>>j+8) : N_R_6[j+7][k] - (N_R_5[j+7][k]>>>j+8));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd0 && (Iteration_number == 5'd1 || Iteration_number == 5'd8 || Iteration_number == 5'd14 || Iteration_number == 5'd19))
            begin
                case (j)
                2'd0: N_R_6[j][k] = (R_6[0] > 0)? ((R_7[0] > 0)? R_6[k] + (R_7[k]>>>j) : R_6[k] - (R_7[j+1][k]>>>j)) : ((R_7[0] > 0)? -R_6[k] + (R_7[k]>>>j) : -R_6[k] - (R_7[j+1][k]>>>j));
                2'd1: N_R_6[j][k] = (N_R_6[j-1][0] > 0)? ((N_R_7[j-1][0] > 0)? N_R_6[j-1][k] + (N_R_7[j-1][k]>>>j) : N_R_6[j-1][k] - (N_R_7[j-1][k]>>>j)) : ((N_R_7[j-1][0] > 0)? -N_R_6[j-1][k] + (N_R_7[j-1][k]>>>j) : -N_R_6[j-1][k] - (N_R_7[j-1][k]>>>j));
                2'd2: N_R_6[j][k] = (N_R_6[j-1][0] > 0)? ((N_R_7[j-1][0] > 0)? N_R_6[j-1][k] + (N_R_7[j-1][k]>>>j) : N_R_6[j-1][k] - (N_R_7[j-1][k]>>>j)) : ((N_R_7[j-1][0] > 0)? -N_R_6[j-1][k] + (N_R_7[j-1][k]>>>j) : -N_R_6[j-1][k] - (N_R_7[j-1][k]>>>j));
                2'd3: N_R_6[j][k] = (N_R_6[j-1][0] > 0)? ((N_R_7[j-1][0] > 0)? N_R_6[j-1][k] + (N_R_7[j-1][k]>>>j) : N_R_6[j-1][k] - (N_R_7[j-1][k]>>>j)) : ((N_R_7[j-1][0] > 0)? -N_R_6[j-1][k] + (N_R_7[j-1][k]>>>j) : -N_R_6[j-1][k] - (N_R_7[j-1][k]>>>j));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd1 && (Iteration_number == 5'd1 || Iteration_number == 5'd8 || Iteration_number == 5'd14 || Iteration_number == 5'd19))
            begin
                case (j)
                2'd0: N_R_6[j+4][k] = (N_R_6[j+3][0] > 0)? ((N_R_7[j+3][0] > 0)? N_R_6[j+3][k] + (N_R_7[j+3][k]>>>j+4) : N_R_6[j+3][k] - (N_R_7[j+3][k]>>>j+4)) : ((N_R_7[j+3][0] > 0)? -N_R_6[j+3][k] + (N_R_7[j+3][k]>>>j+4) : -N_R_6[j+3][k] - (N_R_7[j+3][k]>>>j+4));
                2'd1: N_R_6[j+4][k] = (N_R_6[j+3][0] > 0)? ((N_R_7[j+3][0] > 0)? N_R_6[j+3][k] + (N_R_7[j+3][k]>>>j+4) : N_R_6[j+3][k] - (N_R_7[j+3][k]>>>j+4)) : ((N_R_7[j+3][0] > 0)? -N_R_6[j+3][k] + (N_R_7[j+3][k]>>>j+4) : -N_R_6[j+3][k] - (N_R_7[j+3][k]>>>j+4));
                2'd2: N_R_6[j+4][k] = (N_R_6[j+3][0] > 0)? ((N_R_7[j+3][0] > 0)? N_R_6[j+3][k] + (N_R_7[j+3][k]>>>j+4) : N_R_6[j+3][k] - (N_R_7[j+3][k]>>>j+4)) : ((N_R_7[j+3][0] > 0)? -N_R_6[j+3][k] + (N_R_7[j+3][k]>>>j+4) : -N_R_6[j+3][k] - (N_R_7[j+3][k]>>>j+4));
                2'd3: N_R_6[j+4][k] = (N_R_6[j+3][0] > 0)? ((N_R_7[j+3][0] > 0)? N_R_6[j+3][k] + (N_R_7[j+3][k]>>>j+4) : N_R_6[j+3][k] - (N_R_7[j+3][k]>>>j+4)) : ((N_R_7[j+3][0] > 0)? -N_R_6[j+3][k] + (N_R_7[j+3][k]>>>j+4) : -N_R_6[j+3][k] - (N_R_7[j+3][k]>>>j+4));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd2 && (Iteration_number == 5'd1 || Iteration_number == 5'd8 || Iteration_number == 5'd14 ||Iteration_number == 5'd19))
            begin
                case (j)
                2'd0: N_R_6[j+8][k] = (N_R_6[j+7][0] > 0)? ((N_R_7[j+7][0] > 0)? N_R_6[j+7][k] + (N_R_7[j+7][k]>>>j+8) : N_R_6[j+7][k] - (N_R_7[j+7][k]>>>j+8)) : ((N_R_7[j+7][0] > 0)? -N_R_6[j+7][k] + (N_R_7[j+7][k]>>>j+8) : -N_R_6[j+7][k] - (N_R_7[j+7][k]>>>j+8));
                2'd1: N_R_6[j+8][k] = (N_R_6[j+7][0] > 0)? ((N_R_7[j+7][0] > 0)? N_R_6[j+7][k] + (N_R_7[j+7][k]>>>j+8) : N_R_6[j+7][k] - (N_R_7[j+7][k]>>>j+8)) : ((N_R_7[j+7][0] > 0)? -N_R_6[j+7][k] + (N_R_7[j+7][k]>>>j+8) : -N_R_6[j+7][k] - (N_R_7[j+7][k]>>>j+8));
                2'd2: N_R_6[j+8][k] = (N_R_6[j+7][0] > 0)? ((N_R_7[j+7][0] > 0)? N_R_6[j+7][k] + (N_R_7[j+7][k]>>>j+8) : N_R_6[j+7][k] - (N_R_7[j+7][k]>>>j+8)) : ((N_R_7[j+7][0] > 0)? -N_R_6[j+7][k] + (N_R_7[j+7][k]>>>j+8) : -N_R_6[j+7][k] - (N_R_7[j+7][k]>>>j+8));
                2'd3: N_R_6[j+8][k] = (N_R_6[j+7][0] > 0)? ((N_R_7[j+7][0] > 0)? N_R_6[j+7][k] + (N_R_7[j+7][k]>>>j+8) : N_R_6[j+7][k] - (N_R_7[j+7][k]>>>j+8)) : ((N_R_7[j+7][0] > 0)? -N_R_6[j+7][k] + (N_R_7[j+7][k]>>>j+8) : -N_R_6[j+7][k] - (N_R_7[j+7][k]>>>j+8));
                endcase
            end
        end
    end

for (j=0; j<4; j=j+1)
        for (k=0; k<4; k=k+1)
    begin : gen_block_NEW_R_7
        always @(*)
        begin
            if (Current_state == QR && Counter_Iteratin == 2'd0 && (Iteration_number == 5'd1 || Iteration_number == 5'd8 || Iteration_number == 5'd14 ||Iteration_number == 5'd19))
            begin
                case (j)
                2'd0: N_R_7[j][k] = (R_6[0] > 0)? ((R_7[0] > 0)? R_7[k] - (R_6[k]>>>j) : R_7[k] + (R_6[k]>>>j)) : ((R_7[0] > 0)? R_7[k] + (R_6[k]>>>j) : R_7[k] - (R_6[k]>>>j));
                2'd1: N_R_7[j][k] = (N_R_6[j-1][0] > 0)? ((N_R_7[j-1][0] > 0)? N_R_7[j-1][k] - (N_R_6[j-1][k]>>>j) : N_R_7[j-1][k] + (N_R_6[j-1][k]>>>j)) : ((N_R_7[j-1][0] > 0)? N_R_7[j-1][k] + (N_R_6[j-1][k]>>>j) : N_R_7[j-1][k] - (N_R_6[j-1][k]>>>j));
                2'd2: N_R_7[j][k] = (N_R_6[j-1][0] > 0)? ((N_R_7[j-1][0] > 0)? N_R_7[j-1][k] - (N_R_6[j-1][k]>>>j) : N_R_7[j-1][k] + (N_R_6[j-1][k]>>>j)) : ((N_R_7[j-1][0] > 0)? N_R_7[j-1][k] + (N_R_6[j-1][k]>>>j) : N_R_7[j-1][k] - (N_R_6[j-1][k]>>>j));
                2'd3: N_R_7[j][k] = (N_R_6[j-1][0] > 0)? ((N_R_7[j-1][0] > 0)? N_R_7[j-1][k] - (N_R_6[j-1][k]>>>j) : N_R_7[j-1][k] + (N_R_6[j-1][k]>>>j)) : ((N_R_7[j-1][0] > 0)? N_R_7[j-1][k] + (N_R_6[j-1][k]>>>j) : N_R_7[j-1][k] - (N_R_6[j-1][k]>>>j));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd1 && (Iteration_number == 5'd1 || Iteration_number == 5'd8 || Iteration_number == 5'd14 ||Iteration_number == 5'd19))
            begin
                case (j)
                2'd0: N_R_7[j+4][k] = (N_R_6[j+3][0] > 0)? ((N_R_7[j+3][0] > 0)? N_R_7[j+3][k] - (N_R_6[j+3][k]>>>j+4) : N_R_7[j+3][k] + (N_R_6[j+3][k]>>>j+4)) : ((N_R_7[j+3][0] > 0)? N_R_7[j+3][k] + (N_R_6[j+3][k]>>>j+4) : N_R_7[j+3][k] - (N_R_6[j+3][k]>>>j+4));
                2'd1: N_R_7[j+4][k] = (N_R_6[j+3][0] > 0)? ((N_R_7[j+3][0] > 0)? N_R_7[j+3][k] - (N_R_6[j+3][k]>>>j+4) : N_R_7[j+3][k] + (N_R_6[j+3][k]>>>j+4)) : ((N_R_7[j+3][0] > 0)? N_R_7[j+3][k] + (N_R_6[j+3][k]>>>j+4) : N_R_7[j+3][k] - (N_R_6[j+3][k]>>>j+4));
                2'd2: N_R_7[j+4][k] = (N_R_6[j+3][0] > 0)? ((N_R_7[j+3][0] > 0)? N_R_7[j+3][k] - (N_R_6[j+3][k]>>>j+4) : N_R_7[j+3][k] + (N_R_6[j+3][k]>>>j+4)) : ((N_R_7[j+3][0] > 0)? N_R_7[j+3][k] + (N_R_6[j+3][k]>>>j+4) : N_R_7[j+3][k] - (N_R_6[j+3][k]>>>j+4));
                2'd3: N_R_7[j+4][k] = (N_R_6[j+3][0] > 0)? ((N_R_7[j+3][0] > 0)? N_R_7[j+3][k] - (N_R_6[j+3][k]>>>j+4) : N_R_7[j+3][k] + (N_R_6[j+3][k]>>>j+4)) : ((N_R_7[j+3][0] > 0)? N_R_7[j+3][k] + (N_R_6[j+3][k]>>>j+4) : N_R_7[j+3][k] - (N_R_6[j+3][k]>>>j+4));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd2 && (Iteration_number == 5'd1 || Iteration_number == 5'd8 || Iteration_number == 5'd14 ||Iteration_number == 5'd19))
            begin
                case (j)
                2'd0: N_R_7[j+8][k] = (N_R_6[j+7][0] > 0)? ((N_R_7[j+7][0] > 0)? N_R_7[j+7][k] - (N_R_6[j+7][k]>>>j+8) : N_R_7[j+7][k] + (N_R_6[j+7][k]>>>j+8)) : ((N_R_7[j+7][0] > 0)? N_R_7[j+7][k] + (N_R_6[j+7][k]>>>j+8) : N_R_7[j+7][k] - (N_R_6[j+7][k]>>>j+8));
                2'd1: N_R_7[j+8][k] = (N_R_6[j+7][0] > 0)? ((N_R_7[j+7][0] > 0)? N_R_7[j+7][k] - (N_R_6[j+7][k]>>>j+8) : N_R_7[j+7][k] + (N_R_6[j+7][k]>>>j+8)) : ((N_R_7[j+7][0] > 0)? N_R_7[j+7][k] + (N_R_6[j+7][k]>>>j+8) : N_R_7[j+7][k] - (N_R_6[j+7][k]>>>j+8));
                2'd2: N_R_7[j+8][k] = (N_R_6[j+7][0] > 0)? ((N_R_7[j+7][0] > 0)? N_R_7[j+7][k] - (N_R_6[j+7][k]>>>j+8) : N_R_7[j+7][k] + (N_R_6[j+7][k]>>>j+8)) : ((N_R_7[j+7][0] > 0)? N_R_7[j+7][k] + (N_R_6[j+7][k]>>>j+8) : N_R_7[j+7][k] - (N_R_6[j+7][k]>>>j+8));
                2'd3: N_R_7[j+8][k] = (N_R_6[j+7][0] > 0)? ((N_R_7[j+7][0] > 0)? N_R_7[j+7][k] - (N_R_6[j+7][k]>>>j+8) : N_R_7[j+7][k] + (N_R_6[j+7][k]>>>j+8)) : ((N_R_7[j+7][0] > 0)? N_R_7[j+7][k] + (N_R_6[j+7][k]>>>j+8) : N_R_7[j+7][k] - (N_R_6[j+7][k]>>>j+8));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd0 && (Iteration_number == 5'd0 || Iteration_number == 5'd7 || Iteration_number == 5'd13 ||Iteration_number == 5'd18))
            begin
                case (j)
                2'd0: N_R_7[j][k] = (R_7[0] > 0)? ((R_8[0] > 0)? R_7[k] + (R_8[k]>>>j) : R_7[k] - (R_8[k]>>>j)) : ((R_8[0] > 0)? -R_7[k] + (R_8[k]>>>j) : -R_7[k] - (R_8[k]>>>j));
                2'd1: N_R_7[j][k] = (N_R_7[j-1][0] > 0)? ((N_R_8[j-1][0] > 0)? N_R_7[j-1][k] + (N_R_8[j-1][k]>>>j) : N_R_7[j-1][k] - (N_R_8[j-1][k]>>>j))  : ((N_R_8[j-1][0] > 0)? -N_R_7[j-1][k] + (N_R_8[j-1][k]>>>j) : -N_R_7[j-1][k] - (N_R_8[j-1][k]>>>j));
                2'd2: N_R_7[j][k] = (N_R_7[j-1][0] > 0)? ((N_R_8[j-1][0] > 0)? N_R_7[j-1][k] + (N_R_8[j-1][k]>>>j) : N_R_7[j-1][k] - (N_R_8[j-1][k]>>>j))  : ((N_R_8[j-1][0] > 0)? -N_R_7[j-1][k] + (N_R_8[j-1][k]>>>j) : -N_R_7[j-1][k] - (N_R_8[j-1][k]>>>j));
                2'd3: N_R_7[j][k] = (N_R_7[j-1][0] > 0)? ((N_R_8[j-1][0] > 0)? N_R_7[j-1][k] + (N_R_8[j-1][k]>>>j) : N_R_7[j-1][k] - (N_R_8[j-1][k]>>>j))  : ((N_R_8[j-1][0] > 0)? -N_R_7[j-1][k] + (N_R_8[j-1][k]>>>j) : -N_R_7[j-1][k] - (N_R_8[j-1][k]>>>j));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd1 && (Iteration_number == 5'd0 || Iteration_number == 5'd7 || Iteration_number == 5'd13 ||Iteration_number == 5'd18))
            begin
                case (j)
                2'd0: N_R_7[j+4][k] = (N_R_7[j+3][0] > 0)? ((N_R_8[j+3][0] > 0)? N_R_7[j+3][k] + (N_R_8[j+3][k]>>>j+4) : N_R_7[j+3][k] - (N_R_8[j+3][k]>>>j+4)) : ((N_R_8[j+3][0] > 0)? -N_R_7[j+3][k] + (N_R_8[j+3][k]>>>j+4) : -N_R_7[j+3][k] - (N_R_8[j+3][k]>>>j+4));
                2'd1: N_R_7[j+4][k] = (N_R_7[j+3][0] > 0)? ((N_R_8[j+3][0] > 0)? N_R_7[j+3][k] + (N_R_8[j+3][k]>>>j+4) : N_R_7[j+3][k] - (N_R_8[j+3][k]>>>j+4)) : ((N_R_8[j+3][0] > 0)? -N_R_7[j+3][k] + (N_R_8[j+3][k]>>>j+4) : -N_R_7[j+3][k] - (N_R_8[j+3][k]>>>j+4));
                2'd2: N_R_7[j+4][k] = (N_R_7[j+3][0] > 0)? ((N_R_8[j+3][0] > 0)? N_R_7[j+3][k] + (N_R_8[j+3][k]>>>j+4) : N_R_7[j+3][k] - (N_R_8[j+3][k]>>>j+4)) : ((N_R_8[j+3][0] > 0)? -N_R_7[j+3][k] + (N_R_8[j+3][k]>>>j+4) : -N_R_7[j+3][k] - (N_R_8[j+3][k]>>>j+4));
                2'd3: N_R_7[j+4][k] = (N_R_7[j+3][0] > 0)? ((N_R_8[j+3][0] > 0)? N_R_7[j+3][k] + (N_R_8[j+3][k]>>>j+4) : N_R_7[j+3][k] - (N_R_8[j+3][k]>>>j+4)) : ((N_R_8[j+3][0] > 0)? -N_R_7[j+3][k] + (N_R_8[j+3][k]>>>j+4) : -N_R_7[j+3][k] - (N_R_8[j+3][k]>>>j+4));
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd2 && (Iteration_number == 5'd0 || Iteration_number == 5'd7 || Iteration_number == 5'd13 ||Iteration_number == 5'd18))
            begin
                case (j)
                2'd0: N_R_7[j+8][k] = (N_R_7[j+7][0] > 0)? ((N_R_8[j+7][0] > 0)? N_R_7[j+7][k] + (N_R_8[j+7][k]>>>j+8) : N_R_7[j+7][k] - (N_R_8[j+7][k]>>>j+8)) : ((N_R_8[j+7][0] > 0)? -N_R_7[j+7][k] + (N_R_8[j+7][k]>>>j+8) : -N_R_7[j+7][k] - (N_R_8[j+7][k]>>>j+8));
                2'd1: N_R_7[j+8][k] = (N_R_7[j+7][0] > 0)? ((N_R_8[j+7][0] > 0)? N_R_7[j+7][k] + (N_R_8[j+7][k]>>>j+8) : N_R_7[j+7][k] - (N_R_8[j+7][k]>>>j+8)) : ((N_R_8[j+7][0] > 0)? -N_R_7[j+7][k] + (N_R_8[j+7][k]>>>j+8) : -N_R_7[j+7][k] - (N_R_8[j+7][k]>>>j+8));
                2'd2: N_R_7[j+8][k] = (N_R_7[j+7][0] > 0)? ((N_R_8[j+7][0] > 0)? N_R_7[j+7][k] + (N_R_8[j+7][k]>>>j+8) : N_R_7[j+7][k] - (N_R_8[j+7][k]>>>j+8)) : ((N_R_8[j+7][0] > 0)? -N_R_7[j+7][k] + (N_R_8[j+7][k]>>>j+8) : -N_R_7[j+7][k] - (N_R_8[j+7][k]>>>j+8));
                2'd3: N_R_7[j+8][k] = (N_R_7[j+7][0] > 0)? ((N_R_8[j+7][0] > 0)? N_R_7[j+7][k] + (N_R_8[j+7][k]>>>j+8) : N_R_7[j+7][k] - (N_R_8[j+7][k]>>>j+8)) : ((N_R_8[j+7][0] > 0)? -N_R_7[j+7][k] + (N_R_8[j+7][k]>>>j+8) : -N_R_7[j+7][k] - (N_R_8[j+7][k]>>>j+8));
                endcase
            end
        end
    end

    for (j=0; j<4; j=j+1)
        for (k=0; k<4; k=k+1)
    begin : gen_block_NEW_R_8
        always @(*)
        begin
            if (Current_state == QR && Counter_Iteratin == 2'd0 && (Iteration_number == 5'd0 || Iteration_number == 5'd7 || Iteration_number == 5'd13 ||Iteration_number == 5'd18))
            begin
                case (j)
                2'd0: N_R_8[j][k] = (R_7[0] > 0)? ((R_8[0] > 0)? R_8[k] - (R_7[k]>>>j) : R_8[k] + (R_7[k]>>>j)) : ((R_8[0] > 0)? R_8[k] + (R_7[k]>>>j) : R_8[k] - (R_7[k]>>>j)) ;
                2'd1: N_R_8[j][k] = (N_R_7[j-1][0] > 0)? ((N_R_8[j-1][0] > 0)? N_R_8[j-1][k] - (N_R_7[j-1][k]>>>j) : N_R_8[j-1][k] + (N_R_7[j-1][k]>>>j)) : ((N_R_8[j-1][0] > 0)? N_R_8[j-1][k] + (N_R_7[j-1][k]>>>j) : N_R_8[j-1][k] - (N_R_7[j-1][k]>>>j));                 
                2'd2: N_R_8[j][k] = (N_R_7[j-1][0] > 0)? ((N_R_8[j-1][0] > 0)? N_R_8[j-1][k] - (N_R_7[j-1][k]>>>j) : N_R_8[j-1][k] + (N_R_7[j-1][k]>>>j)) : ((N_R_8[j-1][0] > 0)? N_R_8[j-1][k] + (N_R_7[j-1][k]>>>j) : N_R_8[j-1][k] - (N_R_7[j-1][k]>>>j));
                2'd3: N_R_8[j][k] = (N_R_7[j-1][0] > 0)? ((N_R_8[j-1][0] > 0)? N_R_8[j-1][k] - (N_R_7[j-1][k]>>>j) : N_R_8[j-1][k] + (N_R_7[j-1][k]>>>j)) : ((N_R_8[j-1][0] > 0)? N_R_8[j-1][k] + (N_R_7[j-1][k]>>>j) : N_R_8[j-1][k] - (N_R_7[j-1][k]>>>j)); 
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd1 && (Iteration_number == 5'd0 || Iteration_number == 5'd7 || Iteration_number == 5'd13 ||Iteration_number == 5'd18))
            begin
                case (j)
                2'd0: N_R_8[j+4][k] = (N_R_7[j+3][0] > 0)? ((N_R_8[j+3][0] > 0)? N_R_8[j+3][k] - (N_R_7[j+3][k]>>>j+4) : N_R_8[j+3][k] + (N_R_7[j+3][k]>>>j+4)) : ((N_R_8[j+3][0] > 0)? N_R_8[j+3][k] + (N_R_7[j+3][k]>>>j+4) : N_R_8[j+3][k] - (N_R_7[j+3][k]>>>j+4)) ;
                2'd1: N_R_8[j+4][k] = (N_R_7[j+3][0] > 0)? ((N_R_8[j+3][0] > 0)? N_R_8[j+3][k] - (N_R_7[j+3][k]>>>j+4) : N_R_8[j+3][k] + (N_R_7[j+3][k]>>>j+4)) : ((N_R_8[j+3][0] > 0)? N_R_8[j+3][k] + (N_R_7[j+3][k]>>>j+4) : N_R_8[j+3][k] - (N_R_7[j+3][k]>>>j+4)) ;
                2'd2: N_R_8[j+4][k] = (N_R_7[j+3][0] > 0)? ((N_R_8[j+3][0] > 0)? N_R_8[j+3][k] - (N_R_7[j+3][k]>>>j+4) : N_R_8[j+3][k] + (N_R_7[j+3][k]>>>j+4)) : ((N_R_8[j+3][0] > 0)? N_R_8[j+3][k] + (N_R_7[j+3][k]>>>j+4) : N_R_8[j+3][k] - (N_R_7[j+3][k]>>>j+4)) ;
                2'd3: N_R_8[j+4][k] = (N_R_7[j+3][0] > 0)? ((N_R_8[j+3][0] > 0)? N_R_8[j+3][k] - (N_R_7[j+3][k]>>>j+4) : N_R_8[j+3][k] + (N_R_7[j+3][k]>>>j+4)) : ((N_R_8[j+3][0] > 0)? N_R_8[j+3][k] + (N_R_7[j+3][k]>>>j+4) : N_R_8[j+3][k] - (N_R_7[j+3][k]>>>j+4)) ;
                endcase
            end
            else if (Current_state == QR && Counter_Iteratin == 2'd2 && (Iteration_number == 5'd0 || Iteration_number == 5'd7 || Iteration_number == 5'd13 || Iteration_number == 5'd18))
            begin
                case (j)
                2'd0: N_R_8[j+8][k] = (N_R_7[j+7][0] > 0)? ((N_R_8[j+7][0] > 0)? N_R_8[j+7][k] - (N_R_7[j+7][k]>>>j+8) : N_R_8[j+7][k] + (N_R_7[j+7][k]>>>j+8)) : ((N_R_8[j+7][0] > 0)? N_R_8[j+7][k] + (N_R_7[j+7][k]>>>j+8) : N_R_8[j+7][k] - (N_R_7[j+7][k]>>>j+8)) ;
                2'd1: N_R_8[j+8][k] = (N_R_7[j+7][0] > 0)? ((N_R_8[j+7][0] > 0)? N_R_8[j+7][k] - (N_R_7[j+7][k]>>>j+8) : N_R_8[j+7][k] + (N_R_7[j+7][k]>>>j+8)) : ((N_R_8[j+7][0] > 0)? N_R_8[j+7][k] + (N_R_7[j+7][k]>>>j+8) : N_R_8[j+7][k] - (N_R_7[j+7][k]>>>j+8)) ;
                2'd2: N_R_8[j+8][k] = (N_R_7[j+7][0] > 0)? ((N_R_8[j+7][0] > 0)? N_R_8[j+7][k] - (N_R_7[j+7][k]>>>j+8) : N_R_8[j+7][k] + (N_R_7[j+7][k]>>>j+8)) : ((N_R_8[j+7][0] > 0)? N_R_8[j+7][k] + (N_R_7[j+7][k]>>>j+8) : N_R_8[j+7][k] - (N_R_7[j+7][k]>>>j+8)) ;
                2'd3: N_R_8[j+8][k] = (N_R_7[j+7][0] > 0)? ((N_R_8[j+7][0] > 0)? N_R_8[j+7][k] - (N_R_7[j+7][k]>>>j+8) : N_R_8[j+7][k] + (N_R_7[j+7][k]>>>j+8)) : ((N_R_8[j+7][0] > 0)? N_R_8[j+7][k] + (N_R_7[j+7][k]>>>j+8) : N_R_8[j+7][k] - (N_R_7[j+7][k]>>>j+8)) ;
                endcase
            end
        end
    end

endgenerate

////////////////////////////////////////////////////////
// Output
////////////////////////////////////////////////////////

assign out_valid = (Current_state == Out_data && Counter_over_data !== 0)? 1'd1 : 1'd0 ;
 
always @(posedge clk or negedge rst_n) 
begin
    if (!rst_n) 
    begin
        out_matrix <= 12'd0 ;
    end
    else begin
        if (Current_state == Out_data)
        begin
            case (Counter_change)
            3'd0: out_matrix <= Result_R_1[Counter_out_data][15:4] ;
            3'd1: out_matrix <= Result_R_2[Counter_out_data][15:4] ;
            3'd2: out_matrix <= Result_R_3[Counter_out_data][15:4] ;
            3'd3: out_matrix <= Result_R_4[Counter_out_data][15:4] ;
            3'd4: out_matrix <= Result_R_5[Counter_out_data][15:4] ;
            3'd5: out_matrix <= Result_R_6[Counter_out_data][15:4] ;
            3'd6: out_matrix <= Result_R_7[Counter_out_data][15:4] ;
            3'd7: out_matrix <= Result_R_8[Counter_out_data][15:4] ;
            endcase
        end
    end
end
endmodule