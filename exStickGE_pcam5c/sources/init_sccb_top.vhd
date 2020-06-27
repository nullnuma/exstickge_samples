library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity init_sccb_top is
  port (
    pClk         : in  std_logic;
    pReset       : in  std_logic;
    time_1ms     : in  std_logic;
    set_mode     : in  std_logic_vector(1 downto 0);
    --------
    init_req     : in  std_logic;
    init_done    : out std_logic;
    init_err     : out std_logic;
    I2CIO_BUSY   : out std_logic; --moni
    --------
    I2CIO_SIC    : out std_logic;
    I2CIO_SID_I  : in  std_logic;
    I2CIO_SID_O  : out std_logic;
    I2CIO_SID_D  : out std_logic;
    
    debug : out std_logic_vector(7 downto 0)
  );
  
end init_sccb_top;

architecture RTL of init_sccb_top is

  COMPONENT sccb_bmem IS
  PORT (
    --Port A
    ADDRA      : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
    DOUTA      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    CLKA       : IN  STD_LOGIC
  );
  END COMPONENT;
  
  component i2c_iface
    generic(
      CLK_PRESCALE               : integer
      );
    port(
      clk          : in std_logic;
      reset        : in std_logic;
      --------
      sic          : out std_logic;
      sid_i        : in  std_logic;
      sid_o        : out std_logic;
      sid_dir      : out std_logic;
      --------
      req          : in  std_logic;
      busy         : out std_logic;
      addr         : in  std_logic_vector(15 downto 0);
      data_in      : in  std_logic_vector(31 downto 0);
      data_out     : out std_logic_vector(31 downto 0);
      mode         : in  std_logic_vector(7 downto 0);
      data_length  : in  std_logic_vector(1 downto 0);
      slave_addr   : in  std_logic_vector(7 downto 0);
      --------
      debug        : out std_logic_vector(7 downto 0)
      );
  end component;

  constant READ_DATA_BYTES                 : std_logic_vector(7 downto 0) := "00000011";
  constant DEV_I2C_SADDR                   : std_logic_vector(7 downto 0) := "00111100"; --78h>>1

  type CONT_STATE_TYPE is (
     INIT_IDLE_ST,
     READ_SET_ST,
     SET_REG_ST,
     SET_REG_WAIT_ST,
     INIT_END_ST,
     INIT_ERR_ST
--     USER_MODE_IDLE_ST,
--     USER_MODE_I2C_ST,
--     USER_MODE_END_ST
  );
  signal state      : CONT_STATE_TYPE := INIT_IDLE_ST;

  signal time_cnt   : std_logic_vector(31 downto 0);

  -----------------
  type BMEM_CONT_STATE_TYPE is (
     BMEM_ADDRSET_ST, 
     BMEM_WAIT1_ST,
     BMEM_READ_ST,
     BMEM_END_ST
  );
  signal bmem_cont  : BMEM_CONT_STATE_TYPE := BMEM_ADDRSET_ST;

  signal bmem_addr    : std_logic_vector(8 downto 0);
  signal bmem_rdata   : std_logic_vector(31 downto 0);
  
  signal set_addr     : std_logic_vector(15 downto 0);
  signal set_data     : std_logic_vector(7 downto 0);
  signal set_i2cmode  : std_logic;
  -----------------
  type I2C_STATE_TYPE is (I2C_SET_ST, I2C_REQ_ST, I2C_WAIT_ST, I2C_END_ST);
  signal i2c_cont  : I2C_STATE_TYPE := I2C_SET_ST;
  
  signal i2c_req      : std_logic;
  signal i2c_busy     : std_logic;
  signal i2c_mode     : std_logic_vector(7 downto 0);
  signal i2c_addr     : std_logic_vector(15 downto 0);
  signal i2c_wdata    : std_logic_vector(31 downto 0);
  signal i2c_rdata    : std_logic_vector(31 downto 0);
  signal i2c_saddr    : std_logic_vector(7 downto 0);
  signal i2c_dlen     : std_logic_vector(1 downto 0);
  signal set_count    : std_logic_vector(7 downto 0);

begin

  iBMEM: sccb_bmem
  port map(
    ADDRA      => bmem_addr,
    DOUTA      => bmem_rdata,
    CLKA       => pClk
  );
  
  
  iI2CIF: i2c_iface
  generic map(
    CLK_PRESCALE => 8000
  )
  port map(
    clk         => pClk,        --<
    reset       => pReset,      --<
    --------
    sic         => I2CIO_SIC,   -->
    sid_i       => I2CIO_SID_I, --<
    sid_o       => I2CIO_SID_O, 
    sid_dir     => I2CIO_SID_D, 
    --------
    req         => i2c_req,     --<
    busy        => i2c_busy,    -->
    addr        => i2c_addr,    --<
    data_in     => i2c_wdata,   --<
    data_out    => i2c_rdata,   -->
    mode        => i2c_mode,    --<
    data_length => i2c_dlen,    --<
    slave_addr  => i2c_saddr,   --<
    --------
    debug       => open
  );


  I2CIO_BUSY <= i2c_busy;

  process (pClk)
  begin
    if pClk'event and pClk = '1' then
      if pReset = '1' then
        state        <= INIT_IDLE_ST;
        
        init_done    <= '0';
        init_err     <= '0';
        set_addr     <= (others=>'0');
        set_data     <= (others=>'0');
        time_cnt     <= (others=>'0');
        ------
        i2c_req   <= '0';
        i2c_addr  <= (others=>'0');
        i2c_wdata <= (others=>'0');
        i2c_mode  <= (others=>'0');
        i2c_dlen  <= (others=>'0');
        i2c_cont  <= I2C_SET_ST;
        debug <= X"01";
      else
        case state is
          ------------------------------------------------
          ---
          ------------------------------------------------
          when INIT_IDLE_ST =>
            if(init_req='1') then
              state          <= READ_SET_ST;
              case set_mode is
                when "00"   => bmem_addr <= conv_std_logic_vector(0,bmem_addr'length);
                when "01"   => bmem_addr <= conv_std_logic_vector(0,bmem_addr'length);
                when "10"   => bmem_addr <= conv_std_logic_vector(0,bmem_addr'length);
                when "11"   => bmem_addr <= conv_std_logic_vector(0,bmem_addr'length);
                when others => bmem_addr <= conv_std_logic_vector(0,bmem_addr'length);
              end case;
            end if;
            debug <= X"02";
          ------------------------------------------------
          ---
          ------------------------------------------------
          when READ_SET_ST =>
            case bmem_cont is
              when BMEM_ADDRSET_ST =>
                 bmem_cont <= BMEM_WAIT1_ST;
                 bmem_addr <= bmem_addr;
              when BMEM_WAIT1_ST =>
                 bmem_cont <= BMEM_READ_ST;
              when BMEM_READ_ST =>
                 bmem_cont <= BMEM_END_ST;
                 set_addr  <= bmem_rdata(31 downto 16);
                 set_data  <= bmem_rdata(15 downto 8);
                 set_i2cmode  <= bmem_rdata(0);
--                  set_addr  <= bmem_rdata(15 downto 8);
--                  set_data  <= bmem_rdata(7 downto 0);
              when BMEM_END_ST =>
                 if(bmem_rdata=X"FFFFFFFF") then
                   state     <= INIT_END_ST;
                 elsif(bmem_rdata(31 downto 16)=X"FFFF" and 
                       bmem_rdata(15 downto 8)/=X"FF"
                 ) then
                   state      <= SET_REG_WAIT_ST;
                 else
                   if(bmem_addr="111111111") then
                    state     <= INIT_IDLE_ST;
                   else
                    state     <= SET_REG_ST;
                   end if;
                 end if;
                 bmem_cont <= BMEM_ADDRSET_ST;
                 bmem_addr <= bmem_addr+1;
              when others =>
                 bmem_cont <= BMEM_ADDRSET_ST;
            end case;
            debug <= X"03";
          ------------------------------------------------
          --- 設定のインターバルを作る
          ------------------------------------------------
          when SET_REG_WAIT_ST =>
             if(time_1ms='1') then
               time_cnt <= time_cnt + 1;
               if(conv_integer(time_cnt)=conv_integer((set_data&X"000"))) then
                 state    <= READ_SET_ST;
                 time_cnt <= (others=>'0');
               end if;
             end if;
            debug <= X"04";
          ------------------------------------------------
          --- I2Cの設定動作
          ------------------------------------------------
          when SET_REG_ST =>
            case i2c_cont is
              when I2C_SET_ST =>
                 i2c_req   <= '0';
                 i2c_mode  <= "0000010" & set_i2cmode;
                 i2c_addr  <= set_addr(7 downto 0) & set_addr(15 downto 8);
                 i2c_wdata <= set_data & X"000000";
                 i2c_saddr <= DEV_I2C_SADDR;
                 i2c_cont  <= I2C_REQ_ST;
              when I2C_REQ_ST =>
                 i2c_req  <= '1';
                 if(i2c_busy = '1' ) then
                   i2c_cont <= I2C_WAIT_ST;
                 end if;
              when I2C_WAIT_ST =>
                 i2c_req  <= '0';
                 if(i2c_busy='0') then
                   i2c_cont <= I2C_END_ST;
                 end if;
              when I2C_END_ST =>
--                 state    <= READ_SET_ST;
                 state    <= SET_REG_WAIT_ST;
                 set_data <= X"10";
                 i2c_cont <= I2C_SET_ST;
              when others =>
                 i2c_cont <= I2C_SET_ST;
            end case;
            debug <= X"05";
          ------------------------------------------------
          ---
          ------------------------------------------------
          when INIT_END_ST =>
            init_done  <= '1';
--            state      <= USER_MODE_IDLE_ST;
            debug <= X"06";
          ------------------------------------------------
          ---
          ------------------------------------------------
          when INIT_ERR_ST =>
            init_err   <= '1';
            debug <= X"07";
          ------------------------------------------------
          ---
          ------------------------------------------------
          when others =>
            state    <= INIT_IDLE_ST;
            init_err <= '1';
            debug <= X"08";
        end case;
      end if;
    end if;
  end process;

end RTL;

