module pckgen (
               input  SYSCLK,
               output PCK
               );

   wire               CLKFBOUT, iPCK, locked;
   BUFG iBUFG (.I(iPCK), .O(PCK));

   MMCME2_BASE #(
                 .CLKFBOUT_MULT_F(25.0),
                 .CLKIN1_PERIOD(8.0),
                 .CLKOUT0_DIVIDE_F(25.0),
                 .CLKOUT0_DUTY_CYCLE(0.5),
                 .CLKOUT0_PHASE(0.0),
                 .DIVCLK_DIVIDE(4)
                 )
   MMCME2_BASE_inst (
                     .CLKOUT0(iPCK),
                     .CLKFBOUT(CLKFBOUT),
                     .LOCKED(locked),
                     .CLKIN1(SYSCLK),
                     .CLKFBIN(CLKFBOUT)
                     );

endmodule // pckgen


   
