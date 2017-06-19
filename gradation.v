module gradation(
                 input            CLK,
                 input            RST,
                 output reg [3:0] VGA_R,
                 output reg [3:0] VGA_G,
                 output reg [3:0] VGA_B,
                 output           VGA_HS,
                 output           VGA_VS 
                 );

`include "vga_param.vh"

   localparam HSIZE = 10'd64;
   localparam VSIZE = 10'd120;

   wire                           PCK;
   wire [9:0]                     HCNT, VCNT;

   syncgen syncgen(
                   .CLK (CLK),
                   .RST (RST),
                   .PCK (PCK),
                   .VGA_HS (VGA_HS),
                   .VGA_VS (VGA_VS),
                   .HCNT (HCNT),
                   .VCNT (VCNT)
                   );

   wire [9:0]                     HBLANK = HFRONT + HWIDTH + HBACK;
   wire [9:0]                     VBLANK = VFRONT + VWIDTH + VBACK;

   wire                           disp_enable = (VBLANK <= VCNT)
                                  && (HBLANK - 10'd1 <= HCNT)
                                  && (HCNT < HPERIOD - 10'd1);

   reg [5:0]                      ccnt;
   always @( posedge HCNT ) begin
      if ( !RST )
        ccnt <= 6'd0;
      else if (disp_enable)
        ccnt <= ccnt + 6'd1;
   end
   
   always @( posedge PCK ) begin
      if ( !RST )
        {VGA_R, VGA_G, VGA_B} <= 12'h000;
      else if ( disp_enable )
        case ((VCNT - VBLANK)/VSIZE)
          10'd0: {VGA_R, VGA_G, VGA_B} <= {3{ccnt[5:2]}};
          10'd1: {VGA_R, VGA_G, VGA_B} <= {ccnt[5:2], 4'd0, 4'd0};
          10'd2: {VGA_R, VGA_G, VGA_B} <= {4'd0, ccnt[5:2], 4'd0};
          10'd3: {VGA_R, VGA_G, VGA_B} <= {4'd0, 4'd0, ccnt[5:2]};
          default: {VGA_R, VGA_G, VGA_B} <= 12'h000;
        endcase // case ((VCNT - VBLANK)/VSIZE)
      else
        {VGA_R, VGA_G, VGA_B} <= 12'h000;
   end
endmodule // gradation
