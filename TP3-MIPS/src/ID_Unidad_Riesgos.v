`timescale 1ns / 1ps

module ID_Unidad_Riesgos
    #(
        parameter RNBITS    =   5,
        parameter MUXBITS   =   3
    )
    (
        input   wire                i_ID_EX_MemRead             ,
        input   wire                i_EX_MEM_MemRead            ,
        input   wire                i_JALR                      ,
        input   wire                i_HALT                      ,
        //input   wire                i_ID_Unidad_Control_Jump    ,
        input   wire                i_EX_MEM_Flush              ,
        input   wire [RNBITS-1  :0] i_ID_EX_Rt                  ,
        input   wire [RNBITS-1  :0] i_EX_MEM_Rt                 ,
        input   wire [RNBITS-1  :0] i_IF_ID_Rs                  ,
        input   wire [RNBITS-1  :0] i_IF_ID_Rt                  ,

        output  wire                o_Mux_Riesgo                ,
        output  wire                o_PC_Write                  ,	// Si está en 0, el contador de programa (PC) no avanza
        output  wire                o_IF_ID_Write               ,	// Si está en 0, la instrucción actual en IF/ID no se sobreescribe
        output  wire                o_Latch_Flush			// Limpia la etapa EX/MEM (por salto mal predicho, por ejemplo)
        //output  wire                o_IF_ID_Flush
    );

    reg Reg_Mux_Riesgo  ;
    reg Reg_PC_Write    ;
    reg Reg_IF_ID_Write ;
    reg Reg_Latch_Flush ;
    reg Reg_IF_ID_Flush ;

    assign  o_Mux_Riesgo    =   Reg_Mux_Riesgo  ;
    assign  o_PC_Write      =   Reg_PC_Write    ;
    assign  o_IF_ID_Write   =   Reg_IF_ID_Write ;
    assign  o_Latch_Flush   =   Reg_Latch_Flush ;
    //assign  o_IF_ID_Flush   =   Reg_IF_ID_Flush ;

    initial
    begin
        Reg_Mux_Riesgo     <=      1'b0;
        Reg_PC_Write       <=      1'b1;
        Reg_IF_ID_Write    <=      1'b1;
        Reg_Latch_Flush    <=      1'b0;
        Reg_IF_ID_Flush    <=      1'b0;
    end

    always @(*)
    begin
        if(i_EX_MEM_Flush) //Si llega una señal de flush (por ejemplo, por un salto mal predicho), se debe limpiar esa etapa. El control de eso va por separado, pero se activa con esto
        begin
            Reg_Latch_Flush      <= 1'b1;
        end
        else
        begin
            Reg_Latch_Flush      <= 1'b0;
        end
    end

    always @(*)
    begin
        if((i_ID_EX_MemRead && ((i_ID_EX_Rt == i_IF_ID_Rs) | (i_ID_EX_Rt == i_IF_ID_Rt))) | ((i_EX_MEM_MemRead && (i_EX_MEM_Rt == i_IF_ID_Rs)) && i_JALR))
        	// (i_ID_EX_MemRead && ((i_ID_EX_Rt == i_IF_ID_Rs) | (i_ID_EX_Rt == i_IF_ID_Rt))) 
        	// Si la instrucción actual (en ID) depende de un valor que todavía no fue cargado desde memoria por la instrucción que está en EX, se debe detener el pipeline.
        	
        	// ((i_EX_MEM_MemRead && (i_EX_MEM_Rt == i_IF_ID_Rs)) && i_JALR) 
        	// Si hay un JALR y la instrucción que está en MEM todavía no terminó de leer (MemRead), y escribe justo sobre el registro que JALR va a usar, también hay que detener.
        begin
            Reg_Mux_Riesgo      <= 1'b1; //Si hay riesgo 1
            Reg_PC_Write        <= 1'b0; //No escribir (0)
            Reg_IF_ID_Write     <= 1'b0; //No escribir (0)
        end
        else if (i_HALT)	// Si se está ejecutando un HALT, se detiene el PC, pero se permite escribir en el latch IF/ID para completar la instrucción antes de detener.	
        begin
            Reg_Mux_Riesgo      <= 1'b0;
            Reg_PC_Write        <= 1'b0;
            Reg_IF_ID_Write     <= 1'b1;
        end
        else
        begin
            Reg_Mux_Riesgo      <= 1'b0;
            Reg_PC_Write        <= 1'b1;
            Reg_IF_ID_Write     <= 1'b1;
        end
    end
endmodule
