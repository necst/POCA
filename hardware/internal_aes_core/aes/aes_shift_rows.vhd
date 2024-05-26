----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2023 07:12:34 PM
-- Design Name: 
-- Module Name: aes_shift_rows - Behavioral
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

entity aes_shift_rows is
--  Port ( );
    port (
        input: in std_logic_vector(127 downto 0);
        output: out std_logic_vector(127 downto 0)
    );
end aes_shift_rows;

architecture rtl of aes_shift_rows is

begin
    output(127 downto 120) <= input(127 downto 120);
    output(119 downto 112) <= input(87 downto 80);
    output(111 downto 104) <= input(47 downto 40);
    output(103 downto 96) <= input(7 downto 0);

    output(95 downto 88) <= input(95 downto 88);
    output(87 downto 80) <= input(55 downto 48);
    output(79 downto 72) <= input(15 downto 8);
    output(71 downto 64) <= input(103 downto 96);

    output(63 downto 56) <= input(63 downto 56);
    output(55 downto 48) <= input(23 downto 16);
    output(47 downto 40) <= input(111 downto 104);
    output(39 downto 32) <= input(71 downto 64);

    output(31 downto 24) <= input(31 downto 24);
    output(23 downto 16) <= input(119 downto 112);
    output(15 downto 8) <= input(79 downto 72);
    output(7 downto 0) <= input(39 downto 32);
end rtl;
