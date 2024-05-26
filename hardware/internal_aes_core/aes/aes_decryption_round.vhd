----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2023 02:44:45 PM
-- Design Name: 
-- Module Name: aes_decryption_round - Behavioral
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

entity aes_decryption_round is
--  Port ( );
    port (
        input: in std_logic_vector(127 downto 0);
        output: out std_logic_vector(127 downto 0);
        key: in std_logic_vector(127 downto 0);
        final_round: in std_logic
    );
end aes_decryption_round;

architecture rtl of aes_decryption_round is
    signal state_shift_rows: std_logic_vector(127 downto 0);
    signal state_sub_bytes: std_logic_vector(127 downto 0);
    signal state_keyed: std_logic_vector(127 downto 0);
    signal state_mix_columns: std_logic_vector(127 downto 0);
begin
    inv_shift_rows: entity work.aes_inv_shift_rows
        port map (
            input => input,
            output => state_shift_rows
        );

    inv_sub_bytes: entity work.aes_inv_sub_bytes
        port map (
            input => state_shift_rows,
            output => state_sub_bytes
        );

    state_keyed <= state_sub_bytes xor key;

    inv_mix_columns: entity work.aes_inv_mix_columns
        port map (
            input => state_keyed,
            output => state_mix_columns
        );

    output <= state_mix_columns when final_round = '0' else state_keyed;
end rtl;
