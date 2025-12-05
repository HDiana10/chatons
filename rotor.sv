module rotor#(
    parameter [4:0] NOTCH_POS = 16, // Default: Rotor I (Notch la Q = 16)
    
    parameter [4:0] MAP_FWD [0:25] = '{
        4, 10, 12, 5, 11, 6, 3, 16, 21, 25, 13, 19, 14, 22, 24, 7, 23, 20, 18, 15, 0, 8, 1, 17, 2, 9
    },
    parameter [4:0] MAP_BWD [0:25] = '{
        20, 22, 24, 6, 0, 3, 5, 15, 21, 25, 1, 4, 2, 10, 12, 19, 7, 23, 18, 11, 17, 8, 13, 16, 14, 9
    }
)(
    input  logic clk, // -> ceas
    input  logic reset, // -> reset
    
    input  logic set_in,   // -> SET
    input  logic [4:0] init_pos_in,      // -> pozitia initiala setata de pe placuta
    input  logic step_enable_in,   // -> semnal ca pot sa rotesc rotorul 
    input  logic [4:0] char_fwd_in,   // -> litera intare rotor (necriptata) dus
    output logic [4:0] char_fwd_out,  // -> litera iesire (criptata) dus 
    
    input  logic [4:0] char_bwd_in,   // -> litera intare rotor (necriptata) intors
    output logic [4:0] char_bwd_out,  // -> litera iesire (criptata) intors
    output logic [4:0] current_pos_out,   // -> pozitie curenta
    output logic notch_pulse_out,    // -> step_enable rotor2, ii zice sa pote sa se roteasca
    output logic [4:0] start_pos // -> pozitia de start
);

    logic [4:0] start_pos_reg;
    assign start_pos = start_pos_reg;
    
    
    always_ff @(posedge clk) begin
        if (reset) begin // -> reseteaza tot la 'A'
            current_pos_out <= 5'd0;      
            notch_pulse_out <= 1'b0;
        end 
        else if (set_in) begin // pozitia de start este valoarea initiala data de pe placuta
            current_pos_out <= init_pos_in; 
            notch_pulse_out <= 1'b0;
        end 
        else if (step_enable_in) begin
            if (current_pos_out == NOTCH_POS+1)
                notch_pulse_out <= 1'b1;   // ii ziceam rotorului2 sa se roteasca
            else
                notch_pulse_out <= 1'b0;
            if (current_pos_out == 25) 
                current_pos_out <= 0;
            else 
                current_pos_out <= current_pos_out + 1;
        end 
        else begin
            notch_pulse_out <= 1'b0;
        end
    end
    
    always_comb begin
        logic [4:0] idx, val_mapped, res;
        
        // idx -> intexul care trebuie mapat
        //val_mapped -> valoarea de dupa mapare
          
        idx=char_fwd_in+current_pos_out;
        if (idx >= 26) idx = idx-26;
        val_mapped = MAP_FWD[idx];
        if (val_mapped >= current_pos_out)
            res=val_mapped-current_pos_out;
        else
            res=(val_mapped+26)-current_pos_out;
        char_fwd_out=res;
    end

    always_comb begin
        logic [4:0] idx_b, val_mapped_b, res_b;
        
        idx_b=char_bwd_in+current_pos_out;
        if (idx_b>=26) idx_b=idx_b-26;

        val_mapped_b=MAP_BWD[idx_b];

        if (val_mapped_b>=current_pos_out)
            res_b=val_mapped_b-current_pos_out;
        else
            res_b=(val_mapped_b+26)-current_pos_out;
            
        char_bwd_out=res_b;
    end

endmodule