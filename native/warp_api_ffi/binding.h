#ifndef __APPLE__
typedef char int8_t;
typedef unsigned char uint8_t;
typedef short int uint16_t;
typedef long long int int64_t;
typedef long long int uint64_t;
typedef long long int uintptr_t;
typedef long int int32_t;
typedef long int uint32_t;
typedef char bool;
#endif
typedef void *DartPostCObjectFnType;

void init_wallet(char *db_path);

void reset_app(void);

int8_t warp_sync(uint8_t coin, bool get_tx, uint32_t anchor_offset, int64_t port);

void dart_post_cobject(DartPostCObjectFnType ptr);

uint32_t get_latest_height(uint8_t coin);

int8_t is_valid_key(uint8_t coin, char *seed);

bool valid_address(uint8_t coin, char *address);

char *new_address(uint8_t coin, uint32_t account);

void set_mempool_account(uint8_t coin, uint32_t account);

int32_t new_account(uint8_t coin, char *name, char *data, uint32_t index);

int32_t new_sub_account(uint8_t coin, uint32_t id, char *name);

int64_t get_mempool_balance(uint8_t coin);

const char *send_multi_payment(uint8_t coin,
                               uint32_t account,
                               char *recipients_json,
                               uint32_t anchor_offset,
                               bool use_transparent,
                               int64_t port);

void skip_to_last_height(uint8_t coin);

void rewind_to_height(uint8_t coin, uint32_t height);

int64_t mempool_sync(uint8_t coin);

void mempool_reset(uint8_t coin, uint32_t height);

uint64_t get_taddr_balance(uint8_t coin, uint32_t account);

char *shield_taddr(uint8_t coin, uint32_t account);

void set_lwd_url(uint8_t coin, char *url);

char *prepare_multi_payment(uint8_t coin,
                            uint32_t account,
                            char *recipients_json,
                            bool use_transparent,
                            uint32_t anchor_offset);

char *broadcast(uint8_t coin, char *tx_filename);

char *broadcast_txhex(uint8_t coin, char *txhex);

uint32_t sync_historical_prices(uint8_t coin, int64_t now, uint32_t days, char *currency);

char *get_ua(char *sapling_addr, char *transparent_addr);

char *get_sapling(char *ua_addr);

void store_contact(uint8_t coin, uint32_t id, char *name, char *address, bool dirty);

char *commit_unsaved_contacts(uint8_t coin, uint32_t account, uint32_t anchor_offset);

void delete_account(uint8_t coin, uint32_t account);

void truncate_data(uint8_t coin);

char *make_payment_uri(uint8_t coin, char *address, uint64_t amount, char *memo);

char *parse_payment_uri(uint8_t coin, char *uri);

char *generate_random_enc_key(void);

char *get_full_backup(char *key);

char *restore_full_backup(char *key, char *backup);

void store_share_secret(uint8_t coin, uint32_t account, char *secret);

char *get_share_secret(uint8_t coin, uint32_t account);

void run_aggregator(char *secret_share, uint16_t port, int64_t send_port);

void shutdown_aggregator(void);

char *submit_multisig_tx(char *tx_json, uint16_t port);

uint32_t run_multi_signer(char *address,
                          uint64_t amount,
                          char *secret_share,
                          char *aggregator_url,
                          char *my_url,
                          uint16_t port);

char *split_account(uint8_t coin, uint32_t threshold, uint32_t participants, uint32_t account);

void dummy_export(void);
