
module ram_rom_if
(
	input [7:0] in,
	output [6:0] out
);

assign out = in[6:0];

endmodule

