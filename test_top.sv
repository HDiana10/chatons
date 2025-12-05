module test_top (
    input  logic clk,
    input  logic reset,
    input  logic load_config,
    input  logic step_enable,
    input  logic [4:0] init_pos_r1,
    input  logic [4:0] init_pos_r2,
    input  logic [4:0] init_pos_r3,
    input  logic [4:0] char_in,
    output logic [4:0] char_out
);

    logic [4:0] w_r1_to_r2_fwd;
    logic [4:0] w_r2_to_r3_fwd;
    logic [4:0] w_r3_to_refl;
    
    logic [4:0] w_refl_to_r3;
    logic [4:0] w_r3_to_r2_bwd;
    logic [4:0] w_r2_to_r1_bwd;
    
    logic notch_pulse_1_to_2; 
    logic notch_pulse_2_to_3;

    rotor R1 (
        .clk(clk),
        .reset(reset),
        .set_in(load_config),
        .init_pos_in(init_pos_r1),
        .step_enable_in(step_enable),
        .char_fwd_in(char_in),
        .char_fwd_out(w_r1_to_r2_fwd),
        .char_bwd_in(w_r2_to_r1_bwd),
        .char_bwd_out(char_out),
        .current_pos_out(), // Lasat liber (neconectat)
        .notch_pulse_out(notch_pulse_1_to_2),
        .start_pos() 
    );

    rotor #(
        .NOTCH_POS(5'd4),
        .MAP_FWD('{0, 9, 3, 10, 18, 8, 17, 20, 23, 1, 11, 7, 22, 19, 12, 2, 16, 6, 25, 13, 15, 24, 5, 21, 14, 4}),
        .MAP_BWD('{0, 9, 15, 2, 25, 22, 17, 11, 5, 1, 3, 10, 14, 19, 24, 20, 16, 6, 4, 13, 7, 23, 12, 8, 21, 18})
    ) R2 (
        .clk(clk),
        .reset(reset),
        .set_in(load_config),
        .init_pos_in(init_pos_r2),
        .step_enable_in(notch_pulse_1_to_2),
        .char_fwd_in(w_r1_to_r2_fwd),
        .char_fwd_out(w_r2_to_r3_fwd),
        .char_bwd_in(w_r3_to_r2_bwd),
        .char_bwd_out(w_r2_to_r1_bwd),
        .current_pos_out(), // Lasat liber
        .notch_pulse_out(notch_pulse_2_to_3),
        .start_pos()
    );

    rotor #(
        .NOTCH_POS(5'd21),
        .MAP_FWD('{1, 3, 5, 7, 9, 11, 2, 15, 17, 19, 23, 21, 25, 13, 24, 4, 8, 22, 6, 0, 10, 12, 20, 18, 16, 14}),
        .MAP_BWD('{19, 0, 6, 1, 15, 2, 18, 3, 16, 4, 20, 5, 21, 13, 25, 7, 24, 8, 23, 9, 22, 11, 17, 10, 14, 12})
    ) R3 (
        .clk(clk),
        .reset(reset),
        .set_in(load_config),
        .init_pos_in(init_pos_r3),
        .step_enable_in(notch_pulse_2_to_3),
        .char_fwd_in(w_r2_to_r3_fwd),
        .char_fwd_out(w_r3_to_refl),
        .char_bwd_in(w_refl_to_r3),
        .char_bwd_out(w_r3_to_r2_bwd),
        .current_pos_out(), // Lasat liber
        .notch_pulse_out(),
        .start_pos()
    );

    reflector_ukw_b Refl (
        .char_in(w_r3_to_refl),
        .char_out(w_refl_to_r3)
    );

endmodule