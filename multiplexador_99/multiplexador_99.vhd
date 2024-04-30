--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:    21:20:15 03/27/24
-- Design Name:    
-- Module Name:    multiplexador_99 - Behavioral
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

entity multiplexador_99 is
    Port ( clock : in std_logic;
           reset : in std_logic;
           segmentos : out std_logic_vector(7 downto 0);
           display : out std_logic_vector(3 downto 0));
end multiplexador_99;

architecture Behavioral of multiplexador_99 is

function decodifica (numero: integer) return std_logic_vector is
variable saida: std_logic_vector (7 downto 0);
begin					  
         if numero = 0 then
		   saida := "01000000";
		elsif numero = 1 then
		   saida := "11111001";
		elsif numero = 2 then
		   saida := "10100100";	 
		elsif numero = 3 then
		   saida := "10110000";	
		elsif numero = 4 then
		   saida := "10011001";
		elsif numero = 5 then
		   saida := "10010010";
		elsif numero = 6 then
		   saida := "10000010";	 
		elsif numero = 7 then
		   saida := "11111000";	
		elsif numero = 8 then
		   saida := "10000000";			
   	else
		   saida := "10010000";			
		end if;
	return(saida);
end decodifica;

signal count: integer range 500000 downto 0 := 0;
signal unidade: integer range 10 downto 0 :=0;
signal dezena: integer range 10 downto 0 :=0;
signal segment: std_logic_vector (7 downto 0):= "11111111";
signal transistor: std_logic_vector (3 downto 0) := "1111";
signal mux : integer range 10000 downto 0:= 0;
signal centena: integer range 10 downto 0:=0;
signal milhar: integer range 10 downto 0:=0;

begin
process (clock, reset) 
begin
   if reset = '1' then 
      count <= 0;
		segment <= "11111111";
		transistor <= "1100";
		--inicia ligando os displays de unidade e dezena
		unidade <= 0;
		dezena <= 0;
		centena <= 0;
		milhar <= 0;
   elsif clock ='1' and clock'event then            
		if count = 500000 then--passou um segundo
			count <= 0;
   		if milhar = 10 then
	   	    milhar <= 0;
		    	 mux <= 0;
			elsif centena = 10 then
				milhar <= milhar + 1;
				centena <=0;
			elsif dezena = 10 then
				centena <= centena + 1;
				dezena <= 0;
         elsif unidade = 10 then--9
	    		unidade <= 0;
		    	dezena <= dezena + 1;
         else
		       unidade <= unidade + 1;
		   end if;
      else--ainda não atingiu um segundo
		   count <= count + 1;
			mux <= mux + 1;
      end if;
   	if mux = 4000 then
		    segment <= decodifica(milhar);
			 transistor <= "1101";--liga apenas a dezena
			 mux <= 0;
      elsif mux = 3000 then
			 segment <= decodifica(centena);
			 transistor <= "1011";--liga apenas a unidade
		elsif mux = 2000 then
			 segment <= decodifica(dezena);
			 transistor <= "1101";--liga apenas a unidade
		elsif mux = 1000 then
			 segment <= decodifica(unidade);
			 transistor <= "1110";--liga apenas a unidade
      end if;
	end if;							  
end process;
segmentos <= segment;
display <= transistor;
end Behavioral;
