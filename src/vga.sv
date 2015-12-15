module vga_gen
(
	input	Clock50
);


endmodule


module vga_sync
(
	//input	Reset,
	input Clock50,

	output reg	HorizontalSync ,//= 1'd0,
	output reg	VerticalSync ,//= 1'd0,
	output reg 	[9:0]	HorizontalCounter ,//= 10'd0,
	output reg 	[9:0]	VerticalCounter //,//= 10'd0,
	//output reg	[4:0]	Red ,//= 5'd0,
	//output reg	[5:0]	Green ,//= 6'd0,
	//output reg	[4:0]	Blue //= 5'd0
);

reg Clock25 ;//= 1'd0;

//clock divide to 25MHz
always @(posedge Clock50)
begin
	//if (!Reset)
	//	Clock25 <= 0;
	//else
		Clock25 <= ~Clock25;
end


//Horizontal pulses generation
always @(posedge Clock25)
begin
	HorizontalCounter <= HorizontalCounter + 1'b1;
	case (HorizontalCounter)
		10'd656:
			HorizontalSync <= 0;
		10'd752:
			HorizontalSync <= 1;
		10'd800:
			begin
				HorizontalCounter <= 1;
				VerticalCounter <= VerticalCounter + 1;
				if (VerticalCounter > 10'd524)
					VerticalCounter <= 1;
			end
	endcase

end

//Vertical pulses generation
always @(posedge Clock25)
begin

	case (VerticalCounter)
		10'd490: VerticalSync <= 1'b0;
		10'd492: VerticalSync <= 1'b1;
	endcase
end

endmodule



