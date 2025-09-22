`timescale 1ns / 1ps

module Sumador_PC_Jump
    #(
        parameter NBITS     =  32,
        parameter NBITSJUMP =  26
    )
    (
        input   wire    [NBITSJUMP-1    :0]     i_IJump         ,
        input   wire    [NBITS-1        :0]     i_PC4           ,
        output  wire    [NBITS-1        :0]     o_IJump                 
    );
    
    reg [NBITS-1  :0]   IJump_reg   ;    
    assign  o_IJump   = IJump_reg   ;
    
    always @(*)
    begin
        IJump_reg   <=  {i_PC4[NBITS-1:27], (i_IJump<<2)}  ;    // la dirección está en los 26 bits de de dato, y se le concatenan los bits más significativos de PC para hacer 32 bits
    end   
    
endmodule
