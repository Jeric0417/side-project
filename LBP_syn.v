/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : T-2022.03
// Date      : Sun Jun  9 15:12:37 2024
/////////////////////////////////////////////////////////////


module LBP ( clk, reset, gray_addr, gray_req, gray_ready, gray_data, lbp_addr, 
        lbp_valid, lbp_data, finish );
  output [13:0] gray_addr;
  input [7:0] gray_data;
  output [13:0] lbp_addr;
  output [7:0] lbp_data;
  input clk, reset, gray_ready;
  output gray_req, lbp_valid, finish;
  wire   n867, n868, n869, n870, n871, n872, n873, n874, n875, n876, n877,
         n878, n879, n880, n881, n882, n883, n884, n885, n886, n887, n888,
         n889, n890, n891, n892, n893, n894, n895, n896, n897, n898, n899, N53,
         N54, N55, N71, N72, N73, N74, N75, N76, N77, N78, N79, N80, N529,
         N690, N691, N730, \C48/DATA3_0 , \C48/DATA3_1 , \C48/DATA3_2 ,
         \C48/DATA3_3 , \C48/DATA3_4 , \C48/DATA3_5 , \C48/DATA3_6 ,
         \C48/DATA3_7 , \C48/DATA3_8 , \C48/DATA3_9 , \C48/DATA3_10 ,
         \C48/DATA3_11 , \C48/DATA3_12 , \C47/DATA6_2 , \C47/DATA5_3 ,
         \C47/DATA4_4 , \C47/DATA3_5 , \C47/DATA2_6 , n298, n299, n300, n301,
         n302, n303, n304, n305, n306, n307, n308, n309, n310, n311, n312,
         n313, n314, n315, n316, n317, n318, n319, n320, n321, n322, n323,
         n324, n325, n326, n327, n328, n329, n330, n331, n332, n333, n334,
         n335, n336, n337, n338, n339, n340, n341, n342, n343, n344, n345,
         n346, n347, n348, n349, n350, n351, n352, n353, n354, n355, n356,
         n357, n358, n359, n360, n361, n362, n363, n364, n365, n366, n367,
         n368, n369, n370, n371, n372, n373, n374, n375, n376, n377, n378,
         n379, n380, n381, n382, n383, n384, n385, n386, n387, n388, n389,
         n390, n391, n392, n393, n394, n395, n396, n397, n398, n399, n401,
         n402, n403, n404, n405, n406, n407, n408, n409, n410, n411, n412,
         n413, n414, n415, n416, n417, n418, n419, n420, n421, n422, n423,
         n424, n425, n426, n427, n428, \C1/Z_0 , \DP_OP_193J1_123_1153/n26 ,
         \DP_OP_193J1_123_1153/n21 , \DP_OP_193J1_123_1153/n19 ,
         \DP_OP_193J1_123_1153/n14 , \DP_OP_193J1_123_1153/n13 ,
         \DP_OP_193J1_123_1153/n12 , \DP_OP_193J1_123_1153/n11 ,
         \DP_OP_193J1_123_1153/n10 , \DP_OP_193J1_123_1153/n9 ,
         \DP_OP_193J1_123_1153/n8 , \DP_OP_193J1_123_1153/n7 ,
         \DP_OP_193J1_123_1153/n6 , \DP_OP_193J1_123_1153/n5 ,
         \DP_OP_193J1_123_1153/n4 , \DP_OP_193J1_123_1153/n3 ,
         \DP_OP_193J1_123_1153/n2 , n436, n437, n438, n439, n440, n441, n442,
         n447, n449, n450, n452, n454, n456, n458, n460, n462, n464, n466,
         n468, n470, n472, n474, n477, n479, n481, n483, n485, n487, n489,
         n491, n493, n495, n497, n499, n501, n503, n505, n507, n509, n511,
         n513, n515, n517, n518, n519, n520, n521, n522, n523, n524, n525,
         n526, n527, n528, n529, n530, n531, n532, n533, n534, n535, n536,
         n537, n538, n539, n540, n541, n542, n543, n544, n545, n546, n547,
         n548, n549, n550, n551, n552, n553, n554, n555, n556, n557, n558,
         n559, n560, n561, n562, n563, n564, n565, n566, n567, n568, n569,
         n570, n571, n572, n573, n574, n575, n576, n577, n578, n579, n580,
         n581, n582, n583, n584, n585, n586, n587, n588, n589, n590, n591,
         n592, n593, n594, n595, n596, n597, n598, n599, n600, n601, n602,
         n603, n604, n605, n606, n607, n608, n609, n610, n611, n612, n613,
         n614, n615, n616, n617, n618, n619, n620, n621, n622, n623, n624,
         n625, n626, n627, n628, n629, n630, n631, n632, n633, n634, n635,
         n636, n637, n638, n639, n640, n641, n642, n643, n644, n645, n646,
         n647, n648, n649, n650, n651, n652, n653, n654, n655, n656, n657,
         n658, n659, n660, n661, n662, n663, n664, n665, n666, n667, n668,
         n669, n670, n671, n672, n673, n674, n675, n676, n677, n678, n679,
         n680, n681, n682, n683, n684, n685, n686, n687, n688, n689, n690,
         n691, n692, n693, n694, n695, n696, n697, n698, n699, n700, n701,
         n702, n703, n704, n705, n706, n707, n708, n709, n710, n711, n712,
         n713, n714, n715, n716, n717, n718, n719, n720, n721, n722, n723,
         n724, n725, n726, n727, n728, n729, n730, n731, n732, n733, n734,
         n735, n736, n737, n738, n739, n740, n741, n742, n743, n744, n745,
         n746, n747, n748, n749, n750, n751, n752, n753, n754, n755, n756,
         n757, n758, n759, n760, n761, n762, n763, n764, n765, n766, n767,
         n768, n769, n770, n771, n772, n773, n774, n775, n776, n777, n778,
         n779, n780, n781, n782, n783, n784, n785, n786, n787, n788, n789,
         n790, n791, n792, n793, n794, n795, n796, n797, n798, n799, n800,
         n801, n802, n803, n804, n805, n806, n807, n808, n809, n810, n811,
         n812, n813, n814, n815, n816, n817, n818, n819, n820, n821, n822,
         n823, n824, n825, n826, n827, n828, n829, n830, n831, n832, n833,
         n834, n835, n836, n837, n838, n839, n840, n841, n842, n843, n844,
         n845, n846, n847, n848, n849, n850, n851, n852, n853, n854, n855,
         n856, n857, n858, n859, n860, n861, n862, n863, n864, n865, n866;
  wire   [3:0] counter;
  wire   [10:0] edge_counter;
  wire   [13:0] gray_0;
  wire   [7:0] gray_data0;
  wire   [7:0] gray_data1;
  wire   [7:0] gray_data2;
  wire   [7:0] gray_data3;
  wire   [7:0] gray_data4;
  wire   [7:0] gray_data5;
  wire   [7:0] gray_data6;
  wire   [7:0] gray_data7;
  wire   [7:0] gray_data8;

  DFFRX2 \counter_reg[0]  ( .D(N53), .CK(clk), .RN(n437), .Q(counter[0]), .QN(
        n820) );
  DFFRX1 \edge_counter_reg[0]  ( .D(n829), .CK(clk), .RN(n866), .Q(
        edge_counter[0]), .QN(n829) );
  DFFRX1 \edge_counter_reg[1]  ( .D(N71), .CK(clk), .RN(n437), .Q(
        edge_counter[1]) );
  DFFRX1 \edge_counter_reg[2]  ( .D(N72), .CK(clk), .RN(n865), .Q(
        edge_counter[2]), .QN(n822) );
  DFFRX1 \edge_counter_reg[3]  ( .D(N73), .CK(clk), .RN(n864), .Q(
        edge_counter[3]), .QN(n824) );
  DFFRX1 \edge_counter_reg[4]  ( .D(N74), .CK(clk), .RN(n437), .Q(
        edge_counter[4]) );
  DFFRX1 \edge_counter_reg[5]  ( .D(N75), .CK(clk), .RN(n866), .Q(
        edge_counter[5]), .QN(n826) );
  DFFRX1 \edge_counter_reg[6]  ( .D(N76), .CK(clk), .RN(n865), .Q(
        edge_counter[6]) );
  DFFRX1 \edge_counter_reg[7]  ( .D(N77), .CK(clk), .RN(n437), .Q(
        edge_counter[7]), .QN(n852) );
  DFFRX1 \edge_counter_reg[8]  ( .D(N78), .CK(clk), .RN(n437), .Q(
        edge_counter[8]) );
  DFFRX1 \edge_counter_reg[9]  ( .D(N79), .CK(clk), .RN(n866), .Q(
        edge_counter[9]), .QN(n862) );
  DFFRX1 \edge_counter_reg[10]  ( .D(N80), .CK(clk), .RN(n864), .Q(
        edge_counter[10]) );
  DFFRX1 \gray_0_reg[13]  ( .D(n426), .CK(clk), .RN(n864), .Q(gray_0[13]), 
        .QN(n863) );
  DFFRX1 \gray_0_reg[12]  ( .D(n425), .CK(clk), .RN(n864), .Q(gray_0[12]), 
        .QN(n860) );
  DFFRX1 \gray_0_reg[11]  ( .D(n424), .CK(clk), .RN(n436), .Q(gray_0[11]), 
        .QN(n845) );
  DFFRX1 \gray_0_reg[10]  ( .D(n423), .CK(clk), .RN(n436), .Q(gray_0[10]), 
        .QN(n827) );
  DFFRX1 \gray_0_reg[9]  ( .D(n422), .CK(clk), .RN(n865), .Q(gray_0[9]), .QN(
        n825) );
  DFFRX1 \gray_0_reg[8]  ( .D(n421), .CK(clk), .RN(n437), .Q(gray_0[8]), .QN(
        n843) );
  DFFRX1 \gray_0_reg[6]  ( .D(n419), .CK(clk), .RN(n436), .Q(gray_0[6]), .QN(
        n861) );
  DFFRX1 \gray_0_reg[5]  ( .D(n418), .CK(clk), .RN(n437), .Q(gray_0[5]), .QN(
        n840) );
  DFFRX1 \gray_0_reg[4]  ( .D(n417), .CK(clk), .RN(n436), .Q(gray_0[4]), .QN(
        n842) );
  DFFRX1 \gray_0_reg[3]  ( .D(n416), .CK(clk), .RN(n436), .Q(gray_0[3]), .QN(
        n832) );
  DFFRX1 \gray_0_reg[1]  ( .D(n414), .CK(clk), .RN(n436), .Q(gray_0[1]), .QN(
        n841) );
  DFFRX1 \gray_data3_reg[7]  ( .D(n399), .CK(clk), .RN(n436), .Q(gray_data3[7]) );
  DFFRX1 \gray_data3_reg[6]  ( .D(n398), .CK(clk), .RN(n436), .Q(gray_data3[6]), .QN(n859) );
  DFFRX1 \gray_data3_reg[5]  ( .D(n397), .CK(clk), .RN(n436), .QN(n851) );
  DFFRX1 \gray_data3_reg[4]  ( .D(n396), .CK(clk), .RN(n436), .Q(gray_data3[4]) );
  DFFRX1 \gray_data3_reg[3]  ( .D(n395), .CK(clk), .RN(n436), .QN(n530) );
  DFFRX1 \gray_data3_reg[2]  ( .D(n394), .CK(clk), .RN(n436), .Q(gray_data3[2]) );
  DFFRX1 \gray_data3_reg[1]  ( .D(n393), .CK(clk), .RN(n436), .Q(gray_data3[1]), .QN(n837) );
  DFFRX1 \gray_data3_reg[0]  ( .D(n392), .CK(clk), .RN(n436), .Q(gray_data3[0]) );
  DFFRX1 \gray_data6_reg[7]  ( .D(n391), .CK(clk), .RN(n436), .Q(gray_data6[7]) );
  DFFRX1 \gray_data6_reg[6]  ( .D(n390), .CK(clk), .RN(n866), .Q(gray_data6[6]), .QN(n854) );
  DFFRX1 \gray_data6_reg[5]  ( .D(n389), .CK(clk), .RN(n866), .QN(n847) );
  DFFRX1 \gray_data6_reg[4]  ( .D(n388), .CK(clk), .RN(n866), .Q(gray_data6[4]) );
  DFFRX1 \gray_data6_reg[3]  ( .D(n387), .CK(clk), .RN(n866), .QN(n523) );
  DFFRX1 \gray_data6_reg[2]  ( .D(n386), .CK(clk), .RN(n866), .Q(gray_data6[2]) );
  DFFRX1 \gray_data6_reg[1]  ( .D(n385), .CK(clk), .RN(n866), .Q(gray_data6[1]), .QN(n835) );
  DFFRX1 \gray_data6_reg[0]  ( .D(n384), .CK(clk), .RN(n866), .Q(gray_data6[0]) );
  DFFRX1 \gray_data5_reg[7]  ( .D(n383), .CK(clk), .RN(n866), .Q(gray_data5[7]) );
  DFFRX1 \gray_data5_reg[6]  ( .D(n382), .CK(clk), .RN(n866), .Q(gray_data5[6]), .QN(n855) );
  DFFRX1 \gray_data5_reg[5]  ( .D(n381), .CK(clk), .RN(n866), .QN(n848) );
  DFFRX1 \gray_data5_reg[4]  ( .D(n380), .CK(clk), .RN(n866), .Q(gray_data5[4]) );
  DFFRX1 \gray_data5_reg[3]  ( .D(n379), .CK(clk), .RN(n866), .QN(n526) );
  DFFRX1 \gray_data5_reg[2]  ( .D(n378), .CK(clk), .RN(n437), .Q(gray_data5[2]) );
  DFFRX1 \gray_data5_reg[1]  ( .D(n377), .CK(clk), .RN(n437), .Q(gray_data5[1]), .QN(n836) );
  DFFRX1 \gray_data5_reg[0]  ( .D(n376), .CK(clk), .RN(n437), .Q(gray_data5[0]) );
  DFFRX1 \gray_data4_reg[7]  ( .D(n375), .CK(clk), .RN(n437), .Q(gray_data4[7]) );
  DFFRX1 \gray_data4_reg[6]  ( .D(n374), .CK(clk), .RN(n437), .Q(gray_data4[6]), .QN(n853) );
  DFFRX1 \gray_data4_reg[5]  ( .D(n373), .CK(clk), .RN(n437), .QN(n844) );
  DFFRX1 \gray_data4_reg[4]  ( .D(n372), .CK(clk), .RN(n437), .Q(gray_data4[4]) );
  DFFRX1 \gray_data4_reg[3]  ( .D(n371), .CK(clk), .RN(n437), .QN(n529) );
  DFFRX1 \gray_data4_reg[2]  ( .D(n370), .CK(clk), .RN(n437), .Q(gray_data4[2]) );
  DFFRX1 \gray_data4_reg[1]  ( .D(n369), .CK(clk), .RN(n437), .Q(gray_data4[1]), .QN(n833) );
  DFFRX1 \gray_data4_reg[0]  ( .D(n368), .CK(clk), .RN(n437), .Q(gray_data4[0]) );
  DFFRX1 \gray_data7_reg[7]  ( .D(n359), .CK(clk), .RN(n437), .Q(gray_data7[7]) );
  DFFRX1 \gray_data7_reg[6]  ( .D(n358), .CK(clk), .RN(n865), .Q(gray_data7[6]), .QN(n856) );
  DFFRX1 \gray_data7_reg[5]  ( .D(n357), .CK(clk), .RN(n865), .QN(n846) );
  DFFRX1 \gray_data7_reg[4]  ( .D(n356), .CK(clk), .RN(n865), .Q(gray_data7[4]) );
  DFFRX1 \gray_data7_reg[3]  ( .D(n355), .CK(clk), .RN(n865), .QN(n528) );
  DFFRX1 \gray_data7_reg[2]  ( .D(n354), .CK(clk), .RN(n865), .Q(gray_data7[2]) );
  DFFRX1 \gray_data7_reg[1]  ( .D(n353), .CK(clk), .RN(n865), .Q(gray_data7[1]), .QN(n834) );
  DFFRX1 \gray_data7_reg[0]  ( .D(n352), .CK(clk), .RN(n865), .Q(gray_data7[0]) );
  DFFRX1 \gray_data0_reg[7]  ( .D(n351), .CK(clk), .RN(n865), .Q(gray_data0[7]) );
  DFFRX1 \gray_data0_reg[5]  ( .D(n349), .CK(clk), .RN(n865), .Q(gray_data0[5]) );
  DFFRX1 \gray_data0_reg[4]  ( .D(n348), .CK(clk), .RN(n865), .Q(gray_data0[4]) );
  DFFRX1 \gray_data0_reg[3]  ( .D(n347), .CK(clk), .RN(n865), .Q(gray_data0[3]) );
  DFFRX1 \gray_data0_reg[2]  ( .D(n346), .CK(clk), .RN(n864), .Q(gray_data0[2]) );
  DFFRX1 \gray_data0_reg[0]  ( .D(n344), .CK(clk), .RN(n864), .Q(gray_data0[0]) );
  DFFRX1 \gray_data1_reg[7]  ( .D(n343), .CK(clk), .RN(n864), .Q(gray_data1[7]) );
  DFFRX1 \gray_data1_reg[6]  ( .D(n342), .CK(clk), .RN(n864), .Q(gray_data1[6]), .QN(n857) );
  DFFRX1 \gray_data1_reg[5]  ( .D(n341), .CK(clk), .RN(n864), .QN(n849) );
  DFFRX1 \gray_data1_reg[4]  ( .D(n340), .CK(clk), .RN(n864), .Q(gray_data1[4]) );
  DFFRX1 \gray_data1_reg[3]  ( .D(n339), .CK(clk), .RN(n864), .QN(n525) );
  DFFRX1 \gray_data1_reg[2]  ( .D(n338), .CK(clk), .RN(n864), .Q(gray_data1[2]) );
  DFFRX1 \gray_data1_reg[1]  ( .D(n337), .CK(clk), .RN(n864), .Q(gray_data1[1]), .QN(n838) );
  DFFRX1 \gray_data1_reg[0]  ( .D(n336), .CK(clk), .RN(n864), .Q(gray_data1[0]) );
  DFFRX1 \gray_data2_reg[7]  ( .D(n335), .CK(clk), .RN(n437), .Q(gray_data2[7]) );
  DFFRX1 \gray_data2_reg[6]  ( .D(n334), .CK(clk), .RN(n437), .Q(gray_data2[6]), .QN(n858) );
  DFFRX1 \gray_data2_reg[5]  ( .D(n333), .CK(clk), .RN(n437), .QN(n850) );
  DFFRX1 \gray_data2_reg[4]  ( .D(n332), .CK(clk), .RN(n437), .Q(gray_data2[4]) );
  DFFRX1 \gray_data2_reg[3]  ( .D(n331), .CK(clk), .RN(n437), .QN(n524) );
  DFFRX1 \gray_data2_reg[2]  ( .D(n330), .CK(clk), .RN(n437), .Q(gray_data2[2]) );
  DFFRX1 \gray_data2_reg[1]  ( .D(n329), .CK(clk), .RN(n437), .Q(gray_data2[1]), .QN(n839) );
  DFFRX1 \gray_data2_reg[0]  ( .D(n328), .CK(clk), .RN(n437), .Q(gray_data2[0]) );
  DFFRX1 \LBP_3_reg[3]  ( .D(n327), .CK(clk), .RN(n437), .Q(\C47/DATA5_3 ) );
  DFFRX1 \LBP_5_reg[5]  ( .D(n326), .CK(clk), .RN(n437), .Q(\C47/DATA3_5 ) );
  DFFRX1 \LBP_4_reg[4]  ( .D(n325), .CK(clk), .RN(n437), .Q(\C47/DATA4_4 ) );
  DFFRX1 \LBP_6_reg[6]  ( .D(n324), .CK(clk), .RN(n437), .Q(\C47/DATA2_6 ) );
  DFFRX1 \LBP_7_reg[7]  ( .D(n323), .CK(clk), .RN(n436), .Q(N529) );
  DFFRX1 \LBP_0_reg[0]  ( .D(n322), .CK(clk), .RN(n436), .Q(N690) );
  DFFRX1 \LBP_1_reg[1]  ( .D(n321), .CK(clk), .RN(n436), .Q(N691) );
  DFFRX1 \LBP_2_reg[2]  ( .D(n320), .CK(clk), .RN(n436), .Q(\C47/DATA6_2 ) );
  DFFSX1 \gray_0_reg[7]  ( .D(n420), .CK(clk), .SN(n437), .Q(gray_0[7]), .QN(
        n823) );
  DFFSX1 \gray_0_reg[0]  ( .D(n427), .CK(clk), .SN(n436), .Q(gray_0[0]), .QN(
        n828) );
  DFFQX1 \gray_data8_reg[7]  ( .D(n367), .CK(clk), .Q(gray_data8[7]) );
  DFFQX1 \gray_data8_reg[6]  ( .D(n366), .CK(clk), .Q(gray_data8[6]) );
  DFFQX1 \gray_data8_reg[5]  ( .D(n365), .CK(clk), .Q(gray_data8[5]) );
  DFFQX1 \gray_data8_reg[4]  ( .D(n364), .CK(clk), .Q(gray_data8[4]) );
  DFFQX1 \gray_data8_reg[3]  ( .D(n363), .CK(clk), .Q(gray_data8[3]) );
  DFFQX1 \gray_data8_reg[2]  ( .D(n362), .CK(clk), .Q(gray_data8[2]) );
  DFFQX1 \gray_data8_reg[1]  ( .D(n361), .CK(clk), .Q(gray_data8[1]) );
  DFFQX1 \gray_data8_reg[0]  ( .D(n360), .CK(clk), .Q(gray_data8[0]) );
  DFFRX1 gray_req_reg ( .D(n428), .CK(clk), .RN(n866), .QN(n472) );
  DFFRX1 lbp_valid_reg ( .D(n630), .CK(clk), .RN(n437), .QN(n474) );
  DFFRX1 \lbp_addr_reg[12]  ( .D(n310), .CK(clk), .RN(n436), .Q(n878), .QN(
        n491) );
  DFFRX1 \lbp_addr_reg[8]  ( .D(n306), .CK(clk), .RN(n437), .Q(n882), .QN(n493) );
  DFFRX1 \lbp_addr_reg[6]  ( .D(n304), .CK(clk), .RN(n436), .Q(n884), .QN(n495) );
  DFFRX1 \lbp_addr_reg[4]  ( .D(n302), .CK(clk), .RN(n437), .Q(n886), .QN(n497) );
  DFFRX1 \lbp_addr_reg[5]  ( .D(n303), .CK(clk), .RN(n436), .Q(n885), .QN(n499) );
  DFFRX1 \lbp_addr_reg[10]  ( .D(n308), .CK(clk), .RN(n437), .Q(n880), .QN(
        n501) );
  DFFRX1 \lbp_addr_reg[0]  ( .D(n298), .CK(clk), .RN(n436), .Q(n890), .QN(n503) );
  DFFRX1 \lbp_addr_reg[7]  ( .D(n305), .CK(clk), .RN(n436), .Q(n883), .QN(n505) );
  DFFRX1 \lbp_addr_reg[9]  ( .D(n307), .CK(clk), .RN(n437), .Q(n881), .QN(n507) );
  DFFRX1 \lbp_addr_reg[3]  ( .D(n301), .CK(clk), .RN(n437), .Q(n887), .QN(n509) );
  DFFRX1 \lbp_addr_reg[11]  ( .D(n309), .CK(clk), .RN(n436), .Q(n879), .QN(
        n511) );
  DFFRX1 \lbp_addr_reg[1]  ( .D(n299), .CK(clk), .RN(n864), .Q(n889), .QN(n513) );
  DFFRX1 \gray_addr_reg[5]  ( .D(n405), .CK(clk), .RN(n865), .Q(n874), .QN(
        n515) );
  ADDFXL \DP_OP_193J1_123_1153/U10  ( .A(\DP_OP_193J1_123_1153/n21 ), .B(
        gray_0[5]), .CI(\DP_OP_193J1_123_1153/n10 ), .CO(
        \DP_OP_193J1_123_1153/n9 ), .S(\C48/DATA3_5 ) );
  ADDFXL \DP_OP_193J1_123_1153/U9  ( .A(\DP_OP_193J1_123_1153/n21 ), .B(
        gray_0[6]), .CI(\DP_OP_193J1_123_1153/n9 ), .CO(
        \DP_OP_193J1_123_1153/n8 ), .S(\C48/DATA3_6 ) );
  ADDFXL \DP_OP_193J1_123_1153/U13  ( .A(\DP_OP_193J1_123_1153/n21 ), .B(
        gray_0[2]), .CI(\DP_OP_193J1_123_1153/n13 ), .CO(
        \DP_OP_193J1_123_1153/n12 ), .S(\C48/DATA3_2 ) );
  ADDFXL \DP_OP_193J1_123_1153/U15  ( .A(gray_0[0]), .B(\C1/Z_0 ), .CI(
        \DP_OP_193J1_123_1153/n26 ), .CO(\DP_OP_193J1_123_1153/n14 ), .S(
        \C48/DATA3_0 ) );
  ADDFXL \DP_OP_193J1_123_1153/U11  ( .A(\DP_OP_193J1_123_1153/n21 ), .B(
        gray_0[4]), .CI(\DP_OP_193J1_123_1153/n11 ), .CO(
        \DP_OP_193J1_123_1153/n10 ), .S(\C48/DATA3_4 ) );
  ADDFX1 \DP_OP_193J1_123_1153/U3  ( .A(\C1/Z_0 ), .B(gray_0[12]), .CI(
        \DP_OP_193J1_123_1153/n3 ), .CO(\DP_OP_193J1_123_1153/n2 ), .S(
        \C48/DATA3_12 ) );
  ADDFX1 \DP_OP_193J1_123_1153/U4  ( .A(\C1/Z_0 ), .B(gray_0[11]), .CI(
        \DP_OP_193J1_123_1153/n4 ), .CO(\DP_OP_193J1_123_1153/n3 ), .S(
        \C48/DATA3_11 ) );
  ADDFX1 \DP_OP_193J1_123_1153/U5  ( .A(\C1/Z_0 ), .B(gray_0[10]), .CI(
        \DP_OP_193J1_123_1153/n5 ), .CO(\DP_OP_193J1_123_1153/n4 ), .S(
        \C48/DATA3_10 ) );
  ADDFXL \DP_OP_193J1_123_1153/U6  ( .A(\C1/Z_0 ), .B(gray_0[9]), .CI(
        \DP_OP_193J1_123_1153/n6 ), .CO(\DP_OP_193J1_123_1153/n5 ), .S(
        \C48/DATA3_9 ) );
  ADDFXL \DP_OP_193J1_123_1153/U14  ( .A(\DP_OP_193J1_123_1153/n21 ), .B(
        gray_0[1]), .CI(\DP_OP_193J1_123_1153/n14 ), .CO(
        \DP_OP_193J1_123_1153/n13 ), .S(\C48/DATA3_1 ) );
  DFFSX1 \counter_reg[3]  ( .D(n543), .CK(clk), .SN(n437), .Q(n830), .QN(
        counter[3]) );
  DFFRX1 \counter_reg[1]  ( .D(N54), .CK(clk), .RN(n436), .Q(counter[1]), .QN(
        n821) );
  DFFRX1 \gray_addr_reg[7]  ( .D(n407), .CK(clk), .RN(n865), .Q(n872), .QN(
        n489) );
  DFFRX1 \gray_addr_reg[6]  ( .D(n406), .CK(clk), .RN(n437), .Q(n873), .QN(
        n487) );
  DFFRX1 \gray_addr_reg[1]  ( .D(n401), .CK(clk), .RN(n436), .Q(n876), .QN(
        n485) );
  DFFRX1 \gray_addr_reg[10]  ( .D(n410), .CK(clk), .RN(n865), .Q(n870), .QN(
        n483) );
  DFFRX1 \gray_addr_reg[3]  ( .D(n403), .CK(clk), .RN(n436), .Q(n875), .QN(
        n481) );
  DFFRX1 \gray_addr_reg[11]  ( .D(n411), .CK(clk), .RN(n866), .Q(n869), .QN(
        n479) );
  DFFRX1 \gray_addr_reg[12]  ( .D(n412), .CK(clk), .RN(n437), .Q(n868), .QN(
        n477) );
  DFFRX1 \lbp_addr_reg[2]  ( .D(n300), .CK(clk), .RN(n436), .Q(n888), .QN(n470) );
  DFFRX1 \lbp_addr_reg[13]  ( .D(n311), .CK(clk), .RN(n436), .Q(n877), .QN(
        n468) );
  DFFRX1 \lbp_data_reg[1]  ( .D(n313), .CK(clk), .RN(n436), .Q(n897), .QN(n466) );
  DFFRX1 \lbp_data_reg[2]  ( .D(n314), .CK(clk), .RN(n436), .Q(n896), .QN(n464) );
  DFFRX1 \lbp_data_reg[3]  ( .D(n315), .CK(clk), .RN(n436), .Q(n895), .QN(n462) );
  DFFRX1 \lbp_data_reg[4]  ( .D(n316), .CK(clk), .RN(n436), .Q(n894), .QN(n460) );
  DFFRX1 \lbp_data_reg[5]  ( .D(n317), .CK(clk), .RN(n436), .Q(n893), .QN(n458) );
  DFFRX1 \lbp_data_reg[6]  ( .D(n318), .CK(clk), .RN(n436), .Q(n892), .QN(n456) );
  DFFRX1 \lbp_data_reg[7]  ( .D(n319), .CK(clk), .RN(n436), .Q(n891), .QN(n454) );
  DFFRX1 \lbp_data_reg[0]  ( .D(n312), .CK(clk), .RN(n436), .Q(n898), .QN(n452) );
  DFFRX2 \gray_data0_reg[1]  ( .D(n345), .CK(clk), .RN(n864), .Q(gray_data0[1]), .QN(n440) );
  DFFRX2 \gray_data0_reg[6]  ( .D(n350), .CK(clk), .RN(n865), .Q(gray_data0[6]), .QN(n527) );
  DFFRHQX1 \gray_addr_reg[8]  ( .D(n408), .CK(clk), .RN(n437), .Q(n871) );
  DFFRX1 \gray_addr_reg[9]  ( .D(n409), .CK(clk), .RN(n436), .QN(n441) );
  DFFRX1 \gray_addr_reg[2]  ( .D(n402), .CK(clk), .RN(n436), .QN(n439) );
  DFFSX1 \gray_addr_reg[0]  ( .D(n819), .CK(clk), .SN(n864), .Q(n442) );
  DFFRX1 \gray_addr_reg[4]  ( .D(n404), .CK(clk), .RN(n436), .QN(n438) );
  DFFRX2 \gray_0_reg[2]  ( .D(n415), .CK(clk), .RN(n864), .Q(gray_0[2]) );
  DFFRX2 \counter_reg[2]  ( .D(N55), .CK(clk), .RN(n437), .Q(counter[2]), .QN(
        n831) );
  DFFRHQX1 finish_reg ( .D(N730), .CK(clk), .RN(n436), .Q(n899) );
  ADDFX1 \DP_OP_193J1_123_1153/U12  ( .A(\DP_OP_193J1_123_1153/n21 ), .B(
        gray_0[3]), .CI(\DP_OP_193J1_123_1153/n12 ), .CO(
        \DP_OP_193J1_123_1153/n11 ), .S(\C48/DATA3_3 ) );
  ADDFX1 \DP_OP_193J1_123_1153/U8  ( .A(\DP_OP_193J1_123_1153/n19 ), .B(
        gray_0[7]), .CI(\DP_OP_193J1_123_1153/n8 ), .CO(
        \DP_OP_193J1_123_1153/n7 ), .S(\C48/DATA3_7 ) );
  ADDFX1 \DP_OP_193J1_123_1153/U7  ( .A(\C1/Z_0 ), .B(gray_0[8]), .CI(
        \DP_OP_193J1_123_1153/n7 ), .CO(\DP_OP_193J1_123_1153/n6 ), .S(
        \C48/DATA3_8 ) );
  DFFRHQX1 \gray_addr_reg[13]  ( .D(n413), .CK(clk), .RN(n866), .Q(n867) );
  INVX1 U456 ( .A(n758), .Y(n656) );
  NAND2XL U457 ( .A(gray_0[8]), .B(n607), .Y(n577) );
  INVX2 U458 ( .A(n538), .Y(n534) );
  CLKAND2X3 U459 ( .A(n538), .B(n537), .Y(n687) );
  INVX6 U460 ( .A(n428), .Y(n630) );
  CLKBUFX8 U461 ( .A(n559), .Y(n436) );
  NAND2X2 U462 ( .A(n630), .B(n596), .Y(n564) );
  INVX2 U463 ( .A(n450), .Y(n707) );
  NAND2X2 U464 ( .A(n738), .B(n538), .Y(n533) );
  INVX2 U465 ( .A(n714), .Y(n713) );
  INVX2 U466 ( .A(n705), .Y(n704) );
  INVX2 U467 ( .A(n710), .Y(n709) );
  INVX2 U468 ( .A(n449), .Y(n702) );
  INVX2 U469 ( .A(n727), .Y(n728) );
  AND2X1 U470 ( .A(n703), .B(n712), .Y(n543) );
  INVX2 U471 ( .A(n721), .Y(n722) );
  INVX2 U472 ( .A(n719), .Y(n720) );
  INVX2 U473 ( .A(n563), .Y(n708) );
  NOR2X2 U474 ( .A(n711), .B(n596), .Y(n565) );
  NAND2X2 U475 ( .A(n738), .B(gray_ready), .Y(n563) );
  INVX1 U476 ( .A(n871), .Y(n447) );
  INVX2 U477 ( .A(gray_data0[0]), .Y(n803) );
  INVX2 U478 ( .A(gray_data[6]), .Y(n723) );
  CLKBUFX8 U479 ( .A(n559), .Y(n437) );
  INVX2 U480 ( .A(gray_data[1]), .Y(n726) );
  INVX2 U481 ( .A(gray_data[3]), .Y(n725) );
  INVX2 U482 ( .A(gray_data[5]), .Y(n724) );
  CLKINVX1 U483 ( .A(n792), .Y(n651) );
  NOR3X1 U484 ( .A(n601), .B(n562), .C(n711), .Y(n538) );
  INVXL U485 ( .A(n662), .Y(n660) );
  BUFX2 U486 ( .A(n535), .Y(n691) );
  NAND2XL U487 ( .A(n618), .B(gray_0[6]), .Y(n567) );
  AND2X1 U488 ( .A(n587), .B(n668), .Y(n586) );
  NAND2XL U489 ( .A(n565), .B(n587), .Y(n592) );
  NAND2XL U490 ( .A(gray_0[12]), .B(n586), .Y(n593) );
  INVXL U491 ( .A(n691), .Y(n637) );
  NAND2XL U492 ( .A(n575), .B(n668), .Y(n627) );
  NAND2XL U493 ( .A(gray_0[5]), .B(n575), .Y(n566) );
  AND2X1 U494 ( .A(n565), .B(n575), .Y(n619) );
  NAND2XL U495 ( .A(n618), .B(n668), .Y(n617) );
  AND2X1 U496 ( .A(n565), .B(n618), .Y(n611) );
  NAND2XL U497 ( .A(n610), .B(n668), .Y(n609) );
  AND2X1 U498 ( .A(n565), .B(n610), .Y(n578) );
  NAND2XL U499 ( .A(n565), .B(n569), .Y(n583) );
  INVXL U500 ( .A(n582), .Y(n569) );
  OAI211XL U501 ( .A0(gray_0[2]), .A1(n603), .B0(n565), .C0(n625), .Y(n606) );
  NAND2XL U502 ( .A(n687), .B(\C48/DATA3_1 ), .Y(n682) );
  INVXL U503 ( .A(n533), .Y(n680) );
  INVXL U504 ( .A(n592), .Y(n594) );
  CLKINVX1 U505 ( .A(gray_ready), .Y(n711) );
  NAND2XL U506 ( .A(gray_0[4]), .B(n623), .Y(n616) );
  NAND2XL U507 ( .A(gray_0[6]), .B(n615), .Y(n608) );
  NAND2XL U508 ( .A(gray_0[10]), .B(n571), .Y(n581) );
  NAND2XL U509 ( .A(gray_0[12]), .B(n591), .Y(n590) );
  NAND2BX1 U510 ( .AN(n692), .B(n520), .Y(n519) );
  INVXL U511 ( .A(n521), .Y(n520) );
  NAND2BX1 U512 ( .AN(n694), .B(n522), .Y(n521) );
  XOR2X1 U513 ( .A(\C1/Z_0 ), .B(gray_0[13]), .Y(n669) );
  INVXL U514 ( .A(n768), .Y(n712) );
  INVXL U515 ( .A(n550), .Y(n542) );
  INVXL U516 ( .A(gray_data8[1]), .Y(n770) );
  INVXL U517 ( .A(gray_data8[3]), .Y(n772) );
  INVXL U518 ( .A(gray_data8[5]), .Y(n776) );
  NAND2XL U519 ( .A(edge_counter[8]), .B(n699), .Y(n698) );
  NAND4BX1 U520 ( .AN(n695), .B(edge_counter[10]), .C(edge_counter[5]), .D(
        edge_counter[6]), .Y(n532) );
  NAND2XL U521 ( .A(edge_counter[6]), .B(n597), .Y(n599) );
  NAND2XL U522 ( .A(edge_counter[4]), .B(n697), .Y(n696) );
  INVXL U523 ( .A(n544), .Y(n545) );
  NOR2XL U524 ( .A(n695), .B(n822), .Y(n544) );
  OAI211XL U525 ( .A0(n533), .A1(n636), .B0(n635), .C0(n634), .Y(n404) );
  NAND2XL U526 ( .A(n534), .B(gray_addr[0]), .Y(n540) );
  OAI211XL U527 ( .A0(n533), .A1(n640), .B0(n639), .C0(n638), .Y(n402) );
  AOI22XL U528 ( .A0(n637), .A1(gray_0[2]), .B0(n687), .B1(\C48/DATA3_2 ), .Y(
        n638) );
  NAND2XL U529 ( .A(n687), .B(\C48/DATA3_9 ), .Y(n686) );
  NAND2XL U530 ( .A(n534), .B(gray_addr[8]), .Y(n632) );
  OAI2BB1XL U531 ( .A0N(n562), .A1N(n898), .B0(n561), .Y(n312) );
  NAND2XL U532 ( .A(n687), .B(\C48/DATA3_12 ), .Y(n676) );
  NAND2XL U533 ( .A(n687), .B(\C48/DATA3_11 ), .Y(n690) );
  OAI211XL U534 ( .A0(n533), .A1(n655), .B0(n654), .C0(n653), .Y(n403) );
  NAND2XL U535 ( .A(n687), .B(\C48/DATA3_10 ), .Y(n679) );
  OAI211XL U536 ( .A0(n533), .A1(n649), .B0(n648), .C0(n647), .Y(n407) );
  INVXL U537 ( .A(n517), .Y(N730) );
  NAND2BX1 U538 ( .AN(n693), .B(n518), .Y(n517) );
  INVXL U539 ( .A(n519), .Y(n518) );
  OAI211XL U540 ( .A0(n533), .A1(n646), .B0(n645), .C0(n644), .Y(n405) );
  INVXL U541 ( .A(n564), .Y(n663) );
  OAI211XL U542 ( .A0(n564), .A1(n649), .B0(n614), .C0(n613), .Y(n420) );
  NAND2XL U543 ( .A(gray_0[7]), .B(n609), .Y(n614) );
  INVXL U544 ( .A(gray_data[0]), .Y(n718) );
  INVXL U545 ( .A(gray_data[7]), .Y(n716) );
  NAND3XL U546 ( .A(n565), .B(n626), .C(n832), .Y(n629) );
  NAND2XL U547 ( .A(gray_0[3]), .B(n627), .Y(n628) );
  OAI211XL U548 ( .A0(n564), .A1(n646), .B0(n622), .C0(n621), .Y(n418) );
  NAND3XL U549 ( .A(n620), .B(gray_0[4]), .C(n619), .Y(n621) );
  NAND2XL U550 ( .A(gray_0[5]), .B(n617), .Y(n622) );
  NAND3XL U551 ( .A(n582), .B(gray_0[8]), .C(n578), .Y(n572) );
  NOR3XL U552 ( .A(n587), .B(n583), .C(n827), .Y(n584) );
  AOI21XL U553 ( .A0(gray_0[13]), .A1(n593), .B0(n588), .Y(n589) );
  AOI211XL U554 ( .A0(edge_counter[10]), .A1(n602), .B0(n601), .C0(n600), .Y(
        N80) );
  AOI21XL U555 ( .A0(n862), .A1(n698), .B0(n602), .Y(N79) );
  OAI211XL U556 ( .A0(n564), .A1(n640), .B0(n606), .C0(n605), .Y(n415) );
  NAND2X2 U557 ( .A(gray_ready), .B(n715), .Y(n719) );
  INVX16 U558 ( .A(n438), .Y(gray_addr[4]) );
  INVX16 U559 ( .A(n442), .Y(gray_addr[0]) );
  INVX16 U560 ( .A(n439), .Y(gray_addr[2]) );
  INVX16 U561 ( .A(n441), .Y(gray_addr[9]) );
  INVX16 U562 ( .A(n447), .Y(gray_addr[8]) );
  INVX1 U563 ( .A(reset), .Y(n559) );
  NAND2XL U564 ( .A(n534), .B(gray_addr[4]), .Y(n635) );
  BUFX2 U565 ( .A(n701), .Y(n449) );
  NAND2XL U566 ( .A(n818), .B(gray_ready), .Y(n701) );
  BUFX2 U567 ( .A(n706), .Y(n450) );
  NAND2XL U568 ( .A(n758), .B(gray_ready), .Y(n706) );
  NAND2X2 U569 ( .A(n792), .B(gray_ready), .Y(n721) );
  NAND2X2 U570 ( .A(n802), .B(gray_ready), .Y(n727) );
  BUFX12 U571 ( .A(n899), .Y(finish) );
  INVX12 U572 ( .A(n452), .Y(lbp_data[0]) );
  INVX12 U573 ( .A(n454), .Y(lbp_data[7]) );
  INVX12 U574 ( .A(n456), .Y(lbp_data[6]) );
  INVX12 U575 ( .A(n458), .Y(lbp_data[5]) );
  INVX12 U576 ( .A(n460), .Y(lbp_data[4]) );
  INVX12 U577 ( .A(n462), .Y(lbp_data[3]) );
  INVX12 U578 ( .A(n464), .Y(lbp_data[2]) );
  INVX12 U579 ( .A(n466), .Y(lbp_data[1]) );
  INVX12 U580 ( .A(n468), .Y(lbp_addr[13]) );
  INVX12 U581 ( .A(n470), .Y(lbp_addr[2]) );
  INVX12 U582 ( .A(n472), .Y(gray_req) );
  NAND2X1 U583 ( .A(n782), .B(gray_ready), .Y(n428) );
  INVX12 U584 ( .A(n474), .Y(lbp_valid) );
  BUFX12 U585 ( .A(n867), .Y(gray_addr[13]) );
  AOI2BB2X1 U586 ( .B0(n534), .B1(n867), .A0N(n533), .A1N(n671), .Y(n672) );
  INVX12 U587 ( .A(n477), .Y(gray_addr[12]) );
  NAND2XL U588 ( .A(n867), .B(n868), .Y(n694) );
  INVX12 U589 ( .A(n479), .Y(gray_addr[11]) );
  INVX12 U590 ( .A(n481), .Y(gray_addr[3]) );
  NAND2XL U591 ( .A(n534), .B(n875), .Y(n654) );
  INVX12 U592 ( .A(n483), .Y(gray_addr[10]) );
  AOI2BB2X1 U593 ( .B0(n534), .B1(n870), .A0N(n533), .A1N(n677), .Y(n678) );
  NAND4XL U594 ( .A(n869), .B(n870), .C(gray_addr[9]), .D(gray_addr[8]), .Y(
        n692) );
  INVX12 U595 ( .A(n485), .Y(gray_addr[1]) );
  AOI22XL U596 ( .A0(n534), .A1(n876), .B0(n681), .B1(n680), .Y(n683) );
  NAND4XL U597 ( .A(n875), .B(gray_addr[2]), .C(n876), .D(gray_addr[0]), .Y(
        n693) );
  INVX12 U598 ( .A(n487), .Y(gray_addr[6]) );
  NAND2XL U599 ( .A(n534), .B(n873), .Y(n642) );
  INVX12 U600 ( .A(n489), .Y(gray_addr[7]) );
  NAND2XL U601 ( .A(n534), .B(n872), .Y(n648) );
  INVX12 U602 ( .A(n491), .Y(lbp_addr[12]) );
  INVX12 U603 ( .A(n493), .Y(lbp_addr[8]) );
  AOI2BB2X1 U604 ( .B0(n630), .B1(n843), .A0N(n630), .A1N(n882), .Y(n306) );
  INVX12 U605 ( .A(n495), .Y(lbp_addr[6]) );
  AOI2BB2X1 U606 ( .B0(n630), .B1(n861), .A0N(n630), .A1N(n884), .Y(n304) );
  INVX12 U607 ( .A(n497), .Y(lbp_addr[4]) );
  AOI2BB2X1 U608 ( .B0(n630), .B1(n842), .A0N(n630), .A1N(n886), .Y(n302) );
  INVX12 U609 ( .A(n499), .Y(lbp_addr[5]) );
  AOI2BB2X1 U610 ( .B0(n630), .B1(n840), .A0N(n630), .A1N(n885), .Y(n303) );
  INVX12 U611 ( .A(n501), .Y(lbp_addr[10]) );
  AOI2BB2X1 U612 ( .B0(n630), .B1(n827), .A0N(n630), .A1N(n880), .Y(n308) );
  INVX12 U613 ( .A(n503), .Y(lbp_addr[0]) );
  AOI2BB2X1 U614 ( .B0(n630), .B1(n828), .A0N(n630), .A1N(n890), .Y(n298) );
  INVX12 U615 ( .A(n505), .Y(lbp_addr[7]) );
  AOI2BB2X1 U616 ( .B0(n630), .B1(n823), .A0N(n630), .A1N(n883), .Y(n305) );
  INVX12 U617 ( .A(n507), .Y(lbp_addr[9]) );
  AOI2BB2X1 U618 ( .B0(n630), .B1(n825), .A0N(n630), .A1N(n881), .Y(n307) );
  INVX12 U619 ( .A(n509), .Y(lbp_addr[3]) );
  AOI2BB2X1 U620 ( .B0(n630), .B1(n832), .A0N(n630), .A1N(n887), .Y(n301) );
  INVX12 U621 ( .A(n511), .Y(lbp_addr[11]) );
  AOI2BB2X1 U622 ( .B0(n630), .B1(n845), .A0N(n630), .A1N(n879), .Y(n309) );
  INVX12 U623 ( .A(n513), .Y(lbp_addr[1]) );
  AOI2BB2X1 U624 ( .B0(n630), .B1(n841), .A0N(n630), .A1N(n889), .Y(n299) );
  INVX12 U625 ( .A(n515), .Y(gray_addr[5]) );
  NAND2XL U626 ( .A(n534), .B(n874), .Y(n645) );
  NOR4BBX1 U627 ( .AN(n874), .BN(gray_addr[4]), .C(n487), .D(n489), .Y(n522)
         );
  AOI22XL U628 ( .A0(n637), .A1(gray_0[0]), .B0(n687), .B1(\C48/DATA3_0 ), .Y(
        n539) );
  NAND3XL U629 ( .A(gray_0[2]), .B(gray_0[0]), .C(gray_0[1]), .Y(n624) );
  NOR2XL U630 ( .A(n604), .B(n582), .Y(n573) );
  OAI211XL U631 ( .A0(n533), .A1(gray_0[0]), .B0(n540), .C0(n539), .Y(n541) );
  NAND2XL U632 ( .A(n534), .B(gray_addr[2]), .Y(n639) );
  INVXL U633 ( .A(n658), .Y(n558) );
  NAND3XL U634 ( .A(n612), .B(gray_0[6]), .C(n611), .Y(n613) );
  INVXL U635 ( .A(n703), .Y(n748) );
  INVXL U636 ( .A(gray_data[4]), .Y(n717) );
  MX2X1 U637 ( .A(n583), .B(n573), .S0(gray_0[10]), .Y(n570) );
  NOR2XL U638 ( .A(edge_counter[10]), .B(n602), .Y(n600) );
  OAI211XL U639 ( .A0(n533), .A1(n633), .B0(n632), .C0(n631), .Y(n408) );
  OAI211XL U640 ( .A0(n533), .A1(n643), .B0(n642), .C0(n641), .Y(n406) );
  AOI2BB2X1 U641 ( .B0(n630), .B1(n860), .A0N(n630), .A1N(n878), .Y(n310) );
  OAI211XL U642 ( .A0(n564), .A1(n655), .B0(n629), .C0(n628), .Y(n416) );
  AOI211XL U643 ( .A0(n852), .A1(n599), .B0(n699), .C0(n601), .Y(N77) );
  NAND3X1 U644 ( .A(n821), .B(n830), .C(counter[2]), .Y(n554) );
  NOR2X1 U645 ( .A(n820), .B(n554), .Y(n738) );
  NAND2X1 U646 ( .A(edge_counter[0]), .B(edge_counter[1]), .Y(n695) );
  NOR4XL U647 ( .A(edge_counter[8]), .B(edge_counter[2]), .C(edge_counter[4]), 
        .D(edge_counter[9]), .Y(n531) );
  NAND4BX1 U648 ( .AN(n532), .B(edge_counter[3]), .C(edge_counter[7]), .D(n531), .Y(n596) );
  CLKINVX1 U649 ( .A(n596), .Y(n601) );
  NOR2X1 U650 ( .A(counter[1]), .B(counter[2]), .Y(n549) );
  NOR2X2 U651 ( .A(n549), .B(n830), .Y(n562) );
  NOR2X1 U652 ( .A(counter[3]), .B(counter[0]), .Y(n551) );
  NAND3XL U653 ( .A(n538), .B(n549), .C(n551), .Y(n535) );
  OAI22XL U654 ( .A0(counter[0]), .A1(counter[2]), .B0(n820), .B1(n831), .Y(
        n536) );
  NAND3XL U655 ( .A(n830), .B(n821), .C(n536), .Y(n537) );
  INVXL U656 ( .A(n541), .Y(n819) );
  NOR2X1 U657 ( .A(n820), .B(counter[3]), .Y(n548) );
  NAND2X1 U658 ( .A(n548), .B(counter[1]), .Y(n550) );
  NAND2X1 U659 ( .A(n542), .B(counter[2]), .Y(n703) );
  NAND2X1 U660 ( .A(n549), .B(counter[3]), .Y(n658) );
  NOR2X1 U661 ( .A(counter[0]), .B(n658), .Y(n768) );
  NOR2X1 U662 ( .A(n820), .B(n658), .Y(n782) );
  AOI211XL U663 ( .A0(n695), .A1(n822), .B0(n544), .C0(n601), .Y(N72) );
  NOR2X1 U664 ( .A(n824), .B(n545), .Y(n697) );
  AOI211XL U665 ( .A0(n824), .A1(n545), .B0(n697), .C0(n601), .Y(N73) );
  NAND2XL U666 ( .A(counter[2]), .B(n830), .Y(n547) );
  NOR3XL U667 ( .A(n820), .B(n821), .C(n831), .Y(n546) );
  AOI21XL U668 ( .A0(n550), .A1(n547), .B0(n546), .Y(N55) );
  NOR2X1 U669 ( .A(n826), .B(n696), .Y(n597) );
  AOI211XL U670 ( .A0(n826), .A1(n696), .B0(n597), .C0(n601), .Y(N75) );
  NOR2X1 U671 ( .A(n554), .B(counter[0]), .Y(n818) );
  NAND2X1 U672 ( .A(n549), .B(n548), .Y(n650) );
  CLKINVX1 U673 ( .A(n650), .Y(n715) );
  NOR2X2 U674 ( .A(n818), .B(n715), .Y(n659) );
  NOR2X2 U675 ( .A(n550), .B(counter[2]), .Y(n802) );
  INVX3 U676 ( .A(n802), .Y(n657) );
  NAND2X1 U677 ( .A(n551), .B(counter[1]), .Y(n700) );
  NOR2X2 U678 ( .A(n700), .B(counter[2]), .Y(n792) );
  NAND3X4 U679 ( .A(n659), .B(n657), .C(n651), .Y(\C1/Z_0 ) );
  NOR2X2 U680 ( .A(n700), .B(n831), .Y(n758) );
  NOR3X1 U681 ( .A(n748), .B(n758), .C(n558), .Y(n556) );
  NAND3BX1 U682 ( .AN(n802), .B(n556), .C(n554), .Y(n560) );
  AO22X1 U683 ( .A0(N691), .A1(n560), .B0(n562), .B1(n897), .Y(n313) );
  NAND2XL U684 ( .A(n703), .B(n658), .Y(n552) );
  AO22X1 U685 ( .A0(\C47/DATA3_5 ), .A1(n552), .B0(n562), .B1(n893), .Y(n317)
         );
  NAND2BX1 U686 ( .AN(n738), .B(n556), .Y(n553) );
  AO22X1 U687 ( .A0(\C47/DATA5_3 ), .A1(n553), .B0(n562), .B1(n895), .Y(n315)
         );
  NAND2XL U688 ( .A(n556), .B(n554), .Y(n555) );
  AO22X1 U689 ( .A0(\C47/DATA6_2 ), .A1(n555), .B0(n562), .B1(n896), .Y(n314)
         );
  INVXL U690 ( .A(n556), .Y(n557) );
  AO22X1 U691 ( .A0(\C47/DATA4_4 ), .A1(n557), .B0(n562), .B1(n894), .Y(n316)
         );
  AO22X1 U692 ( .A0(\C47/DATA2_6 ), .A1(n558), .B0(n562), .B1(n892), .Y(n318)
         );
  AO22X1 U693 ( .A0(n782), .A1(N529), .B0(n562), .B1(n891), .Y(n319) );
  AO22X1 U694 ( .A0(n630), .A1(gray_0[13]), .B0(n428), .B1(n877), .Y(n311) );
  AO22X1 U695 ( .A0(n630), .A1(gray_0[2]), .B0(n428), .B1(n888), .Y(n300) );
  CLKBUFX3 U696 ( .A(n559), .Y(n865) );
  CLKBUFX3 U697 ( .A(n559), .Y(n866) );
  CLKBUFX3 U698 ( .A(n559), .Y(n864) );
  NOR2XL U699 ( .A(counter[0]), .B(n562), .Y(N53) );
  OAI21XL U700 ( .A0(n792), .A1(n560), .B0(N690), .Y(n561) );
  OAI22XL U701 ( .A0(n708), .A1(n833), .B0(n563), .B1(n726), .Y(n369) );
  OAI22XL U702 ( .A0(n708), .A1(n853), .B0(n563), .B1(n723), .Y(n374) );
  OAI22XL U703 ( .A0(n708), .A1(n529), .B0(n563), .B1(n725), .Y(n371) );
  OAI22XL U704 ( .A0(n708), .A1(n844), .B0(n563), .B1(n724), .Y(n373) );
  NOR2X1 U705 ( .A(n832), .B(n624), .Y(n623) );
  NOR2X1 U706 ( .A(n840), .B(n616), .Y(n615) );
  NOR2X1 U707 ( .A(n823), .B(n608), .Y(n607) );
  NOR2X1 U708 ( .A(n825), .B(n577), .Y(n571) );
  OAI21XL U709 ( .A0(gray_0[10]), .A1(n571), .B0(n581), .Y(n677) );
  NOR2BX1 U710 ( .AN(n841), .B(gray_0[0]), .Y(n666) );
  NAND2BX1 U711 ( .AN(n666), .B(gray_0[2]), .Y(n625) );
  NOR2X1 U712 ( .A(n832), .B(n625), .Y(n575) );
  NOR2X1 U713 ( .A(n842), .B(n566), .Y(n618) );
  NOR2X1 U714 ( .A(n823), .B(n567), .Y(n610) );
  NOR2XL U715 ( .A(n843), .B(n825), .Y(n568) );
  NAND2X1 U716 ( .A(n610), .B(n568), .Y(n582) );
  NOR2X1 U717 ( .A(n630), .B(n565), .Y(n604) );
  OAI21XL U718 ( .A0(n564), .A1(n677), .B0(n570), .Y(n423) );
  AO21X1 U719 ( .A0(n825), .A1(n577), .B0(n571), .Y(n684) );
  OA21XL U720 ( .A0(n573), .A1(n825), .B0(n572), .Y(n574) );
  OAI21XL U721 ( .A0(n564), .A1(n684), .B0(n574), .Y(n422) );
  OAI21XL U722 ( .A0(gray_0[4]), .A1(n623), .B0(n616), .Y(n636) );
  CLKINVX1 U723 ( .A(n604), .Y(n668) );
  MXI2X1 U724 ( .A(n619), .B(n627), .S0(gray_0[4]), .Y(n576) );
  OAI21XL U725 ( .A0(n564), .A1(n636), .B0(n576), .Y(n417) );
  OAI21XL U726 ( .A0(gray_0[8]), .A1(n607), .B0(n577), .Y(n633) );
  MXI2X1 U727 ( .A(n578), .B(n609), .S0(gray_0[8]), .Y(n579) );
  OAI21XL U728 ( .A0(n564), .A1(n633), .B0(n579), .Y(n421) );
  OAI21XL U729 ( .A0(gray_0[6]), .A1(n615), .B0(n608), .Y(n643) );
  MXI2X1 U730 ( .A(n611), .B(n617), .S0(gray_0[6]), .Y(n580) );
  OAI21XL U731 ( .A0(n564), .A1(n643), .B0(n580), .Y(n419) );
  NOR2X1 U732 ( .A(n845), .B(n581), .Y(n591) );
  AO21X1 U733 ( .A0(n845), .A1(n581), .B0(n591), .Y(n688) );
  NOR3X1 U734 ( .A(n582), .B(n845), .C(n827), .Y(n587) );
  AOI2BB1X1 U735 ( .A0N(n586), .A1N(n845), .B0(n584), .Y(n585) );
  OAI21XL U736 ( .A0(n564), .A1(n688), .B0(n585), .Y(n424) );
  XOR2X1 U737 ( .A(gray_0[13]), .B(n590), .Y(n671) );
  NOR3XL U738 ( .A(n860), .B(gray_0[13]), .C(n592), .Y(n588) );
  OAI21XL U739 ( .A0(n564), .A1(n671), .B0(n589), .Y(n426) );
  OAI21XL U740 ( .A0(gray_0[12]), .A1(n591), .B0(n590), .Y(n674) );
  OAI21XL U741 ( .A0(gray_0[12]), .A1(n594), .B0(n593), .Y(n595) );
  OAI21XL U742 ( .A0(n564), .A1(n674), .B0(n595), .Y(n425) );
  OAI211XL U743 ( .A0(edge_counter[6]), .A1(n597), .B0(n599), .C0(n596), .Y(
        n598) );
  INVXL U744 ( .A(n598), .Y(N76) );
  NOR2X1 U745 ( .A(n852), .B(n599), .Y(n699) );
  NOR2X1 U746 ( .A(n862), .B(n698), .Y(n602) );
  NOR2XL U747 ( .A(n828), .B(n841), .Y(n665) );
  OAI21XL U748 ( .A0(gray_0[2]), .A1(n665), .B0(n624), .Y(n640) );
  NAND2XL U749 ( .A(n828), .B(n841), .Y(n603) );
  NAND2XL U750 ( .A(n604), .B(gray_0[2]), .Y(n605) );
  AO21X1 U751 ( .A0(n823), .A1(n608), .B0(n607), .Y(n649) );
  INVXL U752 ( .A(n610), .Y(n612) );
  AO21X1 U753 ( .A0(n840), .A1(n616), .B0(n615), .Y(n646) );
  INVXL U754 ( .A(n618), .Y(n620) );
  AO21X1 U755 ( .A0(n832), .A1(n624), .B0(n623), .Y(n655) );
  INVXL U756 ( .A(n625), .Y(n626) );
  AOI2BB2X1 U757 ( .B0(\C48/DATA3_8 ), .B1(n687), .A0N(n691), .A1N(n843), .Y(
        n631) );
  AOI2BB2X1 U758 ( .B0(n687), .B1(\C48/DATA3_4 ), .A0N(n691), .A1N(n842), .Y(
        n634) );
  AOI2BB2X1 U759 ( .B0(n687), .B1(\C48/DATA3_6 ), .A0N(n691), .A1N(n861), .Y(
        n641) );
  AOI2BB2X1 U760 ( .B0(n687), .B1(\C48/DATA3_5 ), .A0N(n691), .A1N(n840), .Y(
        n644) );
  AOI2BB2X1 U761 ( .B0(n687), .B1(\C48/DATA3_7 ), .A0N(n691), .A1N(n823), .Y(
        n647) );
  NAND4XL U762 ( .A(n651), .B(n703), .C(n650), .D(n658), .Y(n652) );
  XOR2X1 U763 ( .A(\C1/Z_0 ), .B(n652), .Y(\DP_OP_193J1_123_1153/n19 ) );
  AOI2BB2X1 U764 ( .B0(n687), .B1(\C48/DATA3_3 ), .A0N(n691), .A1N(n832), .Y(
        n653) );
  NAND2X1 U765 ( .A(n657), .B(n656), .Y(n662) );
  NAND3X1 U766 ( .A(n660), .B(n659), .C(n658), .Y(n661) );
  XOR2X1 U767 ( .A(\C1/Z_0 ), .B(n661), .Y(\DP_OP_193J1_123_1153/n26 ) );
  CLKXOR2X2 U768 ( .A(\C1/Z_0 ), .B(n662), .Y(\DP_OP_193J1_123_1153/n21 ) );
  OAI21XL U769 ( .A0(n663), .A1(n565), .B0(n828), .Y(n664) );
  OAI21XL U770 ( .A0(n668), .A1(n828), .B0(n664), .Y(n427) );
  NOR2X1 U771 ( .A(n666), .B(n665), .Y(n681) );
  OAI2BB2XL U772 ( .B0(n681), .B1(n565), .A0N(n681), .A1N(n564), .Y(n667) );
  OAI21XL U773 ( .A0(n668), .A1(n841), .B0(n667), .Y(n414) );
  XOR2X1 U774 ( .A(\DP_OP_193J1_123_1153/n2 ), .B(n669), .Y(n670) );
  NAND2X1 U775 ( .A(n670), .B(n687), .Y(n673) );
  OAI211X1 U776 ( .A0(n691), .A1(n863), .B0(n673), .C0(n672), .Y(n413) );
  AOI2BB2X1 U777 ( .B0(n534), .B1(n868), .A0N(n533), .A1N(n674), .Y(n675) );
  OAI211XL U778 ( .A0(n691), .A1(n860), .B0(n676), .C0(n675), .Y(n412) );
  OAI211XL U779 ( .A0(n691), .A1(n827), .B0(n679), .C0(n678), .Y(n410) );
  OAI211XL U780 ( .A0(n691), .A1(n841), .B0(n683), .C0(n682), .Y(n401) );
  AOI2BB2X1 U781 ( .B0(n534), .B1(gray_addr[9]), .A0N(n533), .A1N(n684), .Y(
        n685) );
  OAI211XL U782 ( .A0(n691), .A1(n825), .B0(n686), .C0(n685), .Y(n409) );
  AOI2BB2X1 U783 ( .B0(n534), .B1(n869), .A0N(n533), .A1N(n688), .Y(n689) );
  OAI211XL U784 ( .A0(n691), .A1(n845), .B0(n690), .C0(n689), .Y(n411) );
  OA21XL U785 ( .A0(edge_counter[0]), .A1(edge_counter[1]), .B0(n695), .Y(N71)
         );
  OA21XL U786 ( .A0(edge_counter[4]), .A1(n697), .B0(n696), .Y(N74) );
  OA21XL U787 ( .A0(edge_counter[8]), .A1(n699), .B0(n698), .Y(N78) );
  OAI31XL U788 ( .A0(counter[1]), .A1(counter[3]), .A2(n820), .B0(n700), .Y(
        N54) );
  AO22X1 U789 ( .A0(n702), .A1(gray_data[7]), .B0(n449), .B1(gray_data3[7]), 
        .Y(n399) );
  OAI22XL U790 ( .A0(n702), .A1(n859), .B0(n449), .B1(n723), .Y(n398) );
  OAI22XL U791 ( .A0(n702), .A1(n851), .B0(n449), .B1(n724), .Y(n397) );
  AO22X1 U792 ( .A0(n702), .A1(gray_data[4]), .B0(n449), .B1(gray_data3[4]), 
        .Y(n396) );
  OAI22XL U793 ( .A0(n702), .A1(n530), .B0(n449), .B1(n725), .Y(n395) );
  AO22X1 U794 ( .A0(n702), .A1(gray_data[2]), .B0(n449), .B1(gray_data3[2]), 
        .Y(n394) );
  OAI22XL U795 ( .A0(n702), .A1(n837), .B0(n449), .B1(n726), .Y(n393) );
  AO22X1 U796 ( .A0(n702), .A1(gray_data[0]), .B0(n449), .B1(gray_data3[0]), 
        .Y(n392) );
  NOR2X2 U797 ( .A(n703), .B(n711), .Y(n705) );
  AO22X1 U798 ( .A0(n705), .A1(gray_data[7]), .B0(n704), .B1(gray_data6[7]), 
        .Y(n391) );
  OAI22XL U799 ( .A0(n705), .A1(n854), .B0(n704), .B1(n723), .Y(n390) );
  OAI22XL U800 ( .A0(n705), .A1(n847), .B0(n704), .B1(n724), .Y(n389) );
  AO22X1 U801 ( .A0(n705), .A1(gray_data[4]), .B0(n704), .B1(gray_data6[4]), 
        .Y(n388) );
  OAI22XL U802 ( .A0(n705), .A1(n523), .B0(n704), .B1(n725), .Y(n387) );
  AO22X1 U803 ( .A0(n705), .A1(gray_data[2]), .B0(n704), .B1(gray_data6[2]), 
        .Y(n386) );
  OAI22XL U804 ( .A0(n705), .A1(n835), .B0(n704), .B1(n726), .Y(n385) );
  AO22X1 U805 ( .A0(n705), .A1(gray_data[0]), .B0(n704), .B1(gray_data6[0]), 
        .Y(n384) );
  AO22X1 U806 ( .A0(n707), .A1(gray_data[7]), .B0(n450), .B1(gray_data5[7]), 
        .Y(n383) );
  OAI22XL U807 ( .A0(n707), .A1(n855), .B0(n450), .B1(n723), .Y(n382) );
  OAI22XL U808 ( .A0(n707), .A1(n848), .B0(n450), .B1(n724), .Y(n381) );
  AO22X1 U809 ( .A0(n707), .A1(gray_data[4]), .B0(n450), .B1(gray_data5[4]), 
        .Y(n380) );
  OAI22XL U810 ( .A0(n707), .A1(n526), .B0(n450), .B1(n725), .Y(n379) );
  AO22X1 U811 ( .A0(n707), .A1(gray_data[2]), .B0(n450), .B1(gray_data5[2]), 
        .Y(n378) );
  OAI22XL U812 ( .A0(n707), .A1(n836), .B0(n450), .B1(n726), .Y(n377) );
  AO22X1 U813 ( .A0(n707), .A1(gray_data[0]), .B0(n450), .B1(gray_data5[0]), 
        .Y(n376) );
  AO22X1 U814 ( .A0(n708), .A1(gray_data[7]), .B0(n563), .B1(gray_data4[7]), 
        .Y(n375) );
  AO22X1 U815 ( .A0(n708), .A1(gray_data[4]), .B0(n563), .B1(gray_data4[4]), 
        .Y(n372) );
  AO22X1 U816 ( .A0(n708), .A1(gray_data[2]), .B0(n563), .B1(gray_data4[2]), 
        .Y(n370) );
  AO22X1 U817 ( .A0(n708), .A1(gray_data[0]), .B0(n563), .B1(gray_data4[0]), 
        .Y(n368) );
  NOR2X2 U818 ( .A(reset), .B(n428), .Y(n710) );
  AO22X1 U819 ( .A0(n710), .A1(gray_data[7]), .B0(n709), .B1(gray_data8[7]), 
        .Y(n367) );
  INVXL U820 ( .A(gray_data8[6]), .Y(n779) );
  OAI22XL U821 ( .A0(n710), .A1(n779), .B0(n709), .B1(n723), .Y(n366) );
  OAI22XL U822 ( .A0(n710), .A1(n776), .B0(n709), .B1(n724), .Y(n365) );
  AO22X1 U823 ( .A0(n710), .A1(gray_data[4]), .B0(n709), .B1(gray_data8[4]), 
        .Y(n364) );
  OAI22XL U824 ( .A0(n710), .A1(n772), .B0(n709), .B1(n725), .Y(n363) );
  AO22X1 U825 ( .A0(n710), .A1(gray_data[2]), .B0(n709), .B1(gray_data8[2]), 
        .Y(n362) );
  OAI22XL U826 ( .A0(n710), .A1(n770), .B0(n709), .B1(n726), .Y(n361) );
  AO22X1 U827 ( .A0(n710), .A1(gray_data[0]), .B0(n709), .B1(gray_data8[0]), 
        .Y(n360) );
  NOR2X2 U828 ( .A(n712), .B(n711), .Y(n714) );
  AO22X1 U829 ( .A0(n714), .A1(gray_data[7]), .B0(n713), .B1(gray_data7[7]), 
        .Y(n359) );
  OAI22XL U830 ( .A0(n714), .A1(n856), .B0(n713), .B1(n723), .Y(n358) );
  OAI22XL U831 ( .A0(n714), .A1(n846), .B0(n713), .B1(n724), .Y(n357) );
  AO22X1 U832 ( .A0(n714), .A1(gray_data[4]), .B0(n713), .B1(gray_data7[4]), 
        .Y(n356) );
  OAI22XL U833 ( .A0(n714), .A1(n528), .B0(n713), .B1(n725), .Y(n355) );
  AO22X1 U834 ( .A0(n714), .A1(gray_data[2]), .B0(n713), .B1(gray_data7[2]), 
        .Y(n354) );
  OAI22XL U835 ( .A0(n714), .A1(n834), .B0(n713), .B1(n726), .Y(n353) );
  AO22X1 U836 ( .A0(n714), .A1(gray_data[0]), .B0(n713), .B1(gray_data7[0]), 
        .Y(n352) );
  INVX3 U837 ( .A(gray_data0[7]), .Y(n816) );
  OAI22XL U838 ( .A0(n720), .A1(n816), .B0(n719), .B1(n716), .Y(n351) );
  OAI22XL U839 ( .A0(n720), .A1(n527), .B0(n719), .B1(n723), .Y(n350) );
  CLKBUFX3 U840 ( .A(gray_data0[5]), .Y(n812) );
  AO22X1 U841 ( .A0(n720), .A1(gray_data[5]), .B0(n719), .B1(n812), .Y(n349)
         );
  INVX3 U842 ( .A(gray_data0[4]), .Y(n810) );
  OAI22XL U843 ( .A0(n720), .A1(n810), .B0(n719), .B1(n717), .Y(n348) );
  CLKBUFX3 U844 ( .A(gray_data0[3]), .Y(n808) );
  AO22X1 U845 ( .A0(n720), .A1(gray_data[3]), .B0(n719), .B1(n808), .Y(n347)
         );
  AO22X1 U846 ( .A0(n719), .A1(gray_data0[2]), .B0(n720), .B1(gray_data[2]), 
        .Y(n346) );
  OAI22XL U847 ( .A0(n720), .A1(n440), .B0(n719), .B1(n726), .Y(n345) );
  OAI22XL U848 ( .A0(n720), .A1(n803), .B0(n719), .B1(n718), .Y(n344) );
  AO22X1 U849 ( .A0(n722), .A1(gray_data[7]), .B0(n721), .B1(gray_data1[7]), 
        .Y(n343) );
  OAI22XL U850 ( .A0(n722), .A1(n857), .B0(n721), .B1(n723), .Y(n342) );
  OAI22XL U851 ( .A0(n722), .A1(n849), .B0(n721), .B1(n724), .Y(n341) );
  AO22X1 U852 ( .A0(n722), .A1(gray_data[4]), .B0(n721), .B1(gray_data1[4]), 
        .Y(n340) );
  OAI22XL U853 ( .A0(n722), .A1(n525), .B0(n721), .B1(n725), .Y(n339) );
  OA22X1 U854 ( .A0(n721), .A1(gray_data[2]), .B0(n722), .B1(gray_data1[2]), 
        .Y(n338) );
  OAI22XL U855 ( .A0(n722), .A1(n838), .B0(n721), .B1(n726), .Y(n337) );
  AO22X1 U856 ( .A0(n722), .A1(gray_data[0]), .B0(n721), .B1(gray_data1[0]), 
        .Y(n336) );
  AO22X1 U857 ( .A0(n728), .A1(gray_data[7]), .B0(n727), .B1(gray_data2[7]), 
        .Y(n335) );
  OAI22XL U858 ( .A0(n728), .A1(n858), .B0(n727), .B1(n723), .Y(n334) );
  OAI22XL U859 ( .A0(n728), .A1(n850), .B0(n727), .B1(n724), .Y(n333) );
  AO22X1 U860 ( .A0(n728), .A1(gray_data[4]), .B0(n727), .B1(gray_data2[4]), 
        .Y(n332) );
  OAI22XL U861 ( .A0(n728), .A1(n524), .B0(n727), .B1(n725), .Y(n331) );
  OA22X1 U862 ( .A0(n727), .A1(gray_data[2]), .B0(n728), .B1(gray_data2[2]), 
        .Y(n330) );
  OAI22XL U863 ( .A0(n728), .A1(n839), .B0(n727), .B1(n726), .Y(n329) );
  AO22X1 U864 ( .A0(n728), .A1(gray_data[0]), .B0(n727), .B1(gray_data2[0]), 
        .Y(n328) );
  OAI22XL U865 ( .A0(gray_data4[1]), .A1(n440), .B0(n803), .B1(gray_data4[0]), 
        .Y(n729) );
  OAI21XL U866 ( .A0(gray_data0[1]), .A1(n833), .B0(n729), .Y(n730) );
  INVX3 U867 ( .A(gray_data0[2]), .Y(n805) );
  AOI222XL U868 ( .A0(gray_data4[2]), .A1(n730), .B0(gray_data4[2]), .B1(n805), 
        .C0(n730), .C1(n805), .Y(n731) );
  AOI222XL U869 ( .A0(n808), .A1(n731), .B0(n808), .B1(n529), .C0(n731), .C1(
        n529), .Y(n732) );
  AOI222XL U870 ( .A0(gray_data4[4]), .A1(n810), .B0(gray_data4[4]), .B1(n732), 
        .C0(n810), .C1(n732), .Y(n733) );
  AOI222XL U871 ( .A0(n812), .A1(n844), .B0(n812), .B1(n733), .C0(n844), .C1(
        n733), .Y(n734) );
  OAI21XL U872 ( .A0(gray_data4[6]), .A1(n527), .B0(n734), .Y(n735) );
  OAI21XL U873 ( .A0(gray_data0[6]), .A1(n853), .B0(n735), .Y(n736) );
  AOI222XL U874 ( .A0(gray_data4[7]), .A1(n816), .B0(gray_data4[7]), .B1(n736), 
        .C0(n816), .C1(n736), .Y(n737) );
  AOI2BB2X1 U875 ( .B0(n738), .B1(n737), .A0N(n738), .A1N(\C47/DATA5_3 ), .Y(
        n327) );
  OAI22XL U876 ( .A0(gray_data6[1]), .A1(n440), .B0(n803), .B1(gray_data6[0]), 
        .Y(n739) );
  OAI21XL U877 ( .A0(gray_data0[1]), .A1(n835), .B0(n739), .Y(n740) );
  AOI222XL U878 ( .A0(gray_data6[2]), .A1(n740), .B0(gray_data6[2]), .B1(n805), 
        .C0(n740), .C1(n805), .Y(n741) );
  AOI222XL U879 ( .A0(n808), .A1(n741), .B0(n808), .B1(n523), .C0(n741), .C1(
        n523), .Y(n742) );
  AOI222XL U880 ( .A0(gray_data6[4]), .A1(n810), .B0(gray_data6[4]), .B1(n742), 
        .C0(n810), .C1(n742), .Y(n743) );
  AOI222XL U881 ( .A0(n812), .A1(n847), .B0(n812), .B1(n743), .C0(n847), .C1(
        n743), .Y(n744) );
  OAI21XL U882 ( .A0(gray_data6[6]), .A1(n527), .B0(n744), .Y(n745) );
  OAI21XL U883 ( .A0(gray_data0[6]), .A1(n854), .B0(n745), .Y(n746) );
  AOI222XL U884 ( .A0(gray_data6[7]), .A1(n816), .B0(gray_data6[7]), .B1(n746), 
        .C0(n816), .C1(n746), .Y(n747) );
  AOI2BB2X1 U885 ( .B0(n748), .B1(n747), .A0N(n748), .A1N(\C47/DATA3_5 ), .Y(
        n326) );
  OAI22XL U886 ( .A0(gray_data5[1]), .A1(n440), .B0(n803), .B1(gray_data5[0]), 
        .Y(n749) );
  OAI21XL U887 ( .A0(gray_data0[1]), .A1(n836), .B0(n749), .Y(n750) );
  AOI222XL U888 ( .A0(gray_data5[2]), .A1(n750), .B0(gray_data5[2]), .B1(n805), 
        .C0(n750), .C1(n805), .Y(n751) );
  AOI222XL U889 ( .A0(n808), .A1(n751), .B0(n808), .B1(n526), .C0(n751), .C1(
        n526), .Y(n752) );
  AOI222XL U890 ( .A0(gray_data5[4]), .A1(n810), .B0(gray_data5[4]), .B1(n752), 
        .C0(n810), .C1(n752), .Y(n753) );
  AOI222XL U891 ( .A0(n812), .A1(n848), .B0(n812), .B1(n753), .C0(n848), .C1(
        n753), .Y(n754) );
  OAI21XL U892 ( .A0(gray_data5[6]), .A1(n527), .B0(n754), .Y(n755) );
  OAI21XL U893 ( .A0(gray_data0[6]), .A1(n855), .B0(n755), .Y(n756) );
  AOI222XL U894 ( .A0(gray_data5[7]), .A1(n816), .B0(gray_data5[7]), .B1(n756), 
        .C0(n816), .C1(n756), .Y(n757) );
  AOI2BB2X1 U895 ( .B0(n758), .B1(n757), .A0N(n758), .A1N(\C47/DATA4_4 ), .Y(
        n325) );
  OAI22XL U896 ( .A0(gray_data7[1]), .A1(n440), .B0(n803), .B1(gray_data7[0]), 
        .Y(n759) );
  OAI21XL U897 ( .A0(gray_data0[1]), .A1(n834), .B0(n759), .Y(n760) );
  AOI222XL U898 ( .A0(gray_data7[2]), .A1(n760), .B0(gray_data7[2]), .B1(n805), 
        .C0(n760), .C1(n805), .Y(n761) );
  AOI222XL U899 ( .A0(n808), .A1(n761), .B0(n808), .B1(n528), .C0(n761), .C1(
        n528), .Y(n762) );
  AOI222XL U900 ( .A0(gray_data7[4]), .A1(n810), .B0(gray_data7[4]), .B1(n762), 
        .C0(n810), .C1(n762), .Y(n763) );
  AOI222XL U901 ( .A0(n812), .A1(n846), .B0(n812), .B1(n763), .C0(n846), .C1(
        n763), .Y(n764) );
  OAI21XL U902 ( .A0(gray_data7[6]), .A1(n527), .B0(n764), .Y(n765) );
  OAI21XL U903 ( .A0(gray_data0[6]), .A1(n856), .B0(n765), .Y(n766) );
  AOI222XL U904 ( .A0(gray_data7[7]), .A1(n816), .B0(gray_data7[7]), .B1(n766), 
        .C0(n816), .C1(n766), .Y(n767) );
  AOI2BB2X1 U905 ( .B0(n768), .B1(n767), .A0N(n768), .A1N(\C47/DATA2_6 ), .Y(
        n324) );
  OAI22XL U906 ( .A0(gray_data8[1]), .A1(n440), .B0(n803), .B1(gray_data8[0]), 
        .Y(n769) );
  OAI21XL U907 ( .A0(gray_data0[1]), .A1(n770), .B0(n769), .Y(n771) );
  AOI222XL U908 ( .A0(gray_data8[2]), .A1(n771), .B0(gray_data8[2]), .B1(n805), 
        .C0(n771), .C1(n805), .Y(n773) );
  AOI222XL U909 ( .A0(n808), .A1(n773), .B0(n808), .B1(n772), .C0(n773), .C1(
        n772), .Y(n774) );
  AOI222XL U910 ( .A0(gray_data8[4]), .A1(n810), .B0(gray_data8[4]), .B1(n774), 
        .C0(n810), .C1(n774), .Y(n775) );
  AOI222XL U911 ( .A0(n812), .A1(n776), .B0(n812), .B1(n775), .C0(n776), .C1(
        n775), .Y(n777) );
  OAI21XL U912 ( .A0(gray_data8[6]), .A1(n527), .B0(n777), .Y(n778) );
  OAI21XL U913 ( .A0(gray_data0[6]), .A1(n779), .B0(n778), .Y(n780) );
  AOI222XL U914 ( .A0(gray_data8[7]), .A1(n816), .B0(gray_data8[7]), .B1(n780), 
        .C0(n816), .C1(n780), .Y(n781) );
  AOI2BB2X1 U915 ( .B0(n782), .B1(n781), .A0N(n782), .A1N(N529), .Y(n323) );
  OAI22XL U916 ( .A0(gray_data1[1]), .A1(n440), .B0(n803), .B1(gray_data1[0]), 
        .Y(n783) );
  OAI21XL U917 ( .A0(gray_data0[1]), .A1(n838), .B0(n783), .Y(n784) );
  AOI222XL U918 ( .A0(n784), .A1(gray_data1[2]), .B0(n784), .B1(n805), .C0(
        gray_data1[2]), .C1(n805), .Y(n785) );
  AOI222XL U919 ( .A0(n808), .A1(n785), .B0(n808), .B1(n525), .C0(n785), .C1(
        n525), .Y(n786) );
  AOI222XL U920 ( .A0(gray_data1[4]), .A1(n810), .B0(gray_data1[4]), .B1(n786), 
        .C0(n810), .C1(n786), .Y(n787) );
  AOI222XL U921 ( .A0(n812), .A1(n849), .B0(n812), .B1(n787), .C0(n849), .C1(
        n787), .Y(n788) );
  OAI21XL U922 ( .A0(gray_data1[6]), .A1(n527), .B0(n788), .Y(n789) );
  OAI21XL U923 ( .A0(gray_data0[6]), .A1(n857), .B0(n789), .Y(n790) );
  AOI222XL U924 ( .A0(gray_data1[7]), .A1(n816), .B0(gray_data1[7]), .B1(n790), 
        .C0(n816), .C1(n790), .Y(n791) );
  AOI2BB2X1 U925 ( .B0(n792), .B1(n791), .A0N(n792), .A1N(N690), .Y(n322) );
  OAI22XL U926 ( .A0(gray_data2[1]), .A1(n440), .B0(n803), .B1(gray_data2[0]), 
        .Y(n793) );
  OAI21XL U927 ( .A0(gray_data0[1]), .A1(n839), .B0(n793), .Y(n794) );
  AOI222XL U928 ( .A0(n794), .A1(gray_data2[2]), .B0(n794), .B1(n805), .C0(
        gray_data2[2]), .C1(n805), .Y(n795) );
  AOI222XL U929 ( .A0(n808), .A1(n795), .B0(n808), .B1(n524), .C0(n795), .C1(
        n524), .Y(n796) );
  AOI222XL U930 ( .A0(gray_data2[4]), .A1(n810), .B0(gray_data2[4]), .B1(n796), 
        .C0(n810), .C1(n796), .Y(n797) );
  AOI222XL U931 ( .A0(n812), .A1(n850), .B0(n812), .B1(n797), .C0(n850), .C1(
        n797), .Y(n798) );
  OAI21XL U932 ( .A0(gray_data2[6]), .A1(n527), .B0(n798), .Y(n799) );
  OAI21XL U933 ( .A0(gray_data0[6]), .A1(n858), .B0(n799), .Y(n800) );
  AOI222XL U934 ( .A0(gray_data2[7]), .A1(n816), .B0(gray_data2[7]), .B1(n800), 
        .C0(n816), .C1(n800), .Y(n801) );
  AOI2BB2X1 U935 ( .B0(n802), .B1(n801), .A0N(n802), .A1N(N691), .Y(n321) );
  OAI22XL U936 ( .A0(gray_data3[1]), .A1(n440), .B0(n803), .B1(gray_data3[0]), 
        .Y(n804) );
  OAI21XL U937 ( .A0(gray_data0[1]), .A1(n837), .B0(n804), .Y(n806) );
  AOI222XL U938 ( .A0(gray_data3[2]), .A1(n806), .B0(gray_data3[2]), .B1(n805), 
        .C0(n806), .C1(n805), .Y(n807) );
  AOI222XL U939 ( .A0(n808), .A1(n807), .B0(n808), .B1(n530), .C0(n807), .C1(
        n530), .Y(n809) );
  AOI222XL U940 ( .A0(gray_data3[4]), .A1(n810), .B0(gray_data3[4]), .B1(n809), 
        .C0(n810), .C1(n809), .Y(n811) );
  AOI222XL U941 ( .A0(n812), .A1(n851), .B0(n812), .B1(n811), .C0(n851), .C1(
        n811), .Y(n813) );
  OAI21XL U942 ( .A0(gray_data3[6]), .A1(n527), .B0(n813), .Y(n814) );
  OAI21XL U943 ( .A0(gray_data0[6]), .A1(n859), .B0(n814), .Y(n815) );
  AOI222XL U944 ( .A0(gray_data3[7]), .A1(n816), .B0(gray_data3[7]), .B1(n815), 
        .C0(n816), .C1(n815), .Y(n817) );
  AOI2BB2X1 U945 ( .B0(n818), .B1(n817), .A0N(n818), .A1N(\C47/DATA6_2 ), .Y(
        n320) );
endmodule

