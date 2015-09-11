//
//  JSJMusicTool.m
//  QQ音乐
//
//  Created by mada on 15/9/10.
//  Copyright (c) 2015年 MD. All rights reserved.
//

#import "JSJMusicTool.h"
#import "JSJMusic.h"
#import <MJExtension.h>

@implementation JSJMusicTool

static NSArray *_musics;
static JSJMusic *_playingMusic;

+ (void)initialize
{
    // 初始化数组
    _musics = [JSJMusic objectArrayWithFilename:@"Musics.plist"];
    // 设置默认播放的歌曲
    _playingMusic = _musics[0];
}

+ (NSArray *)musics
{
    return _musics;
}

+ (void)setPlayingMusic:(JSJMusic *)playingMusic
{
    _playingMusic = playingMusic;
}

+ (JSJMusic *)playingMusic
{
    return _playingMusic;
}

+ (JSJMusic *)previousMusic
{
    NSInteger index = [_musics indexOfObject:_playingMusic];
    NSInteger previousIndex = index - 1;
    if (previousIndex < 0) {
        previousIndex = _musics.count - 1;
    }
    JSJMusic *previousMusic = [_musics objectAtIndex:previousIndex];
    return previousMusic;
}

+ (JSJMusic *)nextMusic
{
    NSInteger index = [_musics indexOfObject:_playingMusic];
    NSInteger nextIndex = index + 1;
    if (nextIndex > _musics.count - 1) {
        nextIndex = 0;
    }
    JSJMusic *nextMusic = _musics[nextIndex];
    return nextMusic;
}

@end
