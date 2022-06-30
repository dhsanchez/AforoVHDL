----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.06.2022 02:29:02
-- Design Name: 
-- Module Name: control_display - Behavioral
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
USE ieee.numeric_std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control_display is
generic (
    WIDTH: positive:= 4
    );
    port(
        CLK : in std_logic;
       CUENTA: in  std_logic_vector(WIDTH-1 downto 0);
       CUENTA2: in  std_logic_vector(WIDTH-1 downto 0);
        refrescar_anodo : out std_logic_vector(7 downto 0); --vector que pone a 1 el �nodo correspondiente para actualizar
        salida_disp : out std_logic_vector(6 downto 0) --salida de los displays
        
        );
end control_display;

architecture Behavioral of control_display is

--Se�ales auxiliares de cada uno de los displays
signal disp1: std_logic_vector(6 downto 0);
signal disp2: std_logic_vector(6 downto 0);
signal disp3: std_logic_vector(6 downto 0);
signal disp4: std_logic_vector(6 downto 0);
signal disp5: std_logic_vector(6 downto 0);
signal disp6: std_logic_vector(6 downto 0);
signal disp7: std_logic_vector(6 downto 0);
signal disp8: std_logic_vector(6 downto 0);

signal flag : integer := 1;
--signal libre_1: std_logic_vector(WIDTH-1 downto 0) :=CUENTA;-- 9-TO_INTEGER(unsigned(CUENTA));
--signal libre_2: std_logic_vector(WIDTH-1 downto 0) :=CUENTA2; --9-TO_INTEGER(unsigned(CUENTA2));
--signal cuenta_1: integer:= TO_INTEGER(unsigned(CUENTA));
--signal cuenta_2: integer:= TO_INTEGER(unsigned(CUENTA2));
--Se�ales de plazas libres
    COMPONENT decoder
       PORT (
              code : in std_logic_vector(3 DOWNTO 0);
              led : OUT std_logic_vector(6 DOWNTO 0)
       );
   END COMPONENT;

begin
declibre: decoder 
port map (code =>"1010",
    led=>disp1
    );
decocupado: decoder 
port map (code =>"1011",
    led=>disp5
    );
decguion:decoder 
port map (code =>"1100",
    led=>disp2
    );
decguion2:decoder 
port map (code =>"1100",
    led=>disp6
    );
deccuenta1: decoder 
port map (code => CUENTA,
    led=>disp8); 
deccuenta2: decoder 
port map (code => CUENTA2,
    led=>disp7); 
libres1: decoder 
port map (
    code => CUENTA,
    led=>disp4);
libres2: decoder 
port map (code => CUENTA2,
    led=>disp3); 

    process (CLK)
    begin
        if rising_edge(CLK) then
            if flag=1 then
                refrescar_anodo(0) <=  '0';
                refrescar_anodo(7 downto 1) <=  "1111111";
                salida_disp <= disp1;
                flag<=2;
            end if;
            if flag=2 then
                refrescar_anodo(1) <=  '0';
                refrescar_anodo(0) <=  '1';
                refrescar_anodo(7 downto 2) <=  "111111";
                salida_disp <= disp2;
                flag<=3;
            end if;
            if flag=3 then
                refrescar_anodo(2) <=  '0';
                refrescar_anodo(1 downto 0) <=  "11";
                refrescar_anodo(7 downto 3) <=  "11111";
                salida_disp <= disp3;
                flag<=4;
            end if;
            if flag=4 then
                refrescar_anodo(3) <=  '0';
                refrescar_anodo(2 downto 0) <=  "111";
                refrescar_anodo(7 downto 4) <=  "1111";
                salida_disp <= disp4;
                flag<=5;
            end if;
            if flag=5 then
                refrescar_anodo(4) <=  '0';
                refrescar_anodo(3 downto 0) <=  "1111";
                refrescar_anodo(7 downto 5) <=  "111";
                salida_disp <= disp5;
                flag<=6;
            end if;
            if flag=6 then
                refrescar_anodo(5) <=  '0';
                refrescar_anodo(4 downto 0) <=  "11111";
                refrescar_anodo(7 downto 6) <=  "11";
                salida_disp <= disp6;
                flag<=7;
            end if;
            if flag=7 then
                refrescar_anodo(6) <=  '0';
                refrescar_anodo(5 downto 0) <=  "111111";
                refrescar_anodo(7) <=  '1';
                salida_disp <= disp7;
                flag<=8;
            end if;
            if flag=8 then
                refrescar_anodo(7) <=  '0';
                refrescar_anodo(6 downto 0) <=  "1111111";
                salida_disp <= disp8;
                flag<=1;
            end if;
        end if;

    end process;


end Behavioral;
