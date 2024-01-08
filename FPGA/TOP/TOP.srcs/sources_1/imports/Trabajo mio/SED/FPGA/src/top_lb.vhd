library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity top_lb is
    generic(
        width : positive := 4;
        secuencia : integer := 1231);
    port(
        RST_N     : in std_logic;
        CLK       : in std_logic;
        CLK_LED   : in std_logic;
        CE        : in std_logic;
        b1        : in std_logic;
        b2        : in std_logic;
        b3        : in std_logic;
        led_no    : out std_logic;
        pass_game : out std_logic;
        light_j2     : out std_logic_vector(2 downto 0);
        end_game  : out std_logic
    ); 
end top_lb;

architecture Behavioral of top_lb is
    component secuencia_botones is
        generic(
            width : positive;
            secuencia : integer );
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
    component secuencia_led is
        generic( 
            secuencia : integer;
            width : positive);
        port(
            RST_N   : in std_logic;
            clk     : in std_logic;
            CE      : in std_logic;
            CE_botones: out std_logic;
            light_j2     : out std_logic_vector(2 downto 0)
        );
    end component;

    signal CE_botones: std_logic;
 
begin
    dut11 : secuencia_led
        generic map(
        secuencia => secuencia,
        width => width)
        port map (
            RST_N  => RST_N,
            CLK    => CLK_LED,
            CE  => CE,
            CE_botones => CE_botones,
            light_j2     => light_j2
    );
    dut0 : secuencia_botones
    generic map(secuencia => secuencia,
    width => width)
    port map(
        RST_N  => RST_N,
        CE  => CE_botones,
        CLK => CLK,
        b1        => b1,
        b2        => b2,
        b3        => b3,
        led_no    => led_no,
        pass_game => pass_game,
        end_game  => end_game
    );
end Behavioral;