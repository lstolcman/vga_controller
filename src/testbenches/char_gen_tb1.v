`timescale 1 ns/ 1 ps
module char_gen_tb1();
// test vector input registers
reg clk50;

reg [6:0] addr;
wire [95:0] data_out;


char_memory i1
(
	.address(addr),
	.data_out(data_out)
);


initial
begin
	clk50 = 0;
	addr = 5;
	$display("Running testbench");
end

always
	// @(event1) ...
begin

clk50 <= ~clk50; #20;

end







endmodule

