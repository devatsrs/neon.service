namespace py thrift
namespace go ssp_thrift_gen

/* The following values must be negative but thrift doesn't allow negative values in enums */
enum CallError {
    NO_ERROR                    = 0
    EXTERNAL_TRANSLATOR_REJECT  = 1
    BODY_LESS_INVITE            = 2
    ACCOUNT_EXPIRED             = 3
    CONNECTION_CAPACITY_EXCEEDED= 4
    MALFORMED_SDP               = 5
    UNSUPPORTED_CONTENT_TYPE    = 6
    UNACCEPTABLE_CODEC          = 7
    INVALID_AUTH_CLD_TRANS_RULE = 8
    INVALID_AUTH_CLI_TRANS_RULE = 9
    INVALID_ACNT_CLD_TRANS_RULE = 10
    INVALID_ACNT_CLI_TRANS_RULE = 11
    CANNOT_BIND_SESSION         = 12
    INVALID_DID_CLI_TRANS_RULE  = 13
    NO_RATE_FOUND               = 14
    CALL_LOOP_DETECTED          = 15
    TOO_MANY_SESSIONS           = 16
    ACCOUNT_IN_USE              = 17
    HIGH_CALL_RATE_PER_ACCOUNT  = 18
    HIGH_CALL_RATE              = 19
    INSUFFICIENT_BALANCE        = 20
    FORBIDDEN_DESTINATION       = 21
    NO_CUSTOMER_RATES           = 22
    LOSS_PROTECTION             = 23
    ADDRESS_INCOMPLETE          = 24
    NO_ROUTES                   = 25
    HIGH_CALL_RATE_PER_CONNECTION = 26
    INVALID_ASSRT_ID_CLI_TRANS_RULE = 27
    DNCL_BLOCKED                = 28
}

struct NullInt64 {
    1:i64 v,
}

struct NullString {
    1:string s,
}

struct UnixTime {
    1:i64 seconds,
    2:i64 nanoseconds
}

struct MonoTime {
    1:UnixTime monot,
    2:UnixTime realt
}

enum TransactionRecordType
{
    CALLS                   = 1,
    CDRS                    = 2,
    CDRS_CONNECTIONS        = 3,
    CDRS_CUSTOMERS          = 4,
    CDRS_DIDS               = 5,
    CDRS_CONNECTIONS_DIDS   = 6,
    SURCHARGES              = 7,
    COMMISSIONS             = 8,
    UPDATE_ACCOUNT_BALANCE  = 9,
    UPDATE_CUSTOMER_BALANCE = 10,
    UPDATE_VENDOR_BALANCE   = 11,
    UPDATE_PLAN_MINUTES     = 12,
    QUALITY_STATS           = 13,
    CALLS_SDP               = 14,
    CDRS_CUSTOMERS_DIDS     = 15,
}

struct TransactionRecord
{
    1: TransactionRecordType type,
    2: string data // thrift encoded record (Cdrs, UpdateAccountBalanceMessage, etc)
}

struct Transaction
{
    1: list<TransactionRecord> records
}

struct Calls
{
    1: i64 i_call,
    2: string call_id,
    3: string cld,
    4: string cli,
    5: i64 setup_time,
    6: NullInt64 parent_i_call,
    7: NullInt64 i_call_type
}

struct Cdrs
{
    1: i64 i_cdr,
    2: i64 i_call,
    3: i64 i_account,
    4: i64 result,
    5: double cost,
    6: double delay,
    7: double duration,
    8: double billed_duration,
    9: i64 connect_time,
    10: i64 disconnect_time,
    11: string cld_in,
    12: string cli_in,
    13: string prefix,
    14: double price_1,
    15: double price_n,
    16: i32 interval_1,
    17: i32 interval_n,
    18: double post_call_surcharge,
    19: double connect_fee,
    20: i64 free_seconds,
    21: string remote_ip,
    22: i32 grace_period,
    23: string user_agent,
    24: double pdd1xx,
    25: i16 i_protocol,
    26: string release_source,
    27: double plan_duration,
    28: double accessibility_cost,
    29: NullString lrn_cld,
    30: NullString lrn_cld_in,
    31: NullString area_name,
    32: NullString p_asserted_id,
    33: NullString remote_party_id,
}

struct CdrsConnections
{
    1: i64 i_cdrs_connection,
    2: i64 i_call,
    3: i64 i_connection,
    4: i32 result,
    5: double cost,
    6: double delay,
    7: double duration,
    8: double billed_duration,
    9: i64 setup_time,
    10: i64 connect_time,
    11: i64 disconnect_time,
    12: string cld_out,
    13: string cli_out,
    14: string prefix,
    15: double price_1,
    16: double price_n,
    17: i32 interval_1,
    18: i32 interval_n,
    19: double post_call_surcharge,
    20: double connect_fee,
    21: i32 free_seconds,
    22: i32 grace_period,
    23: string user_agent,
    24: double pdd100,
    25: double pdd1xx,
    26: i64 i_account_debug,
    27: i32 i_protocol,
    28: string release_source,
    29: i64 call_setup_time,
    30: NullString lrn_cld,
    31: NullString area_name,
    32: NullInt64 i_media_relay,
    33: NullString remote_ip,
    34: NullString vendor_name,
}

struct CdrsCustomers
{
    1: i64 i_cdrs_customer
    2: i64 i_cdr
    3: i64 i_customer
    4: double cost
    5: double billed_duration
    6: string prefix
    7: double price_1
    8: double price_n
    9: i32 interval_1
    10: i32 interval_n
    11: double post_call_surcharge
    12: double connect_fee
    13: i32 free_seconds
    14: i32 grace_period
    15: i64 i_call
    16: i64 i_wholesaler
    17: i64 setup_time
    18: double duration
    19: NullString area_name
}

struct CdrsDids
{
    1: i64 i_cdrs_did,
    2: i64 i_call,
    3: i64 i_did,
    4: string did,
    5: i32 result,
    6: double cost,
    7: double duration,
    8: double billed_duration,
    9: i64 setup_time,
    10: i64 connect_time,
    11: i64 disconnect_time,
    12: double price_1,
    13: double price_n,
    14: i32 interval_1,
    15: i32 interval_n,
    16: double post_call_surcharge,
    17: double connect_fee,
    18: i32 free_seconds,
    19: i32 grace_period
}

struct CdrsConnectionsDids
{
    1: i64 i_cdrs_connections_did,
    2: i64 i_call,
    3: i64 i_did_authorization,
    4: string did,
    5: string incoming_did,
    6: i64 i_connection,
    7: i32 result,
    8: double cost,
    9: double duration,
    10: double billed_duration,
    11: i64 setup_time,
    12: i64 connect_time,
    13: i64 disconnect_time,
    14: double price_1,
    15: double price_n,
    16: i32 interval_1,
    17: i32 interval_n,
    18: double post_call_surcharge,
    19: double connect_fee,
    20: i32 free_seconds,
    21: i32 grace_period,
}

struct Surcharges
{
    1: i64 i_surcharge,
    2: i64 i_call,
    3: double cost,
    4: i64 i_surcharge_type
}

struct Commissions
{
    1: i64 i_commission,
    2: NullInt64 i_account,
    3: NullInt64 i_customer,
    4: i64 i_cdrs_customer,
    5: double commission_size,
    6: i64 setup_time,
    7: i64 i_call
}

struct CallsSdp
{
    1: i64 i_calls_sdp,
    2: i64 i_call,
    3: NullInt64 i_cdrs_connection,
    4: UnixTime time_stamp,
    5: string sdp,
    6: string sip_msg_type
}

struct CdrsCustomersDids
{
    1: i64 i_cdrs_customers_did,
    2: i64 i_call,
    3: i64 i_customer,
    4: i64 i_did,
    5: string did,
    6: i32 result,
    7: double cost,
    8: double duration,
    9: double billed_duration,
    10: i64 setup_time,
    11: i64 connect_time,
    12: i64 disconnect_time,
    13: double price_1,
    14: double price_n,
    15: i32 interval_1,
    16: i32 interval_n,
    17: double post_call_surcharge,
    18: double connect_fee,
    19: i32 free_seconds,
    20: i32 grace_period,
}

struct UpdateAccountBalanceMessage
{
    1: i64 i_account,
    2: double delta
}

struct UpdateCustomerBalanceMessage
{
    1: i64 i_customer,
    2: double delta
}

struct UpdateVendorBalanceMessage
{
    1: i64 i_vendor,
    2: double delta
    3: i64 i_connection
}

struct UpdatePlanMinutesMessage
{
    1: i64 i_account,
    2: i64 i_service_plan,
    3: double delta,
    4: double chargeable_seconds
}

struct ConnectionQualityStats {
    1: i64 i_connection_quality_stats,
    2: i64 i_connection,
    3: i64 tstamp,
    4: double asr,
    5: i32 acd,
    6: string action
}

exception RegisterError {
    1:CallError cause, // The returned value is in fact negative
    2:i64       i_call,
}

exception TryBackupError {
}

exception EagainError {
}

struct Billables {
    1:i64       free_seconds,
    2:double    connect_fee,
    3:double    price_1,
    4:double    price_n,
    5:i32       interval_1,
    6:i32       interval_n,
    7:double    post_call_surcharge,
    8:i32       grace_period,
    9:string    prefix, // this is incoming_did in DidBillables
    10:i32      decimal_precision,
    11:bool     cost_round_up,
}

struct AccountBillables {
    1:Billables bparams,
    2:NullString area_name,
    3:NullInt64 i_commission_agent,
    4:double    commission_size,
    5:i64       i_wholesaler,
    6:double    fresh_balance,
    7:bool      plan_only,
}

struct CustomerBillables {
    1:Billables bparams,
    2:NullString area_name,
    3:NullInt64 i_commission_agent,
    4:double    commission_size,
    5:i64       i_customer,
    6:i64       i_wholesaler,
}

struct DidBillables {
    1:Billables bparams,
    2:i64       i_did,
    3:string    did,
}

struct BuyingDidBillables {
    1:Billables bparams,
    2:string    did,
    3:i64       i_connection,
    4:i64       i_did_authorization,
}

struct CustomerDidBillables {
    1:Billables bparams,
    2:string    did,
    3:i64       i_customer,
    4:i64       i_did,
}

struct CreditTimes {
    1:MonoTime  crtime_acct,
    2:MonoTime  crtime_ext,
    3:MonoTime  rtime,
}

struct Duration {
    1:i64   nanoseconds,
}

struct Tariff {
    1:double        post_call_surcharge,
    2:double        connect_fee,
    3:NullString    name,
    4:i64           i_tariff,
    5:i32           free_seconds,
    6:i64           i_owner,
    7:string        iso_4217,
    8:i32           grace_period,
    9:double        max_loss,
    10:i32          average_duration,
    11:bool         loss_protection,
    12:bool         local_calling,
    13:string       local_calling_cli_validation_rule,
    14:i64          last_change_count,
    15:NullString   local_id,
    16:NullString   remote_id,
    17:bool         is_remote,
    18:bool         is_exportable,
    19:i32          decimal_precision,
    20:bool         cost_round_up,
}

struct TariffRate {
    1:i64           i_rate,
    2:string        prefix,
    3:i64           i_tariff,
    4:double        price_1,
    5:double        price_n,
    6:i32           interval_1,
    7:i32           interval_n,
    8:bool          forbidden,
    9:bool          grace_period_enable,
    10:double       local_price_1,
    11:double       local_price_n,
    12:i32          local_interval_1,
    13:i32          local_interval_n,
    14:NullString   area_name,
    15:UnixTime     activation_date,
    16:UnixTime     expiration_date,
}

struct TariffRateList {
    1:list<TariffRate> arr
}

/* The cache record for a local prefix */
struct LocalTariffRate {
    1:UnixTime  activation_date,
    2:UnixTime  expiration_date,
}

struct LocalTariffRateList {
    1:list<LocalTariffRate> arr
}

struct LookupbparamResultEntry {
    1:i32 free_seconds,
    2:double connect_fee,
    3:double price_1,
    4:double price_n,
    5:i32 interval_1,
    6:i32 interval_n,
    7:double post_call_surcharge,
    8:i32 grace_period,
    9:bool forbidden,
    10:i32 average_duration,
    11:bool loss_protection,
    12:double max_loss,
    13:string prefix,
    14:bool plan_only,
    15:NullString area_name
}

struct LookupbparamResult {
    1:list<LookupbparamResultEntry> bparams,
    2:i32   decimal_precision,
    3:bool  cost_round_up,
}

service B2BUA {
    oneway void crtime_adj(1:i64 i_environment, 2:string sess_id, 3:CreditTimes credit_times)
}

service RatingManager {
    LookupbparamResult lookupbparam(
            1:list<list<string>> clds,
            2:bool is_onnet,
            3:i64 i_tariff,
            4:NullInt64 i_billing_plan
        )
}
    
service SessionTracker {
    i64 next_i_call(),
    i64 current_i_call(),
    i64 next_i_cdrs_connection(),
    oneway void b2bua_stopped(1:string b2bua_id, 2:MonoTime rtime),

    void register_b2bua(1:string b2bua_id, 2:string uri, 3:i32 pid),

    oneway void call_error(
            1:NullInt64 parent_i_call,
            2:i64 i_account,
            3:string cli,
            4:string cld,
            5:double cost,
            6:string call_id,
            7:MonoTime setup_ts,
            8:string remote_ip, 
            9:string cli_orig,
            10:string cld_orig,
            11:string user_agent,
            12:i32 result,
            13:NullString lrn_cld_in,
            14:NullString lrn_cld,
            15:NullString p_asserted_id,
            16:NullInt64 i_call_type,
            17:BuyingDidBillables buying_dcg,
            18:NullString remote_party_id,
        ),

    i64 register_call(
            1:NullInt64 parent_i_call,
            2:i64       i_account,
            3:bool      disallow_loops,
            4:i32       acc_max_sessions,
            5:string    call_id,
            6:string    cld,
            7:string    cli,
            8:MonoTime  setup_ts,
            9:i64       i_billing_plan,
            10:bool     billing_plan_suspended,
            11:AccountBillables account_billables,
            12:Billables accessibility_billables,
            13:string   remote_ip,
            14:string   cli_orig,
            15:string   cld_orig,
            16:i16      i_protocol,
            17:string   user_agent,
            18:double   max_calls_per_second,
            19:double   translation_cost,
            21:DidBillables did_charging_group,
            22:bool     is_late_dcg,
            23:i64      average_duration,
            24:i64      max_credit_time,
            25:string   sess_id,
            26:bool     round_up,
            27:NullString p_asserted_id,
            28:NullInt64 i_call_type,
            29:NullString remote_party_id,
        ) throws (1:RegisterError register_error),

    void register_virtual(
            1:string    bind_session_id,
            2:i64       i_call,
            3:string    remote_ip,
            4:string    cli_orig,
            5:string    cld_orig,
            6:i16       i_protocol,
            7:string    user_agent,
            8:i64       i_account,
            9:i64       i_billing_plan,
            10:bool     billing_plan_suspended,
            11:string   cld,
            12:AccountBillables account_billables,
            13:Billables accessibility_billables,
            14:MonoTime rtime,
            15:double   translation_cost,
            16:i64      max_credit_time,
            17:string   sess_id,
            18:bool     round_up,
            19:NullString p_asserted_id,
            20:NullString remote_party_id,
        ) throws (1:RegisterError register_error),

    map<i64,list<i64>> stats_all(),
    list<i64> stats_total(),

    oneway void sess_started(
            1:string sess_id,
            2:MonoTime rtime,
            3:Duration crtime_ext,
            4:MonoTime p1xx_ts),

    oneway void write_cdr(
            1:i64 i_account,
            2:double duration,
            3:double delay,
            4:double pdd1xx,
            5:bool connected,
            6:AccountBillables account_billables,
            7:Billables accessibility_billables,
            8:list<CustomerBillables> customer_billables,
            9:MonoTime rtime,
            10:string origin,
            11:i32 result,
            12:i64 i_billing_plan,
            13:i64 i_call,
            14:string remote_ip,
            15:string cld,
            16:string cli_orig,
            17:string cld_orig,
            18:MonoTime setup_ts,
            19:string user_agent,
            20:i16 i_protocol,
            21:double translation_cost,
            22:DidBillables dcg,
            23:bool is_late_dcg,
            24:bool billing_plan_suspended,
            25:NullString lrn_cld_in,
            26:NullString lrn_cld,
            27:bool round_up,
            28:NullString p_asserted_id,
            29:BuyingDidBillables buying_dcg,
            30:NullString remote_party_id,
            31:list<CallsSdp> sdp_list,
            32:list<CustomerDidBillables> customer_dcgs),

    void sess_ended(
            1:string b2bua_id,
            2:string sess_id,
            3:list<CustomerBillables> customer_billables,
            4:double duration,
            5:double delay,
            6:double pdd1xx,
            7:bool connected,
            8:MonoTime rtime,
            9:string origin,
            10:i32 result,
            11:NullString lrn_cld_in,
            12:NullString lrn_cld,
            13:BuyingDidBillables buying_dcg,
            14:list<CallsSdp> sdp_list,
            15:list<CustomerDidBillables> customer_dcgs) throws (1:TryBackupError try_backup_error),

}
