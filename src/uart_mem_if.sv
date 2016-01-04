

module uart_mem_if
(
	input clock100,
	input [7:0] data_in,
	input data_ready,

	
	output reg [7:0] data_out = 0,
	output [11:0] wraddress,
	output reg wren = 0
);


reg send_to_mem = 0;
reg [7:0] data = 0;

reg [7:0] data_s1 = 0;
reg [7:0] data_s2 = 0;
reg data_ready_s1 = 0;
reg data_ready_s2 = 0;

reg [6:0] row = 0;
reg [6:0] col = 0;

assign wraddress = row+80*col;


//synchronizers
always @(posedge clock100)
begin
	data_s1 <= data_in;
	data_s2 <= data_s1;
	
	data_ready_s1 <= data_ready;
	data_ready_s2 <= data_ready_s1;
end


enum {S0, S1, S2, S3} state = S0;


//state machine for reading data in and sending data out to memory
always @(posedge clock100)
begin
	
	case (state)
		S0:
		begin // idle
			wren <= 0;
			
			if (data_ready_s2 == 1)
			begin
				data <= data_s2;
				state <= S1;
			end
		end
		
		S1: // calculate position
		begin
			
			//calculate proper character position
			if (row < 80-1)
				row <= row+1;
			else
			begin
				row <= 0;
				if (col < 40-1)
					col <= col+1;
				else
					col <= 0;
			end
			
			data_out <= data;
			
			state <= S2;
		end
		
		S2: //send character
		begin
			wren <= 1;
			state <= S3;
		end
		
		S3: //latch wren, needed by memory
		begin
			state <= S0;
		end
		
		default:
			state <= S0;
			
	endcase
	
end



endmodule




