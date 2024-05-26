----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2023 02:44:45 PM
-- Design Name: 
-- Module Name: aes_inv_mix_single_column - Behavioral
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

entity aes_inv_mix_single_column is
--  Port ( );
    port (
        input: in std_logic_vector(31 downto 0);
        output: out std_logic_vector(31 downto 0)
    );
end aes_inv_mix_single_column;

architecture rtl of aes_inv_mix_single_column is
    signal s0_0: std_logic_vector(7 downto 0);
    signal s0_1: std_logic_vector(7 downto 0);
    signal s0_2: std_logic_vector(7 downto 0);
    signal s0_3: std_logic_vector(7 downto 0);

    signal s1_0: std_logic_vector(7 downto 0);
    signal s1_1: std_logic_vector(7 downto 0);
    signal s1_2: std_logic_vector(7 downto 0);
    signal s1_3: std_logic_vector(7 downto 0);

    signal s2_0: std_logic_vector(7 downto 0);
    signal s2_1: std_logic_vector(7 downto 0);
    signal s2_2: std_logic_vector(7 downto 0);
    signal s2_3: std_logic_vector(7 downto 0);

    signal s3_0: std_logic_vector(7 downto 0);
    signal s3_1: std_logic_vector(7 downto 0);
    signal s3_2: std_logic_vector(7 downto 0);
    signal s3_3: std_logic_vector(7 downto 0);
begin
    mul_0_0: entity work.aes_mul14
        port map (
            input => input(31 downto 24),
            output => s0_0
        );

    mul_0_1: entity work.aes_mul11
        port map (
            input => input(23 downto 16),
            output => s0_1
        );

    mul_0_2: entity work.aes_mul13
        port map (
            input => input(15 downto 8),
            output => s0_2
        );

    mul_0_3: entity work.aes_mul9
        port map (
            input => input(7 downto 0),
            output => s0_3
        );

    mul_1_0: entity work.aes_mul9
        port map (
            input => input(31 downto 24),
            output => s1_0
        );

    mul_1_1: entity work.aes_mul14
        port map (
            input => input(23 downto 16),
            output => s1_1
        );

    mul_1_2: entity work.aes_mul11
        port map (
            input => input(15 downto 8),
            output => s1_2
        );

    mul_1_3: entity work.aes_mul13
        port map (
            input => input(7 downto 0),
            output => s1_3
        );

    mul_2_0: entity work.aes_mul13
        port map (
            input => input(31 downto 24),
            output => s2_0
        );

    mul_2_1: entity work.aes_mul9
        port map (
            input => input(23 downto 16),
            output => s2_1
        );

    mul_2_2: entity work.aes_mul14
        port map (
            input => input(15 downto 8),
            output => s2_2
        );

    mul_2_3: entity work.aes_mul11
        port map (
            input => input(7 downto 0),
            output => s2_3
        );

    mul_3_0: entity work.aes_mul11
        port map (
            input => input(31 downto 24),
            output => s3_0
        );

    mul_3_1: entity work.aes_mul13
        port map (
            input => input(23 downto 16),
            output => s3_1
        );

    mul_3_2: entity work.aes_mul9
        port map (
            input => input(15 downto 8),
            output => s3_2
        );

    mul_3_3: entity work.aes_mul14
        port map (
            input => input(7 downto 0),
            output => s3_3
        );

    output(31 downto 24) <= s0_0 xor s0_1 xor s0_2 xor s0_3;
    output(23 downto 16) <= s1_0 xor s1_1 xor s1_2 xor s1_3;
    output(15 downto 8) <= s2_0 xor s2_1 xor s2_2 xor s2_3;
    output(7 downto 0) <= s3_0 xor s3_1 xor s3_2 xor s3_3;
end rtl;
