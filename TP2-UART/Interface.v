`timescale 1ns / 1ps

module intfv
#(  parameter   MAXTAM = 8,
    parameter   TAM_OP = 6,
    parameter   TAM_COUNTER = 5,
    parameter   TAM_TOTAL = 24

    )
(   input wire                      i_clk,
    input wire                      i_reset,
    input wire                      i_rx_done,
    input  wire [(MAXTAM-1):0]  i_data,
    output wire [(MAXTAM-1):0]   o_data_A,
    output wire [(MAXTAM-1):0]   o_data_B,
    output wire [(TAM_OP-1):0]     o_data_OPCODE, 
    output wire                     o_done
 );
     
localparam dataA_Init    = 0;
localparam dataA_Final   = MAXTAM - 1;
 
localparam dataB_Init    = dataA_Final + 1 ;
localparam dataB_Final   = dataB_Init + MAXTAM - 1 ;

localparam OP_Init       = dataB_Final + 1;
localparam OP_Final      = OP_Init + TAM_OP - 1;


//variables locales 
reg [MAXTAM-1:0]     r_data_A, r_data_B;
reg [TAM_OP:0]         r_data_OPCODE;
reg [TAM_COUNTER-1:0]  counter;
reg [TAM_TOTAL-1:0]    buffer; //[OP] [B] [A]
reg done;

always @(posedge i_clk) begin 
	if(i_reset) begin  
		counter <= 0;
		done    <= 0;
	end
	else begin
		if(i_rx_done) begin
			buffer  <= {i_data,buffer[TAM_TOTAL-1:MAXTAM]};
			counter <= counter + MAXTAM ;
		end
		if(counter  >= TAM_TOTAL ) begin
			counter <= 0;
			r_data_A   <= buffer[dataA_Final:dataA_Init];
			r_data_B   <= buffer[dataB_Final:dataB_Init];
			r_data_OPCODE      <= buffer[OP_Final:OP_Init];
			done    <= 1;
		end
		else
		  done      <= 0;
    end
end

assign o_done   = done;
assign o_data_A  = r_data_A;
assign o_data_B  = r_data_B;
assign o_data_OPCODE     = r_data_OPCODE;

endmodule 