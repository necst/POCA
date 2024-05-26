----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/31/2023 03:28:21 PM
-- Design Name: 
-- Module Name: aes_inv_sub_bytes - Behavioral
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

entity aes_inv_sub_bytes is
    --  Port ( );
    port (
        input: in std_logic_vector(127 downto 0);
        output: out std_logic_vector(127 downto 0)
    );
end aes_inv_sub_bytes;

architecture rtl of aes_inv_sub_bytes is

begin
    sub_bytes: for i in 0 to 15 generate
        sbox: entity work.aes_inv_sbox
            port map (
                input => input(8*i+7 downto 8*i),
                output => output(8*i+7 downto 8*i)
            );
    end generate sub_bytes;
end rtl;