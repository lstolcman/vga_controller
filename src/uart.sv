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
enum {S0, S1, S2 } state = S0;
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

		S1: //transfer bits
			begin
				tx <= data[datacnt];
				datacnt<=datacnt+1;
				if (datacnt == 9)
				begin
					state <= S2;
				end
			end

		S2: //stop bit
			begin
				tx <= 1;
				state <= S0;
			end

		default:
			state <= S0;
	endcase

end

/*
reg [3:0] s;
always @(posedge clk_uart)
begin
	s <= s+1;
	case (s)
	0: tx <= 0;
	1: tx <= 0; //start bit
	2: tx <= 0;
	3: tx <= 0;
	4: tx <= 0;
	5: tx <= 0;
	6: tx <= 0;
	7: tx <= 1;
	8: tx <= 0; //msc
	9: begin tx <= 1; //stop bit
	s<=0; end
	//10: tx <= ; // stop bit

	default:
	 s<=0;
	endcase
end
*/





endmodule

