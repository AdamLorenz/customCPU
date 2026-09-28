`timescale 10ns/1ns

module alu #(
    parameter DATA_WIDTH = 32
)
(
    input   signed  [DATA_WIDTH-1:0]    a_i,
    input   signed  [DATA_WIDTH-1:0]    b_i,
    input   logic   [4:0]               control_i,
    output  logic   [3:0]               flags_o, // Overflow, Carry, Negative, Zero
    output  signed  [DATA_WIDTH-1:0]    result_o
);

    logic   [DATA_WIDTH:0]  result_w;
    
    assign flags_o[0] = ~|result_w[DATA_WIDTH-1:0]; // Zero
    assign flags_o[1] =   result_w[DATA_WIDTH-1]; // Negative
    assign flags_o[2] =   result_w[DATA_WIDTH]; // Carry

    // Overflow flag logic    
    always_comb begin
        case(control_i) 
            5'd1:   flags_o[3] = ~(a_i[DATA_WIDTH-1] ^ b_i[DATA_WIDTH-1]) & result_w[DATA_WIDTH-1] != a_i[DATA_WIDTH-1];
            5'd2:   flags_o[3] =  (a_i[DATA_WIDTH-1] ^ b_i[DATA_WIDTH-1]) & result_w[DATA_WIDTH-1] != a_i[DATA_WIDTH-1]; 
            default:flags_o[3] = 1'b0;
        endcase
    end

    always_comb begin
        case(control_i)
            5'd1:   result_w = a_i + b_i;
            5'd2:   result_w = a_i - b_i;
            5'd3:   result_w = {1'b0, a_i & b_i};
            5'd4:   result_w = {1'b0, a_i ^ b_i};
            5'd5:   result_w = {1'b0, a_i << b_i};
            5'd6:   result_w = {1'b0, a_i >>> b_i};
            5'd7:   result_w = {1'b0, a_i | b_i};
            5'd8:   result_w = {1'b0, a_i >> b_i};
            default:result_w = 33'b0; 
        endcase
    end

    assign result_o = result_w[DATA_WIDTH-1:0];

endmodule
