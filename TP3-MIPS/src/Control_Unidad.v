`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 16.07.2021 15:19:34
// Design Name:
// Module Name: Control_Unidad
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
//
//////////////////////////////////////////////////////////////////////////////////

//LW:   100011  | base      |   RT  |   OFFSET
//LWU:  100111  | base      |   RT  |   OFFSET
//LB:   100000  | base      |   RT  |   OFFSET
//LBU:  100100  | base      |   RT  |   OFFSET
//LH:   100001  | base      |   RT  |   OFFSET
//LHU:  100101  | base      |   RT  |   OFFSET
//LUI:  001111  | 00000     |   RT  |   IMMEDIATE
//SW:   101011  |  base     |   RT  |   OFFSET
//SB:   101000  |  base     |   RT  |   OFFSET
//SH:   101001  |  base     |   RT  |   OFFSET
//ADD:  000000  |   RS      |   RT  |   RD  |   00000   |   100000
//SUB:  000000  |   RS      |   RT  |   RD  |   00000   |   100010
//SUBU: 000000  |   RS      |   RT  |   RD  |   00000   |   100011
//AND:  000000  |   RS      |   RT  |   RD  |   00000   |   100100
//ANDI: 001100  |   RS      |   RT  |   IMMEDIATE
//OR:   000000  |   RS      |   RT  |   RD  |   00000   |   100101
//ORI:  001101  |   RS      |   RT  |   IMMEDIATE
//NOR:  000000  |   RS      |   RT  |   RD  |   00000   |   100111
//XOR:  000000  |   RS      |   RT  |   RD  |   00000   |   100110
//XORI: 001110  |   RS      |   RT  |   IMMEDIATE
//SLT:  000000  |   RS      |   RT  |   RD  |   00000   |   101010
//SLTI: 001010  |   RS      |   RT  |   IMMEDIATE
//BEQ:  000100  |   RS      |   RT  |   OFFSET
//BNE:  000101  |   RS      |   RT  |   OFFSET
//J:    000010  |   INSTR_INDEX
//ADDI: 001000  |   RS      |   RT  |   IMMEDIATE
//SLL:  000000  |   000000  |   RT  |   RD  |   sa      |   000000
//SRL:  000000  |   000000  |   RT  |   RD  |   sa      |   000010

`define LW      6'b100011
`define LWU     6'b100111
`define LB      6'b100000
`define LBU     6'b100100
`define LH      6'b100001
`define LHU     6'b100101
`define LUI     6'b001111
`define SW      6'b101011
`define SB      6'b101000
`define SH      6'b101001
`define BEQ     6'b000100
`define BNE     6'b000101
`define J       6'b000010
`define JAL     6'b000011
`define BAS     6'b000000
`define ADDI    6'b001000
`define ANDI    6'b001100
`define SLTI    6'b001010
`define ORI     6'b001101
`define XORI    6'b001110
`define JALR    6'b001001
`define JR      6'b001000
`define HALT    6'b111111


module Control_Unidad
    #(
        parameter   NBITS       =   6
    )
    (
        input   wire    [NBITS-1        :0]     i_Instruction   ,	// Determina el tipo de instrucción (LOAD, STORE, R-TYPE, JUMP, etc.)
        input   wire    [NBITS-1        :0]     i_Special       ,	// campo funct de las instrucciones tipo R (solo se usa cuando opcode == 000000 o BAS).

        output  wire                            o_RegDst        ,	// El registro destino viene de rd (tipo R) o rt (tipo I)
        output  wire                            o_Jump          ,
        output  wire                            o_JAL           ,
        output  wire                            o_Branch        ,	// BEQ (branch si igual)
        output  wire                            o_NBranch       ,	// BNE (branch si distinto)
        output  wire                            o_MemRead       ,	// Indica que se debe leer memoria (LW, LB, LH...)
        output  wire                            o_MemToReg      ,	// El valor que va a los registros viene de memoria
        output  wire    [1              :0]     o_ALUOp         ,	// Código que guía qué operación debe hacer la ALU
        output  wire                            o_MemWrite      ,	// Se activa cuando hay escritura en memoria (SW, SH, SB...)
        output  wire                            o_ALUSrc        ,	// Si el segundo operando de la ALU es un inmediato (1) o un registro (0)
        output  wire                            o_RegWrite      ,	// Indica si se debe escribir en un registro
        output  wire    [1              :0]     o_ExtensionMode ,	// Define cómo extender un inmediato: con signo, sin signo o cargar alto (lui)
        output  wire    [1              :0]     o_TamanoFiltro  ,	// Tamaño de dato para escribir (byte, halfword, word)
        output  wire    [1              :0]     o_TamanoFiltroL ,	// Tamaño de dato para leer
        output  wire                            o_ZeroExtend    ,	// Si se debe hacer extensión con ceros en vez de signo
        output  wire                            o_LUI           ,	// Señal especial para cargar solo bits altos (lui)
        output  wire                            o_JALR          ,
        output  wire                            o_HALT
    );

    reg         RegDst_Reg          ;
    reg         Jump_Reg            ;
    reg         JAL_Reg             ;
    reg         Branch_Reg          ;
    reg         NBranch_Reg         ;
    reg         MemRead_Reg         ;
    reg         MemToReg_Reg        ;
    reg [1:0]   ALUOp_Reg           ;
    reg         MemWrite_Reg        ;
    reg         ALUSrc_Reg          ;
    reg         RegWrite_Reg        ;
    reg [1:0]   ExtensionMode_Reg   ;
    reg [1:0]   TamanoFiltro_Reg    ;
    reg [1:0]   TamanoFiltroL_Reg   ;
    reg         ZeroExtend_Reg      ;
    reg         LUI_Reg             ;
    reg         JALR_Reg            ;
    reg         HALT_Reg            ;

    assign  o_RegDst        =   RegDst_Reg          ;
    assign  o_Jump          =   Jump_Reg            ;
    assign  o_JAL           =   JAL_Reg             ;
    assign  o_Branch        =   Branch_Reg          ;
    assign  o_NBranch       =   NBranch_Reg         ;
    assign  o_MemRead       =   MemRead_Reg         ;
    assign  o_MemToReg      =   MemToReg_Reg        ;
    assign  o_ALUOp         =   ALUOp_Reg           ;
    assign  o_MemWrite      =   MemWrite_Reg        ;
    assign  o_ALUSrc        =   ALUSrc_Reg          ;
    assign  o_RegWrite      =   RegWrite_Reg        ;
    assign  o_ExtensionMode =   ExtensionMode_Reg   ;
    assign  o_TamanoFiltro  =   TamanoFiltro_Reg    ;
    assign  o_TamanoFiltroL =   TamanoFiltroL_Reg   ;
    assign  o_ZeroExtend    =   ZeroExtend_Reg      ;
    assign  o_LUI           =   LUI_Reg             ;
    assign  o_JALR          =   JALR_Reg            ;
    assign  o_HALT          =   HALT_Reg            ;

    always @(*)
    begin : Decoder
        case(i_Instruction)
            `BAS:
            if(i_Special == `JALR)
            begin
                RegDst_Reg          <=  1'b1    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b1    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b1    ;
                HALT_Reg            <=  1'b0    ;
            end
            else if (i_Special == `JR)
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b1    ;
                HALT_Reg            <=  1'b0    ;
            end
            else
            begin
                RegDst_Reg          <=  1'b1    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b10   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            `ADDI:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            `ANDI:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b11   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b01   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            `ORI:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b11   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b01   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            `SLTI:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b11   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            `XORI:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b11   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b01   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            `LW:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b1    ;
                MemToReg_Reg        <=  1'b1    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            `LWU:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b1    ;
                MemToReg_Reg        <=  1'b1    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            `LB:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b1    ;
                MemToReg_Reg        <=  1'b1    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b01   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            `LBU:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b1    ;
                MemToReg_Reg        <=  1'b1    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b01   ;
                ZeroExtend_Reg      <=  1'b1    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            `LH:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b1    ;
                MemToReg_Reg        <=  1'b1    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b10   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            `LHU:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b1    ;
                MemToReg_Reg        <=  1'b1    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b10   ;
                ZeroExtend_Reg      <=  1'b1    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            `LUI:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b1    ;
                MemToReg_Reg        <=  1'b1    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b10   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b1    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            `SW:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b1    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            `SB:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b1    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b01   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            `SH:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b1    ;
                ALUSrc_Reg          <=  1'b1    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b10   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            `BEQ:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b1    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b01   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            `BNE:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b1    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b01   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

            `J:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b1    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end

           `JAL:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b1    ;
                JAL_Reg             <=  1'b1    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b1    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end
    
            `HALT:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b00   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b1    ;
            end
            
            default:
            begin
                RegDst_Reg          <=  1'b0    ;
                Jump_Reg            <=  1'b0    ;
                JAL_Reg             <=  1'b0    ;
                Branch_Reg          <=  1'b0    ;
                NBranch_Reg         <=  1'b0    ;
                MemRead_Reg         <=  1'b0    ;
                MemToReg_Reg        <=  1'b0    ;
                ALUOp_Reg           <=  2'b11   ;
                MemWrite_Reg        <=  1'b0    ;
                ALUSrc_Reg          <=  1'b0    ;
                RegWrite_Reg        <=  1'b0    ;
                ExtensionMode_Reg   <=  2'b00   ;
                TamanoFiltro_Reg    <=  2'b00   ;
                TamanoFiltroL_Reg   <=  2'b00   ;
                ZeroExtend_Reg      <=  1'b0    ;
                LUI_Reg             <=  1'b0    ;
                JALR_Reg            <=  1'b0    ;
                HALT_Reg            <=  1'b0    ;
            end
        endcase
    end
endmodule
