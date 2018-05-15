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
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Control is
	Port ( 
		I_clk : in STD_LOGIC
--		I_opcode : in std_logic_vector (31 downto 27);
--		I_RSaddr : in std_logic_vector (26 downto 23);
--		I_RTaddr : in std_logic_vector (22 downto 19);
--		I_RDaddr : in std_logic_vector (18 downto 15);
--		I_imm    : in std_logic_vector (18 downto 0)
	);
end Control;

architecture Behavioral of Control is
Component registers
	port(
		I_clk			: in STD_LOGIC;
		I_stage			: in integer range 0 to 4;
		I_RegWrite_Sel	: in STD_LOGIC_VECTOR (3 downto 0); -- bits 26-23
		I_RegRS_Sel   	: in STD_LOGIC_VECTOR (3 downto 0); -- bits 22-19
		I_RegRT_Sel   	: in STD_LOGIC_VECTOR (3 downto 0); -- bits 18-15
		I_WriteEnable 	: in STD_LOGIC;
		I_WriteData   	: in STD_LOGIC_VECTOR (31 downto 0);  -- new register value
		O_ReadDataA   	: out STD_LOGIC_VECTOR (31 downto 0); --register value
		O_ReadDataB   	: out STD_LOGIC_VECTOR (31 downto 0)  --register value  
	);
end component;
Component ALU
	port(
		opcode : in STD_LOGIC_VECTOR (4 downto 0);
		clk : in STD_LOGIC;
		a : in STD_LOGIC_VECTOR (31 downto 0);
		b : in STD_LOGIC_VECTOR (31 downto 0);
		stage : in integer range 0 to 4;
		result : out STD_LOGIC_VECTOR (31 downto 0);
		enable_branch: out STD_LOGIC
	);
end component;
Component Opcode 
	Port (  
		I_stage 	: in integer range 0 to 4;
		I_opcode 	: in STD_LOGIC_VECTOR (4 downto 0);
		RegDST      : out STD_LOGIC;
		Branch      : out STD_LOGIC;
		Jump        : out STD_LOGIC;
		MemRead     : out STD_LOGIC;
		MemtoReg    : out STD_LOGIC;
		ALUcontrol  : out STD_LOGIC_VECTOR (4 downto 0); --NULL
		MemWrite    : out STD_LOGIC_VECTOR (3 downto 0);
		ALUsrc      : out STD_LOGIC;
		RegWrite    : out STD_LOGIC
	);
end Component;
Component mux_2to1 
Generic(
    width: INTEGER := 32
);
Port ( SEL : in STD_LOGIC;
       A   : in STD_LOGIC_VECTOR (width downto 0);
       B   : in STD_LOGIC_VECTOR (width downto 0);
       X   : out STD_LOGIC_VECTOR (width downto 0));
end component;

Component memory
	PORT (
		clka : IN STD_LOGIC;
		rsta : IN STD_LOGIC;
		ena : IN STD_LOGIC;
		wea : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		addra : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		rsta_busy : OUT STD_LOGIC
  );

end component;

	signal r_stages   	: integer range 0 to 4 :=0;
	
	signal r_PC			: std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
	signal r_nextPC 	: std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
	signal r_branchPC 	: std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
	signal r_immLSL		: std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
	signal r_finalPC	: std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
	signal m_inst		: std_logic_vector (31 downto 0) := "00000000000000000000000000000000"; 
	--register sections
	signal r_opcode   	: std_logic_vector (31 downto 27) := "00000";
	signal r_RSaddr   	: std_logic_vector (26 downto 23) := "0000";
	signal r_RTaddr   	: std_logic_vector (22 downto 19) := "0000";
	signal r_RDaddr   	: std_logic_vector (18 downto 15) := "0000";
	signal r_imm      	: std_logic_vector (18 downto 0)  := "0000000000000000000";
	signal r_immSE    	: std_logic_vector (31 downto 0);
	signal r_JumpAddr 	: std_logic_vector (27 downto 2);
	signal r_RSdata   	: std_logic_vector (31 downto 0);
	signal r_RTdata   	: std_logic_vector (31 downto 0);
	signal r_RTimm    	: std_logic_vector (31 downto 0);
	signal r_writeRegAddr : std_logic_vector (3 downto 0);

	signal r_regresult    : std_logic_vector (31 downto 0);	
	--contol bits
	signal RegDST       : STD_LOGIC;
	signal Branch       : STD_LOGIC;
	signal Jump         : STD_LOGIC;
	signal MemRead      : STD_LOGIC;
	signal MemtoReg     : STD_LOGIC;
	signal ALUcontrol   : STD_LOGIC_vector (4 downto 0);
	signal MemWrite     : STD_LOGIC_VECTOR (3 downto 0);
	signal ALUsrc       : STD_LOGIC;
	signal RegWrite     : STD_LOGIC;
	
	--ALU bit
	signal a_branchTrue   : STD_LOGIC := '0' ;
	
	signal a_result       : std_logic_vector (31 downto 0);
	
	--memory 
	signal m_result		: std_logic_vector (31 downto 0);
	signal r_MEMRWena 	: STD_LOGIC := '0';
	signal r_MEMPCena 	: STD_LOGIC := '0';
	
	--mux Results
	signal reset : STD_LOGIC := '0';

    
begin
	regRW: registers port map( I_clk=> I_clk,   I_stage => r_stages,   I_RegWrite_Sel => r_writeRegAddr,   I_RegRS_Sel => r_RSaddr,   I_RegRT_Sel => r_RTaddr, I_WriteEnable => RegWrite,  I_WriteData => r_regresult, O_ReadDataA => r_RSdata,   O_ReadDataB => r_RTdata);
	
	execution: ALU port map(opcode => ALUcontrol,  clk => I_clk,  a => r_RSdata,  b => r_RTimm,	stage => r_stages,	result => a_result,  enable_branch  => a_branchTrue );
	
	control : Opcode port map(I_stage => r_stages,	I_opcode => r_opcode,	RegDST => RegDST,	Branch => Branch,	Jump => Jump,	MemRead => MemRead, 	MemtoReg => MemtoReg,	ALUcontrol => ALUcontrol,	MemWrite => MemWrite,	ALUsrc => ALUsrc,	RegWrite => RegWrite );
	
	memRW : memory port map(clka => I_clk,	rsta => reset,	ena  => r_MEMRWena,	wea  => MemWrite,	addra => a_result,	dina  => r_RSdata							, douta => m_result,	rsta_busy => open);
	memPC : memory port map(clka => I_clk,	rsta => reset,	ena  => r_MEMPCena,	wea  => "0000", 	addra => r_PC,		dina  => "00000000000000000000000000000000" , douta => m_inst,	rsta_busy => open);
	
	mux_regdst : mux_2to1 
		generic map (width => 3)
		port map(SEL => RegDST, 	A=>r_RTaddr,	B=>r_RDaddr,	X=>r_writeRegAddr);
	mux_alusrc : mux_2to1 
		generic map (width => 31)
		port map(SEL => ALUsrc, 	A=>r_RTdata,	B=>r_immSE, 	X=>r_RTimm);
	mux_memtoreg : mux_2to1 
		generic map (width => 31)
		port map(SEL => MemToReg, 	A=>a_result,	B=>m_result, 	X=>r_regresult);
	mux_branch : mux_2to1 
		generic map (width => 31)
		port map(SEL => a_branchTrue, 	A=>r_nextPC,	B=>r_branchPC, 	X=>r_finalPC);

	r_MEMRWena <= '1' when (r_stages = 3) else '0';
	r_MEMPCena <= '1' when (r_stages = 4) else '0';
				
	clock: process(I_clk)
	begin
		r_immSE <= std_logic_vector(resize(signed(r_imm), 32));
		r_immLSL(31 downto 2) <= r_immSE(29 downto 0);
		r_nextPC <= r_PC + "100"; 
		r_branchPC <= r_nextPC + r_immLSL;
		

		
		if rising_edge(I_clk)then
			if r_stages < 4 then
				r_stages <= r_stages + 1;
			else
				r_stages <= 0;
				r_PC <= r_finalPC; 
			end if;
			
--			if  r_stages = 0 then			
--				use to test without MEM 
--				r_opcode <= I_opcode;
--				r_RSaddr <= I_RSaddr;
--				r_RTaddr <= I_RTaddr;
--				r_RDaddr <= I_RDaddr;
--				r_imm    <= I_imm;
--			end if;			
		end if;      
	end process;
    
    insLatch : process (m_inst)
    begin
    	r_opcode <= m_inst(31 downto 27);
    	r_RSaddr <= m_inst(26 downto 23);
    	r_RTaddr <= m_inst(22 downto 19);
    	r_RDaddr <= m_inst(18 downto 15);
    	r_imm    <= m_inst(18 downto 0);
    end process;
    
    
    
    
--    stages : process(I_clk)
--    begin
--        if rising_edge(I_clk) then
--            if r_stages = 0 then    --INSTRUCTION FETCH
--                --READ INSTRUCTION FROM MEMORY
                
--                --r_nextPC <= std_logic_vector(to_unsigned(to_integer(unsigned(r_PC)) + 4, 32));
--            end if;
--            if 
--        end if;
--    end process;

    

end Behavioral;
