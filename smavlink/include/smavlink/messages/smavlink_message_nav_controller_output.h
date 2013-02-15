/* This file has been autogenerated by Ivory
 * Compiler version  0.1.0.0
 */
#ifndef __SMAVLINK_MESSAGE_NAV_CONTROLLER_OUTPUT_H__
#define __SMAVLINK_MESSAGE_NAV_CONTROLLER_OUTPUT_H__
#ifdef __cplusplus
extern "C" {
#endif
#include <ivory.h>
#include <smavlink/channel.h>
#include <smavlink/system.h>
#include "smavlink_pack_ivory.h"
struct nav_controller_output_msg {
    float nav_roll;
    float nav_pitch;
    float alt_error;
    float aspd_error;
    float xtrack_error;
    int16_t nav_bearing;
    int16_t target_bearing;
    uint16_t wp_dist;
};
void smavlink_send_nav_controller_output(struct nav_controller_output_msg* n_var0,
                                         struct smavlink_out_channel* n_var1,
                                         struct smavlink_system* n_var2);
void smavlink_unpack_nav_controller_output(struct nav_controller_output_msg* n_var0,
                                           const uint8_t* n_var1);

#ifdef __cplusplus
}
#endif
#endif /* __SMAVLINK_MESSAGE_NAV_CONTROLLER_OUTPUT_H__ */