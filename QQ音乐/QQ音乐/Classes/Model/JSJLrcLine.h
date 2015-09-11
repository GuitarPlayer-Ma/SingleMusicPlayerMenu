//
//  JSJLrcLine.h
//  QQ音乐
//
//  Created by mada on 15/9/11.
//  Copyright (c) 2015年 MD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSJLrcLine : NSObject
/** 歌词 */
@property (copy, nonatomic) NSString *text;
/** 时长 */
@property (assign, nonatomic) NSTimeInterval time;

- (instancetype)initWithLrcString:(NSString *)lrcString;
+ (instancetype)lrcLineWithLrcString:(NSString *)lrcString;
@end
