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

entity aes_process_block is
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
        cipher_keysize : IN STD_LOGIC_VECTOR (31 downto 0);
        cipher_direction : IN STD_LOGIC_VECTOR (31 downto 0);
        cipher_mode: IN STD_LOGIC_VECTOR (31 downto 0);
        ap_return: out std_logic_vector(127 downto 0)
    );
end aes_process_block;

architecture rtl of aes_process_block is
    signal done: std_logic;
    signal idle: std_logic;
    signal ready: std_logic;
    signal result: std_logic_vector(127 downto 0);

    signal done_dec: std_logic;
    signal idle_dec: std_logic;
    signal ready_dec: std_logic;
    signal result_dec: std_logic_vector(127 downto 0);

    signal input_r_swapped: std_logic_vector(127 downto 0);
    signal input_switched: std_logic_vector(127 downto 0);
    signal result_swapped: std_logic_vector(127 downto 0);
    signal result_dec_swapped: std_logic_vector(127 downto 0);
begin
    swap_endianness_in: entity work.aes_swap_endianness
        port map (
            arr_in => input_r,
            arr_out => input_r_swapped
        );

    swap_endianness_out: entity work.aes_swap_endianness
        port map (
            arr_in => result,
            arr_out => result_swapped
        );
    
    swap_endianness_out_dec: entity work.aes_swap_endianness
        port map (
            arr_in => result_dec,
            arr_out => result_dec_swapped
        );

    input_switched <= input_r when cipher_mode = x"00000002" else input_r_swapped;  

    aes_encrypt: entity work.aes_encrypt_block
        port map (
            ap_clk => ap_clk,
            ap_rst => ap_rst,
            ap_start => ap_start,
            ap_done => done,
            ap_idle => idle,
            ap_ready => ready,
            input_r => input_switched,
            keys => keys,
            enable => not cipher_direction(0),
            cipher_keysize => cipher_keysize,
            ap_return => result
        );

    aes_decrypt: entity work.aes_decrypt_block
        port map (
            ap_clk => ap_clk,
            ap_rst => ap_rst,
            ap_start => ap_start,
            ap_done => done_dec,
            ap_idle => idle_dec,
            ap_ready => ready_dec,
            input_r => input_r,
            keys => keys,
            enable => cipher_direction(0),
            cipher_keysize => cipher_keysize,
            ap_return => result_dec
        );
    
    ap_done <= done when cipher_direction(0) = '0' else done_dec;
    ap_idle <= idle when cipher_direction(0) = '0' else idle_dec;
    ap_ready <= ready when cipher_direction(0) = '0' else ready_dec;
    ap_return <= result_swapped when cipher_direction(0) = '0' else result_dec_swapped;
end rtl;