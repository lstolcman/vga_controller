module vga_clk_gen
(
	input	Clock50,
	output Clock25 = 0
);

always @(posedge Clock50)
begin
	Clock25 <= ~Clock25;
end


endmodule




module vga_sync
(
	input Clock25,

	output reg	HorizontalSync,
	output reg	VerticalSync,
	output reg	Video_on,
	output reg 	[9:0]	HorizontalCounter,
	output reg 	[9:0]	VerticalCounter
);

assign Video_on = ((HorizontalCounter <= 640) && (VerticalCounter<=480));

/*
https://eewiki.net/pages/viewpage.action?pageId=15925278
*/
always @(posedge Clock25)
begin

	HorizontalCounter <= HorizontalCounter + 1'b1;
	
	case (HorizontalCounter)
		10'd656-1:
			HorizontalSync <= 0;
		10'd752-1:
			HorizontalSync <= 1;
		10'd800-1:
			begin
				HorizontalCounter <= 0;
				
				VerticalCounter <= VerticalCounter + 1;
				if (VerticalCounter >= 10'd524)
					VerticalCounter <= 0;
			end
	endcase

	case (VerticalCounter)
		10'd490-1: VerticalSync <= 1'b0;
		10'd492-1: VerticalSync <= 1'b1;
	endcase
	
end



endmodule



