`timescale 1ns / 1ps
module AND_Branch
    #(
        parameter NBITS = 32
    )
    (
        input   wire    i_Branch    ,	// Señal de control que indica si es una instrucción del tipo BEQ (branch si igual)
        input   wire    i_NBranch   ,	// Señal de control que indica si es una instrucción del tipo BNE (branch si no igual)
        input   wire    i_Cero      ,	// Salida de la ALU que indica si los operandos fueron iguales (para BEQ) o distintos (para BNE)
        output  wire    o_PCSrc       // Señal que indica si se debe tomar el branch (1) o no (0)
    );
    
    reg result  ;    
    assign  o_PCSrc   =   result  ;
    
    initial 
    begin
        result     <=      1'b0;      
    end
    
    always @(*)
    begin
        if((i_Branch && i_Cero) || (i_NBranch && !i_Cero))
            result   <=     1'b1    ;
        else
            result   <=     1'b0    ;
    end
       
endmodule


//i_Branch	i_NBranch	i_Cero	o_PCSrc	Descripción
//1		0		1	1	BEQ y los valores coinciden → salto
//1		0		0	0	BEQ pero no coinciden → no salto
//0		1		0	1	BNE y los valores difieren → salto
//0		1		1	0	BNE pero son iguales → no salto
//0		0		X	0	No hay instrucción de Branch
