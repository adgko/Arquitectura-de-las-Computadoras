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
  reg [3:0]    r_Bit_Index   = 0;
  reg [3:0]    last_r_Bit_Index   = 0;
  reg [7:0]    r_Tx_Data     = 0;
  reg [7:0]    last_r_Tx_Data     = 0;
  reg          r_Tx_Done     = 0;
  reg          last_r_Tx_Done    ;
  reg          r_Tx_Active   = 0;
  reg          last_r_Tx_Active ;
  reg [3:0]    r_current_state = 0;
  reg [3:0]    r_next_state = 0;
  reg r_Tx_Serial=1;
  reg last_r_Tx_Serial=1;
 
     
     
  //si hay cambio de tick, agrega uno al contador
 /* always @(posedge i_Clock)
   begin
    if(i_bd) begin
        tick_count_aux = tick_count_reg+1;
    end
   end*/
     
    always @(posedge i_Clock)
        begin
        r_Tx_Active <= last_r_Tx_Active;
        r_Tx_Serial <= last_r_Tx_Serial;
        r_Tx_Done <= last_r_Tx_Done;
        r_Bit_Index <= last_r_Bit_Index;
        r_Tx_Data <= last_r_Tx_Data;
        if(i_reset) begin
            r_current_state <= s_IDLE;
        end
        else begin
            r_current_state <=r_next_state;
        end
        end
    
    always @(*) begin
        r_next_state=r_current_state;
        last_r_Tx_Active=r_Tx_Active;
        last_r_Tx_Serial = r_Tx_Serial;
        last_r_Tx_Done = r_Tx_Done;
        last_r_Bit_Index = r_Bit_Index;
        last_r_Tx_Data = r_Tx_Data;
        case (r_current_state)
        s_IDLE :
          begin
            last_r_Tx_Done     = 1'b0;
            last_r_Bit_Index   = 0;
            last_r_Tx_Active   = 1'b0;

            if (i_Tx_Start == 1'b1)
              begin
                last_r_Tx_Active = 1'b1;
                r_next_state   = s_TX_START_BIT;
              end
            else r_next_state = s_IDLE;
          end // case: s_IDLE
         
         
        // Send out Start Bit. Start bit = 0
        s_TX_START_BIT :
          begin
            // Wait CLKS_PER_BIT-1 clock cycles for start bit to finish
            if (i_bd)
              begin
                last_r_Tx_Serial = 1'b0;
                last_r_Tx_Data   = i_Tx_Byte;
                r_next_state     = s_TX_DATA_BITS;
              end
            else r_next_state     = s_TX_START_BIT;
          end // case: s_TX_START_BIT
         
        // Wait CLKS_PER_BIT-1 clock cycles for data bits to finish         
        s_TX_DATA_BITS :
          begin
        
            if (i_bd)
              begin
                last_r_Tx_Serial = last_r_Tx_Data[last_r_Bit_Index];
                // Check if we have sent out all bits         
                if (last_r_Bit_Index < 7)
                  begin
                    last_r_Bit_Index = last_r_Bit_Index + 1;
                    r_next_state   = s_TX_DATA_BITS;
                  end
                else
                  begin
                    last_r_Bit_Index = 0;
                    r_next_state   = s_TX_STOP_BIT;
                  end
              end
            else r_next_state     = s_TX_DATA_BITS;
          end // case: s_TX_DATA_BITS
         
         
        // Send out Stop bit.  Stop bit = 1
        s_TX_STOP_BIT :
          begin
            // Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
            if (i_bd)
              begin
                last_r_Tx_Serial = 1'b1;
                last_r_Tx_Done     = 1'b1;
                r_next_state     = s_CLEANUP;
              end
            else    r_next_state     = s_TX_STOP_BIT;

          end // case: s_Tx_STOP_BIT
         
        // Stay here 1 clock
        s_CLEANUP :
          begin
            last_r_Tx_Done = 1'b0;
            last_r_Tx_Serial   = 1'b1;         // Drive Line High for Idle
            r_next_state = s_IDLE;
          end
         
         
        default :
          begin
            last_r_Tx_Serial   = 1'b1;         // Drive Line High for Idle
            last_r_Tx_Done     = 1'b0;
            last_r_Bit_Index   = 0;
            r_next_state = s_IDLE;
          end
         
      endcase
    end
 
  assign o_Tx_Active = r_Tx_Active;
  assign o_Tx_Done   = r_Tx_Done;
  assign o_Tx_Serial=r_Tx_Serial;
   
endmodule
