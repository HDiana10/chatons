`timescale 1ns / 1ps

module display_7seg(
    input logic [4:0] in,
    output logic [6:0] out
 );

always_comb begin
  case(in)
    4'd0: out = 7'b1000000;
    4'd1: out = 7'b1111001;
    4'd2: out = 7'b0100100;
    4'd3: out = 7'b0110000;
    4'd4: out = 7'b0011001;
    4'd5: out = 7'b0010010;
    4'd6: out = 7'b0000010;
    4'd7: out = 7'b1111000;
    4'd8: out = 7'b0000000;
    4'd9: out = 7'b0010000; // 9
    default: out = 7'b11111111;
  endcase 
end

endmodule
