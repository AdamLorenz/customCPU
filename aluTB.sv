`timescale 10ns/1ns

module aluTB;
    
    import myPkg::*;
    
    logic signed    [31:0]  a, 
                            b, 
                            result;
    logic           [4:0]   control;
    logic           [3:0]   flags;
    
    alu dut(
        .a_i(a),
        .b_i(b),
        .control_i(control),
        .flags_o(flags),
        .result_o(result)
    );

    randomConstrained rc;

    initial begin
        rc = new();

        repeat(100) begin
            if(rc.randomize() == 1) begin
                a =         rc.a;
                b =         rc.b;
                control =   rc.control;
                
                #10;
               
                if(flags[3] == 1 || result == a + b) begin
                    $display("success"); 
                end   
                else begin
                    $display("control=%d a=%d b=%d result=%d flags=%b Overflow, Carry, Negative, Zero",control, a, b, result, flags);
                    $display("failure");
                end                                   
                
            end
            else begin
                $fatal(1,"Randomization Failed");
            end
        end

        $finish;
    end
endmodule
