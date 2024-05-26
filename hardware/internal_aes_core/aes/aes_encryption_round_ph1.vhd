----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2023 11:24:26 AM
-- Design Name: 
-- Module Name: aes_encryption_round_ph1 - Behavioral
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

entity aes_encryption_round_ph1 is
--  Port ( );
    port (
        input: in std_logic_vector(127 downto 0);
        output: out std_logic_vector(127 downto 0)
    );
end aes_encryption_round_ph1;

architecture Behavioral of aes_encryption_round_ph1 is
    signal state_sub_bytes: std_logic_vector(127 downto 0);
begin
    sub_bytes: entity work.aes_sub_bytes
        port map (
            input => input,
            output => state_sub_bytes
        );

    shift_rows: entity work.aes_shift_rows
        port map (
            input => state_sub_bytes,
            output => output
        );
end Behavioral;
