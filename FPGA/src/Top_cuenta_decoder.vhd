-- CAMBIOS EN TOP DECODER Y TOP CUENTA-DECODER
-- [x]SOLO PASAN UN  VECTOR DE ACTIVACIÓN DE LOS DIFERENTES SEGMENTOS EN LUGAR DE UNO POR SEGMENTO
-- [x]DEBEN PASAR UN VECTOR DE HABILITACIÓN DE LOS DIFERENTES SEGMENTOS
-- [x]EL VECTOR DE ACTIVACIÓN DE LOS SEGMENTOS DEBE CAMBIAR AL MISMO TIEMPO QUE EL DE HABILITACIÓN DE LOS SEGMENTOS
-- [-]SE DEBE CREAR OTRA INSTANCIA DE PRESCALER PARA ADAPTAR EL RELOJ A LA FRECUENCIA DE REFRESCO
-- [] Actualizar TESTBENCH de Top DECODER
-- [] Actualizar TESTBENCH de Top CUENTA-DECODER

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
        rgb_led : OUT STD_LOGIC_VECTOR (5 DOWNTO 0):="000000";
        ignition: out STD_LOGIC := '0';
        last10  : out STD_LOGIC := '0';
        sseg    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        AN     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
     );
end Top_cuenta_decoder;

architecture Behavioral of Top_cuenta_decoder is
    signal level : integer :=0;
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
        ignition : out STD_LOGIC := '0';
        last10 : out STD_LOGIC := '0'
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
        level   : IN natural;
        sseg    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        ANi     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0):= "00000001"
        );
    end component;
    
    signal refresh_clk : std_logic;
    signal user_clk : std_logic;
    signal sad_clk : std_logic;
    signal seconds : positive;

begin
    
    --rgb_led <= "100010";
    -- ANimación de la luz
    LOST: PROCESS(sad_clk)
     variable rgb_led_v : std_logic_vector( 5 downto 0) := (OTHERS =>'0');
     BEGIN
     rising_if:if rising_edge(sad_clk) Then
        led_if:if rgb_led_v(0) = '0' THEN rgb_led_v(0) := '1'; rgb_led_v(3) := '0';  
               ELSE rgb_led_v(0) := '0'; rgb_led_v(3) := '1';
         END IF led_if;
     END IF rising_if;
     rgb_led <= rgb_led_v;
    END PROCESS LOST;
    
    too_sad_clk : Prescaler
    generic map(
              clk_o  => 200000000, -- Original frequency
              clk_f  => 10   -- Final frequency
    )
    port map (
              RST_N  => RST_N,
              CLK    => CLK,
              NewClk => sad_clk
              );
    
    
    
    
    ---
    --Tester de level
    Process (level_std)
        Begin
        if rising_edge(level_std) THEN level<= level+1; END IF;
    END Process;
    
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
         ignition => ignition,
        last10 => last10
        );
    
    dut3 : Top_decoder
    port map (clk     => refresh_clk,
              seconds => seconds,
              level => level,
              sseg    => sseg,
              ANi     => AN);
end Behavioral;
