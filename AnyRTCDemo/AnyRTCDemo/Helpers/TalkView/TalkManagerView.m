//
//  TalkManagerView.m
//  AnyRTCDemo
//
//  Created by jianqiangzhang on 16/4/28.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "TalkManagerView.h"
#import "TalkView.h"
#import <Masonry/Masonry.h>
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@interface TalkManagerView()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIView *textInputbar;

@property (nonatomic, strong) TalkView *talkView;

@property (strong, nonatomic) NSLayoutConstraint *constraintBotton;

@property (nonatomic) BOOL isEdit;

@end

@implementation TalkManagerView

- (id)initWithFrame:(CGRect)frame WithInputView:(BOOL)isShowInputView;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self withInputView:isShowInputView];
        
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
        [singleTapGestureRecognizer setNumberOfTapsRequired:1];
        [self addGestureRecognizer:singleTapGestureRecognizer];
    }
    return self;
}
- (void)withInputView:(BOOL)isShowInputView
{
    if (isShowInputView) {
        [self registerNotifications];
        [self addSubview:self.textInputbar];
        [self.textInputbar addSubview:self.textField];
        
        self.textInputbar.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *constatint = [NSLayoutConstraint constraintWithItem:self.textInputbar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *constatint1 = [NSLayoutConstraint constraintWithItem:self.textInputbar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:44];
        NSLayoutConstraint *constatint2 = [NSLayoutConstraint constraintWithItem:self.textInputbar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        _constraintBotton = [NSLayoutConstraint constraintWithItem:self.textInputbar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        [self addConstraints:@[constatint,constatint1,constatint2,_constraintBotton]];
        
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textInputbar.mas_top).offset(5);
            make.left.equalTo(self.textInputbar.mas_left).offset(5);
            make.right.equalTo(self.textInputbar.mas_right).offset(-5);
            make.bottom.equalTo(self.textInputbar.mas_bottom).offset(-5);
        }];
        
        self.talkView = [[TalkView alloc] initWithFrame:CGRectZero];
        self.talkView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.talkView];
        
        [self.talkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(0);
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.bottom.equalTo(self.textInputbar.mas_top).offset(0);
        }];
        
    }else{
        self.talkView = [[TalkView alloc] initWithFrame:CGRectZero];
        self.talkView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.talkView];
        [self.talkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
    }
}
// 点击
- (void)singleTap:(UITapGestureRecognizer*)gesture
{
    if (self.isEdit) {
        [self.textField resignFirstResponder];
    }
}

- (UIView*)textInputbar
{
    if (!_textInputbar) {
        _textInputbar = [UIView new];
        _textInputbar.backgroundColor = RGBCOLOR(244, 244, 244);
    }
    return _textInputbar;
}

- (UITextField*)textField
{
    if (!_textField) {
        _textField = [UITextField new];
        _textField.backgroundColor = RGBCOLOR(220, 220, 220);
        _textField.layer.cornerRadius = 5;
        _textField.placeholder = @"请输入消息哦";
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeySend;
    }
    return _textField;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)receiveMessage:(NSString*)message withUserId:(NSString*)userID withHeadPath:(NSString*)iconPath
{
    if (self.talkView) {
        [self.talkView receiveMessageView:message withUser:userID withHeadPath:iconPath];
    }
}


- (void)registerNotifications
{
    // Keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}
- (void)sendTextMessage:(NSString*)text
{
    if (self.talkView) {
        [self.talkView sendMessageView:text withUser:_nikeName];
    }
}

#pragma mark - Notification Events

- (void)adjustTextViewByKeyboardState:(BOOL)showKeyboard keyboardInfo:(NSDictionary *)info {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    // transform the UIViewAnimationCurve to a UIViewAnimationOptions mask
    UIViewAnimationCurve animationCurve = [info[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    UIViewAnimationOptions animationOptions = UIViewAnimationOptionBeginFromCurrentState;
    if (animationCurve == UIViewAnimationCurveEaseIn) {
        animationOptions |= UIViewAnimationOptionCurveEaseIn;
    }
    else if (animationCurve == UIViewAnimationCurveEaseInOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseInOut;
    }
    else if (animationCurve == UIViewAnimationCurveEaseOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseOut;
    }
    else if (animationCurve == UIViewAnimationCurveLinear) {
        animationOptions |= UIViewAnimationOptionCurveLinear;
    }
    
    
    if (showKeyboard) {
        
        NSValue *keyboardFrameVal = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = [keyboardFrameVal CGRectValue];
        CGFloat height = keyboardFrame.size.height;
        
        _constraintBotton.constant = -height;
    }
    else {
        _constraintBotton.constant = 0;
        
    }
    
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:([info[UIKeyboardAnimationCurveUserInfoKey] integerValue]<<16)|UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self layoutIfNeeded];
                         [self.talkView animationlayoutSubviews];
                     }
                     completion:NULL];
    
}
- (void)registerEdit
{
    if (_isEdit) {
        [self.textField resignFirstResponder];
    }
}
- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    _isEdit = YES;
    NSDictionary *userInfo = [notification userInfo];
    [self adjustTextViewByKeyboardState:YES keyboardInfo:userInfo];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
     _isEdit = NO;
    NSDictionary *userInfo = [notification userInfo];
    [self adjustTextViewByKeyboardState:NO keyboardInfo:userInfo];
}

#pragma mark -  UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length <= 0) return NO;
    if(_delegate && [_delegate respondsToSelector:@selector(sendMessageTo:)])
    {
        [_delegate sendMessageTo:textField.text];
    }
    [self sendTextMessage:textField.text];
    textField.text = @"";
    
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
