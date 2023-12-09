LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

ENTITY cuenta IS
    GENERIC(
    itime : positive := 120
    );
    PORT(
    clk : in STD_LOGIC;
    seconds : out positive
    );
END ENTITY cuenta;

ARCHITECTURE la OF cuenta IS
    
    BEGIN
    PROCESS (CLK)
        variable max_time : positive := 900;
        VARIABLE seconds_s : POSITIVE := itime;
        VARIABLE FFT : STD_LOGIC := '0'; --FLAG FIRST TIME
        
        --variable seconds_s : positive:= IF (itime<max_time THEN itime ELSE max_time )END IF;

        BEGIN 
            -- Se verifica que el tiempo introducido no supere el máximo permitido. Solo se hace una vez por cuenta atrás.
            FFT_check:IF FFT = '0' THEN
                        timecompare :IF itime>max_time THEN
                            seconds_s := max_time;
                        END IF timecompare;
                    FFT := '1';
            END IF FFT_check;
            
            IF rising_edge(CLK) THEN
            seconds_s := seconds_s -1 ;
            END IF;
            seconds <= seconds_s;
    END PROCESS;

END ARCHITECTURE la;