//
//  EGGiveItemModel.h
//  Egive-ipad
//
//  Created by kevin on 15/12/28.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGBaseModel.h"

@protocol EGGiveItem
@end

@interface EGGiveItem : EGBaseModel

@property (nonatomic, assign) NSInteger TotalNumberOfItems;
@property (nonatomic, strong) NSArray *ItemList;

- (id)initWithDict:(NSDictionary *)dict;

@end

@interface EGGiveItemModel : EGBaseModel

@property (nonatomic, copy) NSString *EventID;
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *EventStartDate;
@property (nonatomic, copy) NSString *EventEndDate;
@property (nonatomic, copy) NSString *Location;
@property (nonatomic, copy) NSString *Desp;
@property (nonatomic, strong) NSArray *Img;

- (id)initWithDict:(NSDictionary *)dict;
+ (NSMutableArray *)initWithArray:(NSArray *)array;
/**
 *  意赠资讯-活动和花絮 接口
 *  接口GetEventDtlList
 *  @return
 */
+ (void)getEventDtlListWithEventTp:(NSString *)EventTp year:(NSString*)year block:(void (^)(EGGiveItem *result, NSError *error))block;


@end

//发布中心
@interface EGAnnouncement : EGBaseModel

@property (nonatomic, copy) NSString *PublishDate;
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *FilePath;
@property (nonatomic, copy) NSString *URL;

- (id)initWithDict:(NSDictionary *)dict;
+ (NSMutableArray *)initWithArray:(NSArray *)array;

/**
 *  意赠资讯-发布中心 接口
 *  接口GetAnnouncementCentreList
 *  @return
 */
+ (void)getEventCentreListWithBlock:(void (^)(NSArray *results, NSError *error))block;

@end

