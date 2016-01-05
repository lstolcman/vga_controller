library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity uart_tx
is
	-- definujeme interni entitu, neni jiz potreba definovat polaritu signalu, vse je aktivni v 1
	generic
	( 
		DATA_BITS : integer := 8;
		UART_BAUD_RATE : integer := 115200;
		TARGET_MCLK : integer := 100000000
	);
	
	port
	
	
	(
		clock			:	in 	std_logic;
		reset			:	in 	std_logic;	-- reset active at '1'
		data			:	in		std_logic_vector(DATA_BITS-1 downto 0);	-- input data
		txd			:	out	std_logic;	-- generated UART signal output
		data_ready	:	in 	std_logic	-- data ready signal
	);
	
end uart_tx;

architecture rtl of uart_tx
is
	type tx_states_t is (tx_ready, tx_start_bit, tx_transmit, tx_stop_bit);
	
	signal tx_state		:	tx_states_t;
	signal tx_br_cntr		:	integer range 0 to TARGET_MCLK/UART_BAUD_RATE-1; -- pokud definujete integer, VZDY uvadejte jeho rozsah
	signal tx_bit_cntr	:	integer range 0 to DATA_BITS; -- pocet datovych bitu k odeslani
	signal tx_data			:	std_logic_vector(DATA_BITS-1 downto 0); -- posuvny registr pro prijata data
	signal txd_latch		:	std_logic;


begin

prijem : process (clock, reset) is
	begin
		if rising_edge(clock)
		then
		-- !!
			--txd <= txd_latch;
				
				-- idle state
				case tx_state is
					when tx_ready =>
						if data_ready = '1'
						then
							tx_bit_cntr	<=	DATA_BITS;
							tx_state		<=	tx_start_bit;
							tx_br_cntr	<=	TARGET_MCLK/UART_BAUD_RATE-1;
							tx_data		<= data;
							txd <= '1';
						end if;
					
					-- send start bit
					when tx_start_bit =>
						if tx_br_cntr = 0
						then
							tx_state		<= tx_transmit;
							tx_br_cntr	<= TARGET_MCLK/UART_BAUD_RATE-1;
						else
							txd	<= '0';
							tx_br_cntr	<= tx_br_cntr - 1;
						end if;
					
					-- send bits
					when tx_transmit =>
						if tx_br_cntr = 0
						then
							if tx_bit_cntr /= 0
							then
								txd  <= tx_data(DATA_BITS - tx_bit_cntr); -- !!!! '0' or 'X' state! check it out
								tx_br_cntr	<= TARGET_MCLK/UART_BAUD_RATE-1;
								tx_bit_cntr	<= tx_bit_cntr - 1;
							else
								tx_state		<= tx_stop_bit;
								tx_br_cntr	<= TARGET_MCLK/UART_BAUD_RATE-1;
							end if;
						else
							tx_br_cntr	<= tx_br_cntr - 1;
						end if;
						
					-- send stop bit
					when tx_stop_bit =>
						txd <= '1';
						if tx_br_cntr = 0
						then
							tx_state		<= tx_ready;
							tx_br_cntr	<= (TARGET_MCLK/UART_BAUD_RATE-1)/2;
						else
							tx_br_cntr	<= tx_br_cntr - 1;
						end if;
						
				end case;
				
		end if;
		
end process prijem;

end rtl;