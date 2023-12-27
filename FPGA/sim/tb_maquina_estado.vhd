library ieee;
use ieee.std_logic_1164.all;

entity tb_fsm is
end tb_fsm;

architecture tb of tb_fsm is

    component fsm
        port (RST_N     : in std_logic;
              CLK       : in std_logic;
              end_time  : in std_logic;
              pass_game : in std_logic_vector (5 downto 0);
              end_game  : in std_logic_vector (2 downto 0);
              CE        : out std_logic_vector (5 downto 0);
              CE_cuenta : out std_logic;
              CE_RGB    : out std_logic;
              modo      : out std_logic;
              levelUP   : out std_logic;
              LIGHT     : out std_logic_vector (3 downto 0));
    end component;

    signal RST_N     : std_logic;
    signal CLK       : std_logic;
    signal end_time  : std_logic;
    signal pass_game : std_logic_vector (5 downto 0);
    signal end_game  : std_logic_vector (2 downto 0);
    signal CE        : std_logic_vector (5 downto 0);
    signal CE_cuenta : std_logic;
    signal CE_RGB    : std_logic;
    signal modo      : std_logic;
    signal levelUP   : std_logic;
    signal LIGHT     : std_logic_vector (3 downto 0);

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : fsm
    port map (RST_N     => RST_N,
              CLK       => CLK,
              end_time  => end_time,
              pass_game => pass_game,
              end_game  => end_game,
              CE        => CE,
              CE_cuenta => CE_cuenta,
              CE_RGB    => CE_RGB,
              modo      => modo,
              levelUP   => levelUP,
              LIGHT     => LIGHT);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        end_time <= '0';
        pass_game <= (others => '0');
        end_game <= (others => '0');

        -- Reset generation
        -- EDIT: Check that RST_N is really your reset signal
        RST_N <= '0';
        wait for 100 ns;
        RST_N <= '1';
        wait for 2000 ns;
        pass_game <= (others => '0');
        pass_game(0) <= '1';
        
		wait for 2000 ns;
        pass_game <= (others => '0');
        pass_game(1) <= '1';
		wait for 2000 ns;
                pass_game <= (others => '0');

        pass_game(2) <= '1';
		wait for 2000 ns;
                pass_game <= (others => '0');

        pass_game(3) <= '1';
		wait for 2000 ns;
                pass_game <= (others => '0');

        pass_game(4) <= '1';
		wait for 2000 ns;
                pass_game <= (others => '0');

        pass_game(5) <= '1';
		wait for 2000 ns;
        
        
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