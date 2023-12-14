library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_comparador is
     generic( password : std_logic_vector(4 downto 0));
     Port ( 
        RST_N   : in STD_LOGIC;
        clk     : in STD_LOGIC;
        switches_top : in std_logic_vector(password'range);
        equal : out std_logic
     );
end top_comparador;

architecture Behavioral of top_comparador is
    -- COMPARADOR --
    component comparador is 
        generic( password : std_logic_vector(4 downto 0));
        port(switches : in std_logic_vector(password'range);
            RST_N : in std_logic;
            clk   : in std_logic;
            equal : out std_logic);
    end component;

    -- SYNCHRNZR --
    component SYNCHRNZR is
        Port ( CLK : in STD_LOGIC;
               ASYNC_IN : in STD_LOGIC;
               SYNC_OUT : out STD_LOGIC);

    end component;

    --EDGEDTCTR--
    component EDGEDTCTR is
        Port ( CLK : in STD_LOGIC;
               SYNC_IN : in STD_LOGIC;
               EDGE : out STD_LOGIC);
    end component;


    --añadir CE
    signal sw4 : std_logic;
    signal sw3 : std_logic;
    signal sw2 : std_logic;
    signal sw1 : std_logic;
    signal sw0 : std_logic;
    signal sw_final : std_logic_vector(password'range);
    --signal password : std_logic_vector(4 downto 0) := "00001";
    

begin
    dut : comparador
    generic map(password => password)
    port map (
        --CE     => CE := '0',--valor por defecto
        RST_N  => RST_N,
        CLK    => CLK,
        switches => sw_final,
        equal  => equal
    );

    --SWITCH 4
    dut2 : SYNCHRNZR
    port map (
        SYNC_OUT  => sw4,
        ASYNC_IN  => switches_top(4),
        CLK    => CLK);
    dut3: EDGEDTCTR
    port map(
        SYNC_IN => sw4,
        EDGE  => sw_final(4),
        CLK    => CLK
    );

    --SWITCH 3
    dut4 : SYNCHRNZR
    port map (
        SYNC_OUT  => sw3,
        ASYNC_IN  => switches_top(3),
        CLK    => CLK
    );
    dut5: EDGEDTCTR
    port map(
        SYNC_IN => sw3,
        EDGE  => sw_final(3),
        CLK    => CLK
    );
    --SWITCH 2
    dut6 : SYNCHRNZR
    port map (
        SYNC_OUT  => sw2,
        ASYNC_IN  => switches_top(2),
        CLK    => CLK
    );
    dut7: EDGEDTCTR
    port map(
        SYNC_IN => sw2,
        EDGE  => sw_final(2),
        CLK    => CLK
    );
    --SWITCH 1
    dut8 : SYNCHRNZR
    port map (
        SYNC_OUT  => sw1,
        ASYNC_IN  => switches_top(1),
        CLK    => CLK
    );
    dut9: EDGEDTCTR
    port map(
        SYNC_IN => sw1,
        EDGE  => sw_final(1),
        CLK    => CLK
    );
    --SWITCH 0
    dut10 : SYNCHRNZR
    port map (
        SYNC_OUT  => sw0,
        ASYNC_IN  => switches_top(0),
        CLK    => CLK
    );
    dut11: EDGEDTCTR
    port map(
        SYNC_IN => sw0,
        EDGE  => sw_final(0),
        CLK    => CLK
    );
end Behavioral;