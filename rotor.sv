module rotor #(
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
    
    input  logic load_config,   // -> ??
    input  logic [4:0] init_pos,      // -> pozitia initiala setata de pe placuta
    input  logic step_enable,   // -> semnal ca pot sa rotesc rotorul 
    input  logic [4:0] char_in_fwd,   // -> litera intare rotor (necriptata) dus
    output logic [4:0] char_out_fwd,  // -> litera iesire (criptata) dus 
    
    input  logic [4:0] char_in_bwd,   // -> litera intare rotor (necriptata) intors
    output logic [4:0] char_out_bwd,  // -> litera iesire (criptata) intors
    output logic [4:0] current_pos,   // -> pozitie curenta
    output logic notch_pulse,    // -> step_enable rotor2, ii zice sa pote sa se roteasca
    output logic [4:0] start_pos // -> pozitia de start
);
    
    
    always_ff @(posedge clk) begin
        if (reset) begin // -> reseteaza tot la 'A'
            current_pos <= 5'd0;      
            notch_pulse <= 1'b0;
        end 
        else if (load_config) begin // pozitia de start este valoarea initiala data de pe placuta
            current_pos <= init_pos; 
            notch_pulse <= 1'b0;
        end 
        else if (step_enable) begin
            if (current_pos == NOTCH_POS+1)
                notch_pulse <= 1'b1;   // ii ziceam rotorului2 sa se roteasca
            else
                notch_pulse <= 1'b0;
            if (current_pos == 25) 
                current_pos <= 0;
            else 
                current_pos <= current_pos + 1;
        end 
        else begin
            notch_pulse <= 1'b0;
        end
    end
    
    always_comb begin
        logic [4:0] idx, val_mapped, res;
        
        // idx -> intexul care trebuie mapat
        //val_mapped -> valoarea de dupa mapare
          
        idx=char_in_fwd+current_pos;
        if (idx >= 26) idx = idx-26;
        val_mapped = MAP_FWD[idx];
        if (val_mapped >= current_pos)
            res=val_mapped-current_pos;
        else
            res=(val_mapped+26)-current_pos;
        char_out_fwd=res;
    end

    always_comb begin
        logic [4:0] idx_b, val_mapped_b, res_b;
        
        idx_b=char_in_bwd+current_pos;
        if (idx_b>=26) idx_b=idx_b-26;

        val_mapped_b=MAP_BWD[idx_b];

        if (val_mapped_b>=current_pos)
            res_b=val_mapped_b-current_pos;
        else
            res_b=(val_mapped_b+26)-current_pos;
            
        char_out_bwd=res_b;
    end

endmodule