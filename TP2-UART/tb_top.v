`timescale 1ns / 1ps

module top_tb();

    localparam Bits = 8;
    localparam T = 40;
    
    integer counter = 0;
    
    reg             r_Clock = 0;
    reg             r_reset = 0;         
    reg             tx_start = 0;     
    reg [Bits-1:0] tb_tx_byte = 0;
    reg last_tx_active=1;
    
    wire tx_active;
    wire [Bits-1:0] resultado;
    wire tb_tx_serial;
    wire tb_rx_data;
    

    top #() TOP
    (
        .r_Clock(r_Clock),
        .r_reset(r_reset),
        .rx_data(tb_tx_serial),
        .tx_data(tb_rx_data)
    );
    
    uart #() UART_TB
    (
        .i_Clock(r_Clock),
        .i_reset(r_reset),
        .tx_start(tx_start),
        .intf_to_tx_result(tb_tx_byte),
        .rx_to_intf_done(),
        .rx_to_intf_data(resultado),
        .tx_to_intf_active(tx_active),
        .tx_data(tb_tx_serial),
        .tx_to_intf_done(),
        .rx_data(tb_rx_data)
    );

           // Clock generation 20 ns
   always begin
      r_Clock = 1'b1;
      #(T/2);
      r_Clock = 1'b0;
      #(T/2);
   end //end_always
   
   // Reset for the first half-cicle:
   initial begin
      r_reset = 1'b1;
      #(T/2);
      r_reset = 1'b0;
   end

always@(posedge r_Clock)
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
endmodule
