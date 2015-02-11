-- SAD for a pixel

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity sad_pixel is
	port (
		ref_rgb	: in std_logic_vector(15 downto 0);
		can_rgb	: in std_logic_vector(15 downto 0);
		sad		: out unsigned(7 downto 0)
	);
end sad_pixel;

architecture Behavioural of sad_pixel is
begin
	process(ref_rgb, can_rgb)
		variable r, g, b : unsigned(7 downto 0);
	begin	
		-- Red
		r := unsigned(
					abs(signed("000" & ref_rgb(15 downto 11)) - signed("000" & can_rgb(15 downto 11)))
				);
		
		-- Green
		g := unsigned(
					abs(signed("00" & ref_rgb(10 downto 5)) - signed("00" & can_rgb(10 downto 5)))
				);
		
		-- Blue
		b := unsigned(
					abs(signed("000" & ref_rgb(4 downto 0)) - signed("000" & can_rgb(4 downto 0)))
				);
				
		sad <= r + g + b;
	end process;
end Behavioural;