----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/20/2023 07:18:39 PM
-- Design Name: 
-- Module Name: aes256_generate_round_keys - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity aes256_generate_round_keys is
--  Port ( );
    port (
        ap_clk: in std_logic;
        ap_rst: in std_logic;
        ap_start: in std_logic;
        ap_done: out std_logic;
        ap_idle: out std_logic;
        ap_ready: out std_logic;
        key: in std_logic_vector(255 downto 0);
        ap_return: inout round_keys
    );
end aes256_generate_round_keys;

architecture Behavioral of aes256_generate_round_keys is
    signal round: integer range 0 to 7 := 0;
    signal prev_key: std_logic_vector(255 downto 0);
    signal new_key: std_logic_vector(255 downto 0);
    signal idle: std_logic := '1';
    signal wait_clock: integer range 0 to 3 := 0;
begin
    prev_key <= key when round = 0
                else ap_return(2 * round) & x"00000000000000000000000000000000" when round = 7
                else ap_return(2 * round) & ap_return(2 * round + 1);

    ap_done <= (not ap_start) when (round = 7 and wait_clock = 0) else (not ap_start) when round = 0 else '0';
    ap_idle <= (idle) and (not ap_start);
    ap_ready <= not idle when round = 7 else not idle when round = 0 else idle;
    
    key_generator: entity work.aes256_generate_round_key
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
            elsif wait_clock > 0 then
            	wait_clock <= wait_clock - 1;
            elsif (ap_start = '1' or round > 0) and round < 7 and wait_clock = 0 then
                ap_return(0) <= key(255 downto 128);
                ap_return(1) <= key(127 downto 0);
                ap_return(2 * (round + 1)) <= new_key(255 downto 128);
                if round < 6 then
                    ap_return(2 * (round + 1) + 1) <= new_key(127 downto 0);
                end if;

                round <= round + 1;
                idle <= '0';
                wait_clock <= 3;
            elsif ap_start = '1' and round >= 7 then
                idle <= '0';
            elsif round >= 7 then
                idle <= '1';
                round <= 0;
            end if;
        end if;
    end process advance_round;
end Behavioral;
