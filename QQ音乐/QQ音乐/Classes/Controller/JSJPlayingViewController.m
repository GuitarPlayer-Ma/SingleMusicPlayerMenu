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
#import "NSString+JSJTime.h"
#import "CALayer+JSJAnimate.h"
#import "JSJLrcView.h"
#import "JSJLrcLabel.h"

#import <Masonry.h>
#import <MediaPlayer/MediaPlayer.h>

@interface JSJPlayingViewController ()<AVAudioPlayerDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UISlider *progressView;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *startOrPauseButton;
@property (weak, nonatomic) IBOutlet JSJLrcView *lrcView;
@property (weak, nonatomic) IBOutlet JSJLrcLabel *lrcLabel;

/** 进度条定时器 */
@property (strong, nonatomic) NSTimer *progressTimer;
/** 进度条定时器 */
@property (strong, nonatomic) CADisplayLink *lrcTimer;
@property (strong, nonatomic) AVAudioPlayer *currentPlayer;


@end

@implementation JSJPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 给背景图片添加毛玻璃效果
    [self setupBlurGlassView];
    
    // 改变进度条样式
    [self.progressView setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    
    // 播放音乐
    [self beginPlayingMusic];
    
    // 设置LvcView
    self.lrcView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, 0);
    self.lrcView.delegate = self;
    self.lrcView.lrcLabel = self.lrcLabel;
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

#pragma mark - 开始播放音乐
- (void)beginPlayingMusic
{
    // 设置播放按钮状态
    self.startOrPauseButton.selected = YES;
    
    // 拿到当前播放的歌曲
    JSJMusic *playingMusic = [JSJMusicTool playingMusic];
    
    // 设置界面信息
    self.songNameLabel.text = playingMusic.name;
    self.singerLabel.text = playingMusic.singer;
    self.iconView.image = [UIImage imageNamed:playingMusic.icon];
    self.backImageView.image = [UIImage imageNamed:playingMusic.icon];
    self.lrcView.lrcname = playingMusic.lrcname;
    
    // 播放音乐
    AVAudioPlayer *player = [JSJAudioTool playMusicWithMusicName:playingMusic.filename];
    self.currentPlayer = player;
    self.currentPlayer.delegate = self;
    self.totalTimeLabel.text = [NSString stringWithTime:player.duration];
    self.currentTimeLabel.text = [NSString stringWithTime:player.currentTime];
    
    // 给iconView添加动画
    [self addIconViewAnimate];
    
    // 添加进度条定时器
    [self addProgressTimer];
    
    // 添加歌词定时器
    [self addLrcTimer];
    
    // 设置锁屏界面的信息
    [self setupLockScreenInfomationWithPlayingMusic:playingMusic];
}

- (void)addIconViewAnimate
{
    CABasicAnimation *rotationAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnim.fromValue = @(0);
    rotationAnim.toValue = @(M_PI * 2);
    rotationAnim.repeatCount = CGFLOAT_MAX;
    rotationAnim.duration = 35.0;
    [self.iconView.layer addAnimation:rotationAnim forKey:nil];
}

- (void)setupLockScreenInfomationWithPlayingMusic:(JSJMusic *)playingMusic
{
    // 获取锁屏中心
    MPNowPlayingInfoCenter *infoCenter = [MPNowPlayingInfoCenter defaultCenter];
    // 设置锁屏界面信息
    NSMutableDictionary *playingInfo = [NSMutableDictionary dictionary];
    playingInfo[MPMediaItemPropertyAlbumTitle] = playingMusic.name;
    playingInfo[MPMediaItemPropertyArtist] = playingMusic.singer;
    playingInfo[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:playingMusic.icon]];
    playingInfo[MPMediaItemPropertyPlaybackDuration] = @(self.currentPlayer.duration);
    infoCenter.nowPlayingInfo = playingInfo;
    // 让应用程序可以接受远程事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

// 监听远程事件
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
            [self startOrPause:nil];
            break;
            
        case UIEventSubtypeRemoteControlNextTrack:
            [self nextMusic];
            break;
            
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self previousMusic];
            break;
            
        default:
            break;
    }
}


#pragma mark - 设置定时器
- (void)addProgressTimer
{
    [self updateProgressInfo];
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)addLrcTimer
{
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrc)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)removeLrcTimer
{
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}

#pragma mark - 跟新信息
- (void)updateProgressInfo
{
    self.currentTimeLabel.text = [NSString stringWithTime:self.currentPlayer.currentTime];
    
    self.progressView.value = self.currentPlayer.currentTime / self.currentPlayer.duration;
}

- (void)updateLrc
{
    self.lrcView.currentTime = self.currentPlayer.currentTime;
}

#pragma mark - 滑块事件监听
- (IBAction)startClick {
    [self removeProgressTimer];
}
- (IBAction)endClick {
    self.currentPlayer.currentTime = self.progressView.value * self.currentPlayer.duration;
    [self addProgressTimer];
}
- (IBAction)sliderValueChange {
    self.currentTimeLabel.text = [NSString stringWithTime:self.progressView.value * self.currentPlayer.duration];
}
// 单击进度条
- (IBAction)sliderClick:(UIGestureRecognizer *)gestureRecognizer {
    // 单击的点位置
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGFloat ratio = point.x / self.progressView.bounds.size.width;
    // 获取当前歌曲的播放时间
    NSTimeInterval currentTime = ratio * self.currentPlayer.duration;
    self.currentPlayer.currentTime = currentTime;
    [self updateProgressInfo];
}

#pragma mark - 播放控制台按钮点击监听
// 点击播放和暂停按钮
- (IBAction)startOrPause:(UIButton *)sender {
    self.startOrPauseButton.selected = !self.startOrPauseButton.isSelected;
    if (!self.startOrPauseButton.isSelected) { // 暂停状态
        // 暂停歌曲
        [self.currentPlayer pause];
        // 移除定时器
        [self removeProgressTimer];
        // 暂停动画
        [self.iconView.layer pauseAnimate];
    }
    else {
        [self.currentPlayer play];
        [self addProgressTimer];
        [self.iconView.layer resumeAnimate];
    }
}
// 下一首
- (IBAction)nextMusic {
    [self changeMusicWithNewMusic:[JSJMusicTool nextMusic]];
}
// 上一首
- (IBAction)previousMusic {
    [self changeMusicWithNewMusic:[JSJMusicTool previousMusic]];
}

- (void)changeMusicWithNewMusic:(JSJMusic *)newMusic
{
    // 暂停当前播放的歌曲
//    [self.currentPlayer stop];
    JSJMusic *playingMusic = [JSJMusicTool playingMusic];
    [JSJAudioTool stopMusicWithMusicName:playingMusic.filename];
    
    // 设置为播放的歌曲
    [JSJMusicTool setPlayingMusic:newMusic];
    // 开始播放
    [self beginPlayingMusic];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        [self nextMusic];
    }
}

#pragma mark - 歌词view的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat alpha = scrollView.contentOffset.x / self.view.bounds.size.width;
    self.lrcLabel.alpha = 1 - alpha;
    self.iconView.alpha = 1 - alpha;
}

@end
