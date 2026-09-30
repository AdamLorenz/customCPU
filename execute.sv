`timescale 10ns/1ns

module execute(
    input   clk,
    input   aresetn,
    input [4:0] alu_control_i,
    input [31:0] operand1_i, operand2_i,
    output logic [31:0] result_o;
)

    wire logic [31:0] result_w;

    alu alUnit(
        .operand1_i(operand1_i),
        .operand2_i(operand2_i),
        .control_i(alu_control_i),
        .result_o(result_w)
    );

    always_ff @(posedge clk or negedge aresetn) begin
        if(~aresetn)    result_o <= '0;
        else            result_o <= result_w
    end 

endmodule
