-----------------------------由于精度问题，本代码实现车速为36km/h---------------------------library ieee;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
entity taxi is
	port(clk:in std_logic;------------------------时钟信号100hz
	start:in std_logic;---------------------------开始信号
	stop:in std_logic;----------------------------停车信号
	pause:in std_logic;---------------------------暂停信号
	reset:in std_logic;---------------------------清零信号
	money:out integer range 0 to 1000;------------车费
	distance:out integer range 0 to 1000;---------行驶路程
	waitime:out integer range 0 to 100);----------等待时间
end taxi;

architecture one of taxi is
signal clk_1s: std_logic;
begin
---------------------------------------分频，得到1s-----------------------------------------
	process(clk)
		variable num: integer range 0 to 50 := 0;
	begin
	if clk'event and clk = '1' then
		if num = 100	then 
			num := 0;
			clk_1s <= not clk_1s;
		else num := num + 1;
		end if;
	end if;
	end process;
------------------------------------------end--------------------------------------------------

---------------------------------------模拟车的行驶情况-------------------------------------
	process(clk,clk_1s,start,stop,pause,reset)
		variable money_reg:integer range 0 to 1000 := 0;----------车费寄存器
		variable distance_reg:integer range 0 to 1000 := 0;-------行驶路程寄存器
		variable waitime_reg:integer range 0 to 1000 := 0;--------等待时间寄存器
		variable d_num: integer range 0 to 10 := 0;---------------记录关于路程的时间每10s
		variable w_num: integer range 0 to 60 := 0;---------------记录关于等候时间的时间每60s
		variable start_1:std_logic := '0';------------------------开始标志信号
		variable pause_1:std_logic := '0';------------------------暂停标志信号
		variable flag : std_logic := '1';-------------------------第一次开始标志信号
	begin 
		if start = '0' then  -----------开发板按键按下为0,表示开始---------------------
			start_1 := '1';
			pause_1 := '0';
		elsif reset = '0' and start_1 = '0' then
			money_reg := 0;
			distance_reg := 0;
			waitime_reg := 0;
			flag := '1';
		elsif pause = '0'  then
			pause_1 := '1';
		elsif stop = '0' then ----------
			start_1 := '0';
		elsif clk_1s'event and clk_1s = '1' then
			if pause_1 = '0' then
				if start_1 = '1' then
					if flag = '1' then
						flag := '0';
						money_reg := money_reg + 80;
					end if;
					if d_num =10 then
						d_num := 0;
						distance_reg := distance_reg + 1;
						if distance_reg > 30 then
							money_reg := money_reg + 2; 
						end if;
					else d_num := d_num + 1; 
					end if;
				end if;
			elsif pause_1 = '1' then
				if w_num = 60 then
					w_num := 0;
					money_reg := money_reg + 1;
					waitime_reg := waitime_reg + 1;
				end if;
				w_num := w_num + 1;
			end if;
		end if;	
		money <= money_reg;
		distance <= distance_reg;
		waitime <= waitime_reg;	
	end process;
end one;