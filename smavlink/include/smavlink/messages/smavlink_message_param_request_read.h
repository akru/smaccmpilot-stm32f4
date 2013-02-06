/* This file has been autogenerated by Ivory
 * Compiler version  0.1.0.0
 */
#ifndef __SMAVLINK_MESSAGE_PARAM_REQUEST_READ_H__
#define __SMAVLINK_MESSAGE_PARAM_REQUEST_READ_H__
#ifdef __cplusplus
extern "C" {
#endif
#include <ivory.h>
#include <smavlink/channel.h>
#include <smavlink/system.h>
#include "smavlink_pack_ivory.h"
struct param_request_read_msg {
    int16_t param_index;
    uint8_t target_system;
    uint8_t target_component;
    uint8_t param_id[16U];
};
void smavlink_send_param_request_read(struct param_request_read_msg* n_var0,
                                      struct smavlink_out_channel* n_var1,
                                      struct smavlink_system* n_var2);
void smavlink_unpack_param_request_read(struct param_request_read_msg* n_var0,
                                        const uint8_t** n_var1);

#ifdef __cplusplus
}
#endif
#endif /* __SMAVLINK_MESSAGE_PARAM_REQUEST_READ_H__ */