//
//  YTPlayerViewController.h
//  dexotrip
//
//  Created by kevin on 16/8/4.
//  Copyright © 2016年 kevin. All rights reserved.
//

#import "ViewController.h"
#import "VoiceModel.h"
@interface YTPlayerViewController : ViewController

- (instancetype)getControllerWithId:(NSString *)audioIdString AudioType:(NSString *)type;
/**
 *  播放器单例
 *
 *  @return YTPlayerViewController
 */
+ (YTPlayerViewController *)shareInstance;

/**
 *  队列
 *
 *  @param audiosArr 当前队列
 *  @param curRow    当前播放第几首歌
 *  @param type      音频类型
 */
- (void)playAudioWithArray:(NSArray *)audiosArr AndCurrentRow:(NSInteger)curRow AudioType:(NSString *)type;

/**
 *  队列
 *
 *  @param singeAudioModel 当前音频模型
 *  @param type      音频类型
 */

- (void)playSingleAudio:(VoiceModel *)singeAudioModel AudioType:(NSString *)type;

/**
 *  ID
 *
 *  @param audioIdString 当前ID
 *  @param type          音频类型
 */
- (void)playAnAudioId:(NSString *)audioIdString AudioType:(NSString *)type;

/**
    获取播放器实时模型
 */
- (VoiceModel *)playerCurrentModel;

/**
    获取播放器实时进度
 */
- (CGFloat)playerCurrentProgress;

/**
    重置播放器实时进度
 */
- (void)resetPlayerTime:(CGFloat)value;

@end
