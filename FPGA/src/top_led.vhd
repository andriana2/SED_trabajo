
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity top_led is 
    generic( 
        secuencia : integer := 1231;
        width : positive := 4);
    port(
        RST_N   : in std_logic;
        clk     : in std_logic;
        CE      : in std_logic;
        CE_botones: out std_logic;
        light     : out std_logic_vector(2 downto 0)
    );
    
end top_led;

architecture behavioral of top_led is
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
    --PRESCALER--
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
    signal NewClk : std_logic;
begin 

    dut : secuencia_led
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

end architecture;