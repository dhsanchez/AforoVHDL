----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.06.2022 01:31:05
-- Design Name: 
-- Module Name: prescale - Behavioral
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

entity prescale is

Port (
    CLK_IN : in  STD_LOGIC;
    RESET  : in  STD_LOGIC;
    CLK_OUT: out STD_LOGIC
);
end prescale;

architecture Behavioral of prescale is
signal temporal: STD_LOGIC;
signal counter : integer range 0 to 4999 := 0;
begin
process (CLK_IN) begin
    if rising_edge(CLK_IN) then
        if (counter = 4999) then
            temporal <= NOT(temporal);
            counter <= 0;
        else
            counter <= counter + 1;
        end if;
    end if;
end process;

CLK_OUT <= temporal;
end Behavioral;
