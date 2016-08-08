//
//  PlayerScrollView.h
//  dexotrip
//
//  Created by kevin on 16/8/6.
//  Copyright © 2016年 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VoiceShowView.h"

typedef void(^FrontCoverBlock)(id);

@interface PlayerScrollView : UIScrollView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UIImageView *frontCoverImageView;
@property (nonatomic, strong) VoiceShowView *listView;
@property (nonatomic, strong) VoiceShowView *storeView;
@property (nonatomic, copy) FrontCoverBlock frontCoverBlock;

@end
