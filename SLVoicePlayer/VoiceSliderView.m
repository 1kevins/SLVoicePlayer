//
//  VoiceSliderView.m
//  dexotrip
//
//  Created by kevin on 16/8/8.
//  Copyright © 2016年 kevin. All rights reserved.
//

#import "VoiceSliderView.h"
#import <Masonry.h>
@implementation VoiceSliderView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
       
        //进度条
        CGFloat leftRightMargin = 40/2.0f;
        CGFloat topMargin = 10.0f;
        CGFloat progressSliderH = 56/2.0f;
        CGFloat currentDurationLabelW = 100;
        CGFloat currentDurationLabelH = 20;
        self.progressSlider = [[UISlider alloc] init];
        self.progressSlider.minimumValue = .0f;
        self.progressSlider.maximumValue = 1.0f;
        [self.progressSlider setThumbImage:[UIImage imageNamed:@"PlayerSlider"] forState:UIControlStateNormal];
        self.progressSlider.minimumTrackTintColor = [UIColor whiteColor];
        self.progressSlider.maximumTrackTintColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:0.5];
//        self.progressSlider.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.progressSlider];
        [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).with.offset(leftRightMargin);
            make.right.mas_equalTo(self).with.offset(-leftRightMargin);
            make.top.mas_equalTo(self.mas_topMargin).offset(topMargin);
            make.height.mas_equalTo(progressSliderH);
        }];
        UIFont *LabelFont = [UIFont systemFontOfSize:10.0f];
        self.crruentLabel = [[UILabel alloc] init];
        self.crruentLabel.font = LabelFont;
        self.crruentLabel.text = @"--/--";
//        self.crruentLabel.backgroundColor = [UIColor redColor];
        self.crruentLabel.textColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:0.5];
        [self addSubview:self.crruentLabel];
        [self.crruentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.progressSlider.mas_left);
            make.top.mas_equalTo(self.progressSlider.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(currentDurationLabelW, currentDurationLabelH));
        }];
        
        self.durationLabel = [[UILabel alloc] init];
        self.durationLabel.font = LabelFont;
        self.durationLabel.text = @"--/--";
        self.durationLabel.textColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:0.5];
        [self.durationLabel setTextAlignment:NSTextAlignmentRight];
//        self.durationLabel.backgroundColor = [UIColor purpleColor];
        [self addSubview:self.durationLabel];
        [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.progressSlider.mas_right);
            make.top.mas_equalTo(self.progressSlider.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(currentDurationLabelW, currentDurationLabelH));
        }];
        
    }
    return self;
}

@end
