----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.06.2022 23:38:45
-- Design Name: 
-- Module Name: contador_bote - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity contador_bote is
    Port (SENSOR: in std_logic;
          REARME: in std_logic;
          CLK: in std_logic; 
          RESET:in std_logic;
          SALIDA: out std_logic);
    
end contador_bote;

architecture Behavioral of contador_bote is
signal cuenta: integer:= 0;
constant maximo: positive:= 10;
signal salida_i: std_logic;
begin
process(CLK,RESET)
begin
    if (RESET= '1' or REARME='1') then
    cuenta<=0;
    elsif(rising_edge(CLK))then
        if(SENSOR='1' and cuenta/=maximo) then
            cuenta<=cuenta+1;
        else
            cuenta<=cuenta;
        end if;
    end if;
 end process;
 gestion_salida:process(cuenta)
 begin
    if (cuenta=maximo) then
        salida_i<='1';
        
    else
        salida_i<='0';
    end if;
 end process;
 SALIDA<=salida_i;

end Behavioral;
