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
           result : out STD_LOGIC_VECTOR (31 downto 0);
           enable_branch: out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is

    signal reg1 : STD_LOGIC_VECTOR (31 downto 0);
    signal reg2 : STD_LOGIC_VECTOR (31 downto 0);
    --signal result : STD_LOGIC_VECTOR (31 downto 0);
    
    signal temp1 : STD_LOGIC_VECTOR (31 downto 0);
    signal eb : STD_LOGIC := '0';
begin

    reg1 <= a;
    reg2 <= b; 
    --result <= reg_result;
    enable_branch <= eb;
    
    process(clk)
    begin
        if (rising_edge(clk)) then
            case opcode is
                when "00000" =>
                    null;
                when "00001" =>
                    result <= reg1 and reg2;
                when "00010" =>
                    result <= not reg1;
                when "00011" =>
                    result <= reg1 xor reg2;
                when "10100" =>
                    result <= reg1 or reg2;
                when "00101" =>
                    result <= reg1 + reg2;
                when "00110" =>
                    result <= reg1 - reg2;
                when "00111" =>
                    if (reg1 < reg2) then
                        result <= "00000000000000000000000000000001";
                    else
                        result <= "00000000000000000000000000000000";
                    end if;
                when "01000" =>
                    eb <= '1'; -- UNCONDITIONAL BRANCH HERE
                when "01001" =>
                    if (reg1 = reg2) then
                        eb <= '1'; -- BRANCH ON EQUAL WILL GO HERE
                    end if;
                when "01010" =>
                    if (reg1 /= reg2) then
                        eb <= '1'; -- BRANCH NOT EQUAL WILL GO HERE
                    end if;
                when "01011" =>
                    eb <= '1'; -- BRANCH AND LINK WILL GO HERE
                when "01110" =>
                    result <= reg1; -- MOVE WILL GO HERE
                when "01111" =>
                    result <= std_logic_vector(shift_left(unsigned(reg1), to_integer(unsigned(reg2)))); --LSL -- FUCK THISS
                when "10000" =>
                    result <= std_logic_vector(shift_right(unsigned(reg1), to_integer(unsigned(reg2))));   -- LSR
                when "10001" =>
                    result <= std_logic_vector(rotate_right(unsigned(reg1), to_integer(unsigned(reg2))));   -- ROR
                when others =>
                    null;
            end case;
        end if;
    end process;
end Behavioral;
