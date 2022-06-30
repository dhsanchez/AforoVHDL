----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.06.2022 18:36:10
-- Design Name: 
-- Module Name: cfg_control_display - Behavioral
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

entity tb_control_display is
end tb_control_display;

architecture tb of tb_control_display is

    component control_display
        port (CLK             : in std_logic;
              CUENTA          : in std_logic_vector (3 downto 0);
              CUENTA2         : in std_logic_vector(3 downto 0);
              refrescar_anodo : out std_logic_vector (7 downto 0);
              salida_disp     : out std_logic_vector (6 downto 0));
    end component;

    signal CLK             : std_logic;
    signal CUENTA          : std_logic_vector (3 downto 0);
    signal CUENTA2         : std_logic_vector (3 downto 0);
    signal refrescar_anodo : std_logic_vector (7 downto 0);
    signal salida_disp     : std_logic_vector (6 downto 0);

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : control_display
    port map (CLK             => CLK,
              CUENTA          => CUENTA,
              CUENTA2         => CUENTA2,
              refrescar_anodo => refrescar_anodo,
              salida_disp     => salida_disp);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        CUENTA <= (others => '0');
        CUENTA2 <= (others => '0');

        -- Reset generation
        --  EDIT: Replace YOURRESETSIGNAL below by the name of your reset as I haven't guessed it
        CUENTA<="1001";
        wait for 100 ns;
        CUENTA2<="0001";
        wait for 100 ns;
        CUENTA<="0001";
        wait for 100 ns;
        wait for 10000 ns;

        -- EDIT Add stimuli here
        

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_control_display of tb_control_display is
    for tb
    end for;
end cfg_tb_control_display;