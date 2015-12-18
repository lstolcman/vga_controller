


module char_gen
(
	input					clock50,
	input			[95:0]data_in,
	input			[9:0]	HorizontalCounter,
	input			[9:0]	VerticalCounter,
	output	reg[6:0]	address = 7'd5,
	output 	reg		Pixel
	/*output	reg[4:0]	Red = 5'd0,
	output	reg[5:0]	Green = 6'd0,
	output	reg[4:0]	Blue = 5'd0*/
);

reg [7:0] line = 7'b11110000;
reg [95:0] data_in1 = 96'h001038440438404438100000; // $
always @(posedge clock50)
begin
	
	
	//line <= 7'b11110000;
	/*if (HorizontalCounter < 640)
	begin
	
		if (HorizontalCounter % 8 == 0)
		begin
			
		end
		
	end
	else
	begin
		line <= 8'd0;
	end
	
	
*/
	case (VerticalCounter % 12)
		10'd0: line <= data_in[7:0];
		10'd1: line <= data_in[15:8];
		10'd2: line <= data_in[23:16];
		10'd3: line <= data_in[31:24];
		10'd4: line <= data_in[39:32];
		10'd5: line <= data_in[47:40];
		10'd6: line <= data_in[55:48];
		10'd7: line <= data_in[63:56];
		10'd8: line <= data_in[71:64];
		10'd9: line <= data_in[79:72];
		10'd10: line <= data_in[87:80];
		10'd11: line <= data_in[95:88];
	endcase



	// displaying pixels in correct syncs
	if (VerticalCounter <= 480 && HorizontalCounter <= 640)
	begin
		Pixel <= line[7];
		line <= {line[6:0], line[7]};	
	end
	else
		Pixel <= 0;
		
	
end



endmodule





module char_memory
(
	input [6:0] address,
	output reg [95:0] data_out
);


reg [95:0] memory [0:94]; // 96 bit memory(8x12 font) with 95 entries

initial
begin
	$readmemh("src/char_array.txt", memory);
end

always @(*)
begin
	if (address < 7'd95)
		data_out = memory[address];
	else
		data_out = memory[7'd94];
end
//assign data_out = memory[address];

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




