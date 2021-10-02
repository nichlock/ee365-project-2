library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity top_level is
		generic(N: integer := 4);
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
end top_level;

architecture Structural of top_level is

	component univ_bin_counter is
		generic(N: integer := 8);
		port(
			clk, reset				: in std_logic;
			syn_clr, load, en, up: in std_logic;
			clk_en 					: in std_logic := '1';			
			d							: in std_logic_vector(N-1 downto 0);
			max_tick, min_tick	: out std_logic;
			q							: out std_logic_vector(N-1 downto 0)
		);
	end component;

	component clk_enabler is
		 GENERIC (
			 CONSTANT cnt_max : integer := 49999999);      --  1.0 Hz 	
		 PORT(	
			clock						: in std_logic;	 
			clk_en					: out std_logic
		);
	end component;
	
	component sys_clk is	
		 GENERIC (
			  CONSTANT REF_CLK : integer := 50000000;  --  50.0 MHz   
			  CONSTANT OUT_CLK : integer := 10000000); --  10.0 MHz 
		 PORT (
			  SIGNAL oCLK 		: INOUT std_logic;	  
			  SIGNAL iCLK 		: IN std_logic;		  
			  SIGNAL iRST_N 	: IN std_logic);	
	end component;	

	component Reset_Delay IS	
		 PORT (
			  SIGNAL iCLK 		: IN std_logic;	
			  SIGNAL oRESET 	: OUT std_logic
				);	
	end component;	

	signal clk								: std_logic;
	signal clk_enable, Rst				: std_logic;
	signal reset, Counterreset			: std_logic;
   signal Counterreset_n        		: std_logic;	
	signal Qsignal							: std_logic_vector(7 downto 0);

	begin
	
   Rst 					<= not iReset_n;
	CounterReset 		<= reset or Rst;
	CounterReset_n  	<= not CounterReset;
	
	Inst_clk_Reset_Delay: Reset_Delay	
			port map(
			  iCLK 		=> iCLK,	
			  oRESET    => reset
				);			

	Inst_clk_enabler: clk_enabler
			generic map(
			cnt_max 		=> 9)
			port map( 
			clock 		=> clk, 			-- output from sys_clk
			clk_en 		=> clk_enable  -- enable every 10th sys_clk edge
			);
			
		
	Inst_univ_bin_counter: univ_bin_counter
		generic map(N => N)
		port map(
			clk 			=> clk,
			reset 		=> CounterReset,
			syn_clr		=> Rst, 
			load			=> iLoad, 
			en				=> iCnt_en, 
			up				=> iUP, 
			clk_en 		=> clk_enable,
			d				=> iData,
			max_tick		=> oMax, 
			min_tick 	=> oMin,
			q				=> oQ
		);

			
	Inst_sys_clk: sys_clk 
		  generic map (
		  REF_CLK   => 50000000, --  50.0 MHz   
		  OUT_CLK   => 5000000)  --   5.0 MHz 
		  port map (
		  oCLK 		=> clk,	  
		  iCLK 		=> iCLK,		  
		  iRST_N 	=> CounterReset_n
		  );	
	

end Structural;

