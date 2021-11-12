#ifndef __APPLE__
typedef char int8_t;
typedef short int uint16_t;
typedef long long int int64_t;
typedef long long int uint64_t;
typedef long long int uintptr_t;
typedef long int int32_t;
typedef long int uint32_t;
typedef char bool;
#endif
typedef void *DartPostCObjectFnType;

void init_wallet(char *db_path, char *ld_url);

void warp_sync(bool get_tx, uint32_t anchor_offset, int64_t port);

void dart_post_cobject(DartPostCObjectFnType ptr);

uint32_t get_latest_height(void);

int8_t is_valid_key(char *seed);

bool valid_address(char *address);

char *new_address(uint32_t account);

void set_mempool_account(uint32_t account);

int32_t new_account(char *name, char *data);

int64_t get_mempool_balance(void);

const char *send_multi_payment(uint32_t account,
                               char *recipients_json,
                               uint32_t anchor_offset,
                               bool use_transparent,
                               int64_t port);

int8_t try_warp_sync(bool get_tx, uint32_t anchor_offset);

void skip_to_last_height(void);

void rewind_to_height(uint32_t height);

int64_t mempool_sync(void);

void mempool_reset(uint32_t height);

uint64_t get_taddr_balance(uint32_t account);

char *shield_taddr(uint32_t account);

void set_lwd_url(char *url);

char *prepare_multi_payment(uint32_t account,
                            char *recipients_json,
                            bool use_transparent,
                            uint32_t anchor_offset);

char *broadcast(char *tx_filename);

char *broadcast_txhex(char *txhex);

uint32_t sync_historical_prices(int64_t now, uint32_t days, char *currency);

char *get_ua(char *sapling_addr, char *transparent_addr);

char *get_sapling(char *ua_addr);

void store_contact(uint32_t id, char *name, char *address, bool dirty);

char *commit_unsaved_contacts(uint32_t account, uint32_t anchor_offset);

void delete_account(uint32_t account);

void truncate_data(void);

char *make_payment_uri(char *address, uint64_t amount, char *memo);

char *parse_payment_uri(char *uri);

void store_share_secret(uint32_t account, char *secret);

char *get_share_secret(uint32_t account);

void run_aggregator(char *secret_share, uint16_t port, int64_t send_port);

void shutdown_aggregator(void);

char *submit_multisig_tx(char *tx_json, uint16_t port);

uint32_t run_multi_signer(char *secret_share, char *aggregator_url, char *my_url, uint16_t port);

char *split_account(uint32_t threshold, uint32_t participants, uint32_t account);

void dummy_export(void);
