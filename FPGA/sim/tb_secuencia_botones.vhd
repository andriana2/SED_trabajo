library ieee;
use ieee.std_logic_1164.all;

entity tb_secuencia_botones is
end tb_secuencia_botones;

architecture tb of tb_secuencia_botones is

    component secuencia_botones
    generic( 
        width : positive := 4);
        port (RST_N     : in std_logic;
              CE        : in std_logic;
              b1        : in std_logic;
              b2        : in std_logic;
              b3        : in std_logic;
              button1   : in std_logic_vector (3 downto 0);
              button2   : in std_logic_vector (3 downto 0);
              button3   : in std_logic_vector (3 downto 0);
              pass_game : out std_logic;
              end_game  : out std_logic);
    end component;

    signal RST_N     : std_logic;
    signal CE        : std_logic;
    signal b1        : std_logic;
    signal b2        : std_logic;
    signal b3        : std_logic;
    signal button1   : std_logic_vector (3 downto 0):= "1000";
    signal button2   : std_logic_vector (3 downto 0):= "0101";
    signal button3   : std_logic_vector (3 downto 0):= "0010";
    signal pass_game : std_logic;
    signal end_game  : std_logic;

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : secuencia_botones
    port map (RST_N     => RST_N,
              CE        => CE,
              b1        => b1,
              b2        => b2,
              b3        => b3,
              button1   => button1,
              button2   => button2,
              button3   => button3,
              pass_game => pass_game,
              end_game  => end_game);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    --  EDIT: Replace YOURCLOCKSIGNAL below by the name of your clock as I haven't guessed it
    --  YOURCLOCKSIGNAL <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        CE <= '1';
        b1 <= '0';
        b2 <= '0';
        b3 <= '0';

        -- Reset generation
        -- EDIT: Check that RST_N is really your reset signal
        RST_N <= '1';
        wait for 100 ns;
        RST_N <= '0';
        wait for 1000 ns;
        b1<='1';
        b2<='0';
        b3<='0';        
        wait for 1000 ns;
        b1<='0';
        b2<='1';
        b3<='0';
        wait for 1000 ns;
        b1<='0';
        b2<='0';
        b3<='1';
        wait for 1000 ns;
        b1<='0';
        b2<='1';
        b3<='0';
        wait for 1000 ns;
        
        RST_N <= '1';
        wait for 1000 ns;
        RST_N <= '0';
        --CE <= '0';
        wait for 1000 ns;
        b1<='1';
        b2<='1';
        b3<='0';
        wait for 1000 ns;
        b1<='0';
        b2<='1';
        b3<='0';
        wait for 1000 ns;

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_secuencia_botones of tb_secuencia_botones is
    for tb
    end for;
end cfg_tb_secuencia_botones;