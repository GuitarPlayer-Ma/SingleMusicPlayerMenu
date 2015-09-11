//
//  JSJLrcView.h
//  QQ音乐
//
//  Created by mada on 15/9/11.
//  Copyright (c) 2015年 MD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JSJLrcLabel;

@interface JSJLrcView : UIScrollView
/** 歌词 */
@property (copy, nonatomic) NSString *lrcname;

/** 播放时间 */
@property (assign, nonatomic) NSTimeInterval currentTime;

/** 非歌词界面的歌词label */
@property (strong, nonatomic) JSJLrcLabel *lrcLabel;
@end
