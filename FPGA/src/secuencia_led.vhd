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
        CE      : in std_logic;
        CE_botones: out std_logic;
        light     : out std_logic_vector(2 downto 0)
    );
end secuencia_led;

architecture Behavioral of secuencia_led is 
    signal light_s   : std_logic_vector(2 downto 0) := (others => '0');
begin
process(clk, RST_N)
        variable count : integer := width;
        variable digit : integer := 0;
        variable value : integer := secuencia;
        variable flag  : integer := 0;
    begin
        if RST_N = '0' then 
            light_s <= "000";
            count := width;
            value := secuencia;
            CE_botones <= '0';
        elsif rising_edge(clk) and CE = '1' then
            light_s <= (others => '0');
            --wait for 100 ns;
			if (flag = 0) then flag := 1;
            else
                flag := 0;
                digit := value mod 10;
            if digit > 3 then 
                digit := 1; 
                
            end if;

              light_s(digit-1) <= '1';
				if count = 0 then CE_botones <= '1'; end if;
              value := value / 10;
              count := count - 1;
              
        	end if;
        end if;
end process;
    light <= light_s;

end Behavioral;
-- ten en cuenta que la secuencia es 1231 pero lo cuenta al revés
-- de derecha a izquierda y esto es por el mod
--mirar como hacer el tiempo de retraso para un punto intermedio entre luz y sin luz

