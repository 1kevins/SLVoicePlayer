# SLVoicePlayer
###SLVoicePlayer 是一个多功能的音乐播放器，持播放语音队列，播放单个音频，播放，暂停，上一首，下一首，快进，快退，缓存音频，下载音频等功能，目前v1.0.0版本，持续更新中
###播放器播放音频的方法，voicemodel可自行构建，必须包含播放的url

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
###本demo运行的效果
![github](https://github.com/1kevins/SLVoicePlayer/blob/master/IMG_0183.PNG?raw=true "github") ![github](https://github.com/1kevins/SLVoicePlayer/blob/master/IMG_0184.PNG?raw=true "github") 
![github](https://github.com/1kevins/SLVoicePlayer/blob/master/IMG_0185.PNG?raw=true "github") 

## contact me  
1.[博客](http://christmascat.lofter.com)<br />  
2.[微博](http://weibo.com/3388333772/profile?topnav=1&wvr=6)<br />  

