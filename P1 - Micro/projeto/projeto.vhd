--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:    19:38:36 04/17/24
-- Design Name:    
-- Module Name:    projeto - Behavioral
-- Project Name:   
-- Target Device:  
-- Tool versions:  
-- Description:
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity projeto is
    Port ( clock : in std_logic;
           reset : in std_logic;
           porta : out std_logic_vector(7 downto 0));
end projeto;

architecture Behavioral of projeto is

-- registradores do microcontrolador
type registro is array (255 downto 0) of std_logic_vector (7 downto 0);
-- memorida do program 2 bits para opcode e 8 bits para dados
type memoria is array (255 downto 0) of std_logic_vector (9 downto 0);

--signal pc: integer range 255 downto 0 := 0;
signal registradores: registro;
signal flash: memoria;
signal operacao: integer range 3 downto 0 := 0;
signal opcode: std_logic_vector (1 downto 0) := "00";
signal dado: std_logic_vector (7 downto 0) := "00000000";
signal acumulador: std_logic_vector (7 downto 0) := "00000000"; 

begin

process (clock, reset) 
begin
	if reset = '1' then
		--pc <= 0;
		registradores (1) <= "00000000";
		-- opcode = 00 acumulador <= 0
		-- opcode = 01 acumulador <= conteudo (registrador)
		-- opcode = 10 conteudo (registrador) <= acumulador
		-- opcode = 11 acumulador <= acumulador + conteudo (registrador)
		-- acumulador <= 0

		operacao <= 0;
		opcode <= "00";
		dado <= "00000000";
		acumulador <= "00000000";

		flash (0) <= "0000000000"; -- acumulador <= 0
		flash (1) <= "1000000000"; -- registrador(0) <= acumulador
		flash (2) <= "0000000001"; -- acumulador <= 1
		flash (3) <= "1000000000"; -- registrador(0) <= acumulador
		flash (4) <= "0000000010"; -- acumulador <= 2
		flash (5) <= "1000000000"; -- registrador(0) <= acumulador
		flash (6) <= "0000000100"; -- acumulador <= 4
		flash (7) <= "1000000000"; -- registrador(0) <= acumulador
		flash (8) <= "0000001000"; -- acumulador <= 8
		flash (9) <= "1000000000"; -- registrador(0) <= acumulador
		flash (10) <= "0000010000"; -- acumulador <= 16
		flash (11) <= "1000000000"; -- registrador(0) <= acumulador
		flash (12) <= "0000100000"; -- acumulador <= 32
		flash (13) <= "1000000000"; -- registrador(0) <= acumulador
		flash (14) <= "0001000000"; -- acumulador <= 64
		flash (15) <= "1000000000"; -- registrador(0) <= acumulador
		flash (16) <= "0010000000"; -- acumulador <= 128
		flash (17) <= "1000000000"; -- registrador(0) <= acumulador
		flash (18) <= "0000000000"; -- acumulador <= 0
		flash (19) <= "1000000001"; -- registrador(1) <= acumulador (PC) = 0
		
	elsif clock = '1' and clock'event then
		if operacao = 2 then
			operacao <= 0;
			-- pc <= pc + 1; -- incrementa contador do programa
			registradores (1) <= registradores (1) + "00000001";
		else
			-- decodificador de instruções, leitura e decodificaçao
			if operacao = 0 then
				opcode (1) <= flash(CONV_INTEGER(registradores (1))) (9);
				opcode (0) <= flash(CONV_INTEGER(registradores (1))) (8);
				
				dado (7) <= flash(CONV_INTEGER(registradores(1))) (7);
				dado (6) <= flash(CONV_INTEGER(registradores(1))) (6);
				dado (5) <= flash(CONV_INTEGER(registradores(1))) (5);
				dado (4) <= flash(CONV_INTEGER(registradores(1))) (4);
				dado (3) <= flash(CONV_INTEGER(registradores(1))) (3);
				dado (2) <= flash(CONV_INTEGER(registradores(1))) (2);
				dado (1) <= flash(CONV_INTEGER(registradores(1))) (1);
				dado (0) <= flash(CONV_INTEGER(registradores(1))) (0);
			else -- operacao = 1
				if opcode = "00" then
					acumulador <= dado;
				elsif opcode = "01" then
					acumulador <= registradores (CONV_INTEGER(dado));
				elsif	opcode = "10" then
					registradores (CONV_INTEGER(dado)) <= acumulador;
				else -- acumulador = "11"
					acumulador <= acumulador + registradores (CONV_INTEGER(dado));
				end if;
			end if;
				operacao <= operacao + 1;
		end if;
	end if;
end process;

porta <= registradores (0);

end Behavioral;
