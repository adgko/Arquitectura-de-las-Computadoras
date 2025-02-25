`timescale 1ns / 1ps

module top
	#( 
       parameter MAXTAM      = 8,
	   parameter TAM_OP        = 6
    )
	(
        input wire      i_clk,
        input wire      i_reset,
        input wire      i_rx_data,
        output wire     o_tx_data,
        output wire     o_tx_done
     );

wire [MAXTAM -1:0]   tx_byte;
wire [MAXTAM -1:0]   dataA;
wire [MAXTAM -1:0]   dataB;
wire [TAM_OP -1:0]     OP;
wire [MAXTAM -1:0]  rx_byte;
wire                    carry;
wire                    rx_done;
wire                    tx_start;
wire                    bd;

br_gen baud_generator   (.i_clk(i_clk),
                        .i_reset(i_reset),
                        .o_tick(bd));

uart_rx uart_rx                 (.i_clk(i_clk),
                                .i_reset(i_reset),
                                .i_Rx_Serial(i_rx_data),
                                .i_bd(bd),
                                .o_Rx_Done(rx_done),
                                .o_Rx_Byte(rx_byte));

uart_tx uart_tx                 (.i_clk(i_clk),
                                .i_reset(i_reset),
                                .i_Tx_Start(tx_start),
                                .i_bd(bd),
                                .i_Tx_Byte(tx_byte),
                                .o_Tx_Done(o_tx_done),
                                .o_Tx_Serial(o_tx_data));    


intfv interface             (.i_clk(i_clk),
                                .i_reset(i_reset),
                                .i_rx_done(rx_done),
                                .i_data(rx_byte),
                                .o_data_A(dataA ),
                                .o_data_B(dataB),
                                .o_data_OPCODE(OP),
                                .o_done(tx_start));

alu alu_instance                (.data_a(dataA),
                                .data_b(dataB),
                                .op(OP),
                                .o_alu_Result(tx_byte),
                                .o_carry(carry));

endmodule
