`timescale 10ns/1ns

module execute(
    input               clk,
    input               aresetn,
    input        [2:0]  funct3,
    input               alt_func
    input        [31:0] operand1_i, 
    input        [31:0] operand2_i,
    output logic [31:0] result_o;
)

    wire logic [31:0] result_w;

    alu alUnit(
        .operand1_i (operand1_i),
        .operand2_i (operand2_i),
        .alt_func   (alt_func)
        .control_i  (funct3),
        .result_o   (result_w)
    );

    always_ff @(posedge clk or negedge aresetn) begin
        if(~aresetn)    result_o <= '0;
        else            result_o <= result_w
    end 

endmodule
