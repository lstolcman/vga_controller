module screen_memory
(
	input	[9:0]		HorizontalCounter,
	input	[9:0]		VerticalCounter,
	input	wr_req,
	
	output reg wr_en,
	output reg [6:0] char
);


reg [5:0] vcnt;
reg [6:0] hcnt;
reg [7:0] memory [3599:0];  // memory with 3599 entries of 8 bit characters


assign char = memory[80*hcnt+vcnt];

initial
begin :named
	integer i;
	for (i=0;i<3600;i=i+1)
	begin
		memory[i] = i[7:0];
	end
end

always @(*)
begin
	if (VerticalCounter < 480)
	begin
		if (VerticalCounter == 0)
			hcnt <= 0;
	
		if (VerticalCounter%12==0)
			vcnt <= vcnt+1;
	end
	else
		vcnt <= 0;
	
	if (HorizontalCounter < 640)
	begin
		if (HorizontalCounter%8==0)
			hcnt <= hcnt+1;
	end
	else
		hcnt <= 0;
	
	
	if (VerticalCounter < 480 && HorizontalCounter < 640)
		wr_en <= 0;
	else
		wr_en <= 1;
	
end


endmodule
