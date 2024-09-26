//`timescale 1ns / 1ns
module alu
#(  //Parameters:
    parameter MAXTAM = 8,
    parameter OPCODE = 6
)
 (  // Inputs & Outputs:
    input  wire [MAXTAM-1:0] A,       // registro A
    input  wire [MAXTAM-1:0] B,       // registro B
    input  wire [OPCODE-1:0] OP,      // la operación a realizar
    
    output reg  [MAXTAM-1:0] ALU_Result // ALU Output
);
    
    always @(*) begin   
      case(OP)
         6'b10_0000: ALU_Result = A+B ; // 32d=20h → SUMA
         6'b10_0010: ALU_Result = A-B ; // 34d=22h → RESTA
         6'b00_0010: ALU_Result = A>>B; // 2d=2h → Desplazamiento lógico Der
         6'b00_0011: ALU_Result = A>>>B; // 3d=3h → Desplazamiento aritmético Der
         6'b10_0100: ALU_Result = A & B; // 36d=24h → AND 
         6'b10_0101: ALU_Result = A | B; // 37d=25h → OR
         6'b10_0110: ALU_Result = A ^ B; // 38d=26h → XOR 
         6'b10_0111: ALU_Result = ~(A | B); // 39d=27h → NOR
         default: ALU_Result = {MAXTAM{1'b0}};
      endcase
    end

endmodule//alu_module
