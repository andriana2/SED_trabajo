library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_cuenta_decoder is
     generic(
     itime : positive := 120
     );
     Port ( 
        CE      : in STD_LOGIC;
        RST_N   : in STD_LOGIC;
        clk     : in STD_LOGIC;
        ignition: out STD_LOGIC := '0';
        last10  : out STD_LOGIC := '0';
        fsseg   : out std_logic_vector (6 downto 0);
        ssseg   : out std_logic_vector (6 downto 0);
        tsseg   : out std_logic_vector (6 downto 0)
     );
end Top_cuenta_decoder;

architecture Behavioral of Top_cuenta_decoder is
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
     
    -- Top decoder
    component Top_decoder
        port (seconds : in positive;
              fsseg   : out std_logic_vector (6 downto 0);
              ssseg   : out std_logic_vector (6 downto 0);
              tsseg   : out std_logic_vector (6 downto 0));
    end component;
    
    signal NewClk : std_logic;
    signal seconds : positive;

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
        itime => itime
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
end Behavioral;
