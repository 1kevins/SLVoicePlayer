//
//  PlayerScrollView.m
//  dexotrip
//
//  Created by kevin on 16/8/6.
//  Copyright © 2016年 kevin. All rights reserved.
//

#import "PlayerScrollView.h"
#import <Masonry.h>
CGFloat const EX_Gold = .618f;
#define IPHONE_WIDTH [[UIScreen mainScreen] bounds].size.width
#define IPHONE_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define VOICEVIEWRATE (double)[[UIScreen mainScreen] bounds].size.height/667
@implementation PlayerScrollView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        // MediumView
        CGFloat frontCoverMargin = 50/2.0f;
        CGFloat frontCoverTopMargin = 20/2.0f * VOICEVIEWRATE;
        CGFloat titleLabelH = 36/2.0f * VOICEVIEWRATE;
        CGFloat titleLableTopMargin = 28/2.0f * VOICEVIEWRATE;
        CGFloat authorLabelH = 28/2.0f;
        CGFloat authorLabelTopMargin = 24/2.0f * VOICEVIEWRATE;
        CGFloat listViewTopMargin = 64/2.0f * VOICEVIEWRATE;
        CGFloat storeViewTopMargin = 32/2.0f * VOICEVIEWRATE;
        CGFloat listStoreViewH = 50.0f * VOICEVIEWRATE;
        
        
        
        
        self.titleLabel = [[UILabel alloc] init];
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        [self.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        self.titleLabel.text = @"...";
        [self addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(IPHONE_WIDTH-2*frontCoverMargin, titleLabelH)); // 宽度动态计算
            make.top.mas_equalTo(self.mas_top).offset(titleLableTopMargin);
        }];
        
        self.authorLabel = [[UILabel alloc] init];
        [self.authorLabel setTextColor:[UIColor whiteColor]];
        [self.authorLabel setFont:[UIFont systemFontOfSize:11.0f]];
        [self.authorLabel setTextAlignment:NSTextAlignmentCenter];
        self.authorLabel.text = @"...";
        [self addSubview:self.authorLabel];
        [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(100, authorLabelH));
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(authorLabelTopMargin);
        }];
        
        self.frontCoverImageView = [[UIImageView alloc] init];
        self.frontCoverImageView.contentMode = UIViewContentModeScaleAspectFill;
//        self.frontCoverImageView.image = [UIImage imageNamed:@"PlaceholderRect"];
        [self addSubview:self.frontCoverImageView];
        [self.frontCoverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.authorLabel.mas_bottom).with.offset(frontCoverTopMargin);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(IPHONE_WIDTH-2*frontCoverMargin);
            make.height.mas_equalTo((IPHONE_WIDTH-2*frontCoverMargin)*EX_Gold);
        }];
        
        self.frontCoverImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(frontCoverClick:)];
        [self.frontCoverImageView addGestureRecognizer:tapGes];
        
        
        self.listView = [[VoiceShowView alloc] init];
        [self.listView setViewApperance:@"VoicePlayerList" title:@"播放列表"];
        [self.listView changeListCount:12];
        [self addSubview:self.listView];
        [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(IPHONE_WIDTH, listStoreViewH));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.frontCoverImageView.mas_bottom).offset(listViewTopMargin);
        }];
        
        self.storeView = [[VoiceShowView alloc] init];
        [self.storeView setViewApperance:@"VoicePlayerStore" title:@"收藏的语音"];
        [self addSubview:self.storeView];
        [self.storeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(IPHONE_WIDTH, listStoreViewH));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.listView.mas_bottom).offset(storeViewTopMargin);
        }];
        
    }
    return self;
}

- (void)frontCoverClick:(UITapGestureRecognizer *)tap {
    if (self.frontCoverBlock) {
        self.frontCoverBlock(tap);
    }
}

@end
