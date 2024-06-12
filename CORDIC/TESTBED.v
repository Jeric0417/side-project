//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
// Copyright (c) 2024, DSP
// MODULE    : TESTBED
// FILE NAME : TESTBED.v
// VERSRION  : 1.0
// DATE      : May. 2, 2024
// Author    : CHAN-HAO LIAO (jericc880417@gmail.com)
// CODE TYPE : RTL or Behavioral Level (Verilog)
//
//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

`timescale 1ns/1ps

module TESTBED();

wire clk;
wire rst_n;
wire in_valid;
wire out_valid;

parameter matrix_integer = 8 ;
parameter decimal_point  = 3 ;

wire [matrix_integer -1 : 0] matrix_0, matrix_1, matrix_2, matrix_3;
wire [matrix_integer + decimal_point : 0] out_matrix;


initial
begin
    // `ifdef RTL
    $fsdbDumpfile("CORDIC.fsdb");
    $fsdbDumpvars(0, "+mda");
    // `endif
`ifdef GATE

    $sdf_annotate("CORDIC_syn.sdf", I_qr_cordic);
    $fsdbDumpfile("CORDIC_syn.fsdb");
    $fsdbDumpvars(0, "+mda");

`endif
end

CORDIC I_qr_cordic
          (
              // Input signals
              .clk(clk),
              .rst_n(rst_n),
              .in_valid(in_valid),
              .matrix_0(matrix_0),
              .matrix_1(matrix_1),
              .matrix_2(matrix_2),
              .matrix_3(matrix_3),

              // Output signals
              .out_valid(out_valid),
              .out_matrix(out_matrix)

          );

PATTERN I_PATTERN
        (
            // Output signals
            .clk(clk),
            .rst_n(rst_n),
            .in_valid(in_valid),
            .matrix_0(matrix_0),
            .matrix_1(matrix_1),
            .matrix_2(matrix_2),
            .matrix_3(matrix_3),

            // Input signals
            .out_valid(out_valid),
            .out_matrix(out_matrix)
        );

endmodule
