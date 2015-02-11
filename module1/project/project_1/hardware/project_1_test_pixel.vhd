library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity project_1_test_pixel is
	port (
		SW : IN std_logic_vector(17 downto 0);
		KEY : IN std_logic_vector(3 downto 0);
		LEDR : OUT std_logic_vector(5 downto 0);
		LEDG : OUT std_logic_vector(7 downto 0)
	);
end project_1_test_pixel;

architecture Behavioural of project_1_test_pixel is
	component sad_pixel
	port (
		ref_rgb	: in std_logic_vector(15 downto 0);
		can_rgb	: in std_logic_vector(15 downto 0);
		sad		: out unsigned(7 downto 0)
	);
	end component;

	signal output : unsigned(7 downto 0);
	signal c			: std_logic_vector(15 downto 0) := "0000000000000000";
begin
	SP : sad_pixel port map (
		ref_rgb => SW(15 downto 0),
		can_rgb => c,
		sad => output
	);
	
	LEDG(7 downto 0) <= std_logic_vector(output);
	
end Behavioural;