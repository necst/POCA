----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2023 11:35:51 PM
-- Design Name: 
-- Module Name: aes_encryption_round - Behavioral
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

entity aes_encryption_round is
--  Port ( );
    port (
        input: in std_logic_vector(127 downto 0);
        output: out std_logic_vector(127 downto 0);
        key: in std_logic_vector(127 downto 0);
        final_round: in std_logic
    );
end aes_encryption_round;

architecture Behavioral of aes_encryption_round is
    signal state_sub_bytes: std_logic_vector(127 downto 0);
    signal state_shift_rows: std_logic_vector(127 downto 0);
    signal state_mix_columns: std_logic_vector(127 downto 0);
begin 
    sub_bytes: entity work.aes_sub_bytes
        port map (
            input => input,
            output => state_sub_bytes
        );

    shift_rows: entity work.aes_shift_rows
        port map (
            input => state_sub_bytes,
            output => state_shift_rows
        );

    mix_columns: entity work.aes_mix_columns
        port map (
            input => state_shift_rows,
            output => state_mix_columns
        );

    output <= state_mix_columns xor key when final_round = '0' else state_shift_rows xor key;
end Behavioral;
