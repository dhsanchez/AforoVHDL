----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.06.2022 19:30:58
-- Design Name: 
-- Module Name: controlaforo - Behavioral
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

entity controlaforo is
generic (
    WIDTH : positive := 4 -- aforo máximo del local 15 personas
);
  Port (S_ENTRADA: in std_logic; --sensor de entrada
        S_SALIDA: in std_logic; -- sensor a la salida del local
        S_BOTE1: in std_logic; -- sensor que detecta el bote vacío
        S_BOTE2: in std_logic; -- sensor que detecta el bote vacío
        A_BOTE1: in std_logic; -- sensor que detecta el uso del bote
        A_BOTE2: in std_logic; -- sensor que detecta el uso del bote        
        CLK: in std_logic; --Reloj 
        RESET: in std_logic;  -- entrada de reseteo
        C_IN: in std_logic_vector( WIDTH-1 downto 0); --Cuenta inicial
        C_EN: in std_logic; -- Valor de activacion de la cuenta inicial
        REARME1: in std_logic; --Boton que al presionar informamos del rearme del bote de gel 
        REARME2: in std_logic; --Boton que al presionar informamos del rearme del bote de gel
        refrescar_anodo : out std_logic_vector(7 downto 0); --vector que pone a 1 el ánodo correspondiente para actualizar
        salida_disp : out std_logic_vector(6 downto 0); --salida de los displays
        LED_GEL1: out std_logic; -- LED que avisa de que se ha terminado el gel
        LED_GEL2:out std_logic; -- LED que avisa de que se ha terminado el gel
        LED_ALARMA: out std_logic; -- LED avisando de que el local esta lleno    
        LED_ERROR: out std_logic;-- LED que avisa de que han intentado entrar mas gente de la que se puede
        LED_ERROR1: out std_logic; --error en el control bote de gel 1
        LED_ERROR2:out std_logic --error en el control bote de gel 2

   );
end controlaforo;

architecture Behavioral of controlaforo is

--declaración del sincronizador
component SYNCHRNZR
    port (
        CLK: in std_logic;
        ASYNC_IN : in  std_logic; 
        SYNC_OUT : out std_logic
        );
 end component;
--declaracion del detector de flancos
component EDGEDTCTR 
    port (
        CLK      : in  std_logic; 
        SYNC_IN  : in  std_logic; 
        EDGE     : out std_logic
    );
end component;
--declaracion del decoder
component decoder
    PORT ( 
        code : in integer := 0; 
        led  : OUT std_logic_vector(6 DOWNTO 0) 
    ); 
    end component;
 --declaracion del contador del aforo
    component contador_aforo
    PORT(
        S_ENTRADA : in std_logic;
        S_SALIDA : in std_logic;
        C_EN: in std_logic;
        C_IN: in std_logic_vector(WIDTH-1 downto 0);
        CLK    : in std_logic;
        RESET  : in std_logic;
        COUNT : out std_logic_vector(WIDTH-1 downto 0);
        COUNT2 : out std_logic_vector(WIDTH-1 downto 0);
        ERROR   : out std_logic;
        FULL   : out std_logic
);
end component;
-- declaracion del contador del bote
component contador_bote
    PORT(SENSOR: in std_logic;
          REARME: in std_logic;
          CLK: in std_logic; 
          RESET:in std_logic;
          SALIDA: out std_logic);
end component;
--declaracion de la maquina de estados de cada bote
component maquina_botes
    Port ( RESET: in std_logic;
           CLK: in std_logic;
           SENSOR: in std_logic;
           REARME: in std_logic;
           CONTADOR: in std_logic;
           ERROR: out std_logic;
           led_alarma: out std_logic);
end component;
--declaracion del prescale
component prescale
Port (
    CLK_IN : in  STD_LOGIC;
    RESET  : in  STD_LOGIC;
    CLK_OUT: out STD_LOGIC
);
end component;

--declaracion del control del display
component control_display 
    port(
        CLK : in std_logic;
       CUENTA: in  std_logic_vector(WIDTH-1 downto 0);
       CUENTA2: in  std_logic_vector(WIDTH-1 downto 0);
        refrescar_anodo : out std_logic_vector(7 downto 0); --vector que pone a 1 el ánodo correspondiente para actualizar
        salida_disp : out std_logic_vector(6 downto 0) --salida de los displays
        
        );
end component;

--SEÑALES INTERMEDIAS ENTRADAS
signal ENTRADA_SYNC : std_logic;
signal SALIDA_SYNC: std_logic;
signal SBOTE1_SYNC: std_logic;
signal SBOTE2_SYNC: std_logic;
signal ABOTE1_SYNC: std_logic;
signal ABOTE2_SYNC: std_logic;
signal REARME1_SYNC: std_logic;
signal REARME2_SYNC: std_logic;
signal C_EN_SYNC: std_logic;
signal ENTRADA_EDGE : std_logic;
signal SALIDA_EDGE: std_logic;
signal SBOTE1_EDGE: std_logic;
signal SBOTE2_EDGE: std_logic;
signal ABOTE1_EDGE: std_logic;
signal ABOTE2_EDGE: std_logic;
signal REARME1_EDGE: std_logic;
signal REARME2_EDGE: std_logic;
signal C_EN_EDGE: std_logic;
signal CLK_10kHz: std_logic;

--SEÑALES INTERMEDIAS PROGRAMA
signal CUENTA: std_logic_vector(WIDTH-1 downto 0);
signal CUENTA2: std_logic_vector(WIDTH-1 downto 0);
signal FULL: std_logic; 
signal ERROR: std_logic; 
signal CONTADOR1: std_logic; 
signal CONTADOR2: std_logic;
begin
--Instancias de los componentes

--GESTOR DE ENTRADAS
EntradaSync: SYNCHRNZR
    port map (
        CLK =>CLK,
        ASYNC_IN=>S_ENTRADA,
        SYNC_OUT=>ENTRADA_SYNC);
SalidaSync: SYNCHRNZR
    port map (
        CLK =>CLK,
        ASYNC_IN=>S_SALIDA,
        SYNC_OUT=>SALIDA_SYNC);
Botevacio1Sync: SYNCHRNZR
    port map (
        CLK =>CLK,
        ASYNC_IN=>S_BOTE1,
        SYNC_OUT=>SBOTE1_SYNC);
Botevacio2Sync: SYNCHRNZR
    port map (
        CLK =>CLK,
        ASYNC_IN=>S_BOTE2,
        SYNC_OUT=>SBOTE2_SYNC);
ABOTE1Sync: SYNCHRNZR
    port map (
        CLK =>CLK,
        ASYNC_IN=>A_BOTE1,
        SYNC_OUT=>ABOTE1_SYNC);
ABOTE2Sync: SYNCHRNZR
    port map (
        CLK =>CLK,
        ASYNC_IN=>A_BOTE2,
        SYNC_OUT=>ABOTE2_SYNC);
Rearme1Sync: SYNCHRNZR
    port map (
        CLK =>CLK,
        ASYNC_IN=>REARME1,
        SYNC_OUT=>REARME1_SYNC);
Rearme2Sync: SYNCHRNZR
    port map (
        CLK =>CLK,
        ASYNC_IN=>REARME2,
        SYNC_OUT=>REARME2_SYNC);
CENsync:  SYNCHRNZR
    port map (
        CLK =>CLK,
        ASYNC_IN=>C_EN,
        SYNC_OUT=>C_EN_SYNC);
EntradaEdge: EDGEDTCTR
    port map(CLK => CLK,
        SYNC_IN => ENTRADA_SYNC,
        EDGE => ENTRADA_EDGE
    );        
SalidaEdge: EDGEDTCTR
    port map(CLK => CLK,
        SYNC_IN => SALIDA_SYNC,
        EDGE => SALIDA_EDGE
    );
botevacio1Edge: EDGEDTCTR
    port map(CLK => CLK,
        SYNC_IN => SBOTE1_SYNC,
        EDGE => SBOTE1_EDGE
    );
botevacio2Edge: EDGEDTCTR
    port map(CLK => CLK,
        SYNC_IN => SBOTE2_SYNC,
        EDGE => SBOTE2_EDGE
    );
ABOTE1Edge: EDGEDTCTR
    port map(CLK => CLK,
        SYNC_IN => ABOTE1_SYNC,
        EDGE => ABOTE1_EDGE
    );
ABOTE2Edge: EDGEDTCTR
    port map(CLK => CLK,
        SYNC_IN => ABOTE2_SYNC,
        EDGE => ABOTE2_EDGE
    );
rearme1edge:EDGEDTCTR
    port map(CLK => CLK,
        SYNC_IN => REARME1_SYNC,
        EDGE => REARME1_EDGE
    ); 
rearme2edge:EDGEDTCTR
    port map(CLK => CLK,
        SYNC_IN => REARME2_SYNC,
        EDGE => REARME2_EDGE
    ); 
c_enedge:EDGEDTCTR
    port map(CLK => CLK,
        SYNC_IN => C_EN_SYNC,
        EDGE => C_EN_EDGE
);
preescaler_10khz : prescale
    port map(
        CLK_IN => CLK,
        RESET  => RESET,
        CLK_OUT => CLK_10kHz
    );
    
--INSTANCIAS DEL BLOQUE PROGRAMA
cuentaaforo: contador_aforo
    port map( S_ENTRADA => ENTRADA_EDGE,
           S_SALIDA=> SALIDA_EDGE,
           C_EN => C_EN_EDGE,
           C_IN => C_IN,
           CLK   => CLK_10kHz,
           RESET  => RESET,
           COUNT => CUENTA,
           COUNT2 => CUENTA2,
           ERROR =>LED_ERROR,
           FULL => FULL
           );
contadorbote1: contador_bote
port map(SENSOR =>ABOTE1_EDGE,
          REARME=> REARME1_EDGE,
          CLK=>CLK_10kHz,  
          RESET =>RESET,
          SALIDA=>CONTADOR1
          );
contadorbote2: contador_bote
port map(SENSOR =>ABOTE2_EDGE,
          REARME=> REARME2_EDGE,
          CLK=>CLK_10kHz,  
          RESET =>RESET,
          SALIDA=>CONTADOR2
          );     
maquinabote1: maquina_botes
port map (RESET=> RESET,
           CLK=> CLK_10kHz,
           SENSOR=> SBOTE1_EDGE,
           REARME=> REARME1_EDGE,
           CONTADOR => CONTADOR1,
           ERROR=> LED_ERROR1,
           led_alarma=> LED_GEL1
           );    
maquinabote2: maquina_botes
port map (RESET=> RESET,
           CLK=> CLK_10kHz,
           SENSOR=> SBOTE2_EDGE,
           REARME=> REARME2_EDGE,
           CONTADOR => CONTADOR2,
           ERROR=> LED_ERROR2,
           led_alarma=> LED_GEL2
           );
--INSTANCIAS DEL BLOQUE DE SALIDAS
display: control_display 
port map ( CLK =>CLK_10kHz,
       CUENTA=>CUENTA,
       CUENTA2=>CUENTA2,
       refrescar_anodo => refrescar_anodo,
        salida_disp =>salida_disp
        );
end Behavioral;

           