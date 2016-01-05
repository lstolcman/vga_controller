
module uart_rx
(
	input clock,
	input rxd,

	output reg [7:0] data,
	output reg data_ready
);

	parameter DATA_BITS = 8;
	parameter UART_BAUD_RATE = 115200; //115,2kHz
	parameter TARGET_MCLK = 25000000; //25MHz

	reg [0:(TARGET_MCLK/UART_BAUD_RATE-1)] rx_br_cntr;
	reg [0:DATA_BITS] rx_bit_cntr;
	reg [0:(DATA_BITS-1)] rx_data;
	reg rxd_latch;

	enum {rx_ready, rx_start_bit, rx_receiv, rx_stop_bit} rx_state = rx_ready;

	always @(posedge clock)
	begin
		rxd_latch <= rxd;

		case (rx_state)

			rx_ready:
			begin
				data_ready <= 0;
				if (rxd_latch == 0)
				begin
					rx_bit_cntr <= DATA_BITS;
					rx_state <= rx_start_bit;
					rx_br_cntr <= (TARGET_MCLK/UART_BAUD_RATE-1)/2;
				end
			end	

			rx_start_bit:
			begin
				if (rx_br_cntr == 0)
				begin
					rx_state <= rx_receiv;
					rx_br_cntr <= TARGET_MCLK/UART_BAUD_RATE-1;
				end
				else
				begin
					rx_br_cntr <= rx_br_cntr - 1;
				end
			end

			rx_receiv:
			begin
				if (rx_br_cntr == 0)
				begin
					if (rx_bit_cntr != 0)
					begin
						rx_data[rx_bit_cntr-1] <= rxd_latch;
						rx_br_cntr <= TARGET_MCLK/UART_BAUD_RATE-1;
						rx_bit_cntr <= rx_bit_cntr - 1;
					end
					else
					begin
						rx_state <= rx_stop_bit;
						rx_br_cntr <= TARGET_MCLK/UART_BAUD_RATE-1;
					end
				end
				else
					rx_br_cntr <= rx_br_cntr - 1;
			end

			rx_stop_bit:
			begin
				if (rx_br_cntr == 0)
				begin
					rx_state <= rx_ready;
					if (rxd_latch == 1)
					begin
						data <= rx_data ;
						data_ready <= 1;
					end
				end
				else
					rx_br_cntr <= rx_br_cntr - 1;
			end
		endcase

	end

endmodule





