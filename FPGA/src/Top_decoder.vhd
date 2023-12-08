LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

ENTITY Top_decoder IS
    PORT (
        seconds : IN positive;
        fsseg   : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        ssseg   : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        tsseg   : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END ENTITY Top_decoder;

ARCHITECTURE dataflow OF Top_decoder IS
    COMPONENT decoder
    PORT (
        code : IN std_logic_vector(3 DOWNTO 0);
        led  : OUT std_logic_vector(6 DOWNTO 0)
    );
    END COMPONENT decoder;

    SIGNAL fcode, scode, tcode : std_logic_vector(3 DOWNTO 0);

BEGIN

    
        fcode <= std_logic_vector(to_unsigned(seconds mod 10, 4));
        scode <= std_logic_vector(to_unsigned((seconds / 10) mod 10, 4));
        tcode <= std_logic_vector(to_unsigned((seconds / 100) mod 10, 4));


    fdecoder_inst: decoder PORT MAP (
        code => fcode,
        led  => fsseg
    );

    sdecoder_inst: decoder PORT MAP (
        code => scode,
        led  => ssseg
    );

    tdecoder_inst: decoder PORT MAP (
        code => tcode,
        led  => tsseg
    );

END ARCHITECTURE dataflow;
