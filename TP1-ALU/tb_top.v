`timescale 1ns / 1ns

module tb_top();
    parameter maxtam = 8;
    parameter tam_OP = 6;
    
    reg bA, bB, bOP, reset;
    reg [maxtam-1:0] In;
    reg clk;
    
    wire [maxtam-1:0] ALU_Out;
    
    // Clock generation
    always #20 clk = ~clk;    
    
    initial begin
    #70 bA<=1'b1; bB<=1'b0; bOP<=1'b0;
        In<=50;          // carga A
        reset <= 1'b0;
        clk = 1'b0; 
        
    #80 bA<=1'b0; bB<=1'b1; bOP<=1'b0;
        In<=30;          // carga B
        reset <= 1'b0;
    
    #80 bA<=1'b0; bB<=1'b0; bOP<=1'b1;
        In<=6'b10_0000;                 // SUMA
        reset <= 1'b0;
   
     
    
    end
    
    
    
// Module instance: 
  top #(
    .MAXTAM(maxtam),
    .tam_OP(tam_OP)
  )
  top (
    .btn_A(bA),
    .btn_B(bB),
    .btn_OP(bOP),
    .btn_Reset(reset),
    .In(In),
    .clk(clk),
    
    .ALU_Out(ALU_Out)
  );
  
endmodule
