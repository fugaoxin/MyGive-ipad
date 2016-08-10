//
//  EGHomeModel.h
//  Egive-ipad
//
//  Created by vincentmac on 15/11/19.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGBaseModel.h"



@protocol EGHomeItem
@end

@interface EGHomeItem : EGBaseModel


@end


@interface EGHomeModel : EGBaseModel

@property (nonatomic,copy) NSString *RemainingValue;
@property (nonatomic) NSNumber * Amt;
@property (nonatomic) NSNumber * TargetAmt;
@property (nonatomic,copy) NSString *CaseID;
@property (nonatomic) BOOL Isfavourite;
@property (nonatomic,copy) NSString *RemainingUnit;
@property (nonatomic) NSNumber *DonorCount;
@property (nonatomic,copy) NSString *Region;
@property (nonatomic) BOOL IsSuccess;
@property (nonatomic,copy) NSString *TitleColor;
@property (nonatomic) float Percentage;
@property (nonatomic,copy) NSString *ProfilePicURL;
@property (nonatomic,copy) NSString *ProfilePicBase64String;
@property (nonatomic,copy) NSString *Status;
@property (nonatomic,copy) NSString *Title;
@property (nonatomic,copy) NSString *ShortDesc;
@property (nonatomic,copy) NSString *Category;
@property (nonatomic,strong) NSString * isSelect;

-(void)setDictionary:(NSDictionary *)dic;

@property (nonatomic,strong) NSArray<EGHomeItem> *ItemList;

+(void)getHomeDataWithParams:(NSDictionary *)param block:(void (^)(NSArray *data,NSError *error)) block;

//请求广告数据
+(void)postHomeItemListWithParams:(NSString *)param block:(void (^)(NSArray *data,NSError *error)) block;

//请求列表数据
+(void)mypostHomeItemListWithParams:(NSString *)param block:(void (^)(NSArray *data,NSError *error)) block;

//请求购物车数据
+(void)savepostHomeItemListWithParams:(NSString *)param block:(void (^)(NSString * str, NSError *))block;

//请求收藏数据
+(void)postFavouriteWithParams:(NSString *)param block:(void (^)(NSString *data,NSError *error)) block;

//请求EGClickCharityViewController右视图
+(void)postClickCharitytWithParams:(NSString *)param block:(void (^)(NSDictionary *data,NSError *error)) block;

//祝福传送
+ (void)postWithHttpsConnection:(BOOL)safe soapMsg:(NSString *)soapMsg success:(void (^)(id))success failure:(void (^)(NSError *))failure;

//关于意增
+ (void)postWithSoapMsg:(NSString *)soapMsg success:(void (^)(id))success failure:(void (^)(NSError *))failure;

@end




