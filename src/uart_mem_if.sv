

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

reg [11:0] clear_chars;

assign wraddress = 80*row+col;


//synchronizers
always @(posedge clock100)
begin
	data_s1 <= data_in;
	data_s2 <= data_s1;
	
	data_ready_s1 <= data_ready;
	data_ready_s2 <= data_ready_s1;
	
end


enum {S0, S1, S2, S3, S4, S5, S6} state = S0;


//state machine for reading data in and sending data out to memory
always @(posedge clock100)
begin
	
	case (state)
		S0:
		begin // idle
			wren <= 0;
			clear_chars <= 0;
			
			if (data_ready_s2 == 1)
			begin
				data <= data_s2;
				state <= S1;
			end
		end
		
		S1: // calculate position
		begin
			case (data)
				13: // CR = enter -> new line
				begin
					col <= 0;
					if (row < 40-1)
						row <= row+1;
					else
						row <= 0;
					
					state <= S3;
				end
				
				27: // ESC -> clear screen
				begin
					row <= 0;
					col <= 0;
					state <= S4;
				end
				
				127: // DEL = backspace
				begin
					
					wren <= 1;
					data_out <= 8'd32; //space
					state <= S5;
				end
				
				default: // just print character in right position
				begin
					data_out <= data;
					//calculate proper character position
					if (col < 80-1)
						col <= col+1;
					else
					begin
						col <= 0;
						if (row < 40-1)
							row <= row+1;
						else
							row <= 0;
					end
					state <= S2;
				end
			endcase
			
		end
		
		S2: //send character
		begin
			wren <= 1;
			state <= S3;
		end

		S3: //latch wren, needed by memory
		begin
			if (data_ready_s2 == 0)
				state <= S0;
		end
		
		S4: // clear screen
		begin
			wren <= 1;
			data_out <= 0;
			
			if (col < 80-1)
				col <= col+1;
			else
			begin
				col <= 0;
				if (row < 40-1)
					row <= row+1;
				else
					row <= 0;
			end
			
			clear_chars <= clear_chars+1;
			
			if (clear_chars >= 3200)
			begin
				row <= 0;
				col <= 0;
				data <= 0;
				state <= S2;
			end
		end
		
		
		
		S5: //latch wren, needed by memory
		begin
			state <= S6;
		end

		S6: 
		begin
			wren <= 0;
			
			//calculate proper character position
			if (col > 0)
				col <= col-1;
			else
			begin
				col <= 80-1;
				if (row > 0)
					row <= row-1;
				else
					row <= 40-1;
			end
			state <= S0;
		end
		
		

					
					
					
					
		default:
			state <= S0;
			
	endcase
	
end



endmodule




