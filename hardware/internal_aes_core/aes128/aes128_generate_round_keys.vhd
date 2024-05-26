----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/09/2023 11:49:28 AM
-- Design Name: 
-- Module Name: aes128_generate_round_keys - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity aes128_generate_round_keys is
--  Port ( );
    port (
        ap_clk: in std_logic;
        ap_rst: in std_logic;
        ap_start: in std_logic;
        ap_done: out std_logic;
        ap_idle: out std_logic;
        ap_ready: out std_logic;
        key: in std_logic_vector(127 downto 0);
        ap_return: inout round_keys
    );
end aes128_generate_round_keys;

architecture Behavioral of aes128_generate_round_keys is
    signal round: integer range 0 to 10 := 0;
    signal prev_key: std_logic_vector(127 downto 0);
    signal new_key: std_logic_vector(127 downto 0);
    signal idle: std_logic := '1';
begin
    prev_key <= key when round = 0 else ap_return(round);

    ap_done <= (not ap_start) when round = 10 else (not ap_start) when round = 0 else '0';
    ap_idle <= (idle) and (not ap_start);
    ap_ready <= not idle when round = 10 else not idle when round = 0 else idle;

    key_generator: entity work.aes128_generate_round_key
        port map (
            previous_round_key => prev_key,
            round => round,
            generated_key => new_key
        );

    advance_round: process(ap_clk)
    begin
        if rising_edge(ap_clk) then
            if ap_rst = '1' then
                round <= 0;
                idle <= ap_rst;
            elsif (ap_start = '1' or round > 0) and round < 10 then
                ap_return(0) <= key;
                ap_return(round + 1) <= new_key;

                round <= round + 1;
                idle <= '0';
            elsif ap_start = '1' and round >= 10 then
                idle <= '0';
            elsif round >= 10 then
                idle <= '1';
                round <= 0;
            end if;
        end if;
    end process advance_round;
end Behavioral;
