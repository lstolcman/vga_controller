


module char_gen
(
	input					clock25,
	input			[95:0]data_in,
	input			[9:0]	HorizontalCounter,
	input			[9:0]	VerticalCounter,
	output	reg[6:0]	address = 7'd5,
	output 	reg		Pixel
	/*output	reg[4:0]	Red = 5'd0,
	output	reg[5:0]	Green = 6'd0,
	output	reg[4:0]	Blue = 5'd0*/
);

reg [7:0] line;
reg[2:0] i;
//reg [95:0] data_in1 = 96'h001038440438404438100000; // $
//reg [95:0] data_in1 = 96'h00000000FC4242427C40403C; // g
reg [95:0] data_in1 = 96'h000000003C407C4242BC0000; // a

always @(posedge clock25)
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
	address <= 74;
	data_in1 <= data_in;
	case (VerticalCounter % 12)
		10'd0: line <= data_in1[95:88];
		10'd1: line <= data_in1[87:80];
		10'd2: line <= data_in1[79:72];
		10'd3: line <= data_in1[71:64];
		10'd4: line <= data_in1[63:56];
		10'd5: line <= data_in1[55:48];
		10'd6: line <= data_in1[47:40];
		10'd7: line <= data_in1[39:32];
		10'd8: line <= data_in1[31:24];
		10'd9: line <= data_in1[23:16];
		10'd10: line <= data_in1[15:8];
		10'd11: line <= data_in1[7:0];

	endcase



	// displaying pixels in correct syncs
	if (VerticalCounter < 480 && HorizontalCounter < 640)
	begin
		Pixel <= line[i];
		i<=i+1;
		//line <= {line[0], line[7:1]};	
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


reg [95:0] memory [0:127]; // 96 bit memory(8x12 font) with 95 entries

initial
begin
	$readmemh("src/char_array3.txt", memory);
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




