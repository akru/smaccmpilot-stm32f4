/* This file has been autogenerated by Ivory
 * Compiler version  0.1.0.0
 */
#include "smavlink_message_debug.h"
void smavlink_send_debug(struct debug_msg* n_var0,
                         struct smavlink_out_channel* n_var1,
                         struct smavlink_system* n_var2)
{
    uint8_t n_local0[9U] = {0};
    uint8_t* n_ref1 = n_local0;
    uint32_t n_deref2 = *&n_var0->time_boot_ms;
    
    smavlink_pack_uint32_t((uint8_t*) n_ref1, 0U, n_deref2);
    
    float n_deref3 = *&n_var0->value;
    
    smavlink_pack_float((uint8_t*) n_ref1, 4U, n_deref3);
    
    uint8_t n_deref4 = *&n_var0->ind;
    
    smavlink_pack_uint8_t((uint8_t*) n_ref1, 8U, n_deref4);
    smavlink_send_ivory(n_var1, n_var2, 254U, (uint8_t*) n_ref1, 9U, 46U);
    return;
}
void smavlink_unpack_debug(struct debug_msg* n_var0, const uint8_t* n_var1)
{
    uint32_t n_r0 = smavlink_unpack_uint32_t(n_var1, 0U);
    
    *&n_var0->time_boot_ms = n_r0;
    
    float n_r1 = smavlink_unpack_float(n_var1, 4U);
    
    *&n_var0->value = n_r1;
    
    uint8_t n_r2 = smavlink_unpack_uint8_t(n_var1, 8U);
    
    *&n_var0->ind = n_r2;
}
