module br_gen 
#(
    parameter COUNT_NBITS  = 10, 
    parameter TICK_RATE  = 651 // FR_CLOCK_HZ / (BAUDRATE * 16) =>  100MHz /(9600*16)
) 
(
    input wire i_clk,
    input wire i_reset,
    output wire o_tick
 );
    
    reg [COUNT_NBITS-1 : 0] counter;
    
    always @(posedge i_clk) begin
        if(i_reset)begin
            counter     <= 0;
        end
        else if(counter < TICK_RATE)
            counter     <= counter + 1;
        else
            counter     <= 0;
    end
    
    
    assign o_tick= ( counter==TICK_RATE )? 1'b1 : 1'b0;
        
endmodule
    