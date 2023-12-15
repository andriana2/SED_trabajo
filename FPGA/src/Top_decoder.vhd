LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

ENTITY Top_decoder IS
    PORT (
        clk     : IN std_logic;
        seconds : IN positive;
        sseg    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        ANi     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0):= "00000001"
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
    TYPE positive_array is  array (2 DOWNTO 0) of positive;
    SIGNAL digits : positive_array; --:=(0,0,0);
    TYPE ssegms_array is array (2 DOWNTO 0) of std_logic_vector(6 DOWNTO 0);
    SIGNAL ssegms_decoded : ssegms_array;
    
BEGIN

    refresh: PROCESS (clk)
        variable ANi_var : STD_LOGIC_VECTOR (ANi'range);
        BEGIN 
            IF rising_edge(clk) THEN
                CASE ANi_var IS
                    WHEN "11111110" =>           
                        ANi_var := "11111101"; 
                        sseg <= ssegms_decoded(1);
                    WHEN "11111101" =>
                        ANi_var := "11111011";
                        sseg <= ssegms_decoded(2);
                    WHEN OTHERS =>
                        ANi_var := "11111110";
                        sseg <= ssegms_decoded(0);
                END CASE;
            END IF; 
            ANi <= ANi_var;
    END PROCESS refresh;
    -- Cada vez que se actualiza el valor de seconds, se actualiza tambi�n su descomposici�n
    digit_separator:PROCESS (seconds)
        TYPE positive_array is  array (2 DOWNTO 0) of positive;
        Variable digits_var : positive_array; --:=(Positive'(0),Positive'(0),Positive'(0));
        BEGIN
            FOR i IN 0 TO 2 LOOP
            digits_var(i) := (seconds /(10**i)) mod 10;
            ssegms_code(i) <= std_logic_vector(to_unsigned(digits_var(i), 4)) ;  
        END LOOP ;
    END PROCESS digit_separator;
   
   decoders: FOR i IN 0 TO 2 GENERATE
    d: decoder PORT MAP(
    code => ssegms_code(i),
    led  => ssegms_decoded(i)
    );
    END GENERATE;
END ARCHITECTURE dataflow;
