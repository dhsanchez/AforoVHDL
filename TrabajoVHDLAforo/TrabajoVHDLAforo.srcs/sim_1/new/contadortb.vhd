----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.06.2022 20:33:41
-- Design Name: 
-- Module Name: contadortb - Behavioral
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

entity tb_contador_aforo is
end tb_contador_aforo;

architecture tb of tb_contador_aforo is

    component contador_aforo
        port (S_ENTRADA : in std_logic;
              S_SALIDA  : in std_logic;
              C_EN    : in std_logic;
              C_IN    : in std_logic_vector (3 downto 0);
              CLK     : in std_logic;
              RESET   : in std_logic;
             COUNT : out std_logic_vector(3 downto 0);
             COUNT2 : out std_logic_vector(3 downto 0);
              FULL    : out std_logic);
    end component;

    signal S_ENTRADA : std_logic;
    signal S_SALIDA  : std_logic;
    signal C_EN    : std_logic;
    signal C_IN    : std_logic_vector (3 downto 0);
    signal CLK     : std_logic;
    signal RESET   : std_logic;
    signal COUNT    : std_logic_vector(3 downto 0);
    signal COUNT2    :  std_logic_vector(3 downto 0);
    signal FULL    : std_logic;

    constant TbPeriod : time := 50 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : contador_aforo
    port map (S_ENTRADA => S_ENTRADA,
              S_SALIDA  => S_SALIDA,
              C_EN    => C_EN,
              C_IN    => C_IN,
              CLK     => CLK,
              RESET   => RESET,
              COUNT   => COUNT,
              COUNT2=> COUNT2, 
              FULL    => FULL);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        S_ENTRADA <= '0';
        S_SALIDA <= '0';
        C_EN <= '0';
        C_IN <= (others => '0');

        -- Reset generation
        -- EDIT: Check that RESET is really your reset signal
        RESET <= '1';
        wait for 10 ns;
        RESET <= '0';
        wait for 10 ns;

        -- EDIT Add stimuli here
        C_EN<='1';
        C_IN<="0011";
        wait for 1 * TbPeriod;
        C_EN<='0';
        S_ENTRADA<='1';
        wait for 200 * TbPeriod;
        S_ENTRADA<='0';
        S_SALIDA<='1';
        wait for 1 * TbPeriod;
        C_EN<='1';
        C_IN<="1111";
        wait  for 1000*TbPeriod;
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_contador_aforo of tb_contador_aforo is
    for tb
    end for;
end cfg_tb_contador_aforo;