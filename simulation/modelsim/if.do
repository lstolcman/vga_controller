
force -freeze sim:/uart_mem_if/clock100 1 0, 0 {5000 ps} -r 10ns
force -freeze sim:/uart_mem_if/data_in 01000000 0
force -freeze sim:/uart_mem_if/data_ready 0 0

run 60ns


force -freeze sim:/uart_mem_if/data_ready 1 0;run 10ns;force -freeze sim:/uart_mem_if/data_ready 0 0;run 100ns
force -freeze sim:/uart_mem_if/data_ready 1 0;run 10ns;force -freeze sim:/uart_mem_if/data_ready 0 0;run 100ns
force -freeze sim:/uart_mem_if/data_ready 1 0;run 10ns;force -freeze sim:/uart_mem_if/data_ready 0 0;run 100ns
force -freeze sim:/uart_mem_if/data_ready 1 0;run 10ns;force -freeze sim:/uart_mem_if/data_ready 0 0;run 100ns
force -freeze sim:/uart_mem_if/data_ready 1 0;run 10ns;force -freeze sim:/uart_mem_if/data_ready 0 0;run 100ns
force -freeze sim:/uart_mem_if/data_ready 1 0;run 10ns;force -freeze sim:/uart_mem_if/data_ready 0 0;run 100ns
force -freeze sim:/uart_mem_if/data_ready 1 0;run 10ns;force -freeze sim:/uart_mem_if/data_ready 0 0;run 100ns
force -freeze sim:/uart_mem_if/data_ready 1 0;run 10ns;force -freeze sim:/uart_mem_if/data_ready 0 0;run 100ns
