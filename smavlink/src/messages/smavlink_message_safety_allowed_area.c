/* This file has been autogenerated by Ivory
 * Compiler version  0.1.0.0
 */
#include "smavlink_message_safety_allowed_area.h"
void smavlink_send_safety_allowed_area(struct safety_allowed_area_msg* n_var0,
                                       struct smavlink_out_channel* n_var1,
                                       struct smavlink_system* n_var2)
{
    uint8_t n_local0[25U] = {0};
    uint8_t* n_ref1 = n_local0;
    float n_deref2 = *&n_var0->p1x;
    
    smavlink_pack_float((uint8_t*) n_ref1, 0U, n_deref2);
    
    float n_deref3 = *&n_var0->p1y;
    
    smavlink_pack_float((uint8_t*) n_ref1, 4U, n_deref3);
    
    float n_deref4 = *&n_var0->p1z;
    
    smavlink_pack_float((uint8_t*) n_ref1, 8U, n_deref4);
    
    float n_deref5 = *&n_var0->p2x;
    
    smavlink_pack_float((uint8_t*) n_ref1, 12U, n_deref5);
    
    float n_deref6 = *&n_var0->p2y;
    
    smavlink_pack_float((uint8_t*) n_ref1, 16U, n_deref6);
    
    float n_deref7 = *&n_var0->p2z;
    
    smavlink_pack_float((uint8_t*) n_ref1, 20U, n_deref7);
    
    uint8_t n_deref8 = *&n_var0->frame;
    
    smavlink_pack_uint8_t((uint8_t*) n_ref1, 24U, n_deref8);
    smavlink_send_ivory(n_var1, n_var2, 55U, (uint8_t*) n_ref1, 25U, 3U);
    return;
}
void smavlink_unpack_safety_allowed_area(struct safety_allowed_area_msg* n_var0,
                                         const uint8_t** n_var1)
{
    float n_r0 = smavlink_unpack_float(n_var1, 0U);
    
    *&n_var0->p1x = n_r0;
    
    float n_r1 = smavlink_unpack_float(n_var1, 4U);
    
    *&n_var0->p1y = n_r1;
    
    float n_r2 = smavlink_unpack_float(n_var1, 8U);
    
    *&n_var0->p1z = n_r2;
    
    float n_r3 = smavlink_unpack_float(n_var1, 12U);
    
    *&n_var0->p2x = n_r3;
    
    float n_r4 = smavlink_unpack_float(n_var1, 16U);
    
    *&n_var0->p2y = n_r4;
    
    float n_r5 = smavlink_unpack_float(n_var1, 20U);
    
    *&n_var0->p2z = n_r5;
    
    uint8_t n_r6 = smavlink_unpack_uint8_t(n_var1, 24U);
    
    *&n_var0->frame = n_r6;
}
