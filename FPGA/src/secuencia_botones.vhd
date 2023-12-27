
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
        CLK       : in std_logic;
        b1        : in std_logic;
        b2        : in std_logic;
        b3        : in std_logic;
        led_no    : out std_logic;
        pass_game : out std_logic := '0';
        end_game  : out std_logic := '0'
    ); 
end secuencia_botones;

architecture Behavioral of secuencia_botones is
    signal end_game_s : std_logic;
    signal pass_game_s : std_logic;
    signal led_no_s : std_logic := '0';
begin
    process(clk, RST_N)
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
            led_no_s <= '0';
        elsif CE = '1' and rising_edge(CLK) then
            led_no_s <='0';
            if(value > 0) then 
                digit := value mod 10;
            end if;
            if (digit = 1 and b1 = '1') then
                count := count - 1;
                value := value / 10;
            elsif (digit = 2 and b2 = '1') then
                count := count - 1;
                value := value / 10;
            elsif (digit = 3 and b3 = '1') then
                count := count - 1;
                value := value / 10;
            elsif (b1 = '0' and b2 = '0' and b3 = '0') then
                led_no_s <= '1';
            else
                end_game_s <= '1';
                led_no_s <= '0';
            end if;
        end if;
        if value = 0 and end_game_s = '0' then
            pass_game_s <= '1';
        end if;
    end process;
    led_no <= led_no_s;
    end_game <= end_game_s;
    pass_game <= pass_game_s;
end Behavioral;