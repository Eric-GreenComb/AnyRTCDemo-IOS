//
//  AnyrtcLive.h
//  anyrtc
//
//  Created by EricTao on 15/12/21.
//  Copyright © 2015年 EricTao. All rights reserved.
//

#ifndef Anyrtc_Live_h
#define Anyrtc_Live_h
#import <UIKit/UIKit.h>
#import "AnyRTC.h"

@protocol AnyRTCLiveDelegate <NSObject>
@optional
/**
 *  Enter living secuess
 *
 *  @param strAnyrtcId the anyrtc of id
 */
- (void) OnRtcJoinLiveOK:(NSString*) strAnyrtcId;

/**
 *  Enter living failed
 *
 *  @param strAnyrtcId the Anyrtc of ID
 *  @param code        code
 *  @param strReason   the reasen for the error
 */
- (void) OnRtcJoinLiveFailed:(NSString*) strAnyrtcId withCode:(int) code withReason:(NSString*) strReason;

/**
 *  Leave the living meeting
 *
 *  @param code the state
 */
- (void) OnRtcLeaveLive:(int) code;

/**
 *  The video of size callback
 *
 *  @param videoView the video view
 *  @param size      the video size
 */
- (void) OnRtcVideoView:(UIView*)videoView didChangeVideoSize:(CGSize)size;

/**
 *  Other video enter living meeting
 *
 *  @param publishID  the channel of video
 *  @param removeView the video view
 *  @param isHost  this param can judge this is host
 */
- (void) OnRtcOpenRemoteView:(NSString*)publishID  withRemoteView:(UIView *)removeView withIsHost:(BOOL)isHost;

/**
 *  Other video view leave the living meeting
 *
 *  @param publishID the channel of video
 */
- (void)OnRtcRemoveRemoteView:(NSString*)publishID;

/**
 *  Other's video or audio state
 *
 *  @param publishID   media channel
 *  @param audioEnable other's audio is close or open
 *  @param videoEnable other's video is close or open
 */
- (void)OnRtcRemoteAVStatus:(NSString*)publishID withAudioEnable:(BOOL)audioEnable withVideoEnable:(BOOL)videoEnable;

/**
 *  Enable Line
 *
 *  @param enable YES/NO
 */
- (void) OnRtcLiveEnableLine:(BOOL) enable;

/**
 *  Messages
 *
 *  @param nsCustomId other's platform  user id
 *  @param nsCustomName other's platform  user nick name
 *  @param nsContent  message
 */
- (void)OnRtcLiveUserMsg:(NSString*)nsCustomId withCustomName:(NSString*)nsCustomName withContent:(NSString*)nsContent;

/**
 *  All member count in this live.
 *
 *  @param nTotal all member count
 */
- (void)OnRtcLiveNumberOfMember:(int)nTotal;

/**
 *   Got online member
 *
 *  @param nsCustomId other's platform  user id
 *  @param nsCustomName other's platform  user nike name
 */
- (void)OnRtcLiveMemberOnline:(NSString*)nsCustomId withCustomName:(NSString*)nsCustomName;

/**
 *  Got offline member
 *
 *  @param nsCustomId other's platform  user id
 */
- (void)OnRtcLiveMemberOffline:(NSString*)nsCustomId;
@end

@interface AnyRTCLive : NSObject {
    BOOL        _joined;
    BOOL        _callIn;
    BOOL        _getMemList;
    BOOL        _hoster;
    NSString*   _nsAnyrtcId;
    BOOL        _applyChat;
    NSString*   _nsUserName;
    NSString *  _nsNickName;
    NSString*   _nsLinedPeerID;
}

- (instancetype)initWithDelegate:(id<AnyRTCLiveDelegate>)delegate withLocalViewItem:(AnyRTCVideoItem *)localViewItem;
- (BOOL) JoinLive:(NSString*)strAnyrtcId andCustomId:(NSString*)nsCustomID andCustomName:(NSString*)nsCustomName andEnableCallIn:(BOOL)bCallIn andEnableMemberList:(BOOL)bGetMemList;
- (void) SendNotify:(NSString*)nsBody;
- (void) CloseGuestChannel;

/**
 *  Leave
 */
- (void) Leave;

/**
 *  SetPreviewEnable
 *
 *  @param enable set YES to enable, NO to disable.
 */
- (void) SetPreviewEnable:(BOOL)enable;

/**
 *  SetLocalAudioEnable (default is YES)
 *
 *  @param enable set YES to enable, NO to disable.
 */
- (void) SetLocalAudioEnable:(BOOL)enable;

/**
 *  SetLocalVideoEnable (default is YES)
 *
 *  @param enable set YES to enable, NO to disable.
 */
- (void) SetLocalVideoEnable:(BOOL)enable;
/**
 *  SetSpeakerEnable (default is YES)
 *
 *  @param enable set YES to enable, NO to disable.
 */
- (void) SetSpeakerEnable:(BOOL)enable;

/**
 *  SwitchCamera  font/back local camera
 */
- (void) SwitchCamera;

@end

#endif /* AnyrtcM2Mutlier_h */
