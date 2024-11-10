`timescale 1ns / 1ps

module uart
#(
    parameter Bits = 8
)
(
  input i_Clock,
  input i_reset,
  input tx_start,               // desde la interface le avisa que puede enviar el alu result
  input [Bits-1:0] intf_to_tx_result,      // el dato de la interface al tx que va a enviar
  input rx_data,                // entrada de rx 
  
  output rx_to_intf_done,    // el rx avisando que tiene un dato a la interfaz
  output [Bits-1:0]rx_to_intf_data,    // el rx pasando la data a la interfaz 
  output tx_to_intf_active,   // tx avisa si está activo 
  output tx_data,               // salida de tx con la data
  output tx_to_intf_done        // tx avisando que terminó
  
);

    wire bd;                // conecta baudrate generator con rx y tx         


  br_gen #() BR_GEN
   (.i_clock(i_Clock),
    .i_reset(i_reset),
    .o_tick(bd)
   );
   
  uart_rx #() UART_RX
    (.i_Clock(i_Clock),
     .i_reset(i_reset),
     .i_bd(bd),
     .o_Rx_Done(rx_to_intf_done),
     .o_Rx_Byte(rx_to_intf_data),
     .i_Rx_Serial(rx_data)
    );
    
  uart_tx #() UART_TX
    (.i_Clock(i_Clock),
    .i_reset(i_reset),
    .i_bd(bd),
    .i_Tx_Start(tx_start),
    .i_Tx_Byte(intf_to_tx_result),
    .o_Tx_Active(tx_to_intf_active),
    .o_Tx_Serial(tx_data),
    .o_Tx_Done(tx_to_intf_done)
    );
endmodule
