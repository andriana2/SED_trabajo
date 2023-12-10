library ieee;
use ieee.std_logic_1164.all;

entity tb_comparador is
end tb_comparador;

architecture tb of tb_comparador is

    component comparador
    GENERIC (password : std_logic_vector(15 downto 0) := "0000000000000001");
        port (switches : in std_logic_vector (password'range);
              enable   : in std_logic;
              reset    : in std_logic;
              clk      : in std_logic;
              equal    : out std_logic);
    end component;

    signal switches : std_logic_vector (15 downto 0);
    signal enable   : std_logic;
    signal reset    : std_logic;
    signal clk      : std_logic;
    signal equal    : std_logic;

    constant TbPeriod : time := 100 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';
    signal password : std_logic_vector(15 downto 0) := "0000000000000001";

begin

    dut : comparador
    generic map ( password => password)
    port map (switches => switches,
              enable   => enable,
              reset    => reset,
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
        enable <= '0';

        -- Reset generation
        -- EDIT: Check that reset is really your reset signal
        reset <= '0';
        wait for 100 ns;
        reset <= '1';
        wait for 100 ns;
        
        enable <= '1';
        wait for 100 ns;
        switches(14) <= '1';
		wait for 100 ns;
        switches(13) <= '1';
        wait for 100 ns;
        switches(12) <= '1';
        wait for 100 ns;
        switches(11) <= '1';
        wait for 100 ns;
        switches <= (others => '0');
        wait for 100 ns;
        switches(0) <= '1';
        wait for 100 ns;
        switches(13) <= '1';
        wait for 100 ns;
        switches(12) <= '1';
        wait for 100 ns;
        switches(11) <= '1';
        wait for 100 ns;
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