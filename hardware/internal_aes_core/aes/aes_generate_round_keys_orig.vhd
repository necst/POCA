----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2023 10:48:06 PM
-- Design Name: 
-- Module Name: aes_generate_round_keys - Behavioral
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

entity aes_generate_round_keys_new is
--  Port ( );
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_idle : OUT STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        key : IN STD_LOGIC_VECTOR (255 downto 0);
        cipher_keysize : IN STD_LOGIC_VECTOR (31 downto 0);
        ap_return : INOUT round_keys
    );
end aes_generate_round_keys_new;

architecture Behavioral of aes_generate_round_keys_new is
    signal clock_div: std_logic := '0';
    signal delayed_start_m: std_logic := '0';
    signal delayed_start: std_logic;

    signal round: integer range 0 to 14 := 0;
    signal prev_key: std_logic_vector(127 downto 0);
    signal prev_w: std_logic_vector(31 downto 0);
    signal new_key: std_logic_vector(127 downto 0);
    signal idle: std_logic := '1';

    signal temp_round_keys: round_keys;

    signal key_size: std_logic;
    signal limit: integer range 0 to 14 := 14;
begin
    clock_divider: process(ap_clk)
    begin
        if rising_edge(ap_clk) then
            clock_div <= not clock_div;
            ap_return <= temp_round_keys;

            if ap_start = '1' then
                delayed_start_m <= '1';
            elsif delayed_start_m = '1' then
                delayed_start_m <= '0';
            end if;
        end if;
    end process clock_divider;

    delayed_start <= ap_start or delayed_start_m;

    prev_key <= key(255 downto 128) when round = 0 else temp_round_keys(round) when key_size = '0' else temp_round_keys(round - 1);
    prev_w <= temp_round_keys(round)(31 downto 0);
    limit <= 10 when cipher_keysize(1) = '0' else 14;

    ap_done <= (not delayed_start) when round = limit else (not delayed_start) when round = 0 else '0';
    ap_idle <= (idle) and (not delayed_start);
    ap_ready <= not idle when round = limit else not idle when round = 0 else idle;

    key_generator: entity work.aes_generate_round_key
        port map (
            previous_round_key => prev_key,
            previous_w => prev_w,
            round => round,
            key_size => key_size,
            generated_key => new_key
        );

    advance_round: process(clock_div)
    begin
        if rising_edge(clock_div) then
            temp_round_keys(0) <= key(255 downto 128);

            if ap_rst = '1' then
                round <= 0;
                idle <= ap_rst;
            elsif (delayed_start = '1' or round > 0) and round < limit then
                temp_round_keys(round + 1) <= new_key;
                round <= round + 1;
                idle <= '0';
            elsif delayed_start = '1' and round >= limit then
                idle <= '0';
            elsif round >= limit then
                idle <= '1';
                round <= 0;
            end if;

            if cipher_keysize = x"00000000" then
                key_size <= '0';
            else 
                key_size <= '1';
                temp_round_keys(1) <= key(127 downto 0);
            end if;
        end if;
    end process advance_round;
end Behavioral;