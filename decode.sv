`timescale 10ns/1ns

module decode(
    input               clk,
    input               aresetn,
    input        [31:2] instr,
    output logic [31:0] imm,
    output logic [4:0]  rd, rs1, rs2,
    output logic [2:0]  funct3,
    output logic        alt_func,            // funct7 bit for alu operation select
    output logic        en_imm,
    output logic        en_pc
);

    wire logic [4:0] opcode = instr[6:2];
    
    // pc and immediate enable bits used to select operands passed to execute unit
    always_ff @(posedge clk and negedge reset) begin
        if(~aresetn) begin
            en_imm <= '0;
            en_pc  <= '0;
        end
        en_imm <= ~(opcode == 5'01100) // if any type except R: enable immediate
        casex(opcode) 
            5'b00101,
            5'b11011,
            5'b11000:   en_pc <= 1'b1;
            default:    en_pc <= '0;
        endcase
    end

    // main decode logic
    always_ff @(posedge clk or negedge aresetn) begin
        if(~aresetn) begin
            imm      <= '0;
            rd       <= '0;
            rs1      <= '0;
            rs2      <= '0;
            funct3   <= '0;
            alt_func <= '0;
        end
        else begin
            rd       <= instr[11:7];
            rs1      <= instr[19:15];
            rs2      <= instr[24:20];
            funct3   <= instr[14:12];
            alt_func <= instr[30];
            casex(opcode) // immediate value decoding
                5'b1110x,
                5'b00x00:   imm <= {{20{isntr[31]}}, instr[31:20]};                                         // I type instruction (sign extended)
                5'b01000:   imm <= {{20{instr[31]}}, instr[31:25], instr[11:7]};                            // S type instruction (sign extended)
                5'b11000:   imm <= {{20{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; // B type instruction (sign extended)
                5'b0x101:   imm <= {instr[31:12], 12'b0};                                                   // U type instruction (sign extended)
                5'b11011:   imm <= {{12{instr[31]}}, instr[31], instr[19:12], instr[30:21], instr[20]};     // J type instruction (sign extended)
                default:    imm <= '0;                                                                      // R type instruction
            endcase
        end
    end

    // // opcode and function
    // always_ff @(posedge clk or negedge aresetn) begin
    //     if(~aresetn) begin
    //         opcode <= '0;
    //         func   <= '0;
    //     end
    //     else begin
    //         opcode <= instr[6:2];
    //         func   <= instr[14:12];
    //     end
    // end

    // //immediate value
    // always_ff @(posedge clk or negedge aresetn) begin
    //     if(~aresetn)        imm[31:0] <= '0;
    //     else begin
    //         casex(opcode)
    //             5'b00100:   imm[31:0]   <= {{20{instr[31]}}, instr[31:20]}; // immediate sign extended; addi, slti, sltiu, xori, ori, andi
    //             default:    imm[31:0]   <= {instr[31:12], 12'b0}; // lui, auipc
    //         endcase
    //     end
    // end

    // //source and destination registers selection
    // always_ff @(posedge clk or negedge aresetn) begin
    //     if(~aresetn) begin
    //         rd  <= '0;
    //         rs1 <= '0;
    //         rs2 <= '0;
    //     end
    //     else begin
    //         rd[4:0]     <= instr[11:7];
    //         rs1[4:0]    <= instr[19:15];
    //         rs2[4:0]    <= instr[24:20];
    //     end
    // end

    // // alu control signal
    // // always_comb begin
    // //     casex(func)
    // //         3'b000: alu_control_w = (opcode[3] && instr[30]) ? SUB : ADD;    // sub / add
    // //         3'b01x: alu_control_w = SUB;    // slt / sltu
    // //         3'b100: alu_control_w = XOR;    // xor
    // //         3'b110: alu_control_w = OR;     // or
    // //         3'b111: alu_control_w = AND;    // and
    // //         3'b001: alu_control_w = SLL;    // sll
    // //         3'b101: alu_control_w = (opcode[3] && instr[30]) ? SAR : SLR;    // sra / srl
    // //         default:alu_control_w = 'x;
    // //     endcase
    // // end
    // // always_ff @(posedge clk or negedge aresetn) begin
    // //     if(~aresetn)    alu_control_o <= '0;
    // //     else            alu_control_o <= alu_control_w;
    // // end

endmodule
