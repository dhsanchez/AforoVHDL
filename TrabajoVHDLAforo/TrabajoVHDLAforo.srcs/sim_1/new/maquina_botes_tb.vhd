----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.06.2022 17:24:38
-- Design Name: 
-- Module Name: maquina_botes_tb - Behavioral
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

entity tb_maquina_botes is
end tb_maquina_botes;

architecture tb of tb_maquina_botes is

    component maquina_botes
        port (RESET      : in std_logic;
              CLK        : in std_logic;
              SENSOR     : in std_logic;
              REARME     : in std_logic;
              CONTADOR   : in std_logic;
              ERROR      : out std_logic;
              led_alarma : out std_logic);
    end component;

    signal RESET      : std_logic;
    signal CLK        : std_logic;
    signal SENSOR     : std_logic;
    signal REARME     : std_logic;
    signal CONTADOR   : std_logic;
    signal ERROR      : std_logic;
    signal led_alarma : std_logic;

    constant TbPeriod : time := 75 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : maquina_botes
    port map (RESET      => RESET,
              CLK        => CLK,
              SENSOR     => SENSOR,
              REARME     => REARME,
              CONTADOR   => CONTADOR,
              ERROR      => ERROR,
              led_alarma => led_alarma);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        SENSOR <= '0';
        REARME <= '0';
        CONTADOR <= '0';

        -- Reset generation
        -- EDIT: Check that RESET is really your reset signal
        RESET <= '1';
        wait for 100 ns;
        RESET <= '0';
        wait for 100 ns;

        -- EDIT Add stimuli here
        SENSOR<='1';
        REARME<='0';
        wait for 100 ns;
        SENSOR<='0';
        REARME<='1';
        wait for 100 ns;
        SENSOR<='1';
        REARME<='0';
        wait for 100 ns;
        REARME<='1';
        SENSOR<='1';
        wait for 100 ns;
        SENSOR<='0';
        REARME<='1';
        wait for 100 ns;
        REARME<='1';
        SENSOR<='1';
        wait for 1000 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_maquina_botes of tb_maquina_botes is
    for tb
    end for;
end cfg_tb_maquina_botes;