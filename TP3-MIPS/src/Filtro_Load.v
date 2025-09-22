`timescale 1ns / 1ps

`define	CERO    2'b00	// Palabra entera (32 bits)	LW
`define	CEROUNO 2'b01	// Byte (8 bits)	LB / LBU
`define	UNOCERO 2'b10	// Halfword (16 bits)	LH / LHU
`define	UNOUNO  2'b11	// Inválido o no implementado

module Filtro_Load
    #(
        parameter   NBITS           =   32  ,
        parameter   HWORDBITS       =   16  ,
        parameter   BYTENBITS       =   8   ,
        parameter   TNBITS          =   2   
    )
    (
        input   wire    [NBITS-1    :0]     i_Dato          ,
        input   wire    [TNBITS-1   :0]     i_Tamano        , // Selector de tamaño (2 bits): si es byte, half o word.
        input   wire                        i_Cero          , // Bandera que indica si se hace zero-extend (1) o sign-extend (0).
        output  wire    [NBITS-1    :0]     o_DatoEscribir            
    );
    
    reg [NBITS-1    :0] DatoEscribir_Reg            ;
    assign o_DatoEscribir =    DatoEscribir_Reg     ;
    
    always @(*)
    begin : Tamano
            case(i_Tamano)
                `CERO       : // Palabra Completa      
                                    DatoEscribir_Reg   <=   i_Dato                                                              ;
                `CEROUNO    : // Byte
                    case(i_Cero)
                        1'b0:      DatoEscribir_Reg   <=   {{HWORDBITS+BYTENBITS{i_Dato[BYTENBITS-1]}}, i_Dato[BYTENBITS-1:0]}  ; // LB
                        1'b1:      DatoEscribir_Reg   <=   i_Dato & 32'b00000000_00000000_00000000_11111111                    ;  // LBU    
                    endcase
                `UNOCERO    : // Halfword
                    case(i_Cero)
                        1'b0:      DatoEscribir_Reg   <=   {{HWORDBITS{i_Dato[HWORDBITS-1]}}, i_Dato[HWORDBITS-1:0]}              ; // LH
                        1'b1:      DatoEscribir_Reg   <=   i_Dato & 32'b00000000_00000000_11111111_11111111                    ; // LHU
                    endcase
                default     :   
                                    DatoEscribir_Reg   <=   -1                                                                  ;
            endcase
    end
endmodule
