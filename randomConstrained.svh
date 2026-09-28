
class randomConstrained;
        /* verilator lint_off UNUSEDSIGNAL */
        rand bit signed [31:0]  a;
        rand bit signed [31:0]  b;
        rand bit        [4:0]   control;
        /* verilator lint_on UNUSEDSIGNAL */
        constraint controlRange {
            control inside {5'd1};
        }

        // constraint inputRange {
        //     a inside {[32'h0000_0000 : 32'hFFFF_FFFF]};
        //     b inside {[32'h0000_0000 : 32'hFFFF_FFFF]};
        // }
endclass
