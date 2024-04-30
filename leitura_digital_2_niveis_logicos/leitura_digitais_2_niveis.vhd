--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:    19:28:15 03/27/24
-- Design Name:    
-- Module Name:    leitura_digitais_2_niveis - Behavioral
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

entity leitura_digitais_2_niveis is
    Port (
        clock : in std_logic;
        reset : in std_logic;
        entrada: in std_logic;
		  sinalizador: out std_logic;
        saida : out std_logic_vector(3 downto 0)
    );
end leitura_digitais_2_niveis;

architecture Behavioral of leitura_digitais_2_niveis is
    signal count: std_logic_vector(3 downto 0) := "0000";
    signal estado: std_logic := '0';
    signal tempo: integer range 500000 downto 0 := 0;
begin
    process (clock, reset, entrada)
    begin
        if reset = '1' then
            count <= "0000";
            estado <= '0';
            tempo <= 0;
        elsif clock = '1' and clock'event then
            if entrada = '0' and estado = '0' then
                --estado de repouso
                tempo <= 0;
            elsif entrada = '1' and estado = '0' then
                if tempo = 500000 then
                    --passou um segundo de tempo após o acionamento
                    tempo <= 0;
                    estado <= '1';
                else
                    tempo <= tempo + 1;
                end if;
            end if;

            if entrada = '0' and estado = '0' then
                --estado de repouso
                tempo <= 0;
            elsif entrada = '1' and estado = '0' then
                if tempo = 500000 then
                    --passou um segundo de tempo após o acionamento
                    tempo <= 0;
                    estado <= '1';
                else
                    tempo <= tempo + 1;
                end if;
            end if;
                if entrada = '1' and estado = '1' then
                    tempo <= 0;
                elsif entrada = '0' and estado = '1' then
                    if tempo = 500000 then
                        tempo <= 0;
                        estado <= '0';
                        count <= count + 1;
                    else
                        tempo <= tempo + 1;
                    end if;
                end if;  
        end if;
    end process;
    saida <= count;
	 sinalizador <= estado;
end Behavioral;
