----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2023 04:06:44 PM
-- Design Name: 
-- Module Name: aes_mul2 - Behavioral
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

entity aes_mul2 is
--  Port ( );
    port (
        input: in std_logic_vector(7 downto 0);
        output: out std_logic_vector(7 downto 0)
    );
end aes_mul2;

architecture Behavioral of aes_mul2 is
    
begin
    mul2: process(input)
    begin
        case input is
            when x"00" => output <= x"00";
            when x"01" => output <= x"02";
            when x"02" => output <= x"04";
            when x"03" => output <= x"06";
            when x"04" => output <= x"08";
            when x"05" => output <= x"0a";
            when x"06" => output <= x"0c";
            when x"07" => output <= x"0e";
            when x"08" => output <= x"10";
            when x"09" => output <= x"12";
            when x"0a" => output <= x"14";
            when x"0b" => output <= x"16";
            when x"0c" => output <= x"18";
            when x"0d" => output <= x"1a";
            when x"0e" => output <= x"1c";
            when x"0f" => output <= x"1e";
            when x"10" => output <= x"20";
            when x"11" => output <= x"22";
            when x"12" => output <= x"24";
            when x"13" => output <= x"26";
            when x"14" => output <= x"28";
            when x"15" => output <= x"2a";
            when x"16" => output <= x"2c";
            when x"17" => output <= x"2e";
            when x"18" => output <= x"30";
            when x"19" => output <= x"32";
            when x"1a" => output <= x"34";
            when x"1b" => output <= x"36";
            when x"1c" => output <= x"38";
            when x"1d" => output <= x"3a";
            when x"1e" => output <= x"3c";
            when x"1f" => output <= x"3e";
            when x"20" => output <= x"40";
            when x"21" => output <= x"42";
            when x"22" => output <= x"44";
            when x"23" => output <= x"46";
            when x"24" => output <= x"48";
            when x"25" => output <= x"4a";
            when x"26" => output <= x"4c";
            when x"27" => output <= x"4e";
            when x"28" => output <= x"50";
            when x"29" => output <= x"52";
            when x"2a" => output <= x"54";
            when x"2b" => output <= x"56";
            when x"2c" => output <= x"58";
            when x"2d" => output <= x"5a";
            when x"2e" => output <= x"5c";
            when x"2f" => output <= x"5e";
            when x"30" => output <= x"60";
            when x"31" => output <= x"62";
            when x"32" => output <= x"64";
            when x"33" => output <= x"66";
            when x"34" => output <= x"68";
            when x"35" => output <= x"6a";
            when x"36" => output <= x"6c";
            when x"37" => output <= x"6e";
            when x"38" => output <= x"70";
            when x"39" => output <= x"72";
            when x"3a" => output <= x"74";
            when x"3b" => output <= x"76";
            when x"3c" => output <= x"78";
            when x"3d" => output <= x"7a";
            when x"3e" => output <= x"7c";
            when x"3f" => output <= x"7e";
            when x"40" => output <= x"80";
            when x"41" => output <= x"82";
            when x"42" => output <= x"84";
            when x"43" => output <= x"86";
            when x"44" => output <= x"88";
            when x"45" => output <= x"8a";
            when x"46" => output <= x"8c";
            when x"47" => output <= x"8e";
            when x"48" => output <= x"90";
            when x"49" => output <= x"92";
            when x"4a" => output <= x"94";
            when x"4b" => output <= x"96";
            when x"4c" => output <= x"98";
            when x"4d" => output <= x"9a";
            when x"4e" => output <= x"9c";
            when x"4f" => output <= x"9e";
            when x"50" => output <= x"a0";
            when x"51" => output <= x"a2";
            when x"52" => output <= x"a4";
            when x"53" => output <= x"a6";
            when x"54" => output <= x"a8";
            when x"55" => output <= x"aa";
            when x"56" => output <= x"ac";
            when x"57" => output <= x"ae";
            when x"58" => output <= x"b0";
            when x"59" => output <= x"b2";
            when x"5a" => output <= x"b4";
            when x"5b" => output <= x"b6";
            when x"5c" => output <= x"b8";
            when x"5d" => output <= x"ba";
            when x"5e" => output <= x"bc";
            when x"5f" => output <= x"be";
            when x"60" => output <= x"c0";
            when x"61" => output <= x"c2";
            when x"62" => output <= x"c4";
            when x"63" => output <= x"c6";
            when x"64" => output <= x"c8";
            when x"65" => output <= x"ca";
            when x"66" => output <= x"cc";
            when x"67" => output <= x"ce";
            when x"68" => output <= x"d0";
            when x"69" => output <= x"d2";
            when x"6a" => output <= x"d4";
            when x"6b" => output <= x"d6";
            when x"6c" => output <= x"d8";
            when x"6d" => output <= x"da";
            when x"6e" => output <= x"dc";
            when x"6f" => output <= x"de";
            when x"70" => output <= x"e0";
            when x"71" => output <= x"e2";
            when x"72" => output <= x"e4";
            when x"73" => output <= x"e6";
            when x"74" => output <= x"e8";
            when x"75" => output <= x"ea";
            when x"76" => output <= x"ec";
            when x"77" => output <= x"ee";
            when x"78" => output <= x"f0";
            when x"79" => output <= x"f2";
            when x"7a" => output <= x"f4";
            when x"7b" => output <= x"f6";
            when x"7c" => output <= x"f8";
            when x"7d" => output <= x"fa";
            when x"7e" => output <= x"fc";
            when x"7f" => output <= x"fe";
            when x"80" => output <= x"1b";
            when x"81" => output <= x"19";
            when x"82" => output <= x"1f";
            when x"83" => output <= x"1d";
            when x"84" => output <= x"13";
            when x"85" => output <= x"11";
            when x"86" => output <= x"17";
            when x"87" => output <= x"15";
            when x"88" => output <= x"0b";
            when x"89" => output <= x"09";
            when x"8a" => output <= x"0f";
            when x"8b" => output <= x"0d";
            when x"8c" => output <= x"03";
            when x"8d" => output <= x"01";
            when x"8e" => output <= x"07";
            when x"8f" => output <= x"05";
            when x"90" => output <= x"3b";
            when x"91" => output <= x"39";
            when x"92" => output <= x"3f";
            when x"93" => output <= x"3d";
            when x"94" => output <= x"33";
            when x"95" => output <= x"31";
            when x"96" => output <= x"37";
            when x"97" => output <= x"35";
            when x"98" => output <= x"2b";
            when x"99" => output <= x"29";
            when x"9a" => output <= x"2f";
            when x"9b" => output <= x"2d";
            when x"9c" => output <= x"23";
            when x"9d" => output <= x"21";
            when x"9e" => output <= x"27";
            when x"9f" => output <= x"25";
            when x"a0" => output <= x"5b";
            when x"a1" => output <= x"59";
            when x"a2" => output <= x"5f";
            when x"a3" => output <= x"5d";
            when x"a4" => output <= x"53";
            when x"a5" => output <= x"51";
            when x"a6" => output <= x"57";
            when x"a7" => output <= x"55";
            when x"a8" => output <= x"4b";
            when x"a9" => output <= x"49";
            when x"aa" => output <= x"4f";
            when x"ab" => output <= x"4d";
            when x"ac" => output <= x"43";
            when x"ad" => output <= x"41";
            when x"ae" => output <= x"47";
            when x"af" => output <= x"45";
            when x"b0" => output <= x"7b";
            when x"b1" => output <= x"79";
            when x"b2" => output <= x"7f";
            when x"b3" => output <= x"7d";
            when x"b4" => output <= x"73";
            when x"b5" => output <= x"71";
            when x"b6" => output <= x"77";
            when x"b7" => output <= x"75";
            when x"b8" => output <= x"6b";
            when x"b9" => output <= x"69";
            when x"ba" => output <= x"6f";
            when x"bb" => output <= x"6d";
            when x"bc" => output <= x"63";
            when x"bd" => output <= x"61";
            when x"be" => output <= x"67";
            when x"bf" => output <= x"65";
            when x"c0" => output <= x"9b";
            when x"c1" => output <= x"99";
            when x"c2" => output <= x"9f";
            when x"c3" => output <= x"9d";
            when x"c4" => output <= x"93";
            when x"c5" => output <= x"91";
            when x"c6" => output <= x"97";
            when x"c7" => output <= x"95";
            when x"c8" => output <= x"8b";
            when x"c9" => output <= x"89";
            when x"ca" => output <= x"8f";
            when x"cb" => output <= x"8d";
            when x"cc" => output <= x"83";
            when x"cd" => output <= x"81";
            when x"ce" => output <= x"87";
            when x"cf" => output <= x"85";
            when x"d0" => output <= x"bb";
            when x"d1" => output <= x"b9";
            when x"d2" => output <= x"bf";
            when x"d3" => output <= x"bd";
            when x"d4" => output <= x"b3";
            when x"d5" => output <= x"b1";
            when x"d6" => output <= x"b7";
            when x"d7" => output <= x"b5";
            when x"d8" => output <= x"ab";
            when x"d9" => output <= x"a9";
            when x"da" => output <= x"af";
            when x"db" => output <= x"ad";
            when x"dc" => output <= x"a3";
            when x"dd" => output <= x"a1";
            when x"de" => output <= x"a7";
            when x"df" => output <= x"a5";
            when x"e0" => output <= x"db";
            when x"e1" => output <= x"d9";
            when x"e2" => output <= x"df";
            when x"e3" => output <= x"dd";
            when x"e4" => output <= x"d3";
            when x"e5" => output <= x"d1";
            when x"e6" => output <= x"d7";
            when x"e7" => output <= x"d5";
            when x"e8" => output <= x"cb";
            when x"e9" => output <= x"c9";
            when x"ea" => output <= x"cf";
            when x"eb" => output <= x"cd";
            when x"ec" => output <= x"c3";
            when x"ed" => output <= x"c1";
            when x"ee" => output <= x"c7";
            when x"ef" => output <= x"c5";
            when x"f0" => output <= x"fb";
            when x"f1" => output <= x"f9";
            when x"f2" => output <= x"ff";
            when x"f3" => output <= x"fd";
            when x"f4" => output <= x"f3";
            when x"f5" => output <= x"f1";
            when x"f6" => output <= x"f7";
            when x"f7" => output <= x"f5";
            when x"f8" => output <= x"eb";
            when x"f9" => output <= x"e9";
            when x"fa" => output <= x"ef";
            when x"fb" => output <= x"ed";
            when x"fc" => output <= x"e3";
            when x"fd" => output <= x"e1";
            when x"fe" => output <= x"e7";
            when x"ff" => output <= x"e5";
            when others => null;
        end case;
    end process mul2;
end Behavioral;
