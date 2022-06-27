----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.06.2022 01:32:01
-- Design Name: 
-- Module Name: tb - Behavioral
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
use ieee.std_logic_1164.all;

entity preescaler_tb is
end preescaler_tb;

architecture tb of preescaler_tb is

    component preescaler
        port (CLK_IN    : in std_logic;
              RESET     : in std_logic;
              preescale : in positive;
              CLK_OUT   : out std_logic);
    end component;

    signal CLK_IN   : std_logic := '0';
    signal RESET     : std_logic;
    signal CLK_OUT : std_logic;
    signal preescale : positive := 10;

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : preescaler
    port map (CLK_IN    => CLK_IN,
              RESET     => RESET,
              preescale => preescale,             
              CLK_OUT   => CLK_OUT);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK_IN  is really your main clock signal
    CLK_IN <= TbClock;
    stimuli : process
    begin
        -- EDIT Adapt initialization as needed

        -- Reset generation
        -- EDIT: Check that rst is really your reset signal
        RESET <= '0';
        wait for 10 ns;
        RESET <= '1';
        wait for 10 ns;

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
