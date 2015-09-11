//
//  JSJLrcView.m
//  QQ音乐
//
//  Created by mada on 15/9/11.
//  Copyright (c) 2015年 MD. All rights reserved.
//

#import "JSJLrcView.h"
#import <Masonry.h>
#import "JSJLrcTool.h"
#import "JSJLrcLine.h"
#import "JSJLrcCell.h"
#import "JSJLrcLabel.h"

@interface JSJLrcView()<UITableViewDataSource>

@property (weak, nonatomic) UITableView *tableView;
/** 歌词数据 */
@property (strong, nonatomic) NSArray *lrcList;
/** 当前播放的行 */
@property (assign, nonatomic) NSInteger currentIndex;
@end

@implementation JSJLrcView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupTableView];
    }
    return self;
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.rowHeight = 35;
    [self addSubview:tableView];
    self.tableView = tableView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.height.equalTo(self.mas_height);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(self.bounds.size.width);
        make.width.equalTo(self.mas_width);
        make.right.equalTo(self.mas_right);
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(self.bounds.size.height * 0.5, 0, self.bounds.size.height * 0.5, 0);
}

- (void)setLrcname:(NSString *)lrcname
{
    _lrcname = [lrcname copy];
    self.lrcList = [JSJLrcTool lrcToolWithLrcName:lrcname];
    [self.tableView reloadData];
}

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    _currentTime = currentTime;
    
    NSInteger count = self.lrcList.count;
    for (int i = 0; i < count; i++) {
        // 取出当前句的歌词
        JSJLrcLine *currentLrcLine = self.lrcList[i];
        // 取出下一句的歌词
        NSInteger index = i + 1;
        // 确保不要越界
        if (index > count - 1) {
            return;
        }
        JSJLrcLine *nextLrcLine = self.lrcList[index];
        
        // 比较时间(最后一个判断的作用能避免多次执行if语句)
        if (currentTime >= currentLrcLine.time && currentTime < nextLrcLine.time && self.currentIndex != i) {
            // 刷新前一行
            NSMutableArray *indexs = [NSMutableArray array];
            if (self.currentIndex < count - 1) {
                [indexs addObject:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
            }
            self.currentIndex = i;
            NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [indexs addObject:currentIndexPath];
            // 刷新歌词
            [self.tableView reloadRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationNone];
            // 歌词位置
            [self.tableView scrollToRowAtIndexPath:currentIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            // 更新外面界面的歌词
            self.lrcLabel.text = currentLrcLine.text;
        }
        if (self.currentIndex == i) {
            // 取出i位置的cell
            JSJLrcCell *cell = (JSJLrcCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            // 更新进度
            cell.lrcLabel.progress = (currentTime - currentLrcLine.time) / (nextLrcLine.time - currentLrcLine.time);
            // 更新外面歌词的进度
            self.lrcLabel.progress =  (currentTime - currentLrcLine.time) / (nextLrcLine.time - currentLrcLine.time);
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSJLrcCell *cell = [JSJLrcCell lrcCellWithTableView:tableView];
    if (indexPath.row == self.currentIndex) {
        cell.lrcLabel.font = [UIFont systemFontOfSize:18.0];
    }
    else {
        cell.lrcLabel.font = [UIFont systemFontOfSize:14.0];
        cell.lrcLabel.progress = 0;
    }
    JSJLrcLine *lrcLine = self.lrcList[indexPath.row];
    cell.lrcLabel.text = lrcLine.text;
    return cell;
}

@end
