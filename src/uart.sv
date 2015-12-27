module uart
(
	input clock50,
	output reg tx = 0
);


reg [15:0] cnt = 0;


assign clk_uart = cnt[15];
// speed: 115200 
always @(posedge clock50)
begin
	cnt <= cnt + 151;
end


//localparam S0=2'd0, S1=2'd1, S2=2'd2;
//reg [1:0] state = S0;
enum {S0, S1, S2, S3 } state = S0;
reg [3:1] datacnt = 0;
reg [7:0] data = 8'b01000000;


always @(posedge clk_uart)
begin

	case (state)
		S0: // idle
			begin
				tx <= 1;
				state <= S1;
			end
		S1: // start bit
			begin
				tx <= 0;
				state <= S2;
			end
		S2: //transfer bits
			begin
				tx <= data[datacnt];
				datacnt <= datacnt+1;
				if (datacnt == 9)
				begin
					state <= S3;
				end
			end

		S3: //stop bit
			begin
				tx <= 1;
				state <= S0;
			end

		default:
			state <= S0;
	endcase

end

endmodule



module uartr
(
	input clock50,
	input rx,
	
	output reg [7:0] char = 0,
	output reg en = 0
);


reg start = 0;
reg [3:0] bitcnt = 0;
reg [15:0] cnt = 0;
reg rx_sync1, rx_sync2, rxd;

// speed: 115200*2
assign clk_uartr = cnt[15];

// if rx = startbit -> enable counting
always @(posedge clock50)
begin

	if (!start)
		cnt <= 0;
	else
		cnt <= cnt+302;

end

always @(posedge clock50)
begin
	rx_sync1 <= rx;
	rx_sync2 <= rx_sync1;
	rxd <= rx_sync2;
end

always @(posedge clk_uartr)
	bitcnt <= bitcnt+1;


always @(posedge clock50)
begin
	
	if (!start && rxd == 0)
	begin
		start <= 1;
	end
	
	case (bitcnt)
		3: char[7]<=rxd;//lsb
		5: char[6]<=rxd;//
		7: char[5]<=rxd;//
		9: char[4]<=rxd;//
		11: char[3]<=rxd;//
		13: char[2]<=rxd;//
		15: char[1]<=rxd;//
		17: char[0]<=rxd;// msb
		19: if (rxd == 1) en<=1;// stopbit
	endcase

end



endmodule


