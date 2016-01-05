//`include "../char_gen.sv"
`timescale 1ns/100ps

module uart_rx_tb1;

// i/o
reg	rx;
reg clock100;

wire [7:0]	data;
wire		data_ready;

// clocks
reg [50:0] cnt;
assign clock1152 = cnt[19];
reg [15:0] cnt2;




uart_rx uut
(
	.clock(clock100),
	.rxd(rx),
	.data(data),
	.data_ready(data_ready)
);


initial
begin
	rx = 1;

	clock100 = 0;
	cnt = 0;
	cnt2 = 0;

end

always
begin

	#40;
	clock100 <= !clock100;

end
/*

// speed: 115200 for 100MHz clock
always @(posedge clock100)
begin
	cnt <= cnt + 1208;
end



// speed: 115200 for 500MHz clock
always @(posedge clock100)
begin
	cnt <= cnt + 2416;
end
*/

// speed: 115200 for 250MHz clock
always @(posedge clock100)
begin
	cnt <= cnt + 4832;
end


always @(posedge clock1152)
begin
	cnt2 <= cnt2+1;

	// 01000000 = @
	case (cnt2)
		2: rx<=0; //startbit
		3: rx<=0; //lsb 0
		4: rx<=0; //1
		5: rx<=0; //2
		6: rx<=0; //3
		7: rx<=0; //4
		8: rx<=0; //5
		9: rx<=1; //6
		10: rx<=0; //7
		11: rx<=1; //stopbit
	endcase




	// 01001011 = K
	case (cnt2)
		52: rx<=0; //startbit
		53: rx<=0; //lsb 0
		54: rx<=1; //1
		55: rx<=0; //2
		56: rx<=0; //3
		57: rx<=1; //4
		58: rx<=0; //5
		59: rx<=1; //6
		60: rx<=1; //7
		61: rx<=1; //stopbit
	endcase



end

endmodule


