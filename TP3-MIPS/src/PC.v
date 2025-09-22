`timescale 1ns / 1ps

module PC
    #(
        parameter   NBITS       =   32  
    )
    (
        input   wire                            i_clk           ,
        input   wire                            i_PC_Write      ,
        input   wire                            i_reset         ,
        input   wire                            i_Step          ,
        input   wire    [NBITS-1    :0]         i_NPC           ,
        output  wire    [NBITS-1    :0]         o_PC            ,
        output  wire    [NBITS-1    :0]         o_PC_4          ,
        output  wire    [NBITS-1    :0]         o_PC_8          
    );
    
    reg         [NBITS-1  :0]         PC_Reg;
    
    assign  o_PC     =   PC_Reg     ;       
    assign  o_PC_4   =   PC_Reg + 4 ;
    assign  o_PC_8   =   PC_Reg + 8 ;        
      
    
    always @(negedge i_clk)
    begin
        if(i_reset)
        begin
            PC_Reg          <=      {NBITS{1'b0}}    ;
        end else if(i_PC_Write & i_Step)
        begin
            PC_Reg          <=      i_NPC           ;
        end 
    end
endmodule
