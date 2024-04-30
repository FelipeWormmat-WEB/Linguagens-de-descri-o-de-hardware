--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:    21:20:00 03/27/24
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
           segmento : out std_logic_vector(7 downto 0);
           display : out std_logic_vector(3 downto 0));
end projeto;

architecture Behavioral of projeto is

function decodificador (digito : integer) return std_logic_vector is  
variable saida: std_logic_vector (7 downto 0);
begin
    if    digito = 0 then saida := "11000000";
    elsif digito = 1 then saida := "11111001";
    elsif digito = 2 then saida := "10100100";
	 elsif digito = 3 then saida := "10110000";
	 elsif digito = 4 then saida := "10011001";
	 elsif digito = 5 then saida := "10010010";
	 elsif digito = 6 then saida := "10000011";
	 elsif digito = 7 then saida := "11111000";
	 elsif digito = 8 then saida := "10000000";
    else  saida := "00010000";
	 end if;
	 return (saida);
end decodificador;

signal contador: integer range 50000000 downto 0 := 0;
signal unidade, dezena: integer range 10 downto 0 := 0;
signal transistor: std_logic_vector(3 downto 0) := "1100";
signal segmentos: std_logic_vector(7 downto 0) := (others => '1');
signal mux: integer range 10000 downto 0 := 0;

begin

process (clock, reset) -- executa como uma interrupção

begin
   if reset='1' then 
      segmentos <= (others => '1'); -- zera o contador
		transistor <= "1100"; -- liga o transistor
		contador <= 0;
		unidade <= 0;
		dezena <= 0;
   elsif clock='1' and clock'event then
		if contador = 50000000 then--passou um segundo
		   if dezena = 9 then
				unidade <= 0;
				dezena <= 0;
		   elsif unidade = 9 then
				unidade <= 0;
				dezena <= dezena + 1;
			else
				unidade <= unidade + 1;
			end if;
					
			contador <= 0; 
		else
			contador <= contador + 1;
		end if;

		if mux = 10000 then
			segmentos <= decodificador(dezena);
			transistor <= "1101"; -- liga só a dezena
			mux <= 0;
		elsif mux = 5000 then
			segmentos <= decodificador(unidade);
			transistor <= "1110"; -- liga só a unidade
		end if;
		mux <= mux + 1;
   end if;
end process;

segmento <= segmentos;
display <= transistor;

end Behavioral;
