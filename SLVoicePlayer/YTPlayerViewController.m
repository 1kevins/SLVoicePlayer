//
//  YTPlayerViewController.m
//  dexotrip
//
//  Created by kevin on 16/8/4.
//  Copyright © 2016年 kevin. All rights reserved.
//

// Controllers
#import "YTPlayerViewController.h"
// Views
#import "VoiceShowView.h"
#import "VoiceSliderView.h"
#import "PlayerScrollView.h"
#import<Masonry.h>
// Libs
#import "HysteriaPlayer.h"
// Others
#import <MediaPlayer/MediaPlayer.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+ImageEffects.h"

#define TopView_CloseButton_TAG      1010
#define TopView_ShareButton_TAG      1011

#define BottomView_Toggle_TAG        1012
#define BottomView_Pre_TAG           1013
#define BottomView_Next_TAG          1014

#define IPHONE_WIDTH [[UIScreen mainScreen] bounds].size.width
#define IPHONE_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define VOICEVIEWRATE (double)[[UIScreen mainScreen] bounds].size.height/667

@interface YTPlayerViewController ()<HysteriaPlayerDelegate,HysteriaPlayerDataSource>

// backView
@property (nonatomic, strong) UIImageView *backImgView;

// Medium
@property (nonatomic, strong) PlayerScrollView *yantuScrollView;
// VoiceSliderView
@property (nonatomic, strong) VoiceSliderView *sliderView;
@property (nonatomic, strong) UIButton *toggleButton;
@property (nonatomic, strong) UIButton *prevButton;
@property (nonatomic, strong) UIButton *nextButton;
@property(nonatomic,strong) UIProgressView * Progress;
@property(nonatomic,strong)AVPlayerItem *item;
// HysteriaPlayer
@property (nonatomic, retain) NSMutableDictionary* media;
@property (nonatomic, strong) NSTimer  *audioTimer; // 播放定时器
@property (nonatomic, strong) HysteriaPlayer  *player;
@property (nonatomic, strong) UIImage *burlImage; // 高斯模糊图片
@property (nonatomic, strong) NSString  *audioType; // 音频类型

// DataSource
@property (nonatomic, strong) VoiceModel *currentModel;
@property (nonatomic, assign) NSInteger currentRow; // 当前选中行
@property (nonatomic, retain) NSMutableArray *deepKnowArr; // 播放队列
@property (nonatomic, strong) NSString *audioId;

// Other
@property (nonatomic, strong) dispatch_queue_t mainQuene;
@property (nonatomic, strong) dispatch_queue_t globalQuene;
@property (nonatomic, strong) NSString *currentNetWorkStaus;

@end

@implementation YTPlayerViewController

{
    NSInteger steps;
    NSInteger toggleIndex;
    CGFloat sliderDragBeginTime;
    unsigned long netStatus;
}

-(instancetype)init {

    self = [super init];
    if (self) {
        [self initPlayer];
        [self setUI];

        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

+(YTPlayerViewController *)shareInstance {
    static dispatch_once_t onceTocken;
    static YTPlayerViewController *controller = nil;
    dispatch_once(&onceTocken, ^{
        controller = [[self alloc] init];
    });
    return controller;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - 初始化播放器
- (void)initPlayer {
    // 1.dataSource
    if (!self.deepKnowArr) { // 队列
        self.deepKnowArr = [NSMutableArray array];
    }
    // 2.Player
    if (!self.player) { // 播放器
        self.player = [HysteriaPlayer sharedInstance];

        self.player.delegate = self;
        self.player.datasource = self;
        /*
         HysteriaPlayerRepeatModeOn = 0,
         HysteriaPlayerRepeatModeOnce,
         HysteriaPlayerRepeatModeOff,
         */
        [self.player setPlayerRepeatMode:HysteriaPlayerRepeatModeOff];
        [self.player setPlayerShuffleMode:HysteriaPlayerShuffleModeOff];
    }
    if (!self.media) { // 远程控制字典
        self.media = [[NSMutableDictionary alloc] init];
    }
    // 3.Other
    if (!self.audioTimer) { // 定时器
        self.audioTimer = [[NSTimer alloc] init];
        self.audioTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(autoChangeProgress) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.audioTimer forMode:NSRunLoopCommonModes];
    }
    // 4.queue
    if (!self.mainQuene) {
        self.mainQuene = dispatch_get_main_queue();
    }
    if (!self.globalQuene) {
        self.globalQuene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 );
    }

}

#pragma mark - FeedBackDelegate
-(void)sendAudioModelAtIndex:(NSInteger)row {
    // 播放第几行模型
    [self.player fetchAndPlayPlayerItem:row];
}

#pragma mark - 创建定时器
- (void)createAudioTimer {
    if (!self.audioTimer) { // 定时器
        self.audioTimer = [[NSTimer alloc] init];
        self.audioTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(autoChangeProgress) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.audioTimer forMode:NSRunLoopCommonModes];
    }
}

#pragma mark -  清空当前队列
- (void)clearPlayerData {
    [self.player removeAllItems];
    self.player.delegate   = self;
    self.player.datasource = self;
    [self.media removeAllObjects]; // 清空远程队列
    self.audioType = nil;
}

#pragma mark -  移除定时器
- (void)removeAudioTimer {
    [self.audioTimer invalidate];
    self.audioTimer = nil;
}

#pragma mark - HysteriaPlayer Delegate

- (void)hysteriaPlayerRateChanged:(BOOL)isPlaying {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayAudio"
                                                        object:self
                                                      userInfo:nil];
    // 暂停，开始 改变切换样式
    if (isPlaying) {
        [self createAudioTimer];
        [self.audioTimer setFireDate:[NSDate distantPast]];
        [self.toggleButton setImage:[UIImage imageNamed:@"PlayerStop"] forState:UIControlStateNormal];
        self.navigationItem.title = @"正在播放";
    } else {
        [self removeAudioTimer];
        [self.audioTimer setFireDate:[NSDate distantFuture]];
        [self.toggleButton setImage:[UIImage imageNamed:@"PlayerPlay"] forState:UIControlStateNormal];
        self.navigationItem.title = @"已暂停";
    }
}
   //返回当前有多少个音频
- (NSUInteger)hysteriaPlayerNumberOfItems {
    if (self.deepKnowArr == nil) {
        return 0;
    }
    
    return self.deepKnowArr.count;
}
    //当前所播放的音频
- (void)hysteriaPlayerWillChangedAtIndex:(NSUInteger)index {


    self.currentModel = self.deepKnowArr[index];
    toggleIndex = index;
    float preEndtime = [self.player getPlayingItemCurrentTime];
    float startime = .0f;

    // 锁屏显示的信息
    if (self.currentModel == nil) {
        self.media[MPMediaItemPropertyTitle] = @"无音频";
        self.media[MPMediaItemPropertyArtist] = @"......";
    }else{
        self.media[MPMediaItemPropertyTitle] = self.currentModel.titleCn;
        self.media[MPMediaItemPropertyArtist] = self.currentModel.authorCn;
    }

    self.media[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"PlaceholderRect"]];
    self.media[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(0);
    self.media[MPMediaItemPropertyPlaybackDuration] = @([self.currentModel.duration floatValue]);
    self.yantuScrollView.frontCoverImageView.image = [UIImage imageNamed:@"nil"];
    
    
    
    // 背景高斯模糊
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:self.currentModel.frontCover]
                          options:0
                         progress: nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                self.media[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:image];
                                [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:self.media];
                                self.yantuScrollView.frontCoverImageView.image = image;
                                // 背景高斯模糊
                                self.backImgView.image = [image applyDarkEffect:5];
                            }
                        }];
    // 刷新UI
    [UIView animateWithDuration:0.25f animations:^{
        self.sliderView.crruentLabel.text = [self stringWithCheckCoderTime:0.0f];
        self.sliderView.progressSlider.value = .0f;
        self.sliderView.durationLabel.text = [self stringWithCheckCoderTime:[self.currentModel.duration floatValue]];
        self.yantuScrollView.authorLabel.text = @"微博请关注@kevin";
        self.yantuScrollView.titleLabel.text = self.currentModel.titleCn;
    }];
}


- (void)hysteriaPlayerCurrentItemChanged:(AVPlayerItem *)item {

    self.item =item;
}
//播放器状态
- (void)hysteriaPlayerReadyToPlay:(HysteriaPlayerReadyToPlay)identifier {
    switch (identifier) {
            //播放器准备播放
        case HysteriaPlayerReadyToPlayPlayer:
            break;
            //播放器播放当前音频
        case HysteriaPlayerReadyToPlayCurrentItem:
            break;
        default:
            break;
    }
}

- (NSURL *)hysteriaPlayerURLForItemAtIndex:(NSUInteger)index preBuffer:(BOOL)preBuffer {
    NSLog(@"%d",preBuffer);
    VoiceModel* newVoice = self.deepKnowArr[index];
    return [NSURL URLWithString:[self voiceURL:newVoice.url]];
}
//播放地址
-(NSString *) voiceURL:(NSString *) path {
    return [NSString stringWithFormat:@"%@" ,path];
}

- (void)hysteriaPlayerDidFailed:(HysteriaPlayerFailed)identifier error:(NSError *)error {
    switch (identifier) {
            //播放失败
        case HysteriaPlayerFailedPlayer:
            break;
            //当前音频失败
        case HysteriaPlayerFailedCurrentItem:
            break;
        default:
            break;
    }
}

- (void)hysteriaPlayerCurrentItemPreloaded:(CMTime)time {
    
    
  
    NSLog(@"--->CMTime:%d",time.timescale);
    NSLog(@"--->CMTime:%lld",time.value);
    NSLog(@"--->CMTime:%u",time.flags);
    NSLog(@"--->CMTime:%lld",time.epoch);
}

- (NSTimeInterval)availableDuration {
    
    NSArray *loadedTimeRanges = [self.item loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}


//
- (void)setUI {

    // backImageView
    self.backImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PlayerBackground"]];
    self.backImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backImgView];
    [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.backImgView.clipsToBounds = YES;

    CGFloat toggleButtonWH = 82/2.0f * VOICEVIEWRATE;
    CGFloat marginToggleAndPre = 120/2.0f * VOICEVIEWRATE;
    CGFloat marginToggleBottom = 48/2.0f * VOICEVIEWRATE;

    // 5.底部播放的View
    self.toggleButton = [[UIButton alloc] init];
    [self.toggleButton setImage:[UIImage imageNamed:@"PlayerStop"] forState:UIControlStateNormal];
    [self.toggleButton setImage:[UIImage imageNamed:@"PlayerPlay"] forState:UIControlStateSelected];
    [self.view addSubview:self.toggleButton];
    self.toggleButton.tag = BottomView_Toggle_TAG;
    [self.toggleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.toggleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(toggleButtonWH, toggleButtonWH));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(-marginToggleBottom);
    }];

    self.prevButton = [[UIButton alloc] init];
    [self.prevButton setImage:[UIImage imageNamed:@"PlayerPrev"] forState:UIControlStateNormal];
    [self.view addSubview:self.prevButton];
    self.prevButton.tag = BottomView_Pre_TAG;
    [self.prevButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.prevButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(toggleButtonWH, toggleButtonWH));
        make.centerY.mas_equalTo(self.toggleButton.mas_centerY);
        make.right.mas_equalTo(self.toggleButton.mas_left).offset(-marginToggleAndPre);
    }];

    self.nextButton = [[UIButton alloc] init];
    [self.nextButton setImage:[UIImage imageNamed:@"PlayerNext"] forState:UIControlStateNormal];
    [self.view addSubview:self.nextButton];
    self.nextButton.tag = BottomView_Next_TAG;
    [self.nextButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(toggleButtonWH, toggleButtonWH));
        make.centerY.mas_equalTo(self.toggleButton.mas_centerY);
        make.left.mas_equalTo(self.toggleButton.mas_right).offset(marginToggleAndPre);
    }];

    // Slider And Label
    CGFloat sliderViewH = 160/2.0f * VOICEVIEWRATE;
    self.sliderView = [[VoiceSliderView alloc] init];
    [self.view addSubview:self.sliderView];
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(IPHONE_WIDTH, sliderViewH));
        make.bottom.mas_equalTo(self.toggleButton.mas_top);
    }];
    
    self.Progress = [[UIProgressView alloc]init];
    [self.sliderView.progressSlider addSubview:self.Progress];
    self.Progress.backgroundColor = [UIColor clearColor];
    self.Progress.progressTintColor = [UIColor redColor];;
    [self.Progress mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.sliderView.progressSlider.mas_left);
        make.right.equalTo(self.sliderView.progressSlider.mas_right);
        make.height.mas_equalTo(@4);
        make.centerY.mas_equalTo(self.sliderView.progressSlider.mas_centerY);
    }];
    

    [self.sliderView.progressSlider addTarget:self action:@selector(slideStartToChange:) forControlEvents:UIControlEventTouchDown];
    [self.sliderView.progressSlider addTarget:self action:@selector(sliderChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.sliderView.progressSlider addTarget:self action:@selector(slideToEnd:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];

    //    MediumView
    self.yantuScrollView = [[PlayerScrollView alloc] init];
    [self.view addSubview:self.yantuScrollView];

    [self.yantuScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.bottom.mas_equalTo(self.sliderView.mas_top);
        make.width.mas_equalTo(IPHONE_WIDTH);
    }];
    if (IPHONE_WIDTH == 320 && IPHONE_HEIGHT == 480) {
        [self.yantuScrollView setContentSize:CGSizeMake(IPHONE_WIDTH, 350)];
        [self.yantuScrollView setScrollEnabled:YES];
        [self.yantuScrollView setShowsVerticalScrollIndicator:NO];
    }
    __weak YTPlayerViewController *vc = self;
    self.yantuScrollView.listView.viewBlock = ^(id sender){
        [vc listClick];
    };
    self.yantuScrollView.storeView.viewBlock = ^(id sender){
        [vc storeClick];
    };
    self.yantuScrollView.frontCoverBlock = ^(id sender){
        [vc frontCoverClick];
    };
}


#pragma mark - 播放，发送后台统计



#pragma mark - Slider Events
- (void)slideStartToChange:(UISlider *) slide {
    [self.player pause];
    [self removeAudioTimer];
    sliderDragBeginTime = slide.value *  [self.player getPlayingItemDurationTime];
}

- (void)sliderChangeValue:(UISlider *)slider {
    float dt = [self.player getPlayingItemDurationTime];
    self.sliderView.crruentLabel.text = [self stringWithCheckCoderTime:slider.value * dt];
}

- (void)slideToEnd:(UISlider *) slide {
    // 1.拿到当前 slider 的值
    float value = slide.value;
    float totalTime = [self.player getPlayingItemDurationTime];
    value   *= totalTime;
    // 2.转化成即将要准备播放的时间
    self.media[MPNowPlayingInfoPropertyElapsedPlaybackTime] = [NSNumber numberWithFloat:value];
    [self.player seekToTime:value];
    [self.player play];
    [self createAudioTimer];
    CGFloat endTime;
    endTime = slide.value *  [self.player getPlayingItemDurationTime];
}

- (void)autoChangeProgress {

    float ct = [self.player getPlayingItemCurrentTime];
    float dt = [self.player getPlayingItemDurationTime];
    if (dt == 0) {
        self.sliderView.progressSlider.value = 0;
    } else {
        self.sliderView.progressSlider.value = ct/dt;
        self.sliderView.crruentLabel.text = [self stringWithCheckCoderTime:ct];
        self.sliderView.durationLabel.text =[self stringWithCheckCoderTime:dt];
    }
    self.Progress.progress =[self availableDuration]/dt;
    NSLog(@"当前缓冲进度 ---》%f",[self availableDuration]/dt);
}

#pragma mark - MediumView Blocks Events
- (NSString *) stringWithCheckCoderTime:(int) time {
    int m = (int) time/60;
    int s = (int) time%60;
    
    return [NSString stringWithFormat:@"%@:%@",
            [self zeroPrefix:m],
            [self zeroPrefix:s]
            ];
}
-(NSString *) zeroPrefix:(int) time {
    if (time<10) {
        return [NSString stringWithFormat:@"0%d", time];
    } else {
        return [NSString stringWithFormat:@"%d", time];
    }
}


- (void)listClick {


}

- (void)storeClick {

    /*
    MyFavriteViewController *myFavrite = [[MyFavriteViewController alloc] init];
    [self.navigationController pushViewController:myFavrite animated:YES];
     */
}

- (void)frontCoverClick {


}

#pragma mark - TopView/BottomView ButtonEvents

- (void)buttonClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1010: // close
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case 1012: // toggle
        {
            if ([self.player isPlaying]) {

                [self.player pausePlayerForcibly:YES];
                [self.player pause];
            } else {
                [self.player pausePlayerForcibly:NO];
                [self.player play];
            }
        }
            break;
        case 1013: // prev
        {
        
            [self.player playPrevious];
            [self.player play];
        }
            break;
        case 1014: // next
        {
            [self.player playNext];
            [self.player play];
        }
            break;

        default:
            break;
    }
}

#pragma mark - Player Functions

// Quene Model
- (void)playAudioWithArray:(NSArray *)audiosArr AndCurrentRow:(NSInteger)curRow AudioType:(NSString *)type{
    [self clearPlayerData];
    [self createAudioTimer];
    self.audioType = type;
    self.deepKnowArr = [NSMutableArray arrayWithArray:audiosArr];
    VoiceModel *model = (VoiceModel *)audiosArr[curRow];

    [self.yantuScrollView.listView changeListCount:self.deepKnowArr.count];
    [self saveCurrentAudiosWithArr:self.deepKnowArr];
    [self myPlayerForcibly];
    [self.player fetchAndPlayPlayerItem:curRow];
}

// Singel Model
- (void)playSingleAudio:(VoiceModel *)singeAudioModel AudioType:(NSString *)type{
    [self clearPlayerData];
    [self createAudioTimer];
    self.audioType = type;
    self.deepKnowArr = [NSMutableArray arrayWithArray:@[singeAudioModel]];
    [self.yantuScrollView.listView changeListCount:self.deepKnowArr.count];
    [self saveCurrentAudiosWithArr:self.deepKnowArr];
    [self myPlayerForcibly];
    [self.player fetchAndPlayPlayerItem:0];
}


// send The Model To Array
- (void)sendModel:(VoiceModel *)model AndAudioType:(NSString *)type{
    [self clearPlayerData];
    [self createAudioTimer];
    self.audioType = type;
    [self.deepKnowArr addObject:model];
    [self.yantuScrollView.listView changeListCount:self.deepKnowArr.count];
    [self saveCurrentAudiosWithArr:self.deepKnowArr];
    [self myPlayerForcibly];
    [self.player fetchAndPlayPlayerItem:0];
}

-(VoiceModel *)playerCurrentModel {
    return self.currentModel;
}

-(CGFloat)playerCurrentProgress {
    return self.sliderView.progressSlider.value;
}

- (void)resetPlayerTime:(CGFloat)value {
    self.sliderView.progressSlider.value = value;
    [self.player pause];
    [self removeAudioTimer];
    float totalTime = [self.player getPlayingItemDurationTime];
    value *= totalTime;
    self.media[MPNowPlayingInfoPropertyElapsedPlaybackTime] = [NSNumber numberWithFloat:value];
    [self.player seekToTime:value];
    [self.player play];
    [self createAudioTimer];
}

#pragma mark - 存贮最新播放队列

- (void)saveCurrentAudiosWithArr:(NSArray *)audiosArr {
    // 将所有当前播放队列存入(队列，单个，ID)
    NSMutableArray *arr = @[].mutableCopy;
    for (VoiceModel *model in audiosArr) {
        NSDictionary *dic = [model toDictionary];
        [arr addObject:dic];
    }
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"LatestAudioList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// play
- (void)myPlayerForcibly {
    [self.player pausePlayerForcibly:NO];
    [self.player play];
}




@end
