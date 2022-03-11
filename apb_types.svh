typedef enum {
  DATA_WIDTH_8 = 8,
  DATA_WIDTH_16 = 16,
  DATA_WIDTH_32 = 32
} data_width_t;

typedef enum {
  WRITE,
  READ,
  WAKEUP,
  DELAY,
  RESET
} apb_operation_t;

typedef enum bit {
  PWRITE_READ = 0,
  PWRITE_WRITE = 1
} pwrite_t;

typedef enum bit {
  PSELX_DISABLE = 0,
  PSELX_ENABLE = 1
} pselx_t;

typedef enum bit {
  PENABLE_DISABLE = 0,
  PENABLE_ENABLE = 1
} penable_t;

typedef enum bit {
  PREADY_NOT_READY = 0,
  PREADY_READY = 1
} pready_t;

typedef enum bit {
  PSLVERR_NO_ERROR = 0,
  PSLVERR_ERROR = 1
} pslverr_t;

typedef enum bit {
  PWAKEUP_NO_WAKEUP = 0,
  PWAKEUP_WAKEUP = 1
} pwakeup_t;

typedef enum bit {
  PPROT_NORMAL = 0,
  PPROT_PRIVILEGED = 1
} pprot_normal_privileged_t;

typedef enum bit {
  PPROT_SECURE = 0,
  PPROT_NON_SECURE = 1
} pprot_secure_non_secure_t;

typedef enum bit {
  PPROT_DATA = 0,
  PPROT_INSTRUCTION = 1
} pprot_data_instruction_t;

typedef enum {
  BEFORE_PSELX_ASSERTION,
  DURING_PSELX_ASSERTION,
  AFTER_PSELX_ASSERTION
} wakeup_assertion_timing_t;
