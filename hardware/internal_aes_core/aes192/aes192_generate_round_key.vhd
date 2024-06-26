----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2023 05:22:38 PM
-- Design Name: 
-- Module Name: aes192_generate_round_key - Behavioral
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

entity aes192_generate_round_key is
--  Port ( );
    port (
        previous_round_key: in std_logic_vector(191 downto 0);
        round: in integer range 0 to 8;
        generated_key: out std_logic_vector(191 downto 0)
    );
end aes192_generate_round_key;

architecture Behavioral of aes192_generate_round_key is
    signal temp: std_logic_vector(31 downto 0);
    signal temp_rotate: std_logic_vector(31 downto 0);
    signal temp_sub: std_logic_vector(31 downto 0);
    signal temp_xored: std_logic_vector(31 downto 0);
begin

    temp <= previous_round_key(31 downto 0);

    rotate_word: entity work.aes_rotate_word
        port map (
            input => temp,
            output => temp_rotate
        );

    sub_word: entity work.aes_sub_word
        port map (
            input => temp_rotate,
            output => temp_sub
        );

    xor_round_constant: entity work.aes_xor_round_constant
        port map (
            input => temp_sub,
            index => round,
            output => temp_xored
        );

    generated_key(191 downto 160) <= previous_round_key(191 downto 160) xor temp_xored;
    generated_key(159 downto 128) <= previous_round_key(159 downto 128) xor previous_round_key(191 downto 160) xor temp_xored;
    generated_key(127 downto 96) <= previous_round_key(127 downto 96) xor previous_round_key(159 downto 128) xor previous_round_key(191 downto 160) xor temp_xored;
    generated_key(95 downto 64) <= previous_round_key(95 downto 64) xor previous_round_key(127 downto 96) xor previous_round_key(159 downto 128) xor previous_round_key(191 downto 160) xor temp_xored;
    generated_key(63 downto 32) <= previous_round_key(63 downto 32) xor previous_round_key(95 downto 64) xor previous_round_key(127 downto 96) xor previous_round_key(159 downto 128) xor previous_round_key(191 downto 160) xor temp_xored;
    generated_key(31 downto 0) <= previous_round_key(31 downto 0) xor previous_round_key(63 downto 32) xor previous_round_key(95 downto 64) xor previous_round_key(127 downto 96) xor previous_round_key(159 downto 128) xor previous_round_key(191 downto 160) xor temp_xored;

end Behavioral;
