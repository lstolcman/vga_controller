

module ram_rom_if
(
	input [7:0] in,
	output [6:0] out
);

assign out = in[6:0];

endmodule


module char_gen
(
	input clock100,
	input				[9:0]		HorizontalCounter,
	input				[9:0]		VerticalCounter,

	output reg [11:0] address
);

/*
always @(posedge clock100)
begin
	address <= 70;
end
*/

assign address = (VerticalCounter/12)*80+(HorizontalCounter/8);


endmodule

module pixel_gen
(
input							clock100,
	input							clock25,

	input				[9:0]		HorizontalCounter,
	input				[9:0]		VerticalCounter,
	input				[95:0]	data_in,
	
	output 	reg				Pixel
);

reg [7:0] line;
reg [2:0] i;
reg [95:0] data;

always @(posedge clock100)
begin
		
	data <= data_in;
	
	case (VerticalCounter % 12)
		10'd0: line <= data[95:88];
		10'd1: line <= data[87:80];
		10'd2: line <= data[79:72];
		10'd3: line <= data[71:64];
		10'd4: line <= data[63:56];
		10'd5: line <= data[55:48];
		10'd6: line <= data[47:40];
		10'd7: line <= data[39:32];
		10'd8: line <= data[31:24];
		10'd9: line <= data[23:16];
		10'd10: line <= data[15:8];
		10'd11: line <= data[7:0];

	endcase
	
end


always @(posedge clock25)
begin
		
	if (VerticalCounter < 480 && HorizontalCounter < 640 )
	begin
		Pixel <= line[i];
		i <= i+1;
	end
	else
	begin
		Pixel <= 0;
		i <= 0;
	end
		
	
end



endmodule



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




