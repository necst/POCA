----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/27/2023 04:26:06 PM
-- Design Name: 
-- Module Name: aes_decrypt_block_orig - Behavioral
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

entity aes_decrypt_block_orig is
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
end aes_decrypt_block_orig;

architecture Behavioral of aes_decrypt_block_orig is
    signal feedback: std_logic_vector(127 downto 0);
    signal feedback_reg: std_logic_vector(127 downto 0);
    signal temp_state: std_logic_vector(127 downto 0);
    signal state: std_logic_vector(127 downto 0);
    signal state_end_swapped: std_logic_vector(127 downto 0);
    signal key: std_logic_vector(127 downto 0);
    signal final_round: std_logic := '0';
    signal round: integer range 0 to 15 := 0;
    signal idle: std_logic := '1';
    signal iter_count: integer range 0 to 15 := 0;
begin
    key <= keys(iter_count - round) when round < iter_count else
            keys(0);

    iter_count <= 14 when cipher_keysize(1) = '1' else
                  10;

    decryption_round: entity work.aes_decryption_round
        port map (
            input => feedback,
            output => state,
            key => key,
            final_round => final_round
        );

    ap_return <= state;
    
    ap_done <= (not ap_start) when round = iter_count else (not ap_start) when round = 0 else '0';
    ap_idle <= (idle) and (not ap_start);
    ap_ready <= not idle when round = iter_count else not idle when round = 0 else idle;
    
    final_round <= '1' when round = iter_count else '0';

    state_register: process (ap_clk)
    begin
        if rising_edge(ap_clk) and enable = '1' then
            if round = 0 then
                feedback <= input_r xor keys(iter_count);
            elsif round < iter_count then
                feedback <= state;
            end if;
        end if;
    end process state_register;

    advance_round: process (ap_clk, enable)
    begin
        if rising_edge(ap_clk) and enable = '1' then
            if ap_rst = '1' then
                round <= 0;
                idle <= ap_rst;
            elsif (ap_start = '1' or round > 0) and round < iter_count then
                if round < iter_count then
                    round <= round + 1;
                end if;

                idle <= '0';
            elsif ap_start = '1' and round = iter_count then
            	idle <= '0';
            	round <= 1;
            elsif round >= iter_count then
                idle <= '1';
            end if;
        end if;
    end process advance_round;
end Behavioral;