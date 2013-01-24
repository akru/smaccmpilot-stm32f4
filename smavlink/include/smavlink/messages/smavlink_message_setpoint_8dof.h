/* This file has been autogenerated by Ivory
 * Compiler version  Version {versionBranch = [0,1,0,0], versionTags = []}
 */
#ifndef __SMAVLINK_MESSAGE_SETPOINT_8DOF_H__
#define __SMAVLINK_MESSAGE_SETPOINT_8DOF_H__
#ifdef __cplusplus
extern "C" {
#endif
#include <ivory.h>
#include <smavlink/channel.h>
#include <smavlink/system.h>
struct setpoint_8dof_msg {
    float val1;
    float val2;
    float val3;
    float val4;
    float val5;
    float val6;
    float val7;
    float val8;
    uint8_t target_system;
};
void smavlink_send_setpoint_8dof(struct setpoint_8dof_msg* n_var0,
                                 struct smavlink_out_channel* n_var1,
                                 struct smavlink_system* n_var2);
void smavlink_unpack_setpoint_8dof(struct setpoint_8dof_msg* n_var0, const
                                   uint8_t** n_var1);

#ifdef __cplusplus
}
#endif
#endif /* __SMAVLINK_MESSAGE_SETPOINT_8DOF_H__ */