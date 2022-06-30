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
        refrescar_anodo : out std_logic_vector(7 downto 0); --vector que pone a 1 el ánodo correspondiente para actualizar
        salida_disp : out std_logic_vector(6 downto 0) --salida de los displays
        
        );
end control_display;

architecture Behavioral of control_display is

--Señales auxiliares de cada uno de los displays
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
signal libre1_i: integer;
signal libre2_i: integer;
signal libre1_e: unsigned(CUENTA'range);
signal libre2_e: unsigned(CUENTA2'range);
signal libre1_o: unsigned(CUENTA'range);
signal libre2_o: unsigned(CUENTA2'range);

signal libre1: std_logic_vector(WIDTH-1 downto 0);
signal libre2: std_logic_vector(WIDTH-1 downto 0);
--Señales de plazas libres
    COMPONENT decoder
       PORT (
              code : in std_logic_vector(3 DOWNTO 0);
              led : OUT std_logic_vector(6 DOWNTO 0)
       );
   END COMPONENT;

begin

declibre: decoder 
port map (code =>"1010",
    led=>disp8
    );
decocupado: decoder 
port map (code =>"1011",
    led=>disp4
    );
decguion:decoder 
port map (code =>"1100",
    led=>disp3
    );
decguion2:decoder 
port map (code =>"1100",
    led=>disp7
    );
deccuenta1: decoder 
port map (code => CUENTA,
    led=>disp1); 
deccuenta2: decoder 
port map (code => CUENTA2,
    led=>disp2); 
libres1: decoder 
port map (
    code =>libre1 ,
    led=>disp5);
libres2: decoder 
port map (code =>libre2 ,
    led=>disp6); 

    process (CLK)
    begin
    --PASAMOS DE VECTOR A UNSIGNED
        libre1_e<=unsigned(CUENTA);
        libre1_e<=unsigned(CUENTA2);
    --RESTAMOS 9-CUENTA
        libre1_i<=9 -TO_INTEGER(libre1_e);
        libre2_i<=9 - TO_INTEGER(libre2_e);
    --VOLVEMOS A PASAR A UNSIGNED
        libre1_o<=to_unsigned(libre1_i,libre1_o'length);
        libre2_o<=to_unsigned(libre2_i,libre2_o'length);
    --VOLVEMOS A PASAR A VECTOR
        libre1<=std_logic_vector(libre1_o);
        libre2<=std_logic_vector(libre1_o);
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
