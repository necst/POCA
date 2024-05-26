----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/09/2023 04:20:28 PM
-- Design Name: 
-- Module Name: aes_sub_word - Behavioral
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

entity aes_sub_word is
--  Port ( );
    port (
        input: in std_logic_vector(31 downto 0);
        output: out std_logic_vector(31 downto 0)
    );
end aes_sub_word;

architecture Behavioral of aes_sub_word is

begin
    sub_word: for i in 0 to 3 generate
        sbox: entity work.aes_sbox
            port map(
                input => input(8*i+7 downto 8*i),
                output => output(8*i+7 downto 8*i)
            );
    end generate sub_word;
end Behavioral;
