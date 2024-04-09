//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   2021 ICLAB Spring Course
//   Lab01          : Supper MOSFET Calculator (SMC)
//   Author         : CHAN-HAO LIAO (jericc880417@gmail.com)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   File Name   : SMC.v
//   Module Name : SMC
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module SMC(
    // Input signals
    mode,
    W_0, V_GS_0, V_DS_0,
    W_1, V_GS_1, V_DS_1,
    W_2, V_GS_2, V_DS_2,
    W_3, V_GS_3, V_DS_3,
    W_4, V_GS_4, V_DS_4,
    W_5, V_GS_5, V_DS_5,   
    // Output signals
    out_n
);

//================================================================
//   INPUT AND OUTPUT DECLARATION                         
//================================================================
input [2:0] W_0, V_GS_0, V_DS_0;
input [2:0] W_1, V_GS_1, V_DS_1;
input [2:0] W_2, V_GS_2, V_DS_2;
input [2:0] W_3, V_GS_3, V_DS_3;
input [2:0] W_4, V_GS_4, V_DS_4;
input [2:0] W_5, V_GS_5, V_DS_5;
input [1:0] mode;
output [9:0] out_n;

wire [2:0] W_temp [0:5] ;
wire [2:0] V_GS_temp [0:5], V_DS_temp [0:5], V_GS_square[0:5] ;

reg [6:0] I_value [0:5] ;
reg [6:0] gm_value [0:5] ;
reg [6:0] n_I [0:5] ,n_I2 [0:5], n_I3 [0:5], n_I4 [0:5], n_I5 [0:5] ;
reg [6:0] n_gm [0:5], n_gm2 [0:5], n_gm3 [0:5], n_gm4 [0:5], n_gm5 [0:5] ;

wire [9:0] I_total, gm_total ;
integer i ;

assign  W_temp[0] = W_0 ;
assign  W_temp[1] = W_1 ;
assign  W_temp[2] = W_2 ;
assign  W_temp[3] = W_3 ;
assign  W_temp[4] = W_4 ;
assign  W_temp[5] = W_5 ;
assign  V_GS_temp[0] = V_GS_0 -1 ;
assign  V_GS_temp[1] = V_GS_1 -1 ;
assign  V_GS_temp[2] = V_GS_2 -1 ;
assign  V_GS_temp[3] = V_GS_3 -1 ;
assign  V_GS_temp[4] = V_GS_4 -1 ;
assign  V_GS_temp[5] = V_GS_5 -1 ;
assign  V_DS_temp[0] = V_DS_0 ;
assign  V_DS_temp[1] = V_DS_1 ; 
assign  V_DS_temp[2] = V_DS_2 ; 
assign  V_DS_temp[3] = V_DS_3 ; 
assign  V_DS_temp[4] = V_DS_4 ; 
assign  V_DS_temp[5] = V_DS_5 ; 

always @(*)
begin
    for (i=0; i<6; i=i+1)
    begin
        if (V_GS_temp[i] > V_DS_temp[i])
        begin
            I_value[i] = (W_temp[i]*((V_GS_temp[i]*(V_DS_temp[i])<<1)-(V_DS_temp[i]*V_DS_temp[i])))/3 ;
            gm_value[i] = ((W_temp[i]*(V_DS_temp[i]))<<1)/3 ;  
        end
        else begin
            I_value[i] = (W_temp[i]*(V_GS_temp[i]*V_GS_temp[i]))/3 ;
            gm_value[i] = ((W_temp[i]*V_GS_temp[i]<<1))/3 ;
        end
    end
end

always @(*) 
begin
    n_I[0] = (I_value[0] < I_value[1])? I_value[1] : I_value[0] ;
    n_I[1] = (I_value[0] < I_value[1])? I_value[0] : I_value[1] ;
    n_I[2] = (I_value[2] < I_value[3])? I_value[3] : I_value[2] ;
    n_I[3] = (I_value[2] < I_value[3])? I_value[2] : I_value[3] ;
    n_I[4] = (I_value[4] < I_value[5])? I_value[5] : I_value[4] ;
    n_I[5] = (I_value[4] < I_value[5])? I_value[4] : I_value[5] ;
    n_I2[0] = (n_I[0] < n_I[2])? n_I[2] : n_I[0] ;
    n_I2[1] = (n_I[0] < n_I[2])? n_I[0] : n_I[2] ;
    n_I2[2] = (n_I[1] < n_I[4])? n_I[4] : n_I[1] ;
    n_I2[3] = (n_I[1] < n_I[4])? n_I[1] : n_I[4] ;
    n_I2[4] = (n_I[3] < n_I[5])? n_I[5] : n_I[3] ;
    n_I2[5] = (n_I[3] < n_I[5])? n_I[3] : n_I[5] ;
    n_I3[0] = (n_I2[0] < n_I2[2])? n_I2[2] : n_I2[0] ;
    n_I3[1] = (n_I2[0] < n_I2[2])? n_I2[0] : n_I2[2] ;
    n_I3[2] = (n_I2[1] < n_I2[4])? n_I2[4] : n_I2[1] ;
    n_I3[3] = (n_I2[1] < n_I2[4])? n_I2[1] : n_I2[4] ;
    n_I3[4] = (n_I2[3] < n_I2[5])? n_I2[5] : n_I2[3] ;
    n_I3[5] = (n_I2[3] < n_I2[5])? n_I2[3] : n_I2[5] ;
    n_I4[0] = n_I3[0] ;
    n_I4[1] = (n_I3[1] < n_I3[2])? n_I3[2] : n_I3[1] ;
    n_I4[2] = (n_I3[1] < n_I3[2])? n_I3[1] : n_I3[2] ;
    n_I4[3] = (n_I3[3] < n_I3[4])? n_I3[4] : n_I3[3] ;
    n_I4[4] = (n_I3[3] < n_I3[4])? n_I3[3] : n_I3[4] ;
    n_I4[5] = n_I3[5] ;
    n_I5[0] = n_I4[0] ;    
    n_I5[1] = n_I4[1] ;
    n_I5[2] = (n_I4[2] < n_I4[3])? n_I4[3] : n_I4[2] ;
    n_I5[3] = (n_I4[2] < n_I4[3])? n_I4[2] : n_I4[3] ;
    n_I5[4] = n_I4[4] ;
    n_I5[5] = n_I4[5] ;    
end

always @(*)
begin
    n_gm[0] = (gm_value[0]<gm_value[1])? gm_value[1] : gm_value[0] ;
    n_gm[1] = (gm_value[0]<gm_value[1])? gm_value[0] : gm_value[1] ;
    n_gm[2] = (gm_value[2]<gm_value[3])? gm_value[3] : gm_value[2] ;
    n_gm[3] = (gm_value[2]<gm_value[3])? gm_value[2] : gm_value[3] ;
    n_gm[4] = (gm_value[4]<gm_value[5])? gm_value[5] : gm_value[4] ;
    n_gm[5] = (gm_value[4]<gm_value[5])? gm_value[4] : gm_value[5] ;
    n_gm2[0] = (n_gm[0] < n_gm[2])? n_gm[2] : n_gm[0] ;
    n_gm2[1] = (n_gm[0] < n_gm[2])? n_gm[0] : n_gm[2] ;
    n_gm2[2] = (n_gm[1] < n_gm[4])? n_gm[4] : n_gm[1] ;
    n_gm2[3] = (n_gm[1] < n_gm[4])? n_gm[1] : n_gm[4] ;
    n_gm2[4] = (n_gm[3] < n_gm[5])? n_gm[5] : n_gm[3] ;
    n_gm2[5] = (n_gm[3] < n_gm[5])? n_gm[3] : n_gm[5] ;
    n_gm3[0] = (n_gm2[0] < n_gm2[2])? n_gm2[2] : n_gm2[0] ;
    n_gm3[1] = (n_gm2[0] < n_gm2[2])? n_gm2[0] : n_gm2[2] ;
    n_gm3[2] = (n_gm2[1] < n_gm2[4])? n_gm2[4] : n_gm2[1] ;
    n_gm3[3] = (n_gm2[1] < n_gm2[4])? n_gm2[1] : n_gm2[4] ;
    n_gm3[4] = (n_gm2[3] < n_gm2[5])? n_gm2[5] : n_gm2[3] ;
    n_gm3[5] = (n_gm2[3] < n_gm2[5])? n_gm2[3] : n_gm2[5] ;
    n_gm4[0] = n_gm3[0] ;
    n_gm4[1] = (n_gm3[1] < n_gm3[2])? n_gm3[2] : n_gm3[1] ;
    n_gm4[2] = (n_gm3[1] < n_gm3[2])? n_gm3[1] : n_gm3[2] ;
    n_gm4[3] = (n_gm3[3] < n_gm3[4])? n_gm3[4] : n_gm3[3] ;
    n_gm4[4] = (n_gm3[3] < n_gm3[4])? n_gm3[3] : n_gm3[4] ;
    n_gm4[5] = n_gm3[5] ;
    n_gm5[0] = n_gm4[0] ;
    n_gm5[1] = n_gm4[1] ; 
    n_gm5[2] = (n_gm4[2] < n_gm4[3])? n_gm4[3] : n_gm4[2] ;
    n_gm5[3] = (n_gm4[2] < n_gm4[3])? n_gm4[2] : n_gm4[3] ;
    n_gm5[4] = n_gm4[4] ; 
    n_gm5[5] = n_gm4[5] ;  
end

assign I_total = (mode == 2'd11)? ((n_I5[0]<<1)+n_I5[0])+(n_I5[1]<<2)+((n_I5[2]<<2)+n_I5[2]) : ((n_I5[3]<<1)+n_I5[3])+((n_I5[4]<<2))+ ((n_I5[5]<<2)+ n_I5[5]) ;
assign gm_total = (mode == 2'd10)? (n_gm5[0])+(n_gm5[1])+(n_gm5[2]) : (n_gm5[3])+(n_gm5[4])+(n_gm5[5]) ;
assign out_n = (mode == 2'd01 || mode == 2'd11)? I_total : gm_total ;

endmodule