`timescale 1ns / 1ps

module reflector_tb;

    logic [4:0] char_in;
    logic [4:0] char_out;

    reflector_ukw_b dut (
        .char_in(char_in),
        .char_out(char_out)
    );
    
    integer i;
    logic [4:0] inapoi;
    
    initial begin
        char_in = 5'd0; //a->y
        #10; 
        char_in = 5'd1;//b->r
        #10;
        for (i = 0; i < 26; i = i + 1) begin
            char_in = i[4:0];
            #10;
            inapoi = char_out; 
            char_in = inapoi;
            #10;
        end
       
        char_in = 5'd30;
        #10;
        $stop;
    end

endmodule