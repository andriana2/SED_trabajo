library ieee;
use ieee.std_logic_1164.all;

entity tb_cuenta is
end tb_cuenta;

architecture tb of tb_cuenta is
    -- CUENTA --
    component cuenta
         GENERIC(
    itime : positive := 120
    );
    PORT(
    clk : in STD_LOGIC;
    seconds : out positive
    );
    end component cuenta;

    signal seconds : positive;
    
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
        itime => 10
        )
    port map 
        (clk     => NewClk,
         seconds => seconds);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2;
    clk <= TbClock;
 

end tb;
