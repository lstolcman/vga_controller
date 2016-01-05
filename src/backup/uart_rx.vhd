library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity uart_rx
is

	generic
	(
		-- definujeme interni entitu, neni jiz potreba definovat polaritu signalu, vse je aktivni v 1
		DATA_BITS		: integer := 8;
		UART_BAUD_RATE	: integer := 115200;
		TARGET_MCLK		: integer := 100000000
	);
	
	port
	(
		clock	: in std_logic; -- hodiny
		reset	: in std_logic; -- interni reset aktivni v '1'
		data	: out std_logic_vector(DATA_BITS-1 downto 0); -- prijata data
		send	: out std_logic; -- priznak potvrzujici platnost vystupnich dat
		fe		: out std_logic; -- framing error - neplatnost prijatych dat
		rxd	: in std_logic -- generovany UART signal
	);
	
end uart_rx;

architecture rtl of uart_rx
is

	type rx_states_t is
	(
		rx_ready,
		rx_start_bit,
		rx_receiv,
		rx_stop_bit
	); -- mohlo by zde byt i rx_parity pro prijem paritniho bitu
	
	signal rx_state		: rx_states_t;
	signal rx_br_cntr		: integer range 0 to TARGET_MCLK/UART_BAUD_RATE-1; -- pokud definujete integer, VZDY uvadejte jeho rozsah
	signal rx_bit_cntr	: integer range 0 to DATA_BITS; -- pocet datovych bitu k odeslani
	signal rx_data			: std_logic_vector(DATA_BITS-1 downto 0); -- posuvny registr pro prijata data
	signal rxd_latch		: std_logic;

begin

prijem : process (clock, reset) is
	begin
		if reset = '1'
		then
			rx_state <= rx_ready;
			send <= '0';
			fe <= '0';
			rxd_latch <= '0';
		elsif rising_edge(clock)
		then
			rxd_latch <= rxd;
			
			case rx_state is
			
				when rx_ready =>
					send <= '0';
					fe <= '0';
					if rxd_latch = '0' then
					rx_bit_cntr <= DATA_BITS;
					rx_state <= rx_start_bit;
					rx_br_cntr <= (TARGET_MCLK/UART_BAUD_RATE-1)/2;
					end if;
					
				when rx_start_bit =>
					if rx_br_cntr = 0
					then
						rx_state <= rx_receiv;
						rx_br_cntr <= TARGET_MCLK/UART_BAUD_RATE-1;
					else
						rx_br_cntr <= rx_br_cntr - 1;
					end if;
					
				when rx_receiv =>
					if rx_br_cntr = 0
					then
						if rx_bit_cntr /= 0
						then
							rx_data(DATA_BITS - rx_bit_cntr) <= rxd_latch;
							rx_br_cntr <= TARGET_MCLK/UART_BAUD_RATE-1;
							rx_bit_cntr <= rx_bit_cntr - 1;
						else
							rx_state <= rx_stop_bit;
							rx_br_cntr <= TARGET_MCLK/UART_BAUD_RATE-1;
						end if;
					else
						rx_br_cntr <= rx_br_cntr - 1;
					end if;
					
				when rx_stop_bit =>
					if rx_br_cntr = 0
					then
						rx_state <= rx_ready;
						if rxd_latch = '1'
						then
							data <= rx_data ;
							send <= '1';
						else
							fe <= '1';
						end if;
					else
						rx_br_cntr <= rx_br_cntr - 1;
					end if;
			end case;
			
		end if;
		
end process prijem;

end rtl;