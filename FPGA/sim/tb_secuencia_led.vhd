library ieee;
use ieee.std_logic_1164.all;

entity tb_secuencia_led is
end tb_secuencia_led;

architecture tb of tb_secuencia_led is

    component secuencia_led
		generic( 
        secuencia : integer := 3333;
        width : positive := 4);
        port (RST_N   : in std_logic;
              clk     : in std_logic;
              end_game: out std_logic;
              light   : out std_logic_vector (2 downto 0);
              button1 : out std_logic_vector (width -1 downto 0);
              button2 : out std_logic_vector (3 downto 0);
              button3 : out std_logic_vector (3 downto 0));
    end component;

    signal RST_N   : std_logic;
    signal clk     : std_logic;
    signal light   : std_logic_vector (2 downto 0);
    signal button1 : std_logic_vector (3 downto 0);
    signal button2 : std_logic_vector (3 downto 0);
    signal button3 : std_logic_vector (3 downto 0);
	signal end_game: std_logic;
    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : secuencia_led
  	generic map( 
        secuencia => 0234,
        width => 4)
    port map (RST_N   => RST_N,
              clk    => clk,
              light   => light,
              end_game => end_game,
              button1 => button1,
              button2 => button2,
              button3 => button3);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed

        -- Reset generation
        -- EDIT: Check that RST_N is really your reset signal
        RST_N <= '1';
        wait for 100 ns;
        RST_N <= '0';
        wait for 4400 ns;
        RST_N <= '1';
        wait for 100 ns;
        RST_N <= '0';
        wait for 1000 ns;

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.
