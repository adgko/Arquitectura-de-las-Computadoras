`timescale 1ns / 1ps

module Memoria_Datos
    #(
        parameter NBITS     = 32    ,
        parameter CELDAS    = 16
    )
    (
        input   wire                        i_clk           ,
        input   wire                        i_reset         ,
        input   wire    [NBITS-1    :0]     i_ALUDireccion  ,
        input   wire    [NBITS-1    :0]     i_DebugDireccion,
        input   wire    [NBITS-1    :0]     i_DatoRegistro  ,
        input   wire                        i_MemWrite      ,
        input   wire                        i_MemRead       ,
        input   wire                        i_Step          ,
        output  reg     [NBITS-1    :0]     o_DatoLeido     ,
        output  reg     [NBITS-1    :0]     o_DebugDato
    );
    
    reg     [NBITS-1  :0]     memory[CELDAS-1:0];
    integer i;
    
    
    initial 
    begin
        for (i = 0; i < CELDAS; i = i + 1) begin
                memory[i] <= i;
        end
        o_DebugDato  <=  0;
    end
    
    always @(i_DebugDireccion)
    begin
        o_DebugDato  <=  memory[i_DebugDireccion];
    end

    always @(*)
    begin
        if (i_MemRead & i_Step) begin
            o_DatoLeido    <=  memory[i_ALUDireccion];
        end else begin
            o_DatoLeido    <=  0;
        end
    end

    always @(negedge i_clk)
    begin
        if(i_MemWrite & i_Step) begin
            memory[i_ALUDireccion]  <=  i_DatoRegistro;
        end
    end
endmodule

