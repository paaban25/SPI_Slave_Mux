module SPIMux_TB;

  // Inputs
  reg [7:0] miso_in;
  reg [7:0] oen_in;
  
  // Outputs
  wire oen_out;
  wire miso_out;
  
  // Instantiate the module under test
  SPIMux uut (
    .miso_in(miso_in),
    .oen_in(oen_in),
    .oen_out(oen_out),
    .miso_out(miso_out)
  );
  
  // Clock generation
  reg clk;
  always #10 clk = ~clk; // Clock period of 10 time units
  
  // Stimulus
  initial begin
    // Initialize inputs
    miso_in = 8'b00000000;
    oen_in = 8'b00000000;
    
    // Open VCD file
    $dumpfile("sim_dump.vcd");
    $dumpvars(0, SPIMux_TB);
    
    // Apply stimulus
    #10 miso_in = 8'b11010010; // Set some random data on miso_in
    #10 oen_in = 8'h01; // Select first chip
    #10 oen_in = 8'h02; // Select second chip
    #10 oen_in = 8'h04; // Select third chip
    #10 oen_in = 8'h08; // Select fourth chip
    #10 oen_in = 8'h10; // Select fifth chip
    #10 oen_in = 8'h20; // Select sixth chip
    #10 oen_in = 8'h40; // Select seventh chip
    #10 oen_in = 8'h80; // Select eighth chip
    #10 oen_in = 8'h01; // Select first chip
    #10 oen_in = 8'h02; // Select second chip
    #10 oen_in = 8'h04; // Select third chip
    #10 oen_in = 8'h08; // Select fourth chip
    #10 oen_in = 8'h10; // Select fifth chip
    #10 oen_in = 8'h20; // Select sixth chip
    #10 oen_in = 8'h40; // Select seventh chip
    #10 oen_in = 8'h80; // Select eighth chip    
    // End simulation
    #100 $finish;
  end
  
  // Monitor miso_out whenever oen_in changes
  always @(oen_in) begin
    $display("Time=%0t, Selected MISO Data: %b", $time, miso_out);
  end
  
endmodule