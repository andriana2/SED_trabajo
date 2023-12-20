library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity secuencia_botones is
    generic(
        width : positive := 4;
        secuencia : integer := 1231);
    
    port(
        RST_N     : in std_logic;
        CE        : in std_logic;
        b1        : in std_logic;
        b2        : in std_logic;
        b3        : in std_logic;
     --   button1   : in std_logic_vector(width-1 downto 0);
      --  button2   : in std_logic_vector(width-1 downto 0);
       -- button3   : in std_logic_vector(width-1 downto 0);
        pass_game : out std_logic;
        end_game  : out std_logic
    );
end secuencia_botones;

architecture Behavioral of secuencia_botones is
    signal end_game_s : std_logic;
    signal pass_game_s : std_logic;
begin
    process(b1, b2, b3, RST_N)
        variable value : integer := secuencia;
        variable count : integer := width - 1;
        variable digit : integer := 0;
    begin
        if RST_N = '0' then
            count := width - 1;
            end_game_s <= '0';
            pass_game_s <= '0';
            value := secuencia;
            digit := 0;
        elsif CE = '1' then
            if(value > 0) then 
                digit := value mod 10;
            end if;
            if (digit = 1) and (b1 = '1') then
                count := count + 1;
            elsif (digit = 2) and b2 = '1' then
                count := count + 1;
            elsif (digit = 3) and b3 = '1' then
                count := count + 1;
            else
                end_game_s <= '1';
            end if;
            value := value / 10;
            count := count - 1;
        end if;
        if count = 0 then
            pass_game_s <= '1';
        end if;
    end process;

    end_game <= end_game_s;
    pass_game <= pass_game_s;
end Behavioral;