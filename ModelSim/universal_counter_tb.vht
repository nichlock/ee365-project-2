library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity universal_counter_tb is
end universal_counter_tb ;

architecture tb of universal_counter_tb is
-- inputs for top_level
		signal rst				  : std_logic;
		signal sys_clk				: std_logic;
		signal cnt_en 				: std_logic;
		signal load 				: std_logic;
		signal up					: std_logic;
		signal data					: std_logic_vector(3 downto 0);
-- outputs for top_level
		signal max					: std_logic;	
		signal min					: std_logic;
		signal count_result		: std_logic_vector(3 downto 0);
begin
-- PORT MAP TO TOP_LEVEL ------------------------------------------------------
   DUT : entity work.top_level 
		generic map(
			N => 4,
			CLK_RATE => 10)
			port map (
			iReset_n => rst,
			iClk => sys_clk,
			iCnt_en => cnt_en,
			iLoad => load,
			iUp => up,
			iData => data,
			oMax => max,
			oMin => min,
			oQ => count_result
		);

clock_driver : process
begin -- Clock rising edge every 1 ns
	sys_clk <= '1';
	wait for 500ps;
	sys_clk <= '0';
	wait for 500ps;
end process;
	
tb1 : process
begin
	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
        -- BEGIN TEST CODE ---------------------------------------------------------
	rst <= '1';
	cnt_en <= '0';
	up <= '0';
	-- Wait for reset delay to run out and start the divided clock
	wait for 200ns;
	----------------------------------------------------------------------------
	-- TEST: Initial value
	assert (count_result = x"0") report "FAILED: Counter loaded non-zero initial value" severity error;
	----------------------------------------------------------------------------
	-- TEST: loading values
	cnt_en <= '0';
	load <= '0';
	data <= x"2";
	wait for 100ns;
	assert (count_result = x"0") report "FAILED: Counter loaded when load was disabled" severity error;
	load <= '1';
	wait for 100ns;
	load <= '0';
	wait for 100ns;
	assert (count_result = x"2") report "FAILED: Counter did not load when load was enabled" severity error;
	----------------------------------------------------------------------------
	-- TEST: counting without enabling
	data <= x"8"; -- midpoint chosen to ensure up/down counting won't be missed
	load <= '1';
	wait for 100ns;
	load <= '0';

	cnt_en <= '0';
	wait for 100ns;
	assert (count_result = x"8") report "FAILED: counter output did not remain when counter not enabled" severity error;
	cnt_en <= '0';
	wait for 100ns;
	assert (count_result = x"8") report "FAILED: counter output did not remain when counter not enabled" severity error;
	----------------------------------------------------------------------------
	-- TEST: counting up
	cnt_en <= '1';
	up <= '1';
	wait for 200ns;
	assert (count_result = x"A") report "FAILED: counter did not count up" severity error;
	----------------------------------------------------------------------------
	-- TEST: counting down
	up <= '0';
	wait for 300ns;
	assert (count_result = x"7") report "FAILED: counter did not count down" severity error;
	----------------------------------------------------------------------------
	-- TEST: counting stops
	cnt_en <= '0';
	wait for 200ns;
	assert (count_result = x"7") report "FAILED: counter did not stop counting after enabled" severity error;
	cnt_en <= '1';
	----------------------------------------------------------------------------
	-- TEST: counting resets to zero
	up <= '1';
	rst <= '0';
	wait for 200ns;
	assert (count_result = x"0") report "FAILED: counter output did not reset after running" severity error;
	rst <= '1';
	wait for 100ns;
	assert (count_result = x"1") report "FAILED: counter did not maintain zero after a reset" severity error;
	----------------------------------------------------------------------------
	-- TEST: max indicated and handled correctly
	cnt_en <= '0';
	up <= '1';
	load <= '1';
	data <= x"D";
	wait for 100ns;
	assert (max = '0') report "FAILED: Max triggered on load of non-maximal value" severity error;
	
	load <= '0';
	cnt_en <= '1';
	wait for 100ns;
	assert (max = '0') report "FAILED: Max triggered after counting to non-maximal value" severity error;
	wait for 100ns;
	assert (max = '1') report "FAILED: Max not triggered after counting to maximal value" severity error;
	wait for 100ns;
	assert (count_result = x"0") report "FAILED: Counter did not overflow after counting above maximal value" severity error;
	assert (max = '0') report "FAILED: Max remained set after overflowing above maximal value" severity error;
	assert (min = '1') report "FAILED: Min not triggered after overflowing above maximal value" severity error;

	up <= '0';
	load <= '1';
	data <= x"2";
	wait for 100ns;
	assert (min = '0') report "FAILED: Min triggered on load of non-minimal value" severity error;
	load <= '0';

	cnt_en <= '1';
	wait for 100ns;
	assert (min = '0') report "FAILED: Min triggered after counting to non-minimal value" severity error;
	wait for 100ns;
	assert (min = '1') report "FAILED: Min not triggered after counting to minimal value" severity error;
	wait for 100ns;
	assert (count_result = x"F") report "FAILED: Counter did not underflow after counting below minimal value" severity error;
	assert (min = '0') report "FAILED: Min remained set after underflowing below minimal value" severity error;
	assert (max = '1') report "FAILED: Max not triggered after underflowing below minimal value" severity error;
	
	-- END OF TEST CODE --------------------------------------------------------
	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
	wait;
	-- report "test" severity error;
end process;
end tb;
