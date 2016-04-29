//
//  TalkManagerView.h
//  AnyRTCDemo
//
//  Created by jianqiangzhang on 16/4/28.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TalkManagerViewDelegate<NSObject>
- (void)sendMessageTo:(NSString*)message;
@end


@interface TalkManagerView : UIView

@property (nonatomic, weak)id<TalkManagerViewDelegate>delegate;
@property (nonatomic, strong) NSString * nikeName;



- (void)registerEdit;

- (id)initWithFrame:(CGRect)frame WithInputView:(BOOL)isShowInputView;

- (void)receiveMessage:(NSString*)message withUserId:(NSString*)userID withHeadPath:(NSString*)iconPath;

@end
