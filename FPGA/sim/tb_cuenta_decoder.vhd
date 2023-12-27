library ieee;
use ieee.std_logic_1164.all;

entity tb_Top_cuenta_decoder is
end tb_Top_cuenta_decoder;

architecture tb of tb_Top_cuenta_decoder is

    component Top_cuenta_decoder
         generic(
            itime : positive := 120
            );
        port (CE       : in std_logic;
              RST_N    : in std_logic;
              clk      : in std_logic;
              ignition : out std_logic;
              last10   : out std_logic;
              fsseg    : out std_logic_vector (6 downto 0);
              ssseg    : out std_logic_vector (6 downto 0);
              tsseg    : out std_logic_vector (6 downto 0));
    end component;

    signal CE       : std_logic;
    signal RST_N    : std_logic;
    signal clk      : std_logic;
    signal ignition : std_logic;
    signal last10   : std_logic;
    signal fsseg    : std_logic_vector (6 downto 0);
    signal ssseg    : std_logic_vector (6 downto 0);
    signal tsseg    : std_logic_vector (6 downto 0);

    constant TbPeriod : time := 10 ns; 
    signal TbClock : std_logic := '0';


begin

    dut : Top_cuenta_decoder
    generic map(
            itime => 11
            )
    port map (CE       => CE,
              RST_N    => RST_N,
              clk      => clk,
              ignition => ignition,
              last10   => last10,
              fsseg    => fsseg,
              ssseg    => ssseg,
              tsseg    => tsseg);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2;
    clk <= TbClock;

    stimuli : process
    begin
    -- Prueba CE
        CE <= '0';
        RST_N <= '1';
        wait for 100ms;
    -- Prueba inicio, cuenta atras y last10
        CE <= '1';
        RST_N <= '0';
        wait for 10ns;
        RST_N <= '1';
        wait for 2000ms;
     -- Prueba reset
        CE <= '1';
        RST_N <= '0';
        wait for 10ns;
        RST_N <= '1';


       
        wait;
    end process;

end tb;
