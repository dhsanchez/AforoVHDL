----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.06.2022 19:51:08
-- Design Name: 
-- Module Name: contador_aforo - Behavioral
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
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity contador_aforo is
generic (
    WIDTH : positive := 4 -- aforo máximo del local 15 personas
);
    Port ( S_ENTRADA : in std_logic;
           S_SALIDA : in std_logic;
           C_EN: in std_logic;
           C_IN: in std_logic_vector(WIDTH-1 downto 0);
           CLK    : in std_logic;
           RESET  : in std_logic;
           COUNT : out std_logic_vector(WIDTH-1 downto 0);
           COUNT2 : out std_logic_vector(WIDTH-1 downto 0);
           FULL   : out std_logic;
           ERROR: out std_logic
           );
end contador_aforo;

architecture Behavioral of contador_aforo is
 signal FULL_i : std_logic := '0';
 signal ERROR_i: std_logic:= '0';
 signal numero: std_logic_vector(WIDTH-1 downto 0);
 signal numero2: std_logic_vector(WIDTH-1 downto 0);
begin
process(CLK,RESET)
begin
    if (RESET= '1') then
    numero<="0000";
    numero2<="0000";
    FULL_i<= '0';
    elsif(rising_edge(CLK))then
    
        if(C_EN='1')then
            numero<= C_IN;
        else
            if (S_ENTRADA='1')then
             if(numero= "1001" and numero2="1001")then
                ERROR_i<='1';
             else
                numero <= numero+1;
             end if;
            end if;
            if (S_SALIDA ='1')then
              if(numero= "1001" and numero2="1001")then
                ERROR_i<='0';
              end if;
                numero<=numero-1;
            end if;
        end if;
        
        if(numero= "1001" and numero2="1001")then
            full_i<= '1';
        elsif(numero= "1010")then
            numero<="0001";
            numero2<=numero2+1;
        else
            full_i<= '0';
        end if;
        
    end if;
FULL <=full_i;   
ERROR<=ERROR_i; 
end process;
COUNT<=numero;
COUNT2<=numero2;
end Behavioral;
