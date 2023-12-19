--https://edaplayground.com/x/YTHc

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm is
    Port (
        RST_N    : in STD_LOGIC;
        CLK      : in STD_LOGIC;
        end_time : in STD_LOGIC;
        pass_game: in std_logic_vector (5 downto 0);
        end_game : in std_logic_vector (2 downto 0);
        CE       : out std_logic_vector (5 downto 0);
        CE_cuenta: out std_logic;
        light_g  : out std_logic_vector(1 downto 0) <= "00";
        light_r  : out std_logic_vector(1 downto 0) <= "00";
        LIGHT    : out STD_LOGIC_VECTOR(10 downto 0)
    );
end fsm;

architecture Behavioral of fsm is
    type STATES is (S0, S1, S2, S3, S4, S5, S6, S7);
    signal current_state : STATES := S0;
    signal next_state    : STATES;

begin
    state_register: process (RST_N, CLK, end_time)
    begin
        if (RST_N = '1') then
            current_state <= S0;
            light_g  <= "00";
            light_r  <= "00";
            LIGHT <= (others => '0');
            --count := 0;
        elsif rising_edge(CLK) then
            current_state <= next_state;
        elsif end_time = '1' and current_state /= S6 then
            current_state <= S7;
        end if;
    end process;

    nextstate_decod: process (current_state, CE, pass_game)
    begin
        variable count : integer := 0;
        next_state <= current_state;
        case current_state is
            when S0 =>
                if pass_game(count) = '1' then
                    next_state <= S1;
                    count := count + 1;
                end if;
            when S1 =>
                if end_game(count - 1) = '1' and pass_game(count) = '1' then
                    next_state <= S2;
                    count := count + 1;
                elsif end_game(count - 1)  = '1' and pass_game(count) = '0' then
                    next_state <= S7;
                end if;
            when S2 =>
                if pass_game(count) = '1' then
                    next_state <= S3;
                    count := count + 1;
                end if;
            when S3 =>
                if end_game(count - 2) = '1' and pass_game(count) = '1' then
                    next_state <= S4;
                    count := count + 1;
                elsif end_game(count - 2) = '1' and pass_game(count) = '0' then
                    next_state <= S7;
                end if;
            when S4 =>
                if pass_game(count) = '1' then
                    next_state <= S5;
                    count := count + 1;
                end if;
            when S5 =>
                if end_game(count - 3) = '1' and pass_game(count) = '1' then
                    next_state <= S6;
                elsif end_game(count - 3) = '1' and pass_game(count) = '0' then
                    next_state <= S7;
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
                LIGHT <= (others => '0');
                LIGHT(10)<= '1';
                LIGHT(9) <= '1';

                LIGHT(0) <= '1';

            when S2 =>
                LIGHT <= (others => '0');
                LIGHT(10)<= '1';
                LIGHT(9) <= '1';
                LIGHT(8) <= '1';

                LIGHT(2) <= '1';

            when S4 =>
                LIGHT <= (others => '0');
                LIGHT(10)<= '1';
                LIGHT(9) <= '1';
                LIGHT(8) <= '1';
                LIGHT(7) <= '1';
                
                LIGHT(4) <= '1';
            when S1 =>
                LIGHT(1) <= '1';
            when S3 =>
                LIGHT(3) <= '1';
            when S5 =>
                LIGHT(5) <= '1';
            when S6 =>
                light_g <= "11";
                LIGHT(6) <= '1';
            when S7 =>
                light_r <= "11"
                LIGHT(7) <= '1';
            when others =>
                LIGHT <= (OTHERS => '0');
        end case;
    end process;

end Behavioral;
