`timescale 1ns / 1ps

module Etapa_ID_EX
    #(
        parameter NBITS     =   32  ,
        parameter RNBITS    =   5
    )
    (
        //GeneralInputs
        input   wire                        i_clk           ,
        input   wire                        i_reset         ,
        input   wire                        i_Flush         ,
        input   wire    [NBITS-1    :0]     i_PC4           ,
        input   wire    [NBITS-1    :0]     i_PC8           ,
        input   wire                        i_Step          ,
        input   wire    [NBITS-1    :0]     i_Instruction   ,
        input   wire    [NBITS-1    :0]     i_Registro1     , // dato leido 1
        input   wire    [NBITS-1    :0]     i_Registro2     , // dato leido 2
        input   wire    [NBITS-1    :0]     i_Extension     ,
        input   wire    [RNBITS-1   :0]     i_Rt            ,
        input   wire    [RNBITS-1   :0]     i_Rd            ,
        input   wire    [RNBITS-1   :0]     i_Rs            ,
        input   wire    [NBITS-1    :0]     i_DJump         ,

        ///IControlEX
        input   wire                        i_Jump          ,
        input   wire                        i_JAL           ,
        input   wire                        i_ALUSrc        ,
        input   wire    [1          :0]     i_ALUOp         ,
        input   wire                        i_RegDst        ,

        ///IControlM
        input   wire                        i_Branch        ,
        input   wire                        i_NBranch       ,
        input   wire                        i_MemWrite      ,
        input   wire                        i_MemRead       ,
        input   wire    [1          :0]     i_TamanoFiltro  ,

        ///IControlWB
        input   wire                        i_MemToReg      ,
        input   wire                        i_RegWrite      ,
        input   wire    [1          :0]     i_TamanoFiltroL ,
        input   wire                        i_ZeroExtend    ,
        input   wire                        i_LUI           ,
        input   wire                        i_JALR          ,
        input   wire                        i_HALT          ,


        //GeneralOutputs
        output  wire    [NBITS-1    :0]     o_PC4           ,
        output  wire    [NBITS-1    :0]     o_PC8           ,
        output  wire    [NBITS-1    :0]     o_Instruction   ,
        output  wire    [NBITS-1    :0]     o_Registro1     ,
        output  wire    [NBITS-1    :0]     o_Registro2     ,
        output  wire    [NBITS-1    :0]     o_Extension     ,
        output  wire    [RNBITS-1   :0]     o_Rs            ,
        output  wire    [RNBITS-1   :0]     o_Rt            ,
        output  wire    [RNBITS-1   :0]     o_Rd            ,
        output  wire    [NBITS-1    :0]     o_DJump         ,

        ///OControlEX
        output  wire                        o_Jump          ,
        output  wire                        o_JAL           ,
        output  wire                        o_ALUSrc        ,
        output  wire    [1          :0]     o_ALUOp         ,
        output  wire                        o_RegDst        ,

        ///OControlM
        output  wire                        o_Branch        ,
        output  wire                        o_NBranch       ,
        output  wire                        o_MemWrite      ,
        output  wire                        o_MemRead       ,
        output  wire    [1          :0]     o_TamanoFiltro  ,

        ///OControlWB
        output  wire                        o_MemToReg      ,
        output  wire                        o_RegWrite      ,
        output  wire   [1           :0]     o_TamanoFiltroL ,
        output  wire                        o_ZeroExtend    ,
        output  wire                        o_LUI           ,
        output  wire                        o_JALR          ,
        output  wire                        o_HALT
    );

    reg     [NBITS-1    :0] PC4_reg             ;
    reg     [NBITS-1    :0] PC8_reg             ;
    reg     [NBITS-1    :0] Instruction_reg     ;
    reg     [NBITS-1    :0] Registro1_reg       ;
    reg     [NBITS-1    :0] Registro2_reg       ;
    reg     [NBITS-1    :0] Extension_reg       ;
    reg     [RNBITS-1   :0] Rs_reg              ;
    reg     [RNBITS-1   :0] Rt_reg              ;
    reg     [RNBITS-1   :0] Rd_reg              ;
    reg     [NBITS-1    :0] DJump_reg           ;

    //RegEX
    reg                     Jump_reg            ;
    reg                     JAL_reg             ;
    reg                     ALUSrc_reg          ;
    reg     [1          :0] ALUOp_reg           ;
    reg                     RegDst_reg          ;

    //RegM
    reg                     Branch_reg          ;
    reg                     NBranch_reg         ;
    reg                     MemWrite_reg        ;
    reg                     MemRead_reg         ;
    reg     [1          :0] TamanoFiltro_reg    ;

    //RegWB
    reg                     MemToReg_reg        ;
    reg                     RegWrite_reg        ;
    reg     [1          :0] TamanoFiltroL_reg   ;
    reg                     ZeroExtend_reg      ;
    reg                     LUI_reg             ;
    reg                     JALR_reg            ;
    reg                     HALT_reg            ;


    assign o_PC4            =   PC4_reg         ;
    assign o_PC8            =   PC8_reg         ;
    assign o_Instruction    =   Instruction_reg ;
    assign o_Registro1      =   Registro1_reg   ;
    assign o_Registro2      =   Registro2_reg   ;
    assign o_Extension      =   Extension_reg   ;
    assign o_Rs             =   Rs_reg          ;
    assign o_Rt             =   Rt_reg          ;
    assign o_Rd             =   Rd_reg          ;
    assign o_DJump          =   DJump_reg       ;

    //AssignEX
    assign o_Jump           =   Jump_reg        ;
    assign o_JALR           =   JALR_reg        ;
    assign o_JAL            =   JAL_reg         ;
    assign o_ALUSrc         =   ALUSrc_reg      ;
    assign o_ALUOp          =   ALUOp_reg       ;
    assign o_RegDst         =   RegDst_reg      ;

    //AssignM
    assign o_Branch         =   Branch_reg      ;
    assign o_NBranch        =   NBranch_reg     ;
    assign o_MemWrite       =   MemWrite_reg    ;
    assign o_MemRead        =   MemRead_reg     ;
    assign o_TamanoFiltro   =   TamanoFiltro_reg;

    //AssignWB
    assign o_MemToReg       =   MemToReg_reg        ;
    assign o_RegWrite       =   RegWrite_reg        ;
    assign o_TamanoFiltroL  =   TamanoFiltroL_reg   ;
    assign o_ZeroExtend     =   ZeroExtend_reg      ;
    assign o_LUI            =   LUI_reg             ;
    assign o_HALT           =   HALT_reg            ;

    //always @(posedge i_clk, posedge i_reset, posedge i_Flush)\
    always @(posedge i_clk)
        if(i_Flush | i_reset)
        begin
            PC4_reg             <=  {NBITS{1'b0}}   ;
            PC8_reg             <=  {NBITS{1'b0}}   ;
            Instruction_reg     <=  {NBITS{1'b0}}   ;
            Registro1_reg       <=  {NBITS{1'b0}}   ;
            Registro2_reg       <=  {NBITS{1'b0}}   ;
            Extension_reg       <=  {NBITS{1'b0}}   ;
            Rs_reg              <=  {RNBITS{1'b0}}  ;
            Rt_reg              <=  {RNBITS{1'b0}}  ;
            Rd_reg              <=  {RNBITS{1'b0}}  ;
            DJump_reg           <=  {NBITS{1'b0}}   ;

            //EX
            Jump_reg            <=  1'b0            ;
            JALR_reg            <=  1'b0            ;
            JAL_reg             <=  1'b0            ;
            ALUSrc_reg          <=  1'b0            ;
            ALUOp_reg           <=  2'b00           ;
            RegDst_reg          <=  1'b0            ;

            //M
            Branch_reg          <=  1'b0            ;
            NBranch_reg         <=  1'b0            ;
            MemWrite_reg        <=  1'b0            ;
            MemRead_reg         <=  1'b0            ;
            TamanoFiltro_reg    <=  2'b00           ;

            //WB
            MemToReg_reg        <=  1'b0            ;
            RegWrite_reg        <=  1'b0            ;
            TamanoFiltroL_reg   <=  2'b00           ;
            ZeroExtend_reg      <=  1'b0            ;
            LUI_reg             <=  1'b0            ;
            HALT_reg            <=  1'b0            ;
        end
        else if (i_Step)
        begin
            PC4_reg             <=  i_PC4           ;
            PC8_reg             <=  i_PC8           ;
            Instruction_reg     <=  i_Instruction   ;
            Registro1_reg       <=  i_Registro1     ;
            Registro2_reg       <=  i_Registro2     ;
            Extension_reg       <=  i_Extension     ;
            Rs_reg              <=  i_Rs            ;
            Rt_reg              <=  i_Rt            ;
            Rd_reg              <=  i_Rd            ;
            DJump_reg           <=  i_DJump         ;

            //EX
            Jump_reg            <=  i_Jump          ;
            JALR_reg            <=  i_JALR          ;
            JAL_reg             <=  i_JAL           ;
            ALUSrc_reg          <=  i_ALUSrc        ;
            ALUOp_reg           <=  i_ALUOp         ;
            RegDst_reg          <=  i_RegDst        ;

            //M
            Branch_reg          <=  i_Branch        ;
            NBranch_reg         <=  i_NBranch       ;
            MemWrite_reg        <=  i_MemWrite      ;
            MemRead_reg         <=  i_MemRead       ;
            TamanoFiltro_reg    <=  i_TamanoFiltro  ;

            //WB
            MemToReg_reg        <=  i_MemToReg      ;
            RegWrite_reg        <=  i_RegWrite      ;
            TamanoFiltroL_reg   <=  i_TamanoFiltroL ;
            ZeroExtend_reg      <=  i_ZeroExtend    ;
            LUI_reg             <=  i_LUI           ;
            HALT_reg            <=  i_HALT          ;
        end

endmodule
