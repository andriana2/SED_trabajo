--https://edaplayground.com/x/G2P7

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity comparador is 
    generic( password : std_logic_vector(4 downto 0));
    port(switches : in std_logic_vector(password'range);
        RST_N : in std_logic;
        clk   : in std_logic;
        equal : out std_logic);
end comparador;
architecture Behavioral of comparador is 
signal salida : std_logic;
begin 
    process(RST_N, clk)
    begin 
        if RST_N = '1' then
            salida <= '0';
        else
            if rising_edge(clk) then 
                if switches = password then
                    salida <= '1';
                else
                    salida <= '0';
                end if;
            end if;
        end if;
    end process;
    equal <= salida;
end Behavioral;


                