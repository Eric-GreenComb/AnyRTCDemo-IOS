//
//  AnyrtcLiveGuestKit.h
//  anrtcsdk
//
//  Created by EricTao on 16/4/19.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#ifndef AnyrtcLiveGuestKit_h
#define AnyrtcLiveGuestKit_h
#import "AnyrtcLive.h"

@protocol AnyRTCLiveGuestDelegate <AnyRTCLiveDelegate>
@optional
/**
 *  Apply chat result
 *
 *  @param accept  accept other link scuess
 */
- (void) OnRtcLiveApplyChatResult:(BOOL) accept;

/**
 *  host hangup line
 */
- (void) OnRtcLiveLineHangup;
@end

@interface AnyRTCLiveGuestKit : AnyRTCLive {
    
}

/**
 *  Initializes the AnyRTCLiveGuestKit object.
 *
 *  @param delegate      delegate
 *  @param localViewItem local video view parameter
 *
 *  @return an object of AnyRTCLiveGuestKit class
 */
- (instancetype)initWithDelegate:(id<AnyRTCLiveGuestDelegate>)delegate
               withLocalViewItem:(AnyRTCVideoItem *)localViewItem;

/**
 *  Join Live
 *
 *  @param nsAnyrtcId  Anyrtc ID
 *  @param nsCustomId  other's platform  user id
 *  @param nsCustomName  other's platform  user name
 *  @param bGetMemList Enable member list
 *
 *  @return true:sucess	false:failed
 */
-(BOOL) Join:(NSString*)nsAnyrtcId andCustomId:(NSString*)nsCustomId  andCustomName:(NSString*)nsCustomName andEnableMemberList:(BOOL)bGetMemList;

/**
 *  Send message to host and other guest
 *
 *  @param nsContent  message
 *
 *  @return true:scuess false:failed
 */
- (BOOL) SendUserMsg:(NSString*)nsContent;

/**
 *  Apply link to host
 *
 *  @param nsBrief  link host's describe
 *
 *  @return send request scuess or failure
 */
- (BOOL) ApplyLine2Anchor:(NSString*)nsBrief;

/**
 *  Cancel line
 *
 *  @return YES/NO
 */
- (BOOL) CancelLine;

@end

#endif /* AnyrtcLiveGuestKit_h */
