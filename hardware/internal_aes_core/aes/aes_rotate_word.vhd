----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/09/2023 04:20:28 PM
-- Design Name: 
-- Module Name: aes_rotate_word - Behavioral
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

entity aes_rotate_word is
--  Port ( );
    port (
        input: in std_logic_vector(31 downto 0);
        output: out std_logic_vector(31 downto 0)
    );
end aes_rotate_word;

architecture rtl of aes_rotate_word is

begin
        output <= input(23 downto 0) & input(31 downto 24);
end rtl;
