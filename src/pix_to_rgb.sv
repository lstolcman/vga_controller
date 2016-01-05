
module pix_to_rgb
(
	input					video_on,
	input					pix,
	output	reg[4:0]	Red = 5'd0,
	output	reg[5:0]	Green = 6'd0,
	output	reg[4:0]	Blue = 5'd0
);



always @(*)
begin
	if (pix && video_on)
	begin
		Red <= 5'b11111;
		Green <= 6'b111111;
		Blue <= 5'b11111;
	end
	else
	begin
		Red <= 0;
		Green <= 0;
		Blue <= 0;

	end
end

endmodule

