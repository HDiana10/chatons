module font_rom(
    input [4:0] char_index, // 0=A, 1=B ... 25=Z
    input [2:0] row_index,  // Randul 0-7 din litera
    output logic [7:0] row_data
);
    always_comb begin
        case(char_index)
            // A
            5'd0: case(row_index)
                0: row_data = 8'h18; 1: row_data = 8'h3C; 2: row_data = 8'h66; 3: row_data = 8'h66;
                4: row_data = 8'h7E; 5: row_data = 8'h66; 6: row_data = 8'h66; 7: row_data = 8'h00;
            endcase
            // B
            5'd1: case(row_index)
                0: row_data = 8'h7C; 1: row_data = 8'h66; 2: row_data = 8'h66; 3: row_data = 8'h7C;
                4: row_data = 8'h66; 5: row_data = 8'h66; 6: row_data = 8'h7C; 7: row_data = 8'h00;
            endcase
            // C
            5'd2: case(row_index)
                0: row_data = 8'h3C; 1: row_data = 8'h66; 2: row_data = 8'h60; 3: row_data = 8'h60;
                4: row_data = 8'h60; 5: row_data = 8'h66; 6: row_data = 8'h3C; 7: row_data = 8'h00;
            endcase
            // D
            5'd3: case(row_index)
                0: row_data = 8'h78; 1: row_data = 8'h6C; 2: row_data = 8'h66; 3: row_data = 8'h66;
                4: row_data = 8'h66; 5: row_data = 8'h6C; 6: row_data = 8'h78; 7: row_data = 8'h00;
            endcase
            // E
            5'd4: case(row_index)
                0: row_data = 8'h7E; 1: row_data = 8'h60; 2: row_data = 8'h60; 3: row_data = 8'h78;
                4: row_data = 8'h60; 5: row_data = 8'h60; 6: row_data = 8'h7E; 7: row_data = 8'h00;
            endcase
            // F
            5'd5: case(row_index)
                0: row_data = 8'h7E; 1: row_data = 8'h60; 2: row_data = 8'h60; 3: row_data = 8'h78;
                4: row_data = 8'h60; 5: row_data = 8'h60; 6: row_data = 8'h60; 7: row_data = 8'h00;
            endcase
            // G
            5'd6: case(row_index)
                0: row_data = 8'h3C; 1: row_data = 8'h66; 2: row_data = 8'h60; 3: row_data = 8'h6E;
                4: row_data = 8'h66; 5: row_data = 8'h66; 6: row_data = 8'h3E; 7: row_data = 8'h00;
            endcase
            // H
            5'd7: case(row_index)
                0: row_data = 8'h66; 1: row_data = 8'h66; 2: row_data = 8'h66; 3: row_data = 8'h7E;
                4: row_data = 8'h66; 5: row_data = 8'h66; 6: row_data = 8'h66; 7: row_data = 8'h00;
            endcase
            // I
            5'd8: case(row_index)
                0: row_data = 8'h3C; 1: row_data = 8'h18; 2: row_data = 8'h18; 3: row_data = 8'h18;
                4: row_data = 8'h18; 5: row_data = 8'h18; 6: row_data = 8'h3C; 7: row_data = 8'h00;
            endcase
            // J
            5'd9: case(row_index)
                0: row_data = 8'h1E; 1: row_data = 8'h0C; 2: row_data = 8'h0C; 3: row_data = 8'h0C;
                4: row_data = 8'h0C; 5: row_data = 8'hCC; 6: row_data = 8'h78; 7: row_data = 8'h00;
            endcase
            // K
            5'd10: case(row_index)
                0: row_data = 8'h66; 1: row_data = 8'h6C; 2: row_data = 8'h78; 3: row_data = 8'h70;
                4: row_data = 8'h78; 5: row_data = 8'h6C; 6: row_data = 8'h66; 7: row_data = 8'h00;
            endcase
            // L
            5'd11: case(row_index)
                0: row_data = 8'h60; 1: row_data = 8'h60; 2: row_data = 8'h60; 3: row_data = 8'h60;
                4: row_data = 8'h60; 5: row_data = 8'h60; 6: row_data = 8'h7E; 7: row_data = 8'h00;
            endcase
            // M
            5'd12: case(row_index)
                0: row_data = 8'h66; 1: row_data = 8'h7E; 2: row_data = 8'h5A; 3: row_data = 8'h42;
                4: row_data = 8'h42; 5: row_data = 8'h42; 6: row_data = 8'h42; 7: row_data = 8'h00;
            endcase
            // N
            5'd13: case(row_index)
                0: row_data = 8'h66; 1: row_data = 8'h66; 2: row_data = 8'h76; 3: row_data = 8'h7E;
                4: row_data = 8'h6E; 5: row_data = 8'h66; 6: row_data = 8'h66; 7: row_data = 8'h00;
            endcase
            // O
            5'd14: case(row_index)
                0: row_data = 8'h3C; 1: row_data = 8'h66; 2: row_data = 8'h66; 3: row_data = 8'h66;
                4: row_data = 8'h66; 5: row_data = 8'h66; 6: row_data = 8'h3C; 7: row_data = 8'h00;
            endcase
            // P
            5'd15: case(row_index)
                0: row_data = 8'h7C; 1: row_data = 8'h66; 2: row_data = 8'h66; 3: row_data = 8'h7C;
                4: row_data = 8'h60; 5: row_data = 8'h60; 6: row_data = 8'h60; 7: row_data = 8'h00;
            endcase
            // Q
            5'd16: case(row_index)
                0: row_data = 8'h3C; 1: row_data = 8'h66; 2: row_data = 8'h66; 3: row_data = 8'h66;
                4: row_data = 8'h6A; 5: row_data = 8'h6C; 6: row_data = 8'h36; 7: row_data = 8'h00;
            endcase
            // R
            5'd17: case(row_index)
                0: row_data = 8'h7C; 1: row_data = 8'h66; 2: row_data = 8'h66; 3: row_data = 8'h7C;
                4: row_data = 8'h78; 5: row_data = 8'h6C; 6: row_data = 8'h66; 7: row_data = 8'h00;
            endcase
            // S
            5'd18: case(row_index)
                0: row_data = 8'h3C; 1: row_data = 8'h66; 2: row_data = 8'h60; 3: row_data = 8'h3C;
                4: row_data = 8'h06; 5: row_data = 8'h66; 6: row_data = 8'h3C; 7: row_data = 8'h00;
            endcase
            // T
            5'd19: case(row_index)
                0: row_data = 8'h7E; 1: row_data = 8'h18; 2: row_data = 8'h18; 3: row_data = 8'h18;
                4: row_data = 8'h18; 5: row_data = 8'h18; 6: row_data = 8'h18; 7: row_data = 8'h00;
            endcase
            // U
            5'd20: case(row_index)
                0: row_data = 8'h66; 1: row_data = 8'h66; 2: row_data = 8'h66; 3: row_data = 8'h66;
                4: row_data = 8'h66; 5: row_data = 8'h66; 6: row_data = 8'h3C; 7: row_data = 8'h00;
            endcase
            // V
            5'd21: case(row_index)
                0: row_data = 8'h66; 1: row_data = 8'h66; 2: row_data = 8'h66; 3: row_data = 8'h66;
                4: row_data = 8'h66; 5: row_data = 8'h3C; 6: row_data = 8'h18; 7: row_data = 8'h00;
            endcase
            // W
            5'd22: case(row_index)
                0: row_data = 8'h66; 1: row_data = 8'h66; 2: row_data = 8'h66; 3: row_data = 8'h5A;
                4: row_data = 8'h5A; 5: row_data = 8'h5A; 6: row_data = 8'h7E; 7: row_data = 8'h00;
            endcase
            // X
            5'd23: case(row_index)
                0: row_data = 8'h66; 1: row_data = 8'h66; 2: row_data = 8'h3C; 3: row_data = 8'h18;
                4: row_data = 8'h3C; 5: row_data = 8'h66; 6: row_data = 8'h66; 7: row_data = 8'h00;
            endcase
            // Y
            5'd24: case(row_index)
                0: row_data = 8'h66; 1: row_data = 8'h66; 2: row_data = 8'h66; 3: row_data = 8'h3C;
                4: row_data = 8'h18; 5: row_data = 8'h18; 6: row_data = 8'h18; 7: row_data = 8'h00;
            endcase
            // Z
            5'd25: case(row_index)
                0: row_data = 8'h7E; 1: row_data = 8'h06; 2: row_data = 8'h0C; 3: row_data = 8'h18;
                4: row_data = 8'h30; 5: row_data = 8'h60; 6: row_data = 8'h7E; 7: row_data = 8'h00;
            endcase
            default: row_data = 8'h00;
        endcase
    end
endmodule