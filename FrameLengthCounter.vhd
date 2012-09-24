LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY FrameLengthCounter IS 
	PORT(clock, reset, data_valid 		  : IN  STD_LOGIC;
		 data_in						  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		 byte_count, second_byte          : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END FrameLengthCounter;

ARCHITECTURE Behavior OF FrameLengthCounter IS 
	SIGNAL second_byte_temp  : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL counter           : UNSIGNED(8 DOWNTO 0);
	SIGNAL data_valid_buffer : STD_LOGIC;
BEGIN
	
	PROCESS(clock, reset)
	BEGIN
		IF reset = '1' THEN
			second_byte_temp <= "00000000";
			counter <= "000000000";
			data_valid_buffer <= '0';
		ELSIF (clock'EVENT AND clock = '1') THEN
			data_valid_buffer <= data_valid;
			IF data_valid = '1' THEN
				counter <= counter + 1;
				IF counter = 2 THEN
					second_byte_temp(7 DOWNTO 4) <= data_in;
				ELSIF counter = 3 THEN
					second_byte_temp(3 DOWNTO 0) <= data_in;
				END IF;
			END IF;
		END IF;
		
		IF (data_valid_buffer = '1' AND data_valid = '0') THEN
			second_byte <= second_byte_temp;
			byte_count <= STD_LOGIC_VECTOR(counter(8 DOWNTO 1));
		END IF;
	END PROCESS;
	
END Behavior;