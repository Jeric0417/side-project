//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   2024 DSP
//   HW4       : CORDIC
//   Author    : CHAN-HAO LIAO (jericc880417@gmail.com)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : PATTERN.v
//   Module Name : PATTERN
//   Release version : v1.0
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################
`define CYCLE_TIME 20.0

module PATTERN(
           // Output signals
           clk,
           rst_n,
           in_valid,
           matrix_0,
           matrix_1,
           matrix_2,
           matrix_3,
           // Input signals
           out_matrix,
           out_valid
       );

//================================================================
//   INPUT AND OUTPUT DECLARATION
//================================================================
parameter matrix_integer = 8 ;
parameter decimal_point  = 3 ;

output reg clk, rst_n, in_valid;
output reg signed[matrix_integer + decimal_point : 0] matrix_0, matrix_1, matrix_2, matrix_3;

input    out_valid;
input    signed [matrix_integer+decimal_point : 0] out_matrix;
// input [11:0]   out_Q;

//================================================================
//   CLOCK
//================================================================
real CYCLE = `CYCLE_TIME;
initial
begin
    clk = 0;
end
always #(CYCLE/2.0) clk = ~clk;

//================================================================
//   FILE
//================================================================
integer fin,fout,in_hold,out_hold;
integer patcount,PATNUM,total_latency;
integer wait_val_time;
integer i,j,iii,jjj;

//================================================================
//   GOLD
//================================================================
reg[11:0] goldas;
reg [11:0] goldset[0:31];
reg signed [11:0]dif [0:31];
//================================================================
//   pattern
//================================================================
initial
begin
    //+++++++++++++++++++++++++++++++++++++++++++++++++++
    fin=$fopen("/home/lab911_1/Desktop/7112064131/DSP/input.txt","r");
    fout=$fopen("/home/lab911_1/Desktop/7112064131/DSP/output.txt","r");
    in_hold=$fscanf(fin,"%d",PATNUM);
    //+++++++++++++++++++++++++++++++++++++++++++++++++++

    rst_n=1'b1;
    in_valid=1'b0;
    matrix_0='dx;
    matrix_1='dx;
    matrix_2='dx;
    matrix_3='dx;
    force clk = 0;
    total_latency = 0;
    reset_signal_task;

    repeat(1)@(negedge clk);

    for(patcount=1; patcount<=PATNUM; patcount=patcount+1)
    begin
        input_task;
        wait_out_valid;
        check_ans;

        // $display("\033[0;34mPASS PATTERN NO.%4d,\033[m \033[0;32mexecution cycle : %3d deg=%d,poly=%d  \033[m",patcount ,wait_val_time,savedeg,savepoly);

        repeat(1)@(negedge clk);

    end
    YOU_PASS_task;
    $finish ;
end

//================================================================
// task
//================================================================
task reset_signal_task;
    begin
        #(0.5);
        rst_n=0;
        #(2.0);
        if((out_valid !== 0)||(out_matrix !== 0))
        begin
            $display("**************************************************************");
            $display("*   Output signal should be 0 after initial RESET at %4t     *",$time);
            $display("**************************************************************");
            $finish;
        end
        #(10);
        rst_n=1;
        #(3);
        release clk;
    end
endtask


task input_task;
    begin
        in_valid=1'b1;
        for(integer i=0;i < 32;i=i+1)
        begin
            in_hold=$fscanf(fin,"%d %d %d %d",matrix_0, matrix_1, matrix_2, matrix_3);
            @(negedge clk);
        end
        in_valid=1'b0;
        matrix_0='dx;
        matrix_1='dx;
        matrix_2='dx;
        matrix_3='dx;
    end
endtask


task wait_out_valid;
    begin
        wait_val_time = -1;
        while(out_valid !== 1)
        begin
            wait_val_time = wait_val_time + 1;
            if(wait_val_time == 300)
            begin
                $display("***************************************************************");
                $display("*         The execution latency are over 300 cycles.         *");
                $display("***************************************************************");
                #(5);
                $finish;
            end
            @(negedge clk);
        end
    end
endtask

task check_ans ;
    begin
        for(iii=0;iii<31;iii=iii+1)
        begin
            if(out_valid!==1)
            begin
                $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
                $display ("                                                                        FAIL!                                                               ");
                $display ("                                                                   Pattern NO.%03d                                                     ", patcount);
                $display ("                                                    out_valid should be high during output                                        ");
                $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
                #(2.0);
                $finish;
            end

            out_hold=$fscanf(fout,"%b",goldas);
            goldset[iii]=goldas;
            if(out_matrix < goldset[iii])
                dif[iii] = goldset[iii] - out_matrix;
            else
                 dif[iii] = out_matrix - goldset[iii];
            if(dif[iii] >=5)
            begin
                $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
                $display ("                                                                        FAIL!                                                               ");
                $display ("                                                                   Pattern NO.%03d                                                     ", patcount);
                $display ("                                     %d    Golden  =%b\t|Your =%b  \t                                         ",iii,goldas,out_matrix);
                $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
                #(2.0);
                 $finish;
            end
            else begin
                $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
                $display ("                                                                        CORRECT!                                                               ");
                $display ("                                                                   Pattern NO.%03d                                                     ", patcount);
                $display ("                                     %d    Golden  =%b\t|Your =%b  \t                                         ",iii,goldas,out_matrix);
                $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
                #(2.0);
                 // $finish;
            end

            @(negedge clk);
        end

        if(out_valid!==0)
        begin
            $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
            $display ("                                                                        FAIL!                                                               ");
            $display ("                                                                   Pattern NO.%03d                                                     ", patcount);
            $display ("                                                    out_valid should be low after output                                         ");
            $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
            #(2.0);
            $finish;
        end

        total_latency=total_latency+wait_val_time;

    end
endtask

task YOU_PASS_task;
    begin
        $display ("--------------------------------------------------------------------");
        $display ("          ~( ˘ω˘ )~(๑╹ᆺ╹)~(｡•ᴗ•｡)~(๑╹ᆺ╹)~(*´꒳`*)ﾟ*.・              ");
        $display ("                         Congratulations!                           ");
        $display("        ----------------------------               ");
        $display("        --                        --       |\__/|  ");
        $display("        --  Congratulations !!    --      / O.O  | ");
        $display("        --                        --    /_____   | ");
        $display("        --  \033[0;32mSimulation PASS!!\033[m     --   /^ ^ ^ \\  |");
        $display("        --                        --  |^ ^ ^ ^ |w| ");
        $display("        ----------------------------   \\m___m__|_|");
        $display ("                  You have passed all patterns!                     ");
        $display ("                 Total Cycle = %d  ",total_latency);
        $display ("                 Total Time = %d  ",total_latency*CYCLE);
        $display ("--------------------------------------------------------------------");
        #(5);
        $finish;
    end
endtask



endmodule
