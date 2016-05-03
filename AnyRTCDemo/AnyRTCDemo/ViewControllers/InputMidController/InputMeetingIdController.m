//
//  InputMeetingIdController.m
//  AnyRTCDemo
//
//  Created by jianqiangzhang on 16/4/7.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "InputMeetingIdController.h"
#import "UIColor+Category.h"
#import <Masonry/Masonry.h>
#import "LineTextField.h"
#import "CallAudioController.h"
#import "CallVideoController.h"

@interface InputMeetingIdController ()
@property (nonatomic, strong) LineTextField *textField;
@property (nonatomic, strong) UIButton *chatButton;
@end

@implementation InputMeetingIdController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    if (self.isVideo) {
        self.title = @"视频通话";
    }else{
        self.title = @"音频通话";
    }
    self.textField = [LineTextField new];
    self.textField.lineColor = [UIColor colorWithHexString:@"2fcf6f"];
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.placeholder = @"会议ID(需要在平台上申请或者服务对接生产)";
#warning Warning 测试会议号，是开发者在平台上生产测试的，也可以服务对接来生产anyrtcID
    // 平台上的测试账号（服务对接才能得到该会议号）
//    self.textField.text = @"xxx";
     NSLog(@"请到平台上申请测试的anyrtcID，或者服务对接生成房间号");
    self.textField.text = @"800000000014";
    self.textField.textColor = [UIColor colorWithHexString:@"2fcf6f"];
    [self.textField setValue:[UIColor colorWithHexString:@"2fcf6f"] forKeyPath:@"_placeholderLabel.textColor"];
    self.textField.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:self.textField];
    
    
    self.chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chatButton setTitle:@"聊天" forState:UIControlStateNormal];
    self.chatButton.layer.cornerRadius = 24;
    self.chatButton.backgroundColor = [UIColor colorWithHexString:@"2fcf6f"];
    [self.chatButton addTarget:self action:@selector(chatButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.chatButton];
    
    __weak InputMeetingIdController *weakSelf = self;
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.equalTo(@45);
        make.centerY.equalTo(weakSelf.view.mas_centerY).multipliedBy(.65);
    }];
    
    [self.chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.equalTo(@45);
        make.centerY.equalTo(weakSelf.view.mas_centerY).multipliedBy(1.25);
    }];
    
}

- (void)chatButtonEvent:(UIButton*)button
{
    if (self.isVideo) {
        UIStoryboard *stroryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        CallVideoController *videoController = [stroryboard instantiateViewControllerWithIdentifier:@"videoController"];
        
        videoController.anyrtcID = self.textField.text;
        [self presentViewController:videoController animated:YES completion:nil];
    }else{
        CallAudioController *audioController = [CallAudioController new];
        UINavigationController *audioNav = [[UINavigationController alloc] initWithRootViewController:audioController];
        [self presentViewController:audioNav animated:YES completion:nil];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.textField.isEditing) {
        [self.textField resignFirstResponder];
    }
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
