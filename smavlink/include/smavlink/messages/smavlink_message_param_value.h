/* This file has been autogenerated by Ivory
 * Compiler version  0.1.0.0
 */
#ifndef __SMAVLINK_MESSAGE_PARAM_VALUE_H__
#define __SMAVLINK_MESSAGE_PARAM_VALUE_H__
#ifdef __cplusplus
extern "C" {
#endif
#include <ivory.h>
#include <smavlink/channel.h>
#include <smavlink/system.h>
#include "smavlink_pack_ivory.h"
struct param_value_msg {
    float param_value;
    uint16_t param_count;
    uint16_t param_index;
    uint8_t param_type;
    uint8_t param_id[16U];
};
void smavlink_send_param_value(struct param_value_msg* n_var0,
                               struct smavlink_out_channel* n_var1,
                               struct smavlink_system* n_var2);
void smavlink_unpack_param_value(struct param_value_msg* n_var0, const
                                 uint8_t** n_var1);

#ifdef __cplusplus
}
#endif
#endif /* __SMAVLINK_MESSAGE_PARAM_VALUE_H__ */