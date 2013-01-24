/* This file has been autogenerated by Ivory
 * Compiler version  Version {versionBranch = [0,1,0,0], versionTags = []}
 */
#include <smavlink/pack.h>
#include "smavlink_message_statustext.h"
void smavlink_send_statustext(struct statustext_msg* n_var0,
                              struct smavlink_out_channel* n_var1,
                              struct smavlink_system* n_var2)
{
    uint8_t n_local0[51U] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    uint8_t(* n_ref1)[51U] = &n_local0;
    uint8_t n_deref2 = *&n_var0->severity;
    
    smavlink_pack_uint8_t(n_ref1, 0U, n_deref2);
    
    uint8_t(* n_let3)[50U] = &n_var0->text;
    
    for (uint8_t n_ix4 = 0U % 50U; n_ix4 < 49U % 50U; n_ix4 = n_ix4 + 1U %
         50U) {
        uint8_t n_deref5 = *&*n_let3[n_ix4];
        
        smavlink_pack_uint8_t(n_ref1, 1U + n_ix4, n_deref5);
    }
    smavlink_send_ivory(n_var1, n_var2, 253U, n_ref1, 51U, 83U);
    return;
}
void smavlink_unpack_statustext(struct statustext_msg* n_var0, const
                                uint8_t** n_var1)
{
    uint8_t n_r0 = smavlink_unpack_uint8_t(n_var1, 0U);
    
    *&n_var0->severity = n_r0;
    for (uint8_t n_ix1 = 0U % 50U; n_ix1 < 49U % 50U; n_ix1 = n_ix1 + 1U %
         50U) {
        uint8_t n_r2 = smavlink_unpack_uint8_t(n_var1, 1U + n_ix1);
        
        *&*(&n_var0->text)[n_ix1] = n_r2;
    }
}
