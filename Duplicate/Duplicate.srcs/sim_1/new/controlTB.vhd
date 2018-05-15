----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/15/2018 02:01:51 PM
-- Design Name: 
-- Module Name: controlTB - Behavioral
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

entity controlTB is
--  Port ( );
end controlTB;

architecture Behavioral of controlTB is
Component Control
	Port ( 
		I_clk : in STD_LOGIC
	);
end Component;
	
	signal clk : std_logic :='0';
	
begin
	UUT: Control port map ( I_clk => clk);

clock : process(clk)
begin
	clk <= not clk after 50 ns;
end process;

end Behavioral;
