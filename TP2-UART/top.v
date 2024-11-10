`timescale 1ns / 1ps

module top
#(
    parameter Bits = 8,
    parameter opcode = 6
)
(
    input r_Clock,
    input r_reset,              
    input rx_data,   
    
    output tx_data               // salida de tx con la data
   // output [Bits-1:0] LED
    //output LED2
);

  
    wire [Bits-1:0] intf_to_tx_result;          // el dato de la interface al tx que va a enviar
    wire intf_to_tx_start;           // desde la interface le avisa que puede enviar el alu result 
    wire rx_to_intf_done;            // el rx avisando que tiene un dato a la interfaz
    wire [Bits-1:0] rx_to_intf_data; // el rx pasando la data a la interfaz 
    wire tx_to_intf_active;          // tx avisa si está activo
    wire tx_to_intf_done;            // tx avisando que terminó
    
    wire [Bits-1:0] intf_data_A;  
    wire [Bits-1:0] intf_data_B;
    wire [opcode-1:0] intf_data_OPCODE;
    wire [Bits-1:0] alu_result_to_intf;
    
    wire clk_100;
    wire clk_50;
    wire locked;
    
    //assign led=rx_to_intf_data;
    //assign led2=rx_data;
      
                 
    //assign LED = rx_to_intf_data;
    //assign LED2 = rx_to_intf_done;
    
    clk_wiz_0 instance_name
   (
    // Clock out ports
    .clk_out1(clk_100),     // output clk_out1
    .clk_out2(clk_50),     // output clk_out2
    // Status and control signals
    .reset(r_reset), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(r_Clock)
    );      // input clk_in1
// INST_TAG_END ------ End INSTANTIATION Template ---------
      
  
  uart #() UART
  (
    .i_Clock(clk_50),
    .i_reset(r_reset),
    .tx_start(intf_to_tx_start),
    .intf_to_tx_result(intf_to_tx_result),
    .rx_to_intf_done(rx_to_intf_done),
    .rx_to_intf_data(rx_to_intf_data),
    .tx_to_intf_active(tx_to_intf_active),
    .tx_data(tx_data),
    .tx_to_intf_done(tx_to_intf_done),
    .rx_data(rx_data)
  );
    
     intfv #() INTERFACE
    (
        .i_clk(clk_50),
        .i_reset(r_reset),
        .o_tx_start_bit(intf_to_tx_start),
        .o_alu_result(intf_to_tx_result),
        .i_tx_active(tx_to_intf_active),
        .i_tx_done(tx_to_intf_done),
        .i_rx_done(rx_to_intf_done),
        .i_data(rx_to_intf_data),
        .o_data_A(intf_data_A),
        .o_data_B(intf_data_B),
        .o_data_OPCODE(intf_data_OPCODE),
        .i_alu_result(alu_result_to_intf)
    );
    
          alu #() alu_intf_tb
    (
        .A(intf_data_A),
        .B(intf_data_B),
        .OP(intf_data_OPCODE),
        .ALU_Result(alu_result_to_intf)
    );
endmodule

