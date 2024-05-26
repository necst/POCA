----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2023 02:44:45 PM
-- Design Name: 
-- Module Name: aes_inv_mix_columns - Behavioral
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

entity aes_inv_mix_columns is
--  Port ( );
    port (
        input: in std_logic_vector(127 downto 0);
        output: out std_logic_vector(127 downto 0)
    );
end aes_inv_mix_columns;

architecture rtl of aes_inv_mix_columns is

begin
    mix_0: entity work.aes_inv_mix_single_column
        port map (
            input => input(31 downto 0),
            output => output(31 downto 0)
        );

    mix_1: entity work.aes_inv_mix_single_column
        port map (
            input => input(63 downto 32),
            output => output(63 downto 32)
        );

    mix_2: entity work.aes_inv_mix_single_column
        port map (
            input => input(95 downto 64),
            output => output(95 downto 64)
        );

    mix_3: entity work.aes_inv_mix_single_column
        port map (
            input => input(127 downto 96),
            output => output(127 downto 96)
        );
end rtl;
