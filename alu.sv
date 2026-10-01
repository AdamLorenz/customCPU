`timescale 10ns/1ns

module alu #(
    parameter DATA_WIDTH = 32
)
(
    input   signed  [DATA_WIDTH-1:0]    a_i,
    input   signed  [DATA_WIDTH-1:0]    b_i,
    input           [2:0]               control_i,
    input                               alt_func,  // funct7
    output  logic   [DATA_WIDTH-1:0]    result_o
);

    always_comb begin
        case(control_i)
            3'h0:   result_o = alt_func ? a_i - b_i : a_i + b_i;
            3'h7:   result_o = a_i & b_i;
            3'h6:   result_o = a_i | b_i;
            3'h4:   result_o = a_i ^ b_i;
            3'h1:   result_o = a_i << b_i[5:0];
            3'h5:   result_o = alt_func ? a_i >>> b_i[5:0] : a_i >> b_i[5:0];
            3'h2:   result_o = {31'b0, a < b};
            3'h3:   result_o = {31'b0, unsigned'(a) < unsigned'(b)};
            default:result_o = 32'b0;
        endcase
    end
endmodule
