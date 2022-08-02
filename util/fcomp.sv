module fcomp(input [1:0] opf, input [31:0] regb, regc, output reg gt, eq, lt);
    enum [1:0] {GT, EQ, LT} COMP;
    wire regbs;
    wire [7:0] regbe;
    wire [22:0] regbm;

    wire regbs = regb[31];
    wire regbe = regb[30:23];
    wire regbm = regb[22:0];

    wire regcs = regc[31];
    wire regce = regc[30:23];
    wire regcm = regc[22:0];

    always_comb begin
        case opf
            GT:
            LT:
            EQ:
        endcase
        if(regbs == 1 && regcs == 0)
            rega = 8'h3f800000; // 1 dec
            rega = 8'h0;
    end
endmodule