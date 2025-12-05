`timescale 1ns / 1ps

module test_top_tb;

    logic clk;
    logic reset;
    logic load_config;
    logic step_enable;
    logic [4:0] init_r1;
    logic [4:0] init_r2;
    logic [4:0] init_r3;
    logic [4:0] char_in;
    logic [4:0] char_out;

    test_top dut (
        .clk(clk),
        .reset(reset),
        .load_config(load_config),
        .step_enable(step_enable),
        .init_pos_r1(init_r1),
        .init_pos_r2(init_r2),
        .init_pos_r3(init_r3),
        .char_in(char_in),
        .char_out(char_out)
    );

    always #5 clk = ~clk;

    task press_key(input logic [4:0] val);
        begin
            char_in = val;
            step_enable = 1;
            @(posedge clk);
            step_enable = 0;
            repeat(5) @(posedge clk);
            // Am scos afisarea rotoarelor (p1, p2, p3) ca nu le mai avem
            $display("In: %c | Out: %c", (char_in + 65), (char_out + 65));
        end
    endtask

    initial begin
        clk = 0;
        reset = 1;
        load_config = 0;
        step_enable = 0;
        char_in = 0;
        init_r1 = 0; init_r2 = 0; init_r3 = 0;
        
        #20 reset = 0;

        load_config = 1; 
        @(posedge clk);
        load_config = 0;
        
        press_key(0);
        press_key(0);
        press_key(0);
        press_key(0);
        press_key(0);

        load_config = 1;
        @(posedge clk);
        load_config = 0;

        press_key(1);
        press_key(3);
        press_key(25);
        press_key(6);
        press_key(14);

        $stop;
    end
endmodule