`timescale 1ns / 1ps

module top_tb#()(
    input i_clock
   // output [Bits-1:0] LED
    //output LED2
);

    localparam Bits = 8;
    localparam T = 40;
    
    integer counter = 0;
    
    reg             r_Clock ;
    reg             r_Clock50  ;
    reg             r_reset;         
    reg             tx_start ;     
    reg [Bits-1:0] tb_tx_byte ;
    reg last_tx_active=1;
    
    wire tx_active;
    wire [Bits-1:0] resultado;
    wire tb_tx_serial;
    wire tb_rx_data;
    wire o_clock;
    wire o_clock50;
    wire o_reset;
    wire o_tx_start;
    wire [Bits-1:0] o_tb_tx_byte;
    

    top #() TOP
    (
        .i_clock(o_clock),
        .r_reset(o_reset),
        .rx_data(tb_tx_serial),
        .tx_data(tb_rx_data)
    );
    
    uart #() UART_TB
    (
        .i_Clock(o_clock50),
        .i_reset(o_reset),
        .tx_start(o_tx_start),
        .intf_to_tx_result(o_tb_tx_byte),
        .rx_to_intf_done(),
        .rx_to_intf_data(resultado),
        .tx_to_intf_active(tx_active),
        .tx_data(tb_tx_serial),
        .tx_to_intf_done(),
        .rx_data(tb_rx_data)
    );
    

       
   // Reset for the first half-cicle:
   initial begin
      r_reset = 1'b1;
      #(T/2);
      r_reset = 1'b0;
   end


           // Clock generation 20 ns
always #5 r_Clock=~r_Clock;

always #10 r_Clock50=~r_Clock50;





always@(posedge o_clock50)
begin
    if(~tx_active && last_tx_active && counter<3)
    begin
       
        case(counter)
            0:
                begin 
                    tb_tx_byte <= 22;
                end
            1:
                begin 
                    tb_tx_byte <= 18;
                end
            2:
                begin 
                    tb_tx_byte <= 8'b0010_0000;
                end
            default:
                begin 
                    tx_start <= 1'b0;       
                end
         endcase
         tx_start <= 1'b1;         
         counter<=counter+1;
    end
    else tx_start <= 1'b0;
    last_tx_active<=tx_active;
end 
assign o_clock= r_Clock;
assign o_clock50 =r_Clock50;
assign o_tx_start =tx_start;
assign o_tb_tx_byte=tb_tx_byte;
assign o_reset = r_reset;
endmodule
