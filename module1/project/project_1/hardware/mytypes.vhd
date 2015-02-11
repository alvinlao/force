library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

package my_types is
	-- Blocks of pixels
	type BlockType is array(integer range<>, integer range<>) of std_logic_vector(15 downto 0);
	type SADBlockType is array(integer range<>, integer range<>) of unsigned(7 downto 0);
end my_types;

package body my_types is
end package body;