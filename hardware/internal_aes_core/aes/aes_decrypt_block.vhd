----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2023 04:31:21 PM
-- Design Name: 
-- Module Name: aes128_encrypt - Behavioral
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

entity aes_decrypt_block is
--  Port ( );
    port (
        ap_clk: in std_logic;
        ap_rst: in std_logic;
        ap_start: in std_logic;
        ap_done: out std_logic;
        ap_idle: out std_logic;
        ap_ready: out std_logic;
        input_r: in std_logic_vector(127 downto 0);
        keys: in round_keys;
        enable: in std_logic;
        cipher_keysize : IN STD_LOGIC_VECTOR (31 downto 0);
        ap_return: out std_logic_vector(127 downto 0)
    );
end aes_decrypt_block;

architecture Behavioral of aes_decrypt_block is
    signal feedback_dec: std_logic_vector(127 downto 0);
    signal temp_state_dec: std_logic_vector(127 downto 0);
    signal temp_state_dec_ph2: std_logic_vector(127 downto 0);
    signal state_dec: std_logic_vector(127 downto 0);
    signal key_dec: std_logic_vector(127 downto 0);
    
    signal round: integer range 0 to 15 := 0;

    signal state_end_swapped: std_logic_vector(127 downto 0);
    signal chosen_iter_count: integer range 0 to 15 := 0;
    signal iter_count: integer range 0 to 15 := 0;

    signal idle: std_logic := '1';
begin
    key_dec <= keys(iter_count - round) when round <= iter_count else
               keys(0);

    chosen_iter_count <= 10 when cipher_keysize = x"00000000" else
                         12 when cipher_keysize = x"00000001" else
                         14 when cipher_keysize = x"00000002" else
                         10;

    ap_return <= temp_state_dec xor keys(0);

    decryption_round_ph1: entity work.aes_decryption_round_ph1
        port map (
            input => feedback_dec,
            output => state_dec
        );

    decryption_round_ph2: entity work.aes_decryption_round_ph2
        port map (
            input => temp_state_dec,
            output => temp_state_dec_ph2,
            key => key_dec
        );
    
    ap_done <= (not ap_start) when round = iter_count else (not ap_start) when round = 0 else '0';
    ap_idle <= (idle) and (not ap_start);
    ap_ready <= not idle when round = iter_count else not idle when round = 0 else idle;    

    advance_round: process (ap_clk)
    begin
        if rising_edge(ap_clk) and enable = '1' then
            if ap_start = '1' then
                iter_count <= chosen_iter_count;
            end if;

            if ap_rst = '1' then
                round <= 0;
                idle <= ap_rst;
            elsif (ap_start = '1'  or round > 0) and round < iter_count then
                if round < iter_count then
                    round <= round + 1;
                end if;
               
                if round = 0 then
                    feedback_dec <= input_r xor keys(chosen_iter_count);
                else
                    feedback_dec <= temp_state_dec_ph2;
                end if;

                idle <= '0';
            elsif ap_start = '1' and round >= iter_count then
                feedback_dec <= input_r xor keys(chosen_iter_count);
            	round <= 1;
                idle <= '0';
            elsif round >= iter_count then
                idle <= '1';
            end if;
        end if;

        if falling_edge(ap_clk) and enable = '1' then
            temp_state_dec <= state_dec;
        end if;
    end process advance_round;
end Behavioral;
