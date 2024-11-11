`timescale 1ns / 1ps

module intfv
#(
    parameter DATA_SIZE=8,
    parameter OPCODE_SIZE=6,
    parameter DATA_A=3'b000,
    parameter DATA_B=3'b001,
    parameter DATA_OPCODE=3'b010,
    parameter SEND_START=3'b011,
    parameter SEND_BYTES=3'b100,
    parameter CLEAN=3'b101
)
(
    input wire i_Clock,
    input wire i_reset,
    input wire i_rx_done, // rx done desde rx uart
    input wire i_tx_active, // tx active desde tx uart
    input wire i_tx_done, // tx done desde tx uart
    input wire [DATA_SIZE-1:0] i_data, // rx output 
    input wire [DATA_SIZE-1:0] i_alu_result, //alu output
    output wire o_tx_start_bit,
    output wire [DATA_SIZE-1:0] o_alu_result,
    output wire [DATA_SIZE-1:0] o_data_A ,
    output wire [DATA_SIZE-1:0] o_data_B,
    output wire [OPCODE_SIZE-1:0] o_data_OPCODE
);

reg [2:0]    r_SM_Main     = 0;
reg [DATA_SIZE-1:0] r_data_A =0;
reg [DATA_SIZE-1:0] r_data_B =0;
reg [OPCODE_SIZE-1:0] r_data_OPCODE =0;
reg [DATA_SIZE-1:0] r_alu_result=0; 
reg r_tx_start_bit=0;
reg [3:0]     r_current_state = 0;
reg [3:0]     r_next_state = 0;
reg last_i_rx_done;
 
always @(posedge i_Clock)
    begin
        if(i_reset) 
            begin
                r_data_A <=0;
                r_data_B <=0;
                r_data_OPCODE <=0;
                r_current_state <= DATA_A;
                r_alu_result<=0;
                r_tx_start_bit<=0;
                r_next_state<=0;
            end
        else r_current_state<=r_next_state;
        
    end
     
    always @(*) begin
        case (r_current_state)
            DATA_A:
                begin
                    if(i_rx_done && ~last_i_rx_done )
                        begin
                            r_data_A=i_data;
                            r_next_state=DATA_B;
                        end
                end
            DATA_B:
                begin
                    if(i_rx_done && ~last_i_rx_done )
                        begin
                            r_next_state=DATA_OPCODE;
                            r_data_B=i_data;
                        end
                end
            DATA_OPCODE:
                begin
                    if(i_rx_done && ~last_i_rx_done )
                        begin
                            r_next_state=SEND_START;
                            r_data_OPCODE=i_data[OPCODE_SIZE-1:0];
                        end
                end
            SEND_START:
                begin
                    r_tx_start_bit=1;
                    if(i_tx_active)
                        begin
                            r_next_state=SEND_BYTES;     
                        end
                end
            SEND_BYTES:
                begin
                    r_alu_result=i_alu_result;
                    if(i_tx_active)
                        begin
                            r_tx_start_bit=0;  
                        end
                    if(i_tx_done)
                    begin   
                        r_next_state=CLEAN;
                    end
                end
            CLEAN:
                begin
                    r_data_A =0;
                    r_data_B =0;
                    r_data_OPCODE =0;
                    r_alu_result=0;
                    r_tx_start_bit=0;
                    r_next_state= DATA_A;
                end
            default: 
                begin
                    r_alu_result= 0;
                    r_data_A =0;
                    r_data_B =0;
                    r_data_OPCODE =0;
                    r_tx_start_bit=0;
                    r_next_state= DATA_A;
                end
        endcase
        last_i_rx_done = i_rx_done;
    end
    
    assign o_data_A=r_data_A;
    assign o_data_B=r_data_B;
    assign o_data_OPCODE=r_data_OPCODE;
    assign o_alu_result=r_alu_result;
    assign o_tx_start_bit=r_tx_start_bit;
endmodule
