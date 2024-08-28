/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03
// Date      : Mon Nov 20 15:34:50 2023
/////////////////////////////////////////////////////////////


module DT_DW01_inc_0_DW01_inc_2 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;

  wire   [7:2] carry;

  ADDHXL U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  ADDHX1 U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  ADDHXL U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  ADDHXL U1_1_6 ( .A(A[6]), .B(carry[6]), .CO(carry[7]), .S(SUM[6]) );
  ADDHXL U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  ADDHXL U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
  XOR2X2 U1 ( .A(carry[7]), .B(A[7]), .Y(SUM[7]) );
  INVXL U2 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module DT_DW01_inc_2_DW01_inc_4 ( A, SUM );
  input [9:0] A;
  output [9:0] SUM;

  wire   [9:2] carry;

  ADDHXL U1_1_8 ( .A(A[8]), .B(carry[8]), .CO(carry[9]), .S(SUM[8]) );
  ADDHXL U1_1_7 ( .A(A[7]), .B(carry[7]), .CO(carry[8]), .S(SUM[7]) );
  ADDHXL U1_1_6 ( .A(A[6]), .B(carry[6]), .CO(carry[7]), .S(SUM[6]) );
  ADDHXL U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  ADDHXL U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  ADDHXL U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  ADDHXL U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  ADDHXL U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
  CLKINVX1 U1 ( .A(A[0]), .Y(SUM[0]) );
  XOR2X1 U2 ( .A(carry[9]), .B(A[9]), .Y(SUM[9]) );
endmodule


module DT_DW01_dec_0_DW01_dec_1 ( A, SUM );
  input [13:0] A;
  output [13:0] SUM;
  wire   n1, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16;

  CLKINVX1 U1 ( .A(n16), .Y(n1) );
  CLKINVX1 U2 ( .A(A[0]), .Y(SUM[0]) );
  CLKINVX1 U3 ( .A(A[10]), .Y(n4) );
  CLKINVX1 U4 ( .A(A[11]), .Y(n3) );
  AO21X1 U5 ( .A0(n5), .A1(A[9]), .B0(n6), .Y(SUM[9]) );
  OAI2BB1X1 U6 ( .A0N(n7), .A1N(A[8]), .B0(n5), .Y(SUM[8]) );
  OAI2BB1X1 U7 ( .A0N(n8), .A1N(A[7]), .B0(n7), .Y(SUM[7]) );
  OAI2BB1X1 U8 ( .A0N(n9), .A1N(A[6]), .B0(n8), .Y(SUM[6]) );
  OAI2BB1X1 U9 ( .A0N(n10), .A1N(A[5]), .B0(n9), .Y(SUM[5]) );
  OAI2BB1X1 U10 ( .A0N(n11), .A1N(A[4]), .B0(n10), .Y(SUM[4]) );
  OAI2BB1X1 U11 ( .A0N(n12), .A1N(A[3]), .B0(n11), .Y(SUM[3]) );
  OAI2BB1X1 U12 ( .A0N(n13), .A1N(A[2]), .B0(n12), .Y(SUM[2]) );
  OAI2BB1X1 U13 ( .A0N(A[0]), .A1N(A[1]), .B0(n13), .Y(SUM[1]) );
  XOR2X1 U14 ( .A(A[13]), .B(n14), .Y(SUM[13]) );
  NOR2X1 U15 ( .A(A[12]), .B(n15), .Y(n14) );
  XNOR2X1 U16 ( .A(A[12]), .B(n15), .Y(SUM[12]) );
  OAI21XL U17 ( .A0(n1), .A1(n3), .B0(n15), .Y(SUM[11]) );
  NAND2X1 U18 ( .A(n1), .B(n3), .Y(n15) );
  OAI21XL U19 ( .A0(n6), .A1(n4), .B0(n16), .Y(SUM[10]) );
  NAND2X1 U20 ( .A(n6), .B(n4), .Y(n16) );
  NOR2X1 U21 ( .A(n5), .B(A[9]), .Y(n6) );
  OR2X1 U22 ( .A(n7), .B(A[8]), .Y(n5) );
  OR2X1 U23 ( .A(n8), .B(A[7]), .Y(n7) );
  OR2X1 U24 ( .A(n9), .B(A[6]), .Y(n8) );
  OR2X1 U25 ( .A(n10), .B(A[5]), .Y(n9) );
  OR2X1 U26 ( .A(n11), .B(A[4]), .Y(n10) );
  OR2X1 U27 ( .A(n12), .B(A[3]), .Y(n11) );
  OR2X1 U28 ( .A(n13), .B(A[2]), .Y(n12) );
  NAND2BX1 U29 ( .AN(A[1]), .B(SUM[0]), .Y(n13) );
endmodule


module DT_DW01_inc_4_DW01_inc_6 ( A, SUM );
  input [13:0] A;
  output [13:0] SUM;

  wire   [13:2] carry;

  ADDHXL U1_1_12 ( .A(A[12]), .B(carry[12]), .CO(carry[13]), .S(SUM[12]) );
  ADDHXL U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  ADDHXL U1_1_11 ( .A(A[11]), .B(carry[11]), .CO(carry[12]), .S(SUM[11]) );
  ADDHXL U1_1_10 ( .A(A[10]), .B(carry[10]), .CO(carry[11]), .S(SUM[10]) );
  ADDHXL U1_1_9 ( .A(A[9]), .B(carry[9]), .CO(carry[10]), .S(SUM[9]) );
  ADDHXL U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  ADDHXL U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  ADDHXL U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  ADDHXL U1_1_6 ( .A(A[6]), .B(carry[6]), .CO(carry[7]), .S(SUM[6]) );
  ADDHXL U1_1_7 ( .A(A[7]), .B(carry[7]), .CO(carry[8]), .S(SUM[7]) );
  ADDHXL U1_1_8 ( .A(A[8]), .B(carry[8]), .CO(carry[9]), .S(SUM[8]) );
  ADDHXL U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
  CLKINVX1 U1 ( .A(A[0]), .Y(SUM[0]) );
  XOR2X1 U2 ( .A(carry[13]), .B(A[13]), .Y(SUM[13]) );
endmodule


module DT ( clk, reset, done, sti_rd, sti_addr, sti_di, res_wr, res_rd, 
        res_addr, res_do, res_di );
  output [9:0] sti_addr;
  input [15:0] sti_di;
  output [13:0] res_addr;
  output [7:0] res_do;
  input [7:0] res_di;
  input clk, reset;
  output done, sti_rd, res_wr, res_rd;
  wire   N32, N33, N34, n389, n390, n391, n392, n393, n394, n395, n396, n397,
         n398, n399, n400, n401, N63, N64, N65, N66, N72, N73, N74, N75, N76,
         N77, N78, N79, N80, N81, N104, N105, N106, N107, N108, N109, N110,
         N111, N112, N113, N114, N115, N116, N117, N119, N120, N121, N122,
         N123, N124, N125, N126, N127, N128, N129, N130, N131, N132, N163,
         N165, N166, N167, N168, N169, N170, N171, N172, N173, N174, N175,
         N176, N206, N207, N208, N209, N210, N211, N212, N213, N214, N215,
         N216, N217, N218, N270, N271, N272, N273, N274, N275, N276, N277,
         N278, N279, N280, N281, N311, N312, N313, N314, N315, N316, N317,
         N318, N319, N320, N321, N322, N323, N372, N375, N376, N377, N378,
         \data[0] , N390, N391, N395, N403, N404, N405, N406, N407, N408, N409,
         N410, N411, n25, n28, n29, n30, n32, n33, n36, n37, n38, n39, n40,
         n41, n43, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56,
         n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70,
         n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84,
         n85, n86, n87, n89, n90, n91, n92, n93, n94, n95, n96, n99, n101,
         n102, n103, n105, n107, n108, n109, n110, n111, n113, n114, n115,
         n116, n118, n119, n120, n125, n126, n128, n131, n134, n135, n136,
         n137, n138, n141, n142, n143, n144, n145, n146, n147, n148, n150,
         n151, n152, n153, n154, n155, n156, n157, n159, n160, n161, n164,
         n165, n168, n170, n171, n173, n174, n175, n176, n177, n179, n180,
         n181, n182, n183, n184, n185, n186, n187, n188, n189, n190, n191,
         n192, n193, n194, n196, n199, n200, n201, n205, n206, n207, n208,
         n209, n210, n211, n212, n213, n214, n215, n216, n217, n218, n219,
         n220, n221, n222, n223, n224, n228, n229, n230, n231, n232, n233,
         n234, n235, n236, n237, n238, n239, n240, n241, n242, n243, n244,
         n245, n246, n247, n248, n249, n250, n251, n252, n253, n254, n255,
         n256, n257, n258, n259, n260, n261, n262, n263, n264, n265, n266,
         \sub_129/carry[2] , \sub_129/carry[3] , \sub_129/carry[4] ,
         \sub_129/carry[5] , \sub_129/carry[6] , \sub_129/carry[7] ,
         \sub_129/carry[8] , \sub_129/carry[9] , \sub_129/carry[10] ,
         \sub_129/carry[11] , \sub_129/carry[12] , \sub_129/carry[13] ,
         \add_119/carry[2] , \add_119/carry[3] , \add_119/carry[4] ,
         \add_119/carry[5] , \add_119/carry[6] , \add_119/carry[7] ,
         \add_119/carry[8] , \add_119/carry[9] , \add_119/carry[10] ,
         \add_119/carry[11] , \add_119/carry[12] , \add_119/carry[13] , n267,
         n268, n269, n270, n271, n272, n273, n274, n275, n276, n277, n278,
         n279, n280, n281, n282, n283, n284, n285, n286, n287, n288, n289,
         n290, n291, n292, n293, n294, n295, n296, n297, n298, n299, n300,
         n301, n302, n303, n304, n305, n306, n307, n308, n309, n310, n311,
         n312, n313, n328, n329, n330, n331, n332, n333, n334, n335, n336,
         n337, n338, n339, n340, n341, n342, n343, n344, n345, n346, n347,
         n348, n349, n350, n351, n352, n353, n354, n355, n356, n357, n358,
         n359, n360, n361, n362, n363, n364, n365, n366, n367, n368, n369,
         n370, n371, n372, n373, n374, n375, n376, n377, n378, n379, n380,
         n381, n382, n383, n384, n385, n386, n387, n388;
  wire   [4:0] counter;
  wire   [3:0] Next_state;
  wire   [3:0] state;
  wire   [3:0] data_compare;
  wire   [4:2] \add_146/carry ;
  wire   [13:1] \add_126/carry ;
  wire   [14:0] \sub_116/carry ;
  wire   [4:2] \add_64/carry ;
  assign res_do[7] = 1'b0;
  assign res_do[6] = 1'b0;
  assign res_do[5] = 1'b0;

  DFFRX4 sti_rd_reg ( .D(1'b1), .CK(clk), .RN(n328), .Q(sti_rd) );
  OAI211X2 U202 ( .A0(n385), .A1(n170), .B0(n171), .C0(n165), .Y(Next_state[1]) );
  DFFRX2 \res_do_reg[3]  ( .D(n222), .CK(clk), .RN(reset), .Q(res_do[3]) );
  DFFRX2 \res_do_reg[2]  ( .D(n221), .CK(clk), .RN(reset), .Q(res_do[2]) );
  DFFRX2 \res_do_reg[1]  ( .D(n220), .CK(clk), .RN(reset), .Q(res_do[1]) );
  DFFSX1 \counter_15_reg[3]  ( .D(n210), .CK(clk), .SN(reset), .Q(n382), .QN(
        n201) );
  DFFSX1 \counter_15_reg[2]  ( .D(n211), .CK(clk), .SN(reset), .Q(N34), .QN(
        n345) );
  DFFRX1 \counter_reg[4]  ( .D(n217), .CK(clk), .RN(n328), .Q(counter[4]), 
        .QN(n208) );
  DFFRX1 \counter_reg[3]  ( .D(n216), .CK(clk), .RN(n328), .Q(counter[3]), 
        .QN(n207) );
  DFFRX1 \counter_reg[0]  ( .D(n218), .CK(clk), .RN(n328), .Q(counter[0]), 
        .QN(n209) );
  DFFRX1 \counter_reg[1]  ( .D(n214), .CK(clk), .RN(n328), .Q(counter[1]), 
        .QN(n205) );
  DFFRX1 \counter_reg[2]  ( .D(n215), .CK(clk), .RN(n328), .Q(counter[2]), 
        .QN(n206) );
  DFFRX1 \data_compare_reg[3]  ( .D(n249), .CK(clk), .RN(n330), .Q(
        data_compare[3]), .QN(n356) );
  DFFRX1 \data_reg[0]  ( .D(n247), .CK(clk), .RN(n330), .Q(\data[0] ), .QN(
        n228) );
  DFFRX1 \data_compare_reg[0]  ( .D(n251), .CK(clk), .RN(n330), .Q(
        data_compare[0]), .QN(n196) );
  DFFSX1 \counter_15_reg[1]  ( .D(n212), .CK(clk), .SN(reset), .Q(N33), .QN(
        n346) );
  DFFRX1 \counter_15_reg[0]  ( .D(n213), .CK(clk), .RN(n328), .Q(N32), .QN(
        n347) );
  DFFRX1 \data_compare_reg[2]  ( .D(n250), .CK(clk), .RN(n330), .Q(
        data_compare[2]), .QN(n355) );
  DFFRX1 \data_compare_reg[1]  ( .D(n252), .CK(clk), .RN(n330), .Q(
        data_compare[1]), .QN(n354) );
  DFFRX1 \data_reg[1]  ( .D(n248), .CK(clk), .RN(n330), .QN(n363) );
  DFFRX1 \data_reg[2]  ( .D(n246), .CK(clk), .RN(n330), .QN(n365) );
  DFFRX1 \res_addr_reg[10]  ( .D(n232), .CK(clk), .RN(n329), .Q(n392), .QN(
        n271) );
  DFFRX2 done_reg ( .D(n266), .CK(clk), .RN(n330), .Q(done) );
  DFFRX2 res_rd_reg ( .D(N391), .CK(clk), .RN(n330), .Q(res_rd) );
  DFFRX2 res_wr_reg ( .D(N390), .CK(clk), .RN(reset), .Q(res_wr) );
  DFFRX1 \res_addr_reg[0]  ( .D(n241), .CK(clk), .RN(reset), .Q(N163), .QN(
        n273) );
  DFFRX1 \res_addr_reg[11]  ( .D(n231), .CK(clk), .RN(n329), .Q(n391) );
  DFFRX1 \data_reg[3]  ( .D(n245), .CK(clk), .RN(n330), .QN(n364) );
  DFFRX1 \res_addr_reg[7]  ( .D(n235), .CK(clk), .RN(n330), .Q(n395) );
  DFFRX1 \res_addr_reg[9]  ( .D(n233), .CK(clk), .RN(n329), .Q(n393) );
  DFFRX1 \res_addr_reg[8]  ( .D(n234), .CK(clk), .RN(n330), .Q(n394) );
  DFFRX1 \res_addr_reg[3]  ( .D(n239), .CK(clk), .RN(n329), .Q(n399) );
  DFFRX1 \res_addr_reg[4]  ( .D(n238), .CK(clk), .RN(n329), .Q(n398) );
  DFFRX1 \res_addr_reg[6]  ( .D(n236), .CK(clk), .RN(n330), .Q(n396) );
  DFFRX1 \res_addr_reg[5]  ( .D(n237), .CK(clk), .RN(n329), .Q(n397) );
  DFFRX1 \res_addr_reg[12]  ( .D(n230), .CK(clk), .RN(n329), .Q(n390) );
  DFFRX1 \res_addr_reg[2]  ( .D(n240), .CK(clk), .RN(n329), .Q(n400) );
  DFFRX1 \res_addr_reg[13]  ( .D(n229), .CK(clk), .RN(n329), .Q(n389) );
  DFFRX1 \res_addr_reg[1]  ( .D(n242), .CK(clk), .RN(reset), .Q(n401), .QN(
        n274) );
  DFFRX1 \counter_05_reg[0]  ( .D(n255), .CK(clk), .RN(reset), .Q(n387), .QN(
        n224) );
  DFFRX1 \counter_05_reg[1]  ( .D(n254), .CK(clk), .RN(n329), .Q(n388), .QN(
        n223) );
  DFFRX1 \counter_05_reg[2]  ( .D(n253), .CK(clk), .RN(n329), .QN(n219) );
  DFFRX1 \state_reg[0]  ( .D(Next_state[0]), .CK(clk), .RN(reset), .Q(state[0]), .QN(n383) );
  DFFRX1 \state_reg[2]  ( .D(Next_state[2]), .CK(clk), .RN(reset), .Q(state[2]), .QN(n272) );
  DFFRX1 \state_reg[1]  ( .D(Next_state[1]), .CK(clk), .RN(reset), .Q(state[1]), .QN(n267) );
  BUFX4 U235 ( .A(n45), .Y(n312) );
  NOR3X1 U236 ( .A(n309), .B(n92), .C(n94), .Y(n45) );
  OA21X2 U237 ( .A0(n160), .A1(n284), .B0(n103), .Y(n170) );
  NAND2X1 U238 ( .A(n286), .B(n120), .Y(n118) );
  NOR4X2 U239 ( .A(n362), .B(N408), .C(N410), .D(N409), .Y(N411) );
  AND2X2 U240 ( .A(n274), .B(n310), .Y(n282) );
  NAND2X6 U241 ( .A(Next_state[1]), .B(n370), .Y(n101) );
  INVX12 U242 ( .A(n268), .Y(n309) );
  NAND3X2 U243 ( .A(n91), .B(n96), .C(n304), .Y(n305) );
  INVX1 U244 ( .A(n99), .Y(n304) );
  BUFX4 U245 ( .A(n46), .Y(n313) );
  BUFX4 U246 ( .A(n47), .Y(n310) );
  BUFX4 U247 ( .A(n48), .Y(n311) );
  INVX3 U248 ( .A(res_di[3]), .Y(n291) );
  CLKINVX1 U249 ( .A(res_di[1]), .Y(n293) );
  CLKINVX1 U250 ( .A(res_di[4]), .Y(n290) );
  CLKINVX1 U251 ( .A(res_di[5]), .Y(n289) );
  CLKINVX1 U252 ( .A(res_di[6]), .Y(n288) );
  OA21XL U253 ( .A0(n370), .A1(n374), .B0(n375), .Y(n281) );
  NAND2X6 U254 ( .A(n179), .B(n180), .Y(n143) );
  AND4X2 U255 ( .A(n287), .B(n288), .C(n289), .D(n290), .Y(n180) );
  AND4X4 U256 ( .A(n291), .B(n292), .C(n293), .D(n294), .Y(n179) );
  CLKINVX1 U257 ( .A(res_di[7]), .Y(n287) );
  CLKINVX1 U258 ( .A(Next_state[3]), .Y(n377) );
  INVX3 U259 ( .A(res_di[2]), .Y(n292) );
  OAI211X1 U260 ( .A0(N395), .A1(n386), .B0(n374), .C0(n369), .Y(n131) );
  NOR2X1 U261 ( .A(n302), .B(n152), .Y(n148) );
  NAND3X1 U262 ( .A(n85), .B(n86), .C(n87), .Y(n242) );
  NAND2X2 U263 ( .A(n115), .B(n285), .Y(n245) );
  AOI32X1 U264 ( .A0(n116), .A1(n291), .A2(n307), .B0(res_di[3]), .B1(n118), 
        .Y(n115) );
  NAND3X1 U265 ( .A(n52), .B(n53), .C(n54), .Y(n231) );
  INVX3 U266 ( .A(Next_state[0]), .Y(n370) );
  OAI211X4 U267 ( .A0(n146), .A1(n147), .B0(n145), .C0(n148), .Y(Next_state[0]) );
  AND2X4 U268 ( .A(n305), .B(n29), .Y(n268) );
  INVX1 U269 ( .A(n143), .Y(n284) );
  NAND2X2 U270 ( .A(n281), .B(n377), .Y(n91) );
  CLKAND2X3 U271 ( .A(n301), .B(n168), .Y(n269) );
  NOR2X4 U272 ( .A(n303), .B(n309), .Y(n270) );
  NAND2X1 U273 ( .A(n142), .B(Next_state[3]), .Y(n96) );
  OAI211X1 U274 ( .A0(n126), .A1(n143), .B0(n144), .C0(n145), .Y(Next_state[3]) );
  NOR2X1 U275 ( .A(n164), .B(n147), .Y(n275) );
  NOR2XL U276 ( .A(state[3]), .B(n269), .Y(n276) );
  CLKINVX1 U277 ( .A(n165), .Y(n277) );
  OR3X4 U278 ( .A(n275), .B(n276), .C(n277), .Y(Next_state[2]) );
  NOR3X2 U279 ( .A(Next_state[1]), .B(Next_state[2]), .C(Next_state[0]), .Y(
        n142) );
  INVX3 U280 ( .A(Next_state[2]), .Y(n374) );
  NOR2X4 U281 ( .A(n309), .B(n295), .Y(n43) );
  NOR2X1 U282 ( .A(n120), .B(n292), .Y(n278) );
  NOR2X1 U283 ( .A(n307), .B(n368), .Y(n279) );
  NOR2X1 U284 ( .A(n365), .B(n114), .Y(n280) );
  OR3X2 U285 ( .A(n278), .B(n279), .C(n280), .Y(n246) );
  OA21X4 U286 ( .A0(n374), .A1(n101), .B0(n102), .Y(n89) );
  INVX1 U287 ( .A(n101), .Y(n369) );
  INVX1 U288 ( .A(Next_state[1]), .Y(n375) );
  AND2X2 U289 ( .A(N120), .B(n311), .Y(n283) );
  NOR2X1 U290 ( .A(n282), .B(n283), .Y(n85) );
  NOR2BX1 U291 ( .AN(n95), .B(n309), .Y(n48) );
  OR2X1 U292 ( .A(n364), .B(n114), .Y(n285) );
  CLKINVX8 U293 ( .A(n143), .Y(n376) );
  OR2XL U294 ( .A(res_di[2]), .B(n119), .Y(n286) );
  NAND4X4 U295 ( .A(Next_state[2]), .B(n369), .C(N411), .D(n126), .Y(n119) );
  CLKINVX8 U296 ( .A(res_di[0]), .Y(n294) );
  AND2X2 U297 ( .A(N216), .B(n312), .Y(n296) );
  AND2X2 U298 ( .A(N321), .B(n313), .Y(n297) );
  AOI222XL U299 ( .A0(res_addr[12]), .A1(n309), .B0(N175), .B1(n43), .C0(N116), 
        .C1(n270), .Y(n51) );
  AOI222XL U300 ( .A0(res_addr[2]), .A1(n309), .B0(N165), .B1(n43), .C0(N106), 
        .C1(n270), .Y(n81) );
  AOI222XL U301 ( .A0(res_addr[8]), .A1(n309), .B0(N171), .B1(n43), .C0(N112), 
        .C1(n270), .Y(n63) );
  OR2XL U302 ( .A(n92), .B(n93), .Y(n295) );
  OA21X4 U303 ( .A0(Next_state[2]), .A1(n101), .B0(n103), .Y(n92) );
  NAND3X1 U304 ( .A(n82), .B(n83), .C(n84), .Y(n241) );
  AND2X2 U305 ( .A(res_addr[0]), .B(n43), .Y(n299) );
  AND2X2 U306 ( .A(N104), .B(n270), .Y(n300) );
  AO21X1 U307 ( .A0(n284), .A1(n150), .B0(n151), .Y(n302) );
  OA21XL U308 ( .A0(state[3]), .A1(n269), .B0(n164), .Y(n146) );
  NOR2X1 U309 ( .A(n296), .B(n297), .Y(n53) );
  AOI32X2 U310 ( .A0(n94), .A1(n93), .A2(n90), .B0(n92), .B1(n89), .Y(n99) );
  NOR3XL U311 ( .A(n294), .B(n119), .C(n378), .Y(n116) );
  NAND2X1 U312 ( .A(n111), .B(sti_rd), .Y(n109) );
  AOI2BB2XL U313 ( .B0(n196), .B1(n373), .A0N(n32), .A1N(n228), .Y(n108) );
  AND2XL U314 ( .A(res_addr[0]), .B(n309), .Y(n298) );
  NOR3X1 U315 ( .A(n298), .B(n299), .C(n300), .Y(n84) );
  OR3X2 U316 ( .A(n267), .B(state[2]), .C(n383), .Y(n301) );
  NAND4X4 U317 ( .A(n376), .B(state[2]), .C(n383), .D(n267), .Y(n168) );
  AOI22XL U318 ( .A0(N206), .A1(n312), .B0(N311), .B1(n313), .Y(n86) );
  AOI22XL U319 ( .A0(n273), .A1(n312), .B0(n273), .B1(n313), .Y(n83) );
  AOI22XL U320 ( .A0(res_addr[0]), .A1(n310), .B0(N119), .B1(n311), .Y(n82) );
  AOI22XL U321 ( .A0(N217), .A1(n312), .B0(N322), .B1(n313), .Y(n50) );
  AOI22XL U322 ( .A0(N280), .A1(n310), .B0(N131), .B1(n311), .Y(n49) );
  AOI22XL U323 ( .A0(N213), .A1(n312), .B0(N318), .B1(n313), .Y(n62) );
  AOI22XL U324 ( .A0(N276), .A1(n310), .B0(N127), .B1(n311), .Y(n61) );
  AOI22XL U325 ( .A0(N207), .A1(n312), .B0(N312), .B1(n313), .Y(n80) );
  AOI22XL U326 ( .A0(N270), .A1(n310), .B0(N121), .B1(n311), .Y(n79) );
  AOI22XL U327 ( .A0(N279), .A1(n310), .B0(N130), .B1(n311), .Y(n52) );
  OA22X1 U328 ( .A0(n384), .A1(n102), .B0(n284), .B1(n126), .Y(n165) );
  INVX1 U329 ( .A(n131), .Y(n366) );
  OA21XL U330 ( .A0(res_di[0]), .A1(n119), .B0(n126), .Y(n125) );
  INVX1 U331 ( .A(n128), .Y(n367) );
  NAND3BX2 U332 ( .AN(n111), .B(sti_rd), .C(n372), .Y(n32) );
  CLKBUFX2 U333 ( .A(res_di[2]), .Y(n307) );
  NAND2XL U334 ( .A(n113), .B(n134), .Y(n136) );
  NAND2XL U335 ( .A(n110), .B(n113), .Y(N390) );
  OA21XL U336 ( .A0(n89), .A1(n90), .B0(n91), .Y(n303) );
  NAND2XL U337 ( .A(n369), .B(n387), .Y(n134) );
  NOR2XL U338 ( .A(n113), .B(Next_state[2]), .Y(n111) );
  OAI211XL U339 ( .A0(Next_state[3]), .A1(n141), .B0(n101), .C0(n96), .Y(N391)
         );
  INVX1 U340 ( .A(n116), .Y(n368) );
  OAI32XL U341 ( .A0(n119), .A1(res_di[1]), .A2(n294), .B0(n114), .B1(n363), 
        .Y(n128) );
  NAND3XL U342 ( .A(state[2]), .B(n143), .C(n157), .Y(n171) );
  NAND3BXL U343 ( .AN(res_di[4]), .B(n352), .C(n351), .Y(n353) );
  NAND4X2 U344 ( .A(sti_rd), .B(n110), .C(n109), .D(n32), .Y(n38) );
  OAI211XL U345 ( .A0(n38), .A1(n199), .B0(n107), .C0(n108), .Y(n244) );
  NAND3BXL U346 ( .AN(n110), .B(sti_rd), .C(N372), .Y(n107) );
  OAI32XL U347 ( .A0(n369), .A1(n224), .A2(n372), .B0(n387), .B1(n101), .Y(
        n255) );
  BUFX4 U348 ( .A(n401), .Y(res_addr[1]) );
  BUFX4 U349 ( .A(n390), .Y(res_addr[12]) );
  BUFX4 U350 ( .A(n397), .Y(res_addr[5]) );
  BUFX4 U351 ( .A(n396), .Y(res_addr[6]) );
  BUFX4 U352 ( .A(n400), .Y(res_addr[2]) );
  BUFX4 U353 ( .A(n391), .Y(res_addr[11]) );
  BUFX4 U354 ( .A(n398), .Y(res_addr[4]) );
  BUFX4 U355 ( .A(n394), .Y(res_addr[8]) );
  BUFX4 U356 ( .A(n399), .Y(res_addr[3]) );
  BUFX4 U357 ( .A(n393), .Y(res_addr[9]) );
  CLKBUFX3 U358 ( .A(n389), .Y(res_addr[13]) );
  BUFX4 U359 ( .A(N163), .Y(res_addr[0]) );
  BUFX4 U360 ( .A(n395), .Y(res_addr[7]) );
  AOI21XL U361 ( .A0(res_di[1]), .A1(n354), .B0(res_di[0]), .Y(n349) );
  INVXL U362 ( .A(res_di[1]), .Y(n378) );
  NAND3X1 U363 ( .A(n223), .B(n387), .C(n219), .Y(n93) );
  OR4X1 U364 ( .A(n207), .B(n209), .C(counter[4]), .D(n306), .Y(n29) );
  AND2XL U365 ( .A(res_di[2]), .B(n355), .Y(n348) );
  CLKINVX1 U366 ( .A(n113), .Y(n372) );
  NAND2X1 U367 ( .A(n142), .B(n377), .Y(n110) );
  NOR2X1 U368 ( .A(n377), .B(n370), .Y(n266) );
  NAND3X1 U369 ( .A(n61), .B(n62), .C(n63), .Y(n234) );
  NAND3X1 U370 ( .A(n64), .B(n65), .C(n66), .Y(n235) );
  AOI22X1 U371 ( .A0(N212), .A1(n312), .B0(N317), .B1(n313), .Y(n65) );
  AOI22X1 U372 ( .A0(N275), .A1(n310), .B0(N126), .B1(n311), .Y(n64) );
  AOI222XL U373 ( .A0(res_addr[7]), .A1(n309), .B0(N170), .B1(n43), .C0(N111), 
        .C1(n270), .Y(n66) );
  NAND3X1 U374 ( .A(n67), .B(n68), .C(n69), .Y(n236) );
  AOI22X1 U375 ( .A0(N211), .A1(n312), .B0(N316), .B1(n313), .Y(n68) );
  AOI22X1 U376 ( .A0(N274), .A1(n310), .B0(N125), .B1(n311), .Y(n67) );
  AOI222XL U377 ( .A0(res_addr[6]), .A1(n309), .B0(N169), .B1(n43), .C0(N110), 
        .C1(n270), .Y(n69) );
  NAND3X1 U378 ( .A(n70), .B(n71), .C(n72), .Y(n237) );
  AOI22X1 U379 ( .A0(N210), .A1(n312), .B0(N315), .B1(n313), .Y(n71) );
  AOI22X1 U380 ( .A0(N273), .A1(n310), .B0(N124), .B1(n311), .Y(n70) );
  AOI222XL U381 ( .A0(res_addr[5]), .A1(n309), .B0(N168), .B1(n43), .C0(N109), 
        .C1(n270), .Y(n72) );
  NAND3X1 U382 ( .A(n73), .B(n74), .C(n75), .Y(n238) );
  AOI22X1 U383 ( .A0(N209), .A1(n312), .B0(N314), .B1(n313), .Y(n74) );
  AOI22X1 U384 ( .A0(N272), .A1(n310), .B0(N123), .B1(n311), .Y(n73) );
  AOI222XL U385 ( .A0(res_addr[4]), .A1(n309), .B0(N167), .B1(n43), .C0(N108), 
        .C1(n270), .Y(n75) );
  NAND3X1 U386 ( .A(n76), .B(n77), .C(n78), .Y(n239) );
  AOI22X1 U387 ( .A0(N208), .A1(n312), .B0(N313), .B1(n313), .Y(n77) );
  AOI22X1 U388 ( .A0(N271), .A1(n310), .B0(N122), .B1(n311), .Y(n76) );
  AOI222XL U389 ( .A0(res_addr[3]), .A1(n309), .B0(N166), .B1(n43), .C0(N107), 
        .C1(n270), .Y(n78) );
  NAND3X1 U390 ( .A(n58), .B(n59), .C(n60), .Y(n233) );
  AOI22X1 U391 ( .A0(N214), .A1(n312), .B0(N319), .B1(n313), .Y(n59) );
  AOI22X1 U392 ( .A0(N277), .A1(n310), .B0(N128), .B1(n311), .Y(n58) );
  AOI222XL U393 ( .A0(res_addr[9]), .A1(n309), .B0(N172), .B1(n43), .C0(N113), 
        .C1(n270), .Y(n60) );
  NAND3X1 U394 ( .A(n55), .B(n56), .C(n57), .Y(n232) );
  AOI22X1 U395 ( .A0(N215), .A1(n312), .B0(N320), .B1(n313), .Y(n56) );
  AOI22X1 U396 ( .A0(N278), .A1(n310), .B0(N129), .B1(n311), .Y(n55) );
  AOI222XL U397 ( .A0(res_addr[10]), .A1(n309), .B0(N173), .B1(n43), .C0(N114), 
        .C1(n270), .Y(n57) );
  AOI222XL U398 ( .A0(res_addr[11]), .A1(n309), .B0(N174), .B1(n43), .C0(N115), 
        .C1(n270), .Y(n54) );
  NAND3X1 U399 ( .A(n49), .B(n50), .C(n51), .Y(n230) );
  NAND3X1 U400 ( .A(n39), .B(n40), .C(n41), .Y(n229) );
  AOI22X1 U401 ( .A0(N218), .A1(n312), .B0(N323), .B1(n313), .Y(n40) );
  AOI22X1 U402 ( .A0(N281), .A1(n310), .B0(N132), .B1(n311), .Y(n39) );
  AOI222XL U403 ( .A0(res_addr[13]), .A1(n309), .B0(N176), .B1(n43), .C0(N117), 
        .C1(n270), .Y(n41) );
  NAND3X1 U404 ( .A(n79), .B(n80), .C(n81), .Y(n240) );
  AOI222XL U405 ( .A0(res_addr[1]), .A1(n309), .B0(n274), .B1(n43), .C0(N105), 
        .C1(n270), .Y(n87) );
  OAI21XL U406 ( .A0(n92), .A1(n90), .B0(n96), .Y(n95) );
  NOR3X1 U407 ( .A(n309), .B(n89), .C(n94), .Y(n46) );
  NOR3X1 U408 ( .A(n309), .B(n89), .C(n93), .Y(n47) );
  NAND2X1 U409 ( .A(n119), .B(n126), .Y(n114) );
  CLKINVX1 U410 ( .A(n159), .Y(n384) );
  NAND2X1 U411 ( .A(Next_state[1]), .B(Next_state[0]), .Y(n113) );
  CLKINVX1 U412 ( .A(n38), .Y(n371) );
  CLKINVX1 U413 ( .A(n109), .Y(n373) );
  AOI32XL U414 ( .A0(n375), .A1(n374), .A2(Next_state[0]), .B0(Next_state[2]), 
        .B1(n370), .Y(n141) );
  NAND2X1 U415 ( .A(n173), .B(n272), .Y(n103) );
  AND2X2 U416 ( .A(n160), .B(n103), .Y(n164) );
  OAI21XL U417 ( .A0(n159), .A1(n126), .B0(n160), .Y(n150) );
  NAND4X1 U418 ( .A(n174), .B(n175), .C(n176), .D(n177), .Y(n159) );
  NOR3X1 U419 ( .A(res_addr[2]), .B(res_addr[4]), .C(res_addr[3]), .Y(n176) );
  AND3X2 U420 ( .A(res_addr[7]), .B(n271), .C(res_addr[0]), .Y(n174) );
  NOR4X1 U421 ( .A(res_addr[1]), .B(res_addr[13]), .C(res_addr[12]), .D(
        res_addr[11]), .Y(n175) );
  NOR4X1 U422 ( .A(res_addr[9]), .B(res_addr[8]), .C(res_addr[6]), .D(
        res_addr[5]), .Y(n177) );
  NAND3BX1 U423 ( .AN(n181), .B(n182), .C(n183), .Y(n147) );
  AND3X2 U424 ( .A(res_addr[1]), .B(res_addr[12]), .C(res_addr[13]), .Y(n182)
         );
  NAND4BX1 U425 ( .AN(n184), .B(res_addr[9]), .C(res_addr[6]), .D(res_addr[8]), 
        .Y(n181) );
  NOR4BX1 U426 ( .AN(res_addr[11]), .B(res_addr[7]), .C(res_addr[0]), .D(n271), 
        .Y(n183) );
  NAND4X1 U427 ( .A(res_addr[5]), .B(res_addr[4]), .C(res_addr[3]), .D(
        res_addr[2]), .Y(n184) );
  NAND4X1 U428 ( .A(n157), .B(res_addr[7]), .C(res_addr[0]), .D(n272), .Y(n153) );
  NAND4X1 U429 ( .A(res_addr[4]), .B(res_addr[3]), .C(res_addr[2]), .D(
        res_addr[1]), .Y(n155) );
  NAND4X1 U430 ( .A(res_addr[9]), .B(res_addr[8]), .C(res_addr[6]), .D(
        res_addr[5]), .Y(n156) );
  NAND4X1 U431 ( .A(res_addr[13]), .B(res_addr[12]), .C(res_addr[11]), .D(
        res_addr[10]), .Y(n154) );
  CLKINVX1 U432 ( .A(n30), .Y(n380) );
  CLKINVX1 U433 ( .A(n28), .Y(n379) );
  NOR4X1 U434 ( .A(n153), .B(n154), .C(n155), .D(n156), .Y(n151) );
  OA21XL U435 ( .A0(res_di[1]), .A1(n119), .B0(n125), .Y(n120) );
  OAI21XL U436 ( .A0(n125), .A1(n378), .B0(n367), .Y(n248) );
  CLKINVX1 U437 ( .A(n93), .Y(n386) );
  OAI22XL U438 ( .A0(n354), .A1(n366), .B0(n378), .B1(n131), .Y(n252) );
  OAI22XL U439 ( .A0(n196), .A1(n366), .B0(n294), .B1(n131), .Y(n251) );
  OAI22XL U440 ( .A0(n355), .A1(n366), .B0(n292), .B1(n131), .Y(n250) );
  OAI22XL U441 ( .A0(n356), .A1(n366), .B0(n291), .B1(n131), .Y(n249) );
  OAI222XL U442 ( .A0(res_di[0]), .A1(n119), .B0(n228), .B1(n114), .C0(n126), 
        .C1(n294), .Y(n247) );
  CLKINVX1 U443 ( .A(n147), .Y(n385) );
  OAI21XL U444 ( .A0(n363), .A1(n32), .B0(n33), .Y(n220) );
  AOI22X1 U445 ( .A0(res_do[1]), .A1(n371), .B0(N375), .B1(n373), .Y(n33) );
  OAI21XL U446 ( .A0(n365), .A1(n32), .B0(n36), .Y(n221) );
  AOI22X1 U447 ( .A0(res_do[2]), .A1(n371), .B0(N376), .B1(n373), .Y(n36) );
  OAI21XL U448 ( .A0(n364), .A1(n32), .B0(n37), .Y(n222) );
  AOI22X1 U449 ( .A0(res_do[3]), .A1(n371), .B0(N377), .B1(n373), .Y(n37) );
  OAI222XL U450 ( .A0(n105), .A1(n101), .B0(n134), .B1(n135), .C0(n219), .C1(
        n136), .Y(n253) );
  NAND2X1 U451 ( .A(n219), .B(n388), .Y(n135) );
  OAI22XL U452 ( .A0(n223), .A1(n136), .B0(n388), .B1(n134), .Y(n254) );
  OAI2BB2XL U453 ( .B0(n38), .B1(n200), .A0N(N378), .A1N(n373), .Y(n243) );
  NAND3BX1 U454 ( .AN(state[3]), .B(state[0]), .C(state[2]), .Y(n144) );
  NOR3X1 U455 ( .A(state[0]), .B(state[3]), .C(n267), .Y(n173) );
  OR4X1 U456 ( .A(state[3]), .B(n383), .C(state[1]), .D(state[2]), .Y(n160) );
  NAND4X2 U457 ( .A(state[3]), .B(n383), .C(n267), .D(n272), .Y(n126) );
  AOI211X1 U458 ( .A0(n103), .A1(n102), .B0(n105), .C0(n224), .Y(n152) );
  NAND2X1 U459 ( .A(state[2]), .B(n173), .Y(n102) );
  BUFX4 U460 ( .A(n392), .Y(res_addr[10]) );
  OA21XL U461 ( .A0(n102), .A1(n159), .B0(n161), .Y(n145) );
  NAND4X1 U462 ( .A(state[3]), .B(state[0]), .C(n267), .D(n272), .Y(n161) );
  NOR3X1 U463 ( .A(state[1]), .B(state[3]), .C(state[0]), .Y(n157) );
  NAND2BX1 U464 ( .AN(n219), .B(n223), .Y(n105) );
  NAND2BX1 U465 ( .AN(n105), .B(n224), .Y(n94) );
  OAI2BB2XL U466 ( .B0(n308), .B1(n194), .A0N(N81), .A1N(n138), .Y(n256) );
  OAI21X1 U467 ( .A0(n224), .A1(n388), .B0(n219), .Y(n90) );
  OAI2BB2XL U468 ( .B0(n308), .B1(n193), .A0N(N80), .A1N(n138), .Y(n257) );
  AND2X2 U469 ( .A(sti_rd), .B(n308), .Y(n138) );
  NAND2X1 U470 ( .A(n345), .B(n379), .Y(n25) );
  NAND2X1 U471 ( .A(n347), .B(n29), .Y(n30) );
  NAND2X1 U472 ( .A(n346), .B(n380), .Y(n28) );
  OAI2BB2XL U473 ( .B0(n308), .B1(n192), .A0N(N79), .A1N(n138), .Y(n258) );
  OAI2BB2XL U474 ( .B0(n308), .B1(n191), .A0N(N78), .A1N(n138), .Y(n259) );
  OAI2BB2XL U475 ( .B0(n308), .B1(n190), .A0N(N77), .A1N(n138), .Y(n260) );
  OAI2BB2XL U476 ( .B0(n308), .B1(n189), .A0N(N76), .A1N(n138), .Y(n261) );
  OAI2BB2XL U477 ( .B0(n308), .B1(n188), .A0N(N75), .A1N(n138), .Y(n262) );
  OAI2BB2XL U478 ( .B0(n308), .B1(n187), .A0N(N74), .A1N(n138), .Y(n263) );
  OAI2BB2XL U479 ( .B0(n308), .B1(n186), .A0N(N73), .A1N(n138), .Y(n264) );
  OAI2BB2XL U480 ( .B0(n308), .B1(n185), .A0N(N72), .A1N(n138), .Y(n265) );
  OR2X1 U481 ( .A(n205), .B(n206), .Y(n306) );
  CLKBUFX3 U482 ( .A(n137), .Y(n308) );
  OAI21XL U483 ( .A0(n382), .A1(n25), .B0(sti_rd), .Y(n137) );
  XOR2X1 U484 ( .A(n25), .B(n201), .Y(n210) );
  OAI2BB2XL U485 ( .B0(n208), .B1(n381), .A0N(N66), .A1N(n381), .Y(n217) );
  ADDHXL U486 ( .A(counter[1]), .B(counter[0]), .CO(\add_64/carry [2]), .S(N63) );
  ADDHXL U487 ( .A(counter[2]), .B(\add_64/carry [2]), .CO(\add_64/carry [3]), 
        .S(N64) );
  ADDHXL U488 ( .A(counter[3]), .B(\add_64/carry [3]), .CO(\add_64/carry [4]), 
        .S(N65) );
  OAI21XL U489 ( .A0(n345), .A1(n379), .B0(n25), .Y(n211) );
  ADDHXL U490 ( .A(data_compare[3]), .B(\add_146/carry [3]), .CO(N378), .S(
        N377) );
  ADDHXL U491 ( .A(data_compare[1]), .B(data_compare[0]), .CO(
        \add_146/carry [2]), .S(N375) );
  ADDHXL U492 ( .A(data_compare[2]), .B(\add_146/carry [2]), .CO(
        \add_146/carry [3]), .S(N376) );
  OAI2BB2XL U493 ( .B0(n207), .B1(n381), .A0N(N65), .A1N(n381), .Y(n216) );
  OAI21XL U494 ( .A0(n346), .A1(n380), .B0(n28), .Y(n212) );
  OAI2BB2XL U495 ( .B0(n206), .B1(n381), .A0N(N64), .A1N(n381), .Y(n215) );
  OAI21XL U496 ( .A0(n347), .A1(n29), .B0(n30), .Y(n213) );
  OAI2BB2XL U497 ( .B0(n205), .B1(n381), .A0N(N63), .A1N(n381), .Y(n214) );
  OAI2BB2XL U498 ( .B0(n209), .B1(n381), .A0N(n209), .A1N(n381), .Y(n218) );
  INVX3 U499 ( .A(counter[4]), .Y(n381) );
  CLKBUFX3 U500 ( .A(reset), .Y(n330) );
  CLKBUFX3 U501 ( .A(reset), .Y(n329) );
  CLKBUFX3 U502 ( .A(reset), .Y(n328) );
  XNOR2X1 U503 ( .A(res_addr[13]), .B(\sub_116/carry [13]), .Y(N176) );
  OR2X1 U504 ( .A(res_addr[12]), .B(\sub_116/carry [12]), .Y(
        \sub_116/carry [13]) );
  XNOR2X1 U505 ( .A(\sub_116/carry [12]), .B(res_addr[12]), .Y(N175) );
  OR2X1 U506 ( .A(res_addr[11]), .B(\sub_116/carry [11]), .Y(
        \sub_116/carry [12]) );
  XNOR2X1 U507 ( .A(\sub_116/carry [11]), .B(res_addr[11]), .Y(N174) );
  OR2X1 U508 ( .A(res_addr[10]), .B(\sub_116/carry [10]), .Y(
        \sub_116/carry [11]) );
  XNOR2X1 U509 ( .A(\sub_116/carry [10]), .B(res_addr[10]), .Y(N173) );
  OR2X1 U510 ( .A(res_addr[9]), .B(\sub_116/carry [9]), .Y(\sub_116/carry [10]) );
  XNOR2X1 U511 ( .A(\sub_116/carry [9]), .B(res_addr[9]), .Y(N172) );
  OR2X1 U512 ( .A(res_addr[8]), .B(\sub_116/carry [8]), .Y(\sub_116/carry [9])
         );
  XNOR2X1 U513 ( .A(\sub_116/carry [8]), .B(res_addr[8]), .Y(N171) );
  OR2X1 U514 ( .A(res_addr[7]), .B(\sub_116/carry [7]), .Y(\sub_116/carry [8])
         );
  XNOR2X1 U515 ( .A(\sub_116/carry [7]), .B(res_addr[7]), .Y(N170) );
  AND2X1 U516 ( .A(\sub_116/carry [6]), .B(res_addr[6]), .Y(\sub_116/carry [7]) );
  XOR2X1 U517 ( .A(res_addr[6]), .B(\sub_116/carry [6]), .Y(N169) );
  AND2X1 U518 ( .A(\sub_116/carry [5]), .B(res_addr[5]), .Y(\sub_116/carry [6]) );
  XOR2X1 U519 ( .A(res_addr[5]), .B(\sub_116/carry [5]), .Y(N168) );
  AND2X1 U520 ( .A(\sub_116/carry [4]), .B(res_addr[4]), .Y(\sub_116/carry [5]) );
  XOR2X1 U521 ( .A(res_addr[4]), .B(\sub_116/carry [4]), .Y(N167) );
  AND2X1 U522 ( .A(\sub_116/carry [3]), .B(res_addr[3]), .Y(\sub_116/carry [4]) );
  XOR2X1 U523 ( .A(res_addr[3]), .B(\sub_116/carry [3]), .Y(N166) );
  XNOR2X1 U524 ( .A(res_addr[13]), .B(\sub_129/carry[13] ), .Y(N323) );
  OR2X1 U525 ( .A(res_addr[12]), .B(\sub_129/carry[12] ), .Y(
        \sub_129/carry[13] ) );
  XNOR2X1 U526 ( .A(\sub_129/carry[12] ), .B(res_addr[12]), .Y(N322) );
  OR2X1 U527 ( .A(res_addr[11]), .B(\sub_129/carry[11] ), .Y(
        \sub_129/carry[12] ) );
  XNOR2X1 U528 ( .A(\sub_129/carry[11] ), .B(res_addr[11]), .Y(N321) );
  OR2X1 U529 ( .A(res_addr[10]), .B(\sub_129/carry[10] ), .Y(
        \sub_129/carry[11] ) );
  XNOR2X1 U530 ( .A(\sub_129/carry[10] ), .B(res_addr[10]), .Y(N320) );
  OR2X1 U531 ( .A(res_addr[9]), .B(\sub_129/carry[9] ), .Y(\sub_129/carry[10] ) );
  XNOR2X1 U532 ( .A(\sub_129/carry[9] ), .B(res_addr[9]), .Y(N319) );
  OR2X1 U533 ( .A(res_addr[8]), .B(\sub_129/carry[8] ), .Y(\sub_129/carry[9] )
         );
  XNOR2X1 U534 ( .A(\sub_129/carry[8] ), .B(res_addr[8]), .Y(N318) );
  AND2X1 U535 ( .A(\sub_129/carry[7] ), .B(res_addr[7]), .Y(\sub_129/carry[8] ) );
  XOR2X1 U536 ( .A(res_addr[7]), .B(\sub_129/carry[7] ), .Y(N317) );
  OR2X1 U537 ( .A(res_addr[6]), .B(\sub_129/carry[6] ), .Y(\sub_129/carry[7] )
         );
  XNOR2X1 U538 ( .A(\sub_129/carry[6] ), .B(res_addr[6]), .Y(N316) );
  OR2X1 U539 ( .A(res_addr[5]), .B(\sub_129/carry[5] ), .Y(\sub_129/carry[6] )
         );
  XNOR2X1 U540 ( .A(\sub_129/carry[5] ), .B(res_addr[5]), .Y(N315) );
  OR2X1 U541 ( .A(res_addr[4]), .B(\sub_129/carry[4] ), .Y(\sub_129/carry[5] )
         );
  XNOR2X1 U542 ( .A(\sub_129/carry[4] ), .B(res_addr[4]), .Y(N314) );
  OR2X1 U543 ( .A(res_addr[3]), .B(\sub_129/carry[3] ), .Y(\sub_129/carry[4] )
         );
  XNOR2X1 U544 ( .A(\sub_129/carry[3] ), .B(res_addr[3]), .Y(N313) );
  XOR2X1 U545 ( .A(res_addr[13]), .B(\add_119/carry[13] ), .Y(N218) );
  AND2X1 U546 ( .A(\add_119/carry[12] ), .B(res_addr[12]), .Y(
        \add_119/carry[13] ) );
  XOR2X1 U547 ( .A(res_addr[12]), .B(\add_119/carry[12] ), .Y(N217) );
  AND2X1 U548 ( .A(\add_119/carry[11] ), .B(res_addr[11]), .Y(
        \add_119/carry[12] ) );
  XOR2X1 U549 ( .A(res_addr[11]), .B(\add_119/carry[11] ), .Y(N216) );
  AND2X1 U550 ( .A(\add_119/carry[10] ), .B(res_addr[10]), .Y(
        \add_119/carry[11] ) );
  XOR2X1 U551 ( .A(res_addr[10]), .B(\add_119/carry[10] ), .Y(N215) );
  AND2X1 U552 ( .A(\add_119/carry[9] ), .B(res_addr[9]), .Y(
        \add_119/carry[10] ) );
  XOR2X1 U553 ( .A(res_addr[9]), .B(\add_119/carry[9] ), .Y(N214) );
  AND2X1 U554 ( .A(\add_119/carry[8] ), .B(res_addr[8]), .Y(\add_119/carry[9] ) );
  XOR2X1 U555 ( .A(res_addr[8]), .B(\add_119/carry[8] ), .Y(N213) );
  OR2X1 U556 ( .A(res_addr[7]), .B(\add_119/carry[7] ), .Y(\add_119/carry[8] )
         );
  XNOR2X1 U557 ( .A(\add_119/carry[7] ), .B(res_addr[7]), .Y(N212) );
  AND2X1 U558 ( .A(\add_119/carry[6] ), .B(res_addr[6]), .Y(\add_119/carry[7] ) );
  XOR2X1 U559 ( .A(res_addr[6]), .B(\add_119/carry[6] ), .Y(N211) );
  AND2X1 U560 ( .A(\add_119/carry[5] ), .B(res_addr[5]), .Y(\add_119/carry[6] ) );
  XOR2X1 U561 ( .A(res_addr[5]), .B(\add_119/carry[5] ), .Y(N210) );
  AND2X1 U562 ( .A(\add_119/carry[4] ), .B(res_addr[4]), .Y(\add_119/carry[5] ) );
  XOR2X1 U563 ( .A(res_addr[4]), .B(\add_119/carry[4] ), .Y(N209) );
  AND2X1 U564 ( .A(\add_119/carry[3] ), .B(res_addr[3]), .Y(\add_119/carry[4] ) );
  XOR2X1 U565 ( .A(res_addr[3]), .B(\add_119/carry[3] ), .Y(N208) );
  XOR2X1 U566 ( .A(res_addr[13]), .B(\add_126/carry [13]), .Y(N281) );
  AND2X1 U567 ( .A(\add_126/carry [12]), .B(res_addr[12]), .Y(
        \add_126/carry [13]) );
  XOR2X1 U568 ( .A(res_addr[12]), .B(\add_126/carry [12]), .Y(N280) );
  AND2X1 U569 ( .A(\add_126/carry [11]), .B(res_addr[11]), .Y(
        \add_126/carry [12]) );
  XOR2X1 U570 ( .A(res_addr[11]), .B(\add_126/carry [11]), .Y(N279) );
  AND2X1 U571 ( .A(\add_126/carry [10]), .B(res_addr[10]), .Y(
        \add_126/carry [11]) );
  XOR2X1 U572 ( .A(res_addr[10]), .B(\add_126/carry [10]), .Y(N278) );
  AND2X1 U573 ( .A(\add_126/carry [9]), .B(res_addr[9]), .Y(
        \add_126/carry [10]) );
  XOR2X1 U574 ( .A(res_addr[9]), .B(\add_126/carry [9]), .Y(N277) );
  AND2X1 U575 ( .A(\add_126/carry [8]), .B(res_addr[8]), .Y(\add_126/carry [9]) );
  XOR2X1 U576 ( .A(res_addr[8]), .B(\add_126/carry [8]), .Y(N276) );
  AND2X1 U577 ( .A(\add_126/carry [7]), .B(res_addr[7]), .Y(\add_126/carry [8]) );
  XOR2X1 U578 ( .A(res_addr[7]), .B(\add_126/carry [7]), .Y(N275) );
  OR2X1 U579 ( .A(res_addr[6]), .B(\add_126/carry [6]), .Y(\add_126/carry [7])
         );
  XNOR2X1 U580 ( .A(\add_126/carry [6]), .B(res_addr[6]), .Y(N274) );
  OR2X1 U581 ( .A(res_addr[5]), .B(\add_126/carry [5]), .Y(\add_126/carry [6])
         );
  XNOR2X1 U582 ( .A(\add_126/carry [5]), .B(res_addr[5]), .Y(N273) );
  OR2X1 U583 ( .A(res_addr[4]), .B(\add_126/carry [4]), .Y(\add_126/carry [5])
         );
  XNOR2X1 U584 ( .A(\add_126/carry [4]), .B(res_addr[4]), .Y(N272) );
  OR2X1 U585 ( .A(res_addr[3]), .B(\add_126/carry [3]), .Y(\add_126/carry [4])
         );
  XNOR2X1 U586 ( .A(\add_126/carry [3]), .B(res_addr[3]), .Y(N271) );
  AND2X1 U587 ( .A(res_addr[1]), .B(res_addr[2]), .Y(\sub_116/carry [3]) );
  XOR2X1 U588 ( .A(res_addr[2]), .B(res_addr[1]), .Y(N165) );
  OR2X1 U589 ( .A(res_addr[2]), .B(\sub_129/carry[2] ), .Y(\sub_129/carry[3] )
         );
  XNOR2X1 U590 ( .A(\sub_129/carry[2] ), .B(res_addr[2]), .Y(N312) );
  AND2X1 U591 ( .A(\add_119/carry[2] ), .B(res_addr[2]), .Y(\add_119/carry[3] ) );
  XOR2X1 U592 ( .A(res_addr[2]), .B(\add_119/carry[2] ), .Y(N207) );
  OR2X1 U593 ( .A(res_addr[2]), .B(res_addr[1]), .Y(\add_126/carry [3]) );
  XNOR2X1 U594 ( .A(res_addr[1]), .B(res_addr[2]), .Y(N270) );
  OR2X1 U595 ( .A(res_addr[1]), .B(res_addr[0]), .Y(\sub_129/carry[2] ) );
  XNOR2X1 U596 ( .A(res_addr[0]), .B(res_addr[1]), .Y(N311) );
  AND2X1 U597 ( .A(res_addr[0]), .B(res_addr[1]), .Y(\add_119/carry[2] ) );
  XOR2X1 U598 ( .A(res_addr[1]), .B(res_addr[0]), .Y(N206) );
  XOR2X1 U599 ( .A(\add_64/carry [4]), .B(counter[4]), .Y(N66) );
  NOR2X1 U600 ( .A(n346), .B(N32), .Y(n340) );
  NOR2X1 U601 ( .A(n346), .B(n347), .Y(n339) );
  NOR2X1 U602 ( .A(n347), .B(N33), .Y(n337) );
  NOR2X1 U603 ( .A(N32), .B(N33), .Y(n336) );
  AO22X1 U604 ( .A0(sti_di[5]), .A1(n337), .B0(sti_di[4]), .B1(n336), .Y(n331)
         );
  AOI221XL U605 ( .A0(sti_di[6]), .A1(n340), .B0(sti_di[7]), .B1(n339), .C0(
        n331), .Y(n334) );
  AO22X1 U606 ( .A0(sti_di[1]), .A1(n337), .B0(sti_di[0]), .B1(n336), .Y(n332)
         );
  AOI221XL U607 ( .A0(sti_di[2]), .A1(n340), .B0(sti_di[3]), .B1(n339), .C0(
        n332), .Y(n333) );
  OA22X1 U608 ( .A0(n345), .A1(n334), .B0(N34), .B1(n333), .Y(n344) );
  AO22X1 U609 ( .A0(sti_di[13]), .A1(n337), .B0(sti_di[12]), .B1(n336), .Y(
        n335) );
  AOI221XL U610 ( .A0(sti_di[14]), .A1(n340), .B0(sti_di[15]), .B1(n339), .C0(
        n335), .Y(n342) );
  AO22X1 U611 ( .A0(sti_di[9]), .A1(n337), .B0(sti_di[8]), .B1(n336), .Y(n338)
         );
  AOI221XL U612 ( .A0(sti_di[10]), .A1(n340), .B0(sti_di[11]), .B1(n339), .C0(
        n338), .Y(n341) );
  OAI22XL U613 ( .A0(n342), .A1(n345), .B0(N34), .B1(n341), .Y(n343) );
  OAI2BB2XL U614 ( .B0(n344), .B1(n382), .A0N(n382), .A1N(n343), .Y(N372) );
  OAI222XL U615 ( .A0(res_di[3]), .A1(n356), .B0(res_di[3]), .B1(n348), .C0(
        n348), .C1(n356), .Y(n352) );
  AOI2BB2X1 U616 ( .B0(n349), .B1(data_compare[0]), .A0N(res_di[1]), .A1N(n354), .Y(n350) );
  OAI221XL U617 ( .A0(res_di[2]), .A1(n355), .B0(res_di[3]), .B1(n356), .C0(
        n350), .Y(n351) );
  NOR4X1 U618 ( .A(n353), .B(res_di[5]), .C(res_di[7]), .D(res_di[6]), .Y(N395) );
  AND2X1 U619 ( .A(N405), .B(n365), .Y(n357) );
  OAI222XL U620 ( .A0(N406), .A1(n364), .B0(N406), .B1(n357), .C0(n357), .C1(
        n364), .Y(n361) );
  AOI21X1 U621 ( .A0(N404), .A1(n363), .B0(N403), .Y(n358) );
  AOI2BB2X1 U622 ( .B0(n358), .B1(\data[0] ), .A0N(N404), .A1N(n363), .Y(n359)
         );
  OAI221XL U623 ( .A0(N405), .A1(n365), .B0(N406), .B1(n364), .C0(n359), .Y(
        n360) );
  NAND3BX1 U624 ( .AN(N407), .B(n361), .C(n360), .Y(n362) );
  DT_DW01_inc_0_DW01_inc_2 add_198 ( .A(res_di), .SUM({N410, N409, N408, N407, 
        N406, N405, N404, N403}) );
  DT_DW01_inc_2_DW01_inc_4 add_81 ( .A(sti_addr), .SUM({N81, N80, N79, N78, 
        N77, N76, N75, N74, N73, N72}) );
  DT_DW01_dec_0_DW01_dec_1 r429 ( .A(res_addr), .SUM({N132, N131, N130, N129, 
        N128, N127, N126, N125, N124, N123, N122, N121, N120, N119}) );
  DT_DW01_inc_4_DW01_inc_6 r428 ( .A(res_addr), .SUM({N117, N116, N115, N114, 
        N113, N112, N111, N110, N109, N108, N107, N106, N105, N104}) );
  DFFRX2 \sti_addr_reg[0]  ( .D(n265), .CK(clk), .RN(n328), .Q(sti_addr[0]), 
        .QN(n185) );
  DFFRX2 \state_reg[3]  ( .D(Next_state[3]), .CK(clk), .RN(reset), .Q(state[3]) );
  DFFRX2 \sti_addr_reg[9]  ( .D(n256), .CK(clk), .RN(reset), .Q(sti_addr[9]), 
        .QN(n194) );
  DFFRX2 \sti_addr_reg[8]  ( .D(n257), .CK(clk), .RN(n328), .Q(sti_addr[8]), 
        .QN(n193) );
  DFFRX2 \sti_addr_reg[7]  ( .D(n258), .CK(clk), .RN(n329), .Q(sti_addr[7]), 
        .QN(n192) );
  DFFRX2 \sti_addr_reg[6]  ( .D(n259), .CK(clk), .RN(n330), .Q(sti_addr[6]), 
        .QN(n191) );
  DFFRX2 \sti_addr_reg[5]  ( .D(n260), .CK(clk), .RN(n329), .Q(sti_addr[5]), 
        .QN(n190) );
  DFFRX2 \sti_addr_reg[4]  ( .D(n261), .CK(clk), .RN(n328), .Q(sti_addr[4]), 
        .QN(n189) );
  DFFRX2 \sti_addr_reg[3]  ( .D(n262), .CK(clk), .RN(n328), .Q(sti_addr[3]), 
        .QN(n188) );
  DFFRX2 \sti_addr_reg[2]  ( .D(n263), .CK(clk), .RN(n328), .Q(sti_addr[2]), 
        .QN(n187) );
  DFFRX2 \sti_addr_reg[1]  ( .D(n264), .CK(clk), .RN(n328), .Q(sti_addr[1]), 
        .QN(n186) );
  DFFRX2 \res_do_reg[4]  ( .D(n243), .CK(clk), .RN(reset), .Q(res_do[4]), .QN(
        n200) );
  DFFRX2 \res_do_reg[0]  ( .D(n244), .CK(clk), .RN(reset), .Q(res_do[0]), .QN(
        n199) );
endmodule

