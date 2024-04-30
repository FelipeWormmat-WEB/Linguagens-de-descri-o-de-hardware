--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:    21:20:25 03/27/24
-- Design Name:    
-- Module Name:    multiplicador_99 - Behavioral
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

entity multiplicador_99 is
    Port ( check : in std_logic;
           reset : in std_logic;
           segmentos : out std_logic_vector(7 downto 0);
           display : out std_logic_vector(3 downto 0));
end multiplicador_99;

architecture Behavioral of multiplicador_99 is

begin


end Behavioral;
