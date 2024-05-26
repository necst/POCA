----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2023 02:44:45 PM
-- Design Name: 
-- Module Name: aes_mul14 - Behavioral
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

entity aes_mul14 is
--  Port ( );
    port (
        input: in std_logic_vector(7 downto 0);
        output: out std_logic_vector(7 downto 0)
    );
end aes_mul14;

architecture Behavioral of aes_mul14 is

begin
    mul14: process(input)
    begin
        case input is
            when x"00" => output <= x"00";
            when x"01" => output <= x"0e";
            when x"02" => output <= x"1c";
            when x"03" => output <= x"12";
            when x"04" => output <= x"38";
            when x"05" => output <= x"36";
            when x"06" => output <= x"24";
            when x"07" => output <= x"2a";
            when x"08" => output <= x"70";
            when x"09" => output <= x"7e";
            when x"0a" => output <= x"6c";
            when x"0b" => output <= x"62";
            when x"0c" => output <= x"48";
            when x"0d" => output <= x"46";
            when x"0e" => output <= x"54";
            when x"0f" => output <= x"5a";
            when x"10" => output <= x"e0";
            when x"11" => output <= x"ee";
            when x"12" => output <= x"fc";
            when x"13" => output <= x"f2";
            when x"14" => output <= x"d8";
            when x"15" => output <= x"d6";
            when x"16" => output <= x"c4";
            when x"17" => output <= x"ca";
            when x"18" => output <= x"90";
            when x"19" => output <= x"9e";
            when x"1a" => output <= x"8c";
            when x"1b" => output <= x"82";
            when x"1c" => output <= x"a8";
            when x"1d" => output <= x"a6";
            when x"1e" => output <= x"b4";
            when x"1f" => output <= x"ba";
            when x"20" => output <= x"db";
            when x"21" => output <= x"d5";
            when x"22" => output <= x"c7";
            when x"23" => output <= x"c9";
            when x"24" => output <= x"e3";
            when x"25" => output <= x"ed";
            when x"26" => output <= x"ff";
            when x"27" => output <= x"f1";
            when x"28" => output <= x"ab";
            when x"29" => output <= x"a5";
            when x"2a" => output <= x"b7";
            when x"2b" => output <= x"b9";
            when x"2c" => output <= x"93";
            when x"2d" => output <= x"9d";
            when x"2e" => output <= x"8f";
            when x"2f" => output <= x"81";
            when x"30" => output <= x"3b";
            when x"31" => output <= x"35";
            when x"32" => output <= x"27";
            when x"33" => output <= x"29";
            when x"34" => output <= x"03";
            when x"35" => output <= x"0d";
            when x"36" => output <= x"1f";
            when x"37" => output <= x"11";
            when x"38" => output <= x"4b";
            when x"39" => output <= x"45";
            when x"3a" => output <= x"57";
            when x"3b" => output <= x"59";
            when x"3c" => output <= x"73";
            when x"3d" => output <= x"7d";
            when x"3e" => output <= x"6f";
            when x"3f" => output <= x"61";
            when x"40" => output <= x"ad";
            when x"41" => output <= x"a3";
            when x"42" => output <= x"b1";
            when x"43" => output <= x"bf";
            when x"44" => output <= x"95";
            when x"45" => output <= x"9b";
            when x"46" => output <= x"89";
            when x"47" => output <= x"87";
            when x"48" => output <= x"dd";
            when x"49" => output <= x"d3";
            when x"4a" => output <= x"c1";
            when x"4b" => output <= x"cf";
            when x"4c" => output <= x"e5";
            when x"4d" => output <= x"eb";
            when x"4e" => output <= x"f9";
            when x"4f" => output <= x"f7";
            when x"50" => output <= x"4d";
            when x"51" => output <= x"43";
            when x"52" => output <= x"51";
            when x"53" => output <= x"5f";
            when x"54" => output <= x"75";
            when x"55" => output <= x"7b";
            when x"56" => output <= x"69";
            when x"57" => output <= x"67";
            when x"58" => output <= x"3d";
            when x"59" => output <= x"33";
            when x"5a" => output <= x"21";
            when x"5b" => output <= x"2f";
            when x"5c" => output <= x"05";
            when x"5d" => output <= x"0b";
            when x"5e" => output <= x"19";
            when x"5f" => output <= x"17";
            when x"60" => output <= x"76";
            when x"61" => output <= x"78";
            when x"62" => output <= x"6a";
            when x"63" => output <= x"64";
            when x"64" => output <= x"4e";
            when x"65" => output <= x"40";
            when x"66" => output <= x"52";
            when x"67" => output <= x"5c";
            when x"68" => output <= x"06";
            when x"69" => output <= x"08";
            when x"6a" => output <= x"1a";
            when x"6b" => output <= x"14";
            when x"6c" => output <= x"3e";
            when x"6d" => output <= x"30";
            when x"6e" => output <= x"22";
            when x"6f" => output <= x"2c";
            when x"70" => output <= x"96";
            when x"71" => output <= x"98";
            when x"72" => output <= x"8a";
            when x"73" => output <= x"84";
            when x"74" => output <= x"ae";
            when x"75" => output <= x"a0";
            when x"76" => output <= x"b2";
            when x"77" => output <= x"bc";
            when x"78" => output <= x"e6";
            when x"79" => output <= x"e8";
            when x"7a" => output <= x"fa";
            when x"7b" => output <= x"f4";
            when x"7c" => output <= x"de";
            when x"7d" => output <= x"d0";
            when x"7e" => output <= x"c2";
            when x"7f" => output <= x"cc";
            when x"80" => output <= x"41";
            when x"81" => output <= x"4f";
            when x"82" => output <= x"5d";
            when x"83" => output <= x"53";
            when x"84" => output <= x"79";
            when x"85" => output <= x"77";
            when x"86" => output <= x"65";
            when x"87" => output <= x"6b";
            when x"88" => output <= x"31";
            when x"89" => output <= x"3f";
            when x"8a" => output <= x"2d";
            when x"8b" => output <= x"23";
            when x"8c" => output <= x"09";
            when x"8d" => output <= x"07";
            when x"8e" => output <= x"15";
            when x"8f" => output <= x"1b";
            when x"90" => output <= x"a1";
            when x"91" => output <= x"af";
            when x"92" => output <= x"bd";
            when x"93" => output <= x"b3";
            when x"94" => output <= x"99";
            when x"95" => output <= x"97";
            when x"96" => output <= x"85";
            when x"97" => output <= x"8b";
            when x"98" => output <= x"d1";
            when x"99" => output <= x"df";
            when x"9a" => output <= x"cd";
            when x"9b" => output <= x"c3";
            when x"9c" => output <= x"e9";
            when x"9d" => output <= x"e7";
            when x"9e" => output <= x"f5";
            when x"9f" => output <= x"fb";
            when x"a0" => output <= x"9a";
            when x"a1" => output <= x"94";
            when x"a2" => output <= x"86";
            when x"a3" => output <= x"88";
            when x"a4" => output <= x"a2";
            when x"a5" => output <= x"ac";
            when x"a6" => output <= x"be";
            when x"a7" => output <= x"b0";
            when x"a8" => output <= x"ea";
            when x"a9" => output <= x"e4";
            when x"aa" => output <= x"f6";
            when x"ab" => output <= x"f8";
            when x"ac" => output <= x"d2";
            when x"ad" => output <= x"dc";
            when x"ae" => output <= x"ce";
            when x"af" => output <= x"c0";
            when x"b0" => output <= x"7a";
            when x"b1" => output <= x"74";
            when x"b2" => output <= x"66";
            when x"b3" => output <= x"68";
            when x"b4" => output <= x"42";
            when x"b5" => output <= x"4c";
            when x"b6" => output <= x"5e";
            when x"b7" => output <= x"50";
            when x"b8" => output <= x"0a";
            when x"b9" => output <= x"04";
            when x"ba" => output <= x"16";
            when x"bb" => output <= x"18";
            when x"bc" => output <= x"32";
            when x"bd" => output <= x"3c";
            when x"be" => output <= x"2e";
            when x"bf" => output <= x"20";
            when x"c0" => output <= x"ec";
            when x"c1" => output <= x"e2";
            when x"c2" => output <= x"f0";
            when x"c3" => output <= x"fe";
            when x"c4" => output <= x"d4";
            when x"c5" => output <= x"da";
            when x"c6" => output <= x"c8";
            when x"c7" => output <= x"c6";
            when x"c8" => output <= x"9c";
            when x"c9" => output <= x"92";
            when x"ca" => output <= x"80";
            when x"cb" => output <= x"8e";
            when x"cc" => output <= x"a4";
            when x"cd" => output <= x"aa";
            when x"ce" => output <= x"b8";
            when x"cf" => output <= x"b6";
            when x"d0" => output <= x"0c";
            when x"d1" => output <= x"02";
            when x"d2" => output <= x"10";
            when x"d3" => output <= x"1e";
            when x"d4" => output <= x"34";
            when x"d5" => output <= x"3a";
            when x"d6" => output <= x"28";
            when x"d7" => output <= x"26";
            when x"d8" => output <= x"7c";
            when x"d9" => output <= x"72";
            when x"da" => output <= x"60";
            when x"db" => output <= x"6e";
            when x"dc" => output <= x"44";
            when x"dd" => output <= x"4a";
            when x"de" => output <= x"58";
            when x"df" => output <= x"56";
            when x"e0" => output <= x"37";
            when x"e1" => output <= x"39";
            when x"e2" => output <= x"2b";
            when x"e3" => output <= x"25";
            when x"e4" => output <= x"0f";
            when x"e5" => output <= x"01";
            when x"e6" => output <= x"13";
            when x"e7" => output <= x"1d";
            when x"e8" => output <= x"47";
            when x"e9" => output <= x"49";
            when x"ea" => output <= x"5b";
            when x"eb" => output <= x"55";
            when x"ec" => output <= x"7f";
            when x"ed" => output <= x"71";
            when x"ee" => output <= x"63";
            when x"ef" => output <= x"6d";
            when x"f0" => output <= x"d7";
            when x"f1" => output <= x"d9";
            when x"f2" => output <= x"cb";
            when x"f3" => output <= x"c5";
            when x"f4" => output <= x"ef";
            when x"f5" => output <= x"e1";
            when x"f6" => output <= x"f3";
            when x"f7" => output <= x"fd";
            when x"f8" => output <= x"a7";
            when x"f9" => output <= x"a9";
            when x"fa" => output <= x"bb";
            when x"fb" => output <= x"b5";
            when x"fc" => output <= x"9f";
            when x"fd" => output <= x"91";
            when x"fe" => output <= x"83";
            when x"ff" => output <= x"8d";
            when others => null;
        end case;
    end process mul14;
end Behavioral;
