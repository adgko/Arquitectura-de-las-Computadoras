`timescale 1ns / 1ps

//Definicion de Macros mediante directiva 'define'
//<nombre>	<tamao>' <base>

`define	ADD_C	  6'b100000	//Suma
`define	SUB_C	  6'b100010	//Resta
`define	SUBU_C    6'b100011	//Resta Unsigned
`define	AND_C	  6'b100100	//And
`define	ANDI_C    6'b001100	//And Immediate
`define	OR_C	  6'b100101	//Or
`define	ORI_C	  6'b001101	//Or Immediate
`define 	NOR_C     6'b100111   //Nor
`define 	XOR_C     6'b100110   //Xor
`define 	XORI_C    6'b001110   //Xor Immediate
`define	SLT_C	  6'b101010	//Set on Less than
`define 	SLTI_C    6'b001010   //Set on Less than Immediate
`define	ADDU_C    6'b100001   //Add Unsigned Word
`define	SLL_C     6'b000000   //Shift Word Left Logical
`define 	SLLV_C    6'b000100   //Shift Word Left Logical Variable
`define	SRL_C     6'b000010   //Shift Word Right Logical
`define	SRLV_C    6'b000110   //Shift Word Right Logical Variable
`define	SRA_C     6'b000011   //Shift Word Right Arithmetic
`define	SRAV_C    6'b000111   //Shift Word Right Arithmetic Variable

`define	CERO    2'b00
`define	CEROUNO 2'b01
`define	UNOCERO 2'b10
`define	UNOUNO  2'b11

module Control_ALU
    #(
        parameter   ANBITS          =   6   ,
        parameter   NBITSCONTROL    =   2   ,
        parameter   ALUOP           =   4   
    )
    (
        input   wire    [ANBITS-1       :0]     i_Funct ,	// Campo funct de instrucciones tipo R (especifica la operación)
        input   wire    [ANBITS-1       :0]     i_Opcode,	// Campo opcode de la instrucción
        input   wire    [NBITSCONTROL-1 :0]     i_ALUOp ,    // Señal generada por la unidad de control principal que indica tipo general de operación
        output  wire    [ALUOP-1        :0]     o_ALUOp ,	// Código que se enviará a la ALU para indicar qué operación ejecutar
        output  wire                            o_Shamt       // Flag que indica si se debe usar shamt como desplazamiento     
    );
    
    reg [ALUOP-1    :0] ALUOp_Reg   ;
    
    assign o_ALUOp  =    ALUOp_Reg   ;
    assign o_Shamt  =   (i_Funct == `SRA_C | i_Funct == `SRL_C | i_Funct == `SLL_C) ? 1 : 0 ; // Esta señal se activa cuando se detecta una instrucción que usa el campo shamt directamente, como sll, srl, sra. Es útil para que la ALU sepa si usar i_Shamt o no
    
    always @(*)
    begin : ALUOp
            case(i_ALUOp)
                `CERO :       					// Operaciones tipo LW/SW/ADDI → ALU debe sumar
                                    ALUOp_Reg   <=   4'b0010    ;	// SUMA
                `CEROUNO :        					// Operaciones tipo BEQ/BNE → ALU debe restar
                                    ALUOp_Reg   <=   4'b0110    ;	// RESTA
                `UNOCERO :						// Instrucciones tipo R (funct define la operación)
                    case(i_Funct)
                        `ADD_C    :   ALUOp_Reg   <=   4'b0010    ;
                        `SUB_C    :   ALUOp_Reg   <=   4'b0110    ;
                        `SUBU_C   :   ALUOp_Reg   <=   4'b0110    ;
                        `AND_C    :   ALUOp_Reg   <=   4'b0000    ;
                        `OR_C     :   ALUOp_Reg   <=   4'b0001    ;
                        `NOR_C    :   ALUOp_Reg   <=   4'b1100    ;
                        `XOR_C    :   ALUOp_Reg   <=   4'b1101    ;
                        `SLT_C    :   ALUOp_Reg   <=   4'b0111    ;
                        `ADDU_C   :   ALUOp_Reg   <=   4'b0010    ;
                        `SLL_C    :   ALUOp_Reg   <=   4'b0011    ;
                        `SRL_C    :   ALUOp_Reg   <=   4'b0100    ;  
                        `SLLV_C   :   ALUOp_Reg   <=   4'b0011    ;
                        `SRLV_C   :   ALUOp_Reg   <=   4'b0100    ;  
                        `SRA_C    :   ALUOp_Reg   <=   4'b0101    ;
                        `SRAV_C   :   ALUOp_Reg   <=   4'b0101    ;                         
                        default :   ALUOp_Reg   <=   -2         ;
                    endcase       
                `UNOUNO :						// Instrucciones tipo I con operaciones lógicas/comparación
                    case(i_Opcode)
                        `SLTI_C   :   ALUOp_Reg   <=   4'b0111    ;
                        `ANDI_C   :   ALUOp_Reg   <=   4'b0000    ;
                        `ORI_C    :   ALUOp_Reg   <=   4'b0001    ;   
                        `XORI_C   :   ALUOp_Reg   <=   4'b1101    ;                           
                        default :   ALUOp_Reg   <=   -3         ;
                    endcase       
                default:            ALUOp_Reg   <=   -1        ;
            endcase
    end
endmodule
