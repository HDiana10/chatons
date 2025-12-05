`timescale 1ns / 1ps
module rotor_master(
        input logic         rst,
        input logic         clk,
        // input logic         set,
        input logic [1:0]   pozitie_rotor_in,
        input logic [4:0]   pozitie_initiala_in,
        
        output logic [6:0]  display,
        output logic [7:0]  an
);    

// logic set; // imi spune daca am datele necesare pentru a configura rotoarele
// assign enable = (pozitie_rotor_in == 2'b11);

logic [4:0] pozitie_initiala_rotor_1, pozitie_initiala_rotor_2, pozitie_initiala_rotor_3;
logic [6:0] display_1_1, display_1_2, display_2_1, display_2_2, display_3_1, display_3_2;

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

/*
rotor rotor_inst_1();
rotor rotor_inst_2();
rotor rotor_inst_3();

*/

/// === counter pentru a afisa =====

logic [7:0] counter;

always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
        counter <= 0;
        an <= 0;
    end
    else begin
        counter = (counter + 1) % 8000;
        an <= 0;
        if(counter < 1000) begin
            an[0] <= 1;
            display <= display_1_2;
        end
        else if(counter < 2000) begin
            an[1] = 1;
            display <= display_1_1;
        end
        else if(counter < 3000) begin
            display <= display_2_2;
            an[3] <= 1;
        end
        
        else if(counter < 4000) begin
            an[4] <= 1;
            display <= display_2_1;
        end
        else if(counter < 5000) begin
            an[6] <= display_3_2;
        end
        else if(counter < 6000) begin
            an[7] <= display_3_1;
        end
    end
end

endmodule
