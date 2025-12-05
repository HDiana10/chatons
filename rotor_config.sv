`timescale 1ns / 1ps

module rotor_config#(parameter [1:0] ROTOR_POS = 0)(
    input logic         rst,
    input logic [4:0]   pozitie_initiala_in,
    input logic [1:0]   pozitie_rotor_in, // functioneaza ca un fel de enable
    output logic [4:0]  pozitie_initiala_out
);


always_comb begin
    if(rst)
        pozitie_initiala_out = 0;
        
    else if(pozitie_rotor_in == ROTOR_POS)
        pozitie_initiala_out = pozitie_initiala_in;
end

endmodule
