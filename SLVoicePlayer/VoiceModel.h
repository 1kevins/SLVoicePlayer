//
//  VoiceModel.h
//  dexotrip
//
//  Created by kevin on 16/8/7.
//  Copyright © 2016年 kevin. All rights reserved.
//

#import "JSONModel.h"
@protocol VoiceModel @end

@interface VoiceModel : JSONModel

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString <Optional>* url;
@property (strong, nonatomic) NSString <Optional>* titleCn;
@property (strong, nonatomic) NSString <Optional>* titleEn;
@property (strong, nonatomic) NSString <Optional>* summary;
@property (strong, nonatomic) NSString <Optional>* frontCover;
@property (nonatomic, strong) NSString <Optional>* frontCoverTitle;
@property (nonatomic, strong) NSNumber <Optional>* distance;
@property (nonatomic, strong) NSNumber <Optional>* audioCount;
@property (nonatomic, strong) NSNumber <Optional>* duration;
@property (strong, nonatomic) NSString<Optional>* authorCn;
@property (strong, nonatomic) NSString<Optional>* authorEn;



@end

@interface VoiceListModel : JSONModel

@property (strong, nonatomic) NSMutableArray<VoiceModel>* date;

@end
