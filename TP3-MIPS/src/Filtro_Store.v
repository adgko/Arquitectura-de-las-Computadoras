`timescale 1ns / 1ps

//Implementación de Filtro
//00: palabra entera
//01: SB -> para un byte
//10: SH -> para media palabra
`define	CERO    2'b00	// SW (store word)
`define	CEROUNO 2'b01	// SB (store byte)
`define	UNOCERO 2'b10	// SH (store halfword)
`define	UNOUNO  2'b11	// no definido / valor inválido

module Filtro_Store
    #(
        parameter   NBITS           =   32  ,
        parameter   TNBITS          =   2   
    )
    (
        input   wire    [NBITS-1    :0]     i_Dato          ,
        input   wire    [TNBITS-1   :0]     i_Tamano        ,	// Tipo de escritura: SW, SB, SH, codificado como 2 bits.
        output  wire    [NBITS-1    :0]     o_DatoEscribir         // Dato filtrado (enmascarado según el tamaño) que se enviará a memoria.   
    );
    
    reg [NBITS-1    :0] DatoEscribir_Reg            ;
    assign o_DatoEscribir =    DatoEscribir_Reg     ;
    
    always @(*)
    begin : Tamano
            case(i_Tamano)
                `CERO       :       
                                    DatoEscribir_Reg   <=   i_Dato                                              ;
                `CEROUNO    :        
                                    DatoEscribir_Reg   <=   i_Dato & 32'b00000000_00000000_00000000_11111111    ;
                `UNOCERO    :
                                    DatoEscribir_Reg   <=   i_Dato & 32'b00000000_00000000_11111111_11111111    ;
                default     :   
                                    DatoEscribir_Reg   <=   -1                                                  ;
            endcase
    end
endmodule
