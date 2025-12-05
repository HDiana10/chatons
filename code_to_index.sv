module scancode_to_index(
    input [7:0] scan_code,
    output logic [4:0] char_index,
    output logic is_letter // 1 daca e litera, 0 daca e altceva (Enter, Space etc.)
);
    always_comb begin
        is_letter = 1;
        case(scan_code)
            8'h1C: char_index = 0;  // A
            8'h32: char_index = 1;  // B
            8'h21: char_index = 2;  // C
            8'h23: char_index = 3;  // D
            8'h24: char_index = 4;  // E
            8'h2B: char_index = 5;  // F
            8'h34: char_index = 6;  // G
            8'h33: char_index = 7;  // H
            8'h43: char_index = 8;  // I
            8'h3B: char_index = 9;  // J
            8'h42: char_index = 10; // K
            8'h4B: char_index = 11; // L
            8'h3A: char_index = 12; // M
            8'h31: char_index = 13; // N
            8'h44: char_index = 14; // O
            8'h4D: char_index = 15; // P
            8'h15: char_index = 16; // Q
            8'h2D: char_index = 17; // R
            8'h1B: char_index = 18; // S
            8'h2C: char_index = 19; // T
            8'h3C: char_index = 20; // U
            8'h2A: char_index = 21; // V
            8'h1D: char_index = 22; // W
            8'h22: char_index = 23; // X
            8'h35: char_index = 24; // Y
            8'h1A: char_index = 25; // Z
            default: begin 
                char_index = 0; 
                is_letter = 0; 
            end
        endcase
    end
endmodule