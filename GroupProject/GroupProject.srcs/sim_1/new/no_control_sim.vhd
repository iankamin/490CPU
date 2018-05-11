----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/10/2018 12:29:45 PM
-- Design Name: 
-- Module Name: no_control_sim - Behavioral
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

entity no_control_sim is
--  Port ( );
end no_control_sim;

architecture Behavioral of no_control_sim is
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
 
    signal r_stages   : integer range 0 to 4 :=0;
    --register sections
    signal r_opcode   : std_logic_vector (31 downto 27);
    signal r_RSaddr   : std_logic_vector (26 downto 23);
    signal r_RTaddr   : std_logic_vector (22 downto 19);
    signal r_RDaddr   : std_logic_vector (18 downto 15);
    signal r_imm      : std_logic_vector (18 downto 0);
    signal r_JumpAddr : std_logic_vector (26 downto 2);
    signal r_RSdata   : std_logic_vector (31 downto 0);
    signal r_RTdata   : std_logic_vector (31 downto 0);
    signal r_immSE    : std_logic_vector (31 downto 0);
    signal r_RTimm    : std_logic_vector (31 downto 0);
    
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
  
    signal clk            : std_logic :='0';
    
begin
    UUTreg: registers port map(
        I_clk         => clk,
        I_stage       => r_stages,      
        I_RegRD_Sel   => r_RDaddr, 
        I_RegRS_Sel   => r_RSaddr,
        I_RegRT_Sel   => r_RTaddr,
        I_WriteEnable => RegWrite,
        I_WriteData   => a_result,
        I_RegDst      => RegDst,
        O_ReadDataA   => r_RSdata,
        O_ReadDataB   => r_RTdata
    );
    
    UUTalu: ALU port map(
        opcode  => ALUcontrol,
        clk     => clk,
        a       => r_RSdata,
        b       => r_RTimm,
        result  => a_result,
        enable_branch  => a_branchTrue
    );
    
    UUTop : Opcode port map(
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





    clock: process(clk)
    begin
        clk <= not clk after 20 ns;
        if rising_edge(clk)then
            if r_stages < 4 then
                r_stages <= r_stages + 1;
            else
                r_stages <= 0;
                r_opcode <= "00000";
            end if;
        end if;
        if ALUsrc = '0' then
            r_RTimm <= r_RTdata;
        else 
            r_RTimm <= r_immSE;  
        end if;       
    end process;
    
    stimulus:process
    begin    
    --MOV r4, 178    
    --wait for 1000 ns;
    r_opcode <= "10001";
    r_RSaddr <= std_logic_vector(to_unsigned(3,4));
    r_RTaddr <= std_logic_vector(to_unsigned(4,4));
    --r_RTaddr <= std_logic_vector(to_unsigned(4,4));
    r_immSE    <= std_logic_vector(to_signed(178,32));        
    
--    wait for 1001 ns;
--    --MOV r2, 23
--    r_opcode <= "10001";
--    r_RTaddr <= std_logic_vector(to_unsigned(3,4));
--    r_immSE  <= std_logic_vector(to_signed(23,32));        
    
--    wait for 1001 ns;
--    --MOV r2, 23
--    r_opcode <= "10001";
--    r_RTaddr <= std_logic_vector(to_unsigned(2,4));
--    r_immSE  <= std_logic_vector(to_signed(22,32)); 
    
    
    
    end process;
    


end Behavioral;
