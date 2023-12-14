--https://edaplayground.com/x/YTHc

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm is
    Port (
        RST_N    : in STD_LOGIC;
        CLK      : in STD_LOGIC;
        last10   : in STD_LOGIC;
        ignition : in STD_LOGIC;
        equal    : in STD_LOGIC;
        CE       : out STD_LOGIC;
        LIGHT    : out STD_LOGIC_VECTOR(0 to 15)
    );
end fsm;

architecture Behavioral of fsm is
    type STATES is (S0, S1, S2);
    signal current_state : STATES := S0;
    signal next_state    : STATES;
--CE meter los valores '0' no esta contando 
begin
    state_register: process (RST_N, CLK)
    begin
        if (RST_N = '0') then
            current_state <= S0;
        elsif rising_edge(CLK) then
            current_state <= next_state;
        end if;
    end process;

    nextstate_decod: process (current_state, equal, last10, ignition)
    begin
        next_state <= current_state;
        case current_state is
            when S0 =>
                if equal = '1' and last10 = '0' then
                    next_state <= S1;
                elsif ignition = '1' then
                    if equal = '1' then
                        next_state <= S1;
                    else
                        next_state <= S2;
                    end if;
                end if;
            when others =>
                next_state <= current_state;
        end case;
    end process;

    output_decod: process (current_state)
    begin
        LIGHT <= (OTHERS => '0');
        case current_state is
            when S0 =>
                LIGHT(15) <= '1';
            when S1 =>
                LIGHT(0) <= '1';
                LIGHT(1) <= '1';
                LIGHT(2) <= '1';
                LIGHT(3) <= '1';
            when S2 =>
                LIGHT <= (OTHERS => '1');
            when others =>
                LIGHT <= (OTHERS => '0');
        end case;
    end process;

end Behavioral;
