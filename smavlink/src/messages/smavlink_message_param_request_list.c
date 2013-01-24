/* This file has been autogenerated by Ivory
 * Compiler version  Version {versionBranch = [0,1,0,0], versionTags = []}
 */
#include <smavlink/pack.h>
#include "smavlink_message_param_request_list.h"
void smavlink_send_param_request_list(struct param_request_list_msg* n_var0,
                                      struct smavlink_out_channel* n_var1,
                                      struct smavlink_system* n_var2)
{
    uint8_t n_local0[2U] = {0, 0};
    uint8_t(* n_ref1)[2U] = &n_local0;
    uint8_t n_deref2 = *&n_var0->target_system;
    
    smavlink_pack_uint8_t(n_ref1, 0U, n_deref2);
    
    uint8_t n_deref3 = *&n_var0->target_component;
    
    smavlink_pack_uint8_t(n_ref1, 1U, n_deref3);
    smavlink_send_ivory(n_var1, n_var2, 21U, n_ref1, 2U, 159U);
    return;
}
void smavlink_unpack_param_request_list(struct param_request_list_msg* n_var0,
                                        const uint8_t** n_var1)
{
    uint8_t n_r0 = smavlink_unpack_uint8_t(n_var1, 0U);
    
    *&n_var0->target_system = n_r0;
    
    uint8_t n_r1 = smavlink_unpack_uint8_t(n_var1, 1U);
    
    *&n_var0->target_component = n_r1;
}
