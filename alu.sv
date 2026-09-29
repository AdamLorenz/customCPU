`timescale 10ns/1ns

module alu #(
    parameter DATA_WIDTH = 32
)
(
    input   signed  [DATA_WIDTH-1:0]    a_i,
    input   signed  [DATA_WIDTH-1:0]    b_i,
    input   logic   [4:0]               control_i,
    output  logic   [DATA_WIDTH-1:0]    result_o
);

    typedef enum {ADD, }

    always_comb begin
        case(control_i)
            5'd1:   result_o = a_i + b_i;
            5'd2:   result_o = a_i - b_i;
            5'd3:   result_o = a_i & b_i;
            5'd4:   result_o = a_i ^ b_i;
            5'd5:   result_o = a_i << b_i;
            5'd6:   result_o = a_i >>> b_i;
            5'd7:   result_o = a_i | b_i;
            5'd8:   result_o = a_i >> b_i;
            default:result_o = 32'b0;
        endcase
    end
endmodule
