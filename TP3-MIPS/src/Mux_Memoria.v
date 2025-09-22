`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2021 15:11:16
// Design Name: 
// Module Name: Mux_Memoria
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


module Mux_Memoria
    #(
        parameter NBITS = 32
    )
    (
        input   wire                          i_MemToReg    ,
        input   wire     [NBITS-1      :0]    i_MemDatos    , //Memoria de Datos -> Dato del Filtro -> Dato de LUI 
        input   wire     [NBITS-1      :0]    i_ALU         , //Dato de la ALU
        output  wire     [NBITS-1      :0]    o_Registro                 
    );
    
    reg [NBITS-1  :0]   to_Reg      ;
    assign  o_Registro   =   to_Reg ;
    
    always @(*)
    begin
        case(i_MemToReg)
            1'b0:   to_Reg  <=  i_ALU       ;   
            1'b1:   to_Reg  <=  i_MemDatos  ;
        endcase
    end 
endmodule
