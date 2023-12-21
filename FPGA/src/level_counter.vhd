library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity level_counter is
  Port ( level_std  : in std_logic;
         level_RST_N: in std_logic;
         level      : out integer:=0);
end level_counter;

architecture Behavioral of level_counter is

begin
    Level_logic:Process (level_std, level_RST_N)
    variable level_v: integer:=0;
        Begin
        if level_RST_N = '0' THEN level_v:= 0; 
        elsif rising_edge(level_std) THEN level_v:= level_v+1; END IF;
        level <= level_v;
    END Process;

end Behavioral;
