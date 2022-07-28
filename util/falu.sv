module falu(input [1:0] opf, input [31:0] regb, regc, output [31:0] rega);
	localparam ADD = 2'b00, SUB = 2'b01, MUL = 2'b10, DIV = 2'b11;

	wire [7:0] regbe, regce;
	wire [23:0] regbm, regcm;

	reg regas;
	reg [7:0] regae;
	reg [24:0] regam;

	reg [31:0] fadder_regb, fadder_regc;
	wire [31:0] fadder_rega;

	reg [31:0] fmultp_regb, fmultp_regc;
	wire [31:0] fmultp_rega;

	reg [31:0] fdvidr_regb, fdvidr_regc;
	wire [31:0] fdvidr_rega;

	assign rega[31] = regas;
	assign rega[30:23] = regae;
	assign rega[22:0] = regam[22:0];

	assign regbs = regb[31];
	assign regbe[7:0] = regb[30:23];
	assign regbm[23:0] = {1'b1, regb[22:0]};

	assign regcs = regc[31];
	assign regce[7:0] = regc[30:23];
	assign regcm[23:0] = {1'b1, regc[22:0]};

	fadder _fadder_(
		.regb(fadder_regb),
		.regc(fadder_regc),
		.rega(fadder_rega)
	);

	fmultp _fmultp_(
		.regb(fmultp_regb),
		.regc(fmultp_regc),
		.rega(fmultp_rega)
	);

	fdvidr _fdvidr_(
		.regb(fdvidr_regb),
		.regc(fdvidr_regc),
		.rega(fdvidr_rega)
	);

	always @(*) begin
		case(opf)
			ADD: begin
				if ((regbe == 255 && regbm != 0) || (regce == 0) && (regcm == 0)) begin // unk b or c=0 -> b
					regas = regbs;
					regae = regbe;
					regam = regbm;
				end else if ((regce == 255 && regcm != 0) || (regbe == 0) && (regbm == 0)) begin // unk c or b=0 -> c
					regas = regcs;
					regae = regce;
					regam = regcm;
				end else if ((regbe == 255) || (regce == 255)) begin // b inf or c inf -> inf
					regas = regbs ^ regcs;
					regae = 255;
					regam = 0;
				end else begin // valid b valid c
					fadder_regb = regb;
					fadder_regc = regc;
					regas = fadder_rega[31];
					regae = fadder_rega[30:23];
					regam = fadder_rega[22:0];
				end
			end 
			SUB: begin
				if ((regbe == 255 && regbm != 0) || (regce == 0) && (regcm == 0)) begin // unk b or c=0 -> b
					regas = regbs;
					regae = regbe;
					regam = regbm;
				end else if ((regce == 255 && regcm != 0) || (regbe == 0) && (regbm == 0)) begin // unk c or b=0 -> c
					regas = regcs;
					regae = regce;
					regam = regcm;
				end else if ((regbe == 255) || (regce == 255)) begin // b inf or c inf -> inf
					regas = regbs ^ regcs;
					regae = 255;
					regam = 0;
				end else begin // valid b valid c
					fadder_regb = regb;
					fadder_regc = {~regc[31], regc[30:0]}; // sub is just neg add
					regas = fadder_rega[31];
					regae = fadder_rega[30:23];
					regam = fadder_rega[22:0];
				end
			end
			MUL: begin
				if (regbe == 255 && regbm != 0) begin // unk b -> unk
					regas = regbs;
					regae = 255;
					regam = regbm;
				end else if (regce == 255 && regcm != 0) begin // unk c -> unk
					regas = regcs;
					regae = 255;
					regam = regcm;
				end else if ((regbe == 0) && (regbm == 0) || (regce == 0) && (regcm == 0)) begin // b=0 or c=0 -> 0
					regas = regbs ^ regcs;
					regae = 0;
					regam = 0;
				end else if ((regbe == 255) || (regce == 255)) begin // inf b or inf c -> inf
					regas = regbs;
					regae = 255;
					regam = 0;
				end else begin // valid b valid c
					fmultp_regb = regb;
					fmultp_regc = regc;
					regas = fmultp_rega[31];
					regae = fmultp_rega[30:23];
					regam = fmultp_rega[22:0];
				end
			end
			DIV: begin
				fdvidr_regb = regb;
				fdvidr_regc = regc;
				regas = fdvidr_rega[31];
				regae = fdvidr_rega[30:23];
				regam = fdvidr_rega[22:0];
			end
			default: begin // unk opc
				regas =1'bz;
				regae = 8'bz;
				regam = 23'bz;
			end
		endcase
	end
endmodule