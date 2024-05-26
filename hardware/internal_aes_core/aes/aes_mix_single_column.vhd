----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2023 07:27:09 PM
-- Design Name: 
-- Module Name: aes_mix_single_column - Behavioral
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

entity aes_mix_single_column is
--  Port ( );
    port (
        input: in std_logic_vector(31 downto 0);
        output: out std_logic_vector(31 downto 0)
    );
end aes_mix_single_column;

architecture rtl of aes_mix_single_column is
    signal s0_0: std_logic_vector(7 downto 0);
    signal s0_1: std_logic_vector(7 downto 0);

    signal s1_0: std_logic_vector(7 downto 0);
    signal s1_1: std_logic_vector(7 downto 0);

    signal s2_0: std_logic_vector(7 downto 0);
    signal s2_1: std_logic_vector(7 downto 0);

    signal s3_0: std_logic_vector(7 downto 0);
    signal s3_1: std_logic_vector(7 downto 0);
begin
    mul_0: entity work.aes_mul2
        port map (
            input => input(31 downto 24),
            output => s0_0
        );

    mul_1: entity work.aes_mul3
        port map (
            input => input(23 downto 16),
            output => s0_1
        );

    mul_2: entity work.aes_mul2
        port map (
            input => input(23 downto 16),
            output => s1_0
        );

    mul_3: entity work.aes_mul3
        port map (
            input => input(15 downto 8),
            output => s1_1
        );

    mul_4: entity work.aes_mul2
        port map (
            input => input(15 downto 8),
            output => s2_0
        );
    
    mul_5: entity work.aes_mul3
        port map (
            input => input(7 downto 0),
            output => s2_1
        );

    mul_6: entity work.aes_mul3
        port map (
            input => input(31 downto 24),
            output => s3_0
        );

    mul_7: entity work.aes_mul2
        port map (
            input => input(7 downto 0),
            output => s3_1
        );

    output(31 downto 24) <= s0_0 xor s0_1 xor input(15 downto 8) xor input(7 downto 0);
    output(23 downto 16) <= s1_0 xor s1_1 xor input(31 downto 24) xor input(7 downto 0);
    output(15 downto 8) <= s2_0 xor s2_1 xor input(31 downto 24) xor input(23 downto 16);
    output(7 downto 0) <= s3_0 xor s3_1 xor input(23 downto 16) xor input(15 downto 8);
end rtl;
