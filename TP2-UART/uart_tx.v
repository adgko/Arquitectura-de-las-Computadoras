`timescale 1ns / 1ps

module uart_tx 
#(
    parameter MAXTAM = 8, 
    parameter BIT_COUNTER = 3 
)
(
    input wire i_clk,               
    input wire i_reset,             
    input wire i_Tx_Start,         
    input wire i_bd,              
    input wire [(MAXTAM-1):0] i_Tx_Byte,   
    output wire o_Tx_Done,      
    output wire o_Tx_Serial                

);

localparam TICKS_MUESTREO = 16;          

//ESTADOS (One-Hot)
localparam [3:0]
    IDLE     =   4'b0001,        //Estado de espera
    START    =   4'b0010,        //Estado de transmision de start bit 
    DATA     =   4'b0100,        //Estado de transmision de data bits
    STOP     =   4'b1000;        //Estado de transmision de stop bit


//VARIABLES LOCALES
reg      r_tx_serial,            r_tx_serial_next;         
reg      r_Tx_Done,           r_Tx_Done_Next;   
reg[3:0] r_current_state,     r_next_state;       
reg[3:0] ticks_count,       ticks_count_next;  
reg[(BIT_COUNTER-1):0] r_Bit_Index,    r_Bit_Index_Next;  
reg[(MAXTAM-1):0]       r_Tx_Data,     r_Tx_Data_Next;   



always @ (posedge i_clk)
begin
    if (i_reset) begin
        r_current_state   <= IDLE;
        ticks_count     <= 0;
        r_Bit_Index      <= 0;
        r_Tx_Data      <= 0;
        r_tx_serial          <= 1; //~start
        r_Tx_Done         <= 0;
    end
    else begin
        r_current_state   <= r_next_state;
        ticks_count     <= ticks_count_next;
        r_Bit_Index      <= r_Bit_Index_Next;
        r_Tx_Data      <= r_Tx_Data_Next;
        r_Tx_Done         <= r_Tx_Done_Next;
        r_tx_serial          <= r_tx_serial_next;
    end
end


always @(*) begin

    r_next_state          = r_current_state; 
    ticks_count_next    = ticks_count;
    r_Bit_Index_Next     = r_Bit_Index;
    r_Tx_Data_Next     = r_Tx_Data;
    r_Tx_Done_Next = r_Tx_Done;

    case(r_current_state)
        IDLE: begin
            //tx_done_next = 0; ///probar en board
            r_tx_serial_next = 1; //~start
            if ( i_Tx_Start )
            begin
                r_next_state          = START;
                ticks_count_next    = 0;             
                r_Tx_Data_Next     = i_Tx_Byte;  
            end
        end

        START: begin
            r_Tx_Done_Next= 0;
            r_tx_serial_next = 0; 
            if( i_bd ) begin
                if (ticks_count == (TICKS_MUESTREO - 1)) 
                    begin
                        r_next_state          = DATA;
                        ticks_count_next    = 0; 
                        r_Bit_Index_Next     = 0; 
                    end
                else
                    ticks_count_next        = ticks_count + 1;
            end
        end

        DATA: begin
            r_tx_serial_next= r_Tx_Data[0];
            if ( i_bd ) begin
                if (ticks_count == (TICKS_MUESTREO - 1) ) begin
                        ticks_count_next    = 0;                 
                        r_Tx_Data_Next     = r_Tx_Data >> 1;    //sig bit 
                        if ( r_Bit_Index == (MAXTAM-1) )  
                                r_next_state  = STOP;               //se envio la trama
                        else
                            r_Bit_Index_Next = r_Bit_Index + 1;
                    end
                else 
                    ticks_count_next = ticks_count + 1; 
            end
        end

        STOP: begin
            r_tx_serial_next = 1; //bit de stop es un 1
            if ( i_bd ) begin
                if ( ticks_count == (TICKS_MUESTREO - 1) ) begin
                    r_next_state       = IDLE;
                    r_Tx_Done_Next     = 1;       //termino de enviar
                end
                else 
                    ticks_count_next = ticks_count + 1; 
            end
        end

        default: begin
            r_tx_serial_next     = 1; //Evitar envio erroneo
            r_next_state  = IDLE; 
        end
    endcase
end


assign o_Tx_Serial = r_tx_serial;
assign o_Tx_Done = r_Tx_Done;

endmodule