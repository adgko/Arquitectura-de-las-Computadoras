module uart_rx
    #(
        parameter MAXTAM = 8,
        parameter BIT_COUNTER = 3 
    )
    (
        input wire i_clk,
        input wire i_reset,
        input wire i_Rx_Serial,
        input wire i_bd,
        output reg o_Rx_Done,
        output wire [(MAXTAM-1):0] o_Rx_Byte
    );


localparam TICKS_OVERSAMPLING = 16;  //Ticks de muestreo
localparam SYNC_TICKS = 7;         //Ticks de sinc


//ESTADOS (One-Hot)
localparam [3:0]
    IDLE     =   4'b0001,        //Estado de espera
    START    =   4'b0010,        //Estado de recepcion de start bit 
    DATA     =   4'b0100,        //Estado de recepcion de data bits
    STOP     =   4'b1000;        //Estado de recepcion de stop bit


//VARIABLES LOCALES
reg[3:0] r_current_state,                     r_next_state;             
reg[3:0] ticks_count,                       ticks_count_next;            
reg[(BIT_COUNTER-1):0] r_Bit_Index,     next_r_Bit_Index;           
reg[(MAXTAM-1):0]       data,           data_next;              
 

always @(posedge i_clk) begin

    if (i_reset) begin
        r_current_state   <= IDLE;
        ticks_count     <= 0;
        r_Bit_Index      <= 0;
        data            <= 0;
    end
    else begin
        r_current_state   <= r_next_state;
        ticks_count     <= ticks_count_next;
        r_Bit_Index      <= next_r_Bit_Index;
        data            <= data_next;
    end
end

always @(*) begin

    r_next_state          = r_current_state;
    o_Rx_Done           = 1'b0;
    ticks_count_next    = ticks_count;
    next_r_Bit_Index     = r_Bit_Index;
    data_next           = data;

    case (r_current_state)
        IDLE: begin
            if( ~i_Rx_Serial ) begin
                r_next_state          = START;
                ticks_count_next    = 0;
            end
        end

        START: begin
            if( i_bd ) begin
                if( ticks_count == SYNC_TICKS ) begin
                    r_next_state          = DATA;
                    ticks_count_next    = 0;
                    next_r_Bit_Index     = 0;
                end
                else
                    ticks_count_next    = ticks_count + 1;
            end
        end
        DATA: begin
            if( i_bd )begin
                if( ticks_count == (TICKS_OVERSAMPLING - 1) ) begin
                    ticks_count_next    = 0;
                    data_next           = {i_Rx_Serial, data[(MAXTAM-1):1]};
                    if( r_Bit_Index == (MAXTAM-1) )
                        r_next_state      = STOP;
                    else
                        next_r_Bit_Index = r_Bit_Index + 1;
                end
                else
                    ticks_count_next    = ticks_count + 1;
            end
        end
        STOP: begin
            if( i_bd ) begin
                if( ticks_count == (TICKS_OVERSAMPLING - 1) ) begin
                    r_next_state      = IDLE;
                    o_Rx_Done       = 1'b1;
                end
                else
                    ticks_count_next = ticks_count + 1;
            end
        end
    endcase   
end


assign o_Rx_Byte = data;
endmodule