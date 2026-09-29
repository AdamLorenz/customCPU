`timescale 10ns/1ns

module aluTB;
    
    import myPkg::*;
    
    logic signed    [31:0]  a, 
                            b, 
                            result;
    logic           [4:0]   control;
    
    alu dut(
        .a_i(a),
        .b_i(b),
        .control_i(control),
        .result_o(result)
    );

    randomConstrained rc;

    initial begin
        rc = new();

        repeat(1000) begin
            if(rc.randomize() == 1) begin
                a =         rc.a;
                b =         rc.b;
                control =   rc.control;
                
                #10;
               
                //$display("control=%d a=%d b=%d result=%d", control, rc.a, rc.b, result);
                if(longint'(result) === longint'(rc.a) + longint'(rc.b)) begin
                    $display("success");
                end   
                else begin
                    $display("control=%d a=%d b=%d result=%d", control, a, b, result);
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
