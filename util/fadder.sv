module fadder(input  [31:0] regb, regc, output [31:0] rega);
	reg regbs, regcs;
	reg [7:0] regbe, regce;
	reg [23:0] regbm, regcm;

	reg regas;
	reg [7:0] regae;
	reg [24:0] regam;

	reg [7:0] diff;
	reg [23:0] tmp_mantissa;
	reg [7:0] tmp_exponent;

	reg  [7:0] i_e;
	reg  [24:0] i_m;
	wire [7:0] o_e;
	wire [24:0] o_m;

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
		if (regbe == regce) begin // Equal exponents
			regae = regbe;
			if (regbs == regcs) begin // Equal signs = add
			regam = regbm + regcm;
			//Signify to shift
			regam[24] = 1;
			regas = regbs;
			end else begin // Opposite signs = subtract
				if(regbm > regcm) begin
					regam = regbm - regcm;
					regas = regbs;
				end else begin
					regam = regcm - regbm;
					regas = regcs;
				end
			end
		end else begin //Unequal exponents
			if (regbe > regce) begin // A is bigger
				regae = regbe;
				regas = regbs;
				diff = regbe - regce;
				tmp_mantissa = regcm >> diff;
				if (regbs == regcs)
					regam = regbm + tmp_mantissa;
				else
					regam = regbm - tmp_mantissa;
			end else if (regbe < regce) begin // B is bigger
				regae = regce;
				regas = regcs;
				diff = regce - regbe;
				tmp_mantissa = regbm >> diff;
				if (regbs == regcs) begin
					regam = regcm + tmp_mantissa;
				end else begin
					regam = regcm - tmp_mantissa;
				end
			end
		end
		if(regam[24] == 1) begin
			regae = regae + 1;
			regam = regam >> 1;
		end else if((regam[23] != 1) && (regae != 0)) begin
			if (regam[23:3] == 21'b000000000000000000001) begin
				regae = regae - 20;
				regam = regam << 20;
			end else if (regam[23:4] == 20'b00000000000000000001) begin
				regae = regae - 19;
				regam = regam << 19;
			end else if (regam[23:5] == 19'b0000000000000000001) begin
				regae = regae - 18;
				regam = regam << 18;
			end else if (regam[23:6] == 18'b000000000000000001) begin
				regae = regae - 17;
				regam = regam << 17;
			end else if (regam[23:7] == 17'b00000000000000001) begin
				regae = regae - 16;
				regam = regam << 16;
			end else if (regam[23:8] == 16'b0000000000000001) begin
				regae = regae - 15;
				regam = regam << 15;
			end else if (regam[23:9] == 15'b000000000000001) begin
				regae = regae - 14;
				regam = regam << 14;
			end else if (regam[23:10] == 14'b00000000000001) begin
				regae = regae - 13;
				regam = regam << 13;
			end else if (regam[23:11] == 13'b0000000000001) begin
				regae = regae - 12;
				regam = regam << 12;
			end else if (regam[23:12] == 12'b000000000001) begin
				regae = regae - 11;
				regam = regam << 11;
			end else if (regam[23:13] == 11'b00000000001) begin
				regae = regae - 10;
				regam = regam << 10;
			end else if (regam[23:14] == 10'b0000000001) begin
				regae = regae - 9;
				regam = regam << 9;
			end else if (regam[23:15] == 9'b000000001) begin
				regae = regae - 8;
				regam = regam << 8;
			end else if (regam[23:16] == 8'b00000001) begin
				regae = regae - 7;
				regam = regam << 7;
			end else if (regam[23:17] == 7'b0000001) begin
				regae = regae - 6;
				regam = regam << 6;
			end else if (regam[23:18] == 6'b000001) begin
				regae = regae - 5;
				regam = regam << 5;
			end else if (regam[23:19] == 5'b00001) begin
				regae = regae - 4;
				regam = regam << 4;
			end else if (regam[23:20] == 4'b0001) begin
				regae = regae - 3;
				regam = regam << 3;
			end else if (regam[23:21] == 3'b001) begin
				regae = regae - 2;
				regam = regam << 2;
			end else if (regam[23:22] == 2'b01) begin
				regae = regae - 1;
				regam = regam << 1;
			end
		end
	end
endmodule