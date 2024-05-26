----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2023 04:28:49 PM
-- Design Name: 
-- Module Name: aes_swap_endianness - Behavioral
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

entity aes_swap_endianness is
--  Port ( );
    port (
        arr_in: in std_logic_vector(127 downto 0);
        arr_out: out std_logic_vector(127 downto 0)
    );
end aes_swap_endianness;

architecture rtl of aes_swap_endianness is

begin
    arr_out(127 downto 120) <= arr_in(7 downto 0);
    arr_out(119 downto 112) <= arr_in(15 downto 8);
    arr_out(111 downto 104) <= arr_in(23 downto 16);
    arr_out(103 downto 96) <= arr_in(31 downto 24);
    arr_out(95 downto 88) <= arr_in(39 downto 32);
    arr_out(87 downto 80) <= arr_in(47 downto 40);
    arr_out(79 downto 72) <= arr_in(55 downto 48);
    arr_out(71 downto 64) <= arr_in(63 downto 56);
    arr_out(63 downto 56) <= arr_in(71 downto 64);
    arr_out(55 downto 48) <= arr_in(79 downto 72);
    arr_out(47 downto 40) <= arr_in(87 downto 80);
    arr_out(39 downto 32) <= arr_in(95 downto 88);
    arr_out(31 downto 24) <= arr_in(103 downto 96);
    arr_out(23 downto 16) <= arr_in(111 downto 104);
    arr_out(15 downto 8) <= arr_in(119 downto 112);
    arr_out(7 downto 0) <= arr_in(127 downto 120);
end rtl;
