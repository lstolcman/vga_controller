


module char_gen
(
	input clk
);

reg [95:0] memory [0:94]; // 96 bit memory(8x12 font) with 95 entries

initial
begin
	$readmemh("char_array.txt", memory);
end







endmodule
