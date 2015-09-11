//
//  JSJLrcLine.m
//  QQ音乐
//
//  Created by mada on 15/9/11.
//  Copyright (c) 2015年 MD. All rights reserved.
//

#import "JSJLrcLine.h"

@implementation JSJLrcLine

- (instancetype)initWithLrcString:(NSString *)lrcString
{
    if (self = [super init]) {
        self.text = [[lrcString componentsSeparatedByString:@"]"] lastObject];
        NSString *timeStr = [[[lrcString componentsSeparatedByString:@"]"] firstObject] substringFromIndex:1];
        self.time = [self timeWithString:timeStr];
    }
    return self;
}

- (NSTimeInterval)timeWithString:(NSString *)timeString
{
    // 分
    NSInteger minute = [[[timeString componentsSeparatedByString:@":"] firstObject] integerValue];
    // 秒
    NSInteger second = [[[[[timeString componentsSeparatedByString:@":"] lastObject] componentsSeparatedByString:@"."] firstObject] integerValue];
    // 毫秒
    NSInteger msec = [[[[[timeString componentsSeparatedByString:@":"] lastObject] componentsSeparatedByString:@"."] lastObject] integerValue];
    return minute * 60 + second + msec * 0.01;
}

+ (instancetype)lrcLineWithLrcString:(NSString *)lrcString
{
    return [[self alloc] initWithLrcString:lrcString];
}

@end
