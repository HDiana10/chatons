module reflector_ukw_b (
    input  logic [4:0] char_in, 
    output logic [4:0] char_out  
);  
    const logic [4:0] REFLECTOR_MAP [0:25] = '{
        24, //A->Y 
        17, //B->R
        20, //C->U 
        7,  //D->H
        16, //E->Q 
        18, //F->S
        11, //G->L
        3,  //H->D
        15, //I->P
        23, //J->X
        13, //K->N
        6,  //L->G 
        14, //M->O
        10, //N->K
        12, //O->M
        8,  //P->I
        4,  //Q->E 
        1,  //R->B 
        5,  //S->F 
        25, //T->Z 
        2,  //U->C 
        22, //V->W 
        21, //W->V 
        9,  //X->J
        0,  //Y->A 
        19  //Z->T 
    };
    always_comb begin
    
        if (char_in < 26)
            char_out = REFLECTOR_MAP[char_in];
        else
            char_out = 5'd0; //->just in case
    end

endmodule