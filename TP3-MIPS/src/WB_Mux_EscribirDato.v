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


module WB_Mux_EscribirDato
    #(
        parameter NBITS = 32
    )
    (
        input   wire                          i_JAL         ,
        input   wire     [NBITS-1      :0]    i_MemDatos    ,
        input   wire     [NBITS-1      :0]    i_PC_8        ,
        output  wire     [NBITS-1      :0]    o_Registro                 
    );

    reg [NBITS-1  :0]   to_Reg      ;
    assign  o_Registro   =   to_Reg ;

    always @(*)
    begin
        case(i_JAL)
            1'b0:   to_Reg  <=  i_MemDatos  ;   // Valor normal (de Memoria)
            1'b1:   to_Reg  <=  i_PC_8      ;   // En JAL, guardamos PC + 8
        endcase
    end 
endmodule
