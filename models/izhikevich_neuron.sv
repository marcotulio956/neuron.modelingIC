module calc_v #(parameter DT) (
    input [31:0] vn, in, un,
    output [31:0] v
);
    reg [31:0] coeff3 = 8'h3d23d70a; // 0.04 dec
    reg [31:0] coeff2 = 8'h40a00000; // 5 dec
    reg [31:0] coeff1 = 8'h430c0000; // 140 dec

    wire [31:0] m1_out, m2_out, m3_out, m4_out;
    wire [31:0] a1_out, a2_out, a3_out, a4_out;
    wire [31:0] s1_out; 

    _fmultp_ M1(coeff3, vn, m1_out); 
    _fmultp_ M2(m1_out, vn, m2_out); 
    _fmultp_ M3(coeff2, vn, m3_out);
    _fadder_ A1(m2_out, m3_out, a1_out);
    _fadder_ S1(coeff1, negate(un), s1_out);
    _fadder_ A2(in, s1_out, a2_out);
    _fadder_ A3(a1_out, a2_out, a3_out);
    _fmultp_ M4(a3_out, dt, m4_out);
    _fadder_ A4(m4_out, vn, a4_out);
    
    assign v = a4_out;
endmodule
module calc_u #(parameter [31:0] A=0, B=0, DT=0) (
    input [31:0] vn, un, 
    output [31:0] u
);
    wire [31:0] m1_out, m2_out, m3_out;
    wire [31:0] a1_out;
    wire [31:0] s1_out; 

    _fmultp_ M1(vn, b, m1_out);
    _fadder_ S1(m1_out, negate(un), s1_out);
    _fmultp_ M2(s1_out, a, m2_out);
    _fmultp_ M3(m2_out, dt, m3_out);
    _fadder_ A1(m3_out, un, a1_out);

    assign u = a1_out;
endmodule
module izhikevich_neuron #(parameter [31:0] A=0, B=0, C=0, D=0, DT=0) (
    input clk, rst, input [31:0] vi, ui,
    output reg [31:] vn, in, un
);  
    reg [31:0] v, u;
    reg [31:0] v_next, u_next;

    wire [31:0] v1_out, u1_out;

    wire [31:0] ge = 8'h41f00000; // 30 dec 

    calc_v V1 #(DT) (vn, in, un, v1_out);
    calc_u U1 #(A, B) (vn, un, u1_out);

    // if v>= 30 then begin v_next = c; u_next = u = u + d; end else begin v = v_next; u = u_next; end

    always_ff @( posedge clk or posedge rst) begin : NXTS
        if(rst) begin
            v <= vi;
            u <= ui;
        end else begin
            v <= v_next;
            u <= u_next;
        end
    end
endmodule