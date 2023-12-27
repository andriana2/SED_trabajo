library ieee;
use ieee.std_logic_1164.all;

entity tb_top_lb is
end tb_top_lb;

architecture tb of tb_top_lb is

    component top_lb
    generic(
        width : positive := 4;
        secuencia : integer := 1231);
        port (RST_N     : in std_logic;
              CLK       : in std_logic;
              CLK_LED   : in std_logic;
              CE        : in std_logic;
              b1        : in std_logic;
              b2        : in std_logic;
              b3        : in std_logic;
              led_no    : out std_logic;
              pass_game : out std_logic;
              light_j2  : out std_logic_vector (2 downto 0);
              end_game  : out std_logic);
    end component;

    signal RST_N     : std_logic;
    signal CLK       : std_logic;
    signal CLK_LED   : std_logic;
    signal CE        : std_logic;
    signal b1        : std_logic;
    signal b2        : std_logic;
    signal b3        : std_logic;
    signal led_no    : std_logic;
    signal pass_game : std_logic;
    signal light_j2  : std_logic_vector (2 downto 0);
    signal end_game  : std_logic;

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : top_lb
    generic map(width => 4,
    secuencia => 1231)
    port map (RST_N     => RST_N,
              CLK       => CLK,
              CLK_LED   => CLK_LED,
              CE        => CE,
              b1        => b1,
              b2        => b2,
              b3        => b3,
              led_no    => led_no,
              pass_game => pass_game,
              light_j2  => light_j2,
              end_game  => end_game);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;
    CLK_LED <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        CE <= '1';
        b1 <= '0';
        b2 <= '0';
        b3 <= '0';

        -- Reset generation
        -- EDIT: Check that RST_N is really your reset signal
        RST_N <= '0';
        wait for 100 ns;
        RST_N <= '1';
        wait for 100 ns;
        b1 <= '0';
        b2 <= '0';
        b3 <= '0';
        
wait for 6000 ns;
        b1 <= '1';
        b2 <= '0';
        b3 <= '0';
        wait for 1000 ns;
        b1 <= '0';
        b2 <= '0';
        b3 <= '1';
        wait for 1000 ns;
        b1 <= '0';
        b2 <= '1';
        b3 <= '0';
         wait for 1000 ns;
        b1 <= '0';
        b2 <= '0';
        b3 <= '0';
        wait for 1000 ns;
        b1 <= '0';
        b2 <= '1';
        b3 <= '0';
         wait for 1000 ns;
        b1 <= '0';
        b2 <= '0';
        b3 <= '0';
        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_top_lb of tb_top_lb is
    for tb
    end for;
end cfg_tb_top_lb;