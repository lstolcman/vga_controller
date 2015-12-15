


module char_gen
(
	input					clock50,
	input			[95:0]data_in,
	input			[9:0]	HorizontalCounter,
	input			[9:0]	VerticalCounter,
	output	reg[6:0]	address = 7'd5,
	output	reg[4:0]	Red = 5'd0,
	output	reg[5:0]	Green = 6'd0,
	output	reg[4:0]	Blue = 5'd0
);

reg [7:0] line;
reg [95:0] data_in1 = 96'h001038440438404438100000; // $
always @(posedge clock50)
begin
	if (HorizontalCounter < 640)
	begin
		case (HorizontalCounter % 12)
			10'd0: line <= data_in1[7:0];
			10'd1: line <= data_in1[15:8];
			10'd2: line <= data_in1[23:16];
			10'd3: line <= data_in1[31:24];
			10'd4: line <= data_in1[39:32];
			10'd5: line <= data_in1[47:40];
			10'd6: line <= data_in1[55:48];
			10'd7: line <= data_in1[63:56];
			10'd8: line <= data_in1[71:64];
			10'd9: line <= data_in1[79:72];
			10'd10: line <= data_in1[87:80];
			10'd11: line <= data_in1[95:88];
		endcase
	end
	else
	begin
		line <= 8'd0;
	end

	if(VerticalCounter < 480)
	begin
		if (line[VerticalCounter[2:0]] > 0)
			Red <= 5'd30;
		else
			Red <= 5'd0;
	end
	else
	begin
		Red <= 5'd0;
	end		
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
	//$readmemh("char_array.txt", memory);
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

