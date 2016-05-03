//
//  GuestViewController.m
//  AnyRTCDemo
//
//  Created by jianqiangzhang on 16/4/26.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "GuestViewController.h"
#import "AnyRTCLiveGuestKit.h"
#import <AVFoundation/AVFoundation.h>
#import "ASHUD.h"
//#import "MessageManagerView.h"
#import "TalkManagerView.h"

#import <Masonry/Masonry.h>

#define ISIPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) // 判断设备是不是iPad
#define VideoHeight 200

@interface GuestViewController ()<AnyRTCLiveGuestDelegate,UIAlertViewDelegate,TalkManagerViewDelegate>
{
    AnyRTCLiveGuestKit  *guestLiveKit;
    AnyRTCVideoItem    *localVideoItem;
    AnyRTCVideoItem    *hostVideoItem;
    AnyRTCVideoItem    *otherVideoItem;
    BOOL isAccept;
    TalkManagerView *messageView;
    
}
@property (weak, nonatomic) IBOutlet UILabel *memberLabel;

@property (weak, nonatomic) IBOutlet UIButton *handUpButton;
@property (weak, nonatomic) IBOutlet UIView *toolBarView;
@end

@implementation GuestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.memberLabel adjustsFontSizeToFitWidth];
    localVideoItem = [[AnyRTCVideoItem alloc] init];
    UIView *local = [[UIView alloc] initWithFrame:CGRectZero];
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locolvideoSingleTap:)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [local addGestureRecognizer:singleTapGestureRecognizer];
    
    localVideoItem.videoView = local;
//    [self.view addSubview: localVideoItem.videoView];
    guestLiveKit = [[AnyRTCLiveGuestKit alloc] initWithDelegate:self withLocalViewItem:localVideoItem];
#warning Warning 测试直播号，是开发者在平台上申请，也可以服务对接来生产anyrtcID  800000000025  800000000028
    [guestLiveKit Join:@"" andCustomId:@"three id" andCustomName:@"guest name" andEnableMemberList:YES];
        NSLog(@"请到平台上申请测试的anyrtcID，或者服务对接生成房间号");
    
    self.handUpButton.hidden = YES;
    messageView = [[TalkManagerView alloc] initWithFrame:CGRectZero WithInputView:YES];
    messageView.nikeName = @"Guest";
    messageView.delegate = self;
    messageView.hidden = YES;
    [self.view addSubview:messageView];
    [messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.width.equalTo(self.view.mas_width).multipliedBy(.6);
        make.height.equalTo(self.view.mas_height).multipliedBy(1);
    }];
}

- (void)layoutHost
{
    
    if (hostVideoItem.videoSize.width>0&& hostVideoItem.videoSize.height>0) {
        //Aspect fit local video view into a square box.
        CGRect remoteVideoFrame =
        AVMakeRectWithAspectRatioInsideRect(hostVideoItem.videoSize, self.view.bounds);
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
        hostVideoItem.videoView.frame = remoteVideoFrame;
        hostVideoItem.videoView.center = CGPointMake(self.view.bounds.size.width/2,self.view.bounds.size.height/2);
        
    }else{
        return;
    }
    
    if (!hostVideoItem.videoView.superview) {
        [self.view addSubview:hostVideoItem.videoView];
    }
    [self.view sendSubviewToBack:hostVideoItem.videoView];
    
    [self.view bringSubviewToFront:messageView];
    [self.view bringSubviewToFront:self.toolBarView];
    
}

- (void)layoutOtherVideoView
{
    if (otherVideoItem) {
        // 另外一个
        CGFloat videoViewHeight = 0.0;
        CGFloat  remoteViewWidth = self.view.bounds.size.width/3;
        
        if (otherVideoItem.videoSize.width>0&& otherVideoItem.videoSize.height>0) {
            videoViewHeight = (otherVideoItem.videoSize.height/otherVideoItem.videoSize.width)*remoteViewWidth;
            otherVideoItem.videoView.frame = CGRectMake(CGRectGetMaxX(self.view.frame)-remoteViewWidth, CGRectGetMaxY(self.view.frame)-videoViewHeight, remoteViewWidth, videoViewHeight);
            if (!otherVideoItem.videoView.superview) {
                [self.view addSubview:otherVideoItem.videoView];
            }
            
        }else{
            videoViewHeight = VideoHeight;
            otherVideoItem.videoView.frame = CGRectMake(CGRectGetMaxX(self.view.frame)-remoteViewWidth, CGRectGetMaxY(self.view.frame)-videoViewHeight, remoteViewWidth, videoViewHeight);
            if (!otherVideoItem.videoView.superview) {
                [self.view addSubview:otherVideoItem.videoView];
            }
        }
        
        [self.view bringSubviewToFront:messageView];
        [self.view bringSubviewToFront:self.toolBarView];
    }
}

- (void)layoutMyself
{
    if (isAccept){
        // 自己
        CGFloat videoViewHeight = 0.0;
        CGFloat  remoteViewWidth = self.view.bounds.size.width/3;
        
        if (localVideoItem.videoSize.width>0&& localVideoItem.videoSize.height>0) {
            videoViewHeight = (localVideoItem.videoSize.height/localVideoItem.videoSize.width)*remoteViewWidth;
            localVideoItem.videoView.frame = CGRectMake(CGRectGetMaxX(self.view.frame)-remoteViewWidth, CGRectGetMaxY(self.view.frame)-videoViewHeight, remoteViewWidth, videoViewHeight);
            if (!localVideoItem.videoView.superview) {
                [self.view addSubview:localVideoItem.videoView];
            }
            
        }else{
            videoViewHeight = VideoHeight;
            localVideoItem.videoView.frame = CGRectMake(CGRectGetMaxX(self.view.frame)-remoteViewWidth, CGRectGetMaxY(self.view.frame)-videoViewHeight, remoteViewWidth, videoViewHeight);
            if (!localVideoItem.videoView.superview) {
                [self.view addSubview:localVideoItem.videoView];
            }
        }
        
        [self.view bringSubviewToFront:messageView];
        [self.view bringSubviewToFront:self.toolBarView];
    }
}

- (IBAction)handsEvent:(id)sender {
    if (guestLiveKit) {
       BOOL isScuess =  [guestLiveKit ApplyLine2Anchor:@"我想连线"];
        self.handUpButton.hidden = YES;
       NSLog(@"%d",isScuess);
    }
}
- (IBAction)hundupEvent:(id)sender {
    if (guestLiveKit) {
        [guestLiveKit Leave];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)locolvideoSingleTap:(UITapGestureRecognizer*)gesture
{
   
   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"关闭连线" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (guestLiveKit) {
           BOOL cancleLine = [guestLiveKit CancelLine];
            if (cancleLine) {
                isAccept = NO;
                [localVideoItem.videoView removeFromSuperview];
                 self.handUpButton.hidden = NO;
            }
        }
    }
}
#pragma mark - TalkManagerViewDelegate
- (void)sendMessageTo:(NSString*)message
{
    if (guestLiveKit) {
        [guestLiveKit SendUserMsg:message];
    }
}

#pragma mark - AnyRTCLiveHostDelegate

- (void) OnRtcJoinLiveOK:(NSString*) strAnyrtcId
{
    NSLog(@"OnRtcJoinLiveOK:%@",strAnyrtcId);
}

- (void) OnRtcLiveMemberList:(NSArray*) narrMember
{
    NSLog(@"OnRtcLiveMemberList:%@",[narrMember description]);
}

- (void) OnRtcLiveEnableLine:(BOOL) enable
{
     NSLog(@"OnRtcLiveEnableLine:%d",enable);
}

- (void) OnRtcJoinLiveFailed:(NSString*) strAnyrtcId withCode:(int) code withReason:(NSString*) strReason
{
    NSLog(@"OnRtcJoinLiveFailed:%@ withCode:%d withReason:%@",strAnyrtcId,code,strReason);
    [ASHUD showHUDWithCompleteStyleInView:self.view content:@"对不起，主播还没开始" icon:nil];
    // 该错误信息后期会给出详细的
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self dismissViewControllerAnimated:YES completion:nil];
    });
   
}

- (void) OnRtcLeaveLive:(int) code
{
    NSLog(@"OnRtcLeaveLive:%d",code);
    [ASHUD showHUDWithCompleteStyleInView:self.view content:@"主播已经关闭直播" icon:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    
}

- (void)OnRtcRemoteAVStatus:(NSString*)publishID withAudioEnable:(BOOL)audioEnable withVideoEnable:(BOOL)videoEnable
{
    NSLog(@"OnRtcRemoteAVStatus:%@ withAudioEnable:%d withVideoEnable:%d",publishID,audioEnable,videoEnable);
}

- (void) OnRtcLiveApplyChatResult:(BOOL) accept
{
    isAccept = accept;
    [self layoutMyself];
    NSLog(@"OnRtcLiveApplyChatResult:%d",accept);
    if (isAccept) {
        [ASHUD showHUDWithCompleteStyleInView:self.view content:@"主播同意你的连线" icon:nil];
        
    }else{
        [ASHUD showHUDWithCompleteStyleInView:self.view content:@"主播拒绝了你的连线" icon:nil];
        self.handUpButton.hidden = NO;
    }
}
- (void) OnRtcLiveLineHangup
{
    NSLog(@"OnRtcLiveLineHangup");
    [localVideoItem.videoView removeFromSuperview];
    self.handUpButton.hidden = NO;
    
}

- (void) OnRtcVideoView:(UIView*)videoView didChangeVideoSize:(CGSize)size
{
    if (videoView == localVideoItem.videoView) {
        localVideoItem.videoSize = size;
        [self layoutMyself];
    }else if(videoView == hostVideoItem.videoView){
        hostVideoItem.videoSize = size;
        [self layoutHost];
        messageView.hidden = NO;
        self.handUpButton.hidden = NO;
    }else if(videoView == otherVideoItem.videoView){
        otherVideoItem.videoSize = size;
        [self layoutOtherVideoView];
    }
}

- (void) OnRtcOpenRemoteView:(NSString*)publishID  withRemoteView:(UIView *)removeView withIsHost:(BOOL)isHost
{
    if (isHost) {
        hostVideoItem = [[AnyRTCVideoItem alloc] init];
        hostVideoItem.videoView = removeView;
        hostVideoItem.channelID = publishID;
        [self layoutHost];
       
    }else{
        otherVideoItem = [[AnyRTCVideoItem alloc] init];
        otherVideoItem.videoView = removeView;
        otherVideoItem.channelID = publishID;
        [self layoutOtherVideoView];
    }
}

- (void)OnRtcRemoveRemoteView:(NSString*)publishID
{
    if ([publishID isEqualToString:otherVideoItem.channelID]) {
        [otherVideoItem.videoView removeFromSuperview];
        otherVideoItem = nil;
    }
}
- (void)OnRtcLiveUserMsg:(NSString*)nsCustomId withCustomName:(NSString *)nsCustomName withContent:(NSString *)nsContent
{
    if (messageView) {
        [messageView receiveMessage:nsContent withUserId:nsCustomName withHeadPath:nil];
    }
}

- (void)OnRtcLiveNumberOfMember:(int)nTotal
{
    NSLog(@"OnRtcLiveNumberOfMember:%d",nTotal);
    @autoreleasepool {
        self.memberLabel.text = [NSString stringWithFormat:@"%d人在线",nTotal];
    }
}

- (void)OnRtcLiveMemberOnline:(NSString*)nsCustomId withCustomName:(NSString*)nsCustomName
{
    NSLog(@"OnRtcLiveMemberOnline:%@ withCustomName:%@",nsCustomId,nsCustomName);
}

- (void)OnRtcLiveMemberOffline:(NSString*)nsCustomId
{
    NSLog(@"OnRtcLiveMemberOffline:%@",nsCustomId);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
}

- (BOOL)shouldAutorotate
{
     return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;

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
