`timescale 10ns/1ns

module cpu(
    input clk;
    input aresetn;
);

    logic [32:0] reg_file [0:32] = '0;

    wire logic [31:0]   imm_w;
    wire logic [4:0]    rd_w, rs1_w, rs2_w;
    wire logic [4:0]    alu_control_w;

    decode decodeUnit(
        .clk    (clk),
        .aresetn(aresetn),
        .instr  (),
        .imm    (imm_w),
        .rd     (rd_w),
        .rs1    (rs1_w),
        .rs2    (rs2_w),
        .alu_control_o()
    );

    /* The following glue logic uses enable signals from the decode unit to determine
    what operands should be passed to the execute unit and the alu therein. There are 
    three possible combinations: operating on two registers, operating on an immediate
    and a register, or an immediate and the program counter (PC) register */
    wire logic [31:0] operand1_w, operand2_w;
    assign operand1_w = /*signal*/ ? reg_file[rs2_w] : imm; 
    assign operand2_w = /*signal*/ ? reg_file[rs1_w] : pc;

    execute executeUnit(
        .clk        (clk),
        .aresetn    (aresetn),
        .operand1   (operand1_w),
        .operand2   (operand2_w),
        .alu_control_i(alu_control_w)
    );

endmodule
