----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.06.2022 23:51:53
-- Design Name: 
-- Module Name: contador_bote_tb - Behavioral
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

entity tb_contador_bote is
end tb_contador_bote;

architecture tb of tb_contador_bote is

    component contador_bote
        port (SENSOR : in std_logic;
              REARME : in std_logic;
              CLK    : in std_logic;
              RESET  : in std_logic;
              SALIDA : out std_logic);
    end component;

    signal SENSOR : std_logic;
    signal REARME : std_logic;
    signal CLK    : std_logic;
    signal RESET  : std_logic;
    signal SALIDA : std_logic;

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : contador_bote
    port map (SENSOR => SENSOR,
              REARME => REARME,
              CLK    => CLK,
              RESET  => RESET,
              SALIDA => SALIDA);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        SENSOR <= '0';
        REARME <= '0';

        -- Reset generation
        -- EDIT: Check that RESET is really your reset signal
        RESET <= '1';
        wait for 10 ns;
        RESET <= '0';
        wait for 10 ns;

        -- EDIT Add stimuli here
        wait for 20 ns;
        SENSOR<='1';
        wait for 100 ns;
        SENSOR<='0';
        REARME<='1';
        wait for 20 ns;
        REARME<='0';
        SENSOR<='1';
        wait for 100 ns;
        REARME<='1';
        wait for  1000*TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_contador_bote of tb_contador_bote is
    for tb
    end for;
end cfg_tb_contador_bote; 