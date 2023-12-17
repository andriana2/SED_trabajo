--https://edaplayground.com/x/XU2b
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity secuencia_led is 
    generic( 
        secuencia : integer := 1231;
        width : positive := 4);
    port(
        RST_N   : in std_logic;
        clk     : in std_logic;
        end_game: out std_logic;
        light   : out std_logic_vector(2 downto 0);
        button1 : out std_logic_vector(width-1 downto 0);
        button2 : out std_logic_vector(width-1 downto 0);
        button3 : out std_logic_vector(width-1 downto 0)
    );
end secuencia_led;

architecture Behavioral of secuencia_led is 
    signal light_s   : std_logic_vector(2 downto 0) := (others => '0');
    signal button1_s : std_logic_vector(width-1 downto 0) := (others => '0');
    signal button2_s : std_logic_vector(width-1 downto 0) := (others => '0');
    signal button3_s : std_logic_vector(width-1 downto 0) := (others => '0');
begin
process(clk, RST_N)
        variable count : integer := 0;
        variable digit : integer := 0;
        variable value : integer := secuencia;
        variable flag  : integer := 0;
    begin
        if RST_N = '1' then 
            light_s <= "000";
            button1_s <= (others => '0');
            button2_s <= (others => '0');
            button3_s <= (others => '0');
            count := 0;
            value := secuencia;
            end_game <= '0';
        elsif rising_edge(clk) then
            light_s <= (others => '0');
            --wait for 100 ns;
			if (flag = 0) then flag := 1;
            else
              flag := 0;
              digit := value mod 10;
              if digit < 1 or digit > 3 then 
                  digit := 1;
              end if;

              light_s(digit-1) <= '1';
              

              case digit is
                  when 1 =>
                      button1_s(count) <= '1';
                  when 2 =>
                      button2_s(count) <= '1';
                  when 3 =>
                      button3_s(count) <= '1';
                  when others =>
                      null;
              end case;

              value := value / 10;
              count := count + 1;
              if value = 0 then end_game <= '1'; end if;
        	end if;
        end if;
end process;
    button1 <= button1_s;
    button2 <= button2_s;
    button3 <= button3_s;
    light <= light_s;

end Behavioral;
-- ten en cuenta que la secuencia es 1231 pero lo cuenta al revés
-- de derecha a izquierda y esto es por el mod
--mirar como hacer el tiempo de retraso para un punto intermedio entre luz y sin luz

