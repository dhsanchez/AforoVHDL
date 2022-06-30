----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.06.2022 11:57:53
-- Design Name: 
-- Module Name: control_aforo_tb - Behavioral
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


library ieee;
use ieee.std_logic_1164.all;

entity tb_controlaforo is
end tb_controlaforo;

architecture tb of tb_controlaforo is

    component controlaforo
        port (S_ENTRADA       : in std_logic;
              S_SALIDA        : in std_logic;
              S_BOTE1         : in std_logic;
              S_BOTE2         : in std_logic;
              A_BOTE1         : in std_logic;
              A_BOTE2         : in std_logic;
              CLK             : in std_logic;
              RESET           : in std_logic;
              C_IN            : in std_logic_vector (3 downto 0);
              C_EN            : in std_logic;
              REARME1         : in std_logic;
              REARME2         : in std_logic;
              refrescar_anodo : out std_logic_vector (7 downto 0);
              salida_disp     : out std_logic_vector (6 downto 0);
              LED_GEL1        : out std_logic;
              LED_GEL2        : out std_logic;
              LED_ALARMA      : out std_logic;
              LED_ERROR       : out std_logic;
              LED_ERROR1      : out std_logic;
              LED_ERROR2      : out std_logic);
    end component;

    signal S_ENTRADA       : std_logic;
    signal S_SALIDA        : std_logic;
    signal S_BOTE1         : std_logic;
    signal S_BOTE2         : std_logic;
    signal A_BOTE1         : std_logic;
    signal A_BOTE2         : std_logic;
    signal CLK             : std_logic;
    signal RESET           : std_logic;
    signal C_IN            : std_logic_vector (3 downto 0);
    signal C_EN            : std_logic;
    signal REARME1         : std_logic;
    signal REARME2         : std_logic;
    signal refrescar_anodo : std_logic_vector (7 downto 0);
    signal salida_disp     : std_logic_vector (6 downto 0);
    signal LED_GEL1        : std_logic;
    signal LED_GEL2        : std_logic;
    signal LED_ALARMA      : std_logic;
    signal LED_ERROR       : std_logic;
    signal LED_ERROR1      : std_logic;
    signal LED_ERROR2      : std_logic;

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : controlaforo
    port map (S_ENTRADA       => S_ENTRADA,
              S_SALIDA        => S_SALIDA,
              S_BOTE1         => S_BOTE1,
              S_BOTE2         => S_BOTE2,
              A_BOTE1         => A_BOTE1,
              A_BOTE2         => A_BOTE2,
              CLK             => CLK,
              RESET           => RESET,
              C_IN            => C_IN,
              C_EN            => C_EN,
              REARME1         => REARME1,
              REARME2         => REARME2,
              refrescar_anodo => refrescar_anodo,
              salida_disp     => salida_disp,
              LED_GEL1        => LED_GEL1,
              LED_GEL2        => LED_GEL2,
              LED_ALARMA      => LED_ALARMA,
              LED_ERROR       => LED_ERROR,
              LED_ERROR1      => LED_ERROR1,
              LED_ERROR2      => LED_ERROR2);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        S_ENTRADA <= '0';
        S_SALIDA <= '0';
        S_BOTE1 <= '0';
        S_BOTE2 <= '0';
        A_BOTE1 <= '0';
        A_BOTE2 <= '0';
        C_IN <= (others => '0');
        C_EN <= '0';
        REARME1 <= '0';
        REARME2 <= '0';

        -- Reset generation
        -- EDIT: Check that RESET is really your reset signal
        RESET <= '1';
        wait for 100 ns;
        RESET <= '0';
        wait for 100 ns;

        -- EDIT Add stimuli here
        C_EN<='1';
        C_IN<="0011";
        wait for 100 ns;
        S_ENTRADA<='1';
        wait for 500 ns;
        S_ENTRADA<='0';
        wait for 100 ns;
        S_SALIDA<='1';
        wait for 100 ns;
        S_BOTE1<='1';
        wait for 100 ns;
        S_BOTE2<='1';
        wait for 100 ns;
        
        wait for 10000 ns;
       
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_controlaforo of tb_controlaforo is
    for tb
    end for;
end cfg_tb_controlaforo;