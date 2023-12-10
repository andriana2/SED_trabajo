library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_kaboom is
     generic(
     itime : positive := 120
     );
     Port ( 
        CE      : in STD_LOGIC;
        RST_N   : in STD_LOGIC;
        clk     : in STD_LOGIC;

        LIGHT    : out STD_LOGIC_VECTOR(0 to 15)
        fsseg   : out std_logic_vector (6 downto 0);
        ssseg   : out std_logic_vector (6 downto 0);
        tsseg   : out std_logic_vector (6 downto 0)
     );
end Top_kaboom;

architecture Behavioral of Top_kaboom is
    -- Top_cuenta_decoder --
    component Top_cuenta_decoder is
        generic(
        itime : positive := 120
        );
        Port ( 
           CE      : in STD_LOGIC;
           RST_N   : in STD_LOGIC;
           clk     : in STD_LOGIC;
           ignition: out STD_LOGIC := '0';
           last10  : out STD_LOGIC := '0';
           fsseg   : out std_logic_vector (6 downto 0);
           ssseg   : out std_logic_vector (6 downto 0);
           tsseg   : out std_logic_vector (6 downto 0)
        );
    end component;
    -- COMPARADOR --
    component comparador is 
        generic( password : std_logic_vector(15 downto 0) := "0000 0000 0000 0001" );
        port(switches : in std_logic_vector(password'range);
            CE : in std_logic;
            RST_N : in std_logic;
            clk   : in std_logic;
            equal : out std_logic);
    end component;

    -- MAQUINA DE ESTADO --
    component fsm is
        Port (
            RST_N    : in STD_LOGIC;
            CLK      : in STD_LOGIC;
            CE       : in STD_LOGIC;
            last10   : in STD_LOGIC;
            ignition : in STD_LOGIC;
            equal    : in STD_LOGIC;
            LIGHT    : out STD_LOGIC_VECTOR(0 to 15)
        );
    end component;

    signal equal : std_logic;
    signal ignition: STD_LOGIC := '0';
    signal last10  : STD_LOGIC := '0';

begin
    dut : Top_cuenta_decoder
    generic map(
        itime  => 120
    )
    port map (
        RST_N => RST_N,
        CLK   => CLK,
        CE    => CE,
        ignition => ignition,
        last10 => last10,
        fsseg => fsseg,
        ssseg => ssseg,
        tsseg => tsseg
    );

    dut2 : comparador
    generic map(
        password => password
    )
    port map (
        CE     => CE,
        RST_N  => RST_N,
        CLK    => CLK,
        equal  => equal
    );

    dut2 : fsm
    port map (
        CE     => CE,
        RST_N  => RST_N,
        CLK    => CLK,
        equal  => equal,
        ignition => ignition,
        last10 => last10,
        LIGHT => LIGHT
    );

end Behavioral;
