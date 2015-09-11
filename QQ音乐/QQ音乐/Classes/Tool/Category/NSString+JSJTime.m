//
//  NSString+JSJTime.m
//  QQ音乐
//
//  Created by mada on 15/9/11.
//  Copyright (c) 2015年 MD. All rights reserved.
//

#import "NSString+JSJTime.h"

@implementation NSString (JSJTime)
+ (instancetype)stringWithTime:(NSTimeInterval)time
{
    NSInteger minute = time / 60;
    NSInteger second = (NSInteger)time % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", minute, second];
}
@end
