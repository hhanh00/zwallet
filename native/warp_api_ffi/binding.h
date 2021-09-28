#ifndef __APPLE__
typedef char int8_t;
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

bool is_valid_key(char *seed);

bool valid_address(char *address);

char *new_address(uint32_t account);

void set_mempool_account(uint32_t account);

int32_t new_account(char *name, char *data);

int64_t get_mempool_balance(void);

const char *send_payment(uint32_t account,
                         char *address,
                         uint64_t amount,
                         char *memo,
                         uint64_t max_amount_per_note,
                         uint32_t anchor_offset,
                         bool shield_transparent_balance,
                         int64_t port);

const char *send_multi_payment(uint32_t account,
                               char *recipients_json,
                               uint32_t anchor_offset,
                               int64_t port);

int8_t try_warp_sync(bool get_tx, uint32_t anchor_offset);

void skip_to_last_height(void);

void rewind_to_height(uint32_t height);

int64_t mempool_sync(void);

void mempool_reset(uint32_t height);

uint64_t get_taddr_balance(uint32_t account);

char *shield_taddr(uint32_t account);

void set_lwd_url(char *url);

char *prepare_offline_tx(uint32_t account,
                         char *to_address,
                         uint64_t amount,
                         char *memo,
                         uint64_t max_amount_per_note,
                         uint32_t anchor_offset,
                         char *tx_filename);

char *broadcast(char *tx_filename);

uint32_t sync_historical_prices(int64_t now, uint32_t days, char *currency);

char *get_ua(char *sapling_addr, char *transparent_addr);

char *get_sapling(char *ua_addr);

void store_contact(uint32_t id, char *name, char *address, bool dirty);

char *commit_unsaved_contacts(uint32_t account, uint32_t anchor_offset);

void delete_account(uint32_t account);

void truncate_data(void);

char *make_payment_uri(char *address, uint64_t amount, char *memo);

char *parse_payment_uri(char *uri);

void dummy_export(void);
