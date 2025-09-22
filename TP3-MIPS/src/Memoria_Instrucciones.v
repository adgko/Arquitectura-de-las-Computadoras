`timescale 1ns / 1ps

module Memoria_Instrucciones
    #(
        parameter NBITS     = 32    ,
        parameter CELDAS    = 256
    )
    (
        input   wire                        i_clk           ,
        input   wire                        i_reset         ,
        input   wire                        i_Step          ,
        input   wire    [NBITS-1    :0]     i_PC            ,
        input   wire    [NBITS-1    :0]     i_DirecDebug    ,
        input   wire    [NBITS-1    :0]     i_DatoDebug     ,
        input   wire                        i_WriteDebug    ,
        output  reg     [NBITS-1    :0]     o_Instruction   
    );
    
    reg     [NBITS-1  :0]     memory[CELDAS-1:0];
    integer                   i;

    
    initial 
    begin
        for (i = 0; i < CELDAS; i = i + 1) begin
            memory[i] = 0;
        end  
    end

//    initial
//    begin
//        memory[4] <= 32'b00000000001000110000000000100000; //add r0,r1,r3
//        memory[8] <= 32'b00000000000000100000100000100010; //sub r1,r0,r2
//        memory[12] <= 32'b00000000010000110000100000100110; //xor r1,r2,r3
//        memory[16] <= 32'b10000000010001000000000000000001; //lb r4,1(r2)
//        memory[20] <= 32'b10101100011000100000000000000100; //sw r2,4(r3)
//        memory[24] <= 32'b00000000011000010010100000000100; //sllv r5,r1,r3
//        memory[28] <= 32'b00000000011000010010100000000110; //srlv r5,r1,r3
//        memory[32] <= 32'b00001000000000000000000000001011; //j 11
//        memory[36] <= 32'b00000000000000100000100001000011; //sra r1,r2,1
//        memory[40] <= 32'b00000000010000110000100000100001; //addu r1,r2,r3
//        memory[44] <= 32'b00000000010000110000100000100011; //subu r1,r2,r3
//        memory[48] <= 32'b10001101000001100000000000000001; //lw r6,1(r8)
//        memory[52] <= 32'b00000000000001100000100000100100; //and r1,r0,r6
//        memory[56] <= 32'b00010000011000110000000000000011; //beq r3,r3,3
//        memory[60] <= 32'b10100000010001000000000000000001; //sb r4,1(r2)
//        memory[64] <= 32'b10010000010001010000000000000001; //lbu r5,1(r2)
//        memory[68] <= 32'b10010100010001100000000000000001; //lhu r6,1(r2)
//        memory[72] <= 32'b10000100010000010000000000000001; //lh r1,1(r2)
//        memory[76] <= 32'b10100100010000110000000000000010; //sh r3,2(r2)
//        memory[80] <= 32'b00010100001000010000000000000101; //bne r1,r1,5
//        memory[84] <= 32'b00001100000000000000000000011000; //jal 24
//        memory[88] <= 32'b00110000011001110000000000001010; //andi r7,r3,10
//        memory[92] <= 32'b00000000000001010010000010000010; //srl r4,r5,2
//        memory[96] <= 32'b00000000001000010010000000100111; //nor r4,r1,r1
//        memory[100] <= 32'b00110100000000010000000001110000; //ori r1,r0,112
//        memory[104] <= 32'b00000000001000001111100000001001; //jalr r1
//        memory[108] <= 32'b00000000010000110010000000100101; //or r4,r2,r3
//        memory[112] <= 32'b10011100010001000000000000000001; //lwu r4,1(r2)
//        memory[116] <= 32'b00111000010000110000000000010011; //xori r3,r2,19
//        memory[120] <= 32'b00000000010000110000100000101010; //slt r1,r2,r3
//        memory[124] <= 32'b00000000000000000000000000000000; //nop
//        memory[128] <= 32'b00111000000000010000000010010000; //xori r1,r0,144
//        memory[132] <= 32'b00000000001000000000000000001000; //jr r1
//        memory[136] <= 32'b00111100000000010000000000011100; //lui r1,28
//        memory[140] <= 32'b00000000000000100000101000000000; //sll r1,r2,8
//        memory[144] <= 32'b00101000000000110000000000000001; //slti r3,r0,1
//        memory[148] <= 32'b00000000000001010010000000000111; //srav r4,r5,r0
//        memory[152] <= 32'b00000000000000110000100111000011; //sra r1,r3,7
//        memory[156] <= 32'b11111111111111111111111111111111;

//    end

    always @(posedge i_clk)
    begin
        if (i_Step)
        begin
            o_Instruction  <= memory[i_PC];
        end
    end

    // Escribe dato enviado por unidad debug en la memoria
    always @(posedge i_WriteDebug)
    begin
            memory[i_DirecDebug] <= i_DatoDebug; 
    end

endmodule
