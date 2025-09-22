`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2022 11:17:30 PM
// Design Name: 
// Module Name: WB_Mux_EscribirDato
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


module WB_Mux_RegistroDestino
    #(
        parameter REGS        = 5
    )
    (
        input   wire                          i_JAL         ,
        input   wire     [REGS-1       :0]    i_RD          ,
        output  wire     [REGS-1       :0]    o_RD                 
    );

    reg [REGS-1  :0]   to_RD      ;
    assign  o_RD   =   to_RD ;

    always @(*)
    begin
        case(i_JAL)
            1'b0:   to_RD  <=  i_RD;   
            1'b1:   to_RD  <=  5'b11111      ; //En JAL se debe guardar el PC+8 en el registro 31, que es donde se guardó la dirección de retorno
        endcase
    end 
endmodule
