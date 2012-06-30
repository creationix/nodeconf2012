/* uvffi.h */
enum { MAX_TITLE_LENGTH = 8192 }
struct uv_err_s { int code; int sys_errno_; };
typedef struct uv_err_s uv_err_t;
uv_err_t uv_get_process_title(char* buffer, size_t size);
uv_err_t uv_set_process_title(const char* title);
const char* uv_strerror(uv_err_t err);
const char* uv_err_name(uv_err_t err);
