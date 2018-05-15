----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/11/2018 11:53:33 AM
-- Design Name: 
-- Module Name: mux_2to1 - Behavioral
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

entity mux_2to1 is
    generic(
        width: INTEGER := 31
    );
    Port ( SEL : in STD_LOGIC;
           A   : in STD_LOGIC_VECTOR (width downto 0);
           B   : in STD_LOGIC_VECTOR (width downto 0);
           X   : out STD_LOGIC_VECTOR (width downto 0));
end mux_2to1;

architecture Behavioral of mux_2to1 is
begin
   X <= B when (SEL = '1') else A;
end Behavioral;
