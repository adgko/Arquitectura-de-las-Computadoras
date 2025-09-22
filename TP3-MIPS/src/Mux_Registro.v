`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2021 15:14:36
// Design Name: 
// Module Name: Mux_Registro
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// 
//////////////////////////////////////////////////////////////////////////////////


module Mux_Registro
    #(
        parameter NBITS = 5
    )
    (
        input   wire                          i_RegDst      ,
        input   wire     [NBITS-1      :0]    i_rd          ,
        input   wire     [NBITS-1      :0]    i_rt          ,
        output  wire     [NBITS-1      :0]    o_Registro                 
    );
    
    reg [NBITS-1  :0]   to_Reg      ;
    assign  o_Registro   =   to_Reg ;
    
    always @(*)
    begin
        case(i_RegDst)
            1'b0:   to_Reg  <=  i_rt    ;   
            1'b1:   to_Reg  <=  i_rd    ;
        endcase
    end
endmodule
