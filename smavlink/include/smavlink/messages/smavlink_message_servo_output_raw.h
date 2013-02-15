/* This file has been autogenerated by Ivory
 * Compiler version  0.1.0.0
 */
#ifndef __SMAVLINK_MESSAGE_SERVO_OUTPUT_RAW_H__
#define __SMAVLINK_MESSAGE_SERVO_OUTPUT_RAW_H__
#ifdef __cplusplus
extern "C" {
#endif
#include <ivory.h>
#include <smavlink/channel.h>
#include <smavlink/system.h>
#include "smavlink_pack_ivory.h"
struct servo_output_raw_msg {
    uint32_t time_usec;
    uint16_t servo1_raw;
    uint16_t servo2_raw;
    uint16_t servo3_raw;
    uint16_t servo4_raw;
    uint16_t servo5_raw;
    uint16_t servo6_raw;
    uint16_t servo7_raw;
    uint16_t servo8_raw;
    uint8_t port;
};
void smavlink_send_servo_output_raw(struct servo_output_raw_msg* n_var0,
                                    struct smavlink_out_channel* n_var1,
                                    struct smavlink_system* n_var2);
void smavlink_unpack_servo_output_raw(struct servo_output_raw_msg* n_var0, const
                                      uint8_t* n_var1);

#ifdef __cplusplus
}
#endif
#endif /* __SMAVLINK_MESSAGE_SERVO_OUTPUT_RAW_H__ */