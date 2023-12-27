library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity final_light is
  Port (    CE        : in std_logic;
            CLK       : in std_logic;
            Mode      : in std_logic;
            rgb_led : out std_logic_vector(5 downto 0)        
  );
end final_light;

architecture Behavioral of final_light is
   signal rgb_led_v  : std_logic_vector( 5 downto 0) := (OTHERS =>'0');
begin
    -- ANimación de la luz

    LOST: PROCESS(clk,CE)

     variable party_state: integer:=0;
     BEGIN
     ce_if:if CE = '0' THEN
        rgb_led_v <= (OTHERS =>'0');
     elsif CE = '1' THEN
        rising_if:if rising_edge(clk) Then
                 if mode = '0' THEN
                         
                    rgb_led_v <= (OTHERS =>'0');
                    led_if_SAD:if rgb_led_v(0) = '0' THEN rgb_led_v(0) <= '1'; rgb_led_v(3) <= '0';  
                           ELSE rgb_led_v(0) <= '0'; rgb_led_v(3) <= '1';
                     END IF led_if_SAD;
                         
                 ELSIF mode = '1' THEN
                    rgb_led_v <= (OTHERS =>'0');
                    rgb_led_v(2) <= '1';
                     case party_state is
                        WHEN 0 =>
                         rgb_led_v <= "111101";
                         party_state := party_state +1;
                         WHEN 1 =>
                         rgb_led_v <= "101111";
                         party_state := party_state +1;
                         WHEN 2 =>
                         rgb_led_v <= "111011";
                         party_state := party_state +1;
                         WHEN 3 =>
                         rgb_led_v <= "110111";
                         party_state := party_state +1;
                         WHEN 4 =>
                         rgb_led_v <= "101111";
                         party_state := party_state +1;
                         WHEN 5 =>
                         rgb_led_v <= "011111";
                         party_state := party_state +1;
                         WHEN OTHERS =>
                         rgb_led_v <= "111110";
                         party_state := 0;                        
                     END case;
                     
                 END IF;
       END IF rising_if;
     END IF ce_if;
     
     rgb_led <= rgb_led_v;
    END PROCESS LOST;


end Behavioral;
