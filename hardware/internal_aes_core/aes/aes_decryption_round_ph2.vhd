----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2023 11:24:26 AM
-- Design Name: 
-- Module Name: aes_decryption_round_ph2 - Behavioral
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

entity aes_decryption_round_ph2 is
--  Port ( );
    port (
        input: in std_logic_vector(127 downto 0);
        output: out std_logic_vector(127 downto 0);
        key: in std_logic_vector(127 downto 0)
    );
end aes_decryption_round_ph2;

architecture Behavioral of aes_decryption_round_ph2 is
    signal input_xored: std_logic_vector(127 downto 0);
begin
    input_xored <= input xor key;

    inv_mix_columns: entity work.aes_inv_mix_columns
        port map (
            input => input_xored,
            output => output
        );
end Behavioral;
