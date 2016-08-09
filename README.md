# SLVoicePlayer
###SLVoicePlayer 是一个多功能的音乐播放器，持播放语音队列，播放单个音频，播放，暂停，上一首，下一首，快进，快退，缓存音频，下载音频等功能，目前v1.0.0版本，持续更新中
###本demo运行的效果
###播放器播放音频的方法，voicemodel可自行构建，必须包含播放的url

+ (YTPlayerViewController *)shareInstance;

- (void)playAudioWithArray:(NSArray *)audiosArr AndCurrentRow:(NSInteger)curRow AudioType:(NSString *)type;

- (void)playSingleAudio:(VoiceModel *)singeAudioModel AudioType:(NSString *)type;
- 
![github](https://github.com/1kevins/SLVoicePlayer/blob/master/IMG_0184.PNG?raw=true "github") 
![github](https://github.com/1kevins/SLVoicePlayer/blob/master/IMG_0184.PNG?raw=true "github") 
![github](https://github.com/1kevins/SLVoicePlayer/blob/master/IMG_0184.PNG?raw=true "github") 
