`timescale 1ns / 1ps

module Mux_ALU_Shamt
    #(
        parameter NBITS         = 32,
        parameter CORTOCIRCUITO = 3
    )
    (
        input   wire  [CORTOCIRCUITO-1  :0] i_EX_UnidadCortocircuito   ,
        input   wire  [NBITS-1          :0] i_ID_EX_Registro            ,
        input   wire  [NBITS-1          :0] i_EX_MEM_Registro           ,
        input   wire  [NBITS-1          :0] i_MEM_WR_Registro           ,
        output  wire  [NBITS-1          :0] o_toALU                 
    );
    
    reg [NBITS-1  :0]   to_ALU;
    assign o_toALU =    to_ALU;
    
    always @(*)
    begin
        case(i_EX_UnidadCortocircuito)
            3'b001:      to_ALU  <=  i_EX_MEM_Registro   ; 	// Hay una instrucción previa que ya calculó el resultado, pero aún no ha llegado a WB.
            3'b010:      to_ALU  <=  i_MEM_WR_Registro   ; 	// El resultado ya está listo para escribirse en el banco de registros.
            default :   to_ALU  <=  i_ID_EX_Registro    ;	// No hay riesgo, se usa el valor original leído del registro.
        endcase
       end
          
endmodule
