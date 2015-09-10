//
//  JSJPlayingViewController.m
//  QQ音乐
//
//  Created by mada on 15/9/10.
//  Copyright (c) 2015年 MD. All rights reserved.
//

#import "JSJPlayingViewController.h"
#import "JSJMusic.h"
#import "JSJAudioTool.h"
#import "JSJMusicTool.h"
#import <Masonry.h>

@interface JSJPlayingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation JSJPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 给背景图片添加毛玻璃效果
    [self setupBlurGlassView];
    
    // 播放音乐
    [self beginPlayingMusic];
}

- (void)setupBlurGlassView
{
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    toolBar.barStyle = UIBarStyleBlack;
    // 添加约束
    toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backImageView addSubview:toolBar];
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backImageView);
    }];
}

- (void)beginPlayingMusic
{
    // 拿到当前播放的歌曲
    JSJMusic *playingMusic = [JSJMusicTool playingMusic];
    [JSJAudioTool playMusicWithMusicName:playingMusic.filename];
}

// 更改状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// 设置小头像为圆形
- (void)viewWillLayoutSubviews
{
    self.iconView.layer.cornerRadius = self.iconView.bounds.size.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.borderWidth = 7;
    self.iconView.layer.borderColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1.0].CGColor;
}

@end
