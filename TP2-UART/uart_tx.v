module uart_tx 
  #(parameter Bits = 8,
    parameter s_IDLE         = 3'b000,
  parameter s_TX_START_BIT = 3'b001,
  parameter s_TX_DATA_BITS = 3'b010,
  parameter s_TX_STOP_BIT  = 3'b011,
  parameter s_CLEANUP      = 3'b100)
  (
   input       i_Clock,
   input       i_Tx_Start,
   input [7:0] i_Tx_Byte, 
   input        i_bd,
   input        i_reset,
   output      o_Tx_Active,
   output     o_Tx_Serial,
   output      o_Tx_Done
   );
  

   
  reg [2:0]    r_SM_Main     = 0;
  reg [2:0]    r_Bit_Index   = 0;
  reg [7:0]    r_Tx_Data     = 0;
  reg          r_Tx_Done     = 0;
  reg          r_Tx_Active   = 0;
  reg [3:0]    r_current_state = 0;
  reg [3:0]    r_next_state = 0;
  reg r_Tx_Serial=1;
     
     
  //si hay cambio de tick, agrega uno al contador
 /* always @(posedge i_Clock)
   begin
    if(i_bd) begin
        tick_count_aux = tick_count_reg+1;
    end
   end*/
     
  always @(*)
    begin
       if(i_reset) begin
         r_current_state = s_IDLE;
       end
       else begin
         r_current_state=r_next_state;
       end
    end
    
   always @(*) begin
      
      case (r_current_state)
        s_IDLE :
          begin
            r_Tx_Done     = 1'b0;
            r_Bit_Index   = 0;
            r_Tx_Active   = 1'b0;

            
            if (i_Tx_Start == 1'b1)
              begin
                r_Tx_Active = 1'b1;
              end
          end // case: s_IDLE
         
         
        // Send out Start Bit. Start bit = 0
        s_TX_START_BIT :
          begin
            r_Tx_Serial = 1'b0;
             
            // Wait CLKS_PER_BIT-1 clock cycles for start bit to finish
            if (i_bd)
              begin
                r_Tx_Data   = i_Tx_Byte;
              end
          end // case: s_TX_START_BIT
         
        // Wait CLKS_PER_BIT-1 clock cycles for data bits to finish         
        s_TX_DATA_BITS :
          begin

             
            if (i_bd)
              begin
                // Check if we have sent out all bits
                r_Tx_Serial = r_Tx_Data[r_Bit_Index];

                if (r_Bit_Index < 7)
                  begin
                    r_Bit_Index = r_Bit_Index + 1;
                  end
                else
                  begin
                    r_Bit_Index = 0;
                  end
              end
          end // case: s_TX_DATA_BITS
         
         
        // Send out Stop bit.  Stop bit = 1
        s_TX_STOP_BIT :
          begin
            r_Tx_Serial = 1'b1;
             
            // Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
            if (i_bd)
              begin
                r_Tx_Done     = 1'b1;
              end
          end // case: s_Tx_STOP_BIT
         
         
        // Stay here 1 clock
        s_CLEANUP :
          begin
            r_Tx_Done = 1'b0;
            r_Tx_Serial   = 1'b1;         // Drive Line High for Idle

          end
         
         
        default :
          begin
            r_Tx_Serial   = 1'b1;         // Drive Line High for Idle
            r_Tx_Done     = 1'b0;
            r_Bit_Index   = 0;
          end
         
      endcase
    end
    
     always @(*)
    begin

      case (r_current_state)
        s_IDLE :
          begin
            if (i_Tx_Start == 1'b1)
              begin
                r_next_state   = s_TX_START_BIT;
              end
            else
              r_next_state = s_IDLE;
          end // case: s_IDLE
        
        // Send out Start Bit. Start bit = 0
        s_TX_START_BIT :
          begin
            if (~i_bd)
              begin
                r_next_state     = s_TX_START_BIT;
              end
            else
              begin
                r_next_state     = s_TX_DATA_BITS;
              end
          end // case: s_TX_START_BIT
         
         
        // Wait CLKS_PER_BIT-1 clock cycles for data bits to finish         
        s_TX_DATA_BITS :
          begin
            if (~i_bd)
              begin
                    r_next_state     = s_TX_DATA_BITS;
              end
            else
              begin
                 
                // Check if we have sent out all bits
                if (r_Bit_Index < 7)
                  begin
                    r_next_state   = s_TX_DATA_BITS;
                  end
                else
                  begin
                    r_next_state   = s_TX_STOP_BIT;
                  end
              end
          end // case: s_TX_DATA_BITS
         
         
        // Send out Stop bit.  Stop bit = 1
        s_TX_STOP_BIT :
          begin
            // Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
            if (~i_bd)
              begin
                r_next_state     = s_TX_STOP_BIT;
              end
            else
              begin
                r_next_state     = s_CLEANUP;
              end
          end // case: s_Tx_STOP_BIT
         
         
        // Stay here 1 clock
        s_CLEANUP :
          begin
            r_next_state = s_IDLE;
          end
         
        default :
          r_next_state = s_IDLE;
         
      endcase
    end 
 
  assign o_Tx_Active = r_Tx_Active;
  assign o_Tx_Done   = r_Tx_Done;
  assign o_Tx_Serial=r_Tx_Serial;
   
endmodule
