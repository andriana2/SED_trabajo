library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_cuenta_decoder is
     generic(
     itime : natural := 12
     );
     Port ( 
        CE      : in STD_LOGIC;
        RST_N   : in STD_LOGIC;
        clk     : in STD_LOGIC;
        level_std   : in std_logic ; -- cambiar luego a natural
        mode_light  : in std_logic;
        CE_light    : in std_logic;
        rgb_led : OUT STD_LOGIC_VECTOR (5 DOWNTO 0):="000000";
        ignition: out STD_LOGIC := '0';
        sseg    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        AN     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
     );
end Top_cuenta_decoder;

architecture Behavioral of Top_cuenta_decoder is
    -- Final light
    COMPONENT final_light is
      Port (    CE        : in std_logic;
                CLK       : in std_logic;
                Mode      : in std_logic;
                rgb_led : out std_logic_vector(5 downto 0)        
      );
      END COMPONENT final_light;

    -- Level counter
    COMPONENT level_counter is
      Port ( level_std  : in std_logic;
             level_RST_N: in std_logic;
             level      : out integer:=0);
    END COMPONENT level_counter;

    
    -- CUENTA --
    COMPONENT cuenta IS
        GENERIC(
        itime : natural := 120
        );
        PORT(
        CE : in STD_LOGIC;
        RST_N : in STD_LOGIC;
        clk : in STD_LOGIC;
        seconds : out natural;
        ignition : out STD_LOGIC := '0'
        );
    END COMPONENT cuenta;

    -- PRESCALER TO USER CLOCK
    component Prescaler
        generic (
        clk_o  : natural := 10; -- Original frequency
        clk_f  : natural := 1   -- Final frequency
        );
        port (RST_N  : in std_logic;
              CLK    : in std_logic;
              NewClk : out std_logic);
    end component;
     
    -- Top decoder
    component Top_decoder
        PORT (
        clk     : IN std_logic;
        seconds : IN natural;
        level   : IN integer;
        sseg    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        ANi     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0):= "00000001"
        );
    end component;
    
    signal refresh_clk : std_logic;
    signal user_clk : std_logic;
    signal final_light_clk : std_logic;
    signal seconds : positive;
    signal level: integer;

begin
    
    final_lights :final_light 
      Port map(    CE        => CE_light,
                   CLK       => final_light_clk,
                   Mode      => mode_light,
                   rgb_led   => rgb_led
      );
    
    level_count: level_counter 
      Port map(  level_std    => level_std,
                 level_RST_N  => RST_N,
                 level        => level);
  
    
    final_lights_clk : Prescaler
    generic map(
              clk_o  => 200000000, -- Original frequency
              clk_f  => 10   -- Final frequency
    )
    port map (
              RST_N  => RST_N,
              CLK    => CLK,
              NewClk => final_light_clk
              );

    to_user_clk : Prescaler
    generic map(
              clk_o  => 200000000, -- Original frequency
              clk_f  => 1   -- Final frequency
    )
    port map (
              RST_N  => RST_N,
              CLK    => CLK,
              NewClk => user_clk
              );
              
    to_refresh_clk : Prescaler
    generic map(
              clk_o  => 100000000, -- Original frequency
              clk_f  => 180   -- Final frequency 180/3=60
    )
    port map (
              RST_N  => RST_N,
              CLK    => CLK,
              NewClk => refresh_clk
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
         clk     => user_clk,
         seconds => seconds,
         ignition => ignition
        );
    
    dut3 : Top_decoder
    port map (clk     => refresh_clk,
              seconds => seconds,
              level=> level,
              sseg    => sseg,
              ANi     => AN);
end Behavioral;
