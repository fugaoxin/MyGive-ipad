//
//  EGRankModel.h
//  Egive-ipad
//
//  Created by vincentmac on 15/12/1.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGBaseModel.h"


@protocol EGRankItem
@end

@interface EGRankItem : EGBaseModel

@property (nonatomic,copy) NSString *Amt ;
@property (nonatomic,copy) NSString *MemberName;
@property (nonatomic,copy) NSString *ProfilePicFilePath ;


@end

@interface EGRankModel : EGBaseModel


/**
 *  获取排名
 *
 *  @return
 */
+(void)getRankWithParams:(NSString *)param block:(void (^)(NSArray *array,NSError *error)) block;

/**
 *  获取头部信息
 *
 *  @return
 */
+(void)getOtherRankInfoWithParams:(NSString *)param block:(void (^)(NSDictionary *array,NSError *error)) block;

/**
 *  获取累积最高企业
 *
 *  @return
 */
+(void)getHeightCompanyDonationWithParams:(NSString *)param block:(void (^)(NSArray *array,NSError *error)) block;



/**
 *  最热心参与企业
 *
 *  @return
 */
+(void)getEnthusiasmCompanyDonationWithParams:(NSString *)param block:(void (^)(NSArray *array,NSError *error)) block;


/**
 *  每月最高个人捐款
 *
 *  @return
 */
+(void)getMonthPersonDonationWithParams:(NSString *)param block:(void (^)(NSArray *array,NSError *error)) block;


/**
 *  累积最高个人捐款
 *
 *  @return
 */
+(void)getHeightPersonDonationWithParams:(NSString *)param block:(void (^)(NSArray *array,NSError *error)) block;
@end
