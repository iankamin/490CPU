----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2018 07:11:16 PM
-- Design Name: 
-- Module Name: Opcode - Behavioral
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

entity Opcode is
    Port (  I_stage  : in integer range 0 to 4 :=0;
            I_opcode : in STD_LOGIC_VECTOR (4 downto 0);
            RegDST      : out STD_LOGIC;
            Branch      : out STD_LOGIC;
            Jump        : out STD_LOGIC;
            MemRead     : out STD_LOGIC;
            MemtoReg    : out STD_LOGIC;
            ALUcontrol  : out STD_LOGIC_VECTOR (4 downto 0); --NULL
            MemWrite    : out STD_LOGIC;
            ALUsrc      : out STD_LOGIC;
            RegWrite    : out STD_LOGIC
    );
end Opcode;

architecture Behavioral of Opcode is

begin
    opcode : process(I_stage)
        begin
        	if I_stage = 0 then
        		MemWrite  <= '0';
        		RegWrite  <= '0';
        	end if;
        	
            if I_stage = 1 then
                case I_opcode is
                    when "00000" => --NOP  
                        RegDST    <= '0';
                        Branch    <= '0';
                        Jump      <= '0';
                        MemRead   <= '0';
                        MemtoReg  <= '0';
                        ALUcontrol<= "00000"; --NULL
                        MemWrite  <= '0';
                        ALUsrc    <= '0';
                        RegWrite  <= '0';
                    when "00001" => --AND  
                        RegDST    <= '1';
                        Branch    <= '0';
                        Jump      <= '0';
                        MemRead   <= '0';
                        MemtoReg  <= '0';
                        ALUcontrol<= "00001"; --AND
                        MemWrite  <= '0';
                        ALUsrc    <= '0';
                        RegWrite  <= '1';
                    when "00010" => --NOT  
                        RegDST    <= '1';
                        Branch    <= '0';
                        Jump      <= '0';
                        MemRead   <= '0';
                        MemtoReg  <= '0';
                        ALUcontrol<= "00010"; --NOT
                        MemWrite  <= '0';
                        ALUsrc    <= '0';
                        RegWrite  <= '1';
                    when "00011" => --XOR  
                        RegDST    <= '1';
                        Branch    <= '0';
                        Jump      <= '0';
                        MemRead   <= '0';
                        MemtoReg  <= '0';
                        ALUcontrol<= "00011"; --XOR
                        MemWrite  <= '0';
                        ALUsrc    <= '0';
                        RegWrite  <= '1';
                    when "00100" => --OR   
                        RegDST    <= '1';   
                        Branch    <= '0';
                        Jump      <= '0';
                        MemRead   <= '0';
                        MemtoReg  <= '0';
                        ALUcontrol<= "00100"; --OR
                        MemWrite  <= '0';
                        ALUsrc    <= '0';
                        RegWrite  <= '1';
                    when "00101" => --ADD  
                        RegDST    <= '1';   
                        Branch    <= '0';
                        Jump      <= '0';
                        MemRead   <= '0';
                        MemtoReg  <= '0';
                        ALUcontrol<= "00101"; --ADD
                        MemWrite  <= '0';
                        ALUsrc    <= '0';
                        RegWrite  <= '1';
                    when "00110" => --SUB  
                        RegDST    <= '1';   
                        Branch    <= '0';
                        Jump      <= '0';
                        MemRead   <= '0';
                        MemtoReg  <= '0';
                        ALUcontrol<= "00100"; --SUB
                        MemWrite  <= '0';
                        ALUsrc    <= '0';
                        RegWrite  <= '1';
                    when "00111" => --SLT  
                        RegDST    <= '1';   
                        Branch    <= '0';
                        Jump      <= '0';
                        MemRead   <= '0';
                        MemtoReg  <= '0';
                        ALUcontrol<= "00111"; --SLT
                        MemWrite  <= '0';
                        ALUsrc    <= '0';
                        RegWrite  <= '1';
                    when "01000" => --JUMP 
                        RegDST    <= '1';   
                        Branch    <= '0';
                        Jump      <= '1';
                        MemRead   <= '0';
                        MemtoReg  <= '0';
                        ALUcontrol<= "01000"; --JUMP
                        MemWrite  <= '0';
                        ALUsrc    <= '0';
                        RegWrite  <= '0';
                    when "01001" => --BEQ  
                        RegDST    <= '1';   
                        Branch    <= '1';
                        Jump      <= '0';
                        MemRead   <= '0';
                        MemtoReg  <= '0';
                        ALUcontrol<= "01001"; --BEQ
                        MemWrite  <= '0';
                        ALUsrc    <= '0';
                        RegWrite  <= '0';
                    when "01010" => --BNE  
                        RegDST    <= '1';   
                        Branch    <= '1';
                        Jump      <= '0';
                        MemRead   <= '0';
                        MemtoReg  <= '0';
                        ALUcontrol<= "01010"; --BNE
                        MemWrite  <= '0';
                        ALUsrc    <= '0';
                        RegWrite  <= '0';
                    when "01011" => --LW   
                        RegDST    <= '0'; --RT
                        Branch    <= '0';
                        Jump      <= '0';
                        MemRead   <= '1';
                        MemtoReg  <= '1';
                        ALUcontrol<= "00101"; --ADD
                        MemWrite  <= '0'; 
                        ALUsrc    <= '1'; --offset is an immediate
                        RegWrite  <= '1'; 
                    when "01100" => --SW   
                        RegDST    <= '0'; --RT    
                        Branch    <= '0';
                        Jump      <= '0';
                        MemRead   <= '0';
                        MemtoReg  <= '0';
                        ALUcontrol<= "00101"; --ADD
                        MemWrite  <= '1';
                        ALUsrc    <= '1';
                        RegWrite  <= '0';
                    when "01101" => --MOV  
                        RegDST    <= '0'; --RT    
                        Branch    <= '0';
                        Jump      <= '0';
                        MemRead   <= '0';
                        MemtoReg  <= '0';
                        ALUcontrol<= "01110"; --MOV
                        MemWrite  <= '0'; 
                        ALUsrc    <= '0';
                        RegWrite  <= '1';
                    when "01110" => --ANDI 
                        RegDST    <= '0'; --RT    
                        Branch    <= '0';
                        Jump      <= '0';
                        MemRead   <= '0';
                        MemtoReg  <= '0';
                        ALUcontrol<= "00001"; --AND
                        MemWrite  <= '0'; 
                        ALUsrc    <= '1';
                        RegWrite  <= '1';
                    when "01111" => --ORI  
                        RegDST    <= '0'; --RT    
                        Branch    <= '0';
                        Jump      <= '0';
                        MemRead   <= '0';
                        MemtoReg  <= '0';
                        ALUcontrol<= "00100"; --OR
                        MemWrite  <= '0'; 
                        ALUsrc    <= '1';
                        RegWrite  <= '1';
                    when "10000" => --ADDI 
                        RegDST    <= '0'; --RT    
                        Branch    <= '0';
                        Jump      <= '0';
                        MemRead   <= '0';
                        MemtoReg  <= '0';
                        ALUcontrol<= "00101"; --ADD
                        MemWrite  <= '0'; 
                        ALUsrc    <= '1';
                        RegWrite  <= '1';
                    when "10001" => --MOVI 
                        RegDST    <= '0'; --RT    
                        Branch    <= '0';
                        Jump      <= '0';
                        MemRead   <= '0';
                        MemtoReg  <= '0';
                        ALUcontrol<= "01110"; --MOV
                        MemWrite  <= '0'; 
                        ALUsrc    <= '1';
                        RegWrite  <= '1';
                    when "10010" => --LOGICAL SHIFT LEFT
                        RegDST    <= '0'; --RT    
                        Branch    <= '0';
                        Jump      <= '0';
                        MemRead   <= '0';
                        MemtoReg  <= '0';
                        ALUcontrol<= "01111"; --LSL
                        MemWrite  <= '0'; 
                        ALUsrc    <= '1';
                        RegWrite  <= '1';
                    when "10011" => --LOGICAL SHIFT RIGHT
                        RegDST    <= '0'; --RT    
                        Branch    <= '0';
                        Jump      <= '0';
                        MemRead   <= '0';
                        MemtoReg  <= '0';
                        ALUcontrol<= "10000"; --LSR
                        MemWrite  <= '0'; 
                        ALUsrc    <= '1';
                        RegWrite  <= '1';
                    when "10100" => --BARREL SHIFT RIGH
                        RegDST    <= '0'; --RT    
                        Branch    <= '0';
                        Jump      <= '0';
                        MemRead   <= '0';
                        MemtoReg  <= '0';
                        ALUcontrol<= "10001"; --ROR
                        MemWrite  <= '0'; 
                        ALUsrc    <= '1';
                        RegWrite  <= '1';
                    when others =>
                        RegDST    <= '0';
                        Branch    <= '0';
                        Jump      <= '0';
                        MemRead   <= '0';
                        MemtoReg  <= '0';
                        ALUcontrol<= "00000"; --NULL
                        MemWrite  <= '0';
                        ALUsrc    <= '0';
                        RegWrite  <= '0';
                end case;
            end if;
        end process;

end Behavioral;
