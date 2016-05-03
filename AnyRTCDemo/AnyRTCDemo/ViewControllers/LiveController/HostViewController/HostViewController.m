//
//  HostViewController.m
//  AnyRTCDemo
//
//  Created by jianqiangzhang on 16/4/26.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "HostViewController.h"
#import "AnyRTCLiveHostKit.h"
#import "ASHUD.h"
#import "TalkManagerView.h"
#import <Masonry/Masonry.h>
#define ISIPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) // 判断设备是不是iPad
#define VideoHeight 200

@interface HostViewController ()<AnyRTCLiveHostDelegate,UIAlertViewDelegate>
{
    AnyRTCLiveHostKit  *hostLiveKit;
    AnyRTCVideoItem    *localVideoItem;
    
    AnyRTCVideoItem    *otherLinkVideoItem;
    
    TalkManagerView *_messageView;

    NSString *peerID;
}
@property (weak, nonatomic) IBOutlet UIView *toolsBarView;
@property (weak, nonatomic) IBOutlet UILabel *memberLabel;
@end

@implementation HostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.memberLabel adjustsFontSizeToFitWidth];
    localVideoItem = [[AnyRTCVideoItem alloc] init];
    UIView *local = [[UIView alloc] initWithFrame:self.view.frame];
    localVideoItem.videoView = local;
    [self.view addSubview: localVideoItem.videoView];
    hostLiveKit = [[AnyRTCLiveHostKit alloc] initWithDelegate:self withLocalViewItem:localVideoItem];
    // 预览功能
    [hostLiveKit SetPreviewEnable:YES];
    #warning Warning 测试直播号，是开发者在平台上申请，也可以服务对接来生产anyrtcID
    [hostLiveKit Join:@"" andCustomId:@"threeID" andCustomName:@"host name" andEnableCallIn:YES andEnableMemberList:YES];
     NSLog(@"请到平台上申请测试的anyrtcID，或者服务对接生成房间号");
    
    _messageView = [[TalkManagerView alloc] initWithFrame:CGRectZero WithInputView:NO];
     [self.view addSubview:_messageView];
    [_messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.width.equalTo(self.view.mas_width).multipliedBy(.6);
        make.height.equalTo(self.view.mas_height).multipliedBy(.6);
    }];
    
}

- (void)layoutLocalVideo
{
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
    [localVideoItem.videoView removeFromSuperview];
    [self.view addSubview:localVideoItem.videoView];
    [self.view sendSubviewToBack:localVideoItem.videoView];
}
- (void)layoutOtherVideo
{
    CGFloat videoViewHeight = 0.0;
    CGFloat  remoteViewWidth = self.view.bounds.size.width/3;
    
    if (otherLinkVideoItem.videoSize.width>0&& otherLinkVideoItem.videoSize.height>0) {
        videoViewHeight = (otherLinkVideoItem.videoSize.height/otherLinkVideoItem.videoSize.width)*remoteViewWidth;
        otherLinkVideoItem.videoView.frame = CGRectMake(CGRectGetMaxX(self.view.frame)-remoteViewWidth, CGRectGetMaxY(self.view.frame)-videoViewHeight, remoteViewWidth, videoViewHeight);
        if (!otherLinkVideoItem.videoView.superview) {
            [self.view addSubview:otherLinkVideoItem.videoView];
        }
        
    }else{
        videoViewHeight = VideoHeight;
        otherLinkVideoItem.videoView.frame = CGRectMake(CGRectGetMaxX(self.view.frame)-remoteViewWidth, CGRectGetMaxY(self.view.frame)-videoViewHeight, remoteViewWidth, videoViewHeight);
        if (!otherLinkVideoItem.videoView.superview) {
            [self.view addSubview:otherLinkVideoItem.videoView];
        }
    }

    [self.view bringSubviewToFront:_messageView];
    
}

- (IBAction)hundupEvent:(id)sender {
    if (hostLiveKit) {
        [hostLiveKit Leave];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)singleTap:(UITapGestureRecognizer*)gesture
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"关闭连线" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 500;
    [alertView show];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 501) {
        if (buttonIndex == 0) {
            if (hostLiveKit) {
                [hostLiveKit RejectApplyLine:peerID];
                 peerID = nil;
            }
        }else{
            if (hostLiveKit) {
                [hostLiveKit AcceptApplyLine:peerID];
            }
        }
    }else if (alertView.tag == 500){
        if (buttonIndex == 1) {
            if (hostLiveKit) {
                [hostLiveKit HangupLine:peerID];
                peerID = nil;
            }
        }
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
    [ASHUD showHUDWithCompleteStyleInView:self.view content:@"对不起，该频道正在直播" icon:nil];
    // 该错误信息后期会给出详细的
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void) OnRtcLeaveLive:(int) code
{
    NSLog(@"OnRtcLeaveLive:%d",code);
}

- (void)OnRtcRemoteAVStatus:(NSString*)publishID withAudioEnable:(BOOL)audioEnable withVideoEnable:(BOOL)videoEnable
{
     NSLog(@"OnRtcRemoteAVStatus:%@ withAudioEnable:%d withVideoEnable:%d",publishID,audioEnable,videoEnable);
}
-(void) OnRtcLiveInfomation:(NSString*)nsUrl withSessionId:(NSString*)nsSessionId
{
    NSLog(@"OnRtcLiveInfomation:%@ withSessionId:%@",nsUrl,nsSessionId);
}

-(void) OnRtcLiveApplyLine:(NSString*)nsPeerId withUserName:(NSString*)nsUserName withBrief:(NSString*)nsBrief
{
    NSLog(@"OnRtcLiveApplyLine:%@ withUserName:%@ withBrief:%@",nsPeerId,nsUserName,nsBrief);
    
    
    if (peerID) {
        [hostLiveKit RejectApplyLine:nsPeerId];
        return;
    }
    peerID = nsPeerId;
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"粉丝请求连线" message:[NSString stringWithFormat:@"%@想连线你",nsUserName] delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"同意", nil];
    alerView.tag = 501;
    [alerView show];
}

-(void) OnRtcLiveCancelLine:(NSString*)nsPeerId withUserName:(NSString*)nsUserName
{
    if ([nsPeerId isEqualToString: peerID]) {
        peerID = nil;
    }
     NSLog(@"OnRtcLiveCancelLine:%@ withUserName:%@",nsPeerId,nsUserName);
}

- (void) OnRtcVideoView:(UIView*)videoView didChangeVideoSize:(CGSize)size
{
    if (videoView == localVideoItem.videoView) {
        localVideoItem.videoSize = size;
        [self layoutLocalVideo];
    }else{
        if (otherLinkVideoItem) {
            otherLinkVideoItem.videoSize = size;
            [self layoutOtherVideo];
        }
    }
}

- (void) OnRtcOpenRemoteView:(NSString*)publishID  withRemoteView:(UIView *)removeView withIsHost:(BOOL)isHost
{
    if (otherLinkVideoItem) {
        otherLinkVideoItem = nil;
    }
    otherLinkVideoItem = [[AnyRTCVideoItem alloc] init];
    otherLinkVideoItem.videoView = removeView;
    
    otherLinkVideoItem.channelID = publishID;
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [otherLinkVideoItem.videoView  addGestureRecognizer:singleTapGestureRecognizer];
    [self layoutOtherVideo];
}

- (void)OnRtcRemoveRemoteView:(NSString*)publishID
{
    if (otherLinkVideoItem.videoView.superview) {
        [otherLinkVideoItem.videoView removeFromSuperview];
    }
    otherLinkVideoItem = nil;
}
- (void)OnRtcLiveUserMsg:(NSString*)nsCustomId withCustomName:(NSString *)nsCustomName withContent:(NSString *)nsContent
{
    if (_messageView) {
        [_messageView receiveMessage:nsContent withUserId:nsCustomName withHeadPath:nil];
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
