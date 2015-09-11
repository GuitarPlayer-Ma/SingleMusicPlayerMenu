//
//  CALayer+JSJAnimate.h
//  QQ音乐
//
//  Created by mada on 15/9/11.
//  Copyright (c) 2015年 MD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (JSJAnimate)
/** 暂停动画 */
- (void)pauseAnimate;
/** 继续动画 */
- (void)resumeAnimate;
@end
