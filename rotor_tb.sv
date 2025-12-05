`timescale 1ns / 1ps

module rotor_tb;

    localparam [4:0] NOTCH_POS = 16;
    logic clk;
    logic reset;
    logic set_in;
    logic [4:0] init_pos_in;
    logic step_enable_in;
    logic [4:0] char_fwd_in;
    logic [4:0] char_bwd_in;
    logic [4:0] char_fwd_out;
    logic [4:0] char_bwd_out;
    logic [4:0] current_pos_out;
    logic notch_pulse_out;
    logic [4:0] start_pos;

    rotor #(
        .NOTCH_POS(NOTCH_POS)
    ) dut (
        .clk(clk),
        .reset(reset),
        .set_in(set_in),
        .init_pos_in(init_pos_in),
        .step_enable_in(step_enable_in),
        .char_fwd_in(char_fwd_in),
        .char_fwd_out(char_fwd_out),
        .char_bwd_in(char_bwd_in),
        .char_bwd_out(char_bwd_out),
        .current_pos_out(current_pos_out),
        .notch_pulse_out(notch_pulse_out),
        .start_pos(start_pos)
    );

    initial begin
        clk = 0;
        forever #5 clk=~clk;
    end

    initial begin
        reset=1;
        set_in=0;
        init_pos_in=0;
        step_enable_in=0;
        char_fwd_in=0; 
        char_bwd_in=0; 
        
        #20; 
        reset=0;

        #10;
        init_pos_in=5'd1; 
        set_in=1;        
        #10;
        set_in=0;       
        #10;
        
        char_fwd_in=5'd0; 
        #10;
        step_enable_in = 1; 
        
        repeat(20) begin
            @(posedge clk); 
        end
        
        step_enable_in = 0;
        $stop; 
    end
endmodule