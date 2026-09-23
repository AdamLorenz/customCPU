`timescale 10ns/1ns

module aluTB();

alu dut(
    .a_i(a),
    .b_i(b),
    .control_i(control),
    .flags_o(flags),
    .result_o(result)
);

    logic   [31:0]  a;
    logic   [31:0]  b;
    logic   [4:0]   control;
    logic   [3:0]   flags;
    logic   [31:0]  result;

    initial begin
        control = 5'd1;
        a = 32'b0;
        b = 32'b0;
        for(integer i = 0; i < 10000; i++) begin
            a += 1'b1;
            b += 1'b1;
            #10
            if(result != (a + b)) begin
                $display("failure");
                $display(a);
                $display(b);
                $display(result);
                $display(flags);
            end
        end 
        $finish;
    end
endmodule


