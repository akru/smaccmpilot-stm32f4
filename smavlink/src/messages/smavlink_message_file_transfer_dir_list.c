/* This file has been autogenerated by Ivory
 * Compiler version  0.1.0.0
 */
#include "smavlink_message_file_transfer_dir_list.h"
void smavlink_send_file_transfer_dir_list(struct file_transfer_dir_list_msg* n_var0,
                                          struct smavlink_out_channel* n_var1,
                                          struct smavlink_system* n_var2)
{
    uint8_t n_local0[249U] = {0};
    uint8_t* n_ref1 = n_local0;
    uint64_t n_deref2 = *&n_var0->transfer_uid;
    
    smavlink_pack_uint64_t((uint8_t*) n_ref1, 0U, n_deref2);
    
    uint8_t n_deref3 = *&n_var0->flags;
    
    smavlink_pack_uint8_t((uint8_t*) n_ref1, 248U, n_deref3);
    
    uint8_t* n_let4 = n_var0->dir_path;
    
    for (int32_t n_ix5 = 0 % 240; n_ix5 <= 239 % 240; n_ix5 = n_ix5 + 1) {
        uint8_t n_deref6 = *&n_let4[n_ix5];
        
        smavlink_pack_uint8_t((uint8_t*) n_ref1, 8U + (uint8_t) n_ix5,
                              n_deref6);
    }
    smavlink_send_ivory(n_var1, n_var2, 111U, (uint8_t*) n_ref1, 249U, 93U);
    return;
}
void smavlink_unpack_file_transfer_dir_list(struct file_transfer_dir_list_msg* n_var0,
                                            const uint8_t* n_var1)
{
    uint64_t n_r0 = smavlink_unpack_uint64_t(n_var1, 0U);
    
    *&n_var0->transfer_uid = n_r0;
    
    uint8_t n_r1 = smavlink_unpack_uint8_t(n_var1, 248U);
    
    *&n_var0->flags = n_r1;
    for (int32_t n_ix2 = 0 % 240; n_ix2 <= 239 % 240; n_ix2 = n_ix2 + 1) {
        uint8_t n_r3 = smavlink_unpack_uint8_t(n_var1, 8U + (uint8_t) n_ix2);
        
        *&n_var0->dir_path[n_ix2] = n_r3;
    }
}
