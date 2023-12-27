library ieee;
use ieee.std_logic_1164.all;

entity tb_fsm is
end tb_fsm;

architecture tb of tb_fsm is

    component fsm
        port (RST_N    : in std_logic;
              clk      : in std_logic;
              CE       : in std_logic;
              last10   : in std_logic;
              ignition : in std_logic;
              equal    : in std_logic;
              LIGHT    : out std_logic_vector (15 downto 0));
    end component;

    signal RST_N    : std_logic;
    signal clk      : std_logic;
    signal CE       : std_logic;
    signal last10   : std_logic;
    signal ignition : std_logic;
    signal equal    : std_logic;
    signal LIGHT    : std_logic_vector (15 downto 0);

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : fsm
    port map (RST_N    => RST_N,
              clk      => clk,
              CE       => CE,
              last10   => last10,
              ignition => ignition,
              equal    => equal,
              LIGHT    => LIGHT);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        CE <= '0';
        last10 <= '0';
        ignition <= '0';
        equal <= '0';

        -- Reset generation
        -- EDIT: Check that RST_N is really your reset signal
        RST_N <= '1';
        wait for 1000 ns;
        RST_N <= '0';
        wait for 100 ns;
        CE <= '1';
        wait for 10000 ns;
        last10 <= '0';
        ignition <= '0';
        equal <= '1';
        wait for 10000 ns;
        RST_N <= '1';
        wait for 1000 ns;
        RST_N <= '0';
        last10 <= '1';
        ignition <= '0';
        equal <= '0';
        wait for 10000 ns;
        last10 <= '1';
        ignition <= '1';
        equal <= '1';
        wait for 10000 ns;
        RST_N <= '1';
        wait for 1000 ns;
        RST_N <= '0';
        last10 <= '1';
        ignition <= '1';
        equal <= '0';
         wait for 10000 ns;
        RST_N <= '1';
        wait for 1000 ns;
        RST_N <= '0';
        last10 <= '1';
        ignition <= '0';
        equal <= '1';
        wait for 10000 ns;
        
        ignition <= '1';
        equal <= '1';
        
        wait for 10000 ns;
		CE <= '0';
        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_fsm of tb_fsm is
    for tb
    end for;
end cfg_tb_fsm;