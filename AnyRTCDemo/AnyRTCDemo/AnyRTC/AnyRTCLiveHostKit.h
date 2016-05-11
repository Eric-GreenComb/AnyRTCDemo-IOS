//
//  AnyrtcLiveHost.h
//  anrtcsdk
//
//  Created by EricTao on 16/4/19.
//  Copyright © 2016年 EricTao. All rights reserved.
//

#ifndef AnyrtcLiveHostKit_h
#define AnyrtcLiveHostKit_h
#import "AnyRTCLive.h"

@protocol AnyRTCLiveHostDelegate <AnyRTCLiveDelegate>
@optional
/**
 *  Live infomation
 *
 *  @param nsUrl        Rtmp/Hls url
 *  @param nsSessionId  SessionId
 */
-(void) OnRtcLiveInfomation:(NSString*)nsUrl withSessionId:(NSString*)nsSessionId;

/**
 *  Guest want to line with you
 *
 *  @param nsPeerId   Peer's ID
 *  @param nsUserName Peer's user name
 *  @param nsBrief    A brief
 */
-(void) OnRtcLiveApplyLine:(NSString*)nsPeerId withUserName:(NSString*)nsUserName withBrief:(NSString*)nsBrief;

/**
 *  Guest cancel line apply
 *
 *  @param nsPeerId   Peer's ID
 *  @param nsUserName Peer's user name
 */
-(void) OnRtcLiveCancelLine:(NSString*)nsPeerId withUserName:(NSString*)nsUserName;
@end

@interface AnyRTCLiveHostKit : AnyRTCLive {
    
}

/**
 *  Initializes the AnyRTCLiveHostKit object.
 *
 *  @param delegate      delegate
 *  @param localViewItem local video view parameter
 *
 *  @return an object of AnyRTCLiveHostKit class
 */
- (instancetype)initWithDelegate:(id<AnyRTCLiveHostDelegate>)delegate
               withLocalViewItem:(AnyRTCVideoItem *)localViewItem;

/**
 *  Join Live
 *
 *  @param nsAnyrtcId  Anyrtc ID
 *  @param nsCustomId  other's platform  user id
 *  @param nsCustomName  other's platform  user name
 *  @param bCallIn     Enable line function
 *  @param bGetMemList Enable member list
 *
 *  @return true:sucess	false:failed
 */
-(BOOL) Join:(NSString*)nsAnyrtcId  andCustomId:(NSString*)nsCustomId andCustomName:(NSString*)nsCustomName andEnableCallIn:(BOOL)bCallIn andEnableMemberList:(BOOL)bGetMemList;

/**
 *  The host switch connection function
 *
 *  @param enable ON/YES (open/close)
 *
 *  @return true:scuess	false:failure
 */
-(BOOL) SetLineEnable:(BOOL)enable;

/**
 *  Host accept the connection
 *
 *  @param nsPeerId  request connection Id
 *
 *  @return ture:scuess false:failed
 */
-(BOOL) AcceptApplyLine:(NSString*)nsPeerId;

/**
 *  Host refused to the connection
 *
 *  @param nsPeerId request connection Id
 */
-(void) RejectApplyLine:(NSString*)nsPeerId;

/**
 *  Hungup Line
 *
 *  @param nsPeerId the gust line's peer Id
 */
-(void) HangupLine:(NSString*)nsPeerId;

@end

#endif /* AnyrtcLiveHostKit_h */
