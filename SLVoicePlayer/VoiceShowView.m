//
//  VoiceShowView.m
//  dexotrip
//
//  Created by kevin on 16/8/5.
//  Copyright © 2016年 kevin. All rights reserved.
//

#import "VoiceShowView.h"
#import <Masonry.h>
@implementation VoiceShowView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    
        CGFloat margin = 23.0f;
        CGFloat height = 16.0f;
        CGFloat width = 23.0f;
        CGFloat titleLabelWidth = 100.0f;
        CGFloat indicatorLabelWidth = 10.0f;
        CGFloat countLabelWidth = 55.0f;
        CGFloat titleMarginToIcon = 15.0f;
        // iconImageView
        self.iconImageView = [[UIImageView alloc] init];
        [self addSubview:self.iconImageView];
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width, height));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(titleMarginToIcon);
        }];
        
        // titleLable
        self.titleLabel = [[UILabel alloc] init];
        [self addSubview:self.titleLabel];
        [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [self.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(titleLabelWidth, height));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.iconImageView.mas_right).offset(titleMarginToIcon);
        }];
        
        // indicatorImageView
        self.indicatorImageView = [[UIImageView alloc] init];
        self.indicatorImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.indicatorImageView.image = [UIImage imageNamed:@"VoicePlayerIndicator"];
        [self addSubview:self.indicatorImageView];
        [self.indicatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(indicatorLabelWidth, height));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.mas_equalTo(-margin);
        }];
        
        // countLabel
        self.countLabel = [[UILabel alloc] init];
        [self.countLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [self.countLabel setTextColor:[UIColor whiteColor]];
        [self.countLabel setTextAlignment:NSTextAlignmentCenter];
//        self.countLabel.backgroundColor = [UIColor purpleColor];
        [self addSubview:self.countLabel];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(countLabelWidth, height));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.mas_equalTo(self.indicatorImageView.mas_left);
        }];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [self addGestureRecognizer:tap];
        
        self.backgroundColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:0.5];
//        self.alpha = .25f;
        
    }
    return self;
}


-(void)setViewApperance:(NSString *)iconName title:(NSString *)title {
    self.iconImageView.image = [UIImage imageNamed:iconName];
    self.titleLabel.text = title;
}

- (void)changeListCount:(NSInteger)count {
    self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
}

- (void)tapClick:(id)sender {
    if (self.viewBlock) {
        self.viewBlock(sender);
    }
}

@end
