`timescale 1ns / 1ps

module tb_br_gen;  // Testbench para el baud rate generator

    // Parámetros
    parameter CLOCK_FREQUENCY = 25E6;  // 25 MHz
    parameter BAUD_RATE = 19200;       // Baud rate a 19200 bps

    // Señales internas
    reg i_clock;
    reg i_reset;
    wire o_tick;

    // Instancia del módulo del baud rate generator
    br_gen #(
        .CLOCK_FREQUENCY(CLOCK_FREQUENCY), 
        .BAUD_RATE(BAUD_RATE)
    ) uut (
        .i_clock(i_clock),
        .i_reset(i_reset),
        .o_tick(o_tick)
    );

    // Generador de reloj (25 MHz)
    initial begin
        i_clock = 0;
        forever #20 i_clock = ~i_clock;  // Periodo de 40ns (25 MHz)
    end

    // Simulación
    initial begin
        // Inicialización
        i_reset = 1;      // Reseteamos al principio
        #100;             // Esperamos 100 ns

        // Quitamos el reset y comenzamos la simulación
        i_reset = 0;

        // Simulamos durante 100.000 ciclos de reloj (puedes ajustarlo)
        #1000000;

        // Fin de la simulación
        $finish;
    end

    // Monitor para observar los cambios (opcional, para seguimiento por consola)
    initial begin
        $monitor("Time: %0t | o_tick = %b", $time, o_tick);
    end

endmodule

