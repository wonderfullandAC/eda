library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity encoder is
	port(clk6mhz:in std_logic;-----------------------��Ƶʱ���ź�6mhz
		money: in integer range 0 to 1000;-----------����
		distance: in integer range 0 to 1000;--------��ʻ·��
		waitime:in integer range 0 to 100;-----------�ȴ�ʱ��
		scan:out std_logic_vector(7 downto 0);-------����ܵ�ַѡ���ź�
		seg7:out std_logic_vector(6 downto 0);-------��ʾ����
		dot:out std_logic);--------------------------С����
end encoder;

-------------------------------------------��ʮ��������ת��Ϊ��λ������---------------------------------------------
architecture one of encoder is
	signal m_2,m_1,m_0:std_logic_vector(3 downto 0) ;-----------�ֱ�ָ���ѵ�ʮ���ư�λʮλ��λ
	signal d_2,d_1,d_0:std_logic_vector(3 downto 0);------------�ֱ�ָ��ʻ·�̵�ʮ���ư�λʮλ��λ
	signal w_1,w_0:std_logic_vector(3 downto 0);----------------�ֱ�ָ��ʻ·�̵�ʮ����ʮλ��λ
	signal num: std_logic_vector(3 downto 0);-------------------��ʾ����
begin
	process(clk6mhz,money,distance,waitime)
	variable d0,d1,d2:integer range 0 to 500;--------------1000����
	begin
	    ---------------��֪��Ϊʲôdistance rem 10����-----------------
		d0 := distance;
		d1 := distance / 10;
		d2 := d1 / 10;
		-------------------------------end-----------------------------
		
		-----------------��ʮ��������ת��Ϊ��λ������------------------
		m_0 <= conv_std_logic_vector(money rem 10, 4);
		m_1 <= conv_std_logic_vector((money / 10) rem 10, 4);
		m_2 <= conv_std_logic_vector(money / 100, 4);
		d_0 <= conv_std_logic_vector(d0 rem 10, 4);
		d_1 <= conv_std_logic_vector(d1 mod 10, 4);
		d_2 <= conv_std_logic_vector(d2 mod 10, 4);
		w_0 <= conv_std_logic_vector(waitime rem 10, 4);
		w_1 <= conv_std_logic_vector(waitime / 10, 4);
		-------------------------------end-----------------------------
	end process;
	
	-----------------------------------����ܵ�ַѡ��(�����ң�·�̣��ȴ�ʱ�䣬���ѣ�)-----------------------------
	process(clk6mhz, m_2,m_1,m_0,d_2,d_1,d_0,w_1,w_0)
		variable cnt:std_logic_vector(2 downto 0) ;
		begin
			if clk6mhz'event and clk6mhz = '1' then
				cnt := cnt + 1;
			end if;
			case cnt is
				when "000" => num <= d_2 ; dot <= '0'; scan <= "01111111";
				when "001" => num <= d_1 ; dot <= '1'; scan <= "10111111";
				when "010" => num <= d_0 ; dot <= '0'; scan <= "11011111";
				when "011" => num <= w_1 ; dot <= '0'; scan <= "11101111";
				when "100" => num <= w_0 ; dot <= '0'; scan <= "11110111";
				when "101" => num <= m_2 ; dot <= '0'; scan <= "11111011";
				when "110" => num <= m_1 ; dot <= '1'; scan <= "11111101";
				when "111" => num <= m_0 ; dot <= '0'; scan <= "11111110";
				when others => scan <= null;
			end case;
		end process;
	
	-----------------------------------�������ʾ�ź�-----------------------------------------------------------------
	process(num)
	begin
		case num is
			when "0000" => seg7 <= "0111111";
			when "0001" => seg7 <= "0000110";
			when "0010" => seg7 <= "1011011";
			when "0011" => seg7 <= "1001111";
			when "0100" => seg7 <= "1100110";
			when "0101" => seg7 <= "1101101";
			when "0110" => seg7 <= "1111101";
			when "0111" => seg7 <= "0000111";
			when "1000" => seg7 <= "1111111";
			when "1001" => seg7 <= "1101111";
			when others => seg7 <= "0000000";
		end case;
	end process;
end one;