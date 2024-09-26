`timescale 1ns / 1ns
module tb_alu();
    
  parameter maxtam = 8;
  parameter tam_OP = 6;

  reg [maxtam-1:0] A;
  reg [maxtam-1:0] B;
  reg [tam_OP-1:0] OP;
  reg start, clk;

  wire [maxtam-1:0] ALU_Out;

///////////////////////////////////////////
  initial begin
  #0    A = {maxtam{1'b0}};
        B = {maxtam{1'b0}};
        OP = {tam_OP{1'b0}};
        start=1'b0;
        clk=1'b0;
  #10  start=1'b1;
  #200;
  $display("############# Test OK ############");
  $finish();
  end

///////////////////////////////////////////
//Module instance
  alu #(
    .MAXTAM(maxtam),
    .OPCODE(tam_OP)
  )
  alu_0 (
    .A(A),
    .B(B),
    .OP(OP),
    .ALU_Result(ALU_Out)
  );
///////////////////////////////////////////

// Clock generation
  always #20 clk = ~clk;

// Random data:
  always @(posedge clk) begin
    A <= $random();
    B <= 10;
  end

// OPCode data: 
  always begin
    #20 OP <= 6'b10_0000;//suma
    #20 OP <= 6'b10_0010;//resta
    #20 OP <= 6'b10_0100;//AND
    #20 OP <= 6'b10_0101;//OR
    #20 OP <= 6'b10_0110;//XOR
    #20 OP <= 6'b10_0111;//NOR
    #20 OP <= 6'b00_0010;//Desplazamiento lógico hacia Der.
    #20 OP <= 6'b00_0011;//Desplazamiento aritmético hacia Der.
  end//end_always

///////////////////////////////////////////////////////////////////////////
// Check Module Output:
  always @(posedge clk or negedge clk) begin
  $timeformat(-9,0,"ns");
    if(start) begin
      case(OP)
        6'b10_0000: begin //suma
           $display("[%0t] -> %d + %d = %d", $realtime, A,B,ALU_Out);
           if(ALU_Out != (A+B)) $display("Suma FAIL");
           else $display("Suma OK");
        end //suma
        6'b10_0010: begin //resta
           $display("[%0t] -> %d - %d = %d", $realtime, A,B,ALU_Out);
           if(ALU_Out != (A-B)) $display("Resta FAIL");
           else $display("Resta OK");
        end //resta
        6'b10_0100: begin //AND
           $display("[%0t] -> %b & %b = %b", $realtime, A,B,ALU_Out);
           if(ALU_Out != (A&B)) $display("AND FAIL");
           else $display("AND OK");
        end //AND
        6'b10_0101: begin //OR
           $display("[%0t] -> %b | %b = %b", $realtime, A,B,ALU_Out);
           if(ALU_Out != (A|B)) $display("OR FAIL");
           else $display("OR OK");
        end //OR
        6'b10_0110: begin //XOR
           $display("[%0t] -> %b ^ %b = %b", $realtime, A,B,ALU_Out);
           if(ALU_Out != (A^B)) $display("XOR FAIL");
           else $display("XOR OK");
        end //XOR
        6'b10_0111: begin //NOR
           $display("[%0t] -> ~(%b | %b) = %b", $realtime, A,B,ALU_Out);
           if(ALU_Out != ~(A|B)) $display("NOR FAIL");
           else $display("NOR OK");
        end //NOR
        6'b00_0010: begin //Desplazamiento lógico hacia Der
           $display("[%0t] -> %b >> %b = %b", $realtime, A,B,ALU_Out);
           if(ALU_Out != (A>>B)) $display("Despl.lógico hacia Der. FAIL");
           else $display("Despl.lógico Der. OK");
        end //Desplazamiento lógico hacia Der
        6'b00_0011: begin //Desplazamiento aritmético hacia Der.
           $display("[%0t] -> %b >>> %b = %b", $realtime, A,B,ALU_Out);
           if(ALU_Out != (A>>>B)) $display("Despl.aritmético Der. FAIL");
           else $display("Despl.aritmético hacia Der. OK");
        end //Desplazamiento aritmético hacia Der.
        
        default:  $display("OPCode no reconocido");
      endcase
    end//endif_start
  end//always
///////////////////////////////////////////////////////////////////////////
  
endmodule
