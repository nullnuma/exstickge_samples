library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity i2c_iface is
  generic (
    CLK_PRESCALE : integer := 1;         -- Nのとき入力クロックの約1/(10N)がI2Cのクロック周波数となる。
    ENABLE_READ_STOP_CONDITION : integer := 0  -- 1のとき、READコマンド発行時にSTOPコンディションを生成する。
    );
  port (
    clk          : in std_logic;        -- Typ. 6.25MHz
    reset        : in std_logic;

    -- I2Cデバイスと接続する
    sic     : out std_logic;
    sid_i   : in  std_logic;
    sid_o   : out std_logic;
    sid_dir : out std_logic;

    -- 上位モジュールと接続する
    req             : in  std_logic;
    busy            : out std_logic;
    addr            : in  std_logic_vector(15 downto 0);
    data_in         : in  std_logic_vector(31 downto 0);
    data_out        : out std_logic_vector(31 downto 0);
    mode            : in  std_logic_vector(7 downto 0);
    data_length     : in  std_logic_vector(1 downto 0); -- データ幅が16bitのときに1とする。0のときは、下位8bitだけが有効。
    slave_addr      : in  std_logic_vector(7 downto 0); -- 下位6bitにアドレスを指定する。
    
    debug : out std_logic_vector(7 downto 0)
    );

end i2c_iface;

architecture RTL of i2c_iface is

  type SccbMainStateType is (MAIN_IDLE, DATA_WRITE, DATA_READ);
  signal state : SccbMainStateType;

  signal counter : unsigned(3 downto 0);

  type SccbSubStateType is (SUB_IDLE, START_CONDITION, STOP_CONDITION, OUTPUT_BUFFER, INPUT_BUFFER);
  signal substate : SccbSubStateType;

  signal substate_busy : std_logic;
  signal sub_counter   : unsigned(3 downto 0);
  signal buf_counter   : unsigned(3 downto 0);
  signal clk_counter   : unsigned(31 downto 0);
  signal byte_counter  : unsigned(1 downto 0);

  signal start_condition_req : std_logic;
  signal stop_condition_req  : std_logic;
  signal output_buffer_req   : std_logic;
  signal input_buffer_req    : std_logic;

  signal buf     : std_logic_vector(7 downto 0);
  signal sub_buf : std_logic_vector(7 downto 0);

  signal addr_reg     : std_logic_vector(15 downto 0);
  signal data_in_reg  : std_logic_vector(31 downto 0);
  signal data_out_reg : std_logic_vector(31 downto 0);

  signal mode_we : std_logic;
  signal mode_single_addr : std_logic;
  signal mode_16bit_addr : std_logic;
  signal addr_byte_count : std_logic;
  
begin  -- RTL

  mode_we          <= mode(0);          -- 1のときwrite, 0のときread
  mode_single_addr <= mode(1);          -- 1のときslaveaddrだけ、0のとき、slaveaddrとaddr
  mode_16bit_addr  <= mode(2);          -- 1のときaddrが16bit, 0のときaddrが8bit
  
  MAIN_STMT: process (clk)
  begin  -- process
    if clk'event and clk = '1' then
      if reset = '1' then
        state <= MAIN_IDLE;
        counter <= (others => '0');
        busy <= '0';
      else
        case state is
          
          when MAIN_IDLE =>

            if req = '1' then
              busy <= '1';
              addr_reg <= addr;
              addr_byte_count <= mode_16bit_addr;  -- 0のとき1byte, 1のとき2byte
              byte_counter <= unsigned(data_length); 
              if mode_we = '1' then
                state <= DATA_WRITE;
                data_in_reg <= data_in;
              else
                state <= DATA_READ;
              end if;
            else
              busy <= '0';
            end if;
            counter <= (others => '0');

          when DATA_WRITE =>
            case to_integer(counter) is
              when 0 =>                 -- START CODNDITION
                start_condition_req <= '1';
                counter <= counter + 1;
              when 1 =>                 -- output slave_addr after START_CONDITION
                start_condition_req <= '0';
                if start_condition_req = '0' and substate_busy = '0' then
                  output_buffer_req <= '1';
                  counter <= counter + 1;
                  buf <= slave_addr(6 downto 0) & '0';
                end if;
              when 2 =>                 -- output ADDR after slave_addr
                output_buffer_req <= '0';
                if output_buffer_req = '0' and substate_busy = '0' then
                  if mode_single_addr = '0' then
                    output_buffer_req <= '1';
                    buf <= addr_reg(7 downto 0);
                    addr_reg(7 downto 0) <= addr_reg(15 downto 8);
                    -- addrレジスタの長さ分繰り返す
                    if( addr_byte_count = '0' ) then
                      counter <= counter + 1;
                    else
                      -- このステートにとどまる
                      addr_byte_count <= '0';
                    end if;
                  else
                    counter <= counter + 1;  -- jump to output DATA
                  end if;
                end if;
              when 3 =>                 -- output DATA after ADDR
                output_buffer_req <= '0';
                if output_buffer_req = '0' and substate_busy = '0' then
                  output_buffer_req <= '1';
                  counter <= counter + 1;
                  buf <= data_in_reg(31 downto 24);
                end if;
              when 4 =>                 -- STOP_CONDITION after DATA
                output_buffer_req <= '0';
                if output_buffer_req = '0' and substate_busy = '0' then
                  -- 送信バイト長分繰り返す。
                  -- 入力データの上位バイトから送信する。
                  if( byte_counter = "00" ) then
                    stop_condition_req <= '1';
                    counter <= counter + 1;
                  else
                    byte_counter <= byte_counter-1;
                    data_in_reg <= data_in_reg(23 downto 0) & X"00";
                    counter <= counter-1;
                  end if;
                end if;
              when 5 =>                 -- return to IDLE after stop_condition
                stop_condition_req <= '0';
                if stop_condition_req = '0' and substate_busy = '0' then
                  state <= MAIN_IDLE;
                  counter <= (others => '0');
                end if;
              when others => null;
            end case;
            
          when DATA_READ =>
            case to_integer(counter) is
              when 0 =>                 -- START_CONDITION
                start_condition_req <= '1';
                counter <= counter + 1;
              when 1 =>                 -- slave_addr after START_CONDITION
                start_condition_req <= '0';
                if start_condition_req = '0' and substate_busy = '0' then
                  output_buffer_req <= '1';
                  counter <= counter + 1;
                  buf <= slave_addr(6 downto 0) & '0';
                end if;
              when 2 =>                 -- ADDR after slave_addr
                output_buffer_req <= '0';
                if output_buffer_req = '0' and substate_busy = '0' then
                  if mode_single_addr = '0' then
                    output_buffer_req <= '1';
                  end if;
                  -- addrレジスタの長さ分繰り返す
                  if( addr_byte_count = '0' ) then
                    counter <= counter + 1;
                  else
                    -- このステートにとどまる
                    addr_byte_count <= '0';
                  end if;
                  buf <= addr_reg(7 downto 0);
                  addr_reg(7 downto 0) <= addr_reg(15 downto 8);
                end if;
              when 3 =>                 -- STOP_CONDITION after ADDR
                output_buffer_req <= '0';
                if output_buffer_req = '0' and substate_busy = '0' then
                  if( ENABLE_READ_STOP_CONDITION = 1 ) then
                    stop_condition_req <= '1';
                  end if;
                  counter <= counter + 1;
                end if;
              when 4 =>                 -- WAIT after STOP_CONDITION
                stop_condition_req <= '0';
                if stop_condition_req = '0' and substate_busy = '0' then
                  counter <= counter + 1;
                end if;
              when 5 =>                 -- START_CONDITION
                start_condition_req <= '1';
                counter <= counter + 1;
              when 6 =>                 -- slave_addr after START_CONDITION
                start_condition_req <= '0';
                if start_condition_req = '0' and substate_busy = '0' then
                  output_buffer_req <= '1';
                  counter <= counter + 1;
                  buf <= slave_addr(6 downto 0) & '1';  -- read mode
                end if;
              when 7 =>                 -- INPUT DATA after slave_addr
                output_buffer_req <= '0';
                if output_buffer_req = '0' and substate_busy = '0' then
                  input_buffer_req <= '1';
                  counter <= counter + 1;
                end if;
              when 8 =>                 -- STOP_CONDITION after INPUT DATA
                input_buffer_req <= '0';
                if input_buffer_req = '0' and substate_busy = '0' then
                  data_out_reg(31 downto 0) <= data_out_reg(23 downto 0) & sub_buf;
                  -- 受信バイト数分繰り返す
                  if( byte_counter = "00" ) then
                    stop_condition_req <= '1';
                    counter <= counter + 1;
                  else
                    byte_counter <= byte_counter-1;
                    counter <= counter - 1;                    
                  end if;
                end if;
              when 9 =>                 -- return to IDLE after STOP_CONDITION
                stop_condition_req <= '0';
                data_out <= data_out_reg;
                if stop_condition_req = '0' and substate_busy = '0' then
                  state <= MAIN_IDLE;
                  counter <= (others => '0');
                  busy <= '0';
                end if;
              when others => null;
            end case;
          when others => state <= MAIN_IDLE;
        end case;
      end if;
    end if;
  end process MAIN_STMT;

  SUB_STMT: process (clk)
  begin  -- process
    if clk'event and clk = '1' then
      if reset = '1' then
        substate <= SUB_IDLE;
        sub_counter <= (others => '0');
        clk_counter <= (others => '0');
        buf_counter <= (others => '0');
        substate_busy <= '0';
        
        sic     <= '1';
        sid_o   <= '1';
        sid_dir <= '0';             -- output is available
      else
        
        case substate is
          
          when SUB_IDLE =>
            if start_condition_req = '1' then
              substate <= START_CONDITION;
              substate_busy <= '1';
            elsif stop_condition_req = '1' then
              substate <= STOP_CONDITION;
              substate_busy <= '1';
            elsif output_buffer_req = '1' then
              substate <= OUTPUT_BUFFER;
              substate_busy <= '1';
              sub_buf <= buf;
            elsif input_buffer_req = '1' then
              substate <= INPUT_BUFFER;
              substate_busy <= '1';
            else
              substate_busy <= '0';
            end if;
            sub_counter <= (others => '0');
            buf_counter <= (others => '0');
            clk_counter <= (others => '0');
          
          -- before this statement, sic should be asserted
          when START_CONDITION =>
            sid_dir <= '0';             -- output is available
            case to_integer(sub_counter) is
              when 0 =>
                sic <= '1';
                sid_o <= '1';
                if to_integer(clk_counter) = 3*CLK_PRESCALE then  -- > 600ns
                  clk_counter <= (others => '0');
                  sub_counter <= sub_counter + 1;
                else
                  clk_counter <= clk_counter + 1;
                end if;
              when 1 =>
                sic <= '1';
                sid_o <= '0';             -- sid will be de-asserted during sic is high
                if to_integer(clk_counter) = 3*CLK_PRESCALE then  -- > 600ns
                  clk_counter <= (others => '0');
                  sub_counter <= sub_counter + 1;
                else
                  clk_counter <= clk_counter + 1;
                end if;
              when 2 =>
                sic <= '0';
                sub_counter <= (others => '0');
                clk_counter <= (others => '0');
                substate_busy <= '0';
                substate <= SUB_IDLE;
              when others => null;
            end case;
            
          -- before this statement, sic should be de-asserted
          when STOP_CONDITION =>
            sid_dir <= '0';             -- output is available
            case to_integer(sub_counter) is
              when 0 =>
                sic <= '0';
                sid_o <= '0';
                if to_integer(clk_counter) = 3*CLK_PRESCALE then  -- > 600ns
                  clk_counter <= (others => '0');
                  sub_counter <= sub_counter + 1;
                else
                  clk_counter <= clk_counter + 1;
                end if;
              when 1 =>
                sic <= '1';
                sid_o <= '0';
                if to_integer(clk_counter) = 3*CLK_PRESCALE then  -- > 600ns
                  clk_counter <= (others => '0');
                  sub_counter <= sub_counter + 1;
                else
                  clk_counter <= clk_counter + 1;
                end if;
              when 2 =>
                sic <= '1';
                sid_o <= '1';             -- sid will be asserted during sic is high
                if to_integer(clk_counter) = 8*CLK_PRESCALE then  -- > 1.3us
                  clk_counter <= (others => '0');
                  sub_counter <= (others => '0');
                  substate_busy <= '0';
                  substate <= SUB_IDLE;
                else
                  clk_counter <= clk_counter + 1;
                end if;
              when others => null;
            end case;

          -- before this statement, sic should be de-asserted
          when OUTPUT_BUFFER =>
            case to_integer(sub_counter) is
              when 0 =>
                sid_dir <= '0';             -- output is available
                sic <= '0';
                if to_integer(clk_counter) = 1*CLK_PRESCALE then
                  sid_o <= sub_buf(7);          -- sid should be changed during sic is low
                  sub_buf <= sub_buf(6 downto 0) & '0';
                end if;
                if to_integer(clk_counter) = 8*CLK_PRESCALE then  -- > 1.3us
                  clk_counter <= (others => '0');
                  sub_counter <= sub_counter + 1;
                else
                  clk_counter <= clk_counter + 1;
                end if;
              when 1 =>
                sid_dir <= '0';             -- output is available
                sic <= '1';             -- data is available at this state
                if to_integer(clk_counter) = 3*CLK_PRESCALE then  -- > 600ns
                  clk_counter <= (others => '0');
                  sub_counter <= sub_counter + 1;
                else
                  clk_counter <= clk_counter + 1;
                end if;
              when 2 =>
                sid_dir <= '0';             -- output is available
                sic <= '0';
                if to_integer(buf_counter) = 7 then
                  buf_counter <= (others => '0');
                  sub_counter <= sub_counter + 1;
                else
                  buf_counter <= buf_counter + 1;
                  sub_counter <= (others => '0');
                end if;
              when 3 =>
                sid_dir <= '1';             -- input is available
                sub_counter <= sub_counter + 1;
              when 4 =>
                sic <= '0';             -- 1 clock to receive 1-bit for ack/nack
--                status <= sid_i;
                if to_integer(clk_counter) = 8*CLK_PRESCALE then  -- > 1.3us
                  clk_counter <= (others => '0');
                  sub_counter <= sub_counter + 1;
                else
                  clk_counter <= clk_counter + 1;
                end if;
              when 5 =>
                sic <= '1';
                if to_integer(clk_counter) = 3*CLK_PRESCALE then  -- > 600ns
                  clk_counter <= (others => '0');
                  sub_counter <= sub_counter + 1;
                else
                  clk_counter <= clk_counter + 1;
                end if;
              when 6 =>
                sic <= '0';
                if to_integer(clk_counter) = 8*CLK_PRESCALE then  -- > 1.3us
                  clk_counter <= (others => '0');
                  sub_counter <= sub_counter + 1;
                else
                  clk_counter <= clk_counter + 1;
                end if;
              when 7 =>
                sid_dir <= '0';             -- output is available
                sub_counter <= (others => '0');
                substate_busy <= '0';
                substate <= SUB_IDLE;
              when others => null;
            end case;
            
          -- before this statement, sic should be de-asserted
          when INPUT_BUFFER =>
            case to_integer(sub_counter) is
              when 0 =>
                sid_dir <= '1'; -- input is available
                sic <= '0';
                if to_integer(clk_counter) = 8*CLK_PRESCALE then  -- > 1.3us
                  clk_counter <= (others => '0');
                  sub_counter <= sub_counter + 1;
                else
                  clk_counter <= clk_counter + 1;
                end if;
              when 1 =>
                sic <= '1';             -- data is available at this state
                sub_counter <= sub_counter + 1;
              when 2 =>
                if to_integer(clk_counter) = 2*CLK_PRESCALE then
                  sub_buf <= sub_buf(6 downto 0) & sid_i;
                end if;
                if to_integer(clk_counter) = 3*CLK_PRESCALE then  -- > 600ns
                  clk_counter <= (others => '0');
                  sub_counter <= sub_counter + 1;
                else
                  clk_counter <= clk_counter + 1;
                end if;
              when 3 =>
                sic <= '0';
                if to_integer(buf_counter) = 7 then
                  sub_counter <= sub_counter + 1;
                  buf_counter <= (others => '0');
                else
                  sub_counter <= (others => '0');
                  buf_counter <= buf_counter + 1;
                end if;
              when 4 =>
                sic <= '0';             -- 1 clock to receive 1-bit for ack/nack
--                status <= sid_i;
                if to_integer(clk_counter) = 8*CLK_PRESCALE then  -- > 1.3us
                  clk_counter <= (others => '0');
                  sub_counter <= sub_counter + 1;
                else
                  clk_counter <= clk_counter + 1;
                end if;
              when 5 =>
                sic <= '1';
                if to_integer(clk_counter) = 3*CLK_PRESCALE then  -- > 600ns
                  clk_counter <= (others => '0');
                  sub_counter <= sub_counter + 1;
                else
                  clk_counter <= clk_counter + 1;
                end if;
              when 6 =>
                sic <= '0';
                sub_counter <= sub_counter + 1;
              when 7 =>
                sid_dir <= '0';             -- output is available
                sub_counter <= (others => '0');
                substate_busy <= '0';
                substate <= SUB_IDLE;
              when others => null;
            end case;
          when others => substate <= SUB_IDLE;
        end case;
      end if;
    end if;
  end process SUB_STMT;

end RTL;
