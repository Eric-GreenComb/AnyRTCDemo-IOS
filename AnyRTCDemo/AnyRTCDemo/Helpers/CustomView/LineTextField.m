//
//  LineTextField.m
//  AnyRTCDemo
//
//  Created by jianqiangzhang on 16/4/7.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "LineTextField.h"
@interface LineTextField()
@end

@implementation LineTextField

- (id)init
{
    self = [super init];
    if (self) {
        _lineWidth = 2;
        _lineColor = [UIColor blackColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.tintColor = _lineColor;//设置光标颜色
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, _lineWidth);  //线宽
    CGContextSetAllowsAntialiasing(context, true);
//    CGContextSetRGBStrokeColor(context, _lineColor);  //线的颜色
    [_lineColor setStroke];
    //设置边框颜色
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, 0, rect.size.height);  //起点坐标
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);   //终点坐标
    
    CGContextStrokePath(context);
}


@end
