//
//  ViewController.m
//  AnyRTCDemo
//
//  Created by jianqiangzhang on 16/4/7.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "UIColor+Category.h"
#import "InputMeetingIdController.h"
#import "ASHUD.h"
#import "LiveController.h"

@interface ViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) UIButton *liveButton;
@property (nonatomic, strong) UIButton *multiButton;
@property (nonatomic, strong) UIButton *sigleButton;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.multiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.multiButton setTitle:@"视频通话" forState:UIControlStateNormal];
    self.multiButton.layer.cornerRadius = 24;
    self.multiButton.backgroundColor = [UIColor colorWithHexString:@"2fcf6f"];
    [self.multiButton addTarget:self action:@selector(multiButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.multiButton];
    
    self.liveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.liveButton setTitle:@"视频直播" forState:UIControlStateNormal];
    self.liveButton.layer.cornerRadius = 24;
    self.liveButton.backgroundColor = [UIColor colorWithHexString:@"2fcf6f"];
    [self.liveButton addTarget:self action:@selector(liveButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.liveButton];
    
    self.sigleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sigleButton setTitle:@"音频通话" forState:UIControlStateNormal];
    self.sigleButton.layer.cornerRadius = 24;
    self.sigleButton.backgroundColor = [UIColor colorWithHexString:@"2fcf6f"];
    [self.sigleButton addTarget:self action:@selector(sigleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sigleButton];
    
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"AnyRTC";
    titleLabel.font = [UIFont boldSystemFontOfSize:48];
    [self.view addSubview:titleLabel];
    
    UILabel *powerLabel = [UILabel new];
    powerLabel.textAlignment = NSTextAlignmentCenter;
    powerLabel.numberOfLines = 0;
    powerLabel.text = @"Powered by Shanghai Boyuan(DYNC) Electronic Technology CO.,LTD";
    powerLabel.font = [UIFont systemFontOfSize:9];
    [self.view addSubview:powerLabel];
    
    
    __weak ViewController *weakSelf = self;
    [self.multiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.equalTo(@50);
        make.center.equalTo(weakSelf.view);
    }];
    
    [self.liveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.equalTo(weakSelf.multiButton.mas_height);
        make.bottom.equalTo(weakSelf.multiButton.mas_top).offset(-20);
    }];
    
    [self.sigleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.equalTo(weakSelf.multiButton.mas_height);
        make.top.equalTo(weakSelf.multiButton.mas_bottom).offset(20);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.equalTo(@65);
        make.bottom.equalTo(weakSelf.liveButton.mas_top).offset(-25);
    }];
    
    [powerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.equalTo(@40);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-10);
    }];
    
}

#pragma mark button methods
- (void)multiButtonEvent:(UIButton*)button
{
    InputMeetingIdController *inputMeetingController = [InputMeetingIdController new];
    inputMeetingController.isVideo = YES;
    [self.navigationController pushViewController:inputMeetingController animated:YES];
}
- (void)liveButtonEvent:(UIButton*)button
{
    LiveController *liveController = [LiveController new];
    [self.navigationController pushViewController:liveController animated:YES];
    
}
- (void)sigleButtonEvent:(UIButton*)button
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"音频通话功能暂未开放" message:@"请拨打 021-65650071,进行咨询" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
//    InputMeetingIdController *inputMeetingController = [InputMeetingIdController new];
//    inputMeetingController.isVideo = NO;
//    [self.navigationController pushViewController:inputMeetingController animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"021-65650071"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
