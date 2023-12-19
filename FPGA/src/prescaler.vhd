library ieee;
use ieee.std_logic_1164.all;

entity Prescaler is
  generic (
    clk_o  : positive :=10; -- Original frequency
    clk_f  : positive  :=1 -- Final frequency
  );
  port ( 
    RST_N  : in   std_logic;
    CLK    : in   std_logic;
    NewClk : out  std_logic
  );
end Prescaler;

architecture BEHAVIORAL of Prescaler is
begin
  process (RST_N, CLK)
    
    variable objetive : positive := clk_o/clk_f; -- Cantidad de ciclos a contar
    subtype count_t is natural range 0 to objetive; -- Cantidad de ciclos hasta flanco de subida o bajada
    variable count : count_t;
    variable newClk_s : std_logic:='1'; -- Reloj de salida
  begin
    if RST_N = '0' then
      count := 0;
      newClk_s := '1';
    elsif rising_edge(CLK) then
      count := count + 1; -- Con cada flanco de subida de la señal original se cuenta un ciclo
    end if;

    ifc :if count = objetive/2  then -- Cuando se alcanza la mitad del periodo se realiza el flanco
        newClk_S := not newClk_S;
        count := 0;
     end if ifc;
     newClk <= newClk_S;
  end process;
end BEHAVIORAL;
