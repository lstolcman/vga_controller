/*
module testt(input iiiiiiii);

integer i,r,v;
reg [95:0] memory [0:94]; // 96 bit memory with 95 entries
//reg [7:0] memory [94:0][11:0];


initial begin :adasdasdd
v=4;

	r = 1;
	for (i=0; i<94; i=i+1) begin
		memory[i][0] = $random(r);
		r=$random(r);
	end

	$readmemh("char_array.txt", memory);
	$writememh("memory_hex.txt", memory);

	$display("mem[0] = %h", memory[v][7:0]);
	$display("mem[0] = %h", memory[v][15:8]);
	$display("mem[0] = %h", memory[v][23:16]);
	$display("mem[0] = %h", memory[v][31:24]);
	$display("mem[0] = %h", memory[v][39:32]);
	$display("mem[0] = %h", memory[v][47:40]);
	$display("mem[0] = %h", memory[v][55:48]);
	$display("mem[0] = %h", memory[v][63:56]);
	$display("mem[0] = %h", memory[v][71:64]);
	$display("mem[0] = %h", memory[v][79:72]);
	$display("mem[0] = %h", memory[v][87:80]);
	$display("mem[0] = %h", memory[v][95:88]);
end


endmodule




module arrays_data();

reg [7:0] mem1 [0:1] [0:3] = '{'{8'h0,8'h1,8'h2,8'h3},'{8'h4,8'h5,8'h6,8'h7}};

initial begin
  $display ("mem[0]            = %b", mem[0]);
  $display ("mem[1][0]         = %b", mem[1][0]);
  $display ("mem1[0][1]        = %b", mem1[0][1]);
  $display ("mem1[1][1]        = %b", mem1[1][1]);
  #1 $finish;
end

endmodule

*/


module mem_read_tb1
(
	input [6:0] address,
	output reg [95:0] data_out
);


reg [95:0] memory [0:127]; // 96 bit memory(8x12 font) with 95 entries

initial
begin
	$readmemh("char_array3.txt", memory);
end

always @(*)
begin
	if (address < 7'd95)
		data_out = memory[address];
	else
		data_out = 96'bz;
end
//assign data_out = memory[address];

endmodule




