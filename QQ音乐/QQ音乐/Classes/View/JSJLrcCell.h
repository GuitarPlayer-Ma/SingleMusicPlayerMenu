//
//  JSJLrcCell.h
//  QQ音乐
//
//  Created by mada on 15/9/11.
//  Copyright (c) 2015年 MD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JSJLrcLabel;

@interface JSJLrcCell : UITableViewCell
+ (instancetype)lrcCellWithTableView:(UITableView *)tableView;

/** 歌词的Label */
@property (strong, nonatomic) JSJLrcLabel *lrcLabel;

@end
