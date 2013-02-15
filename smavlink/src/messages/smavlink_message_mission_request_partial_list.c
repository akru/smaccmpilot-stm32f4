/* This file has been autogenerated by Ivory
 * Compiler version  0.1.0.0
 */
#include "smavlink_message_mission_request_partial_list.h"
void smavlink_send_mission_request_partial_list(struct mission_request_partial_list_msg* n_var0,
                                                struct smavlink_out_channel* n_var1,
                                                struct smavlink_system* n_var2)
{
    uint8_t n_local0[6U] = {0};
    uint8_t* n_ref1 = n_local0;
    int16_t n_deref2 = *&n_var0->start_index;
    
    smavlink_pack_int16_t((uint8_t*) n_ref1, 0U, n_deref2);
    
    int16_t n_deref3 = *&n_var0->end_index;
    
    smavlink_pack_int16_t((uint8_t*) n_ref1, 2U, n_deref3);
    
    uint8_t n_deref4 = *&n_var0->target_system;
    
    smavlink_pack_uint8_t((uint8_t*) n_ref1, 4U, n_deref4);
    
    uint8_t n_deref5 = *&n_var0->target_component;
    
    smavlink_pack_uint8_t((uint8_t*) n_ref1, 5U, n_deref5);
    smavlink_send_ivory(n_var1, n_var2, 37U, (uint8_t*) n_ref1, 6U, 212U);
    return;
}
void smavlink_unpack_mission_request_partial_list(struct mission_request_partial_list_msg* n_var0,
                                                  const uint8_t* n_var1)
{
    int16_t n_r0 = smavlink_unpack_int16_t(n_var1, 0U);
    
    *&n_var0->start_index = n_r0;
    
    int16_t n_r1 = smavlink_unpack_int16_t(n_var1, 2U);
    
    *&n_var0->end_index = n_r1;
    
    uint8_t n_r2 = smavlink_unpack_uint8_t(n_var1, 4U);
    
    *&n_var0->target_system = n_r2;
    
    uint8_t n_r3 = smavlink_unpack_uint8_t(n_var1, 5U);
    
    *&n_var0->target_component = n_r3;
}
