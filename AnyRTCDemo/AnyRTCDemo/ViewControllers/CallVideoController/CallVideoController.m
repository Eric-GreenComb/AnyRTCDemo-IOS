//
//  CallVideoController.m
//  AnyRTCDemo
//
//  Created by jianqiangzhang on 16/4/20.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "CallVideoController.h"
#import "AnyRTCMeetKit.h"
#import "ASHUD.h"

@interface CallVideoController ()<AnyRTCMeetDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
{
    AnyRTCMeetKit         *anyRTCKit;
    AnyRTCVideoItem   *localVideoItem;
    
    NSString *selectedChannelId;
}
@property (nonatomic, strong) NSMutableDictionary *dicRemoteVideoView;
@property (weak, nonatomic) IBOutlet UIView *toolBarView;
@end

@implementation CallVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dicRemoteVideoView = [[NSMutableDictionary alloc] initWithCapacity:6];
    
    localVideoItem = [[AnyRTCVideoItem alloc] init];
    UIView *local = [[UIView alloc] initWithFrame:self.view.frame];
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locolvideoSingleTap:)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [local addGestureRecognizer:singleTapGestureRecognizer];
    localVideoItem.videoView = local;
    [self.view addSubview: localVideoItem.videoView];
    
    anyRTCKit = [[AnyRTCMeetKit alloc] initWithDelegate:self withLocalViewItem:localVideoItem];
    
    [anyRTCKit Join:self.anyrtcID];
}
- (void)layoutSubView
{
    CGPoint centerpoint;
    CGRect bounds;
    if ([[UIDevice currentDevice].systemVersion floatValue]<=8.0) {
        
        centerpoint = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        
    }else{
        centerpoint = self.view.center;
        bounds = self.view.frame;
    }
    
    // 选择了远程图像
    if (selectedChannelId) {
        
        AnyRTCVideoItem* view = nil;
        view = [_dicRemoteVideoView objectForKey:selectedChannelId];
        
        if (view.videoSize.width>0&& view.videoSize.height>0) {
            //Aspect fit local video view into a square box.
            CGRect remoteVideoFrame =
            AVMakeRectWithAspectRatioInsideRect(view.videoSize, self.view.bounds);
            CGFloat scale = 1;
            if (remoteVideoFrame.size.width < remoteVideoFrame.size.height) {
                // Scale by height.
                scale = self.view.bounds.size.height / remoteVideoFrame.size.height;
            } else {
                // Scale by width.
                scale = self.view.bounds.size.width / remoteVideoFrame.size.width;
            }
            remoteVideoFrame.size.height *= scale;
            remoteVideoFrame.size.width *= scale;
            view.videoView.frame = remoteVideoFrame;
            view.videoView.center = CGPointMake(self.view.bounds.size.width/2,self.view.bounds.size.height/2);
            
        }else{
            return;
        }
        
        if (!view.videoView.superview) {
            [self.view addSubview:view.videoView];
        }
        [self.view sendSubviewToBack:view.videoView];
        
        BOOL localHasSize = NO;
        float sizeViewAllWidth = 0;
        if (localVideoItem.videoSize.width>0 && localVideoItem.videoSize.height>0) {
            if ([localVideoItem.videoView.superview isKindOfClass:[self.view class]]) {
                [localVideoItem.videoView removeFromSuperview];
            }
            localHasSize = YES;
        }
        
        CGFloat videoViewHeight = 0.0;
        videoViewHeight = self.view.bounds.size.height/4;
        CGFloat localViewWidth = 0.0;
        CGFloat remoteViewWidth = 0.0;
        
        float scaleHeight = [self getAllWidthWithHeight:videoViewHeight withAllHeight:&sizeViewAllWidth withLocal:YES];
        videoViewHeight = scaleHeight;
        if (localHasSize) {
            localViewWidth = (localVideoItem.videoSize.width/localVideoItem.videoSize.height)*videoViewHeight;
        }
        
        CGFloat x = 0;
        
        CGFloat y = 0;
        
        for (id key in [_dicRemoteVideoView allKeys]) {
            if (![key isEqualToString:selectedChannelId]) {
                AnyRTCVideoItem * viewsmail = [_dicRemoteVideoView objectForKey:key];
                if (viewsmail.videoSize.width>0&& viewsmail.videoSize.height>0) {
                    remoteViewWidth = (viewsmail.videoSize.width/viewsmail.videoSize.height)*videoViewHeight;
                    viewsmail.videoView.frame = CGRectMake(x,y, remoteViewWidth, videoViewHeight);
                    
                    if (!viewsmail.videoView.superview) {
                        [self.view addSubview:viewsmail.videoView];
                        
                    }
                    [viewsmail.videoView bringSubviewToFront:self.view];
                    x = x+remoteViewWidth;
                }
            }
        }
        localVideoItem.videoView.frame = CGRectMake(x, y, localViewWidth, videoViewHeight);
        if (!localVideoItem.videoView.superview) {
            [self.view addSubview:localVideoItem.videoView];
        }
        [localVideoItem.videoView bringSubviewToFront:self.view];
        
    }else{
        //* Remove by MZW, For show local video when nobody in room.
        if (_dicRemoteVideoView.count==0) {
            if (localVideoItem.videoSize.width && localVideoItem.videoSize.height > 0) {
                float scaleW = self.view.bounds.size.width/localVideoItem.videoSize.width;
                float scaleH = self.view.bounds.size.height/localVideoItem.videoSize.height;
                if (scaleW>scaleH) {
                    localVideoItem.videoView.frame = CGRectMake(0, 0, localVideoItem.videoSize.width*scaleW, localVideoItem.videoSize.height*scaleW);
                    localVideoItem.videoView.center =  CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));;
                }else{
                    localVideoItem.videoView.frame = CGRectMake(0, 0, localVideoItem.videoSize.width*scaleH, localVideoItem.videoSize.height*scaleH);
                    localVideoItem.videoView.center =  CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));;
                }
                
            } else {
                localVideoItem.videoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
            }
            if (!localVideoItem.videoView.superview) {
                [self.view addSubview:localVideoItem.videoView];
            }
            [self.view sendSubviewToBack:localVideoItem.videoView];
            return;
        }
        if (localVideoItem.videoSize.width && localVideoItem.videoSize.height > 0) {
            float scaleW = self.view.bounds.size.width/localVideoItem.videoSize.width;
            float scaleH = self.view.bounds.size.height/localVideoItem.videoSize.height;
            if (scaleW>scaleH) {
                localVideoItem.videoView.frame = CGRectMake(0, 0, localVideoItem.videoSize.width*scaleW, localVideoItem.videoSize.height*scaleW);
                localVideoItem.videoView.center =  CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));;
            }else{
                localVideoItem.videoView.frame = CGRectMake(0, 0, localVideoItem.videoSize.width*scaleH, localVideoItem.videoSize.height*scaleH);
                localVideoItem.videoView.center =  CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));;
            }
            
        } else {
            localVideoItem.videoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        }
        if (!localVideoItem.videoView.superview) {
            [self.view addSubview:localVideoItem.videoView];
        }
        [self.view sendSubviewToBack:localVideoItem.videoView];
        
        float sizeViewAllWidth = 0;
        CGFloat videoViewHeight = 0.0;
        
        videoViewHeight = self.view.bounds.size.height/4;
        
        CGFloat remoteViewWidth = 0.0;
        
        float scaleHeight = [self getAllWidthWithHeight:videoViewHeight withAllHeight:&sizeViewAllWidth withLocal:NO];
        videoViewHeight = scaleHeight;
        
        CGFloat x = 0;
        
        CGFloat y = 0;
        
        for (id key in [_dicRemoteVideoView allKeys]) {
            if (![key isEqualToString:selectedChannelId]) {
                AnyRTCVideoItem * viewsmail = [_dicRemoteVideoView objectForKey:key];
                if (viewsmail.videoSize.width>0&& viewsmail.videoSize.height>0) {
                    remoteViewWidth = (viewsmail.videoSize.width/viewsmail.videoSize.height)*videoViewHeight;
                    viewsmail.videoView.frame = CGRectMake(x,y, remoteViewWidth, videoViewHeight);
                    if (!viewsmail.videoView.superview) {
                        [self.view addSubview:viewsmail.videoView];
                        
                    }
                    [viewsmail.videoView bringSubviewToFront:self.view];
                    x = x+remoteViewWidth;
                }
            }
        }
        
    }
    [self.view bringSubviewToFront:self.toolBarView];
}
- (float)getAllWidthWithHeight:(float)height withAllHeight:(float*)allWidth withLocal:(BOOL)hasLocal{
    float width = 0.0f;
    float videowidth = 0.0f;
    for (id key in [_dicRemoteVideoView allKeys]) {
        if (![key isEqualToString:selectedChannelId]) {
            AnyRTCVideoItem * viewsmail = [_dicRemoteVideoView objectForKey:key];
            if (viewsmail.videoSize.width>0&& viewsmail.videoSize.height>0) {
                videowidth = (viewsmail.videoSize.width/viewsmail.videoSize.height)*height;
            }
            viewsmail.videoView.frame = CGRectMake(0,0, videowidth, height);
            width += videowidth;
        }
    }
    float localWidth = 0.0;
    if (hasLocal) {
        if (localVideoItem.videoSize.width>0 && localVideoItem.videoSize.height>0) {
            localWidth = (localVideoItem.videoSize.width/localVideoItem.videoSize.height)*height;
        }
    }
    
    *allWidth = width+localWidth;
    
    if ((width + localWidth)>self.view.bounds.size.width) {
        height-=20;
        return [self getAllWidthWithHeight:height withAllHeight:allWidth withLocal:hasLocal];
    }
    return height;
}


- (void)singleTap:(UITapGestureRecognizer*)gesture
{
    if (selectedChannelId) {
        return;
    }else{
        UIView  *view = (UIView*)[gesture view];
        for (id key in [_dicRemoteVideoView allKeys]) {
            AnyRTCVideoItem *item = [_dicRemoteVideoView objectForKey:key];
            if (item.videoView == view) {
                selectedChannelId = key;
                [self layoutSubView];
                return;
            }
        }
    }
}

- (void)locolvideoSingleTap:(UITapGestureRecognizer*)gesture
{
    if (selectedChannelId) {
        selectedChannelId = nil;
        [self layoutSubView];
    }
}
- (IBAction)muteButtonEvent:(id)sender {
    UIButton *muteButton = (UIButton*)sender;
    muteButton.selected = !muteButton.selected;
    if (muteButton.selected) {
        [anyRTCKit SetLocalAudioEnable:!muteButton.selected];
    }else{
         [anyRTCKit SetLocalAudioEnable:muteButton.selected];
    }
    
}
- (IBAction)videoButtonEvent:(id)sender {
    UIButton *videoButton = (UIButton*)sender;
    videoButton.selected = !videoButton.selected;
    if (videoButton.selected) {
         [anyRTCKit SetLocalVideoEnable:!videoButton.selected];
    }else{
         [anyRTCKit SetLocalVideoEnable:videoButton.selected];
    }
  
}

- (IBAction)switchCameraEvent:(id)sender {
      [anyRTCKit SwitchCamera];
}
- (IBAction)hangupButton:(id)sender {
    [anyRTCKit Leave];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if(alertView.tag == 502){
        if (anyRTCKit) {
            [anyRTCKit Leave];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - AnyRTCMeetDelegate
/** enter metting secuess
 *
 * @param strAnyrtcId	AnyRTC的ID
 */
- (void) OnRtcJoinMeetOK:(NSString*) strAnyrtcId
{
    
}

/** enter metting failed
 *
 * @param strAnyrtcId	AnyRTC的ID
 * @param code	 error code
 * @param strReason		The reason for the error
 */
- (void) OnRtcJoinMeetFailed:(NSString*) strAnyrtcId withCode:(AnyRTCErrorCode)code withReason:(NSString*) strReason
{
    [ASHUD showHUDWithCompleteStyleInView:self.view content:strReason icon:nil];
}

/** leave meeting
 *
 *  node：abnormal exit or when there will be the callback is put forward
 */
- (void) OnRtcLeaveMeet:(int) code
{
    if (code == AnyRTC_FORCE_EXIT)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请去AnyRTC官网申请账号,如有疑问请联系客服!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 502;
        [alertView show];
        
    }
}
/** video  window size
 *
 * @param videoView	  Video view
 * @param size  the size of video view
 */
- (void) OnRtcVideoView:(UIView*)videoView didChangeVideoSize:(CGSize)size
{
    if (videoView == localVideoItem.videoView) {
        localVideoItem.videoSize = size;
    }else{
        NSLog(@"didChangeVideoSize:%f  %f",size.width,size.height);
        for (NSString *strTag in [_dicRemoteVideoView allKeys]) {
            AnyRTCVideoItem *remoteView = (AnyRTCVideoItem*)[_dicRemoteVideoView objectForKey:strTag];
            if (remoteView.videoView == videoView) {
                remoteView.videoSize = size;
                break;
            }
        }
        NSLog(@"OnRtcVideoView:%f %f",size.width,size.height);
    }
    [self layoutSubView];
}
/** the remote view into the meeting
 *
 *  @param channelID   channel id
 *  @param remoteView  the remote view
 */
- (void) OnRtcOpenRemoteView:(NSString*)channelID  withRemoteView:(UIView *)removeView
{
    AnyRTCVideoItem* findView = [_dicRemoteVideoView objectForKey:channelID];
    if (findView.videoView == removeView) {
        return;
    }
    if (!selectedChannelId&&_dicRemoteVideoView.count==0) {
        selectedChannelId = channelID;
    }
    
    AnyRTCVideoItem *item = [[AnyRTCVideoItem alloc] init];
    item.videoView = removeView;
    item.channelID = channelID;
    
    [_dicRemoteVideoView setObject:item forKey:channelID];
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    singleTapGestureRecognizer.delegate = self;
    [item.videoView  addGestureRecognizer:singleTapGestureRecognizer];
}

/** the remote view leave the meeting
 *
 *  @param channelID  channel id
 */
- (void)OnRtcRemoveRemoteView:(NSString*)channelID
{
    AnyRTCVideoItem *findView = [_dicRemoteVideoView objectForKey:channelID];
    if (findView) {
        if ([channelID isEqualToString:selectedChannelId]) {
            [findView.videoView removeFromSuperview];
            [_dicRemoteVideoView removeObjectForKey:channelID];
            if (_dicRemoteVideoView.count!=0) {
                selectedChannelId =[[_dicRemoteVideoView allKeys] firstObject];
            }else{
                selectedChannelId = nil;
            }
        }else{
            [findView.videoView removeFromSuperview];
            [_dicRemoteVideoView removeObjectForKey:channelID];
            
        }
        [self layoutSubView];
    }
}

/** state of the remote video audio and video
 *
 *  @param channelID   channel id
 *  @param audioEnable  if the audioEnable is ture/false,the remote audio is close/open
 *  @param videoEnable  if the videoEnable is ture/false,the remote video is close/open
 */
- (void)OnRtcRemoteAVStatus:(NSString*)channelID withAudioEnable:(BOOL)audioEnable withVideoEnable:(BOOL)videoEnable
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
