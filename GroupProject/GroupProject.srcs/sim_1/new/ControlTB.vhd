----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/11/2018 01:38:56 PM
-- Design Name: 
-- Module Name: ControlTB - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ControlTB is
--  Port ( );
end ControlTB;

architecture Behavioral of ControlTB is
Component Control
	Port ( 
		   I_clk : in STD_LOGIC;
		   I_opcode : in std_logic_vector (31 downto 27);
		   I_RSaddr : in std_logic_vector (26 downto 23);
		   I_RTaddr : in std_logic_vector (22 downto 19);
		   I_RDaddr : in std_logic_vector (18 downto 15);
		   I_imm    : in std_logic_vector (18 downto 0)
	);
end Component;
	signal clk : std_logic :='0';
	
	signal I_opcode : std_logic_vector (31 downto 27);
	signal I_RSaddr : std_logic_vector (26 downto 23);
	signal I_RTaddr : std_logic_vector (22 downto 19);
	signal I_RDaddr : std_logic_vector (18 downto 15);
	signal I_imm    : std_logic_vector (18 downto 0);
	
begin
	UUT: Control port map ( I_clk => clk,	I_opcode => I_opcode,	I_RSaddr => I_RSaddr,	I_RTaddr => I_RTaddr,	I_RDaddr => I_RDaddr,	I_imm => I_imm	);
	 
	clock : process(clk)
	begin
		clk <= not clk after 10 ns;
	end process;
	
	stimulus : process
	begin
			--MOVI r4, 178    
	--wait for 500 ns;
	I_opcode <= "10001";
	I_RSaddr <= std_logic_vector(to_unsigned(3,4));
	I_RTaddr <= std_logic_vector(to_unsigned(4,4));
	--r_RDaddr <= std_logic_vector(to_unsigned(4,4));
	I_imm    <= std_logic_vector(to_signed(178,19)); 
	wait for 90 ns;
	
	I_opcode <= "10001";
	I_RTaddr <= std_logic_vector(to_unsigned(5,4));
	--r_RTaddr <= std_logic_vector(to_unsigned(4,4));
	I_imm    <= std_logic_vector(to_signed(22,19));
	wait for 90 ns;

	I_opcode <= "00101"; --ADD
	I_RSaddr <= std_logic_vector(to_unsigned(4,4));
	I_RTaddr <= std_logic_vector(to_unsigned(5,4));
	I_RDaddr <= std_logic_vector(to_unsigned(6,4));
--	I_imm    <= std_logic_vector(to_signed(22,19));
	wait for 90 ns;

	I_opcode <= "00001";
	I_RSaddr <= std_logic_vector(to_unsigned(4,4));
	I_RTaddr <= std_logic_vector(to_unsigned(5,4));
	I_RDaddr <= std_logic_vector(to_unsigned(7,4));
--	I_imm    <= std_logic_vector(to_signed(22,19));
	wait for 90 ns;

--	I_opcode <= "10001";
--	I_RSaddr <= std_logic_vector(to_unsigned(3,4));
--	I_RTaddr <= std_logic_vector(to_unsigned(5,4));
--	I_RDaddr <= std_logic_vector(to_unsigned(4,4));
--	I_imm    <= std_logic_vector(to_signed(22,19));
--	wait for 90 ns;

--	I_opcode <= "10001";
--	I_RSaddr <= std_logic_vector(to_unsigned(3,4));
--	I_RTaddr <= std_logic_vector(to_unsigned(5,4));
--	I_RDaddr <= std_logic_vector(to_unsigned(4,4));
--	I_imm    <= std_logic_vector(to_signed(22,19));
--	wait for 90 ns;

--	I_opcode <= "10001";
--	I_RSaddr <= std_logic_vector(to_unsigned(3,4));
--	I_RTaddr <= std_logic_vector(to_unsigned(5,4));
--	I_RDaddr <= std_logic_vector(to_unsigned(4,4));
--	I_imm    <= std_logic_vector(to_signed(22,19));
--	wait for 90 ns;

	

	wait for 10000 ns;
	
	end process;
	

end Behavioral;
