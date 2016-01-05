

module char_gen
(
	input clock100,
	input				[9:0]		HorizontalCounter,
	input				[9:0]		VerticalCounter,

	output reg [11:0] address
);

assign address = (VerticalCounter/12)*80+(HorizontalCounter/8);
	
endmodule

