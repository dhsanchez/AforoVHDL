----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.06.2022 16:45:34
-- Design Name: 
-- Module Name: maquina_botes - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.STD_LOGIC_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

entity maquina_botes is
    Port ( RESET: in std_logic;
           CLK: in std_logic;
           SENSOR: in std_logic;
           REARME: in std_logic;
           CONTADOR: in std_logic;
           ERROR: out std_logic;
           led_alarma: out std_logic
     );
end maquina_botes;

architecture Behavioral of maquina_botes is
  type STATES is (S0, S1,S2);
  -- S0: El bote se encuentra lleno.
  -- S1: El  bote se encuentra vacío. 
  -- S2: ERROR. El estado de error se activara cuando estando en 
  --cualquier estado se activen simultáneamente el sensor de bote 
  -- vacio y de rearme 
  signal current_state: STATES := S0;
  signal next_state: STATES;  
  signal alarma_i: std_logic :='0';
  signal error_i: std_logic :='0';
begin
    registro_estados: process (RESET, CLK)
 begin
   if (RESET = '1') then
      current_state <= S0;
   elsif (rising_edge(CLK)) then
      current_state <= next_state;
   end if;
 end process;
 nextstateis: process(SENSOR,REARME,CONTADOR,current_state)
begin
    next_state<= current_state;
    case current_state is 
        when S0 =>
            if ((SENSOR='1' and REARME ='0')or CONTADOR='1') then
            next_state<=S1; 
            elsif (SENSOR='1' and REARME= '1') then
            next_state<=S2;
            else
            next_state<=S0;
            end if;
        when S1 =>
            if(SENSOR= '1' and REARME= '1') then
                next_state<= S2;
            elsif(SENSOR='0' and REARME='1')then 
                next_state<=S0;
            else
                next_state<=S1;
            end if;
        when S2 =>
            if(SENSOR='0' and REARME='1') then
            next_state<= S0;
            else
            next_state<=S2;
            end if;
        end case;
end process;
decodifica_salida: process(current_state)
begin
    case current_state is
    when S0 =>
        alarma_i<='0';
        error_i<='0';
    when S1 =>
        alarma_i<='1';
        error_i<='0';
    when S2 =>
        error_i<='1';
        alarma_i<='0';
    end case;
end process;
ERROR<=error_i;
led_alarma<=alarma_i;
end Behavioral;
