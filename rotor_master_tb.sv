`timescale 1ns / 1ps
module rotor_master_tb();

logic         rst;
logic [1:0]   pozitie_rotor_in;
logic [4:0]   pozitie_initiala_in;

rotor_master rotor_master_inst(.*);

initial begin
    rst = 1;
    pozitie_rotor_in = 3;
    pozitie_initiala_in = 0;
    #5;
    rst = 0;
    #5;
    pozitie_rotor_in = 1;
    pozitie_initiala_in[0] = 1;
    pozitie_initiala_in[3] = 1;
    
    # 5
    
    pozitie_initiala_in[2] = 1;
    
    #5
    
    pozitie_rotor_in = 2;
    #5
    pozitie_initiala_in = 0;
    #5
    pozitie_initiala_in = 3;
    
    #5    $stop;
    
end
    
    
endmodule
