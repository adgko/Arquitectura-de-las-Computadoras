`timescale 1ns / 1ps

module alu
    #(
    //parameter
    parameter          MAXTAM     = 8
    )
    (
    //inputs
    input  wire        [MAXTAM - 1:0]                      data_a,
    input  wire        [MAXTAM - 1:0]                      data_b,
    input  wire        [MAXTAM - 3:0]                          op,
    
    //outputs
    output wire        [MAXTAM - 1:0]                         o_alu_Result,
    output wire                                                o_carry
    );
    
    localparam ADD = 6'b100000;
    localparam SUB = 6'b100010;
    localparam AND = 6'b100100;
    localparam OR  = 6'b100101;
    localparam XOR = 6'b100110;
    localparam SRA = 6'b000011;
    localparam SRL = 6'b000010;
    localparam NOR = 6'b100111;

    reg carry;
    reg [MAXTAM : 0] aluResult;
    assign o_alu_Result = aluResult;
    assign o_carry = carry;
         
    always @(*) begin
        case (op)
        ADD: begin
                aluResult = (data_a) + (data_b); //ADD
                carry = aluResult[MAXTAM];
             end
        SUB: begin
                aluResult = (data_a) - (data_b); //SUB
                carry = aluResult[MAXTAM];
             end
        AND: begin
                aluResult = data_a & data_b; //AND
                carry = 1'b0;
             end
        OR : begin
                aluResult = data_a | data_b; //OR
                carry = 1'b0;
             end
        XOR: begin
                aluResult = data_a ^ data_b; //XOR
                carry = 1'b0;
             end
        SRA: begin
                aluResult = $signed(data_a) >>> data_b; //SRA
                carry = 1'b0;
             end
        SRL: begin
                aluResult = data_a >> data_b; //SRL
                carry = 1'b0;
             end
        NOR: begin
                aluResult = ~(data_a | data_b); //NOR
                carry = 1'b0;
             end
        default: begin
                    aluResult = {MAXTAM{1'b0}};
                    carry = 1'b0;
                 end
        endcase
  
    end
endmodule
