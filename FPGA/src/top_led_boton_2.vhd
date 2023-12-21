library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity top_botones is
    generic(
        width : positive := 4;
        secuencia : integer := 1231);
    port(
        RST_N     : in std_logic;
        CLK       : in std_logic;
        CE        : in std_logic;
        b1        : in std_logic;
        b2        : in std_logic;
        b3        : in std_logic;
        led_no   : out std_logic;
        pass_game : out std_logic;
        light     : out std_logic_vector(2 downto 0);
        end_game  : out std_logic
    ); 
end top_botones;

architecture Behavioral of top_botones is
    component secuencia_botones is
        generic(
            width : positive := 4;
            secuencia : integer := 1231);
        port(
            RST_N     : in std_logic;
            CE        : in std_logic;
            CLK       : in std_logic;
            b1        : in std_logic;
            b2        : in std_logic;
            b3        : in std_logic;
            led_no    : out std_logic;
            pass_game : out std_logic := '0';
            end_game  : out std_logic := '0'
        ); 
    end component;
    component Prescaler is
        generic (
          clk_o  : positive :=10; -- Original frequency
          clk_f  : positive  :=1 -- Final frequency
        );
        port ( 
          RST_N  : in   std_logic;
          CLK    : in   std_logic;
          NewClk : out  std_logic);
    end component;
    component secuencia_led is
        generic( 
            secuencia : integer;
            width : positive);
        port(
            RST_N   : in std_logic;
            clk     : in std_logic;
            CE      : in std_logic;
            CE_botones: out std_logic;
            light     : out std_logic_vector(2 downto 0)
        );
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

    signal b1_c : std_logic;
    signal b2_c : std_logic;
    signal b3_c : std_logic;
    signal b1_sa : std_logic;
    signal b2_sa : std_logic;
    signal b3_sa : std_logic;
    signal CE_botones: std_logic;
    signal NewClk    : std_logic;
begin
    dut : secuencia_botones
    generic map(secuencia => secuencia,
        width => width)
        port map(
            RST_N  => RST_N,
            CE  => CE_botones,
            CLK => CLK,
            b1        => b1_sa,
            b2        => b2_sa,
            b3        => b3_sa,
            led_no    => led_no,
            pass_game => pass_game,
            end_game  => end_game
        );
    dut10 : secuencia_led
        generic map(
        secuencia => secuencia,
        width => width)
        port map (
            RST_N  => RST_N,
            CLK    => NewClk,
            CE  => CE,
            CE_botones => CE_botones,
            light     => light
    );
    dut9: Prescaler
        generic map(
            clk_o  => 200000000, -- Original frequency
            clk_f  => 1)
        port map( 
            RST_N  => RST_N,
            CLK    => CLK,
            NewClk => NewClk
        );
    --boton1
    dut2 : SYNCHRNZR
    port map (
        SYNC_OUT  => b1_c,
        ASYNC_IN  => b1,
        CLK    => CLK);
    dut3: EDGEDTCTR
    port map(
        SYNC_IN => b1_c,
        EDGE  => b1_sa,
        CLK    => CLK
    );

    --boton2
    dut4 : SYNCHRNZR
    port map (
        SYNC_OUT  => b2_c,
        ASYNC_IN  => b2,
        CLK    => CLK
    );
    dut5: EDGEDTCTR
    port map(
        SYNC_IN => b2_c,
        EDGE  => b2_sa,
        CLK    => CLK
    );
    --boton3
    dut6 : SYNCHRNZR
    port map (
        SYNC_OUT  => b3_c,
        ASYNC_IN  => b3,
        CLK    => CLK
    );
    dut7: EDGEDTCTR
    port map(
        SYNC_IN => b3_c,
        EDGE  => b3_sa,
        CLK    => CLK
    );
end Behavioral;