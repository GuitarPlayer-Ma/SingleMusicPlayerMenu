//
//  CALayer+JSJAnimate.m
//  QQ音乐
//
//  Created by mada on 15/9/11.
//  Copyright (c) 2015年 MD. All rights reserved.
//

#import "CALayer+JSJAnimate.h"

@implementation CALayer (JSJAnimate)
- (void)pauseAnimate
{
    // 暂停时的时间
    NSTimeInterval pauseTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    // 速度为0即动画停止
    self.speed = 0.0;
    self.timeOffset = pauseTime;
}

- (void)resumeAnimate
{
    // 拿到上次暂停的时间
    NSTimeInterval pauseTime = self.timeOffset;
    self.speed = 1.0;
    self.timeOffset = 0.0;
    self.beginTime = 0.0;
    // 离暂停时间实际过去的动画时间
    NSTimeInterval timeSincePause = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pauseTime;
    self.beginTime = timeSincePause;
}

@end
