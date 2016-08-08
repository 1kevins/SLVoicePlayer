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
@property (nonatomic, strong) NSNumber <Optional>* commented;
@property (nonatomic, strong) NSNumber <Optional>* collected;
@property (nonatomic, strong) NSNumber <Optional>* played;
@property (nonatomic, strong) NSNumber <Optional>* voiceDuration;
@property (nonatomic, strong) NSNumber <Optional>* isCollect;
@property (copy, nonatomic) NSMutableArray<Optional>* tags;
@property (strong, nonatomic) NSString<Optional>* authorCn;
@property (strong, nonatomic) NSString<Optional>* authorEn;
@property (nonatomic, strong) NSMutableArray<Optional> *images;
@property (nonatomic) NSNumber <Optional> * duration;
@property (nonatomic) NSNumber <Optional> * like;
@property(nonatomic,strong) NSMutableArray< Optional>*tagsdetail;
@property(nonatomic,strong) NSMutableArray<Optional>*poisdetail;
@property(nonatomic,strong)NSString <Optional>*uid;
@property(nonatomic,strong)NSNumber <Optional>*playAt;
@property(nonatomic,strong)NSNumber <Optional>*playTime;


@end

@interface VoiceListModel : JSONModel

@property (strong, nonatomic) NSMutableArray<VoiceModel>* date;

@end
