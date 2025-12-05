`timescale 1ns / 1ps
module rotor (
    input  logic clk,
    input  logic reset,
    input  logic load_config, 
    input  logic [4:0] init_pos,  
    input  logic enable, 
    
    //dus
    input  logic [4:0] char_in_fwd,
    output logic [4:0] char_out_fwd,
    //intors
    input  logic [4:0] char_in_bwd,
    output logic [4:0] char_out_bwd,
    
    output logic notch_pulse
);
    //forward
    const logic [4:0] MAP_FWD [0:25] = '{
        4, 10, 12, 5, 11, 6, 3, 16, 21, 25, 13, 19, 14, 22, 24, 7, 23, 20, 18, 15, 0, 8, 1, 17, 2, 9
    };
    //backward
    const logic [4:0] MAP_BWD [0:25] = '{
        20, 22, 24, 6, 0, 3, 5, 15, 21, 25, 1, 4, 2, 10, 12, 19, 7, 23, 18, 11, 17, 8, 13, 16, 14, 9
    };

    localparam NOTCH_POS = 5'd16; 
    logic [4:0] stare_curenta;

    always_ff @(posedge clk) begin
        if (reset) begin
            stare_curenta <= 0; //A
            notch_pulse <= 0;
        end else if (load_config) begin
            stare_curenta <= init_pos;
        end else if (enable) begin
            if (stare_curenta == 25) 
                stare_curenta <= 0;
            else 
                stare_curenta <= stare_curenta + 1;
            if (stare_curenta == NOTCH_POS) // daca am ajuns la 16 insemna ca trebuie sa rotesc rotorul 2
                notch_pulse <= 1;
            else 
                notch_pulse <= 0;
        end else begin
            notch_pulse <= 0;
        end
    end

    //dus
    always_comb begin
        logic [4:0] index_fwd;
        logic [4:0] mapped_fwd;
        logic [4:0] result_fwd;
        index_fwd = (char_in_fwd + stare_curenta); 
        if (index_fwd >= 26) index_fwd = index_fwd - 26; 
        mapped_fwd = MAP_FWD[index_fwd]; // -> cripteaza
        if (mapped_fwd >= stare_curenta)
            result_fwd = mapped_fwd - stare_curenta;
        else
            result_fwd =(mapped_fwd+26)-stare_curenta;

        char_out_fwd = result_fwd;
    end
    always_comb begin
        logic [4:0] index_bwd;
        logic [4:0] mapped_bwd;
        logic [4:0] result_bwd;

        index_bwd = (char_in_bwd + stare_curenta);
        if (index_bwd>=26) index_bwd=index_bwd - 26;

        mapped_bwd=MAP_BWD[index_bwd];

        if (mapped_bwd>=stare_curenta)
            result_bwd=mapped_bwd - stare_curenta;
        else
            result_bwd =(mapped_bwd+26)-stare_curenta;

        char_out_bwd=result_bwd;
    end

endmodule
