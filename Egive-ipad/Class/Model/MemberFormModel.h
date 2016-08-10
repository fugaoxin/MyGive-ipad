//
//  MemberFormModel.h
//  Egive
//
//  Created by sino on 15/9/4.
//  Copyright (c) 2015年 sino. All rights reserved.
//

#import "EGBaseModel.h"

@interface MemberFormModel : EGBaseModel

@property (nonatomic,copy) NSDictionary *ChiNameTitleOptions;
@property (nonatomic,copy) NSArray *ContentText;
@property (nonatomic,copy) NSDictionary *BusinessRegistrationTypeOptions;
@property (nonatomic,copy) NSDictionary *PositionOptions;
@property (nonatomic,copy) NSDictionary *EngNameTitleOptions;
@property (nonatomic,copy) NSDictionary *AgeGroupOptions;
@property (nonatomic,copy) NSDictionary *EducationLevelOptions;
@property (nonatomic,copy) NSDictionary *BelongToOptions;

/**
 *  获取注册需要的下拉和弹窗信息
 *  接口GetMemberForm
 *  @return
 */
+(void)getMemberFormModelData:(int)lang  Block:(void (^)(NSDictionary *result,NSError *error)) block;

@end
