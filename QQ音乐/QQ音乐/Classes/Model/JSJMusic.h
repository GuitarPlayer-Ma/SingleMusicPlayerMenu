//
//  JSJMusic.h
//  QQ音乐
//
//  Created by mada on 15/9/10.
//  Copyright (c) 2015年 MD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSJMusic : NSObject

/** 歌曲名 */
@property (copy, nonatomic) NSString *name;
/** 文件名 */
@property (copy, nonatomic) NSString *filename;
/** 歌词名 */
@property (copy, nonatomic) NSString *lrcname;
/** 歌手 */
@property (copy, nonatomic) NSString *singer;
/** 歌手头像 */
@property (copy, nonatomic) NSString *singericon;
/** 歌手大头像 */
@property (copy, nonatomic) NSString *icon;


@end
