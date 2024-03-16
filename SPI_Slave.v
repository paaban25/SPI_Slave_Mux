// Code your design here
`timescale 1ns / 1ps

module SPI_Slave(
    input mosi, sclk, cs, rst,
    input [2:0] addr,
    output reg miso_oe, miso
);

reg [7:0] Register [7:0];  // Internal Register Bank

initial begin 
    Register[0] = 8'h12;
    Register[1] = 8'h52;
    Register[2] = 8'h35;
    Register[3] = 8'h35;
    Register[4] = 8'h36;
    Register[5] = 8'h75;
    Register[6] = 8'h46;
    Register[7] = 8'h39;
end

reg WR;
reg [2:0] EXT_ADDR;
reg [2:0] REG_ADDR;
reg FUTURE;  // Register to extract from words

reg [4:0] COUNTER = 5'b10000;

always @(posedge sclk) begin
    if (rst | !cs) begin
        miso_oe <= 1'b0;
        miso <= 1'bZ; 
        COUNTER<=5'b00000;
    end
    else begin
        case (COUNTER)
            5'b10000: WR <= mosi;
            5'b01111: EXT_ADDR[0] <= mosi;
            5'b01110: EXT_ADDR[1] <= mosi;
            5'b01101: EXT_ADDR[2] <= mosi;
            5'b01100: FUTURE <= mosi;
            5'b01011: REG_ADDR[0] <= mosi;
            5'b01010: REG_ADDR[1] <= mosi;
            5'b01001: REG_ADDR[2] <= mosi;
            5'b01000, 5'b00111, 5'b00110, 5'b00101, 5'b00100, 5'b00011, 5'b00010, 5'b00001:
                begin
                    if (addr != EXT_ADDR) begin
                        miso_oe <= 1'b0;
                        miso <= 1'bZ; 
                    end
                    else begin
                        if (WR) begin
                            miso = Register[REG_ADDR][COUNTER-1];
                            Register[REG_ADDR][COUNTER-1] = mosi;
                            miso_oe = 1'b1;
                        end
                        else begin
                            miso = Register[REG_ADDR][0];
                            Register[REG_ADDR] = {Register[REG_ADDR][0], Register[REG_ADDR][7:1]};
                            miso_oe <= 1'b1;
                        end
                    end
                end
            default: 
                begin 
                    COUNTER = 5'b01001; 
                    if (REG_ADDR == 3'b111)
                        REG_ADDR = 3'b000;
                    else
                        REG_ADDR = REG_ADDR + 3'b001;
                end  
        endcase
        COUNTER = COUNTER - 5'b00001;
    end
end

endmodule
