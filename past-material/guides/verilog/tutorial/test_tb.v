`timescale 1ns/100ps
`include "test.v"

module test_tb;

   wire A, B, C, D, E;
   integer k=0;

   assign {A,B,C} = k;
   test the_circuit(A, B, C, D, E);

   initial begin

      $dumpfile("test.vcd");
      $dumpvars(0, the_circuit);

      for (k=0; k<8; k=k+1)
        #10 $display("A=",A," B=",B," C=",C," D=",D," E=",E);

      $finish;

   end

endmodule