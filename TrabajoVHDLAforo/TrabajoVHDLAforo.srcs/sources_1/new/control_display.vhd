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
        CLK,RESET : in std_logic;
       CUENTA,C1,C2: in  std_logic_vector(WIDTH-1 downto 0);
       CUENTA2: in  std_logic_vector(WIDTH-1 downto 0);
       LED: in std_logic_vector(1 downto 0);
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

signal aux1,aux4: std_logic_vector(6 downto 0);
signal aux2,aux5: std_logic_vector(6 downto 0);
signal aux3,aux6: std_logic_vector(6 downto 0);

signal salida1,salida2,salida3: std_logic_vector(6 downto 0);
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
signal C1_i,C11: std_logic_vector(C1'range);
signal C2_i,C22: std_logic_vector(C2'range);
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

conversion_2vectores: process (CLK, C1)
begin
    if(rising_edge(CLK)) then
    if (C1="1010") then
        C11<="0001";
        C1_i<="0000";
    else
        C11<="0000";
        C1_i<=C1;
    end if;
    end if;
end process;
conversion_2vectores2: process (CLK, C2)
begin
    if(rising_edge(CLK)) then
    if (C2="1010") then
        C22<="0001";
        C2_i<="0000";
    else
        C22<="0000";
        C2_i<=C2;
    end if;
    end if;
end process;
 

 -- DECODERS CONTADOR 1
 dec1: decoder
 port map (code=>"0001",
 led=>aux1);
 decconta1: decoder
 port map (code=>C1_i,
 led=>aux2);
 decconta11: decoder
port map (code=>C11,
led=>aux3);
--DECODERS CONTADOR 2
dec2: decoder
 port map (code=>"0010",
 led=>aux4);
 decconta2: decoder
 port map (code=>C2_i,
 led=>aux5);
 decconta22: decoder
port map (code=>C22,
led=>aux6);

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
        libre2_e<=unsigned(CUENTA2);
    --RESTAMOS 9-CUENTA
        libre1_i<=9 -TO_INTEGER(libre1_e);
        libre2_i<=9 - TO_INTEGER(libre2_e);
    --VOLVEMOS A PASAR A UNSIGNED
        libre1_o<=to_unsigned(libre1_i,libre1_o'length);
        libre2_o<=to_unsigned(libre2_i,libre2_o'length);
    --VOLVEMOS A PASAR A VECTOR
        libre1<=std_logic_vector(libre1_o);
        libre2<=std_logic_vector(libre2_o);
        if rising_edge(CLK) then
            if (LED="00") then
                salida1<=disp5;
                salida2<=disp6;
                salida3<=disp8;
            elsif (LED="01") then
                salida1<=aux2;
                salida2<=aux3;
                salida3<=aux1;
            elsif (LED="10")then
                salida1<=aux5;
                salida2<=aux6;
                salida3<=aux4;
            end if;    
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
                salida_disp<=salida1;
                
                flag<=6;
            end if;
            if flag=6 then
                refrescar_anodo(5) <=  '0';
                refrescar_anodo(4 downto 0) <=  "11111";
                refrescar_anodo(7 downto 6) <=  "11";
                 salida_disp<=salida2;
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
               salida_disp<= salida3;
                flag<=1;
            end if;
        end if;

    end process;


end Behavioral;
