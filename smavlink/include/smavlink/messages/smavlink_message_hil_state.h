/* This file has been autogenerated by Ivory
 * Compiler version  Version {versionBranch = [0,1,0,0], versionTags = []}
 */
#ifndef __SMAVLINK_MESSAGE_HIL_STATE_H__
#define __SMAVLINK_MESSAGE_HIL_STATE_H__
#ifdef __cplusplus
extern "C" {
#endif
#include <ivory.h>
#include <smavlink/channel.h>
#include <smavlink/system.h>
struct hil_state_msg {
    uint64_t time_usec;
    float roll;
    float pitch;
    float yaw;
    float rollspeed;
    float pitchspeed;
    float yawspeed;
    int32_t lat;
    int32_t lon;
    int32_t alt;
    int16_t vx;
    int16_t vy;
    int16_t vz;
    int16_t xacc;
    int16_t yacc;
    int16_t zacc;
};
void smavlink_send_hil_state(struct hil_state_msg* n_var0,
                             struct smavlink_out_channel* n_var1,
                             struct smavlink_system* n_var2);
void smavlink_unpack_hil_state(struct hil_state_msg* n_var0, const
                               uint8_t** n_var1);

#ifdef __cplusplus
}
#endif
#endif /* __SMAVLINK_MESSAGE_HIL_STATE_H__ */