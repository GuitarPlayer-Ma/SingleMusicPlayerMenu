//
//  JSJAudioTool.m
//  02-播放音效
//
//  Created by mada on 15/9/9.
//  Copyright (c) 2015年 MD. All rights reserved.
//

#import "JSJAudioTool.h"
#import <AVFoundation/AVFoundation.h>

static NSMutableDictionary *_soundIDs;

static NSMutableDictionary *_audioPlayers;

@implementation JSJAudioTool

+ (void)initialize
{
    _soundIDs = [NSMutableDictionary dictionary];
    _audioPlayers = [NSMutableDictionary dictionary];
}

+ (void)playSoundWithSoundName:(NSString *)soundName
{
    // 从字典中取出音效ID
    SystemSoundID soundID = [_soundIDs[soundName] unsignedIntValue];
    if (!soundID) {
        // 如果soundID没有值就创建
        CFURLRef url = (__bridge CFURLRef)[[NSBundle mainBundle] URLForResource:soundName withExtension:nil];
        [_soundIDs setObject:@(soundID) forKey:soundName];
        AudioServicesCreateSystemSoundID(url, &soundID);
    }
    AudioServicesPlayAlertSound(soundID);
}

+ (AVAudioPlayer *)playMusicWithMusicName:(NSString *)musicName
{
    // 从字典中取出AVAudioPlayer
    AVAudioPlayer *audioPlayer = _audioPlayers[musicName];
    if (!audioPlayer) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:musicName withExtension:nil];
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        // 将播放器放在字典中
        [_audioPlayers setObject:audioPlayer forKey:musicName];
    }
    [audioPlayer play];
    
    return audioPlayer;
}

+ (void)pauseMusicWithMusicName:(NSString *)musicName
{
    // 取出播放器
    AVAudioPlayer *audioPlayer = _audioPlayers[musicName];
    if (audioPlayer) {
        [audioPlayer pause];
    }
}

+ (void)stopMusicWithMusicName:(NSString *)musicName
{
    // 取出播放器
    AVAudioPlayer *audioPlayer = _audioPlayers[musicName];
    if (audioPlayer) {
        [audioPlayer stop];
        [_audioPlayers removeObjectForKey:musicName];
        audioPlayer = nil;
    }
}

@end
