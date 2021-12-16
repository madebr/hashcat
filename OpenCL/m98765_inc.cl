/**
 * Author......: See docs/credits.txt
 * License.....: MIT
 */

#include "inc_vendor.h"
#include "inc_types.h"
#include "inc_platform.h"
#include "inc_common.h"
#include "m98765_inc.h"

#define C_INIT(s, c0, c1)                     \
{                                             \
  s = 0;                                      \
  c0 = 0;                                     \
  c1 = 0;                                     \
}

#define C_STEP_C(s, c0, c1, d, tmp)           \
{                                             \
  tmp = d - 'a' + 22;                         \
  s += tmp;                                   \
  c0 += (tmp << 11);                          \
  c0 = (c0 >> 17) + (c0 << 4);                \
  c1 = (c1 >> 29) + (c1 << 3) + (tmp * tmp);  \
}

#define C_STEP_W(s, c0, c1, d, tmp)           \
{                                             \
  tmp = d - 'a' + 22;                         \
  s += tmp;                                   \
  c0 += (tmp << 11);                          \
  c0 = (c0 >> 17) + (c0 << 4);                \
  c1 = (c1 >> 29) + (c1 << 3) + (tmp * tmp);  \
}

#define C_FINAL(h0, h1, s, c0, c1)            \
{                                             \
  h0 = (c0 >> 11) + (s << 21);                \
  h1 = c1;                                    \
}

DECLSPEC void c_init (c_ctx_t *ctx)
{
  C_INIT(ctx->s, ctx->c[0], ctx->c[1]);
}

DECLSPEC void c_update_c (c_ctx_t *ctx, u32 c)
{
  u32 s = ctx->s;
  u32 c0 = ctx->c[0];
  u32 c1 = ctx->c[1];
  u32 tmp;
  C_STEP_C(s, c0, c1, c, tmp);
  ctx->s = s;
  ctx->c[0] = c0;
  ctx->c[1] = c1;
}

DECLSPEC void c_update (c_ctx_t *ctx, const u32 *w, const int len)
{
  for (int pos = 3, i = 0; pos < len; pos += 4, i += 1) {
    c_update_c(ctx, (w[i] >> 0) & 0xff);
    c_update_c(ctx, (w[i] >> 8) & 0xff);
    c_update_c(ctx, (w[i] >> 16) & 0xff);
    c_update_c(ctx, (w[i] >> 24) & 0xff);
  }

  if (len % 4 > 0) {
    c_update_c(ctx, (w[len / 4] >> 0) & 0xff);
  }
  if (len % 4 > 1) {
    c_update_c(ctx, (w[len / 4] >> 8) & 0xff);
  }
  if (len % 4 > 2) {
    c_update_c(ctx, (w[len / 4] >> 16) & 0xff);
  }
}

DECLSPEC void c_update_global (c_ctx_t *ctx, GLOBAL_AS const u32 *w, const int len) {
  for (int pos = 3, i = 0; pos < len; pos += 4, i += 1) {
    c_update_c(ctx, (w[i] >> 0) & 0xff);
    c_update_c(ctx, (w[i] >> 8) & 0xff);
    c_update_c(ctx, (w[i] >> 16) & 0xff);
    c_update_c(ctx, (w[i] >> 24) & 0xff);
  }

  if (len % 4 > 0) {
    c_update_c(ctx, (w[len / 4] >> 0) & 0xff);
  }
  if (len % 4 > 1) {
    c_update_c(ctx, (w[len / 4] >> 8) & 0xff);
  }
  if (len % 4 > 2) {
    c_update_c(ctx, (w[len / 4] >> 16) & 0xff);
  }
}

DECLSPEC void c_final (c_ctx_t *ctx)
{
  C_FINAL(ctx->h[0], ctx->h[1], ctx->s, ctx->c[0], ctx->c[1]);
}

DECLSPEC void c_init_vector (c_ctx_vector_t *ctx)
{
  C_INIT(ctx->s, ctx->c[0], ctx->c[1]);
}

DECLSPEC void c_update_c_vector (c_ctx_vector_t *ctx, u32x c)
{
  u32x s = ctx->s;
  u32x c0 = ctx->c[0];
  u32x c1 = ctx->c[1];
  u32x tmp;
  C_STEP_C(s, c0, c1, c, tmp);
  ctx->s = s;
  ctx->c[0] = c0;
  ctx->c[1] = c1;
}

DECLSPEC void c_update_vector (c_ctx_vector_t *ctx, const u32x *w, const int len)
{
  for (int pos = 3, i = 0; pos < len; pos += 4, i += 1) {
    c_update_c_vector(ctx, (w[i] >> 0) & 0xff);
    c_update_c_vector(ctx, (w[i] >> 8) & 0xff);
    c_update_c_vector(ctx, (w[i] >> 16) & 0xff);
    c_update_c_vector(ctx, (w[i] >> 24) & 0xff);
  }

  if (len % 4 > 0) {
    c_update_c_vector(ctx, (w[len / 4] >> 0) & 0xff);
  }
  if (len % 4 > 1) {
    c_update_c_vector(ctx, (w[len / 4] >> 8) & 0xff);
  }
  if (len % 4 > 2) {
    c_update_c_vector(ctx, (w[len / 4] >> 16) & 0xff);
  }
}

DECLSPEC void c_final_vector (c_ctx_vector_t *ctx)
{
  C_FINAL(ctx->h[0], ctx->h[1], ctx->s, ctx->c[0], ctx->c[1]);
}
