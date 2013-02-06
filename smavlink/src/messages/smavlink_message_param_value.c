/* This file has been autogenerated by Ivory
 * Compiler version  0.1.0.0
 */
#include "smavlink_message_param_value.h"
void smavlink_send_param_value(struct param_value_msg* n_var0,
                               struct smavlink_out_channel* n_var1,
                               struct smavlink_system* n_var2)
{
    uint8_t n_local0[25U] = {0};
    uint8_t* n_ref1 = n_local0;
    float n_deref2 = *&n_var0->param_value;
    
    smavlink_pack_float((uint8_t*) n_ref1, 0U, n_deref2);
    
    uint16_t n_deref3 = *&n_var0->param_count;
    
    smavlink_pack_uint16_t((uint8_t*) n_ref1, 4U, n_deref3);
    
    uint16_t n_deref4 = *&n_var0->param_index;
    
    smavlink_pack_uint16_t((uint8_t*) n_ref1, 6U, n_deref4);
    
    uint8_t n_deref5 = *&n_var0->param_type;
    
    smavlink_pack_uint8_t((uint8_t*) n_ref1, 24U, n_deref5);
    
    uint8_t* n_let6 = n_var0->param_id;
    
    for (uint8_t n_ix7 = 0U % 16U; n_ix7 <= 15U % 16U; n_ix7 = n_ix7 + 1U %
         16U) {
        uint8_t n_deref8 = *&n_let6[n_ix7];
        
        smavlink_pack_uint8_t((uint8_t*) n_ref1, 8U + n_ix7, n_deref8);
    }
    smavlink_send_ivory(n_var1, n_var2, 22U, (uint8_t*) n_ref1, 25U, 220U);
    return;
}
void smavlink_unpack_param_value(struct param_value_msg* n_var0, const
                                 uint8_t** n_var1)
{
    float n_r0 = smavlink_unpack_float(n_var1, 0U);
    
    *&n_var0->param_value = n_r0;
    
    uint16_t n_r1 = smavlink_unpack_uint16_t(n_var1, 4U);
    
    *&n_var0->param_count = n_r1;
    
    uint16_t n_r2 = smavlink_unpack_uint16_t(n_var1, 6U);
    
    *&n_var0->param_index = n_r2;
    
    uint8_t n_r3 = smavlink_unpack_uint8_t(n_var1, 24U);
    
    *&n_var0->param_type = n_r3;
    for (uint8_t n_ix4 = 0U % 16U; n_ix4 <= 15U % 16U; n_ix4 = n_ix4 + 1U %
         16U) {
        uint8_t n_r5 = smavlink_unpack_uint8_t(n_var1, 8U + n_ix4);
        
        *&n_var0->param_id[n_ix4] = n_r5;
    }
}
