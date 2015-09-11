//
//  JSJLrcTool.m
//  QQ音乐
//
//  Created by mada on 15/9/11.
//  Copyright (c) 2015年 MD. All rights reserved.
//

#import "JSJLrcTool.h"
#import "JSJLrcLine.h"

@implementation JSJLrcTool
+ (NSArray *)lrcToolWithLrcName:(NSString *)lrcName
{
    NSString *lrcPath = [[NSBundle mainBundle] pathForResource:lrcName ofType:nil];
    
    NSString *lrcStr = [NSString stringWithContentsOfFile:lrcPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *lrcArray = [lrcStr componentsSeparatedByString:@"\n"];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *lrcLineString in lrcArray) {
        // 过滤掉一些无用的信息
        if ([lrcLineString hasPrefix:@"[ti:"] || [lrcLineString hasPrefix:@"[ar:"] || [lrcLineString hasPrefix:@"[al:"] || ![lrcLineString hasPrefix:@"["]) {
            continue;
        }
        // 转换为模型
        JSJLrcLine *lrcLine = [JSJLrcLine lrcLineWithLrcString:lrcLineString];
        [tempArray addObject:lrcLine];
    }
    return tempArray;
}

@end
