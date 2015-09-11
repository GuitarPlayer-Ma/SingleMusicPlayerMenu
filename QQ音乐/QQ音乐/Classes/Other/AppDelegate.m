//
//  AppDelegate.m
//  QQ音乐
//
//  Created by mada on 15/9/10.
//  Copyright (c) 2015年 MD. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 获取音频会话
    AVAudioSession *session = [AVAudioSession sharedInstance];
    // 设置后台模式
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    // 激活后台模式
    [session setActive:YES error:nil];
    
    return YES;
}


@end
