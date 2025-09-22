`timescale 1ns / 1ps


module UART_tx_interface
    #(
        parameter       CLK_FREQ     = 50000000,  
        parameter       BAUD_RATE    = 9600, 
        parameter       DATA_BITS    = 8
    )
    (
        input                                   clk, 
        input                                   reset, 
        input                                   i_ready, //Datos en i_data listos para enviar
        input           [DATA_BITS-1    :0]     i_data, // Datos a transmitir
        output                                  o_uart_tx, // Output de transmision uart
        output                                  o_uart_tx_done // Transmision completada
    );
    
    //Estados
    localparam   IDLE                = 1'b0;
    localparam   TRANSMIT            = 1'b1; 
        
    // Parametros locales
    localparam   DIV_COUNTER         = CLK_FREQ / BAUD_RATE;
    localparam   COUNTER_SIZE        = $clog2(DIV_COUNTER+1);
    localparam   BIT_COUNTER_SIZE    = $clog2(DATA_BITS+2);
    //internal variables
    reg         [COUNTER_SIZE-1         :0]       counter; //Contador de 14 bits para baud rate, counter = clock / baud rate   
    reg         [BIT_COUNTER_SIZE-1     :0]       bitcounter, bitcounter_next; //Contador de 4 bits para contar hasta 10 
    reg                                           state, state_next;
    reg         [DATA_BITS+1            :0]       shift_reg, shift_reg_next; 
    
    reg                                           uart_tx, uart_tx_next;
    reg                                           uart_tx_done, uart_tx_done_next;

    assign o_uart_tx      = uart_tx;
    assign o_uart_tx_done = uart_tx_done;
    
    //UART transmission logic
    always @ (posedge clk, posedge reset) 
    begin 
        if (reset) begin
            state           <= IDLE;
            counter         <= 0; 
            bitcounter      <= 0; 
            uart_tx         <= 1;
            uart_tx_done    <= 1;
        end
        else begin
            counter <= counter + 1; //Comienza a contar para el baud rate generator
            if (counter >= DIV_COUNTER) begin //Cuenta hasta 10416          
              counter       <=  0;        
              state         <=  state_next;
              shift_reg     <=  shift_reg_next;
              bitcounter    <=  bitcounter_next;
              uart_tx       <=  uart_tx_next;
              uart_tx_done  <=  uart_tx_done_next;
           end
         end
    end 
    
    //state machine
    
    always @* 
    begin        
        shift_reg_next    <= shift_reg;
        uart_tx_next      <= uart_tx;
        bitcounter_next   <= bitcounter;
        uart_tx_done_next <= uart_tx_done;
        case (state)
            IDLE:
            begin 
                if (i_ready) begin // Si los datos estan listos comienza a transmitir 
                   state_next           <= TRANSMIT;
                   shift_reg_next       <= {1'b1,i_data,1'b0}; //Cargo 8 bits de datos
                end 
                else begin // Si no hay datos listos queda esperando
                   state_next           <= IDLE;
                   uart_tx_next         <= 1; 
                   uart_tx_done_next    <= 1;
                end
            end
            TRANSMIT:
            begin  
                if (bitcounter >= 10) begin // Si se transmitieron 10 bits vuelve a IDLE
                    state_next          <= IDLE; 
                    bitcounter_next     <= 0;
                end 
                else begin //Si la transmision no completo envia el siguiente bit
                    state_next          <=  TRANSMIT; 
                    uart_tx_done_next   <=  0;
                    uart_tx_next        <=  shift_reg[0]; 
                    shift_reg_next      <=  shift_reg >> 1; // Mueve el shift register en 1 bit
                    bitcounter_next     <=  bitcounter + 1;
                end
            end
            default: 
                state_next <= IDLE;                      
        endcase
    end

endmodule

