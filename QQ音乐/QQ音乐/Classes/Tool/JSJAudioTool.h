//
//  JSJAudioTool.h
//  02-播放音效
//
//  Created by mada on 15/9/9.
//  Copyright (c) 2015年 MD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSJAudioTool : NSObject
/** 播放音效 */
+ (void)playSoundWithSoundName:(NSString *)soundName;
/** 播放音乐 */
+ (void)playMusicWithMusicName:(NSString *)musicName;
/** 暂停播放音乐 */
+ (void)pauseMusicWithMusicName:(NSString *)musicName;
/** 停止播放音乐 */
+ (void)stopMusicWithMusicName:(NSString *)musicName;
@end
