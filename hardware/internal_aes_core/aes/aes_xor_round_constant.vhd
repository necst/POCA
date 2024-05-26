----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/09/2023 04:20:28 PM
-- Design Name: 
-- Module Name: aes_xor_round_constant - Behavioral
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
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity aes_xor_round_constant is
--  Port ( );
    port (
        input: in std_logic_vector(31 downto 0);
        output: out std_logic_vector(31 downto 0);
        index: in integer range 0 to 9
    );
end aes_xor_round_constant;

architecture Behavioral of aes_xor_round_constant is

begin
    output(23 downto 0) <= input(23 downto 0);

    rcon: process(input, index)
    begin
        case index is
            when 0 => output(31 downto 24) <= input(31 downto 24) xor x"01";
            when 1 => output(31 downto 24) <= input(31 downto 24) xor x"02";
            when 2 => output(31 downto 24) <= input(31 downto 24) xor x"04";
            when 3 => output(31 downto 24) <= input(31 downto 24) xor x"08";
            when 4 => output(31 downto 24) <= input(31 downto 24) xor x"10";
            when 5 => output(31 downto 24) <= input(31 downto 24) xor x"20";
            when 6 => output(31 downto 24) <= input(31 downto 24) xor x"40";
            when 7 => output(31 downto 24) <= input(31 downto 24) xor x"80";
            when 8 => output(31 downto 24) <= input(31 downto 24) xor x"1b";
            when 9 => output(31 downto 24) <= input(31 downto 24) xor x"36";
            when others => output(31 downto 24) <= x"00";
        end case;
    end process rcon;
end Behavioral;
