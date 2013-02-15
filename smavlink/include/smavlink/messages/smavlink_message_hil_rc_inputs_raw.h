/* This file has been autogenerated by Ivory
 * Compiler version  0.1.0.0
 */
#ifndef __SMAVLINK_MESSAGE_HIL_RC_INPUTS_RAW_H__
#define __SMAVLINK_MESSAGE_HIL_RC_INPUTS_RAW_H__
#ifdef __cplusplus
extern "C" {
#endif
#include <ivory.h>
#include <smavlink/channel.h>
#include <smavlink/system.h>
#include "smavlink_pack_ivory.h"
struct hil_rc_inputs_raw_msg {
    uint64_t time_usec;
    uint16_t chan1_raw;
    uint16_t chan2_raw;
    uint16_t chan3_raw;
    uint16_t chan4_raw;
    uint16_t chan5_raw;
    uint16_t chan6_raw;
    uint16_t chan7_raw;
    uint16_t chan8_raw;
    uint16_t chan9_raw;
    uint16_t chan10_raw;
    uint16_t chan11_raw;
    uint16_t chan12_raw;
    uint8_t rssi;
};
void smavlink_send_hil_rc_inputs_raw(struct hil_rc_inputs_raw_msg* n_var0,
                                     struct smavlink_out_channel* n_var1,
                                     struct smavlink_system* n_var2);
void smavlink_unpack_hil_rc_inputs_raw(struct hil_rc_inputs_raw_msg* n_var0,
                                       const uint8_t* n_var1);

#ifdef __cplusplus
}
#endif
#endif /* __SMAVLINK_MESSAGE_HIL_RC_INPUTS_RAW_H__ */