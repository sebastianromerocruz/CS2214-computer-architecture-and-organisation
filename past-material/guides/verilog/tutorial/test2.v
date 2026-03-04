module test(A, B, C, D, E);
   
   output D, E;
   input  A, B, C;
   wire   w1;

   assign w1 = A & B;
   assign E = ~C;
   assign D = w1 | E;

endmodule