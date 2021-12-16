/**
 * Author......: See docs/credits.txt
 * License.....: MIT
 */

#ifndef _M98765_INC_H
#define _M98765_INC_H

typedef struct c_ctx {
  u32 h[2];
  u32 s;
  u32 c[2];
} c_ctx_t;

typedef struct c_ctx_vector {
  u32x h[2];
  u32x s;
  u32x c[2];
} c_ctx_vector_t;

DECLSPEC void c_init (c_ctx_t *ctx);
DECLSPEC void c_update_c (c_ctx_t *ctx, u32 c);
DECLSPEC void c_update (c_ctx_t *ctx, const u32 *w, int len);
DECLSPEC void c_final (c_ctx_t *ctx);

DECLSPEC void c_init_vector (c_ctx_vector_t *ctx);
DECLSPEC void c_update_c_vector (c_ctx_vector_t *ctx, u32x c);
DECLSPEC void c_update_vector (c_ctx_vector_t *ctx, const u32x *w, int len);
DECLSPEC void c_final_vector (c_ctx_vector_t *ctx);

#endif
