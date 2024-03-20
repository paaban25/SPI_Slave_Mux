module Slave_MUX(input rst, sclk, cs, mosi, output miso, oen);
  
  wire [7:0] miso_im;
  wire [7:0] oen_im;

  genvar num;
  generate
    for (num = 0; num < 8; num = num + 1) begin : Modules
      SPI_Slave Slave (
        .mosi(mosi),
        .cs(cs),
        .sclk(sclk),
        .rst(rst),
        .addr(num[2:0]), 
        .miso_oe(oen_im[num]),
        .miso(miso_im[num])
      );
    end
  endgenerate

  SPIMux Mux (
    .miso_in(miso_im),
    .oen_in(oen_im),
    .oen_out(oen),
    .miso_out(miso)
  );
endmodule
