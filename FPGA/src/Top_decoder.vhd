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
    
    Type ssegms_code_array is array (2 DOWNTO 0) of std_logic_vector(3 DOWNTO 0);
    SIGNAL ssegms_code : ssegms_code_array;


BEGIN

        digits: FOR i IN 0 TO 2 GENERATE
        ssegms_code(i) <= std_logic_vector(to_unsigned((seconds /(10**i)) mod 10, 4));
        END GENERATE digits;    

    fdecoder_inst: decoder PORT MAP (
        code => ssegms_code(0),
        led  => fsseg
    );

    sdecoder_inst: decoder PORT MAP (
        code => ssegms_code(1),
        led  => ssseg
    );

    tdecoder_inst: decoder PORT MAP (
        code => ssegms_code(2),
        led  => tsseg
    );

END ARCHITECTURE dataflow;
