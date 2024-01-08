library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity top is
    port(
        RST_N     : in std_logic;
        CLK       : in std_logic;
        b1        : in std_logic;
        b2        : in std_logic;
        b3        : in std_logic;
        switches  : in std_logic_vector(3 downto 0);
        led_no    : out std_logic;
        end_time  : out std_logic;
        rgb_led   : OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
        sseg    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        AN     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        LIGHT : OUT std_logic_vector(3 downto 0);
        light_j2  : out std_logic_vector(2 downto 0)
    ); 
end top;

architecture Behavioral of top is
    component top_lb is
        generic(
            width : positive := 4;
            secuencia : integer := 1231);
        port(
            RST_N     : in std_logic;
            CLK       : in std_logic;
            CLK_LED   : in std_logic;
            CE        : in std_logic;
            b1        : in std_logic;
            b2        : in std_logic;
            b3        : in std_logic;
            led_no    : out std_logic;
            pass_game : out std_logic;
            light_j2  : out std_logic_vector(2 downto 0);
            end_game  : out std_logic
        );
    end component;
    component Prescaler is
        generic (
          clk_o  : positive :=10; -- Original frequency
          clk_f  : positive  :=1 -- Final frequency
        );
        port ( 
          RST_N  : in   std_logic;
          CLK    : in   std_logic;
          NewClk : out  std_logic);
    end component;
        --FMS--
    component fsm is
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
    end component;
        --COMPARADOR--
        
    component comparador is 
        generic( password : std_logic_vector(3 downto 0));
        port(switches : in std_logic_vector(password'range);
            RST_N : in std_logic;
            clk   : in std_logic;
            CE    : in std_logic;
            pass_game : out std_logic);
    end component;

    --TOP DECODER CUENTA--
    component Top_cuenta_decoder is
        generic(
        itime : natural := 12
        );
        Port ( 
           CE      : in STD_LOGIC;
           RST_N   : in STD_LOGIC;
           clk     : in STD_LOGIC;
           level_std   : in std_logic ; -- cambiar luego a natural
           mode_light  : in std_logic;
           CE_light    : in std_logic;
           rgb_led : OUT STD_LOGIC_VECTOR (5 DOWNTO 0):="000000";
           ignition: out STD_LOGIC := '0';
           sseg    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
           AN     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
   end component;

       -- SYNCHRNZR --
    component SYNCHRNZR is
        Port ( CLK : in STD_LOGIC;
               ASYNC_IN : in STD_LOGIC;
               SYNC_OUT : out STD_LOGIC);

    end component;

    --EDGEDTCTR--
    component EDGEDTCTR is
        Port ( CLK : in STD_LOGIC;
               SYNC_IN : in STD_LOGIC;
               EDGE : out STD_LOGIC);
    end component;
--BOTONES
    signal b1_c : std_logic;
    signal b2_c : std_logic;
    signal b3_c : std_logic;
    signal b1_sa : std_logic;
    signal b2_sa : std_logic;
    signal b3_sa : std_logic;
    --PREESCALER
    signal NewClk    : std_logic;

-- FMS
    signal CE       : std_logic_vector (5 downto 0);
    signal CE_cuenta: std_logic;
    signal CE_RGB   : std_logic;
    signal pass_game : std_logic_vector(5 downto 0);
    signal end_game : std_logic_vector(2 downto 0);
    signal level_up : std_logic;
    signal mode_light : std_logic;
    signal end_time_s : std_logic; 
    --Debugging:
    signal led_no_v : std_logic_vector(2 downto 0):= (OTHERS =>'0');
    signal light_j2_1,light_j2_2,light_j2_3 : std_logic_vector(2 downto 0):=(OTHERS=>'0');
    signal RST_N_s : std_logic;

begin
    --Debuggin
    led_no <= led_no_v(0) or led_no_v(1) or led_no_v(2);
    light_j2 <= light_j2_1 or light_j2_2 or light_j2_3;
    ---
    --nivel 1--
    dut1: comparador
    generic map( password => "0100")
    port map(
        switches => switches,
        RST_N => RST_N,
        CLK => CLK,
        CE => CE(0),
        pass_game => pass_game(0)
    );
    --nivel 2--
    dut2 : top_lb
    generic map(secuencia => 1231,
        width => 4)
        port map(
            RST_N  => RST_N,
            CE  => CE(1),
            CLK => CLK,
            CLK_LED => NewClk,
            b1        => b1_sa,
            b2        => b2_sa,
            b3        => b3_sa,
            led_no    => led_no_v(0),
            pass_game => pass_game(1),
            light_j2 => light_j2_1,
            end_game  => end_game(0)
        );
        --nivel 3--
    dut3: comparador
    generic map( password => "0110")
    port map(
        switches => switches,
        RST_N => RST_N,
        CLK => CLK,
        CE => CE(2),
        pass_game => pass_game(2)
    );
    --nivel 4--
    dut4 : top_lb
    generic map(secuencia => 13312,
        width => 5)
        port map(
            RST_N  => RST_N,
            CE  => CE(3),
            CLK => CLK,
            CLK_LED => NewClk,
            b1        => b1_sa,
            b2        => b2_sa,
            b3        => b3_sa,
            led_no    => led_no_v(1),
            pass_game => pass_game(3),
            light_j2 => light_j2_2,
            end_game  => end_game(1)
        );
    --nivel 5--
    dut5: comparador
    generic map( password => "0111")
    port map(
        switches => switches,
        RST_N => RST_N,
        CLK => CLK,
        CE => CE(4),
        pass_game => pass_game(4)
    );
    --nivel 6--
    dut6 : top_lb
    generic map(secuencia => 3123321,
        width => 7)
        port map(
            RST_N  => RST_N,
            CE  => CE(5),
            CLK => CLK,
            CLK_LED => NewClk,
            b1        => b1_sa,
            b2        => b2_sa,
            b3        => b3_sa,
            led_no    => led_no_v(2),
            pass_game => pass_game(5),
            light_j2 => light_j2_3,
            end_game  => end_game(2)
        );
    dut7 :fsm
    port map(
        RST_N => RST_N,
        CLK => CLK,
        end_time => end_time_s,
        pass_game => pass_game,
        end_game => end_game,
        CE => CE,
        CE_cuenta => CE_cuenta,
        CE_RGB => CE_RGB,
        modo =>mode_light,
        levelUP =>level_up,
        LIGHT =>LIGHT
    );

    dut8 : Top_cuenta_decoder
    generic map(
        itime => 120
    )
    port map(
        CE => CE_cuenta,
        RST_N => RST_N,
        CLK => CLK,
        level_std => level_up,
        mode_light  => mode_light,
        CE_light => CE_RGB,
        rgb_led =>rgb_led,
        ignition => end_time_s,
        sseg => sseg,
        AN => AN
    );
    dut14: Prescaler
        generic map(
            clk_o  => 100000000, -- Original frequency
            clk_f  => 1)
        port map( 
            RST_N  => RST_N,
            CLK    => CLK,
            NewClk => NewClk
        );
    --boton1
    dut15 : SYNCHRNZR
    port map (
        SYNC_OUT  => b1_c,
        ASYNC_IN  => b1,
        CLK    => CLK);
    dut16: EDGEDTCTR
    port map(
        SYNC_IN => b1_c,
        EDGE  => b1_sa,
        CLK    => CLK
    );

    --boton2
    dut17 : SYNCHRNZR
    port map (
        SYNC_OUT  => b2_c,
        ASYNC_IN  => b2,
        CLK    => CLK
    );
    dut18: EDGEDTCTR
    port map(
        SYNC_IN => b2_c,
        EDGE  => b2_sa,
        CLK    => CLK
    );
    --boton3
    dut19 : SYNCHRNZR
    port map (
        SYNC_OUT  => b3_c,
        ASYNC_IN  => b3,
        CLK    => CLK
    );
    dut20: EDGEDTCTR
    port map(
        SYNC_IN => b3_c,
        EDGE  => b3_sa,
        CLK    => CLK
    );
    end_time <= end_time_s;
end Behavioral;