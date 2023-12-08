library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_decoder is
end tb_decoder;

architecture tb of tb_decoder is

    component decoder
        port (code : in std_logic_vector (3 downto 0);
              led  : out std_logic_vector (6 downto 0));
    end component;

    signal code : std_logic_vector (3 downto 0);
    signal led  : std_logic_vector (6 downto 0);

begin

    dut : decoder
    port map (code => code,
              led  => led);

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        code <= (others => '0');

        a: FOR i IN 0 to 10 LOOP
        code <= std_logic_vector(to_unsigned(i,code'length));
        wait for 10ns;
        END LOOP;

        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_decoder of tb_decoder is
    for tb
    end for;
end cfg_tb_decoder;