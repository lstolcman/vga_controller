


module char_gen
(
	input							clock25,
	input				[95:0]	data_in,
	input				[9:0]		HorizontalCounter,
	input				[9:0]		VerticalCounter,

	output	reg	[6:0]		address,
	output 	reg				Pixel
);

reg [7:0] line;
reg[2:0] i;
reg [95:0] data;

always @(posedge clock25)
begin
		
	data <= data_in;

	address<=70;
	
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


	if (VerticalCounter < 480 && HorizontalCounter < 640 )
	begin
		Pixel <= line[i];
		i<=i+1;
	end
	else
	begin
		Pixel <= 0;
		i<=0;
	end
		
	
end



endmodule





module char_memory
(
	input [6:0] address,
	output reg [95:0] data_out
);


reg [95:0] memory [0:127]; // memory with 128 entries of 96 bit(8x12 font)
assign data_out = memory[address];

initial
begin
	$readmemh("src/char_array3.txt", memory);
end



endmodule




module pix_to_rgb
(
	input					pix,
	output	reg[4:0]	Red = 5'd0,
	output	reg[5:0]	Green = 6'd0,
	output	reg[4:0]	Blue = 5'd0
);



always @(*)
begin
	if (pix == 0)
	begin
		Red <= 0;
		Green <= 0;
		Blue <= 0;
	end
	else
	begin
		Red <= 5'b11111;
		Green <= 6'b111111;
		Blue <= 5'b11111;
	end
end

endmodule




