module fmultp(input [31:0] regb, regc, output [31:0] rega);
	reg regbs;
	reg [7:0] regbe;
	reg [23:0] regbm;
	reg regcs;
	reg [7:0] regce;
	reg [23:0] regcm;

	reg regas;
	reg [7:0] regae;
	reg [24:0] regam;

	reg [47:0] mulm;

	assign rega[31] = regas;
	assign rega[30:23] = regae;
	assign rega[22:0] = regam[22:0];

	always @ (*) begin
		regbs = regb[31];
		if(regb[30:23] == 0) begin
			regbe = 8'b00000001;
			regbm = {1'b0, regb[22:0]};
		end else begin
			regbe = regb[30:23];
			regbm = {1'b1, regb[22:0]};
		end
		regcs = regc[31];
		if(regc[30:23] == 0) begin
			regce = 8'b00000001;
			regcm = {1'b0, regc[22:0]};
		end else begin
			regce = regc[30:23];
			regcm = {1'b1, regc[22:0]};
		end
		regas = regbs ^ regcs;
		regae = regbe + regce - 127;

		mulm = regbm * regcm;
		if(mulm[47] == 1) begin // norm
			regae = regae + 1;
			mulm = mulm >> 1;
		end else if((mulm[46] != 1) && (regae != 0)) begin
			if(mulm[46:40] == 7'b0000001) begin
				regae = regae - 6;
				mulm = mulm << 6;
			end else if(mulm[46:41] == 6'b000001) begin
				regae = regae - 5;
				mulm = mulm << 5;
			end else if (mulm[46:42] == 5'b00001) begin
				regae = regae - 4;
				mulm = mulm << 4;
			end else if (mulm[46:43] == 4'b0001) begin
				regae = regae - 3;
				mulm = mulm << 3;
			end else if (mulm[46:44] == 3'b001) begin
				regae = regae - 2;
				mulm = mulm << 2;
			end else if (mulm[46:45] == 2'b01) begin
				regae = regae - 1;
				mulm = mulm << 1;
			end
		end
		regam = mulm[46:23];
	end
endmodule