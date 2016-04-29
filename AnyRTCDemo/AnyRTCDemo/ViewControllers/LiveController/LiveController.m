//
//  LiveController.m
//  AnyRTCDemo
//
//  Created by jianqiangzhang on 16/4/26.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "LiveController.h"
#import "UIColor+Category.h"
#import "HostViewController.h"
#import "GuestViewController.h"
#import <Masonry/Masonry.h>

@interface LiveController ()
@property (nonatomic, strong) UIButton *hostButton;
@property (nonatomic, strong) UIButton *guestButton;
@end

@implementation LiveController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"直播";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.hostButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.hostButton setTitle:@"发布直播" forState:UIControlStateNormal];
    self.hostButton.layer.cornerRadius = 24;
    self.hostButton.backgroundColor = [UIColor colorWithHexString:@"2fcf6f"];
    [self.hostButton addTarget:self action:@selector(hostButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.hostButton];
    
    self.guestButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.guestButton setTitle:@"观看直播" forState:UIControlStateNormal];
    self.guestButton.layer.cornerRadius = 24;
    self.guestButton.backgroundColor = [UIColor colorWithHexString:@"2fcf6f"];
    [self.guestButton addTarget:self action:@selector(guestButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.guestButton];
    
    __weak LiveController *weakSelf = self;
    [self.hostButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.equalTo(@50);
        make.centerY.equalTo(weakSelf.view.mas_centerY).multipliedBy(.8);
    }];
    
    [self.guestButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.equalTo(weakSelf.hostButton.mas_height);
        make.top.equalTo(weakSelf.hostButton.mas_bottom).offset(30);
    }];

}
- (void)hostButtonEvent:(UIButton*)button
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    HostViewController *hostViewController = [storyBoard instantiateViewControllerWithIdentifier:@"hostViewController"];
    
    [self presentViewController:hostViewController animated:YES completion:nil];
}
- (void)guestButtonEvent:(UIButton *)button
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    GuestViewController *hostViewController = [storyBoard instantiateViewControllerWithIdentifier:@"guestViewController"];
    [self presentViewController:hostViewController animated:YES completion:nil];
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
