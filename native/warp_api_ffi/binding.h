typedef char int8_t;
typedef long long int int64_t;
typedef long long int uint64_t;
typedef long long int uintptr_t;
typedef long int uint32_t;
typedef char bool;
typedef void *DartPostCObjectFnType;

void init_wallet(char *db_path);

void warp_sync(int64_t port);

void dart_post_cobject(DartPostCObjectFnType ptr);

uint32_t get_latest_height(void);

bool is_valid_key(char *seed);

bool valid_address(char *address);

void set_mempool_account(uint32_t account);

uint32_t new_account(char *name, char *data);

int64_t get_mempool_balance(void);

const char *send_payment(uint32_t account, char *address, uint64_t amount);

int8_t try_warp_sync(void);

void skip_to_last_height(void);

void rewind_to_height(uint32_t height);

int64_t mempool_sync(void);
