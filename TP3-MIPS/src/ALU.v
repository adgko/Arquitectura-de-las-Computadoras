`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2021 12:33:32
// Design Name: 
// Module Name: ALU
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
//Definicion de Macros
//<nombre>, <tamano>'<base>
`define AND     4'b0000       //0.Salida-> A and B
`define OR      4'b0001       //1.Salida-> A or B
`define ADD     4'b0010       //2.Salida-> A + B
`define SLL     4'b0011       //3.Salida-> A<<B(shamt)
`define SRL     4'b0100       //4.Salida-> A>>B(shamt)
`define SRA     4'b0101       //5.Salida-> A>>>B
`define SUB     4'b0110       //6.Salida-> A - B
`define SLT     4'b0111       //7.Salida-> A es menor que B
`define NOR     4'b1100       //12.Salida-> A nor B
`define XOR     4'b1101       //13.Salida-> A xor B

module ALU
    #(
        parameter   NBITS   =   32  ,
        parameter   RNBITS  =   5   ,
        parameter   BOP     =   4      
    )
    (
        input   wire    [NBITS-1    :0]     i_RegA      ,
        input   wire    [NBITS-1    :0]     i_RegB      ,
        input   wire    [RNBITS-1   :0]     i_Shamt     ,
        input   wire                        i_UShamt    ,
        input   wire    [BOP-1      :0]     i_Op        ,
        output  wire                        o_Cero      ,
        output  wire    [NBITS-1    :0]     o_Result    
    );
    
    reg [NBITS-1:0]     result          ;
    
    assign o_Result =   result          ;
    assign o_Cero   =   (result==0)     ;
    
    always @(*)
        begin : operations
            case(i_Op)
                `AND:       result  =   i_RegA   &   i_RegB                                                         ;
                `OR:        result  =   i_RegA   |   i_RegB                                                         ;
                `ADD:       result  =   i_RegA   +   i_RegB                                                         ;
                `SUB:       result  =   i_RegA   -   i_RegB                                                         ;
                `SLT:       result  =   i_RegA   <   i_RegB ? 1:0                                                   ;
                `NOR:       result  =   ~(i_RegA |   i_RegB)                                                        ;
                `XOR:       result  =   i_RegA   ^   i_RegB                                                         ;
                `SLL:       result  =   (i_UShamt) ? (i_RegB << i_Shamt) : (i_RegB << i_RegA)                       ;
                `SRL:       result  =   (i_UShamt) ? (i_RegB >> i_Shamt) : (i_RegB >> i_RegA)                       ;
                `SRA:       result  =   (i_UShamt) ? ($signed(i_RegB) >>> i_Shamt) : ($signed(i_RegB) >>> i_RegA)   ;
                default:    result  =   -1                                                                          ;
            endcase
        end
endmodule
