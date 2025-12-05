`timescale 1ns / 1ps
module rotor_master(
        input logic         rst,
        input logic         clk,
        input logic         set,
        input logic [1:0]   pozitie_rotor_in,
        input logic [4:0]   pozitie_initiala_in,
        // Tastatura
        input logic ps2_clk,
        input logic ps2_data,
        
        // afisaj 7seg
        output logic [6:0]  display,
        output logic [7:0]  an,
        
        // VGA Output
        output logic [3:0]  vgaRed, vgaGreen, vgaBlue,
        output logic        Hsync, Vsync
);    
//////////// ======= Semnale Interne ======
// Semnale Interconectare Rotoare (Firele prin care trec literele)
// FWD = Drumul dus, BWD = Drumul intors
logic [4:0] r1_fwd_out, r2_fwd_out, r3_fwd_out;
logic [4:0] reflector_out;
logic [4:0] r3_bwd_out, r2_bwd_out, r1_bwd_out; // r1_bwd_out este REZULTATUL FINAL

// Semnale Rotoare (Pozitii curente - se schimba cand tastezi)
    logic [4:0] current_pos_r1, current_pos_r2, current_pos_r3;
    
// Semnale Notch (Impulsuri de rotire)
logic notch1, notch2;
logic step_enable;
    
// Tastatura
logic [7:0] key_scan_code;
logic       key_valid;   // semnal de la tastatura
logic [4:0] char_index_in;
logic       is_letter;
logic       valid_keystroke; // semnal filtrat
logic       ignore_next;       // variabila interna pt filtrare

parameter [4:0] MAP_FWD_1 [0:25] = '{4, 10, 12, 5, 11, 6, 3, 16, 21, 25, 13, 19, 14, 22, 24, 7, 23, 20, 18, 15, 0, 8, 1, 17, 2, 9};
parameter [4:0] MAP_BWD_1 [0:25] = '{20, 22, 24, 6, 0, 3, 5, 15, 21, 25, 1, 4, 2, 10, 12, 19, 7, 23, 18, 11, 17, 8, 13, 16, 14, 9};
parameter [4:0] MAP_FWD_2 [0:25] = '{0, 9, 3, 10, 18, 8, 17, 20, 23, 1, 11, 7, 22, 19, 12, 2, 16, 6, 25, 13, 15, 24, 5, 21, 14, 4};
parameter [4:0] MAP_BWD_2 [0:25] = '{0, 9, 15, 2, 25, 22, 17, 11, 5, 1, 3, 10, 14, 19, 24, 20, 16, 6, 4, 13, 7, 23, 12, 8, 21, 18};
parameter [4:0] MAP_FWD_3 [0:25] = '{1, 3, 5, 7, 9, 11, 2, 15, 17, 19, 23, 21, 25, 13, 24, 4, 8, 22, 6, 0, 10, 12, 20, 18, 16, 14};
parameter [4:0] MAP_BWD_3 [0:25] = '{19, 0, 6, 1, 15, 2, 18, 3, 16, 4, 20, 5, 21, 13, 25, 7, 24, 8, 23, 9, 22, 11, 17, 10, 14, 12};
parameter [4:0] NOTCH1 = 16, NOTCH2 =4, NOTCH3 = 21;


// logic set; // imi spune daca am datele necesare pentru a configura rotoarele
// assign enable = (pozitie_rotor_in == 2'b11);

logic [4:0] pozitie_initiala_rotor_1, pozitie_initiala_rotor_2, pozitie_initiala_rotor_3;
logic [6:0] display_1_1, display_1_2, display_2_1, display_2_2, display_3_1, display_3_2, blank;
/// ====== INSTANTIERI MODULE ========
// Configurarea rotoarelor

rotor_config #(.ROTOR_POS(2'b00)) rotor_config_1
(
    .rst(rst),                 
    .pozitie_initiala_in(pozitie_initiala_in), 
    .pozitie_rotor_in(pozitie_rotor_in),
    .pozitie_initiala_out(pozitie_initiala_rotor_1) 
);
rotor_config #(.ROTOR_POS(2'b01)) rotor_config_2(
    .rst(rst),                 
    .pozitie_initiala_in(pozitie_initiala_in), 
    .pozitie_rotor_in(pozitie_rotor_in),
    .pozitie_initiala_out(pozitie_initiala_rotor_2)
);
rotor_config #(.ROTOR_POS(2'b10)) rotor_config_3(
    .rst(rst),                 
    .pozitie_initiala_in(pozitie_initiala_in), 
    .pozitie_rotor_in(pozitie_rotor_in),
    .pozitie_initiala_out(pozitie_initiala_rotor_3)
);

display_7seg display_inst_1_1(
    .in(pozitie_initiala_rotor_1 / 10),
    .out(display_1_1)
);

display_7seg display_inst_1_2(
    .in(pozitie_initiala_rotor_1 % 10),
    .out(display_1_2)
);

display_7seg display_inst_2_1(
    .in(pozitie_initiala_rotor_2 / 10),
    .out(display_2_1)
);

// A. Driver PS2
 ps2_receiver kbd_driver_inst(
        .clk(clk),
        .kclk(ps2_clk),
        .kdata(ps2_data),
        .keycode(key_scan_code),
        .key_valid(key_valid_pulse)
 );
 
// B. Logic? de filtrare (ACEASTA LIPSEA!)
    // Transform? key_valid_pulse (care apare de 3 ori) intr-un singur puls valid_keystroke
    always_ff @(posedge clk) begin
        if (rst) begin
            ignore_next <= 0;
            valid_keystroke <= 0;
        end else if (key_valid_pulse) begin
            if (key_scan_code == 8'hF0) begin
                ignore_next <= 1;     // Detectam cod de Release
                valid_keystroke <= 0;
            end else if (ignore_next) begin
                ignore_next <= 0;     // Ignoram codul de dupa Release
                valid_keystroke <= 0;
            end else begin
                valid_keystroke <= 1; // Apasare Valida!
            end
        end else begin
            valid_keystroke <= 0;
        end
    end
// C. Conversie ScanCode -> Index (0-25)
    scancode_to_index converter (
        .scan_code(key_scan_code),
        .char_index(char_index_in),
        .is_letter(is_letter)
    );

// Activam pasul rotorului doar daca e litera si e apasare valida
assign step_enable = valid_keystroke && is_letter;


display_7seg display_inst_2_2(
    .in(pozitie_initiala_rotor_2 % 10),
    .out(display_2_2)
);

display_7seg display_inst_3_1(
    .in(pozitie_initiala_rotor_3 / 10),
    .out(display_3_1)
);

display_7seg display_inst_3_2(
    .in(pozitie_initiala_rotor_3 % 10),
    .out(display_3_2)
);

rotor #(    .NOTCH_POS(NOTCH1),
            .MAP_FWD(MAP_FWD_1),
            .MAP_BWD(MAP_BWD_1)
)rotor_inst_1(
    .clk(clk),   
    .reset(rst),   
                         
    .set_in(set), 
    .init_pos_in(pozitie_initiala_rotor_1),   
    .step_enable_in(step_enable), 
    .char_fwd_in(char_index_in),   
    .char_fwd_out(r1_fwd_out),  
                         
    .char_bwd_in(r2_bwd_out),   
    .char_bwd_out(r1_bwd_out),  
    .current_pos_out(current_pos_r1),
    .notch_pulse_out(notch1),
    .start_pos()
);
rotor #(    .NOTCH_POS(NOTCH2),
            .MAP_FWD(MAP_FWD_2),
            .MAP_BWD(MAP_BWD_2)
)rotor_inst_2(
    .clk(clk),   
    .reset(rst),   
                         
    .set_in(set), 
    .init_pos_in(pozitie_initiala_rotor_2),   
    .step_enable_in(notch1),
    .char_fwd_in(r1_fwd_out),   
    .char_fwd_out(r2_fwd_out),  
                         
    .char_bwd_in(r3_bwd_out),   
    .char_bwd_out(r2_bwd_out),  
    .current_pos_out(current_pos_r2),
    .notch_pulse_out(notch2),
    .start_pos()
);

rotor #(    .NOTCH_POS(NOTCH3),
            .MAP_FWD(MAP_FWD_3),
            .MAP_BWD(MAP_BWD_3)
)rotor_inst_3(
    .clk(clk),   
    .reset(rst),   
                         
    .set_in(set), 
    .init_pos_in(pozitie_initiala_rotor_3),   
    .step_enable_in(notch2), 
    .char_fwd_in(r2_fwd_out),   
    .char_fwd_out(r3_fwd_out),  
                         
    .char_bwd_in(reflector_out),   
    .char_bwd_out(r3_bwd_out),  
    .current_pos_out(current_pos_r3),
    .notch_pulse_out(),
    .start_pos()
);


// --- REFLECTOR (B) ---
    reflector_ukw_b reflector_inst (
        .char_in(r3_fwd_out),     // Vine de la Rotor 3 (drumul dus)
        .char_out(reflector_out)  // Se intoarce in Rotor 3 (drumul intors)
    );

/// === counter pentru a afisa =====

// 100.000.000 Hz / 2^17 ~= 762 Hz (Refresh rate)
logic [16:0] refresh_counter;
logic [2:0]  digit_select;

always_ff @(posedge clk or posedge rst) begin
    if (rst) 
        refresh_counter <= 0;
    else 
        refresh_counter <= refresh_counter + 1;
end

    // Folosim cei mai semnificativi 3 biti pentru a selecta unul din cei 8 anozi
    assign digit_select = refresh_counter[16:14];

    always_comb begin
        // Reset default values (stins)
        an = 8'b11111111;      // Anozii sunt Active LOW (1 = Stins)
        display = 7'b1111111;  // Segmentele sunt Active LOW (1 = Stins)

        case (digit_select)
            // Grupul 1 (Dreapta) - Rotor 1
            3'b000: begin an[0] = 0; display = display_1_2; end // Unitati
            3'b001: begin an[1] = 0; display = display_1_1; end // Zeci
            
            // Grupul 2 (Mijloc) - Rotor 2
            3'b011: begin an[3] = 0; display = display_2_2; end
            3'b100: begin an[4] = 0; display = display_2_1; end

            // Grupul 3 (Stanga) - Rotor 3
            3'b110: begin an[6] = 0; display = display_3_2; end
            3'b111: begin an[7] = 0; display = display_3_1; end
            
            // Digitii nefolositi (2 si 5) raman stinsi (default)
            default: begin 
                an = 8'b11111111; 
                display = 7'b1111111; 
            end
        endcase
    end
    
    
    
 /// =============
 /// VGA OUTPUT
 /// =============
 
 vga_enigma_display vga_inst(
    .clk(clk),
    .rst(rst),
    .char_orig(char_index_in),
    .char_enc(r1_bwd_out),
    .valid(step_enable),
    .hsync(Hsync),
    .vsync(Vsync),
    .red(vgaRed),
    .green(vgaGreen),
    .blue(vgaBlue)
 );
endmodule
