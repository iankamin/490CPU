----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
CORE_CONTAINER	-- Create Date: 04/12/2018 08:52:06 PM
-- Design Name: 
-- Module Name: registers - Behavioral
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
use IEEE.NUMERIC_STD.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity registers is
    Port (  
        I_clk         : in STD_LOGIC;
        I_RegWriteSel : in STD_LOGIC_VECTOR (3 downto 0); -- bits 26-23
        I_RegASel     : in STD_LOGIC_VECTOR (3 downto 0); -- bits 22-19
        I_RegBSel     : in STD_LOGIC_VECTOR (3 downto 0); -- bits 18-15
        I_WriteEnable : in STD_LOGIC;
        I_WriteData   : in STD_LOGIC_VECTOR (31 downto 0);  -- new register value
        O_ReadDataA   : out STD_LOGIC_VECTOR (31 downto 0); --register value
        O_ReadDataB   : out STD_LOGIC_VECTOR (31 downto 0)  --register value
        );   
end registers;

architecture Behavioral of registers is
type registerFile is array(0 to 15) of std_logic_vector(31 downto 0);
signal L_registers : registerFile;

begin
    reg : process(I_clk)
    begin
        if rising_edge(I_clk) then
            if(I_writeEnable = '1') then
                L_registers(to_integer(unsigned(I_RegWriteSel))) <= I_WriteData;
            else
                O_ReadDataA <= L_registers(to_integer(unsigned(I_regASel)));
                O_ReadDataB <= L_registers(to_integer(unsigned(I_regBSel)));
            end if;
        end if;       
    end process;
end Behavioral;
