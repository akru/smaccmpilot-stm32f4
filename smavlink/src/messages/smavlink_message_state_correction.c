/* This file has been autogenerated by Ivory
 * Compiler version  0.1.0.0
 */
#include "smavlink_message_state_correction.h"
void smavlink_send_state_correction(struct state_correction_msg* n_var0,
                                    struct smavlink_out_channel* n_var1,
                                    struct smavlink_system* n_var2)
{
    uint8_t n_local0[36U] = {0};
    uint8_t* n_ref1 = n_local0;
    float n_deref2 = *&n_var0->xErr;
    
    smavlink_pack_float((uint8_t*) n_ref1, 0U, n_deref2);
    
    float n_deref3 = *&n_var0->yErr;
    
    smavlink_pack_float((uint8_t*) n_ref1, 4U, n_deref3);
    
    float n_deref4 = *&n_var0->zErr;
    
    smavlink_pack_float((uint8_t*) n_ref1, 8U, n_deref4);
    
    float n_deref5 = *&n_var0->rollErr;
    
    smavlink_pack_float((uint8_t*) n_ref1, 12U, n_deref5);
    
    float n_deref6 = *&n_var0->pitchErr;
    
    smavlink_pack_float((uint8_t*) n_ref1, 16U, n_deref6);
    
    float n_deref7 = *&n_var0->yawErr;
    
    smavlink_pack_float((uint8_t*) n_ref1, 20U, n_deref7);
    
    float n_deref8 = *&n_var0->vxErr;
    
    smavlink_pack_float((uint8_t*) n_ref1, 24U, n_deref8);
    
    float n_deref9 = *&n_var0->vyErr;
    
    smavlink_pack_float((uint8_t*) n_ref1, 28U, n_deref9);
    
    float n_deref10 = *&n_var0->vzErr;
    
    smavlink_pack_float((uint8_t*) n_ref1, 32U, n_deref10);
    smavlink_send_ivory(n_var1, n_var2, 64U, (uint8_t*) n_ref1, 36U, 130U);
    return;
}
void smavlink_unpack_state_correction(struct state_correction_msg* n_var0, const
                                      uint8_t** n_var1)
{
    float n_r0 = smavlink_unpack_float(n_var1, 0U);
    
    *&n_var0->xErr = n_r0;
    
    float n_r1 = smavlink_unpack_float(n_var1, 4U);
    
    *&n_var0->yErr = n_r1;
    
    float n_r2 = smavlink_unpack_float(n_var1, 8U);
    
    *&n_var0->zErr = n_r2;
    
    float n_r3 = smavlink_unpack_float(n_var1, 12U);
    
    *&n_var0->rollErr = n_r3;
    
    float n_r4 = smavlink_unpack_float(n_var1, 16U);
    
    *&n_var0->pitchErr = n_r4;
    
    float n_r5 = smavlink_unpack_float(n_var1, 20U);
    
    *&n_var0->yawErr = n_r5;
    
    float n_r6 = smavlink_unpack_float(n_var1, 24U);
    
    *&n_var0->vxErr = n_r6;
    
    float n_r7 = smavlink_unpack_float(n_var1, 28U);
    
    *&n_var0->vyErr = n_r7;
    
    float n_r8 = smavlink_unpack_float(n_var1, 32U);
    
    *&n_var0->vzErr = n_r8;
}
