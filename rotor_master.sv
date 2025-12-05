`timescale 1ns / 1ps
module rotor_master(
        input logic rst,
        input logic [1:0] pozitie_rotor_in,
        input logic [4:0] pozitie_initiala_in
    );
    

logic set; // imi spune daca am datele necesare pentru a configura rotoarele
asign enable = (pozitie_rotor_in == 2'b11);

logic [4:0] pozitie_initiala_rotor_1, pozitie_initiala_rotor_2, pozitie_initiala_rotor_3;

/// ====== INSTANTIERI MODULE ========
// Configurarea rotoarelor

rotor_config #(.ROTOR_POS(0)) rotor_config_1
(
    .rst(rst),                 
    .pozitie_initiala_in(pozitie_initiala_in), 
    .pozitie_rotor_in(pozitie_rotor_in),
    .pozitie_initiala_out(pozitia_innitiala_rotor_1) 
);
rotor_config #(.ROTOR_POS(1)) rotor_config_2(
    .rst(rst),                 
    .pozitie_initiala_in(pozitie_initiala_in), 
    .pozitie_rotor_in(pozitie_rotor_in),
    .pozitie_initiala_out(pozitia_innitiala_rotor_2)
);
rotor_config #(.ROTOR_POS(2)) rotor_config_3(
    .rst(rst),                 
    .pozitie_initiala_in(pozitie_initiala_in), 
    .pozitie_rotor_in(pozitie_rotor_in),
    .pozitie_initiala_out(pozitia_innitiala_rotor_2)
);

/*
rotor rotor_inst_1();
rotor rotor_inst_2();
rotor rotor_inst_3();

*/



endmodule
