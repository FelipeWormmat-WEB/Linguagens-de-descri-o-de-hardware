--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:    21:37:38 04/03/24
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

entity projeto is
    Port ( clock : in std_logic;
           reset : in std_logic;
           tx : out std_logic);
end projeto;

architecture Behavioral of projeto is

    function transmite_func(conta: integer; letra: std_logic_vector(7 downto 0)) return std_logic is
    begin
        case conta is
            when 0 => return '1';  -- idle
            when 1 => return '0';  -- start bit
            when 10 => return '0'; -- stop bit
            when 11 => return '1'; -- idle
            when others =>
                if conta > 1 and conta < 10 then 
                    return letra(conta - 2); -- dados
                else 
                    return '1'; -- idle
                end if;
        end case;
    end transmite_func;

    signal divisor : integer range 5200 downto 0 := 0;
    signal conta : integer range 255 downto 0 := 0;
    signal transmite : std_logic := '0';
    signal indice : integer range 7 downto 0 := 0;
    signal j : std_logic_vector (7 downto 0) := "01101010"; -- 'j' em ASCII
    signal u : std_logic_vector (7 downto 0) := "01110101"; -- 'u' em ASCII
    signal v : std_logic_vector (7 downto 0) := "01110110"; -- 'v' em ASCII
    signal e : std_logic_vector (7 downto 0) := "01100101"; -- 'e' em ASCII

begin

    process (clock, reset)
    begin
        if reset = '1' then 
            divisor <= 0;
            conta <= 0;
            transmite <= '0';
            indice <= 0;
        elsif rising_edge(clock) then
            if divisor = 5200 then -- atingiu tempo do bit
                divisor <= 0;
                conta <= conta + 1;
                if conta = 255 then
                    conta <= 0;
                    indice <= indice + 1;
                    if indice = 6 then indice <= 0;
                    end if;
                end if;
            else
                divisor <= divisor + 1;
                case indice is
                    when 0 =>
                        transmite <= transmite_func(conta, j);
                    when 1 =>
                        transmite <= transmite_func(conta, u);
                    when 2 =>
                        transmite <= transmite_func(conta, v);
                    when 3 =>
                        transmite <= transmite_func(conta, e);
                    when 4 =>
                        transmite <= transmite_func(conta, "00001010");
                    when 5 =>
                        transmite <= transmite_func(conta, "00001011");
                    when others =>
                        transmite <= '1'; -- idle
                end case;
            end if;
        end if;
    end process;

    tx <= transmite; 

end Behavioral;