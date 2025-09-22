`timescale 1ns / 1ps

module Etapa_EX_MEM
    #(
        parameter NBITS     =   32  ,
        parameter REGS      =   5       
    )
    (   //GeneralInputs
        input   wire                        i_clk               ,
        input   wire                        i_reset             ,
        input   wire                        i_Flush             ,
        input   wire    [NBITS-1    :0]     i_PC4               ,
        input   wire    [NBITS-1    :0]     i_PC8               ,
        input   wire                        i_Step              ,
        input   wire    [NBITS-1    :0]     i_PCBranch          ,
        input   wire    [NBITS-1    :0]     i_Instruction       ,
        input   wire                        i_Cero              ,
        input   wire    [NBITS-1    :0]     i_ALU               ,
        input   wire    [NBITS-1    :0]     i_Registro2         ,
        input   wire    [REGS-1     :0]     i_RegistroDestino   ,
        input   wire    [NBITS-1    :0]     i_Extension         ,
        
        ///IControlM
        input   wire                        i_Branch            ,
        input   wire                        i_NBranch           ,
        input   wire                        i_MemWrite          ,
        input   wire                        i_MemRead           , 
        input   wire    [1          :0]     i_TamanoFiltro      ,   
        
        ///IControlWB
        input   wire                        i_JAL               ,        
        input   wire                        i_MemToReg          ,
        input   wire                        i_RegWrite          ,
        input   wire    [1          :0]     i_TamanoFiltroL     ,
        input   wire                        i_ZeroExtend        ,
        input   wire                        i_LUI               ,
        input   wire                        i_HALT              ,
        
        //GeneralOutputs
        output  wire    [NBITS-1    :0]     o_PC4               ,
        output  wire    [NBITS-1    :0]     o_PC8               ,        
        output  wire    [NBITS-1    :0]     o_PCBranch          ,
        output  wire    [NBITS-1    :0]     o_Instruction       ,
        output  wire                        o_JAL               ,
        output  wire                        o_Cero              ,
        output  wire    [NBITS-1    :0]     o_ALU               ,
        output  wire    [NBITS-1    :0]     o_Registro2         ,
        output  wire    [REGS-1     :0]     o_RegistroDestino   ,
        output  wire    [NBITS-1    :0]     o_Extension         ,
        
        ///OControlM
        output  wire                        o_Branch            ,
        output  wire                        o_NBranch           ,
        output  wire                        o_MemWrite          ,
        output  wire                        o_MemRead           ,
        output  wire   [1          :0]      o_TamanoFiltro      ,     
        
        ///OControlWB
        output  wire                        o_MemToReg          ,
        output  wire                        o_RegWrite          ,
        output  wire   [1          :0]      o_TamanoFiltroL     ,
        output  wire                        o_ZeroExtend        ,
        output  wire                        o_LUI               ,
        output  wire                        o_HALT
    );
    
    reg     [NBITS-1    :0] PC4_reg             ;
    reg     [NBITS-1    :0] PC8_reg             ;
    reg     [NBITS-1    :0] PCBranch_reg        ;
    reg     [NBITS-1    :0] Instruction_reg     ;
    reg                     JAL_reg             ;
    reg                     Cero_reg            ;
    reg     [NBITS-1    :0] ALU_reg             ;
    reg     [NBITS-1    :0] Registro2_reg       ;
    reg     [REGS-1     :0] RegistroDestino_reg ;
    reg     [NBITS-1    :0] Extension_reg       ;
    
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
    reg                     HALT_reg            ;
    
    assign o_PC4                =   PC4_reg             ;
    assign o_PC8                =   PC8_reg             ;
    assign o_PCBranch           =   PCBranch_reg        ;
    assign o_Instruction        =   Instruction_reg     ;
    assign o_Cero               =   Cero_reg            ;
    assign o_JAL                =   JAL_reg             ;
    assign o_ALU                =   ALU_reg             ;
    assign o_Registro2          =   Registro2_reg       ;
    assign o_RegistroDestino    =   RegistroDestino_reg ;
    assign o_Extension          =   Extension_reg       ;
    
    //AssignM
    assign o_Branch         =   Branch_reg          ;
    assign o_NBranch        =   NBranch_reg         ;
    assign o_MemWrite       =   MemWrite_reg        ;
    assign o_MemRead        =   MemRead_reg         ;
    assign o_TamanoFiltro   =   TamanoFiltro_reg    ;
    
    //AssignWB
    assign o_MemToReg       =   MemToReg_reg        ;
    assign o_RegWrite       =   RegWrite_reg        ;
    assign o_TamanoFiltroL  =   TamanoFiltroL_reg   ;
    assign o_ZeroExtend     =   ZeroExtend_reg      ;
    assign o_LUI            =   LUI_reg             ;
    assign o_HALT           =   HALT_reg            ;
    
    //always @(posedge i_clk, posedge i_reset, posedge i_Flush)
    always @(posedge i_clk)
        if(i_Flush | i_reset)
             begin 
                PC4_reg             <=  {NBITS{1'b0}}           ;
                PC8_reg             <=  {NBITS{1'b0}}           ;
                PCBranch_reg        <=  {NBITS{1'b0}}           ;
                Instruction_reg     <=  {NBITS{1'b0}}           ;
                Cero_reg            <=  1'b0                    ;
                ALU_reg             <=  {NBITS{1'b0}}           ;        
                Registro2_reg       <=  {NBITS{1'b0}}           ;
                RegistroDestino_reg <=  {REGS{1'b0}}            ;
                Extension_reg       <=  {NBITS{1'b0}}           ;
                
                //M
                Branch_reg          <=  1'b0                    ;
                NBranch_reg         <=  1'b0                    ;
                MemWrite_reg        <=  1'b0                    ;
                MemRead_reg         <=  1'b0                    ;
                TamanoFiltro_reg    <=  2'b00                   ;
        
                //WB
                JAL_reg             <=  1'b0                    ;            
                MemToReg_reg        <=  1'b0                    ;
                RegWrite_reg        <=  1'b0                    ;
                TamanoFiltroL_reg   <=  2'b00                   ;
                ZeroExtend_reg      <=  1'b0                    ;
                LUI_reg             <=  1'b0                    ;
                HALT_reg            <=  1'b0                    ;
            end
        else if (i_Step)
            begin 
                PC4_reg             <=  i_PC4                   ;
                PC8_reg             <=  i_PC8                   ;
                PCBranch_reg        <=  i_PCBranch              ;
                Instruction_reg     <=  i_Instruction           ;
                Cero_reg            <=  i_Cero                  ;
                ALU_reg             <=  i_ALU                   ;        
                Registro2_reg       <=  i_Registro2             ;
                RegistroDestino_reg <=  i_RegistroDestino       ;
                Extension_reg       <=  i_Extension             ;
                
                //M
                Branch_reg          <=  i_Branch                ;
                NBranch_reg         <=  i_NBranch               ;
                MemWrite_reg        <=  i_MemWrite              ;
                MemRead_reg         <=  i_MemRead               ;
                TamanoFiltro_reg    <=  i_TamanoFiltro          ;
        
                //WB
                JAL_reg             <=  i_JAL                   ;            
                MemToReg_reg        <=  i_MemToReg              ;
                RegWrite_reg        <=  i_RegWrite              ;
                TamanoFiltroL_reg   <=  i_TamanoFiltroL         ;
                ZeroExtend_reg      <=  i_ZeroExtend            ;
                LUI_reg             <=  i_LUI                   ;
                HALT_reg            <=  i_HALT                  ;
            end
        
endmodule
