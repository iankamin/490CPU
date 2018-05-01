----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2018 01:58:34 PM
-- Design Name: 
-- Module Name: Control - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Control is
    Port ( I_clk : in STD_LOGIC);
end Control;

architecture Behavioral of Control is
Component registers
    port(
        I_clk         : in STD_LOGIC;
        I_RegRD_Sel   : in STD_LOGIC_VECTOR (3 downto 0); -- bits 26-23
        I_RegRS_Sel   : in STD_LOGIC_VECTOR (3 downto 0); -- bits 22-19
        I_RegRT_Sel   : in STD_LOGIC_VECTOR (3 downto 0); -- bits 18-15
        I_WriteEnable : in STD_LOGIC;
        I_WriteData   : in STD_LOGIC_VECTOR (31 downto 0);  -- new register value
        I_RegDst      : in STD_LOGIC;
        O_ReadDataA   : out STD_LOGIC_VECTOR (31 downto 0); --register value
        O_ReadDataB   : out STD_LOGIC_VECTOR (31 downto 0)  --register value 
    );
end component;

Component ALU
    port(
        opcode : in STD_LOGIC_VECTOR (4 downto 0);
        clk : in STD_LOGIC;
        a : in STD_LOGIC_VECTOR (31 downto 0);
        b : in STD_LOGIC_VECTOR (31 downto 0);
        result : out STD_LOGIC_VECTOR (31 downto 0);
        enable_branch: out STD_LOGIC
    );
end component;
 
    signal r_PC     : std_logic_vector (31 downto 0) := "0";
    signal r_nextPC : std_logic_vector (31 downto 0);
    signal r_branchPC : std_logic_vector (31 downto 0);
    
    --register sections
    signal r_opcode   : std_logic_vector (31 downto 26);
    signal r_RSaddr   : std_logic_vector (25 downto 21);
    signal r_RTaddr   : std_logic_vector (20 downto 16);
    signal r_RDaddr   : std_logic_vector (15 downto 11);
    signal r_imm      : std_logic_vector (15 downto 0);
    signal r_JumpAddr : std_logic_vector (27 downto 2);
    signal r_RSdata   : std_logic_vector (31 downto 0);
    signal r_RTdata   : std_logic_vector (31 downto 0);
    
    --contol bits
    signal RegDST       : STD_LOGIC;
    signal Branch       : STD_LOGIC;
    signal Jump         : STD_LOGIC;
    signal MemRead      : STD_LOGIC;
    signal MemtoReg     : STD_LOGIC;
    signal ALUcontrol   : STD_LOGIC_vector (4 downto 0);
    signal MemWrite     : STD_LOGIC;
    signal ALUsrc       : STD_LOGIC;
    signal RegWrite     : STD_LOGIC;
    
    --ALU bit
    signal a_branchTrue   : STD_LOGIC := '0' ;
    signal a_result       : std_logic_vector (31 downto 0);
  


    
begin
    regFile: registers port map(
        I_clk         => I_clk,      
        I_RegRD_Sel   => r_RDaddr, 
        I_RegRS_Sel   => r_RSaddr,
        I_RegRT_Sel   => r_RTaddr,
        I_WriteEnable => '0',
        I_WriteData   => "00000000000000000000000000000000",
        I_RegDst      => RegDst,
        O_ReadDataA   => r_RSdata,
        O_ReadDataB   => r_RTdata
    );
    
    execution: ALU port map(
        opcode  => ALUcontrol,
        clk     => I_clk,
        a       => r_RSdata,
        b       => r_RTdata,
        result  => a_result,
        enable_branch  => a_branchTrue
    );

    stages : process(I_clk)
    variable v_stages   : natural range 0 to 4 :=0;

    
    
    begin
        if rising_edge(I_clk) then
            if v_stages = 0 then    --INSTRUCTION FETCH
                --READ INSTRUCTION FROM MEMORY
                r_nextPC <= std_logic_vector(to_unsigned(to_integer(unsigned(r_PC)) + 4, 32));
                v_stages := 1;
               
            elsif v_stages = 1 then --DECODE
                case r_opcode is
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
                

                v_stages := 2;
            elsif v_stages = 2 then --EXECUTIOM
                
                
                v_stages := 3;
            elsif v_stages = 3 then --MEMORY
                
                
                v_stages := 4;
            elsif v_stages = 4 then --REGWRITE
        
        
                v_stages := 0;
            end if;
        end if;
    end process;

    

end Behavioral;
