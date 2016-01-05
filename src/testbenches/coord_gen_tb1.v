//`include "../char_gen.sv"
`timescale 1ns/1ps

module coord_gen_tb1;

	reg clock25;
	
	reg	[9:0]	HorizontalCounter;
	reg	[9:0]	VerticalCounter;
	
	wire		[6:0] 	y;
	wire		[6:0]	x;



coord_gen uut
(
	.HorizontalCounter(HorizontalCounter),
	.VerticalCounter(VerticalCounter),
	.y(y),
	.x(x)
);

initial
begin
	clock25 <= 0;
	HorizontalCounter <= 0;
	VerticalCounter <= 0;
end

always
begin
	#20;
	clock25 <= !clock25;

	HorizontalCounter <= HorizontalCounter + 1'b1;
	
	case (HorizontalCounter)
		10'd800-1:
			begin
				HorizontalCounter <= 0;
				VerticalCounter <= VerticalCounter + 1;
				if (VerticalCounter >= 10'd524)
					VerticalCounter <= 0;
			end
	endcase
	

end

endmodule
