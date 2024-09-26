`timescale 1ns / 1ns
module top
#(
    parameter MAXTAM = 8, // bits de entrada (switches)
    parameter tam_OP= 6
)
(
    input   clk,  // clock
    input   [MAXTAM-1:0] sw,  // switches de entrada
    input   btn_A,
    input   btn_B,
    input   btn_OP,
    input   btn_Reset,
    output  [MAXTAM-1:0] LED,  // LED que refleja los switches
    output  [MAXTAM-1:0] LED2  // salida del resultado de la ALU (leds)
);
    reg [MAXTAM-1:0] inA;
    reg [MAXTAM-1:0] inB;
    reg [tam_OP-1:0] OP;
    wire [MAXTAM-1:0] ALU_Out;  // salida de la ALU
  
    // Instancia de la ALU
    alu alu_0( 
        .A(inA),
        .B(inB),
        .OP(OP),
        .ALU_Result(ALU_Out) 
    );
    
    // Mostrar el estado de los switches en los LED
    assign LED = sw;

    // Actualización secuencial de los registros al presionar botones
    always @(posedge clk) begin
        if (btn_Reset) begin
            // Reset de todos los valores
            inA <= {MAXTAM{1'b0}};
            inB <= {MAXTAM{1'b0}};
            OP  <= {tam_OP{1'b0}};
        end else begin
            if (btn_A) begin
                inA <= sw[MAXTAM-1:0];  // Cargar inA desde switches
            end
            if (btn_B) begin
                inB <= sw[MAXTAM-1:0];  // Cargar inB desde switches
            end
            if (btn_OP) begin
                OP <= sw[tam_OP-1:0];   // Cargar OP desde switches
            end
        end
    end

    // Mostrar el resultado de la ALU en los LEDs
    assign LED2 = ALU_Out;
    
endmodule
