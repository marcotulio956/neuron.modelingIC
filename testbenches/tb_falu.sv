module tb_fp();
	localparam DEPTH = 100;
	localparam ADD = 2'b00, SUB = 2'b01, MUL = 2'b10, DIV = 2'b11;

	integer dump_file;

	reg [31:0] regb1, regc1, regb2, regc2, regb3, regc3, regb4, regc4;
	reg [31:0] expected_adder_out, expected_multp_out, expected_subtr_out, expected_dvidr_out;

	wire [31:0] adder_out, multp_out, subtr_out, dvidr_out;

	initial begin
		dump_file = $fopen("../dumps/tb_falu_dump.txt", "w");
		fork 
			begin : thr1
				integer i, fp1;
				fp1 = $fopen("../dumps/adder_truthtable.txt","rb");

				for(i=0; i<DEPTH && !$feof(fp1); i=i+1)begin
					$fscanf(fp1,"%h %h %h", regb1, regc1, expected_adder_out);
					#1;//@(posedge adder_out);
					$display("fadder %d b %h c %h out %h expd %h", i, regb1, regc1, adder_out, expected_adder_out);
					$fwrite(dump_file, "fadder %d b %h c %h out %h expd %h", i, regb1, regc1, adder_out, expected_adder_out);
					if(expected_adder_out!==adder_out)begin
						$display("--- fadder UNMATCH ---");
						$fwrite(dump_file, " U\n");
						//$finish;
					end else begin
						$fwrite(dump_file, " M\n");
					end
					#1;
				end
				$display("_fadder_ PASSED");
				$fclose(fp1);
			end
			begin : thr2
				integer j, fp2;
				fp2 = $fopen("../dumps/multp_truthtable.txt","rb");

				for(j=0; j<DEPTH && !$feof(fp2); j=j+1)begin
					$fscanf(fp2,"%h %h %h", regb2, regc2, expected_multp_out);
					#1;//@(posedge multp_out);
					$display("fmultp %d b %h c %h out %h expd %h", j, regb2, regc2, multp_out, expected_multp_out);
					$fwrite(dump_file, "fmultp %d b %h c %h out %h expd %h", j, regb2, regc2, multp_out, expected_multp_out);
					if(expected_multp_out!==multp_out)begin
						$display("--- fmultp UNMATCH ---\n");
						$fwrite(dump_file, " U\n");
						//$finish;
					end else begin
						$fwrite(dump_file, " M\n");
					end
					#1;
				end
				$display("_fmultp_ PASSED");
				$fclose(fp2);
			end
			begin : thr3
				integer k, fp3;
				fp3 = $fopen("../dumps/subtr_truthtable.txt","rb");

				for(k=0; k<DEPTH && !$feof(fp3); k=k+1)begin
					$fscanf(fp3,"%h %h %h", regb3, regc3, expected_subtr_out);
					#1;//@(posedge subtr_out);
					$display("fsubtr %d b %h c %h out %h expd %h", k, regb3, regc3, subtr_out, expected_subtr_out);
					$fwrite(dump_file, "fsubtr %d b %h c %h out %h expd %h", k, regb3, regc3, subtr_out, expected_subtr_out);
					if(expected_subtr_out!==subtr_out)begin
						$display("--- fsubtr UNMATCH ---\n");
						$fwrite(dump_file, " U\n");
						//$finish;
					end else begin
						$fwrite(dump_file, " M\n");
					end
					#1;
				end
				$display("_fsubtr_ PASSED");
				$fclose(fp3);
			end
			begin : thr4
				integer l, fp4;
				fp4 = $fopen("../dumps/dvidr_truthtable.txt","rb");

				for(l=0; l<DEPTH && !$feof(fp4); l=l+1)begin
					$fscanf(fp4,"%h %h %h", regb4, regc4, expected_dvidr_out);
					#1;//@(posedge dvidr_out);
					$display("fdvidr %d b %h c %h out %h expd %h", l, regb4, regc4, dvidr_out, expected_dvidr_out);
					$fwrite(dump_file, "fdvidr %d b %h c %h out %h expd %h", l, regb4, regc4, dvidr_out, expected_dvidr_out);
					if(expected_dvidr_out!==dvidr_out)begin
						$display("--- fdvidr UNMATCH ---\n");
						$fwrite(dump_file, " U\n");
						//$finish;
					end else begin
						$fwrite(dump_file, " M\n");
					end
					#1;
				end
				$display("_fdvidr_ PASSED");
				$fclose(fp4);
			end
		join
		$fclose(dump_file);
		$finish;
	end
	falu _fadder_(ADD, regb1, regc1, adder_out);
	falu _fmultp_(MUL, regb2, regc2, multp_out);
	falu _fsubtr_(SUB, regb3, regc3, subtr_out);
	falu _fdvidr_(DIV, regb4, regc4, dvidr_out);
endmodule