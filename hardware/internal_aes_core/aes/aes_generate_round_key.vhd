----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/10/2023 12:52:47 PM
-- Design Name: 
-- Module Name: aes_generate_round_key - Behavioral
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

entity aes_generate_round_key is
--  Port ( );
    port (
        previous_round_key: in std_logic_vector(127 downto 0);
        previous_w: in std_logic_vector(31 downto 0);
        round: in integer range 0 to 15;
        key_size: in std_logic;
        generated_key: out std_logic_vector(127 downto 0)
    );
end aes_generate_round_key;

architecture Behavioral of aes_generate_round_key is
    signal temp: std_logic_vector(31 downto 0);
    signal temp_sub_input: std_logic_vector(31 downto 0);
    signal w_last: std_logic_vector(31 downto 0);
    
    signal temp_rotate_1: std_logic_vector(31 downto 0);
    signal temp_sub_1: std_logic_vector(31 downto 0);
    signal temp_xored_1: std_logic_vector(31 downto 0);

    signal temp_xored_2: std_logic_vector(31 downto 0);

    signal temp_sub_3: std_logic_vector(31 downto 0);

    signal round_diff: integer range 0 to 15;
    signal round_div: integer range 0 to 9;
begin
    round_diff <= round;
    round_div <= round_diff / 2;

    -- rotate_word: entity work.aes_rotate_word
    --     port map (
    --         input => previous_w,
    --         output => temp_rotate
    --     );

    -- temp_sub_input <= temp_rotate when (key_size = '0') else temp_rotate when (round mod 2 = 1) else previous_w;

    -- sub_word: entity work.aes_sub_word
    --     port map (
    --         input => temp_sub_input,
    --         output => temp_sub
    --     );

    -- round_index <= round when (key_size = '0') else (round / 2);

    -- xor_round_constant: entity work.aes_xor_round_constant
    --     port map (
    --         input => temp_sub,
    --         index => round_index,
    --         output => temp_xored
    --     );

    -- w_last <= temp_xored when (key_size = '0') else temp_xored when (round mod 2 = 1) else temp_sub;

    -- when (key_size = '0')

    rotate_word_1: entity work.aes_rotate_word
        port map (
            input => previous_w,
            output => temp_rotate_1
        );

    sub_word_1: entity work.aes_sub_word
        port map (
            input => temp_rotate_1,
            output => temp_sub_1
        );

    xor_round_constant_1: entity work.aes_xor_round_constant
        port map (
            input => temp_sub_1,
            index => round_diff,
            output => temp_xored_1
        );

    -- when (key_size = '1' and round mod 2 = 1)

    xor_round_constant_2: entity work.aes_xor_round_constant
        port map (
            input => temp_sub_1,
            index => round_div,
            output => temp_xored_2
        );

    -- when (key_size = '1' and round mod 2 = 0)

    sub_word_3: entity work.aes_sub_word
        port map (
            input => previous_w,
            output => temp_sub_3
        );

    w_last <= temp_xored_1 when (key_size = '0') else temp_xored_2 when (round_diff mod 2 = 1) else temp_sub_3;

    generated_key(127 downto 96) <= previous_round_key(127 downto 96) xor w_last;
    generated_key(95 downto 64) <= previous_round_key(95 downto 64) xor previous_round_key(127 downto 96) xor w_last;
    generated_key(63 downto 32) <= previous_round_key(63 downto 32) xor previous_round_key(95 downto 64) xor previous_round_key(127 downto 96) xor w_last;
    generated_key(31 downto 0) <= previous_round_key(31 downto 0) xor previous_round_key(63 downto 32) xor previous_round_key(95 downto 64) xor previous_round_key(127 downto 96) xor w_last;

end Behavioral;
