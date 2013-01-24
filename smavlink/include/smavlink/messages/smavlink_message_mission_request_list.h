/* This file has been autogenerated by Ivory
 * Compiler version  Version {versionBranch = [0,1,0,0], versionTags = []}
 */
#ifndef __SMAVLINK_MESSAGE_MISSION_REQUEST_LIST_H__
#define __SMAVLINK_MESSAGE_MISSION_REQUEST_LIST_H__
#ifdef __cplusplus
extern "C" {
#endif
#include <ivory.h>
#include <smavlink/channel.h>
#include <smavlink/system.h>
struct mission_request_list_msg {
    uint8_t target_system;
    uint8_t target_component;
};
void smavlink_send_mission_request_list(struct mission_request_list_msg* n_var0,
                                        struct smavlink_out_channel* n_var1,
                                        struct smavlink_system* n_var2);
void smavlink_unpack_mission_request_list(struct mission_request_list_msg* n_var0,
                                          const uint8_t** n_var1);

#ifdef __cplusplus
}
#endif
#endif /* __SMAVLINK_MESSAGE_MISSION_REQUEST_LIST_H__ */