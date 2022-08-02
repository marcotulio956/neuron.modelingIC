module reciprocal (input [31:0] regb, output [31:0] rega);
	wire [31:0] D;
	wire [31:0] N0, N1, N2;
	wire [31:0] C1; //C1 = 48/17
	wire [31:0] C2; //C2 = 32/17
	wire [31:0] C3; //C3 = 2.0
	wire [31:0] S0_2D_out;
	wire [31:0] S1_DN0_out;
	wire [31:0] S1_2min_DN0_out;
	wire [31:0] S2_DN1_out;
	wire [31:0] S2_2minDN1_out;
	wire [31:0] S0_N0_in;
	
	assign rega[31] = regb[31];
	assign rega[22:0] = N2[22:0];
	assign rega[30:23] = (D==9'b100000000)? 9'h102 - regb[30:23] : 9'h101 - regb[30:23];

	assign D = {1'b0, 8'h80, regb[22:0]};

	assign C1 = 32'h4034B4B5;
	assign C2 = 32'h3FF0F0F1;
	assign C3 = 32'h40000000;

	assign S0_N0_in = {~S0_2D_out[31], S0_2D_out[30:0]};

	fmultp S0_2D(
		.regb(C2),
		.regc(D),
		.rega(S0_2D_out)
	);

	fadder S0_N0(
		.regb(C1),
		.regc(S0_N0_in),
		.rega(N0)
	);

	fmultp S1_DN0(
		.regb(D),
		.regc(N0),
		.rega(S1_DN0_out)
	);

	fadder S1_2minDN0(
		.regb(C3),
		.regc({~S1_DN0_out[31], S1_DN0_out[30:0]}),
		.rega(S1_2min_DN0_out)
	);

	fmultp S1_N1(
		.regb(N0),
		.regc(S1_2min_DN0_out),
		.rega(N1)
	);

	fmultp S2_DN1(
		.regb(D),
		.regc(N1),
		.rega(S2_DN1_out)
	);

	fadder S2_2minDN1(
		.regb(C3),
		.regc({~S2_DN1_out[31], S2_DN1_out[30:0]}),
		.rega(S2_2minDN1_out)
	);

	fmultp S2_N2(
		.regb(N1),
		.regc(S2_2minDN1_out),
		.rega(N2)
	);
endmodule
module fdvidr(input [31:0] regb, regc, output [31:0] rega);
	wire [31:0] regc_reciprocal;

	reciprocal recp(
		.regb(regc),
		.rega(regc_reciprocal)
	);
	fmultp _fmultp_(// div is just regc^-1
		.regb(regb),
		.regc(regc_reciprocal),
		.rega(rega)
	);
endmodule