LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

ENTITY cuenta IS
    GENERIC(
    itime : natural := 120
    );
    PORT(
    CE : in STD_LOGIC:= '0';
    RST_N : in STD_LOGIC :='1';
    clk : in STD_LOGIC;
    seconds : out natural;
    ignition : out STD_LOGIC := '0'
    );
END ENTITY cuenta;

ARCHITECTURE la OF cuenta IS
    
    BEGIN
    PROCESS (CLK,RST_N,CE)
        variable max_time : natural := 900;
        VARIABLE seconds_s : natural := itime;
        VARIABLE FFT : STD_LOGIC := '0'; --FLAG FIRST TIME
        
        BEGIN 
            RST_NIF: IF RST_N = '0' THEN FFT := '0'; END IF RST_NIF;
            

            -- COUNT DOWN
            CEIF:IF CE = '1' and FFT = '1' THEN
                f_if_count_down:IF rising_edge(CLK) THEN
                    s_if_count_down: IF seconds_s>0 THEN
                        seconds_s := seconds_s -1 ;
                    END IF s_if_count_down;
                END IF f_if_count_down;
            END IF CEIF;
            
            -- Se verifica que el tiempo introducido no supere el m�ximo permitido. Solo se hace una vez por cuenta atr�s.
            FFT_check:IF FFT = '0' THEN
                        timecompare :IF itime>max_time THEN
                            seconds_s := max_time;
                        ELSE
                            seconds_s := itime;
                        END IF timecompare;
                    FFT := '1';
            END IF FFT_check;
            
                seconds <= seconds_s;
                -- IGNITION
                IF seconds_s=0 THEN ignition <= '1'; ELSE ignition <= '0'; END IF;

            
    END PROCESS;

END ARCHITECTURE la;