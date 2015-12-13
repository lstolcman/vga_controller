module uart
(
	input clock50,
	output tx
);


reg [31:0] cnt;
assign tx = cnt[31];
always @(posedge clock50)
begin
	cnt <= cnt + 86; 
end




endmodule

