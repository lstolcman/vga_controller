

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

