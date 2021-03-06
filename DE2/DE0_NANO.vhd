LIBRARY ieee;
   USE ieee.std_logic_1164.all;
	use work.values.all;

ENTITY DE0_NANO IS
   PORT (
 -- 			Clock Input	
			CLOCK_50    : IN STD_LOGIC;								-- On Board 50 MHz
-- 			Push Button		      
			KEY         : IN STD_LOGIC_VECTOR(2 DOWNTO 1);		-- Pushbutton[1:0]
-- 			DPDT Switch		      
			SW          : IN STD_LOGIC_VECTOR(3 DOWNTO 0);		-- Toggle Switch[3:0]

-- 			LED		      
			LEDG         : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);		-- LED [7:0]
			
			LEDR         : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) 
-- 			SDRAM Interface		      
--      	DRAM_DQ     : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);	-- SDRAM Data bus 16 Bits
--      	DRAM_ADDR   : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);		-- SDRAM Address bus 12 Bits
--      	DRAM_LDQM   : OUT STD_LOGIC;								-- SDRAM Low-byte Data Mask
--      	DRAM_UDQM   : OUT STD_LOGIC;								-- SDRAM High-byte Data Mask
--      	DRAM_WE_N   : OUT STD_LOGIC;								-- SDRAM Write Enable
--      	DRAM_CAS_N  : OUT STD_LOGIC;								-- SDRAM Column Address Strobe
--      	DRAM_RAS_N  : OUT STD_LOGIC;								-- SDRAM Row Address Strobe
--      	DRAM_CS_N   : OUT STD_LOGIC;								-- SDRAM Chip Select
--      	DRAM_BA     : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);		-- SDRAM Bank Address 
--      	DRAM_CLK    : OUT STD_LOGIC;								-- SDRAM Clock
--      	DRAM_CKE    : OUT STD_LOGIC;								-- SDRAM Clock Enable
      
--          ADC    
--     	ADC_CS_N     : OUT STD_LOGIC;                    	-- ADC Chip Select
--	  		ADC_SADDR    : OUT STD_LOGIC;                     	-- ADC Address
--     	ADC_SCLK     : OUT STD_LOGIC;                     	-- ADC System clock
--     	ADC_SDAT     : IN  STD_LOGIC;                     	-- Data output from the ADC
     
--         EPCS
--    	EPCS_ASDO     : OUT STD_LOGIC;
--    	EPCS_DATA0    : IN  STD_LOGIC;
--    	EPCS_DCLK     : OUT STD_LOGIC;
--    	EPCS_NCSO     : OUT STD_LOGIC;
     
-- 			SRAM Interface		      
--      	SRAM_DQ     : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);		-- SRAM Data bus 16 Bits
--      	SRAM_ADDR   : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);		-- SRAM Address bus 18 Bits
--      	SRAM_UB_N   : OUT STD_LOGIC;									-- SRAM High-byte Data Mask
--      	SRAM_LB_N   : OUT STD_LOGIC;									-- SRAM Low-byte Data Mask
--      	SRAM_WE_N   : OUT STD_LOGIC;									-- SRAM Write Enable
--      	SRAM_CE_N   : OUT STD_LOGIC;									-- SRAM Chip Enable
--      	SRAM_OE_N   : OUT STD_LOGIC;									-- SRAM Output Enable

-- 			GPIO	      
--      	GPIO_0       : INOUT STD_LOGIC_VECTOR(33 DOWNTO 0);	-- GPIO Connection 0
--	   	GPIO_0_IN    : IN    STD_LOGIC_VECTOR(1 DOWNTO 0);		-- GPIO_IN Connection 0
--      	GPIO_1       : INOUT STD_LOGIC_VECTOR(33 DOWNTO 0);	-- GPIO Connection 1   
--	   	GPIO_1_IN    : IN    STD_LOGIC_VECTOR(1 DOWNTO 0);		-- GPIO_IN Connection 1
--      	GPIO_2       : INOUT STD_LOGIC_VECTOR(9 DOWNTO 0);		-- GPIO Connection 1   
--	   	GPIO_2_IN    : IN    STD_LOGIC_VECTOR(2 DOWNTO 0)		-- GPIO_IN Connection 1 	   
	                                                                                                    
   );
END DE0_NANO;

ARCHITECTURE structural OF DE0_NANO IS

-- TOP LEVEL COMPONENT

component top_level is
		generic(N: integer := 8);
		port (
		iReset_n				: in std_logic; 
		iClk					: in std_logic; 
		iCnt_en 				: in std_logic;
		iLoad 				: in std_logic;
		iUp					: in std_logic;
		iData					: in std_logic_vector(N-1 downto 0);
		oMax					: out std_logic;	
		oMin					: out std_logic;
		oQ						: out std_logic_vector(N-1 downto 0)
		);
end component top_level;

BEGIN
   
-- INSTANTIATION OF THE TOP LEVEL COMPONENT

Inst_top_level: top_level 
		generic map(N => N)
      port map(
			iReset_n	=> SW(2), 
			iClk		=> CLOCK_50, 
			iCnt_en 	=> SW(0),
			iLoad 	=> SW(3),
			iUp 	   => SW(1),
			iData		=> (others => '1'), 	
			oMax		=> LEDR(1),	
			oMin		=> LEDR(0),
			oQ			=> LEDG(7 downto 8-N)
		);

		
END structural;



