function bit [31:0] negate(input [31:0] in);
        return {~in[31], in[30:0]};
endfunction