//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   2022 ICLAB Spring Course                                                 
//   Lab01          : Supper MOSFET Calculator (SMC)
//   Author         : CHAN-HAO LIAO (jericc880417@gmail.com)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   File Name   : HD.v
//   Module Name : HD
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module HD(
    code_word1,
    code_word2,
    out_n
);
input[6:0] code_word1;
input[6:0] code_word2;
output reg signed[5:0] out_n;
//-------------------------------------------------------------

wire x1_1, x1_2, x1_3, x1_4 ;
wire x2_1, x2_2, x2_3, x2_4 ;
wire p1_1_detect, p1_2_detect, p1_3_detect ;
wire p2_1_detect, p2_2_detect, p2_3_detect ;
wire p1_1, p1_2, p1_3 ;
wire p2_1, p2_2, p2_3 ;
wire code1_or, code2_or ;
wire p1_and, p2_and ;
wire opt [1:0] ;
wire signed[3:0] c1, c2 ;



////////////////////////////////
//    code_word p_detect 
////////////////////////////////

assign p1_1_detect = code_word1[3] ^ code_word1[2] ^ code_word1[1] ;
assign p1_2_detect = code_word1[3] ^ code_word1[2] ^ code_word1[0] ;
assign p1_3_detect = code_word1[3] ^ code_word1[1] ^ code_word1[0] ;
assign p2_1_detect = code_word2[3] ^ code_word2[2] ^ code_word2[1] ;
assign p2_2_detect = code_word2[3] ^ code_word2[2] ^ code_word2[0] ;
assign p2_3_detect = code_word2[3] ^ code_word2[1] ^ code_word2[0] ;

////////////////////////////////
//    code1_or
////////////////////////////////
assign code1_or = (p1_1_detect == code_word1[6]) || (p1_2_detect == code_word1[5]) || (p1_3_detect == code_word1[4]) ;
assign code2_or = (p2_1_detect == code_word2[6]) || (p2_2_detect == code_word2[5]) || (p2_3_detect == code_word2[4]) ;

////////////////////////////////
//    p1_and
////////////////////////////////
assign p1_and = (p1_1 == code_word1[6]) & (p1_2 == code_word1[5]) & (p1_3 == code_word1[4]) ;
assign p2_and = (p2_1 == code_word2[6]) & (p2_2 == code_word2[5]) & (p2_3 == code_word2[4]) ;

////////////////////////////////
//    code_word1 x1~x4 correct
////////////////////////////////
assign x1_1 = (code1_or)? code_word1[3] : ~code_word1[3] ;
assign x1_2 = (p1_and)? ((p1_3_detect == code_word1[4])? ~code_word1[2] : code_word1[2]) : code_word1[2] ;
assign x1_3 = (p1_and)? ((p1_2_detect == code_word1[5])? ~code_word1[1] : code_word1[1]) : code_word1[1] ;
assign x1_4 = (p1_and)? ((p1_1_detect == code_word1[6])? ~code_word1[0] : code_word1[0]) : code_word1[0] ;

////////////////////////////////
//    code_wore2 x1~x4 detect
////////////////////////////////

assign x2_1 = (code2_or)? code_word2[3] : ~code_word2[3] ;
assign x2_2 = (p2_and)? ((p2_3_detect == code_word2[4])? ~code_word2[2] : code_word2[2]) : code_word2[2] ;
assign x2_3 = (p2_and)? ((p2_2_detect == code_word2[5])? ~code_word2[1] : code_word2[1]) : code_word2[1] ;
assign x2_4 = (p2_and)? ((p2_1_detect == code_word2[6])? ~code_word2[0] : code_word2[0]) : code_word2[0] ;

////////////////////////////////
//    code_word p_correct
////////////////////////////////

assign p1_1 = ((p1_2_detect == code_word1[5]) & (p1_3_detect == code_word1[4]))? ~code_word1[6] : code_word1[6] ; 
assign p1_2 = ((p1_1_detect == code_word1[6]) & (p1_3_detect == code_word1[4]))? ~code_word1[5] : code_word1[5] ; 
assign p1_3 = ((p1_1_detect == code_word1[6]) & (p1_2_detect == code_word1[5]))? ~code_word1[4] : code_word1[4] ; 
assign p2_1 = ((p2_2_detect == code_word2[5]) & (p2_3_detect == code_word2[4]))? ~code_word2[6] : code_word2[6] ; 
assign p2_2 = ((p2_1_detect == code_word2[6]) & (p2_3_detect == code_word2[4]))? ~code_word2[5] : code_word2[5] ; 
assign p2_3 = ((p2_1_detect == code_word2[6]) & (p2_2_detect == code_word2[5]))? ~code_word2[4] : code_word2[4] ;

////////////////////////////////
//            opt
////////////////////////////////

assign opt[0] = (p2_1 == code_word2[6])? ((p2_2 == code_word2[5])? ((p2_3 == code_word2[4])? ((code_word2[3] == x2_1)? ((code_word2[2] == x2_2)? ((code_word2[1] == x2_3)? code_word2[0] : code_word2[1]) : code_word2[2]) : code_word2[3]) : code_word2[4]) : code_word2[5]) : code_word2[6] ;  
assign opt[1] = (p1_1 == code_word1[6])? ((p1_2 == code_word1[5])? ((p1_3 == code_word1[4])? ((code_word1[3] == x1_1)? ((code_word1[2] == x1_2)? ((code_word1[1] == x1_3)? code_word1[0] : code_word1[1]) : code_word1[2]) : code_word1[3]) : code_word1[4]) : code_word1[5]) : code_word1[6] ; 

////////////////////////////////
//            calculate
////////////////////////////////

assign c1 = {x1_1, x1_2, x1_3, x1_4} ;
assign c2 = {x2_1, x2_2, x2_3, x2_4} ;

always @(*)
begin
    case({opt[1], opt[0]})
    2'd00: out_n = (c1<<1) + c2 ;
    2'd01: out_n = (c1<<1) - c2 ;
    2'd10: out_n = c1 - (c2<<1) ;
    2'd11: out_n = c1 + (c2<<1) ;
    endcase
end

endmodule