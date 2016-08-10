//
//  EGMemberZoneModel.h
//  Egive-ipad
//
//  Created by vincentmac on 15/12/28.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGBaseModel.h"

@protocol EGMemberInfo
@end

@interface EGMemberInfo : EGBaseModel

@property (nonatomic,assign) BOOL AcceptEDM ;
@property (nonatomic,copy) NSString *AddressBldg;
@property (nonatomic,copy) NSString *AddressCountry ;
@property (nonatomic,copy) NSString *AddressDistrict ;
@property (nonatomic,copy) NSString *AddressEstate;
@property (nonatomic,copy) NSString *AddressRoom ;
@property (nonatomic,copy) NSString *AddressStreet ;
@property (nonatomic,copy) NSString *AgeGroup;
@property (nonatomic,copy) NSString *AppToken ;
@property (nonatomic,copy) NSString *AvailableTime ;
@property (nonatomic,copy) NSString *AvailableTime_Other;
@property (nonatomic,copy) NSString *BelongTo ;
@property (nonatomic,copy) NSString *BusinessRegistrationNo ;
@property (nonatomic,copy) NSString *BusinessRegistrationType;
@property (nonatomic,copy) NSString *ChiFirstName ;
@property (nonatomic,copy) NSString *ChiLastName ;
@property (nonatomic,copy) NSString *ChiNameTitle;
@property (nonatomic,copy) NSString *CorporationChiName ;
@property (nonatomic,copy) NSString *CorporationEngName ;
@property (nonatomic,copy) NSString *CorporationType;
@property (nonatomic,copy) NSString *CorporationType_Other ;
@property (nonatomic,copy) NSString *DonationInterest ;
@property (nonatomic,copy) NSString *EducationLevel;
@property (nonatomic,copy) NSString *Email ;
@property (nonatomic,copy) NSString *EngFirstName ;
@property (nonatomic,copy) NSString *EngLastName;
@property (nonatomic,copy) NSString *EngNameTitle ;
@property (nonatomic,copy) NSString *HowToKnoweGive ;
@property (nonatomic,copy) NSString *HowToKnoweGive_Other;
@property (nonatomic,assign) BOOL JoinVolunteer ;
@property (nonatomic,copy) NSString *Lang ;
@property (nonatomic,copy) NSString *LoginName;
@property (nonatomic,copy) NSString *MemberID ;
@property (nonatomic,copy) NSString *MemberType ;
@property (nonatomic,copy) NSString *Position;
@property (nonatomic,copy) NSString *ProfilePicURL ;
@property (nonatomic,copy) NSString *Sex ;
@property (nonatomic,copy) NSString *TelCountryCode;
@property (nonatomic,copy) NSString *TelNo ;
@property (nonatomic,copy) NSString *VolunteerEndDate ;
@property (nonatomic,copy) NSString *VolunteerInterest;
@property (nonatomic,copy) NSString *VolunteerInterest_Other ;
@property (nonatomic,copy) NSString *VolunteerStartDate ;
@property (nonatomic,copy) NSString *VolunteerType;


@end

@interface EGMemberZoneModel : EGBaseModel



+ (void)getPersonInfoWithParams:(NSString *)param block:(void (^)(EGMemberInfo *result,NSError *error)) block;

+ (void)getCompanyInfoWithParams:(NSString *)param block:(void (^)(EGMemberInfo *result,NSError *error)) block;

+ (void)getCompanySelectionsWithParams:(NSString *)param block:(void (^)(NSDictionary *result,NSError *error)) block;


+ (void)updateMemberWithParams:(NSString *)param block:(void (^)(NSString *result,NSError *error)) block;

@end
