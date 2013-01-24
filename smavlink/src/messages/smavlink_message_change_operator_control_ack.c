/* This file has been autogenerated by Ivory
 * Compiler version  Version {versionBranch = [0,1,0,0], versionTags = []}
 */
#include <smavlink/pack.h>
#include "smavlink_message_change_operator_control_ack.h"
void smavlink_send_change_operator_control_ack(struct change_operator_control_ack_msg* n_var0,
                                               struct smavlink_out_channel* n_var1,
                                               struct smavlink_system* n_var2)
{
    uint8_t n_local0[3U] = {0, 0, 0};
    uint8_t(* n_ref1)[3U] = &n_local0;
    uint8_t n_deref2 = *&n_var0->gcs_system_id;
    
    smavlink_pack_uint8_t(n_ref1, 0U, n_deref2);
    
    uint8_t n_deref3 = *&n_var0->control_request;
    
    smavlink_pack_uint8_t(n_ref1, 1U, n_deref3);
    
    uint8_t n_deref4 = *&n_var0->ack;
    
    smavlink_pack_uint8_t(n_ref1, 2U, n_deref4);
    smavlink_send_ivory(n_var1, n_var2, 6U, n_ref1, 3U, 104U);
    return;
}
void smavlink_unpack_change_operator_control_ack(struct change_operator_control_ack_msg* n_var0,
                                                 const uint8_t** n_var1)
{
    uint8_t n_r0 = smavlink_unpack_uint8_t(n_var1, 0U);
    
    *&n_var0->gcs_system_id = n_r0;
    
    uint8_t n_r1 = smavlink_unpack_uint8_t(n_var1, 1U);
    
    *&n_var0->control_request = n_r1;
    
    uint8_t n_r2 = smavlink_unpack_uint8_t(n_var1, 2U);
    
    *&n_var0->ack = n_r2;
}
