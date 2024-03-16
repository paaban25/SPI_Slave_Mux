// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples
 `timescale 1ns / 1ps
 
 module tb_SPI_Slave();
 
     // Inputs
     reg mosi,  cs, rst;
     reg [2:0] addr;
     
     // Outputs
     wire miso_oe, miso;
 
     // Instantiate the SPI_Slave module
     SPI_Slave dut (
         .mosi(mosi),
         .sclk(sclk),
         .cs(cs),
         .rst(rst),
         .addr(addr),
         .miso_oe(miso_oe),
         .miso(miso)
     );
 
     // Clock generation
     reg sclk = 0;
     always #10 sclk = ~sclk;
 
     // Dump VCD file
     initial begin
         $dumpfile("dump.vcd");
         $dumpvars(0, tb_SPI_Slave);
     end
 
     // Testbench stimulus
     initial begin
         // Initialize inputs
         
         
         // Release reset
         #10 rst = 0;
         
         // Test case 1: Write to Register 0x0F
         addr = 3'b111;
         cs = 1;
         mosi = 0; //set this 0 for read and 1 for write
         #20;
       mosi = 1; // EXT_ADDR[0]
         #20;
         mosi = 1; // EXT_ADDR[1]
         #20;
       mosi = 1; // EXT_ADDR[2]
         #20;
         mosi = 0; // FUTURE
         #20;
       mosi = 1; // REG_ADDR[0]
         #20;
         mosi = 1; // REG_ADDR[1]
         #20;
       mosi = 1; // REG_ADDR[2]
         #20;
         mosi = 1; // Data bit 7
         #20;
         mosi = 0; // Data bit 6
         #20;
         mosi = 1; // Data bit 5
         #20;
         mosi = 0; // Data bit 4
         #20;
         mosi = 1; // Data bit 3
         #20;
         mosi = 1; // Data bit 2
         #20;
         mosi = 0; // Data bit 1
         #20;
         mosi = 1; // Data bit 0
         #20;
         
         
       
 
         
         // End simulation
         $finish;
     end
 endmodule
 