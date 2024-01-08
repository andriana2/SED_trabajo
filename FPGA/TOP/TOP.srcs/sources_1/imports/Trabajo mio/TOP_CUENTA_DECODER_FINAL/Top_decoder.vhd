-- CAMBIOS EN TOP DECODER 
-- [x]SOLO PASAN UN  VECTOR DE ACTIVACIÓN DE LOS DIFERENTES SEGMENTOS EN LUGAR DE UNO POR SEGMENTO
-- [x]DEBEN PASAR UN VECTOR DE HABILITACIÓN DE LOS DIFERENTES SEGMENTOS
-- [x]EL VECTOR DE ACTIVACIÓN DE LOS SEGMENTOS DEBE CAMBIAR AL MISMO TIEMPO QUE EL DE HABILITACIÓN DE LOS SEGMENTOS
-- [] Actualizar TESTBENCH de Top DECODER

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

ENTITY Top_decoder IS
    PORT (
        clk     : IN std_logic;
        seconds : IN natural;
        level   : IN integer;
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
    
    Type ssegms_code_array is array (4 DOWNTO 0) of std_logic_vector(3 DOWNTO 0); -- 4,3 Nivel y 2,1,0 segundos
    SIGNAL ssegms_code : ssegms_code_array;
    TYPE ssegms_array is array (4 DOWNTO 0) of std_logic_vector(6 DOWNTO 0);
    SIGNAL ssegms_decoded : ssegms_array;
    
BEGIN
    
    refresh: PROCESS (clk)
        variable ANi_var : STD_LOGIC_VECTOR (ANi'range);
        BEGIN 
            IF rising_edge(clk) THEN
                CASE ANi_var IS
                -- Segundos
                    WHEN "11111110" =>           
                        ANi_var := "11111101"; 
                        sseg <= ssegms_decoded(1);
                    WHEN "11111101" =>
                        ANi_var := "11111011";
                        sseg <= ssegms_decoded(2);
                -- Level
                    WHEN "11111011" =>
                        ANi_var := "11101111";
                        sseg <= ssegms_decoded(3);
                    WHEN "11101111" =>
                        ANi_var := "11011111";
                        sseg <=    ssegms_decoded(4);
                    WHEN OTHERS =>
                        ANi_var := "11111110";
                        sseg <= ssegms_decoded(0);
                END CASE;
            END IF; 
            ANi <= ANi_var;
    END PROCESS refresh;
    -- Descomposición de levels
    
    -- Cada vez que se actualiza el valor de seconds, se actualiza también su descomposición
    digit_separator:PROCESS (seconds)
        TYPE positive_array is  array (2 DOWNTO 0) of positive;
        Variable digits_var : positive_array; --:=(Positive'(0),Positive'(0),Positive'(0));
        TYPE positive_array_level is  array (1 DOWNTO 0) of positive;
        Variable digits_level_var : positive_array_level; --:=(Positive'(0),Positive'(0),Positive'(0));
        BEGIN
            -- Descomposición de segundos
            FOR i IN 0 TO 2 LOOP
            digits_var(i) := (seconds /(10**i)) mod 10;
            ssegms_code(i) <= std_logic_vector(to_unsigned(digits_var(i), 4)) ;  
            END LOOP ;
            -- Descomposición de nivel
            FOR i IN 0 TO 1 LOOP
            digits_level_var(i) := (level /(10**i)) mod 10;
            ssegms_code(i+3) <= std_logic_vector(to_unsigned(digits_level_var(i), 4)) ;  
            END LOOP;
    END PROCESS digit_separator;
   
   decoders: FOR i IN 0 TO 4 GENERATE
    d: decoder PORT MAP(
    code => ssegms_code(i),
    led  => ssegms_decoded(i)
    );
    END GENERATE;
END ARCHITECTURE dataflow;
