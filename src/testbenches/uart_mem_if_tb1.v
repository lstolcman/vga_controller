//`include "../char_gen.sv"
`timescale 1ns/100ps

module uart_mem_if_tb1;

reg	clock100;
reg	[7:0] data_in;
reg data_ready;

wire [7:0]	data_out;
wire [11:0] wraddress;
wire		wren;


reg [19:0] cnt;



uart_mem_if uut
(
	.clock100(clock100),
	.data_in(data_in),
	.data_ready(data_ready),
	.data_out(data_out),
	.wraddress(wraddress),
	.wren(wren)
);

initial
begin
	clock100 = 0;
	data_in = 0;
	data_ready = 0;

	cnt = 0;
end

always
begin
	#10;
	clock100 <= !clock100;
end


always @(posedge clock100)
begin
	cnt = cnt+1;


	if (cnt == 1)
		data_in = 8'b01000000;

	if (cnt==4) data_ready = 1;
	if (cnt==5) data_ready = 0;

end

endmodule

