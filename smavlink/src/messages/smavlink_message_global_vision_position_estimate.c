/* This file has been autogenerated by Ivory
 * Compiler version  0.1.0.0
 */
#include "smavlink_message_global_vision_position_estimate.h"
void smavlink_send_global_vision_position_estimate(struct global_vision_position_estimate_msg* n_var0,
                                                   struct smavlink_out_channel* n_var1,
                                                   struct smavlink_system* n_var2)
{
    uint8_t n_local0[32U] = {0};
    uint8_t* n_ref1 = n_local0;
    uint64_t n_deref2 = *&n_var0->usec;
    
    smavlink_pack_uint64_t((uint8_t*) n_ref1, 0U, n_deref2);
    
    float n_deref3 = *&n_var0->x;
    
    smavlink_pack_float((uint8_t*) n_ref1, 8U, n_deref3);
    
    float n_deref4 = *&n_var0->y;
    
    smavlink_pack_float((uint8_t*) n_ref1, 12U, n_deref4);
    
    float n_deref5 = *&n_var0->z;
    
    smavlink_pack_float((uint8_t*) n_ref1, 16U, n_deref5);
    
    float n_deref6 = *&n_var0->roll;
    
    smavlink_pack_float((uint8_t*) n_ref1, 20U, n_deref6);
    
    float n_deref7 = *&n_var0->pitch;
    
    smavlink_pack_float((uint8_t*) n_ref1, 24U, n_deref7);
    
    float n_deref8 = *&n_var0->yaw;
    
    smavlink_pack_float((uint8_t*) n_ref1, 28U, n_deref8);
    smavlink_send_ivory(n_var1, n_var2, 101U, (uint8_t*) n_ref1, 32U, 102U);
    return;
}
void smavlink_unpack_global_vision_position_estimate(struct global_vision_position_estimate_msg* n_var0,
                                                     const uint8_t** n_var1)
{
    uint64_t n_r0 = smavlink_unpack_uint64_t(n_var1, 0U);
    
    *&n_var0->usec = n_r0;
    
    float n_r1 = smavlink_unpack_float(n_var1, 8U);
    
    *&n_var0->x = n_r1;
    
    float n_r2 = smavlink_unpack_float(n_var1, 12U);
    
    *&n_var0->y = n_r2;
    
    float n_r3 = smavlink_unpack_float(n_var1, 16U);
    
    *&n_var0->z = n_r3;
    
    float n_r4 = smavlink_unpack_float(n_var1, 20U);
    
    *&n_var0->roll = n_r4;
    
    float n_r5 = smavlink_unpack_float(n_var1, 24U);
    
    *&n_var0->pitch = n_r5;
    
    float n_r6 = smavlink_unpack_float(n_var1, 28U);
    
    *&n_var0->yaw = n_r6;
}
