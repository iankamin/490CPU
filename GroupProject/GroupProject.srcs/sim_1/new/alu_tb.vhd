----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2018 10:29:03 PM
-- Design Name: 
-- Module Name: alu_tb - Behavioral
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

entity alu_tb is

end alu_tb;

architecture Behavioral of alu_tb is

component ALU
    Port ( opcode : in STD_LOGIC_VECTOR (4 downto 0);
           clk : in STD_LOGIC;
           a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (31 downto 0);
           result : out STD_LOGIC_VECTOR (31 downto 0);
           enable_branch: out STD_LOGIC);
end component;

    signal opcode : STD_LOGIC_VECTOR (4 downto 0);
    signal clk : STD_LOGIC;
    signal a : STD_LOGIC_VECTOR (31 downto 0);
    signal b : STD_LOGIC_VECTOR (31 downto 0);
    signal result : STD_LOGIC_VECTOR (31 downto 0);
    signal enable_branch: STD_LOGIC;

begin
    UUT: ALU port map (opcode=>opcode, clk=>clk, a=>a, b=>b, result=>result, enable_branch=>enable_branch);
    stimulus: process
    begin
        wait for 10 ns;
        opcode <=  "00101";
        a <= "00000000000000000000000000000001";
        b <= "00000000000000000000000000000000";
    end process;

end Behavioral;
