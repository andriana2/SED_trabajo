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
        CE_RGB   : out std_logic;
        modo     : out std_logic;
        levelUP  : out std_logic;
        LIGHT    : out STD_LOGIC_VECTOR(3 downto 0)
    );
end fsm;

architecture Behavioral of fsm is
    type STATES is (S0, S1, S2, S3, S4, S5, S6, S7);
    signal current_state : STATES := S0;
    signal next_state    : STATES;
    signal CE_s       : std_logic_vector (5 downto 0):= (others => '0');
    signal CE_cuenta_s: std_logic;
    signal CE_RGB_s   : std_logic := '0';
    signal modo_s     : std_logic := '1';
    signal LIGHT_s    : STD_LOGIC_VECTOR(LIGHT'range);
    signal levelUP_s  : std_logic :='0';

begin
    state_register: process (RST_N, CLK, end_time)
    begin
        if (RST_N = '0') then
            current_state <= S0;
        elsif rising_edge(CLK) then
            current_state <= next_state;
            if end_time = '1' and current_state /= S6 then
            current_state <= S7;
            end if;
        end if;
    end process; 

    nextstate_decod: process (current_state, pass_game, end_game)
    begin
        next_state <= current_state;
        case current_state is
            when S0 =>
                levelUP_s <= '0';
                CE_cuenta_s <= '1';
                
                CE_s <= (others => '0');
                CE_s(0) <= '1';
                
                if pass_game(0) = '1' then
                    next_state <= S1;
                    levelUP_s <= '1';
                end if;

            when S1 =>
                levelUP_s <= '0';
                
                CE_s <= (others => '0');
                CE_s(1) <= '1';

                if pass_game(1) = '1' then
                    next_state <= S2;
                    levelUP_s <= '1';
                elsif end_game(0) = '1' and pass_game(1) = '0' then
                    next_state <= S7;
                end if;

            when S2 =>
                levelUP_s <= '0';
                CE_s <= (others => '0');
                CE_s(2) <= '1';

                if pass_game(2) = '1' then
                    next_state <= S3;
                    levelUP_s <= '1';
                end if;
            when S3 =>
                levelUP_s <= '0';
                CE_s <= (others => '0');
                CE_s(3) <= '1';

                if pass_game(3) = '1' then
                    next_state <= S4;
                    levelUP_s <= '1';
                elsif end_game(1) = '1' and pass_game(3) = '0' then
                    next_state <= S7;
                end if;
            when S4 =>
                levelUP_s <= '0';
                CE_s <= (others => '0');
                CE_s(4) <= '1';

                if pass_game(4) = '1' then
                    next_state <= S5;
                    levelUP_s <= '1';
                end if;
            when S5 =>
                levelUP_s <= '0';
                CE_s <= (others => '0');
                CE_s(5) <= '1';

                if pass_game(5) = '1' then
                    next_state <= S6;
                elsif end_game(2) = '1' and pass_game(5) = '0' then
                    next_state <= S7;
                end if;
             when S6 =>
                levelUP_s <= '0';
            	 CE_cuenta_s <= '0';
             when S7 =>
             CE_cuenta_s <= '0';
            when others =>
                next_state <= S0;
                
        end case;
        levelUP <= levelUP_s;
    end process;

    output_decod: process (current_state)
    begin
        LIGHT_s <= (OTHERS => '0');
        case current_state is
            when S0 =>
               -- LIGHT_s <= (others => '0');
                LIGHT_s(3)<= '1';
                LIGHT_s(2) <= '1';

                CE_RGB_s <= '0';

            when S2 =>
              --  LIGHT_s <= (others => '0');
                LIGHT_s(3)<= '1';
                LIGHT_s(2) <= '1';
                LIGHT_s(1) <= '1';

                CE_RGB_s <= '0';

            when S4 =>
                --LIGHT_s <= (others => '0');
                LIGHT_s(3)<= '1';
                LIGHT_s(2) <= '1';
                LIGHT_s(1) <= '1';
                LIGHT_s(0) <= '1';
                
                CE_RGB_s <= '0';
            when S6 =>
                CE_RGB_s <= '1';
                modo_s <= '1';
            when S7 =>
                CE_RGB_s <= '1';
                modo_s <= '0';
            when others =>
                LIGHT_s <= (OTHERS => '0');
        end case;
    end process;
    CE <= CE_s;
    CE_cuenta <= CE_cuenta_s;
    CE_RGB <= CE_RGB_s;
    modo <= modo_s;
    LIGHT <= LIGHT_s;

end Behavioral;