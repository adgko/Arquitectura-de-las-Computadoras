`timescale 1ns / 1ps


module Sumador_Branch
    #(
        parameter NBITS = 32
    )
    (
        input   wire    [NBITS-1      :0]   i_ExtensionData ,
        input   wire    [NBITS-1      :0]   i_SumadorPC4    ,
        output  wire    [NBITS-1      :0]   o_Mux                 
    );
    
    reg [NBITS-1  :0]   result  ;    
    assign  o_Mux   =   result  ;
    
    always @(*)
    begin
        result   <=  (i_ExtensionData<<2) + i_SumadorPC4  ;	// tyoma el valor, lo multiplica por 4 y le suma el PC
    end  
     
endmodule
