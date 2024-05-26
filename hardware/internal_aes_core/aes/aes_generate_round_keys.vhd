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

entity aes_generate_round_keys is
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
end aes_generate_round_keys;

architecture Behavioral of aes_generate_round_keys is
    signal round: integer range 0 to 15 := 0;
    signal prev_key: std_logic_vector(127 downto 0);
    signal prev_w: std_logic_vector(31 downto 0);
    signal new_key: std_logic_vector(127 downto 0);
    signal idle: std_logic := '1';

    signal enable: std_logic;

    signal prev_key_reg: std_logic_vector(127 downto 0);
    signal new_key_reg: std_logic_vector(127 downto 0);

    signal key_size: std_logic;
    signal limit: integer range 0 to 15;
begin
    key_size <= '1' when cipher_keysize = x"00000002" else '0';

    limit <= 10 when key_size = '0' else 14;

    prev_key <= new_key_reg when key_size = '0' else prev_key_reg;
    prev_w <= new_key_reg(31 downto 0);

    ap_done <= (not ap_start) when round = limit else (not ap_start) when round = 0 else '0';
    ap_idle <= (idle) and (not ap_start);
    ap_ready <= (not idle) when round = limit else (not idle) when round = 0 else idle;

    key_generator: entity work.aes_generate_round_key
        port map (
            previous_round_key => prev_key,
            previous_w => prev_w,
            round => round,
            key_size => key_size,
            generated_key => new_key
        );

    advance_round: process(ap_clk)
    begin
        if rising_edge(ap_clk) then
            if key_size = '1' then
                ap_return(0) <= key(255 downto 128);
                ap_return(1) <= key(127 downto 0);
                prev_key_reg <= key(255 downto 128);
                new_key_reg <= key(127 downto 0);
            else
                ap_return(0) <= key(127 downto 0);
                new_key_reg <= key(127 downto 0);
            end if;

            if ap_rst = '1' then
                round <= 0;
                idle <= ap_rst;
            elsif (ap_start = '1' or round > 0) and round < limit then
                if key_size = '0' or round > 0 then
                    ap_return(round + 1) <= new_key;
                    prev_key_reg <= new_key_reg;
                    new_key_reg <= new_key;
                end if;
                round <= round + 1;
                idle <= '0';
            elsif ap_start = '1' and round >= limit then
                idle <= '0';
            elsif round >= limit then
                idle <= '1';
                round <= 0;
            end if;
        end if;
    end process advance_round;
end Behavioral;