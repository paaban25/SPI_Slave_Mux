`timescale 1ns / 1ps

module SPI_Slave(
    input mosi, sclk, cs, rst,
    input [2:0] addr,
    output reg miso_oe, miso
);

reg [7:0] Register [7:0];  // Internal Register Bank

reg WR;
reg [2:0] EXT_ADDR;
reg [2:0] REG_ADDR;
reg FUTURE;  // Register to extract from words

reg [4:0] COUNTER = 5'b10000;

always @(posedge sclk) begin
    if (rst | !cs) begin
        miso_oe <= 1'b0;
        miso <= 1'bZ; 
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
                            Register[REG_ADDR] <= {mosi, Register[REG_ADDR][7:1]};
                            miso_oe <= 1'b1;
                            miso <= 1'bZ; 
                        end
                        else begin
                            miso <= Register[REG_ADDR][0];
                            miso_oe <= 1'b1;
                        end
                    end
                end
            default: COUNTER = 5'b10001;  
        endcase
        COUNTER = COUNTER - 5'b00001;
    end
end

endmodule