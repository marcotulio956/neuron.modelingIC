module tb_neuron;
    localparam DT = 8'h3a83126f; // 0.001

    localparam M65 = 8'hc2820000; // -65
    localparam M55 = 8'hc25c0000; // -55
    localparam M50 = 8'hc2480000; // -50
    localparam P002 = 8'h3ca3d70a; // 0.02
    localparam P005 = 8'h3d4ccccd; // 0.05
    localparam  P01 = 8'h3dcccccd; // 0.1
    localparam  P02 = 8'h3e4ccccd; // 0.2
    localparam  P025 = 8'h3e800000; // 0.25
    localparam  P026 = 8'h3e851eb8; // 0.26
    localparam  P2 = 8'h40000000; // 2
    localparam  P4 = 8'h40800000; // 4
    localparam  P8 = 8'h41000000; // 8

    enum {RS, IB, CH FS, TC, RZ, LTS} dynamic;

    reg clk, rst;
    reg [31:0] vi, ui;
    wire [31:0] a, b, c, d;
    wire [31:0] vn, in, un;

    typedef struct {
        bit [31:0] a, // recovery var time scale
        b, // recovery var sensitivity
        c, // after-spike rst value of v
        d; // after-spike rst value of u
    } param_set;
    param_set parameters[dynamic];

    assign a = parameters[dynamic].a;
    assign b = parameters[dynamic].b;
    assign c = parameters[dynamic].c;
    assign d = parameters[dynamic].d;

    initial forever begin clk = 0; #1; clk = 1; #1; end

    initial begin : RST
        rst = 1;
        @(negedge clk);
        rst = 0;
    end : RST

    initial begin : INIT_PARAM
        parameters[RS].a = P002;
        parameters[RS].b = P02;
        parameters[RS].c = M65;
        parameters[RS].d = M8;
        
        parameters[IB].a = P002;
        parameters[IB].b = P02;
        parameters[IB].c = M55;
        parameters[IB].d = P4;
        
        parameters[CH].a = P002;
        parameters[CH].b = P02;
        parameters[CH].c = M50;
        parameters[CH].d = P2;

        parameters[FS].a = P01;
        parameters[FS].b = P02;
        parameters[FS].c = M65;
        parameters[FS].d = P2;

        parameters[TC].a = P002;
        parameters[TC].b = P025;
        parameters[TC].c = M65;
        parameters[TC].d = P005;
        
        parameters[RZ].a = P01;
        parameters[RZ].b = P026;
        parameters[RZ].c = M65;
        parameters[RZ].d = P2;
        
        parameters[LTS].a = P002;
        parameters[LTS].b = P025;
        parameters[LTS].c = M65;
        parameters[LTS].d = P2;
    end : INIT_PARAM
    
    // initial begin : IT_DYNAMIC// DECLARE PROGRAM
    //     dynamic it;

    //     foreach(parameters[it]) begin
    //         //run_test(it);
    //     end
        
    // end : IT_DYNAMIC



    izhikevich_neuron _neuron_ #(
        .A(a), .B(b), .C(c), .D(d), .DT(DT)
    ) (
        .(*)
    );

endmodule