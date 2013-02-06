/* This file has been autogenerated by Ivory
 * Compiler version  0.1.0.0
 */
#ifndef __SMAVLINK_MESSAGE_SET_LOCAL_POSITION_SETPOINT_H__
#define __SMAVLINK_MESSAGE_SET_LOCAL_POSITION_SETPOINT_H__
#ifdef __cplusplus
extern "C" {
#endif
#include <ivory.h>
#include <smavlink/channel.h>
#include <smavlink/system.h>
#include "smavlink_pack_ivory.h"
struct set_local_position_setpoint_msg {
    float x;
    float y;
    float z;
    float yaw;
    uint8_t target_system;
    uint8_t target_component;
    uint8_t coordinate_frame;
};
void smavlink_send_set_local_position_setpoint(struct set_local_position_setpoint_msg* n_var0,
                                               struct smavlink_out_channel* n_var1,
                                               struct smavlink_system* n_var2);
void smavlink_unpack_set_local_position_setpoint(struct set_local_position_setpoint_msg* n_var0,
                                                 const uint8_t** n_var1);

#ifdef __cplusplus
}
#endif
#endif /* __SMAVLINK_MESSAGE_SET_LOCAL_POSITION_SETPOINT_H__ */