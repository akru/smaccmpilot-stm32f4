/* This file has been autogenerated by Ivory
 * Compiler version  Version {versionBranch = [0,1,0,0], versionTags = []}
 */
#ifndef __SMAVLINK_MESSAGE_SETPOINT_6DOF_H__
#define __SMAVLINK_MESSAGE_SETPOINT_6DOF_H__
#ifdef __cplusplus
extern "C" {
#endif
#include <ivory.h>
#include <smavlink/channel.h>
#include <smavlink/system.h>
struct setpoint_6dof_msg {
    float trans_x;
    float trans_y;
    float trans_z;
    float rot_x;
    float rot_y;
    float rot_z;
    uint8_t target_system;
};
void smavlink_send_setpoint_6dof(struct setpoint_6dof_msg* n_var0,
                                 struct smavlink_out_channel* n_var1,
                                 struct smavlink_system* n_var2);
void smavlink_unpack_setpoint_6dof(struct setpoint_6dof_msg* n_var0, const
                                   uint8_t** n_var1);

#ifdef __cplusplus
}
#endif
#endif /* __SMAVLINK_MESSAGE_SETPOINT_6DOF_H__ */