library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity secuencia_botones is
    generic(width : positive := 4);
    port(
        RST_N     : in std_logic;
        CE        : in std_logic;
        b1        : in std_logic;
        b2        : in std_logic;
        b3        : in std_logic;
        button1   : in std_logic_vector(width-1 downto 0);
        button2   : in std_logic_vector(width-1 downto 0);
        button3   : in std_logic_vector(width-1 downto 0);
        pass_game : out std_logic;
        end_game  : out std_logic
    );
end secuencia_botones;

architecture Behavioral of secuencia_botones is
    signal end_game_s : std_logic;
    signal pass_game_s : std_logic;
begin
    process(b1, b2, b3, RST_N)
        variable count : integer := 0;
    begin
        if RST_N = '1' then
            count := 0;
            end_game_s <= '0';
            pass_game_s <= '0';
        elsif CE = '1' then
            if (b1 = button1(count) and b2 = button2(count) and b3 = button3(count)) then
                count := count + 1;
            else
                end_game_s <= '1';
            end if;
        end if;
        if count = (width - 1) then
            pass_game_s <= '1';
            end_game_s <= '1';
        end if;
    end process;

    end_game <= end_game_s;
    pass_game <= pass_game_s;
end Behavioral;