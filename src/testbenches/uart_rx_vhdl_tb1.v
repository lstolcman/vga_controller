//`include "../char_gen.sv"
`timescale 1ns/100ps

module uart_rx_vhdl_tb1;

reg	reset; // : in std_logic; -- interni reset aktivni v '1'
reg	rx; // : in std_logic -- generovany UART signal
reg clock100;

wire [7:0]	data; // : out std_logic_vector(DATA_BITS-1 downto 0); -- prijata data
wire		send; // : out std_logic; -- priznak potvrzujici platnost vystupnich dat
wire		fe; // : out std_logic; -- framing error - neplatnost prijatych dat

reg [19:0] cnt;
assign clock1152 = cnt[19];
reg [15:0] cnt2;

uart_rx uut
(
	clock100,
	reset,
	data,
	send,
	fe,
	rx	
);

initial
begin
	reset=1;
	rx=1;

	
	clock100 = 0;
	cnt = 0;
	cnt2 = 0;
#10000;
reset=0;
end

always
begin
	#10;
	clock100 <= !clock100;

end


// speed: 115200 
always @(posedge clock100)
begin
	cnt <= cnt + 1208;
end



always @(posedge clock1152)
begin
	if (reset == 0)
	begin
	if (cnt2 > 200)
		cnt2<=0;
	else
		cnt2<= cnt2+1;
	end
	else cnt2<=0;

// 01000000 = @
	case (cnt2)
		2: rx<=0; //startbit
		3: rx<=0; //lsb 0
		4: rx<=0; //1
		5: rx<=0; //2
		6: rx<=0; //3
		7: rx<=1; //4
		8: rx<=0; //5
		9: rx<=1; //6
		10: rx<=0; //7
		11: rx<=1; //stopbit
	endcase





end

endmodule

