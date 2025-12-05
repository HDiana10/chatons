module vga_enigma_display(
    input clk, rst,
    input [4:0] char_orig, // Index 0-25 (A-Z)
    input [4:0] char_enc,  // Index 0-25 (A-Z)
    input valid,           // Semnal ca s-a apasat o tasta
    output logic hsync, vsync,
    output logic [3:0] red, green, blue
);

    // --- 1. GENERARE CEAS PIXEL (25 MHz) ---
    logic [1:0] clk_div;
    logic pixel_clk;
    
    always_ff @(posedge clk) clk_div <= clk_div + 1;
    assign pixel_clk = clk_div[1]; // 100MHz / 4 = 25MHz

    // --- 2. NUMARATOARE VSYNC/HSYNC (640x480) ---
    logic [9:0] h_cnt, v_cnt;
    
    always_ff @(posedge pixel_clk) begin
        if (rst) begin
            h_cnt <= 0; v_cnt <= 0;
        end else begin
            if (h_cnt < 799) h_cnt <= h_cnt + 1;
            else begin
                h_cnt <= 0;
                if (v_cnt < 524) v_cnt <= v_cnt + 1;
                else v_cnt <= 0;
            end
        end
    end
    
    assign hsync = ~(h_cnt >= 656 && h_cnt < 752);
    assign vsync = ~(v_cnt >= 490 && v_cnt < 492);
    
    logic active_area;
    assign active_area = (h_cnt < 640 && v_cnt < 480);

    // --- 3. LOGICA AFISARE TEXT ---
    
    // Definim doua zone pe ecran unde desenam literele
    // Vom mari literele de 16 ori (Scale x16). Fontul e 8x8 => Litera pe ecran va fi 128x128 pixeli.
    
    // Zona 1 (Stanga - Original): X intre 100 si 228
    logic in_rect_orig;
    assign in_rect_orig = (h_cnt >= 100 && h_cnt < 228) && (v_cnt >= 176 && v_cnt < 304);

    // Zona 2 (Dreapta - Criptat): X intre 412 si 540
    logic in_rect_enc;
    assign in_rect_enc = (h_cnt >= 412 && h_cnt < 540) && (v_cnt >= 176 && v_cnt < 304);

    // Calculam coordonatele relative in interiorul literei (0..7 pentru font)
    // Shiftam cu 4 biti (diviziune cu 16) pentru a face scalarea
    logic [2:0] font_row, font_col;
    logic [4:0] current_char_idx;
    
    always_comb begin
        if (in_rect_orig) begin
            current_char_idx = char_orig;   // Ce litera desenam?
            font_col = (h_cnt - 100) >> 4;  // Scalare X
            font_row = (v_cnt - 176) >> 4;  // Scalare Y
        end else if (in_rect_enc) begin
            current_char_idx = char_enc;
            font_col = (h_cnt - 412) >> 4;
            font_row = (v_cnt - 176) >> 4;
        end else begin
            current_char_idx = 0;
            font_col = 0;
            font_row = 0;
        end
    end

    // --- 4. INSTANTIERE FONT ROM ---
    logic [7:0] font_data; // O linie de pixeli din litera
    logic pixel_on;        // 1 daca pixelul curent e alb, 0 altfel

    font_rom my_font (
        .char_index(current_char_idx),
        .row_index(font_row),
        .row_data(font_data)
    );

    // Verificam daca bitul curent din font este 1
    // font_col 0 este cel mai semnificativ bit (7), deci inversam indexarea
    assign pixel_on = (in_rect_orig || in_rect_enc) ? font_data[7 - font_col] : 1'b0;

    // --- 5. LOGICA CULORI (Flash + Text) ---
    logic [25:0] flash_counter;
    logic flash_active;

    always_ff @(posedge clk) begin
        if (valid) flash_counter <= 26'd50_000_000; // 0.5 sec
        else if (flash_counter > 0) flash_counter <= flash_counter - 1;
    end
    assign flash_active = (flash_counter > 0);

    always_comb begin
        if (!active_area) begin
            red = 0; green = 0; blue = 0;
        end else begin
            if (pixel_on) begin
                // Desenam TEXTUL (Alb)
                red = 4'hF; green = 4'hF; blue = 4'hF;
            end else begin
                // Desenam FUNDALUL
                if (flash_active) begin
                    red = 0; green = 4'h8; blue = 0; // Verde inchis cand tastezi
                end else begin
                    red = 0; green = 0; blue = 4'h8; // Albastru inchis in repaus
                end
            end
        end
    end

endmodule