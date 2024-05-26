----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2023 06:52:23 PM
-- Design Name: 
-- Module Name: aes192_convert_keys - Behavioral
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
use work.aes_types.all;
use work.aes192_types.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity aes192_convert_keys is
--  Port ( );
    port (
        keys_in: in round_keys_192_wide;
        keys_out: out round_keys
    );
end aes192_convert_keys;

architecture rtl of aes192_convert_keys is

begin
    keys_out(0) <= keys_in(0)(191 downto 64);
    keys_out(1) <= keys_in(0)(63 downto 0) & keys_in(1)(191 downto 128);
    keys_out(2) <= keys_in(1)(127 downto 0);
    keys_out(3) <= keys_in(2)(191 downto 64);
    keys_out(4) <= keys_in(2)(63 downto 0) & keys_in(3)(191 downto 128);
    keys_out(5) <= keys_in(3)(127 downto 0);
    keys_out(6) <= keys_in(4)(191 downto 64);
    keys_out(7) <= keys_in(4)(63 downto 0) & keys_in(5)(191 downto 128);
    keys_out(8) <= keys_in(5)(127 downto 0);
    keys_out(9) <= keys_in(6)(191 downto 64);
    keys_out(10) <= keys_in(6)(63 downto 0) & keys_in(7)(191 downto 128);
    keys_out(11) <= keys_in(7)(127 downto 0);
    keys_out(12) <= keys_in(8)(191 downto 64);
end rtl;
