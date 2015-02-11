library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

	
library work;
use work.my_types.all;

entity project_1_test_block is
	generic (
		sizeX : integer := 3;
		sizeY : integer := 3
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
		sizeX : integer;
		sizeY : integer
	);
	port (
		reset	: in std_logic;
		clock	: in std_logic;
		
		ready	: out std_logic;
		ready_block : out std_logic;
		done	: out std_logic;
		start	: in std_logic;
		start_block : in std_logic;
		block_read_en : in std_logic;

		ref_block : in BlockType(sizeX-1 downto 0, sizeY-1 downto 0);
		can_block : in BlockType(sizeX-1 downto 0, sizeY-1 downto 0);
		
		sad : out unsigned(31 downto 0)
	);
	end component;

	signal ready : std_logic;
	signal ready_block : std_logic;
	signal done : std_logic;
	
	signal output : unsigned(31 downto 0);	
	
	signal ref_block, can_block : BlockType(sizeX-1 downto 0, sizeY-1 downto 0);
	
begin
	LEDR(0) <= ready;
	LEDR(1) <= ready_block;
	LEDR(2) <= done;
	
	SB : sad_block 
		generic map (
			sizeX => sizeX,
			sizeY => sizeY
		)
		port map (
			reset => not KEY(0),
			clock => KEY(1),
			
			ready => ready,
			ready_block => ready_block,
			done => done,
			start => SW(0),
			start_block => SW(1),
			
			ref_block => ref_block,
			can_block => can_block,
			block_read_en => SW(17),
			
			sad => output
		);
	
	process(KEY(1))
	begin
		if(rising_edge(KEY(1))) then 
			for i in 0 to sizeX-1 loop
				for j in 0 to sizeY-1 loop
					can_block(i, j) <= b"0000_0000_0000_0000";
					if(i = 0) and (j = 0) then
						can_block(i, j) <= b"0000_0000_0000_0011";
					end if;
				end loop;
			end loop;
		end if;
	end process;
	
	LEDG(7 downto 0) <= std_logic_vector(output)(7 downto 0);
end Behavioural;