`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/01/2023 03:02:23 PM
// Design Name:
// Module Name: TOP
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module TOP
    #(
        parameter NBITS             = 32,
        parameter DATA_BITS         = 8,
        parameter REGS              = 5,
        parameter CLK_FREQ          = 50000000,
        parameter BAUD_RATE         = 9600,
        parameter RX_DIV_SAMP       = 16,
        parameter CELDAS_MEM_DATOS  = 16,
        parameter CELDAS_MEM_INSTR  = 256,
        parameter CELDAS_REGISTROS  = 32
    )
    (
        input   wire                                basys_clk    ,
        input   wire                                basys_reset  ,
        input   wire                                i_uart_rx,
        input   wire                                i_btn_tx,
        output  wire                                o_uart_tx,
        output  wire        [        3  :0]         o_d_unit_state_debug
    );

    localparam  MEM_INSTR_SIZE = $clog2(CELDAS_MEM_INSTR);
    localparam  MEM_REGS_SIZE  = $clog2(CELDAS_REGISTROS);

    wire                                clk_wz;

    reg     [        NBITS-1:    0]     mips_clk_count;
    wire    [        NBITS-1:    0]     mips_pc;

    wire    [                  NBITS-1:    0]     mips_reg_debug;
    wire    [          MEM_REGS_SIZE-1:    0]     mips_sel_reg_debug;

    wire    [                  NBITS-1:    0]     mips_mem_debug;
    wire    [                  NBITS-1:    0]     mips_sel_mem_debug;

    wire    [         MEM_INSTR_SIZE-1:    0]     mips_sel_mem_ins_debug;
    wire    [                  NBITS-1:    0]     mips_dato_mem_ins_debug;
    wire                                          mips_write_mem_ins_debug;

    wire                                uart_rx_data_ready;

    wire                                uart_tx_start;
    wire    [   DATA_BITS-1:    0]      uart_tx_data;
    wire                                uart_tx_done;


    wire                                mips_clk_ctrl;
    wire                                mips_reset_ctrl;
    wire                                mips_halt;

    wire    [   DATA_BITS-1:    0]      uart_rx_data;
    wire                                uart_rx_reset;

    assign o_uart_rx_data_debug = uart_rx_data;

   clk_wiz_0 clk_wiz
   (
    // Clock out ports
    .clk_out1(clk_wz),     // output clk_out25MHz
    // Status and control signals
    .reset(basys_reset), // input reset
    .locked(locked),       // output locked
    .clk_in1(basys_clk)
    );      // input clk_in1

    MIPS #(
        .NBITS          (NBITS),
        .CELDAS_REG     (CELDAS_REGISTROS),
        .CELDAS_M       (CELDAS_MEM_DATOS),
        .CELDAS_I       (CELDAS_MEM_INSTR),
        .REGS           (REGS)
    )
    u_MIPS
    (
        .clk                            (clk_wz                     ),
        .reset                          (basys_reset                ),
        .i_mips_clk_ctrl                (mips_clk_ctrl              ),
        .i_mips_reset_ctrl              (mips_reset_ctrl            ),
        .i_mips_reg_debug               (mips_sel_reg_debug         ),
        .i_mips_mem_debug               (mips_sel_mem_debug         ),
        .i_mips_mem_ins_direc_debug     (mips_sel_mem_ins_debug     ),
        .i_mips_mem_ins_dato_debug      (mips_dato_mem_ins_debug    ),
        .i_mips_mem_ins_write_debug     (mips_write_mem_ins_debug   ),
        .o_mips_pc                      (mips_pc                    ),
        .o_mips_reg_debug               (mips_reg_debug             ),
        .o_mips_mem_debug               (mips_mem_debug             ),
        .mips_halt                      (mips_halt                  )
    );

    UART_tx_interface #(
        .CLK_FREQ   (CLK_FREQ   ),
        .BAUD_RATE  (BAUD_RATE  ),
        .DATA_BITS  (DATA_BITS  )
    )
    u_UART_tx_interface (
        .clk                    (clk_wz         ),
        .reset                  (basys_reset    ),
        .i_ready                (uart_tx_start  ),
        .i_data                 (uart_tx_data   ),
        .o_uart_tx              (o_uart_tx      ),
        .o_uart_tx_done         (uart_tx_done   )
    );

    UART_rx_interface #(
        .CLK_FREQ   (CLK_FREQ   ),
        .BAUD_RATE  (BAUD_RATE  ),
        .DIV_SAMPLE (RX_DIV_SAMP),
        .DATA_BITS  (DATA_BITS  )
    )
    u_UART_rx_interface
    (
        .clk                (clk_wz             ),
        .reset              (uart_rx_reset      ),
        .i_uart_rx          (i_uart_rx          ),
        .o_ready            (uart_rx_data_ready ),
        .o_data             (uart_rx_data       )
    );

    MIPS_Unidad_Debug #(
        .DATA_BITS  (DATA_BITS),
        .NBITS      (NBITS    )
    )
    u_MIPS_Unidad_Debug
    (
        .clk                (clk_wz                     ),
        .reset              (basys_reset                ),
        .i_uart_rx_ready    (uart_rx_data_ready         ),
        .i_uart_rx_data     (uart_rx_data               ),
        .i_uart_tx_done     (uart_tx_done               ),
        .i_mips_halt        (mips_halt                  ),
        .i_mips_clk_count   (mips_clk_count             ),
        .i_mips_pc          (mips_pc                    ),
        .i_mips_reg         (mips_reg_debug             ),
        .i_mips_mem         (mips_mem_debug             ),
        .o_uart_rx_reset    (uart_rx_reset              ),
        .o_uart_tx_data     (uart_tx_data               ),
        .o_uart_tx_ready    (uart_tx_start              ),
        .o_mips_clk_ctrl    (mips_clk_ctrl              ),
        .o_mips_reset_ctrl  (mips_reset_ctrl            ),
        .o_mips_reg         (mips_sel_reg_debug         ),
        .o_mips_mem         (mips_sel_mem_debug         ),
        .o_mips_instr_sel   (mips_sel_mem_ins_debug     ),
        .o_mips_instr_dato  (mips_dato_mem_ins_debug    ),
        .o_mips_instr_write (mips_write_mem_ins_debug   ),
        .o_debug            (o_d_unit_state_debug       )
     );

    always @(posedge clk_wz)
        begin
            if(basys_reset) begin
                mips_clk_count = 0;
            end else if (mips_clk_ctrl) begin
                mips_clk_count = mips_clk_count + 1;
            end
        end

endmodule