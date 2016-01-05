`include "../char_gen.sv"
`include "../../font_rom.v"
`include "../../char_rom_test.v"
`timescale 1ns/100ps

module mem_chain_tb1;

// i/o
reg clock100;
reg	[9:0] HorizontalCounter;
reg	[9:0] VerticalCounter;

wire [11:0] char_gen_out;
wire [7:0] char_rom_test_out;
wire [6:0] ram_rom_if_out;
wire [95:0] font_rom_out;




char_gen u1
(
	.clock100(clock100),
	.HorizontalCounter(HorizontalCounter),
	.VerticalCounter(VerticalCounter),
	.address(char_gen_out)
);

char_rom_test u2
(
	.clock(clock100),
	.address(char_gen_out),
	.q(char_rom_test_out)
);

ram_rom_if u3
(
	.in(char_rom_test_out),
	.out(ram_rom_if_out)
);

font_rom u4
(
	.clock(clock100),
	.address(ram_rom_if_out),
	.q(font_rom_out)
);



initial
begin

	clock100 = 0;
	HorizontalCounter = 0;
	VerticalCounter = 0;

end

always
begin

	#10;
	clock100 <= !clock100;

end


always
begin

	HorizontalCounter <= HorizontalCounter + 1'b1;
	
	case (HorizontalCounter)
		10'd800-1:
			begin
				HorizontalCounter <= 0;
				VerticalCounter <= VerticalCounter + 1;
				if (VerticalCounter >= 10'd524)
					VerticalCounter <= 0;
			end
	endcase
	

end

endmodule



