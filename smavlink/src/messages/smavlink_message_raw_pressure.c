/* This file has been autogenerated by Ivory
 * Compiler version  0.1.0.0
 */
#include "smavlink_message_raw_pressure.h"
void smavlink_send_raw_pressure(struct raw_pressure_msg* n_var0,
                                struct smavlink_out_channel* n_var1,
                                struct smavlink_system* n_var2)
{
    uint8_t n_local0[16U] = {0};
    uint8_t* n_ref1 = n_local0;
    uint64_t n_deref2 = *&n_var0->time_usec;
    
    smavlink_pack_uint64_t((uint8_t*) n_ref1, 0U, n_deref2);
    
    int16_t n_deref3 = *&n_var0->press_abs;
    
    smavlink_pack_int16_t((uint8_t*) n_ref1, 8U, n_deref3);
    
    int16_t n_deref4 = *&n_var0->press_diff1;
    
    smavlink_pack_int16_t((uint8_t*) n_ref1, 10U, n_deref4);
    
    int16_t n_deref5 = *&n_var0->press_diff2;
    
    smavlink_pack_int16_t((uint8_t*) n_ref1, 12U, n_deref5);
    
    int16_t n_deref6 = *&n_var0->temperature;
    
    smavlink_pack_int16_t((uint8_t*) n_ref1, 14U, n_deref6);
    smavlink_send_ivory(n_var1, n_var2, 28U, (uint8_t*) n_ref1, 16U, 67U);
    return;
}
void smavlink_unpack_raw_pressure(struct raw_pressure_msg* n_var0, const
                                  uint8_t** n_var1)
{
    uint64_t n_r0 = smavlink_unpack_uint64_t(n_var1, 0U);
    
    *&n_var0->time_usec = n_r0;
    
    int16_t n_r1 = smavlink_unpack_int16_t(n_var1, 8U);
    
    *&n_var0->press_abs = n_r1;
    
    int16_t n_r2 = smavlink_unpack_int16_t(n_var1, 10U);
    
    *&n_var0->press_diff1 = n_r2;
    
    int16_t n_r3 = smavlink_unpack_int16_t(n_var1, 12U);
    
    *&n_var0->press_diff2 = n_r3;
    
    int16_t n_r4 = smavlink_unpack_int16_t(n_var1, 14U);
    
    *&n_var0->temperature = n_r4;
}
