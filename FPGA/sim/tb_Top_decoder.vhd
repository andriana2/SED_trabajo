library ieee;
use ieee.std_logic_1164.all;

entity tb_Top_decoder is
end tb_Top_decoder;

architecture tb_Top_decoder of tb_Top_decoder is

    component Top_decoder
        port (seconds : in positive;
              fsseg   : out std_logic_vector (6 downto 0);
              ssseg   : out std_logic_vector (6 downto 0);
              tsseg   : out std_logic_vector (6 downto 0));
    end component;

    signal seconds : positive;
    signal fsseg   : std_logic_vector (6 downto 0);
    signal ssseg   : std_logic_vector (6 downto 0);
    signal tsseg   : std_logic_vector (6 downto 0);

begin

    dut : Top_decoder
    port map (seconds => seconds,
              fsseg   => fsseg,
              ssseg   => ssseg,
              tsseg   => tsseg);

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        a: FOR i IN 120 DOWNTO 0 LOOP
        seconds <= i;
        wait for 10ns;
        END LOOP;

        -- EDIT Add stimuli here

        wait;
    end process;

end tb_Top_decoder;
