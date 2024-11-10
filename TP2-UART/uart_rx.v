module uart_rx 
  #(parameter Bits = 8,
    parameter s_IDLE         = 3'b000,
  parameter s_RX_START_BIT = 3'b001,
  parameter s_RX_DATA_BITS = 3'b010,
  parameter s_RX_STOP_BIT  = 3'b011,
  parameter s_CLEANUP      = 3'b100)
  (
   input        i_Clock,
   input        i_Rx_Serial,    // para instancia de test, para pasar dato a comparar
   input        i_bd,
   input        i_reset,
   output       o_Rx_Done,
   output [7:0] o_Rx_Byte       // ve el dato a comparar
   //output [7:0] RsRx
   );
    
  reg [7:0]     r_Clock_Count = 0;
  reg [3:0]     r_Bit_Index   = 0; //8 bits total
  reg [7:0]     r_Rx_Byte     = 0;
  reg           r_Rx_done       = 0;
  reg [2:0]     r_next_state     = 0;
  reg [3:0]     r_current_state = 0;
   
  // Purpose: Control RX state machine
  always @(posedge i_Clock)
      begin
      if(i_reset) 
        begin
            r_current_state <= s_IDLE;
        end
      else  r_current_state<=r_next_state;
      
      case (r_current_state)
        s_IDLE :
          begin
            r_Rx_done       <= 1'b0;
            r_Bit_Index   <= 0;
          end
        
        // Check middle of start bit to make sure it's still low
        s_RX_START_BIT :
          begin
          end // case: s_RX_START_BIT
        // Wait CLKS_PER_BIT-1 clock cycles to sample serial data
        s_RX_DATA_BITS :
          begin
            if (i_bd)
              begin
                r_Rx_Byte[r_Bit_Index] <= i_Rx_Serial;
                // Check if we have received all bits
                if (r_Bit_Index < 7)
                  begin
                    r_Bit_Index <= r_Bit_Index + 1;                   
                  end
                else
                  begin
                    r_Bit_Index <= 0;
                  end
              end
          end // case: s_RX_DATA_BITS
     
     
        // Receive Stop bit.  Stop bit = 1
        s_RX_STOP_BIT :
          begin
            if (i_bd)
              begin
                    r_Rx_done       <= 1'b1;         
              end
          end // case: s_RX_STOP_BIT
     
         
        // Stay here 1 clock
        s_CLEANUP :
          begin
            r_Rx_done   <= 1'b0;
          end
         
         
        default :
          r_current_state <= s_IDLE;
         
      endcase
    end
    
    
     // Purpose: Control RX state machine
  always @(*)
      begin
          if(i_reset) 
            begin
                r_next_state = s_IDLE;
            end     
          case (r_current_state)
            s_IDLE :
              begin
                if (i_Rx_Serial == 1'b0)          // Start bit detected
                  r_next_state = s_RX_START_BIT;
                else
                  r_next_state = s_IDLE;
              end
             
            // Check middle of start bit to make sure it's still low
            s_RX_START_BIT :
              begin
               if (i_bd)
                    begin
                        r_next_state     = s_RX_DATA_BITS;
                    end
               else
                  begin
                    r_next_state     = s_RX_START_BIT;
                  end
               end // case: s_RX_START_BIT
             
             
            // Wait CLKS_PER_BIT-1 clock cycles to sample serial data
            s_RX_DATA_BITS :
              begin
                if (~i_bd)
                  begin
                    r_next_state     = s_RX_DATA_BITS;
                  end
                else
                    begin    
                   // Check if we have received all bits
                    if (r_Bit_Index < 7)
                      begin
                        r_next_state   = s_RX_DATA_BITS;
                      end
                    else
                      begin
                        r_next_state   = s_RX_STOP_BIT;
                      end
                  end
              end // case: s_RX_DATA_BITS
         
         
            // Receive Stop bit.  Stop bit = 1
            s_RX_STOP_BIT :
              begin
                // Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
                if (~i_bd)
                  begin
                    r_next_state     = s_RX_STOP_BIT;
                  end
                else
                  begin
                    r_next_state = s_CLEANUP;
                  end
              end // case: s_RX_STOP_BIT
         
            // Stay here 1 clock
            s_CLEANUP :
              begin
                r_next_state = s_IDLE;
              end
            default :
              r_next_state = s_IDLE;
        endcase
      end   
   
  assign o_Rx_Done   = r_Rx_done;
  assign o_Rx_Byte = r_Rx_Byte;
   
endmodule // uart_rx
