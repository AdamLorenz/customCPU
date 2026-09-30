`timescale 10ns/1ns

module alu #(
    parameter DATA_WIDTH = 32
)
(
    input   signed  [DATA_WIDTH-1:0]    operand1_i,
    input   signed  [DATA_WIDTH-1:0]    operand2_i,
    input   logic   [3:0]               control_i,
    output  logic   [DATA_WIDTH-1:0]    result_o
);

    always_comb begin
        case(control_i)
            4'd1:   result_o = operand1_i + operand2_i;
            4'd2:   result_o = operand1_i - operand2_i;
            4'd3:   result_o = operand1_i & operand2_i;
            4'd4:   result_o = operand1_i | operand2_i;
            4'd5:   result_o = operand1_i ^ operand2_i;
            4'd6:   result_o = operand1_i << operand2_i;
            4'd7:   result_o = operand1_i >> operand2_i;
            4'd8:   result_o = operand1_i >>> operand2_i;
            default:result_o = 32'b0;
        endcase
    end
endmodule
