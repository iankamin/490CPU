----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2018 11:48:02 AM
-- Design Name: 
-- Module Name: ALU - Behavioral
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
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( opcode : in STD_LOGIC_VECTOR (4 downto 0);
           clk : in STD_LOGIC;
           a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (31 downto 0);
           stage : in integer range 0 to 4;
           result : out STD_LOGIC_VECTOR (31 downto 0);
           enable_branch: out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
begin
	process(clk)
	begin
		if rising_edge(clk) then
			case opcode is
				when "00000" =>
					enable_branch <= '0';
				when "00001" =>
					result <= a and b;
					enable_branch <= '0';
				when "00010" =>
					result <= not a;
					enable_branch <= '0';
				when "00011" =>
					result <= a xor b;
					enable_branch <= '0';
				when "10100" =>
					result <= a or b;
					enable_branch <= '0';
				when "00101" =>
					result <= a + b;
					enable_branch <= '0';
				when "00110" =>
					result <= a - b;
					enable_branch <= '0';
				when "00111" =>
					enable_branch <= '0';
					if (a < b) then
						result <= "00000000000000000000000000000001";
					else
						result <= "00000000000000000000000000000000";
					end if;
				when "01000" =>
					enable_branch <= '1'; -- UNCONDITIONAL BRANCH HERE
				when "01001" =>
					if (a = b) then
						enable_branch <= '1'; -- BRANCH ON EQUAL WILL GO HERE
					else
						enable_branch <= '0';
					end if;
				when "01010" =>
					if (a /= b) then
						enable_branch <= '1'; -- BRANCH NOT EQUAL WILL GO HERE
					else
						enable_branch <= '0';
					end if;
				when "01011" =>
					enable_branch <= '1'; -- BRANCH AND LINK WILL GO HERE
				when "01110" =>
					result <= b; -- MOVE WILL GO HERE
					enable_branch <= '0';
				when "01111" =>
					result <= std_logic_vector(shift_left(unsigned(a), to_integer(unsigned(b)))); --LSL -- FUCK THISS
					enable_branch <= '0';
				when "10000" =>
					result <= std_logic_vector(shift_right(unsigned(a), to_integer(unsigned(b))));   -- LSR
					enable_branch <= '0';
				when "10001" =>
					result <= std_logic_vector(rotate_right(unsigned(a), to_integer(unsigned(b))));   -- ROR
					enable_branch <= '0';
				when others =>
					enable_branch <= '0';
			end case;
		end if;
	end process;
end Behavioral;
