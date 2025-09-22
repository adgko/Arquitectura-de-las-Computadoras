`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2022 10:45:12 PM
// Design Name: 
// Module Name: EX_Unidad_Cortocircuito
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


module EX_Unidad_Cortocircuito
    #(
        parameter RNBITS    =   5,
        parameter MUXBITS   =   3
    )
    (
        input   wire                i_EX_MEM_RegWrite   ,
        input   wire [RNBITS-1  :0] i_EX_MEM_Rd         ,
        input   wire                i_MEM_WR_RegWrite   ,
        input   wire [RNBITS-1  :0] i_MEM_WR_Rd         , 
        input   wire [RNBITS-1  :0] i_Rs                ,
        input   wire [RNBITS-1  :0] i_Rt                ,
        
        output  wire [MUXBITS-1 :0] o_Mux_OperandoA     ,
        output  wire [MUXBITS-1 :0] o_Mux_OperandoB
    );
    
    reg [MUXBITS-1 :0]  Mux_OperandoA_Reg               ;
    reg [MUXBITS-1 :0]  Mux_OperandoB_Reg               ;
    
    assign  o_Mux_OperandoA =   Mux_OperandoA_Reg       ;
    assign  o_Mux_OperandoB =   Mux_OperandoB_Reg       ;
    
    always @(*)
    begin
        if(i_EX_MEM_RegWrite && (i_Rs == i_EX_MEM_Rd))
        begin
            Mux_OperandoA_Reg = 3'b001;	// Usa valor desde EX/MEM
        end
        else if (i_MEM_WR_RegWrite && (i_Rs == i_MEM_WR_Rd))
        begin
            Mux_OperandoA_Reg = 3'b010;	// Usa valor desde MEM/WB
        end
        else
        begin
            Mux_OperandoA_Reg = 3'b000;	// Usa valor leído del registro Rs
        end
    end   
    always @(*)
    begin
        if (i_EX_MEM_RegWrite && (i_Rt == i_EX_MEM_Rd))
        begin
            Mux_OperandoB_Reg = 3'b001;	// Usa valor desde EX/MEM
        end
        else if (i_MEM_WR_RegWrite && (i_Rt == i_MEM_WR_Rd))
        begin
            Mux_OperandoB_Reg = 3'b010;	// Usa valor desde MEM/WB
        end
        else
        begin
            Mux_OperandoB_Reg = 3'b000;	// Usa valor leído del registro Rs
        end
    end
endmodule
