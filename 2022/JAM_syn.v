/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : T-2022.03
// Date      : Thu Nov 23 00:25:39 2023
/////////////////////////////////////////////////////////////


module JAM_DW01_add_0 ( A, B, CI, SUM, CO );
  input [9:0] A;
  input [9:0] B;
  output [9:0] SUM;
  input CI;
  output CO;
  wire   n1, n2, n3;
  wire   [9:1] carry;

  ADDFXL U1_5 ( .A(A[5]), .B(B[5]), .CI(carry[5]), .CO(carry[6]), .S(SUM[5])
         );
  ADDFXL U1_4 ( .A(A[4]), .B(B[4]), .CI(carry[4]), .CO(carry[5]), .S(SUM[4])
         );
  ADDFXL U1_3 ( .A(A[3]), .B(B[3]), .CI(carry[3]), .CO(carry[4]), .S(SUM[3])
         );
  ADDFXL U1_2 ( .A(A[2]), .B(B[2]), .CI(carry[2]), .CO(carry[3]), .S(SUM[2])
         );
  ADDFXL U1_1 ( .A(A[1]), .B(B[1]), .CI(n1), .CO(carry[2]), .S(SUM[1]) );
  ADDFXL U1_6 ( .A(A[6]), .B(B[6]), .CI(carry[6]), .CO(carry[7]), .S(SUM[6])
         );
  AND2X2 U1 ( .A(B[0]), .B(A[0]), .Y(n1) );
  AND2X2 U2 ( .A(A[8]), .B(n3), .Y(n2) );
  AND2X2 U3 ( .A(A[7]), .B(carry[7]), .Y(n3) );
  XOR2X1 U4 ( .A(A[9]), .B(n2), .Y(SUM[9]) );
  XOR2X1 U5 ( .A(A[8]), .B(n3), .Y(SUM[8]) );
  XOR2X1 U6 ( .A(A[7]), .B(carry[7]), .Y(SUM[7]) );
  XOR2X1 U7 ( .A(B[0]), .B(A[0]), .Y(SUM[0]) );
endmodule


module JAM_DW01_add_1 ( A, B, CI, SUM, CO );
  input [9:0] A;
  input [9:0] B;
  output [9:0] SUM;
  input CI;
  output CO;
  wire   n1, n2, n3;
  wire   [9:1] carry;

  ADDFXL U1_5 ( .A(A[5]), .B(B[5]), .CI(carry[5]), .CO(carry[6]), .S(SUM[5])
         );
  ADDFXL U1_4 ( .A(A[4]), .B(B[4]), .CI(carry[4]), .CO(carry[5]), .S(SUM[4])
         );
  ADDFXL U1_3 ( .A(A[3]), .B(B[3]), .CI(carry[3]), .CO(carry[4]), .S(SUM[3])
         );
  ADDFXL U1_2 ( .A(A[2]), .B(B[2]), .CI(carry[2]), .CO(carry[3]), .S(SUM[2])
         );
  ADDFXL U1_1 ( .A(A[1]), .B(B[1]), .CI(n1), .CO(carry[2]), .S(SUM[1]) );
  ADDFXL U1_6 ( .A(A[6]), .B(B[6]), .CI(carry[6]), .CO(carry[7]), .S(SUM[6])
         );
  AND2X2 U1 ( .A(B[0]), .B(A[0]), .Y(n1) );
  AND2X2 U2 ( .A(A[8]), .B(n3), .Y(n2) );
  AND2XL U3 ( .A(A[7]), .B(carry[7]), .Y(n3) );
  XOR2XL U4 ( .A(B[0]), .B(A[0]), .Y(SUM[0]) );
  XOR2XL U5 ( .A(A[7]), .B(carry[7]), .Y(SUM[7]) );
  XOR2XL U6 ( .A(A[9]), .B(n2), .Y(SUM[9]) );
  XOR2XL U7 ( .A(A[8]), .B(n3), .Y(SUM[8]) );
endmodule


module JAM ( CLK, RST, W, J, Cost, MatchCount, MinCost, Valid );
  output [2:0] W;
  output [2:0] J;
  input [6:0] Cost;
  output [3:0] MatchCount;
  output [9:0] MinCost;
  input CLK, RST;
  output Valid;
  wire   n1224, n1225, n1226, n1227, n1228, n1229, n1230, n1231, n1232, n1233,
         N38, N39, N40, N77, N78, N79, N80, N81, N82, N83, N84, N85, N86, N87,
         N111, N128, N129, N130, N131, N132, N133, N134, N135, N136, N137,
         N138, N139, N140, N141, N142, N143, N144, N145, N146, N147, N148,
         N587, N588, n343, n344, n345, n348, n350, n352, n353, n355, n356,
         n359, n361, n362, n364, n365, n376, n377, n378, n379, n380, n381,
         n383, n385, n386, n387, n390, n391, n392, n395, n398, n399, n400,
         n404, n408, n409, n410, n411, n412, n413, n414, n415, n419, n421,
         n422, n423, n424, n425, n426, n428, n429, n430, n431, n432, n433,
         n435, n437, n438, n439, n440, n441, n442, n443, n444, n445, n446,
         n447, n448, n449, n450, n451, n452, n453, n454, n455, n456, n457,
         n458, n459, n461, n462, n463, n464, n465, n466, n467, n468, n469,
         n470, n471, n472, n473, n474, n475, n476, n478, n479, n480, n481,
         n482, n484, n485, n487, n489, n491, n492, n493, n496, n498, n499,
         n500, n501, n502, n503, n504, n505, n506, n507, n508, n509, n510,
         n511, n512, n513, n515, n516, n517, n518, n519, n520, n522, n523,
         n524, n526, n528, n529, n530, n533, n534, n535, n538, n539, n540,
         n541, n543, n545, n546, n547, n548, n549, n550, n551, n552, n554,
         n555, n556, n558, n561, n562, n563, n564, n566, n567, n568, n569,
         n570, n571, n572, n575, n576, n577, n578, n579, n582, n583, n584,
         n585, n586, n587, n588, n589, n590, n591, n592, n593, n594, n595,
         n596, n597, n598, n599, n600, n601, n602, n604, n605, n606, n607,
         n608, n609, n610, n612, n613, n614, n615, n616, n617, n618, n619,
         n620, n622, n623, n624, n627, n630, n631, n632, n633, n634, n635,
         n636, n637, n638, n639, n640, n641, n642, n643, n644, n645, n647,
         n648, n649, n650, n651, n652, n653, n654, n655, n657, n658, n660,
         n661, n662, n663, n664, n665, n666, n667, n668, n669, n670, n671,
         n672, n673, n674, n675, n676, n677, n678, n679, n681, n682, n685,
         n686, n688, n689, n690, n691, n692, n693, n694, n695, n696, n697,
         n698, n699, n700, n702, n703, n704, n705, n706, n707, n708, n709,
         n710, n711, n712, n713, n714, n716, n717, n719, n720, n721, n722,
         n723, n724, n725, n726, n727, n728, n729, n730, n731, n732, n733,
         n734, n735, n736, n737, n738, n739, n741, n742, n743, n744, n745,
         n746, n747, n748, n749, n750, n751, n752, n753, n754, n756, n757,
         n758, n759, n760, n761, n762, n763, n764, n765, n766, n767, n768,
         n769, n770, n771, n772, n773, n774, n775, n776, n777, n778, n779,
         n780, n781, n783, n784, n785, n786, n787, n788, n789, n790, n791,
         n792, n793, n794, n795, n797, n798, n799, n800, n801, n803, n804,
         n805, n806, n807, n808, n809, n811, n812, n813, n815, n816, n817,
         n818, n820, n821, n822, n823, n824, n825, n826, n827, n828, n829,
         n830, n831, n832, n833, n834, n835, n836, n837, n838, n839, n841,
         n842, n845, n846, n847, n848, n849, n850, n851, n852, n853, n855,
         n856, n857, n858, n859, n860, n861, n862, n863, n864, n865, n866,
         n867, n868, n869, n870, n871, n872, n873, n874, n875, n876, n877,
         n878, n879, n880, n882, n884, n886, n888, n947, n948, n949, n950,
         n951, n952, n953, n954, n955, n956, n957, n958, n959, n960, n961,
         n962, n963, n964, n965, n966, n967, n968, n969, n970, n971, n972,
         n973, n974, n975, n976, n977, n978, n979, n980, n981, n982, n983,
         n984, n985, n986, n987, n988, n989, n990, n991, n992, n993, n994,
         n995, n996, n997, n998, n999, n1000, n1001, n1002, n1003, n1004,
         n1005, n1006, n1007, n1008, n1009, n1010, n1011, n1012, n1013, n1014,
         n1015, n1016, n1017, n1018, n1019, n1020, n1021, n1022, n1023, n1024,
         n1025, n1026, n1027, n1028, n1029, n1030, n1031, n1051, n1053, n1063,
         n1064, n1065, n1066, n1067, n1068, n1069, n1070, n1071, n1072, n1073,
         n1074, n1075, n1076, n1077, n1078, n1079, n1080, n1081, n1082, n1083,
         n1084, n1085, n1086, n1087, n1088, n1089, n1090, n1091, n1092, n1093,
         n1094, n1095, n1096, n1097, n1098, n1099, n1100, n1101, n1102, n1103,
         n1104, n1105, n1106, n1107, n1108, n1109, n1110, n1111, n1112, n1113,
         n1114, n1115, n1116, n1117, n1118, n1119, n1120, n1121, n1122, n1123,
         n1124, n1125, n1126, n1127, n1128, n1129, n1130, n1131, n1132, n1133,
         n1134, n1135, n1136, n1137, n1138, n1139, n1140, n1141, n1142, n1143,
         n1144, n1145, n1146, n1147, n1148, n1149, n1150, n1151, n1152, n1153,
         n1154, n1155, n1156, n1157, n1158, n1159, n1160, n1161, n1162, n1163,
         n1164, n1165, n1166, n1167, n1168, n1169, n1170, n1171, n1172, n1173,
         n1174, n1175, n1176, n1177, n1178, n1179, n1180, n1181, n1182, n1183,
         n1184, n1185, n1186, n1187, n1188, n1189, n1190, n1191, n1192, n1193,
         n1194, n1195, n1196, n1197, n1198, n1199, n1200, n1201, n1202, n1203,
         n1204, n1205, n1206, n1207, n1208, n1209, n1210, n1211, n1212, n1213,
         n1214, n1215, n1216, n1217, n1218, n1219, n1220, n1221;
  wire   [2:0] Next_state;
  wire   [9:0] number;
  wire   [2:0] state;

  OAI31X2 U251 ( .A0(n1184), .A1(n657), .A2(n609), .B0(n1153), .Y(n496) );
  AOI211X2 U256 ( .A0(n663), .A1(n653), .B0(n1204), .C0(n613), .Y(n523) );
  OAI211X2 U408 ( .A0(n1082), .A1(n775), .B0(n776), .C0(n777), .Y(n627) );
  JAM_DW01_add_0 add_114 ( .A(number), .B({1'b0, 1'b0, 1'b0, Cost}), .CI(1'b0), 
        .SUM({N137, N136, N135, N134, N133, N132, N131, N130, N129, N128}) );
  JAM_DW01_add_1 add_74 ( .A({n1225, n1226, n1029, n1227, n1228, n1229, n1230, 
        n1231, n1232, n1233}), .B({1'b0, 1'b0, 1'b0, Cost}), .CI(1'b0), .SUM({
        N86, N85, N84, N83, N82, N81, N80, N79, N78, N77}) );
  TLATX1 \Next_state_reg[1]  ( .G(N588), .D(N587), .Q(Next_state[1]), .QN(n879) );
  DFFNSRX1 \state_reg[1]  ( .D(Next_state[1]), .CKN(CLK), .SN(1'b1), .RN(n1099), .Q(state[1]), .QN(n1030) );
  DFFNSRX1 \number_reg[9]  ( .D(N147), .CKN(CLK), .SN(1'b1), .RN(n1099), .Q(
        number[9]), .QN(n870) );
  DFFNSRX1 \counter_reg[3]  ( .D(N40), .CKN(CLK), .SN(1'b1), .RN(n1156), .Q(
        n1023), .QN(n948) );
  DFFNSRX1 \counter_reg[1]  ( .D(N38), .CKN(CLK), .SN(1'b1), .RN(n1156), .Q(
        n1022), .QN(n950) );
  DFFNSRX1 \number_reg[7]  ( .D(N145), .CKN(CLK), .SN(1'b1), .RN(n1099), .Q(
        number[7]), .QN(n868) );
  DFFNSRX1 \number_reg[8]  ( .D(N146), .CKN(CLK), .SN(1'b1), .RN(n1099), .Q(
        number[8]), .QN(n852) );
  DFFNSRX1 \number_reg[5]  ( .D(N143), .CKN(CLK), .SN(1'b1), .RN(n1099), .Q(
        number[5]), .QN(n864) );
  DFFNSRX1 \number_reg[6]  ( .D(N144), .CKN(CLK), .SN(1'b1), .RN(n1099), .Q(
        number[6]), .QN(n866) );
  DFFNSRX1 \number_reg[1]  ( .D(N139), .CKN(CLK), .SN(1'b1), .RN(n1156), .Q(
        number[1]), .QN(n856) );
  DFFNSRX1 \number_reg[3]  ( .D(N141), .CKN(CLK), .SN(1'b1), .RN(n1099), .Q(
        number[3]), .QN(n860) );
  DFFNSRX1 \number_reg[4]  ( .D(N142), .CKN(CLK), .SN(1'b1), .RN(n1099), .Q(
        number[4]), .QN(n862) );
  DFFNSRX1 \number_reg[2]  ( .D(N140), .CKN(CLK), .SN(1'b1), .RN(n1156), .Q(
        number[2]), .QN(n858) );
  DFFNSRX1 \compare_7_reg[2]  ( .D(n1008), .CKN(CLK), .SN(1'b1), .RN(1'b1), 
        .Q(n1027), .QN(n965) );
  TLATX1 \Next_state_reg[0]  ( .G(N588), .D(n947), .Q(Next_state[0]), .QN(n878) );
  DFFNSRX1 \counter_reg[2]  ( .D(N39), .CKN(CLK), .SN(1'b1), .RN(n1156), .Q(
        n1024), .QN(n949) );
  DFFNSRX1 \state_reg[0]  ( .D(Next_state[0]), .CKN(CLK), .SN(1'b1), .RN(n1099), .Q(state[0]), .QN(n1031) );
  DFFNSRX1 \compare_3_reg[1]  ( .D(n999), .CKN(CLK), .SN(1'b1), .RN(1'b1), 
        .QN(n975) );
  DFFNSRX1 \compare_3_reg[0]  ( .D(n1000), .CKN(CLK), .SN(1'b1), .RN(1'b1), 
        .Q(n1028), .QN(n976) );
  DFFNSRX1 \compare_3_reg[2]  ( .D(n1004), .CKN(CLK), .SN(1'b1), .RN(1'b1), 
        .QN(n974) );
  DFFNSRX1 \compare_1_reg[0]  ( .D(n1012), .CKN(CLK), .SN(1'b1), .RN(1'b1), 
        .QN(n985) );
  DFFNSRX1 \compare_0_reg[2]  ( .D(n989), .CKN(CLK), .SN(1'b1), .RN(n1156), 
        .QN(n980) );
  DFFNSRX1 \compare_0_reg[1]  ( .D(n1010), .CKN(CLK), .SN(1'b1), .RN(n1156), 
        .QN(n981) );
  DFFNSRX1 \compare_0_reg[0]  ( .D(n990), .CKN(CLK), .SN(1'b1), .RN(n1156), 
        .QN(n982) );
  DFFNSRX1 \compare_1_reg[1]  ( .D(n1009), .CKN(CLK), .SN(1'b1), .RN(1'b1), 
        .QN(n984) );
  DFFNSRX1 \compare_5_reg[0]  ( .D(n996), .CKN(CLK), .SN(1'b1), .RN(1'b1), .Q(
        n1021), .QN(n964) );
  DFFNSRX1 \compare_4_reg[0]  ( .D(n998), .CKN(CLK), .SN(1'b1), .RN(1'b1), 
        .QN(n979) );
  DFFNSRX1 \compare_4_reg[2]  ( .D(n1005), .CKN(CLK), .SN(1'b1), .RN(1'b1), 
        .QN(n977) );
  DFFNSRX1 \compare_6_reg[1]  ( .D(n993), .CKN(CLK), .SN(1'b1), .RN(1'b1), 
        .QN(n969) );
  DFFNSRX1 \compare_7_reg[1]  ( .D(n991), .CKN(CLK), .SN(1'b1), .RN(1'b1), .Q(
        n1026), .QN(n966) );
  DFFNSRX1 \compare_5_reg[2]  ( .D(n1006), .CKN(CLK), .SN(1'b1), .RN(1'b1), 
        .QN(n962) );
  DFFNSRX1 \compare_5_reg[1]  ( .D(n995), .CKN(CLK), .SN(1'b1), .RN(1'b1), .Q(
        n1025), .QN(n963) );
  DFFNSRX1 \compare_4_reg[1]  ( .D(n997), .CKN(CLK), .SN(1'b1), .RN(1'b1), .Q(
        n1019), .QN(n978) );
  DFFNSRX1 \compare_6_reg[2]  ( .D(n1007), .CKN(CLK), .SN(1'b1), .RN(1'b1), 
        .Q(n1018), .QN(n968) );
  DFFNSRX1 \compare_6_reg[0]  ( .D(n994), .CKN(CLK), .SN(1'b1), .RN(1'b1), 
        .QN(n970) );
  DFFNSRX1 \compare_7_reg[0]  ( .D(n992), .CKN(CLK), .SN(1'b1), .RN(1'b1), 
        .QN(n967) );
  DFFNSRX1 \compare_2_reg[2]  ( .D(n1003), .CKN(CLK), .SN(1'b1), .RN(1'b1), 
        .QN(n971) );
  DFFNSRX1 \compare_2_reg[1]  ( .D(n1001), .CKN(CLK), .SN(1'b1), .RN(1'b1), 
        .QN(n972) );
  DFFNSRX1 \compare_1_reg[2]  ( .D(n1011), .CKN(CLK), .SN(1'b1), .RN(1'b1), 
        .QN(n983) );
  DFFNSRX1 \compare_2_reg[0]  ( .D(n1002), .CKN(CLK), .SN(1'b1), .RN(1'b1), 
        .Q(n1020), .QN(n973) );
  DFFNSRX1 \MinCost_reg[2]  ( .D(n959), .CKN(CLK), .SN(1'b1), .RN(n1099), .Q(
        n1231), .QN(n859) );
  DFFNSRX1 \W_reg[2]  ( .D(n1013), .CKN(CLK), .SN(1'b1), .RN(n1156), .Q(n1224), 
        .QN(n1053) );
  DFFNSRX1 \MatchCount_reg[1]  ( .D(n886), .CKN(CLK), .SN(1'b1), .RN(n1099), 
        .QN(n877) );
  DFFNSRX1 \MatchCount_reg[2]  ( .D(n884), .CKN(CLK), .SN(1'b1), .RN(n1099), 
        .QN(n876) );
  DFFNSRX1 Valid_reg ( .D(N148), .CKN(CLK), .SN(1'b1), .RN(n1156), .QN(n1051)
         );
  DFFNSRX1 \MinCost_reg[1]  ( .D(n960), .CKN(CLK), .SN(1'b1), .RN(n1099), .Q(
        n1232), .QN(n857) );
  DFFNSRXL \number_reg[0]  ( .D(N138), .CKN(CLK), .SN(1'b1), .RN(n1156), .Q(
        number[0]), .QN(n1137) );
  DFFNSRXL \counter_reg[0]  ( .D(n951), .CKN(CLK), .SN(1'b1), .RN(n1156), .Q(
        n1157), .QN(n951) );
  DFFNSRX1 \J_reg[0]  ( .D(n988), .CKN(CLK), .SN(1'b1), .RN(n1156), .QN(n872)
         );
  DFFNSRX1 \MatchCount_reg[3]  ( .D(n882), .CKN(CLK), .SN(1'b1), .RN(n1156), 
        .QN(n875) );
  DFFNSRX1 \W_reg[1]  ( .D(n1014), .CKN(CLK), .SN(1'b1), .RN(n1156), .QN(n851)
         );
  DFFNSRX1 \W_reg[0]  ( .D(n1015), .CKN(CLK), .SN(1'b1), .RN(n1156), .QN(n850)
         );
  DFFNSRX1 \J_reg[2]  ( .D(n986), .CKN(CLK), .SN(1'b1), .RN(n1156), .QN(n874)
         );
  DFFNSRX1 \J_reg[1]  ( .D(n987), .CKN(CLK), .SN(1'b1), .RN(n1156), .QN(n873)
         );
  DFFNSRX1 \MatchCount_reg[0]  ( .D(n888), .CKN(CLK), .SN(n1156), .RN(1'b1), 
        .QN(n880) );
  DFFNSRX1 \MinCost_reg[7]  ( .D(n954), .CKN(CLK), .SN(1'b1), .RN(n1156), .Q(
        n1029), .QN(n869) );
  DFFNSRX1 \MinCost_reg[8]  ( .D(n953), .CKN(CLK), .SN(1'b1), .RN(n1099), .Q(
        n1226), .QN(n853) );
  DFFNSRX1 \MinCost_reg[0]  ( .D(n961), .CKN(CLK), .SN(1'b1), .RN(n1099), .Q(
        n1233), .QN(n855) );
  DFFNSRX1 \MinCost_reg[9]  ( .D(n952), .CKN(CLK), .SN(1'b1), .RN(n1099), .Q(
        n1225), .QN(n871) );
  DFFNSRX1 \MinCost_reg[6]  ( .D(n955), .CKN(CLK), .SN(1'b1), .RN(n1099), .Q(
        n1227), .QN(n867) );
  DFFNSRX1 \MinCost_reg[3]  ( .D(n958), .CKN(CLK), .SN(1'b1), .RN(n1099), .Q(
        n1230), .QN(n861) );
  DFFNSRX1 \MinCost_reg[4]  ( .D(n957), .CKN(CLK), .SN(1'b1), .RN(n1099), .Q(
        n1229), .QN(n863) );
  DFFNSRX1 \MinCost_reg[5]  ( .D(n956), .CKN(CLK), .SN(1'b1), .RN(n1156), .Q(
        n1228), .QN(n865) );
  INVX3 U637 ( .A(n513), .Y(n1153) );
  NAND2X2 U638 ( .A(n1071), .B(n1154), .Y(n513) );
  NOR2X2 U639 ( .A(n1019), .B(n1083), .Y(n723) );
  NAND2X2 U640 ( .A(n1083), .B(n1019), .Y(n722) );
  XOR2X4 U641 ( .A(n1218), .B(n1083), .Y(n809) );
  AOI211XL U642 ( .A0(n1083), .A1(n1190), .B0(n1206), .C0(n1091), .Y(n805) );
  CLKBUFX8 U643 ( .A(n966), .Y(n1083) );
  OAI211X2 U644 ( .A0(n1077), .A1(n1212), .B0(n797), .C0(n793), .Y(n643) );
  XNOR2X4 U645 ( .A(n1018), .B(n1208), .Y(n793) );
  OAI22X4 U646 ( .A0(n1089), .A1(n1174), .B0(n1173), .B1(n783), .Y(n729) );
  AOI32X4 U647 ( .A0(n784), .A1(n1020), .A2(n1097), .B0(n1093), .B1(n1215), 
        .Y(n783) );
  NOR2X6 U648 ( .A(n1207), .B(n978), .Y(n781) );
  CLKINVX12 U649 ( .A(n1086), .Y(n1207) );
  BUFX4 U650 ( .A(n739), .Y(n1016) );
  CLKBUFX3 U651 ( .A(n968), .Y(n1017) );
  AOI31X2 U652 ( .A0(n1087), .A1(n699), .A2(n1095), .B0(n1201), .Y(n669) );
  BUFX12 U653 ( .A(n978), .Y(n1075) );
  NAND2X2 U654 ( .A(n1016), .B(n425), .Y(n566) );
  NAND2X2 U655 ( .A(n664), .B(n803), .Y(n425) );
  NAND2X2 U656 ( .A(n1068), .B(n1069), .Y(n778) );
  OAI21XL U657 ( .A0(n812), .A1(n813), .B0(n669), .Y(n739) );
  NAND2X1 U658 ( .A(n809), .B(n778), .Y(n775) );
  OAI32X1 U659 ( .A0(n786), .A1(n787), .A2(n788), .B0(n1095), .B1(n1205), .Y(
        n558) );
  NOR3BX1 U660 ( .AN(n607), .B(n1209), .C(n562), .Y(n590) );
  NAND2BX1 U661 ( .AN(n566), .B(n735), .Y(n602) );
  NAND2BX1 U662 ( .AN(n582), .B(n749), .Y(n594) );
  AO22X1 U663 ( .A0(n1211), .A1(n1095), .B0(n779), .B1(n780), .Y(n551) );
  INVX1 U664 ( .A(n606), .Y(n1150) );
  OR2X1 U665 ( .A(n741), .B(n602), .Y(n415) );
  OR2X1 U666 ( .A(n1065), .B(n1066), .Y(n724) );
  NOR2X1 U667 ( .A(RST), .B(n410), .Y(n1065) );
  NOR2X1 U668 ( .A(n632), .B(n753), .Y(n1066) );
  CLKINVX1 U669 ( .A(n724), .Y(n1154) );
  OAI2BB1X2 U670 ( .A0N(n752), .A1N(n754), .B0(n751), .Y(n595) );
  INVX3 U671 ( .A(n496), .Y(n1152) );
  INVX4 U672 ( .A(n426), .Y(n1149) );
  INVX3 U673 ( .A(n1090), .Y(n1203) );
  CLKBUFX3 U674 ( .A(n968), .Y(n1090) );
  CLKBUFX3 U675 ( .A(n963), .Y(n1076) );
  CLKBUFX3 U676 ( .A(n979), .Y(n1074) );
  CLKBUFX3 U677 ( .A(n965), .Y(n1092) );
  CLKBUFX3 U678 ( .A(n964), .Y(n1077) );
  CLKBUFX3 U679 ( .A(n962), .Y(n1085) );
  INVX3 U680 ( .A(RST), .Y(n1156) );
  INVX12 U681 ( .A(n875), .Y(MatchCount[3]) );
  INVX12 U682 ( .A(n872), .Y(J[0]) );
  INVX12 U683 ( .A(n873), .Y(J[1]) );
  INVX12 U684 ( .A(n874), .Y(J[2]) );
  INVX12 U685 ( .A(n850), .Y(W[0]) );
  INVX12 U686 ( .A(n851), .Y(W[1]) );
  INVX12 U687 ( .A(n880), .Y(MatchCount[0]) );
  INVX12 U688 ( .A(n869), .Y(MinCost[7]) );
  OAI21X1 U699 ( .A0(n1133), .A1(n1132), .B0(n1131), .Y(N111) );
  INVX12 U700 ( .A(n857), .Y(MinCost[1]) );
  OAI211XL U701 ( .A0(n1232), .A1(n1138), .B0(n1115), .C0(n1114), .Y(n1118) );
  INVX12 U702 ( .A(n1051), .Y(Valid) );
  INVX16 U703 ( .A(n876), .Y(MatchCount[2]) );
  INVX16 U704 ( .A(n877), .Y(MatchCount[1]) );
  INVX12 U705 ( .A(n1053), .Y(W[2]) );
  INVX12 U706 ( .A(n859), .Y(MinCost[2]) );
  INVX12 U707 ( .A(n865), .Y(MinCost[5]) );
  INVX12 U708 ( .A(n863), .Y(MinCost[4]) );
  INVX12 U709 ( .A(n861), .Y(MinCost[3]) );
  INVX12 U710 ( .A(n867), .Y(MinCost[6]) );
  INVX12 U711 ( .A(n871), .Y(MinCost[9]) );
  INVX12 U712 ( .A(n855), .Y(MinCost[0]) );
  INVX12 U713 ( .A(n853), .Y(MinCost[8]) );
  AOI32XL U714 ( .A0(n1130), .A1(n1135), .A2(n1129), .B0(n1226), .B1(n852), 
        .Y(n1132) );
  NAND2X2 U715 ( .A(n968), .B(n1092), .Y(n1069) );
  NAND2X1 U716 ( .A(n1018), .B(n1027), .Y(n1068) );
  BUFX12 U717 ( .A(n967), .Y(n1091) );
  INVX4 U718 ( .A(n610), .Y(n1151) );
  OAI31X2 U719 ( .A0(n1196), .A1(n612), .A2(n609), .B0(n1152), .Y(n610) );
  OR2X1 U720 ( .A(n1063), .B(n1064), .Y(n712) );
  NOR2XL U721 ( .A(n1084), .B(n1195), .Y(n1063) );
  NOR2X1 U722 ( .A(n721), .B(n1198), .Y(n1064) );
  BUFX2 U723 ( .A(n977), .Y(n1084) );
  NOR2BX1 U724 ( .AN(n712), .B(n717), .Y(n1070) );
  NAND2X1 U725 ( .A(n541), .B(n748), .Y(n582) );
  NAND2X1 U726 ( .A(n1185), .B(n729), .Y(n540) );
  CLKINVX1 U727 ( .A(n643), .Y(n1201) );
  BUFX2 U728 ( .A(n973), .Y(n1080) );
  NAND2X1 U729 ( .A(n590), .B(n627), .Y(n623) );
  NOR2X1 U730 ( .A(n540), .B(n551), .Y(n555) );
  NAND2X1 U731 ( .A(n1079), .B(n1191), .Y(n784) );
  CLKBUFX3 U732 ( .A(n975), .Y(n1086) );
  CLKBUFX3 U733 ( .A(n974), .Y(n1095) );
  CLKBUFX3 U734 ( .A(n983), .Y(n1096) );
  CLKBUFX3 U735 ( .A(n972), .Y(n1079) );
  CLKBUFX3 U736 ( .A(n976), .Y(n1087) );
  CLKBUFX3 U737 ( .A(n971), .Y(n1089) );
  CLKBUFX3 U738 ( .A(n970), .Y(n1082) );
  NOR3X2 U739 ( .A(n1202), .B(n1209), .C(n1172), .Y(n592) );
  CLKINVX1 U740 ( .A(n523), .Y(n1182) );
  NOR2BX4 U741 ( .AN(n712), .B(n717), .Y(n664) );
  CLKINVX1 U742 ( .A(n551), .Y(n1183) );
  NOR2X1 U743 ( .A(n558), .B(n729), .Y(n539) );
  CLKINVX1 U744 ( .A(n558), .Y(n1185) );
  NAND3XL U745 ( .A(n1187), .B(n415), .C(n425), .Y(n649) );
  NAND2X1 U746 ( .A(n543), .B(n545), .Y(n613) );
  OAI22XL U747 ( .A0(n1081), .A1(n1195), .B0(n805), .B1(n806), .Y(n804) );
  OAI21XL U748 ( .A0(n1092), .A1(n1213), .B0(n804), .Y(n803) );
  OAI211X4 U749 ( .A0(n1212), .A1(n775), .B0(n776), .C0(n807), .Y(n717) );
  NAND2X1 U750 ( .A(n674), .B(n798), .Y(n735) );
  NAND2X1 U751 ( .A(n664), .B(n764), .Y(n541) );
  OAI21XL U752 ( .A0(n1092), .A1(n1174), .B0(n765), .Y(n764) );
  OAI221XL U753 ( .A0(n1093), .A1(n1026), .B0(n1096), .B1(n1195), .C0(n766), 
        .Y(n765) );
  OAI22XL U754 ( .A0(n1091), .A1(n1168), .B0(n1083), .B1(n1191), .Y(n766) );
  OR2XL U755 ( .A(N87), .B(N111), .Y(n1072) );
  NAND2X1 U756 ( .A(n1089), .B(n1174), .Y(n785) );
  NOR2X1 U757 ( .A(n1186), .B(n1089), .Y(n787) );
  NOR2X1 U758 ( .A(n1207), .B(n1079), .Y(n788) );
  NAND2XL U759 ( .A(n1233), .B(n1137), .Y(n1113) );
  CLKBUFX3 U760 ( .A(n984), .Y(n1093) );
  CLKBUFX3 U761 ( .A(n982), .Y(n1088) );
  CLKBUFX3 U762 ( .A(n981), .Y(n1094) );
  NOR2BXL U763 ( .AN(number[4]), .B(n1229), .Y(n1104) );
  CLKBUFX3 U764 ( .A(n980), .Y(n1081) );
  NAND2XL U765 ( .A(n1230), .B(n860), .Y(n1112) );
  CLKBUFX3 U766 ( .A(n985), .Y(n1097) );
  NOR2XL U767 ( .A(n860), .B(n1230), .Y(n1117) );
  NOR2BXL U768 ( .AN(n1229), .B(number[4]), .Y(n1122) );
  NOR2XL U769 ( .A(n866), .B(n1227), .Y(n1108) );
  NOR2XL U770 ( .A(n1137), .B(n1233), .Y(n1101) );
  NOR2BXL U771 ( .AN(n1228), .B(number[5]), .Y(n1121) );
  NAND2XL U772 ( .A(n1227), .B(n866), .Y(n1124) );
  NAND2XL U773 ( .A(n1029), .B(n868), .Y(n1125) );
  NAND2BXL U774 ( .AN(n1228), .B(number[5]), .Y(n1120) );
  NOR2XL U775 ( .A(n868), .B(n1029), .Y(n1128) );
  NOR2BXL U776 ( .AN(number[9]), .B(n1225), .Y(n1133) );
  NAND2BXL U777 ( .AN(number[9]), .B(n1225), .Y(n1131) );
  INVX1 U778 ( .A(n607), .Y(n1202) );
  OAI211X4 U779 ( .A0(n774), .A1(n414), .B0(n1160), .C0(n1170), .Y(n410) );
  NAND2XL U780 ( .A(n1167), .B(n1170), .Y(n450) );
  INVXL U781 ( .A(n562), .Y(n1169) );
  NAND3BXL U782 ( .AN(n602), .B(n419), .C(n414), .Y(n585) );
  OA22XL U783 ( .A0(n645), .A1(n632), .B0(n1182), .B1(n619), .Y(n438) );
  NAND3XL U784 ( .A(n414), .B(n415), .C(n1181), .Y(n564) );
  OR2XL U785 ( .A(n414), .B(n623), .Y(n435) );
  NAND2XL U786 ( .A(n579), .B(n592), .Y(n467) );
  NOR3XL U787 ( .A(n613), .B(n1204), .C(n523), .Y(n618) );
  NAND2XL U788 ( .A(n524), .B(n597), .Y(n468) );
  OAI31X2 U789 ( .A0(n607), .A1(n608), .A2(n609), .B0(n1151), .Y(n606) );
  XNOR2XL U790 ( .A(n1213), .B(n1211), .Y(n820) );
  NAND2X1 U791 ( .A(n1160), .B(n1099), .Y(n609) );
  OR4XL U792 ( .A(n579), .B(n1164), .C(n1165), .D(n582), .Y(n577) );
  OA22XL U793 ( .A0(n595), .A1(n632), .B0(n648), .B1(n623), .Y(n437) );
  NOR2BX1 U794 ( .AN(n1067), .B(n737), .Y(n584) );
  NAND3XL U795 ( .A(n576), .B(n551), .C(n607), .Y(n598) );
  NAND3BXL U796 ( .AN(n594), .B(n595), .C(n596), .Y(n591) );
  NOR2X1 U797 ( .A(n749), .B(n582), .Y(n575) );
  NOR3BX1 U798 ( .AN(n653), .B(n1204), .C(n613), .Y(n526) );
  NOR2X1 U799 ( .A(n654), .B(n613), .Y(n524) );
  NOR2XL U800 ( .A(n524), .B(n613), .Y(n651) );
  INVX1 U801 ( .A(n545), .Y(n1192) );
  NOR2X1 U802 ( .A(n1016), .B(n1189), .Y(n538) );
  NAND3XL U803 ( .A(n550), .B(n551), .C(n552), .Y(n503) );
  XNOR2XL U804 ( .A(n1211), .B(n1203), .Y(n708) );
  XOR2XL U805 ( .A(n1195), .B(n1208), .Y(n704) );
  OR2XL U806 ( .A(n540), .B(n541), .Y(n519) );
  NAND2XL U807 ( .A(n1202), .B(n604), .Y(n599) );
  AND2X1 U808 ( .A(n627), .B(n604), .Y(n432) );
  NOR4XL U809 ( .A(n1168), .B(n1208), .C(n1218), .D(n1203), .Y(n849) );
  AOI211XL U810 ( .A0(n1091), .A1(n1028), .B0(n696), .C0(n693), .Y(n833) );
  NAND2XL U811 ( .A(n1081), .B(n1174), .Y(n831) );
  NOR2XL U812 ( .A(n1090), .B(n1213), .Y(n813) );
  AO22X1 U813 ( .A0(n1090), .A1(n1208), .B0(n793), .B1(n794), .Y(n607) );
  INVXL U814 ( .A(n797), .Y(n1217) );
  NAND2XL U815 ( .A(n1088), .B(n1212), .Y(n816) );
  NOR2XL U816 ( .A(n1083), .B(n1215), .Y(n668) );
  AOI2BB2XL U817 ( .B0(n1186), .B1(n1084), .A0N(n1086), .A1N(n1220), .Y(n779)
         );
  NAND2XL U818 ( .A(n1078), .B(n1207), .Y(n699) );
  AO22X1 U819 ( .A0(n1085), .A1(n1211), .B0(n789), .B1(n790), .Y(n576) );
  NOR2XL U820 ( .A(n1077), .B(n1221), .Y(n791) );
  XNOR2XL U821 ( .A(n1019), .B(n1076), .Y(n792) );
  XOR2XL U822 ( .A(n1211), .B(n1085), .Y(n789) );
  NOR2XL U823 ( .A(n1076), .B(n1190), .Y(n801) );
  AOI211XL U824 ( .A0(n1078), .A1(n1191), .B0(n1168), .C0(n1082), .Y(n762) );
  AOI211XL U825 ( .A0(n1076), .A1(n1190), .B0(n1206), .C0(n1077), .Y(n800) );
  AOI31XL U826 ( .A0(n821), .A1(n1221), .A2(n1088), .B0(n822), .Y(n818) );
  NAND2X1 U827 ( .A(n669), .B(n670), .Y(n543) );
  NOR2XL U828 ( .A(n1078), .B(n1215), .Y(n673) );
  AOI211XL U829 ( .A0(n1076), .A1(n1191), .B0(n1168), .C0(n1077), .Y(n758) );
  NOR2XL U830 ( .A(n1190), .B(n1075), .Y(n822) );
  NAND2XL U831 ( .A(n1075), .B(n1190), .Y(n821) );
  AOI211XL U832 ( .A0(n1075), .A1(n1191), .B0(n1168), .C0(n1074), .Y(n769) );
  NAND2XL U833 ( .A(n663), .B(n767), .Y(n750) );
  NOR2XL U834 ( .A(n1075), .B(n1191), .Y(n770) );
  NAND3BXL U835 ( .AN(n696), .B(n1199), .C(n1087), .Y(n695) );
  OAI211XL U836 ( .A0(n1081), .A1(n1205), .B0(n823), .C0(n824), .Y(n738) );
  AOI33XL U837 ( .A0(n784), .A1(n785), .A2(n825), .B0(n826), .B1(n1190), .B2(
        n1079), .Y(n824) );
  NAND2XL U838 ( .A(n1081), .B(n1205), .Y(n826) );
  AOI32XL U839 ( .A0(n829), .A1(n1190), .A2(n1086), .B0(n1095), .B1(n1213), 
        .Y(n828) );
  NOR2XL U840 ( .A(n1028), .B(n1080), .Y(n830) );
  AOI211XL U841 ( .A0(n1083), .A1(n1215), .B0(n1020), .C0(n1091), .Y(n667) );
  NAND2XL U842 ( .A(n674), .B(n675), .Y(n654) );
  NOR2XL U843 ( .A(n1076), .B(n1215), .Y(n678) );
  NAND2XL U844 ( .A(n1080), .B(n1168), .Y(n825) );
  AOI2BB2XL U845 ( .B0(n820), .B1(n835), .A0N(n1211), .A1N(n1081), .Y(n834) );
  AOI211XL U846 ( .A0(n1078), .A1(n1215), .B0(n1020), .C0(n1082), .Y(n672) );
  OAI21XL U847 ( .A0(n1095), .A1(n1174), .B0(n771), .Y(n752) );
  NOR2XL U848 ( .A(n1086), .B(n1191), .Y(n773) );
  AOI211XL U849 ( .A0(n1086), .A1(n1191), .B0(n1168), .C0(n1087), .Y(n772) );
  AOI211XL U850 ( .A0(n1076), .A1(n1215), .B0(n1020), .C0(n1077), .Y(n677) );
  AO21XL U851 ( .A0(n1191), .A1(n836), .B0(n1094), .Y(n837) );
  NOR2XL U852 ( .A(n1206), .B(n1097), .Y(n836) );
  AO22XL U853 ( .A0(n1211), .A1(n1089), .B0(n660), .B1(n679), .Y(n653) );
  NAND2XL U854 ( .A(n1075), .B(n1215), .Y(n682) );
  OAI222XL U855 ( .A0(n1087), .A1(n1176), .B0(n1097), .B1(n437), .C0(n1080), 
        .C1(n438), .Y(n440) );
  AOI21XL U856 ( .A0(n1211), .A1(n1089), .B0(n662), .Y(n660) );
  NOR2XL U857 ( .A(n1026), .B(n1086), .Y(n696) );
  NAND2XL U858 ( .A(n1079), .B(n1220), .Y(n681) );
  OAI21XL U859 ( .A0(n1090), .A1(n1186), .B0(n697), .Y(n644) );
  OAI211XL U860 ( .A0(n1095), .A1(n1203), .B0(n698), .C0(n699), .Y(n697) );
  AOI31XL U861 ( .A0(n705), .A1(n1199), .A2(n1077), .B0(n706), .Y(n703) );
  NAND2X1 U862 ( .A(n674), .B(n688), .Y(n550) );
  AOI31XL U863 ( .A0(n691), .A1(n1021), .A2(n1087), .B0(n692), .Y(n689) );
  NAND3X1 U864 ( .A(n716), .B(n700), .C(n1194), .Y(n578) );
  AOI31XL U865 ( .A0(n722), .A1(n1199), .A2(n1074), .B0(n723), .Y(n720) );
  NOR2XL U866 ( .A(n1207), .B(n1076), .Y(n692) );
  NAND2XL U867 ( .A(n1076), .B(n1207), .Y(n691) );
  XNOR2XL U868 ( .A(n1186), .B(n1085), .Y(n690) );
  OAI22XL U869 ( .A0(n1085), .A1(n1195), .B0(n704), .B1(n1197), .Y(n700) );
  NOR2XL U870 ( .A(n1025), .B(n1083), .Y(n706) );
  NAND2XL U871 ( .A(n1083), .B(n1025), .Y(n705) );
  NAND2X1 U872 ( .A(n712), .B(n713), .Y(n571) );
  AOI31XL U873 ( .A0(n711), .A1(n1212), .A2(n1074), .B0(n710), .Y(n714) );
  NOR2XL U874 ( .A(n1220), .B(n1078), .Y(n710) );
  NAND2XL U875 ( .A(n1078), .B(n1220), .Y(n711) );
  NAND4BXL U876 ( .AN(n784), .B(n662), .C(n795), .D(n830), .Y(n847) );
  NAND4BXL U877 ( .AN(n705), .B(n781), .C(n693), .D(n1091), .Y(n846) );
  NAND4XL U878 ( .A(n1174), .B(n1206), .C(n848), .D(n849), .Y(n845) );
  CLKBUFX2 U879 ( .A(n969), .Y(n1078) );
  NOR4XL U880 ( .A(n411), .B(n412), .C(n1195), .D(n413), .Y(n409) );
  NAND4X1 U881 ( .A(state[0]), .B(n878), .C(Next_state[1]), .D(n1030), .Y(n352) );
  AOI2BB1X1 U882 ( .A0N(n878), .A1N(n879), .B0(n1023), .Y(n380) );
  NAND2X1 U883 ( .A(n950), .B(n951), .Y(n387) );
  NOR2BXL U884 ( .AN(n741), .B(n602), .Y(n1067) );
  NOR2BX4 U885 ( .AN(n741), .B(n602), .Y(n736) );
  AOI32XL U886 ( .A0(n1083), .A1(n1218), .A2(n778), .B0(n1092), .B1(n1203), 
        .Y(n777) );
  AOI32XL U887 ( .A0(n1078), .A1(n1026), .A2(n778), .B0(n1017), .B1(n1195), 
        .Y(n807) );
  OR3X2 U888 ( .A(n619), .B(n658), .C(n609), .Y(n1071) );
  NAND2X1 U889 ( .A(n1165), .B(n1171), .Y(n451) );
  NOR2BX1 U890 ( .AN(n605), .B(n1150), .Y(n459) );
  OAI31XL U891 ( .A0(n613), .A1(n523), .A2(n526), .B0(n597), .Y(n605) );
  CLKINVX1 U892 ( .A(n623), .Y(n1170) );
  NAND2X1 U893 ( .A(n539), .B(n1183), .Y(n562) );
  CLKINVX1 U894 ( .A(n555), .Y(n1172) );
  NOR2BX1 U895 ( .AN(n572), .B(n1202), .Y(n597) );
  CLKINVX1 U896 ( .A(n609), .Y(n1155) );
  CLKINVX1 U897 ( .A(n641), .Y(n1184) );
  CLKINVX1 U898 ( .A(n596), .Y(n1165) );
  CLKINVX1 U899 ( .A(n595), .Y(n1164) );
  CLKINVX1 U900 ( .A(n584), .Y(n1181) );
  AOI2BB1X1 U901 ( .A0N(n561), .A1N(n562), .B0(n563), .Y(n506) );
  NOR3X1 U902 ( .A(n564), .B(n1167), .C(n566), .Y(n561) );
  CLKINVX1 U903 ( .A(n419), .Y(n1167) );
  OA21XL U904 ( .A0(n622), .A1(n623), .B0(n624), .Y(n448) );
  NOR2X1 U905 ( .A(n602), .B(n564), .Y(n622) );
  AOI2BB2X1 U906 ( .B0(n600), .B1(n590), .A0N(n598), .A1N(n601), .Y(n470) );
  NAND2BX1 U907 ( .AN(n585), .B(n415), .Y(n600) );
  NOR4X1 U908 ( .A(n575), .B(n647), .C(n1166), .D(n1165), .Y(n645) );
  OR2X1 U909 ( .A(n554), .B(n579), .Y(n647) );
  AND2X2 U910 ( .A(n630), .B(n631), .Y(n452) );
  OAI31XL U911 ( .A0(n594), .A1(n579), .A2(n1164), .B0(n1171), .Y(n630) );
  AOI2BB1X1 U912 ( .A0N(n618), .A1N(n619), .B0(n620), .Y(n449) );
  NOR2X1 U913 ( .A(n415), .B(n562), .Y(n489) );
  CLKINVX1 U914 ( .A(n633), .Y(n1196) );
  NAND2BX1 U915 ( .AN(n619), .B(n526), .Y(n624) );
  NAND2X1 U916 ( .A(n584), .B(n590), .Y(n466) );
  CLKINVX1 U917 ( .A(n556), .Y(n1187) );
  NAND2X1 U918 ( .A(n563), .B(n641), .Y(n631) );
  NOR2BX1 U919 ( .AN(n575), .B(n1172), .Y(n487) );
  CLKINVX1 U920 ( .A(n632), .Y(n1171) );
  AOI211X1 U921 ( .A0(n1202), .A1(n432), .B0(n620), .C0(n1193), .Y(n433) );
  CLKINVX1 U922 ( .A(n538), .Y(n1188) );
  AOI2BB1X1 U923 ( .A0N(n554), .A1N(n1172), .B0(n1179), .Y(n507) );
  NAND2X1 U924 ( .A(n538), .B(n539), .Y(n520) );
  NAND2X1 U925 ( .A(n556), .B(n1169), .Y(n504) );
  CLKINVX1 U926 ( .A(n601), .Y(n1179) );
  NAND2X1 U927 ( .A(n554), .B(n555), .Y(n505) );
  OA21XL U928 ( .A0(n1179), .A1(n598), .B0(n599), .Y(n471) );
  NAND2X1 U929 ( .A(n1192), .B(n1183), .Y(n502) );
  NAND3X2 U930 ( .A(n737), .B(n738), .C(n736), .Y(n414) );
  XNOR2X1 U931 ( .A(n1025), .B(n1218), .Y(n797) );
  NOR2BX1 U932 ( .AN(n583), .B(n1151), .Y(n476) );
  OAI211X1 U933 ( .A0(n584), .A1(n585), .B0(n576), .C0(n1169), .Y(n583) );
  XOR2X1 U934 ( .A(n1211), .B(n1195), .Y(n721) );
  AOI21X1 U935 ( .A0(n571), .A1(n633), .B0(n1149), .Y(n443) );
  AO21X1 U936 ( .A0(n655), .A1(n1155), .B0(n496), .Y(n426) );
  OAI221XL U937 ( .A0(n593), .A1(n612), .B0(n607), .B1(n608), .C0(n627), .Y(
        n655) );
  NOR2BX1 U938 ( .AN(n750), .B(n594), .Y(n751) );
  INVX3 U939 ( .A(n576), .Y(n1209) );
  NAND2X1 U940 ( .A(n592), .B(n627), .Y(n632) );
  NAND2X1 U941 ( .A(n597), .B(n627), .Y(n619) );
  NOR3X1 U942 ( .A(n1209), .B(n1185), .C(n551), .Y(n572) );
  OR3X2 U943 ( .A(n788), .B(n787), .C(n830), .Y(n754) );
  CLKINVX1 U944 ( .A(n654), .Y(n1204) );
  AOI21X1 U945 ( .A0(n643), .A1(n644), .B0(n1178), .Y(n552) );
  INVX3 U946 ( .A(n642), .Y(n1178) );
  NOR2BX1 U947 ( .AN(n627), .B(n598), .Y(n641) );
  AOI33X1 U948 ( .A0(n555), .A1(n576), .A2(n577), .B0(n1209), .B1(n571), .B2(
        n578), .Y(n482) );
  NAND2X1 U949 ( .A(n751), .B(n752), .Y(n596) );
  NAND3BX1 U950 ( .AN(n738), .B(n1067), .C(n737), .Y(n419) );
  NOR4X1 U951 ( .A(n649), .B(n1167), .C(n584), .D(n538), .Y(n648) );
  NOR2X2 U952 ( .A(n750), .B(n594), .Y(n579) );
  CLKINVX1 U953 ( .A(n550), .Y(n1175) );
  CLKINVX1 U954 ( .A(n410), .Y(n1159) );
  AOI222XL U955 ( .A0(n1178), .A1(n1028), .B0(n487), .B1(n1168), .C0(n489), 
        .C1(n1206), .Y(n493) );
  AOI222XL U956 ( .A0(n1178), .A1(n1186), .B0(n487), .B1(n1174), .C0(n489), 
        .C1(n1213), .Y(n569) );
  AOI222XL U957 ( .A0(n1178), .A1(n1207), .B0(n487), .B1(n1191), .C0(n489), 
        .C1(n1190), .Y(n484) );
  AOI222XL U958 ( .A0(n523), .A1(n1207), .B0(n524), .B1(n1025), .C0(n526), 
        .C1(n1220), .Y(n522) );
  AOI222XL U959 ( .A0(n523), .A1(n1028), .B0(n524), .B1(n1021), .C0(n526), 
        .C1(n1221), .Y(n530) );
  AOI222XL U960 ( .A0(n523), .A1(n1186), .B0(n524), .B1(n1208), .C0(n526), 
        .C1(n1211), .Y(n535) );
  NOR2BX1 U961 ( .AN(n627), .B(n593), .Y(n633) );
  AOI2BB2X1 U962 ( .B0(n591), .B1(n592), .A0N(n593), .A1N(n578), .Y(n465) );
  CLKINVX1 U963 ( .A(n650), .Y(n1176) );
  OAI211X1 U964 ( .A0(n651), .A1(n619), .B0(n652), .C0(n624), .Y(n650) );
  NAND3X1 U965 ( .A(n552), .B(n550), .C(n641), .Y(n652) );
  AOI222XL U966 ( .A0(n579), .A1(n1211), .B0(n575), .B1(n1208), .C0(n554), 
        .C1(n1203), .Y(n744) );
  NOR2X1 U967 ( .A(n735), .B(n566), .Y(n556) );
  CLKINVX1 U968 ( .A(n638), .Y(n1177) );
  OAI211X1 U969 ( .A0(n639), .A1(n1184), .B0(n640), .C0(n631), .Y(n638) );
  NOR2X1 U970 ( .A(n1179), .B(n1178), .Y(n639) );
  NAND3X1 U971 ( .A(n578), .B(n571), .C(n633), .Y(n640) );
  NOR2BX1 U972 ( .AN(n552), .B(n550), .Y(n563) );
  OA21XL U973 ( .A0(n563), .A1(n1184), .B0(n604), .Y(n453) );
  NAND2X1 U974 ( .A(n1209), .B(n607), .Y(n593) );
  NOR2X2 U975 ( .A(n748), .B(n1166), .Y(n554) );
  CLKINVX1 U976 ( .A(n541), .Y(n1166) );
  CLKINVX1 U977 ( .A(n425), .Y(n1189) );
  NOR2X1 U978 ( .A(n571), .B(n1196), .Y(n620) );
  CLKINVX1 U979 ( .A(n717), .Y(n1194) );
  NOR2BX1 U980 ( .AN(n604), .B(n700), .Y(n608) );
  OAI2BB2X1 U981 ( .B0(n1192), .B1(n543), .A0N(n1188), .A1N(n539), .Y(n517) );
  AOI31X1 U982 ( .A0(n1183), .A1(n558), .A2(n545), .B0(n1178), .Y(n508) );
  AND2X2 U983 ( .A(n570), .B(n571), .Y(n485) );
  OAI21XL U984 ( .A0(n1192), .A1(n543), .B0(n572), .Y(n570) );
  NAND3X1 U985 ( .A(n642), .B(n643), .C(n644), .Y(n601) );
  CLKINVX1 U986 ( .A(n578), .Y(n1193) );
  OAI31X1 U987 ( .A0(n1178), .A1(n1183), .A2(n1209), .B0(n578), .Y(n479) );
  OAI21X1 U988 ( .A0(n1189), .A1(n729), .B0(n541), .Y(n726) );
  NOR3BX1 U989 ( .AN(n572), .B(n1192), .C(n543), .Y(n480) );
  OAI21X1 U990 ( .A0(n1166), .A1(n540), .B0(n545), .Y(n516) );
  OA21XL U991 ( .A0(n1193), .A1(n593), .B0(n604), .Y(n469) );
  AND2XL U992 ( .A(n599), .B(n627), .Y(n454) );
  NOR2X1 U993 ( .A(n425), .B(n729), .Y(n727) );
  CLKINVX1 U994 ( .A(n1116), .Y(n1136) );
  OA21XL U995 ( .A0(N111), .A1(MatchCount[1]), .B0(n350), .Y(n348) );
  CLKINVX1 U996 ( .A(n345), .Y(n1162) );
  INVXL U997 ( .A(N111), .Y(n1163) );
  AOI211X1 U998 ( .A0(n831), .A1(n832), .B0(n833), .C0(n834), .Y(n774) );
  AOI211X1 U999 ( .A0(n1180), .A1(n685), .B0(n686), .C0(n1175), .Y(n657) );
  CLKINVX1 U1000 ( .A(n690), .Y(n1180) );
  OAI31XL U1001 ( .A0(n1021), .A1(n1087), .A2(n692), .B0(n691), .Y(n685) );
  AOI211X1 U1002 ( .A0(n660), .A1(n661), .B0(n1182), .C0(n662), .Y(n658) );
  OAI31XL U1003 ( .A0(n1221), .A1(n1080), .A2(n1216), .B0(n682), .Y(n661) );
  CLKINVX1 U1004 ( .A(n681), .Y(n1216) );
  NOR2X1 U1005 ( .A(n1083), .B(n1190), .Y(n806) );
  INVX3 U1006 ( .A(n969), .Y(n1218) );
  NAND2BX1 U1007 ( .AN(n775), .B(n808), .Y(n776) );
  XOR2X1 U1008 ( .A(n1212), .B(n1091), .Y(n808) );
  AOI222XL U1009 ( .A0(n1090), .A1(n1213), .B0(n1078), .B1(n815), .C0(n816), 
        .C1(n1190), .Y(n812) );
  NAND2BX1 U1010 ( .AN(n816), .B(n1094), .Y(n815) );
  CLKINVX1 U1011 ( .A(n811), .Y(n1198) );
  OAI31XL U1012 ( .A0(n1199), .A1(n1074), .A2(n723), .B0(n722), .Y(n811) );
  INVX3 U1013 ( .A(n1075), .Y(n1220) );
  INVX3 U1014 ( .A(n1085), .Y(n1208) );
  INVX3 U1015 ( .A(n1082), .Y(n1212) );
  INVX3 U1016 ( .A(n1092), .Y(n1195) );
  INVX3 U1017 ( .A(n1084), .Y(n1211) );
  INVX3 U1018 ( .A(n1091), .Y(n1199) );
  OAI22XL U1019 ( .A0(n1082), .A1(n443), .B0(n1149), .B1(n455), .Y(n994) );
  NOR3X1 U1020 ( .A(n456), .B(n457), .C(n458), .Y(n455) );
  OAI22XL U1021 ( .A0(n1088), .A1(n450), .B0(n1097), .B1(n451), .Y(n457) );
  OAI222XL U1022 ( .A0(n1087), .A1(n452), .B0(n1077), .B1(n453), .C0(n1091), 
        .C1(n454), .Y(n456) );
  NAND2X1 U1023 ( .A(n669), .B(n760), .Y(n748) );
  OAI21XL U1024 ( .A0(n1090), .A1(n1174), .B0(n761), .Y(n760) );
  OAI22XL U1025 ( .A0(n1096), .A1(n1203), .B0(n762), .B1(n763), .Y(n761) );
  NOR2X1 U1026 ( .A(n1078), .B(n1191), .Y(n763) );
  OAI22XL U1027 ( .A0(n1076), .A1(n1218), .B0(n795), .B1(n1217), .Y(n794) );
  INVX3 U1028 ( .A(n1088), .Y(n1206) );
  OAI21XL U1029 ( .A0(n1090), .A1(n1205), .B0(n671), .Y(n670) );
  OAI22XL U1030 ( .A0(n1089), .A1(n1203), .B0(n672), .B1(n673), .Y(n671) );
  CLKINVX1 U1031 ( .A(n785), .Y(n1173) );
  INVX3 U1032 ( .A(n1093), .Y(n1191) );
  OAI22XL U1033 ( .A0(n1091), .A1(n426), .B0(n1149), .B1(n439), .Y(n992) );
  NOR3X1 U1034 ( .A(n440), .B(n441), .C(n442), .Y(n439) );
  OAI22XL U1035 ( .A0(n1082), .A1(n432), .B0(n1077), .B1(n433), .Y(n442) );
  OAI22XL U1036 ( .A0(n1074), .A1(n1177), .B0(n1088), .B1(n435), .Y(n441) );
  AO21X1 U1037 ( .A0(n1221), .A1(n1087), .B0(n781), .Y(n780) );
  INVX3 U1038 ( .A(n1074), .Y(n1221) );
  INVX3 U1039 ( .A(n1094), .Y(n1190) );
  OAI211X1 U1040 ( .A0(n1074), .A1(n1021), .B0(n1219), .C0(n789), .Y(n674) );
  CLKINVX1 U1041 ( .A(n792), .Y(n1219) );
  OAI21XL U1042 ( .A0(n1085), .A1(n1213), .B0(n799), .Y(n798) );
  OAI22XL U1043 ( .A0(n1081), .A1(n1208), .B0(n800), .B1(n801), .Y(n799) );
  NAND2X1 U1044 ( .A(n1070), .B(n665), .Y(n545) );
  OAI21XL U1045 ( .A0(n1092), .A1(n1205), .B0(n666), .Y(n665) );
  OAI22XL U1046 ( .A0(n1089), .A1(n1195), .B0(n667), .B1(n668), .Y(n666) );
  INVX3 U1047 ( .A(n1079), .Y(n1215) );
  AOI2BB2X1 U1048 ( .B0(n1080), .B1(n1028), .A0N(n1215), .A1N(n1086), .Y(n786)
         );
  NOR2X1 U1049 ( .A(n1021), .B(n1082), .Y(n795) );
  INVX3 U1050 ( .A(n1089), .Y(n1205) );
  INVX3 U1051 ( .A(n1096), .Y(n1174) );
  CLKINVX1 U1052 ( .A(N87), .Y(n1161) );
  INVX3 U1053 ( .A(n1095), .Y(n1186) );
  OAI22XL U1054 ( .A0(n1075), .A1(n1025), .B0(n791), .B1(n792), .Y(n790) );
  INVX3 U1055 ( .A(n1081), .Y(n1213) );
  OAI221XL U1056 ( .A0(n1080), .A1(n1206), .B0(n1079), .B1(n1190), .C0(n826), 
        .Y(n823) );
  NAND2X1 U1057 ( .A(n663), .B(n817), .Y(n741) );
  OAI22XL U1058 ( .A0(n1084), .A1(n1213), .B0(n818), .B1(n1210), .Y(n817) );
  CLKINVX1 U1059 ( .A(n820), .Y(n1210) );
  NAND2X1 U1060 ( .A(n674), .B(n756), .Y(n749) );
  OAI21XL U1061 ( .A0(n1085), .A1(n1174), .B0(n757), .Y(n756) );
  OAI22XL U1062 ( .A0(n1096), .A1(n1208), .B0(n758), .B1(n759), .Y(n757) );
  NOR2X1 U1063 ( .A(n1076), .B(n1191), .Y(n759) );
  INVX3 U1064 ( .A(n1097), .Y(n1168) );
  OAI21X1 U1065 ( .A0(n1087), .A1(n1221), .B0(n779), .Y(n663) );
  NAND3X1 U1066 ( .A(n827), .B(n754), .C(n828), .Y(n737) );
  OAI221XL U1067 ( .A0(n1087), .A1(n1206), .B0(n1086), .B1(n1190), .C0(n829), 
        .Y(n827) );
  NAND2X1 U1068 ( .A(n1081), .B(n1186), .Y(n829) );
  OAI221XL U1069 ( .A0(n836), .A1(n1191), .B0(n1081), .B1(n1174), .C0(n837), 
        .Y(n832) );
  OAI31XL U1070 ( .A0(n1221), .A1(n1088), .A2(n822), .B0(n821), .Y(n835) );
  OAI21XL U1071 ( .A0(n1085), .A1(n1205), .B0(n676), .Y(n675) );
  OAI22XL U1072 ( .A0(n1089), .A1(n1208), .B0(n677), .B1(n678), .Y(n676) );
  OAI21XL U1073 ( .A0(n1084), .A1(n1174), .B0(n768), .Y(n767) );
  OAI22XL U1074 ( .A0(n1096), .A1(n1211), .B0(n769), .B1(n770), .Y(n768) );
  OAI22XL U1075 ( .A0(n1096), .A1(n1186), .B0(n772), .B1(n773), .Y(n771) );
  CLKINVX1 U1076 ( .A(n359), .Y(n1160) );
  NOR2X1 U1077 ( .A(n1195), .B(n1095), .Y(n693) );
  OAI31XL U1078 ( .A0(n1020), .A1(n1074), .A2(n1214), .B0(n681), .Y(n679) );
  CLKINVX1 U1079 ( .A(n682), .Y(n1214) );
  NAND3BX1 U1080 ( .AN(n693), .B(n694), .C(n1070), .Y(n642) );
  OAI221XL U1081 ( .A0(n1083), .A1(n1207), .B0(n1092), .B1(n1186), .C0(n695), 
        .Y(n694) );
  OAI21XL U1082 ( .A0(n1095), .A1(n1208), .B0(n552), .Y(n686) );
  NOR2X1 U1083 ( .A(n1211), .B(n1089), .Y(n662) );
  OAI22XL U1084 ( .A0(n1093), .A1(n724), .B0(n1154), .B1(n725), .Y(n1009) );
  AOI222XL U1085 ( .A0(n726), .A1(n1026), .B0(n727), .B1(n1190), .C0(n728), 
        .C1(n729), .Y(n725) );
  OAI221XL U1086 ( .A0(n1086), .A1(n596), .B0(n1079), .B1(n595), .C0(n730), 
        .Y(n728) );
  AOI222XL U1087 ( .A0(n579), .A1(n1220), .B0(n575), .B1(n1025), .C0(n554), 
        .C1(n1218), .Y(n730) );
  OAI22XL U1088 ( .A0(n1097), .A1(n724), .B0(n1154), .B1(n745), .Y(n1012) );
  AOI222XL U1089 ( .A0(n726), .A1(n1199), .B0(n727), .B1(n1206), .C0(n746), 
        .C1(n729), .Y(n745) );
  OAI221XL U1090 ( .A0(n1087), .A1(n596), .B0(n1080), .B1(n595), .C0(n747), 
        .Y(n746) );
  AOI222XL U1091 ( .A0(n579), .A1(n1221), .B0(n575), .B1(n1021), .C0(n554), 
        .C1(n1212), .Y(n747) );
  OAI222XL U1092 ( .A0(n1076), .A1(n506), .B0(n1078), .B1(n507), .C0(n1083), 
        .C1(n508), .Y(n499) );
  OAI222XL U1093 ( .A0(n1077), .A1(n506), .B0(n1082), .B1(n507), .C0(n1091), 
        .C1(n508), .Y(n510) );
  OAI222XL U1094 ( .A0(n1085), .A1(n506), .B0(n1090), .B1(n507), .C0(n1092), 
        .C1(n508), .Y(n547) );
  OAI222XL U1095 ( .A0(n1086), .A1(n1176), .B0(n1093), .B1(n437), .C0(n1079), 
        .C1(n438), .Y(n429) );
  OAI222XL U1096 ( .A0(n1095), .A1(n1176), .B0(n1096), .B1(n437), .C0(n1089), 
        .C1(n438), .Y(n635) );
  OAI22XL U1097 ( .A0(n1079), .A1(n448), .B0(n1075), .B1(n449), .Y(n447) );
  OAI22XL U1098 ( .A0(n1080), .A1(n448), .B0(n1074), .B1(n449), .Y(n458) );
  OAI22XL U1099 ( .A0(n1089), .A1(n448), .B0(n1084), .B1(n449), .Y(n617) );
  OAI222XL U1100 ( .A0(n1083), .A1(n469), .B0(n1086), .B1(n470), .C0(n969), 
        .C1(n471), .Y(n462) );
  OAI222XL U1101 ( .A0(n1091), .A1(n469), .B0(n1087), .B1(n470), .C0(n1082), 
        .C1(n471), .Y(n473) );
  OAI222XL U1102 ( .A0(n1092), .A1(n469), .B0(n1095), .B1(n470), .C0(n1090), 
        .C1(n471), .Y(n587) );
  OAI22XL U1103 ( .A0(n1085), .A1(n1186), .B0(n689), .B1(n690), .Y(n688) );
  OAI22XL U1104 ( .A0(n1088), .A1(n1159), .B0(n421), .B1(n410), .Y(n990) );
  NOR3X1 U1105 ( .A(n422), .B(n423), .C(n424), .Y(n421) );
  OAI22XL U1106 ( .A0(n1082), .A1(n1188), .B0(n1080), .B1(n419), .Y(n423) );
  OAI222XL U1107 ( .A0(n1097), .A1(n414), .B0(n1074), .B1(n415), .C0(n1091), 
        .C1(n425), .Y(n422) );
  OAI22XL U1108 ( .A0(n1094), .A1(n1159), .B0(n731), .B1(n410), .Y(n1010) );
  NOR3X1 U1109 ( .A(n732), .B(n733), .C(n734), .Y(n731) );
  OAI22XL U1110 ( .A0(n969), .A1(n1188), .B0(n1079), .B1(n419), .Y(n733) );
  OAI222XL U1111 ( .A0(n1093), .A1(n414), .B0(n1075), .B1(n415), .C0(n1083), 
        .C1(n425), .Y(n732) );
  OAI222XL U1112 ( .A0(n1086), .A1(n452), .B0(n1076), .B1(n453), .C0(n1083), 
        .C1(n454), .Y(n445) );
  OAI222XL U1113 ( .A0(n1095), .A1(n452), .B0(n1085), .B1(n453), .C0(n1092), 
        .C1(n454), .Y(n615) );
  CLKBUFX3 U1114 ( .A(n1156), .Y(n1099) );
  OAI22XL U1115 ( .A0(n1078), .A1(n1207), .B0(n1082), .B1(n1028), .Y(n698) );
  OAI22XL U1116 ( .A0(n1075), .A1(n465), .B0(n1094), .B1(n466), .Y(n464) );
  OAI22XL U1117 ( .A0(n1074), .A1(n465), .B0(n1088), .B1(n466), .Y(n475) );
  OAI22XL U1118 ( .A0(n1084), .A1(n465), .B0(n1081), .B1(n466), .Y(n589) );
  OAI22XL U1119 ( .A0(n1087), .A1(n1181), .B0(n1077), .B1(n1187), .Y(n424) );
  OAI22XL U1120 ( .A0(n1086), .A1(n1181), .B0(n1076), .B1(n1187), .Y(n734) );
  OAI22XL U1121 ( .A0(n1095), .A1(n1181), .B0(n1085), .B1(n1187), .Y(n412) );
  OAI22XL U1122 ( .A0(n1075), .A1(n1177), .B0(n1094), .B1(n435), .Y(n430) );
  OAI22XL U1123 ( .A0(n1084), .A1(n1177), .B0(n1081), .B1(n435), .Y(n636) );
  OAI22XL U1124 ( .A0(n1096), .A1(n414), .B0(n1084), .B1(n415), .Y(n413) );
  OAI22XL U1125 ( .A0(n1092), .A1(n1211), .B0(n720), .B1(n721), .Y(n716) );
  AND3X2 U1126 ( .A(n578), .B(n571), .C(n707), .Y(n612) );
  AOI2BB2X1 U1127 ( .B0(n708), .B1(n709), .A0N(n1203), .A1N(n1084), .Y(n707)
         );
  OAI31XL U1128 ( .A0(n1212), .A1(n1074), .A2(n710), .B0(n711), .Y(n709) );
  NAND2X1 U1129 ( .A(n1194), .B(n702), .Y(n604) );
  OAI22XL U1130 ( .A0(n1092), .A1(n1208), .B0(n703), .B1(n704), .Y(n702) );
  CLKINVX1 U1131 ( .A(n719), .Y(n1197) );
  OAI31XL U1132 ( .A0(n1199), .A1(n1077), .A2(n706), .B0(n705), .Y(n719) );
  OAI22XL U1133 ( .A0(n1079), .A1(n502), .B0(n1075), .B1(n503), .Y(n501) );
  OAI22XL U1134 ( .A0(n1080), .A1(n502), .B0(n1074), .B1(n503), .Y(n512) );
  OAI22XL U1135 ( .A0(n1089), .A1(n502), .B0(n1084), .B1(n503), .Y(n549) );
  OAI22XL U1136 ( .A0(n1090), .A1(n1211), .B0(n714), .B1(n1200), .Y(n713) );
  CLKINVX1 U1137 ( .A(n708), .Y(n1200) );
  AND2X2 U1138 ( .A(N134), .B(n1098), .Y(N144) );
  AND2X2 U1139 ( .A(N133), .B(n1098), .Y(N143) );
  OA21XL U1140 ( .A0(n1160), .A1(n1022), .B0(n1157), .Y(n842) );
  AND2X2 U1141 ( .A(N132), .B(n1098), .Y(N142) );
  NAND2X2 U1142 ( .A(n1157), .B(n1022), .Y(n386) );
  OAI22XL U1143 ( .A0(n1094), .A1(n386), .B0(n1076), .B1(n387), .Y(n395) );
  OAI22XL U1144 ( .A0(n1088), .A1(n386), .B0(n1077), .B1(n387), .Y(n404) );
  OAI22XL U1145 ( .A0(n1081), .A1(n386), .B0(n1085), .B1(n387), .Y(n385) );
  NAND2X1 U1146 ( .A(n380), .B(n1024), .Y(n379) );
  AND2X2 U1147 ( .A(N131), .B(n1098), .Y(N141) );
  AOI2BB1X1 U1148 ( .A0N(n383), .A1N(n381), .B0(n1160), .Y(N38) );
  NOR3X1 U1149 ( .A(n845), .B(n846), .C(n847), .Y(N148) );
  AND2X2 U1150 ( .A(N130), .B(n1098), .Y(N140) );
  AND2X2 U1151 ( .A(N129), .B(n1098), .Y(N139) );
  NOR3X1 U1152 ( .A(n1094), .B(n1074), .C(n1081), .Y(n848) );
  NOR3X1 U1153 ( .A(n387), .B(n1098), .C(n1024), .Y(n361) );
  CLKINVX1 U1154 ( .A(n1128), .Y(n1135) );
  CLKINVX1 U1155 ( .A(n1113), .Y(n1138) );
  NOR2BX1 U1156 ( .AN(n353), .B(n352), .Y(n350) );
  OAI21XL U1157 ( .A0(n880), .A1(n1072), .B0(n1163), .Y(n353) );
  OAI21XL U1158 ( .A0(n875), .A1(n343), .B0(n344), .Y(n882) );
  NAND4X1 U1159 ( .A(n875), .B(n345), .C(MatchCount[1]), .D(MatchCount[2]), 
        .Y(n344) );
  OA21XL U1160 ( .A0(N111), .A1(MatchCount[2]), .B0(n348), .Y(n343) );
  OAI32X1 U1161 ( .A0(MatchCount[2]), .A1(n877), .A2(n1162), .B0(n876), .B1(
        n348), .Y(n884) );
  NOR4X1 U1162 ( .A(n1072), .B(n352), .C(N111), .D(n880), .Y(n345) );
  OAI22XL U1163 ( .A0(n877), .A1(n350), .B0(n1162), .B1(MatchCount[1]), .Y(
        n886) );
  OAI21XL U1164 ( .A0(n352), .A1(n1163), .B0(n355), .Y(n888) );
  XOR2X1 U1165 ( .A(n880), .B(n356), .Y(n355) );
  NOR2X1 U1166 ( .A(n352), .B(n1072), .Y(n356) );
  OAI21XL U1167 ( .A0(n595), .A1(n754), .B0(n1155), .Y(n753) );
  OAI22XL U1168 ( .A0(n1076), .A1(n459), .B0(n1150), .B1(n461), .Y(n995) );
  NOR3X1 U1169 ( .A(n462), .B(n463), .C(n464), .Y(n461) );
  OAI22XL U1170 ( .A0(n1093), .A1(n467), .B0(n1079), .B1(n468), .Y(n463) );
  OAI22XL U1171 ( .A0(n1077), .A1(n459), .B0(n1150), .B1(n472), .Y(n996) );
  NOR3X1 U1172 ( .A(n473), .B(n474), .C(n475), .Y(n472) );
  OAI22XL U1173 ( .A0(n1097), .A1(n467), .B0(n1080), .B1(n468), .Y(n474) );
  OAI22XL U1174 ( .A0(n1085), .A1(n459), .B0(n1150), .B1(n586), .Y(n1006) );
  NOR3X1 U1175 ( .A(n587), .B(n588), .C(n589), .Y(n586) );
  OAI22XL U1176 ( .A0(n1096), .A1(n467), .B0(n1089), .B1(n468), .Y(n588) );
  CLKINVX1 U1177 ( .A(n1129), .Y(n1134) );
  OAI22XL U1178 ( .A0(n1074), .A1(n476), .B0(n1151), .B1(n491), .Y(n998) );
  AOI221XL U1179 ( .A0(n479), .A1(n1199), .B0(n480), .B1(n1020), .C0(n492), 
        .Y(n491) );
  OAI222XL U1180 ( .A0(n1077), .A1(n482), .B0(n1209), .B1(n493), .C0(n1082), 
        .C1(n485), .Y(n492) );
  OAI22XL U1181 ( .A0(n1075), .A1(n476), .B0(n1151), .B1(n478), .Y(n997) );
  AOI221XL U1182 ( .A0(n479), .A1(n1026), .B0(n480), .B1(n1215), .C0(n481), 
        .Y(n478) );
  OAI222XL U1183 ( .A0(n1076), .A1(n482), .B0(n1209), .B1(n484), .C0(n1078), 
        .C1(n485), .Y(n481) );
  OAI22XL U1184 ( .A0(n1084), .A1(n476), .B0(n1151), .B1(n567), .Y(n1005) );
  AOI221XL U1185 ( .A0(n479), .A1(n1195), .B0(n480), .B1(n1205), .C0(n568), 
        .Y(n567) );
  OAI222XL U1186 ( .A0(n1085), .A1(n482), .B0(n1209), .B1(n569), .C0(n1090), 
        .C1(n485), .Y(n568) );
  OAI22XL U1187 ( .A0(n1078), .A1(n443), .B0(n1149), .B1(n444), .Y(n993) );
  NOR3X1 U1188 ( .A(n445), .B(n446), .C(n447), .Y(n444) );
  OAI22XL U1189 ( .A0(n1094), .A1(n450), .B0(n1093), .B1(n451), .Y(n446) );
  OAI22XL U1190 ( .A0(n1090), .A1(n443), .B0(n1149), .B1(n614), .Y(n1007) );
  NOR3X1 U1191 ( .A(n615), .B(n616), .C(n617), .Y(n614) );
  OAI22XL U1192 ( .A0(n1081), .A1(n450), .B0(n1096), .B1(n451), .Y(n616) );
  OAI22XL U1193 ( .A0(n1083), .A1(n426), .B0(n1149), .B1(n428), .Y(n991) );
  NOR3X1 U1194 ( .A(n429), .B(n430), .C(n431), .Y(n428) );
  OAI22XL U1195 ( .A0(n1078), .A1(n432), .B0(n1076), .B1(n433), .Y(n431) );
  OAI22XL U1196 ( .A0(n1092), .A1(n426), .B0(n1149), .B1(n634), .Y(n1008) );
  NOR3X1 U1197 ( .A(n635), .B(n636), .C(n637), .Y(n634) );
  OAI22XL U1198 ( .A0(n1090), .A1(n432), .B0(n1085), .B1(n433), .Y(n637) );
  OAI222XL U1199 ( .A0(n362), .A1(n1148), .B0(n364), .B1(n1137), .C0(n855), 
        .C1(n1073), .Y(n961) );
  CLKINVX1 U1200 ( .A(N77), .Y(n1148) );
  OAI222XL U1201 ( .A0(n362), .A1(n1147), .B0(n364), .B1(n856), .C0(n857), 
        .C1(n1073), .Y(n960) );
  CLKINVX1 U1202 ( .A(N78), .Y(n1147) );
  OAI222XL U1203 ( .A0(n362), .A1(n1146), .B0(n364), .B1(n858), .C0(n859), 
        .C1(n1073), .Y(n959) );
  CLKINVX1 U1204 ( .A(N79), .Y(n1146) );
  OAI222XL U1205 ( .A0(n362), .A1(n1145), .B0(n364), .B1(n860), .C0(n861), 
        .C1(n1073), .Y(n958) );
  CLKINVX1 U1206 ( .A(N80), .Y(n1145) );
  OAI222XL U1207 ( .A0(n362), .A1(n1144), .B0(n364), .B1(n862), .C0(n863), 
        .C1(n1073), .Y(n957) );
  CLKINVX1 U1208 ( .A(N81), .Y(n1144) );
  OAI222XL U1209 ( .A0(n362), .A1(n1143), .B0(n364), .B1(n864), .C0(n865), 
        .C1(n1073), .Y(n956) );
  CLKINVX1 U1210 ( .A(N82), .Y(n1143) );
  OAI222XL U1211 ( .A0(n362), .A1(n1142), .B0(n364), .B1(n866), .C0(n867), 
        .C1(n1073), .Y(n955) );
  CLKINVX1 U1212 ( .A(N83), .Y(n1142) );
  OAI222XL U1213 ( .A0(n362), .A1(n1141), .B0(n364), .B1(n868), .C0(n869), 
        .C1(n1073), .Y(n954) );
  CLKINVX1 U1214 ( .A(N84), .Y(n1141) );
  OAI222XL U1215 ( .A0(n362), .A1(n1139), .B0(n364), .B1(n870), .C0(n871), 
        .C1(n1073), .Y(n952) );
  CLKINVX1 U1216 ( .A(N86), .Y(n1139) );
  OAI222XL U1217 ( .A0(n362), .A1(n1140), .B0(n364), .B1(n852), .C0(n853), 
        .C1(n1073), .Y(n953) );
  CLKINVX1 U1218 ( .A(N85), .Y(n1140) );
  CLKBUFX3 U1219 ( .A(n365), .Y(n1073) );
  OA21XL U1220 ( .A0(n879), .A1(n1161), .B0(n878), .Y(n365) );
  NAND3X2 U1221 ( .A(n1161), .B(Next_state[1]), .C(n878), .Y(n364) );
  OAI22XL U1222 ( .A0(n1086), .A1(n496), .B0(n1152), .B1(n498), .Y(n999) );
  NOR3X1 U1223 ( .A(n499), .B(n500), .C(n501), .Y(n498) );
  OAI22XL U1224 ( .A0(n1094), .A1(n504), .B0(n1093), .B1(n505), .Y(n500) );
  OAI22XL U1225 ( .A0(n1087), .A1(n496), .B0(n1152), .B1(n509), .Y(n1000) );
  NOR3X1 U1226 ( .A(n510), .B(n511), .C(n512), .Y(n509) );
  OAI22XL U1227 ( .A0(n1088), .A1(n504), .B0(n1097), .B1(n505), .Y(n511) );
  OAI22XL U1228 ( .A0(n1095), .A1(n496), .B0(n1152), .B1(n546), .Y(n1004) );
  NOR3X1 U1229 ( .A(n547), .B(n548), .C(n549), .Y(n546) );
  OAI22XL U1230 ( .A0(n1081), .A1(n504), .B0(n1096), .B1(n505), .Y(n548) );
  OAI22XL U1231 ( .A0(n1079), .A1(n513), .B0(n1153), .B1(n515), .Y(n1001) );
  AOI221XL U1232 ( .A0(n516), .A1(n1026), .B0(n517), .B1(n1218), .C0(n518), 
        .Y(n515) );
  OAI222XL U1233 ( .A0(n1093), .A1(n519), .B0(n1094), .B1(n520), .C0(n1185), 
        .C1(n522), .Y(n518) );
  OAI22XL U1234 ( .A0(n1080), .A1(n513), .B0(n1153), .B1(n528), .Y(n1002) );
  AOI221XL U1235 ( .A0(n516), .A1(n1199), .B0(n517), .B1(n1212), .C0(n529), 
        .Y(n528) );
  OAI222XL U1236 ( .A0(n1097), .A1(n519), .B0(n1088), .B1(n520), .C0(n1185), 
        .C1(n530), .Y(n529) );
  OAI22XL U1237 ( .A0(n1089), .A1(n513), .B0(n1153), .B1(n533), .Y(n1003) );
  AOI221XL U1238 ( .A0(n516), .A1(n1195), .B0(n517), .B1(n1018), .C0(n534), 
        .Y(n533) );
  OAI222XL U1239 ( .A0(n1096), .A1(n519), .B0(n1081), .B1(n520), .C0(n1185), 
        .C1(n535), .Y(n534) );
  NOR2X2 U1240 ( .A(n1022), .B(n951), .Y(n381) );
  NAND3X1 U1241 ( .A(n949), .B(n1023), .C(n381), .Y(n359) );
  CLKBUFX3 U1242 ( .A(n948), .Y(n1098) );
  OAI22XL U1243 ( .A0(n1096), .A1(n724), .B0(n1154), .B1(n742), .Y(n1011) );
  AOI222XL U1244 ( .A0(n726), .A1(n1195), .B0(n727), .B1(n1213), .C0(n743), 
        .C1(n729), .Y(n742) );
  OAI221XL U1245 ( .A0(n1095), .A1(n596), .B0(n1089), .B1(n595), .C0(n744), 
        .Y(n743) );
  OAI21XL U1246 ( .A0(n409), .A1(n410), .B0(n1081), .Y(n989) );
  OAI22XL U1247 ( .A0(n1090), .A1(n1188), .B0(n1089), .B1(n419), .Y(n411) );
  XOR2XL U1248 ( .A(n1224), .B(n838), .Y(n1013) );
  NOR2X1 U1249 ( .A(n851), .B(n839), .Y(n838) );
  AND2X2 U1250 ( .A(N137), .B(n1098), .Y(N147) );
  AND2X2 U1251 ( .A(N136), .B(n1098), .Y(N146) );
  AND2X2 U1252 ( .A(N135), .B(n1098), .Y(N145) );
  OAI32X1 U1253 ( .A0(n386), .A1(n949), .A2(n1023), .B0(n1098), .B1(n841), .Y(
        N40) );
  OA21XL U1254 ( .A0(n1024), .A1(n1160), .B0(n842), .Y(n841) );
  OAI222XL U1255 ( .A0(n391), .A1(n377), .B0(n392), .B1(n379), .C0(n873), .C1(
        n380), .Y(n987) );
  AOI221XL U1256 ( .A0(n381), .A1(n1215), .B0(n383), .B1(n1207), .C0(n398), 
        .Y(n391) );
  AOI221XL U1257 ( .A0(n381), .A1(n1218), .B0(n383), .B1(n1026), .C0(n395), 
        .Y(n392) );
  OAI22XL U1258 ( .A0(n1075), .A1(n386), .B0(n1093), .B1(n387), .Y(n398) );
  OAI222XL U1259 ( .A0(n399), .A1(n377), .B0(n400), .B1(n379), .C0(n872), .C1(
        n380), .Y(n988) );
  AOI221XL U1260 ( .A0(n381), .A1(n1020), .B0(n383), .B1(n1028), .C0(n408), 
        .Y(n399) );
  AOI221XL U1261 ( .A0(n381), .A1(n1212), .B0(n383), .B1(n1199), .C0(n404), 
        .Y(n400) );
  OAI22XL U1262 ( .A0(n1074), .A1(n386), .B0(n1097), .B1(n387), .Y(n408) );
  OAI222XL U1263 ( .A0(n376), .A1(n377), .B0(n378), .B1(n379), .C0(n874), .C1(
        n380), .Y(n986) );
  AOI221XL U1264 ( .A0(n381), .A1(n1205), .B0(n383), .B1(n1186), .C0(n390), 
        .Y(n376) );
  AOI221XL U1265 ( .A0(n381), .A1(n1203), .B0(n383), .B1(n1195), .C0(n385), 
        .Y(n378) );
  OAI22XL U1266 ( .A0(n1084), .A1(n386), .B0(n1096), .B1(n387), .Y(n390) );
  OAI22XL U1267 ( .A0(n1024), .A1(n386), .B0(n949), .B1(n842), .Y(N39) );
  NAND2X1 U1268 ( .A(n380), .B(n949), .Y(n377) );
  NOR2X2 U1269 ( .A(n1157), .B(n950), .Y(n383) );
  NAND2BX1 U1270 ( .AN(n850), .B(n1098), .Y(n839) );
  XOR2X1 U1271 ( .A(n850), .B(n1023), .Y(n1015) );
  XOR2X1 U1272 ( .A(n839), .B(n851), .Y(n1014) );
  AND2X2 U1273 ( .A(N128), .B(n1098), .Y(N138) );
  OAI33X1 U1274 ( .A0(n1030), .A1(state[0]), .A2(n359), .B0(n1031), .B1(
        state[1]), .B2(n361), .Y(n947) );
  OAI32X1 U1275 ( .A0(n1030), .A1(state[0]), .A2(n1160), .B0(state[1]), .B1(
        n1158), .Y(N587) );
  CLKINVX1 U1276 ( .A(n361), .Y(n1158) );
  NAND2X2 U1277 ( .A(n879), .B(n878), .Y(n362) );
  NAND2X1 U1278 ( .A(state[1]), .B(state[0]), .Y(N588) );
  XOR2X1 U1279 ( .A(n1226), .B(n852), .Y(n1129) );
  AO21X1 U1280 ( .A0(n857), .A1(n1101), .B0(number[1]), .Y(n1100) );
  NAND2X1 U1281 ( .A(number[2]), .B(n859), .Y(n1102) );
  NOR2X1 U1282 ( .A(n859), .B(number[2]), .Y(n1111) );
  NOR2BX1 U1283 ( .AN(n1102), .B(n1111), .Y(n1114) );
  OAI211X1 U1284 ( .A0(n1101), .A1(n857), .B0(n1100), .C0(n1114), .Y(n1103) );
  NAND3BX1 U1285 ( .AN(n1117), .B(n1103), .C(n1102), .Y(n1105) );
  NOR2X1 U1286 ( .A(n1122), .B(n1104), .Y(n1116) );
  AOI31X1 U1287 ( .A0(n1105), .A1(n1112), .A2(n1116), .B0(n1104), .Y(n1106) );
  NAND2BX1 U1288 ( .AN(n1108), .B(n1124), .Y(n1127) );
  AOI211X1 U1289 ( .A0(n1106), .A1(n1120), .B0(n1127), .C0(n1121), .Y(n1107)
         );
  OAI31XL U1290 ( .A0(n1128), .A1(n1108), .A2(n1107), .B0(n1125), .Y(n1109) );
  OAI22XL U1291 ( .A0(n1134), .A1(n1109), .B0(n1226), .B1(n852), .Y(n1110) );
  AO21X1 U1292 ( .A0(n1110), .A1(n1131), .B0(n1133), .Y(N87) );
  NOR2BX1 U1293 ( .AN(n1112), .B(n1111), .Y(n1119) );
  OAI21XL U1294 ( .A0(n857), .A1(n1113), .B0(number[1]), .Y(n1115) );
  AOI211X1 U1295 ( .A0(n1119), .A1(n1118), .B0(n1136), .C0(n1117), .Y(n1123)
         );
  OAI31XL U1296 ( .A0(n1123), .A1(n1122), .A2(n1121), .B0(n1120), .Y(n1126) );
  OAI211X1 U1297 ( .A0(n1127), .A1(n1126), .B0(n1125), .C0(n1124), .Y(n1130)
         );
endmodule

