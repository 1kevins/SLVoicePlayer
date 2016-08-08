//
//  VoiceShowView.h
//  dexotrip
//
//  Created by kevin on 16/8/8.
//  Copyright © 2016年 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TapBlock)(id);

@interface VoiceShowView : UIView

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIImageView *indicatorImageView;
@property (nonatomic, copy) TapBlock viewBlock;

- (void)setViewApperance:(NSString *)iconName title:(NSString *)title;
- (void)changeListCount:(NSInteger)count;

@end
