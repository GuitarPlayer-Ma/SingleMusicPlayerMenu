//
//  JSJMusicTool.h
//  QQ音乐
//
//  Created by mada on 15/9/10.
//  Copyright (c) 2015年 MD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JSJMusic;

@interface JSJMusicTool : NSObject
+ (NSArray *)musics;
/** 设置播放的歌曲 */
+ (void)setPlayingMusic:(JSJMusic *)playingMusic;
/** 返回正在播放的歌曲 */
+ (JSJMusic *)playingMusic;
/** 返回上一首播放的歌曲 */
+ (JSJMusic *)previousMusic;
/** 返回下一首播放的歌曲 */
+ (JSJMusic *)nextMusic;
@end
