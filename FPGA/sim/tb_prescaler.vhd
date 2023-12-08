library ieee;
use ieee.std_logic_1164.all;

entity tb_Prescaler is
end tb_Prescaler;

architecture tb of tb_Prescaler is

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
    signal CLK    : std_logic;
    signal NewClk : std_logic;


    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '1';

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
    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 ;
    CLK <= TbClock;

  
end tb;
