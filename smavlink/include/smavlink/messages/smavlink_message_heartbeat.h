/* This file has been autogenerated by Ivory
 * Compiler version  0.1.0.0
 */
#ifndef __SMAVLINK_MESSAGE_HEARTBEAT_H__
#define __SMAVLINK_MESSAGE_HEARTBEAT_H__
#ifdef __cplusplus
extern "C" {
#endif
#include <ivory.h>
#include <smavlink/channel.h>
#include <smavlink/system.h>
#include "smavlink_pack_ivory.h"
struct heartbeat_msg {
    uint32_t custom_mode;
    uint8_t mavtype;
    uint8_t autopilot;
    uint8_t base_mode;
    uint8_t system_status;
    uint8_t mavlink_version;
};
void smavlink_send_heartbeat(struct heartbeat_msg* n_var0,
                             struct smavlink_out_channel* n_var1,
                             struct smavlink_system* n_var2);
void smavlink_unpack_heartbeat(struct heartbeat_msg* n_var0, const
                               uint8_t* n_var1);

#ifdef __cplusplus
}
#endif
#endif /* __SMAVLINK_MESSAGE_HEARTBEAT_H__ */