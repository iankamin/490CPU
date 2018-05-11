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
        I_stage       : in integer range 0 to 4;
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

Component Opcode is
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
end Component;
 
    signal r_PC     : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
    signal r_nextPC : std_logic_vector (31 downto 0);
    signal r_branchPC : std_logic_vector (31 downto 0);
    signal r_stages   : integer range 0 to 4 :=0;
    --register sections
    signal r_opcode   : std_logic_vector (31 downto 27);
    signal r_RSaddr   : std_logic_vector (26 downto 23);
    signal r_RTaddr   : std_logic_vector (22 downto 19);
    signal r_RDaddr   : std_logic_vector (18 downto 15);
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
        I_stage       => r_stages,      
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
        b       => r_RTimm,
        result  => a_result,
        enable_branch  => a_branchTrue
    );
    
    opcodeFile : Opcode port map(
        I_stage     => r_stages,
        I_opcode    => r_opcode,
        RegDST      => RegDST,
        Branch      => Branch,
        Jump        => Jump,
        MemRead     => MemRead,
        MemtoReg    => MemtoReg, 
        ALUcontrol  => ALUcontrol,
        MemWrite    => MemWrite,
        ALUsrc      => ALUsrc,
        RegWrite    => RegWrite
    );
    multiplexors : process
    begin
        
    end process;
    
    
    stages : process(I_clk)
    begin
        if rising_edge(I_clk) then
            if r_stages = 0 then    --INSTRUCTION FETCH
                --READ INSTRUCTION FROM MEMORY
                r_nextPC <= std_logic_vector(to_unsigned(to_integer(unsigned(r_PC)) + 4, 32));
                r_stages <= 1;
                
            elsif r_stages = 1 then --DECODE
                r_stages <= 2;
            elsif r_stages = 2 then --EXECUTIOM
                
                
                r_stages <= 3;
            elsif r_stages = 3 then --MEMORY
                
                
                r_stages <= 4;
            elsif r_stages = 4 then --REGWRITE
                r_stages <= 0;
            end if;
        end if;
    end process;

    

end Behavioral;
