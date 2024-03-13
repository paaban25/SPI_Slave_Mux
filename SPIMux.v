module SPIMux(
  input [7:0] miso_in,
  input [7:0] oen_in,
  output  oen_out,
  output reg miso_out
);

  // Logic for oen_out
  assign oen_out = |oen_in;

  // Logic for miso_out
  always @*
    case (oen_in)
      8'b00000001: miso_out <= miso_in[0]; 
      8'b00000010: miso_out <= miso_in[1]; 
      8'b00000100: miso_out <= miso_in[2]; 
      8'b00001000: miso_out <= miso_in[3]; 
      8'b00010000: miso_out <= miso_in[4]; 
      8'b00100000: miso_out <= miso_in[5]; 
      8'b01000000: miso_out <= miso_in[6]; 
      8'b10000000: miso_out <= miso_in[7];
      default: miso_out <= 1'b0;
    endcase

endmodule