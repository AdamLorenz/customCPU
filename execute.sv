`timescale 10ns/1ns

module execute(
    input   clk,
    input   aresetn,
    input [4:0] alu_control_i,
    input [31:0] operand1, operand2,
    
)