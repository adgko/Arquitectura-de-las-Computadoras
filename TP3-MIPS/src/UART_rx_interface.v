`timescale 1ns / 1ps

// UART receiver module
module UART_rx_interface
    #(
        parameter       CLK_FREQ     = 50000000,  
        parameter       BAUD_RATE    = 9600, 
        parameter       DIV_SAMPLE   = 16, //oversampling
        parameter       DATA_BITS    = 8 
    )
    (
        input   wire                        clk,
        input   wire                        reset,
        input   wire                        i_uart_rx,
        output  wire                        o_ready,
        output  wire   [DATA_BITS-1    :0]  o_data
    );
    
    //Estados
    localparam     IDLE                = 1'b0;
    localparam     RECEIVING           = 1'b1;
    
    //Parametros locales    
    localparam     DIV_COUNTER         = CLK_FREQ/(BAUD_RATE*DIV_SAMPLE);  // este es el número que tenemos para dividir la frecuencia del reloj del sistema para obtener un tiempo de frecuencia (div_sample) mayor que (baud_rate)
    localparam     MID_SAMPLE          = (DIV_SAMPLE/2);  // este es el punto medio de un bit en el que desea  tomar el sample
    localparam     COUNTER_SIZE        = $clog2(DIV_COUNTER+1)+1;
    localparam     SAMPLE_COUNTER_SIZE = $clog2(DIV_SAMPLE+1);
    localparam     BIT_COUNTER_SIZE    = $clog2(DATA_BITS+1);
    
    
    reg         [DATA_BITS-1    :0]             shift_reg, shift_reg_next;   
    reg                                         state, state_next;
    reg                                         data_ready, data_ready_next;    
    reg         [BIT_COUNTER_SIZE-1     :0]     bitcounter, bitcounter_next; // Contador de 4 bits para contar hasta 9 bits recibidos
    reg         [SAMPLE_COUNTER_SIZE-1  :0]     samplecounter, samplecounter_next; // Contador de muestras de 2 bits para contar hasta 4 para oversampling
    reg         [COUNTER_SIZE+1         :0]     counter; // Contador de 14 bits para contar la tasa de baudios

    
    assign o_data  = shift_reg [DATA_BITS-1:0]; 
    assign o_ready = data_ready;
    
    always @ (posedge clk, posedge reset)
        begin 
            if (reset)begin       
                counter             <= 0; 
                state               <= IDLE; 
                bitcounter          <= 0; 
                samplecounter       <= 0; 
                shift_reg           <= 0;
                data_ready          <= 0;
            end else begin 
                counter <= counter +1; // empezar a contar en el contador
                if (counter >= DIV_COUNTER-1) begin // si el contador alcanza el baudrate
                    counter       <= 0; 
                    state         <= state_next; 
                    samplecounter <= samplecounter_next;
                    bitcounter    <= bitcounter_next;
                    data_ready    <= data_ready_next;
                    shift_reg     <= shift_reg_next;                    
                end
            end
        end
       
    always @* 
    begin 
        state_next          <=  state;
        samplecounter_next  <=  samplecounter;
        bitcounter_next     <=  bitcounter;
        data_ready_next     <=  data_ready;
        shift_reg_next      <=  shift_reg;
        case (state)
            IDLE:
             begin 
                if (~i_uart_rx) begin// Si el input de UART es 1 queda esperando el bit de inicio (0)
                    state_next          <= RECEIVING; 
                    bitcounter_next     <= 0;
                    samplecounter_next  <= 0;
                    data_ready_next     <= 0;
                end
            end
            RECEIVING: 
            begin
                if (samplecounter == MID_SAMPLE - 1) begin   
                    shift_reg_next      <=  {i_uart_rx,shift_reg[DATA_BITS-1:1]}; // si el contador de muestras es 1, activa el shift
                end            
                if (samplecounter == DIV_SAMPLE - 1) begin
                    if (bitcounter == DATA_BITS) begin // Si el contador de bits es 8 termina la recepcion
                        state_next      <= IDLE; 
                        data_ready_next <= 1;
                    end 
                                       
                    bitcounter_next     <= bitcounter + 1; 
                    samplecounter_next  <= 0; //Reinicia el contador de muestras
                end 
                else begin 
                    samplecounter_next  <= samplecounter + 1;          
                end
            end
           default: 
                state_next <= IDLE;
         endcase
    end         
endmodule