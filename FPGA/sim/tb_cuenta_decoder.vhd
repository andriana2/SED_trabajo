-- Este testbench agrupa el contador y el decoder
-- Servirá de referencia para instanciar Top


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_decoder_cuenta is
end tb_decoder_cuenta;

architecture tb_dc of tb_decoder_cuenta is
    -- CUENTA --
    COMPONENT cuenta IS
        GENERIC(
        itime : positive := 120
        );
        PORT(
        CE : in STD_LOGIC;
        RST_N : in STD_LOGIC;
        clk : in STD_LOGIC;
        seconds : out positive;
        ignition : out STD_LOGIC := '0';
        last10 : out STD_LOGIC := '0'
        );
    END COMPONENT cuenta;

    signal seconds : positive;
    signal ignition : STD_LOGIC;
    signal last10 : STD_LOGIC;
    signal CE : STD_LOGIC := '0';
    
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
    
    -- Top decoder
    component Top_decoder
        port (seconds : in positive;
              fsseg   : out std_logic_vector (6 downto 0);
              ssseg   : out std_logic_vector (6 downto 0);
              tsseg   : out std_logic_vector (6 downto 0));
    end component;

    signal fsseg   : std_logic_vector (6 downto 0);
    signal ssseg   : std_logic_vector (6 downto 0);
    signal tsseg   : std_logic_vector (6 downto 0);


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
        (
         CE => CE,
         RST_N => RST_N,
         clk     => NewClk,
         seconds => seconds,
         ignition => ignition,
        last10 => last10
        );
    
    dut3 : Top_decoder
    port map (seconds => seconds,
              fsseg   => fsseg,
              ssseg   => ssseg,
              tsseg   => tsseg);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2;
    clk <= TbClock;
    
    -- PRUEBA CON CE y RST_N
    PROCESS
    BEGIN
    wait for 104 ms;
    CE <= '1';
    RST_N <= '0';
    wait for 10 ns;
    RST_N <= '1';
    wait; 
    END PROCESS;

end tb_dc;
