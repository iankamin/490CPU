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
           pc : in STD_LOGIC_VECTOR (31 downto 0);
           result : out STD_LOGIC_VECTOR (31 downto 0));
end ALU;

architecture Behavioral of ALU is

    signal reg1 : STD_LOGIC_VECTOR (31 downto 0) := "0";
    signal reg2 : STD_LOGIC_VECTOR (31 downto 0) := "0";
    signal reg_result : STD_LOGIC_VECTOR (31 downto 0) := "0";
    
    signal temp1 : STD_LOGIC_VECTOR (31 downto 0) := "0";
begin

    reg1 <= a;
    reg2 <= b;
    result <= reg_result;

    process(clk)
    begin
        if (rising_edge(clk)) then
            case opcode is
                when "00000" =>
                    null;
                when "00001" =>
                    reg_result <= reg1 and reg2;
                when "00010" =>
                    reg_result <= not reg1;
                when "00011" =>
                    reg_result <= reg1 xor reg2;
                when "00100" =>
                    reg_result <= reg1 or reg2;
                when "00101" =>
                    reg_result <= reg1 + reg2;
                when "00110" =>
                    reg_result <= reg1 - reg2;
                when "00111" =>
                    if (reg1 < reg2) then
                        reg_result <= "1";
                    else
                        reg_result <= "0";
                    end if;
                when "01000" =>
                        null; -- UNCONDITIONAL BRANCH HERE
                when "01001" =>
                    if (reg1 = reg2) then
                        null; -- BRANCH ON EQUAL WILL GO HERE
                    end if;
                when "01010" =>
                    if (reg1 /= reg2) then
                        null; -- BRANCH NOT EQUAL WILL GO HERE
                    end if;
                when "01011" =>
                    null; -- BRANCH AND LINK WILL GO HERE
                when "01100" =>
                    null; -- LOAD WORD WILL GO HERE
                when "01101" =>
                    null; -- STORE WORD WILL GO HERE
                when "01110" =>
                    null; -- MOVE WILL GO HERE
            end case;
        end if;
    end process;
end Behavioral;
