`timescale 1ns / 1ps

module Mux_LUI // Load Upper Immediate
    #(
        parameter NBITS = 32
    )
    (
        input   wire                          i_LUI         ,	// Flag de control. Si está en 1, se trata de una instrucción LUI.
        input   wire     [NBITS-1      :0]    i_FilterLoad  ,	// Resultado de una carga desde memoria, pasado por el filtro Filtro_Load.
        input   wire     [NBITS-1      :0]    i_Extension   ,	// El inmediato extendido a 32 bits (probablemente con ceros en los bits bajos para LUI).
        output  wire     [NBITS-1      :0]    o_Registro                 
    );
    
    reg [NBITS-1  :0]   to_Reg      ;
    assign  o_Registro   =   to_Reg ;
    
    always @(*)
    begin
        case(i_LUI)
            1'b0:   to_Reg  <=  i_FilterLoad    ;   // resultado de carga
            1'b1:   to_Reg  <=  i_Extension     ;   // resultado de LUI
        endcase
    end
    
endmodule
