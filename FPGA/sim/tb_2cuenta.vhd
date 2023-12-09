library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_2cuenta is
end tb_2cuenta;

architecture tb_2_cuenta of tb_2cuenta is
    -- CUENTA --
    COMPONENT cuenta IS
        GENERIC(
        itime : positive := 120
        );
        PORT(
        clk : in STD_LOGIC;
        seconds : out positive;
        ignition : out STD_LOGIC := '0';
        last10 : out STD_LOGIC := '0'
        );
    END COMPONENT cuenta;

    signal seconds : positive;
    signal ignition : STD_LOGIC;
    signal last10 : STD_LOGIC;
    
    -- SEÑAL DE RELOJ ORIGINAL
    constant TbPeriod : time := 10ns; -- EDIT Put right period here
    signal TbClock : std_logic := '1';
    signal clk     : std_logic;
    
    -- PRESCALER
    component Prescaler
        generic (
        clk_o  : positive := 10; -- Original frequency
        clk_f  : positive := 1   -- Final frequency
        );
        port (RST_N  : in std_logic;
              CLK    : in std_logic;
              NewClk : out std_logic);
    end component;

    signal RST_N  : std_logic:='1';
    signal NewClk : std_logic;


begin
    
    dut : Prescaler
    generic map(
              clk_o  => 100000000, -- Original frequency
              clk_f  => 1   -- Final frequency
    )
    port map (
              RST_N  => RST_N,
              CLK    => CLK,
              NewClk => NewClk
              );
    
    dut2 : cuenta
    generic map
        (
        itime => 11
        )
    port map 
        (clk     => NewClk,
         seconds => seconds,
         ignition => ignition,
        last10 => last10
        );

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2;
    clk <= TbClock;
 

end tb_2_cuenta;
