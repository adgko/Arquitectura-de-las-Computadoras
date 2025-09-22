`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2021 14:22:07
// Design Name: 
// Module Name: signal_extension
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

module Extensor_Signo
    #(
        parameter i_NBITS = 16  ,
        parameter e_NBITS = 16  ,
        parameter o_NBITS = 32
    )
    (
        input   wire    [i_NBITS-1  :0]     i_signal        ,
        input   wire    [1          :0]     i_ExtensionMode ,
        output  wire    [o_NBITS-1  :0]     o_ext_signal
    );
    
    reg     [o_NBITS-1:0] result_ext_reg;
                
    assign o_ext_signal = result_ext_reg;
    
    always @(*)
        begin : extension
            case(i_ExtensionMode)
                2'b00:      result_ext_reg  <=  {{e_NBITS{i_signal[i_NBITS-1]}}, i_signal}  ;//1010 1010 1010 1010 -> 1111 1111 1111 1111 1010 1010 1010 1010 Instrucciones tipo I como addi, lw, sw
                2'b01:      result_ext_reg  <=  {{e_NBITS{1'b0}}, i_signal}                 ;//1010 1010 1010 1010 -> 0000 0000 0000 0000 1010 1010 1010 1010 Instrucciones lógicas tipo I como andi, ori	
                2'b10:      result_ext_reg  <=  {i_signal,{e_NBITS{1'b0}}}                  ;//1010 1010 1010 1010 -> 1010 1010 1010 1010 0000 0000 0000 0000  Instrucción lui 
                default:    result_ext_reg  <= -1                                           ;
            endcase
        end
endmodule
