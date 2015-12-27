module coord_gen
(
	input		[9:0]		HorizontalCounter,
	input		[9:0]		VerticalCounter,
	
	output	[6:0]	y,
	output	[6:0] x
);

assign x = (HorizontalCounter < 640) ? (HorizontalCounter/8):0;
assign y = (VerticalCounter < 480) ? (VerticalCounter/12):0;

endmodule


module screen_memory
(
	input		[6:0]	x,
	input		[6:0]	y,
	
	output	[6:0]	char
);


reg [7:0] memory [3599:0];  // memory with 3599 entries of 8 bit characters


assign char = memory[x*80+y];


initial
begin
	integer i;
	for (i=0;i<3600;i=i+1)
	begin
		memory[i] = (i%60)+32;
	end
	
	//memory[164] = 70;
end

/*
always @(*)
begin

	if (VerticalCounter < 48 && HorizontalCounter < 64)
		char <= 70;
	else char <= 0;

end
*/

endmodule




module char_controller
(
	input							clock25,
	input				[9:0]		HorizontalCounter,
	input				[9:0]		VerticalCounter,

	output 	reg	[6:0]		address = 0
);



endmodule




module char_gen
(
	input							clock25,
	input				[95:0]	data_in,
	input				[9:0]		HorizontalCounter,
	input				[9:0]		VerticalCounter,

	output 	reg				Pixel = 0
);

reg [7:0] line = 0;
reg[2:0] i = 0;
reg [95:0] data = 0;

always @(posedge clock25)
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


	if (VerticalCounter < 480 && HorizontalCounter < 640)
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
	output [95:0] data_out
);


reg [95:0] memory [0:127]; // memory with 128 entries of 96 bit(8x12 font)
assign data_out = memory[address];

initial
begin
	$readmemh("src/char_array3.txt", memory);
	//address<=70;
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




