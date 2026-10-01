`timescale 10ns/1ns

module decode(
    input               clk,
    input               aresetn,
    input        [31:2] instr,
    output logic [31:0] imm,
    output logic [4:0]  rd, rs1, rs2,
    output logic [4:0]  opcode_o,
    output logic [2:0]  funct3,
    output logic        en_imm_o,
    output logic        en_pc_o
);

    typedef enum bit[3:0] {ADD, SUB, AND, OR, XOR, SLL, SLR, SAR} alu_op;
    logic [4:0] alu_control_w;

    
    // enable signals for immediate and pc related instructions
    always_ff(posedge clk or negedge aresetn) begin
        if(~aresetn) begin
            en_imm_o <= '0;
            en_pc_o  <= '0;
        end
        else begin
            casex(opcode)
        end
    end

    // opcode and function
    always_ff @(posedge clk or negedge aresetn) begin
        if(~aresetn) begin
            opcode <= '0;
            func   <= '0;
        end
        else begin
            opcode <= instr[6:2];
            func   <= instr[14:12];
        end
    end

    //immediate value
    always_ff @(posedge clk or negedge aresetn) begin
        if(~aresetn)        imm[31:0] <= '0;
        else begin
            casex(opcode)
                5'b00100:   imm[31:0]   <= {{20{instr[31]}}, instr[31:20]}; // immediate sign extended; addi, slti, sltiu, xori, ori, andi
                default:    imm[31:0]   <= {instr[31:12], 12'b0}; // lui, auipc
            endcase
        end
    end

    //source and destination registers selection
    always_ff @(posedge clk or negedge aresetn) begin
        if(~aresetn) begin
            rd  <= '0;
            rs1 <= '0;
            rs2 <= '0;
        end
        else begin
            rd[4:0]     <= instr[11:7];
            rs1[4:0]    <= instr[19:15];
            rs2[4:0]    <= instr[24:20];
        end
    end

    // alu control signal
    // always_comb begin
    //     casex(func)
    //         3'b000: alu_control_w = (opcode[3] && instr[30]) ? SUB : ADD;    // sub / add
    //         3'b01x: alu_control_w = SUB;    // slt / sltu
    //         3'b100: alu_control_w = XOR;    // xor
    //         3'b110: alu_control_w = OR;     // or
    //         3'b111: alu_control_w = AND;    // and
    //         3'b001: alu_control_w = SLL;    // sll
    //         3'b101: alu_control_w = (opcode[3] && instr[30]) ? SAR : SLR;    // sra / srl
    //         default:alu_control_w = 'x;
    //     endcase
    // end
    // always_ff @(posedge clk or negedge aresetn) begin
    //     if(~aresetn)    alu_control_o <= '0;
    //     else            alu_control_o <= alu_control_w;
    // end




endmodule
