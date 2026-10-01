`timescale 10ns/1ns

module cpu(
    input clk;
    input aresetn;
);
    // central resources
    logic [31:0] reg_file [5:0] = '0;
    logic [31:0] pc             = '0;

/***************************************************************************
    FETCH STAGE
 ****************************************************************************/
    
    wire logic [31:0] instr_w;

/***************************************************************************
    DECODE STAGE
 ****************************************************************************/

    wire logic [31:0]   imm_w;
    wire logic [4:0]    rd_w, rs1_w, rs2_w;
    wire logic [2:0]    funct3_w;
    wire logic [6:0]    alt_func_w;
    wire logic          en_imm_w;
    wire logic          en_pc_w;

    decode decodeUnit(
        .clk            (clk),
        .aresetn        (aresetn),
        .instr          (instr_w),
        .imm            (imm_w),
        .rd             (rd_w),
        .rs1            (rs1_w),
        .rs2            (rs2_w),
        .funct3         (funct3_w),
        .alt            (alt_func_w),
        .en_imm         (en_imm_w),
        .en_pc          (en_pc_w)
    );

/***************************************************************************
    EXECUTE STAGE
 ****************************************************************************/
    
    /* The following glue logic uses enable signals from the decode unit to 
    determine what operands should be passed to the execute unit and the alu 
    therein. There are three possible combinations: operating on two registers,
    operating on an immediate and a register, or an immediate and the program 
    counter (PC) register */
    wire logic [31:0] operand1_w, operand2_w;
    assign operand1_w = en_pc_w  ? pc  : reg_file[rs1_w];
    assign operand2_w = en_imm_w ? imm : reg_file[rs2_w];

    wire logic [31:0] result_w;

    execute executeUnit(
        .clk            (clk),
        .aresetn        (aresetn),
        .operand1_i     (operand1_w),
        .operand2_i     (operand2_w),
        .alu_control_i  (funct3),
        .result_o       (result_w)
    );
    
/***************************************************************************
    MEMORY ACCESS STAGE
 ****************************************************************************/

    
/***************************************************************************
    WRITE BACK STAGE
 ****************************************************************************/
    
    // buffer destination register and execute result to write back stage
    logic [4:0] rd_buffer1_r;   // execute stage buffer
    logic [4:0] rd_buffer2_r;   // memory access stage buffer
    logic [31:0] result_r;      // memory access stage buffer
    always_ff @(posedge clk or negedge aresetn) begin
        if(~aresetn) begin
            rd_buffer1_r <= '0;
            rd_buffer2_r <= '0;
            result_r     <= '0;
        end    
        else begin
            rd_buffer1_r <= rd_w;  
            rd_buffer2_r <= rd_buffer1_r;
            result_r     <= result_w;
        end
    end

    always_ff @(posedge clk or negedge aresetn) begin
        if(~aresetn)    
        else            reg_file[rd_buffer2_r] <= result_r;
    end

endmodule
