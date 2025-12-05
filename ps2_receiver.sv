module ps2_receiver(
    input clk,             // Ceasul placutei (100MHz)
    input kclk,            // Pinul PS2 Clock
    input kdata,           // Pinul PS2 Data
    output logic [7:0] keycode, // Codul tastei citit
    output logic key_valid      // Semnal (puls) cand datele sunt gata
);
    logic [3:0] count = 0;
    logic [10:0] shift_reg = 0;
    logic [1:0] kclk_sync;

    // Sincronizare semnal asincron PS2 cu ceasul intern
    always_ff @(posedge clk) begin
        kclk_sync <= {kclk_sync[0], kclk};
    end

    wire kclk_falling = (kclk_sync == 2'b10); // Detectam front descrescator

    always_ff @(posedge clk) begin
        if (kclk_falling) begin
            shift_reg <= {kdata, shift_reg[10:1]};
            if (count == 10) count <= 0;
            else count <= count + 1;
        end
    end

    always_ff @(posedge clk) begin
        if (kclk_falling && count == 10) begin
            keycode <= shift_reg[8:1];
            key_valid <= 1;
        end else begin
            key_valid <= 0;
        end
    end
endmodule