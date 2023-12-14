
library ieee;
use ieee.std_logic_1164.all;

entity tb_comparador is
end tb_comparador;


architecture tb of tb_comparador is

    component comparador
     GENERIC (password : std_logic_vector(4 downto 0) := "00001");
        port (switches : in std_logic_vector (password'range);
              RST_N    : in std_logic;
              clk      : in std_logic;
              equal    : out std_logic);
    end component;

    signal switches : std_logic_vector (4 downto 0);
    signal RST_N    : std_logic;
    signal clk      : std_logic;
    signal equal    : std_logic;
    signal password : std_logic_vector(4 downto 0) := "00001";
    


    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : comparador
    generic map (password => password)
    port map (switches => switches,
              RST_N    => RST_N,
              clk      => clk,
              equal    => equal);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
         switches <= (others => '0');

        -- Reset generation
        -- EDIT: Check that reset is really your reset signal
        RST_N <= '0';
        wait for 100 ns;
        RST_N <= '1';
        wait for 100 ns;
        RST_N <= '0';
        wait for 100 ns;
        switches <= (others => '1');
        wait for 100 ns;
        switches(4) <= '1';
        wait for 100 ns;
        switches <= (others => '0');
        wait for 1000 ns;
        switches(3) <= '1';
        wait for 1000 ns;
        switches <= (others => '0');
        wait for 1000 ns;
        switches(2) <= '1';
        wait for 1000 ns;
        switches <= (others => '0');
        wait for 1000 ns;
        switches(1) <= '1';
        wait for 1000 ns;
        switches <= (others => '0');
        wait for 1000 ns;
        switches(0) <= '1';
        wait for 1000 ns;

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_comparador of tb_comparador is
    for tb
    end for;
end cfg_tb_comparador;