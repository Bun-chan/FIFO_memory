library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FIFO_Memory is --the inputs and outputs of the circuit.
   port(
      clk, rst:		in std_logic;
      RdPtrClr, WrPtrClr:	in std_logic; -- Use RdPtrClr and WrPtrClr as input signals which reset the pointers to point to the first register in the array.    
      RdInc, WrInc:	in std_logic; -- Use RdInc and WrInc as input signals to increment the pointers that indicate which register to read or write. 
      DataIn:	 in std_logic_vector(8 downto 0);
      DataOut: out std_logic_vector(8 downto 0);
      rden, wren: in std_logic -- read (output) enable. write (input) enable
	);
end entity FIFO_Memory;

architecture RTL of FIFO_Memory is
	--signal declarations
	type fifo_array is array(7 downto 0) of std_logic_vector(8 downto 0);  -- makes use of VHDL’s enumerated type
	signal fifo:  fifo_array;
	signal wrptr, rdptr: unsigned(2 downto 0);
	signal en: std_logic_vector(7 downto 0);
	signal dmuxout: std_logic_vector(8 downto 0);

begin
	fifo_process : process (clk) is
		begin
			if (rising_edge(clk)) then
				if (WrInc = '1') then --increment the write pointer wrptr
					wrptr <= wrptr + 1;
				end if; --if WrInc=1
				if (RdInc = '1') then --increment the read pointer rdptr
					rdptr <= rdptr + 1;
				end if; --if RdInc=1
			
			
				if (WrPtrClr = '1') then --reset the pointers to point to the first register in the array
					wrptr <= "000";
				end if; --if WrPtrClr=1
				if (RdPtrClr = '1') then --reset the pointers to point to the first register in the array
					rdptr <= "000";
				end if; --if RdPtrClr=1
			
			
				if (rden = '1') then
--					en <= ""; --what is this for?
					DataOut <= fifo(to_integer(unsigned(rdptr))); --the output should be enabled. what does this mean?
					--dmuxout <= fifo(to_integer(unsigned(rdptr)));
				else
					DataOut <= "ZZZZZZZZZ"; --can not use lowercase z. High Impedance.
--					dmuxout <= "ZZZZZZZZZ";
				end if; --if rden=1
				if (wren = '1') then
					fifo(to_integer(unsigned(wrptr))) <= DataIn;
					--dmuxout <= DataIn; --is this needed here?
					DataOut <= DataIn; --i am not sure if this is correct. but it removed a lot of errors.
				end if; --if wren=1
			end if; --if rising_edge
		end process;




end RTL;