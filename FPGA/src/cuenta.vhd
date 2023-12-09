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
    seconds : out positive;
    ignition : out STD_LOGIC := '0';
    last10 : out STD_LOGIC := '0'
    );
END ENTITY cuenta;

ARCHITECTURE la OF cuenta IS
    
    BEGIN
    PROCESS (CLK)
        variable max_time : positive := 900;
        VARIABLE seconds_s : POSITIVE := itime;
        VARIABLE FFT : STD_LOGIC := '0'; --FLAG FIRST TIME
        
        BEGIN 
            -- Se verifica que el tiempo introducido no supere el m�ximo permitido. Solo se hace una vez por cuenta atr�s.
            FFT_check:IF FFT = '0' THEN
                        timecompare :IF itime>max_time THEN
                            seconds_s := max_time;
                        END IF timecompare;
                    FFT := '1';
            END IF FFT_check;
            -- COUNT DOWN
            IF rising_edge(CLK) and seconds_s/=0 THEN
            seconds_s := seconds_s -1 ;
            END IF;
            seconds <= seconds_s;
            -- IGNITION
            IF seconds_s=0 THEN ignition <= '1'; END IF;
            -- LAST 10 seconds
            IF seconds_s<=10 THEN last10 <= '1'; END IF;
    END PROCESS;

END ARCHITECTURE la;