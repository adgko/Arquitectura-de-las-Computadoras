`timescale 1ns / 1ps

module br_gen
#(
    parameter CLOCK_FREQUENCY   = 50E6,  // 25 [MHz]
    parameter BAUD_RATE         = 19200
)
(
    input   wire    i_clock,
    input   wire    i_reset,
    output  wire    o_tick
);

   localparam TICK_RATE     = CLOCK_FREQUENCY / ( 16 * BAUD_RATE ); // 81.7
   localparam COUNT_NBITS   = $clog2( TICK_RATE );  // 7

   reg  [COUNT_NBITS-1:0]   counter;

   assign o_tick = ~(|counter);

   always @( posedge i_clock ) begin
      if(i_reset || o_tick)
        counter <= TICK_RATE-1;
      else
        counter <= counter - 1;
   end

endmodule
