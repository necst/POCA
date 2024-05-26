----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/09/2023 05:57:26 PM
-- Design Name: 
-- Module Name: aes_types - Behavioral
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

package aes_types is
    type round_keys_128 is array (0 to 10) of std_logic_vector(127 downto 0);
    type round_keys_192 is array (0 to 12) of std_logic_vector(127 downto 0);
    type round_keys_256 is array (0 to 14) of std_logic_vector(127 downto 0);

    type round_keys is array (0 to 14) of std_logic_vector(127 downto 0);
end package;
