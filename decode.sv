`timescale 10ns/1ns

module decode(
    input                   clk,
    input                   aresetn,
    input           [31:2]  instr,
    output logic    [31:0]  imm,
    output logic    [4:0]   rd, rs1, rs2,
    output logic    [3:0]   alu_control_o,
    output logic            en_imm_o,
    output logic            en_pc_o
);

    typedef enum bit[3:0] {ADD, SUB, AND, OR, XOR, SLL, SLR, SAR} alu_op;
    logic [4:0] alu_control_w;
    
    wire logic [4:0] opcode;
    wire logic [2:0] func;
    assign opcode[4:0]  = instr[6:2];
    assign func[2:0]    = instr[14:12];

    //immediate value
    always_ff @(posedge clk or negedge aresetn) begin
        if(~aresetn)        imm[31:0] <= '0;
        else begin
            casex(opcode)
                5'b00100:   imm[31:0]   <= {{20{instr[31]}}, instr[31:20]}; // immediate sign extended; addi, slti, sltiu, xori, ori, andi
                5'b0x101:   imm[31:0]   <= {instr[31:12], 12'b0}; // lui, auipc
                default:    imm[31:0]   <= 'x;
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
            
            // casex(opcode)
            //     5'b11011,       // jal
            //     5'b0x101: begin // lui, auipc
            //         rd[4:0]     <= instr[11:7];
            //         rs1[4:0]    <= 'x;
            //         rs2[4:0]    <= 'x;
            //     end
            //     5'b11001,       // jalr
            //     5'b00x00,       // addi, slti, sltiu, xori, ori, andi, slli, srli, srai, sfence.vma
            //     5'b11100: begin // lb, lh, lw, lbu, lhu, csrrw, csrrs, csrrc, csrrci
            //         rd[4:0]     <= instr[11:7];
            //         rs1[4:0]    <= instr[19:15];
            //         rs2[4:0]    <= 'x;
            //     end
            //     5'b01100: begin // add, sub, sll, slt, sltu, xor, srl, sra, or, and, 
            //         rd[4:0]     <= instr[11:7];                
            //         rs1[4:0]    <= instr[19:15];
            //         rs2[4:0]    <= instr[24:20];
            //     end
            //     5'b1x000: begin // sb, sh, sw, beq, bne, blt, bge, bltu, bgeu
            //         rd[4:0]     <= 'x;
            //         rs1[4:0]    <= instr[19:15];
            //         rs2[4:0]    <= instr[24:20];
            //     end
            //     default: begin
            //         rd[4:0]     <= 'x;
            //         rs1[4:0]    <= 'x;
            //         rs2[4:0]    <= 'x;
            //     end
            // endcase
        end
    end

    // alu control signal
    always_comb begin
        // casex(opcode)
        //     5'b00100: begin
        //         casex(func)
        //             3'b000: alu_control_w = ADD;    // addi
        //             3'b01x: alu_control_w = SUB;    // slti, sltiu
        //             3'b100: alu_control_w = XOR;    // xori
        //             3'b110: alu_control_w = OR;     // ori
        //             3'b111: alu_control_w = AND;    // andi
        //             3'b001: alu_control_w = SLL;    // slli
        //             3'b101: alu_control_w = instr[30] ? SAR : SLR;    // srai / srli
        //             default:alu_control_w = 'x;
        //         endcase
        //     end
        //     5'b01100: begin
                casex(func)
                    3'b000: alu_control_w = (opcode[3] && instr[30]) ? SUB : ADD;    // sub / add
                    3'b01x: alu_control_w = SUB;    // slt / sltu
                    3'b100: alu_control_w = XOR;    // xor
                    3'b110: alu_control_w = OR;     // or
                    3'b111: alu_control_w = AND;    // and
                    3'b001: alu_control_w = SLL;    // sll
                    3'b101: alu_control_w = (opcode[3] && instr[30]) ? SAR : SLR;    // sra / srl
                    default:alu_control_w = 'x;
                endcase
        //     end
        //     default:        alu_control_w = 'x;
        // endcase
    end
    always_ff @(posedge clk or negedge aresetn) begin
        if(~aresetn)    alu_control_o <= '0;
        else            alu_control_o <= alu_control_w;
    end


endmodule
