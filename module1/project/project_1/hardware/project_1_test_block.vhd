library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

	
library work;
use work.my_types.all;

entity project_1_test_block is
	generic (
		sizeX : integer := 3;
		sizeY : integer := 3;
		winSizeX : integer := 8;
		winSizeY : integer := 8
	);
	port (
		SW : IN std_logic_vector(17 downto 0);
		KEY : IN std_logic_vector(3 downto 0);
		LEDR : OUT std_logic_vector(17 downto 0);
		LEDG : OUT std_logic_vector(7 downto 0)
	);
end project_1_test_block;

architecture Behavioural of project_1_test_block is	
	component sad_block
	generic (
		sizeX, sizeY : integer;
		winSizeX, winSizeY : integer
	);
	port (
		reset	: in std_logic;
		clock	: in std_logic;
		
		ready	: out std_logic;
		start	: in std_logic;
		done	: out std_logic;

		-- Absolute x, y offsets
		x0			: in integer;
		y0			: in integer;
		
		window : in BlockType(winSizeX-1 downto 0, winSizeY-1 downto 0);
		ref : in BlockType(sizeX-1 downto 0, sizeY-1 downto 0);
		
		sad : out unsigned(31 downto 0)
	);
	end component;

	signal ready : std_logic;
	signal done : std_logic;
	
	signal output : unsigned(31 downto 0);	
	
	signal window : BlockType(winSizeX-1 downto 0, winSizeY-1 downto 0);
	signal ref : BlockType(sizeX-1 downto 0, sizeY-1 downto 0);
	signal x0 : integer := 0;
	signal y0 : integer := 0;
	
begin
	SB : sad_block 
		generic map (
			sizeX => sizeX,
			sizeY => sizeY,
			winSizeX => winSizeX,
			winSizeY => winSizeY
		)
		port map (
			reset => not KEY(0),
			clock => KEY(1),
			
			ready => ready,
			done => done,
			start => SW(0),
			
			x0 => x0,
			y0 => y0,
			
			window => window,
			ref => ref,		
			
			sad => output
		);
	
	process(KEY(1))
	begin
		if(rising_edge(KEY(1))) then 
		
			for i in 0 to winSizeX-1 loop
				for j in 0 to winSizeY-1 loop
					window(i, j) <= b"0000_0000_0000_0000";
					if(i = 0) and (j = 0) then
						window(i, j) <= b"0000_0000_0000_0001";
					end if;
				end loop;
			end loop;
			
			for i in 0 to sizeX-1 loop
				for j in 0 to sizeY-1 loop
					ref(i, j) <= b"0000_0000_0000_0000";
				end loop;
			end loop;
			
		end if;
	end process;
	
	LEDR(0) <= ready;
	LEDR(1) <= done;
	LEDG(7 downto 0) <= std_logic_vector(output)(7 downto 0);
	
end Behavioural;