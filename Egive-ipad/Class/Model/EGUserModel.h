//
//  EGUserModel.h
//  Egive-ipad
//
//  Created by vincentmac on 15/12/1.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGBaseModel.h"

@interface EGUserModel : EGBaseModel

@property (nonatomic,copy) NSString *MemberID;
@property (nonatomic,copy) NSString *MemberType;
@property (nonatomic,copy) NSString *LoginName;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *AddressCountry;
@property (nonatomic,copy) NSString *VolunteerInterest;
@property (nonatomic,copy) NSString *EngFirstName;
@property (nonatomic,copy) NSString *ChiLastName;
@property (nonatomic,copy) NSString *AddressRoom;
@property (nonatomic,copy) NSString *AddressBldg;
@property (nonatomic,copy) NSString *BusinessRegistrationType;
@property (nonatomic,copy) NSString *BusinessRegistrationNo;
@property (nonatomic,copy) NSString *ProfilePicBase64String;
@property (nonatomic,copy) NSString *ProfilePicURL; // dedicated
@property (nonatomic,copy) NSString *ChiFirstName;
@property (nonatomic,copy) NSString *Email;
@property (nonatomic,copy) NSString *AddressStreet;
@property (nonatomic,copy) NSString *DonationInterest;
@property (nonatomic) BOOL JoinVolunteer;
@property (nonatomic,copy) NSString *EngNameTitle;
@property (nonatomic,copy) NSString *BelongTo;
@property (nonatomic,copy) NSString *VolunteerInterest_Other;
@property (nonatomic,copy) NSString *AvailableTime;
@property (nonatomic,copy) NSString *Sex;
@property (nonatomic,copy) NSString *AppToken;
@property (nonatomic,copy) NSString *ChiNameTitle;
@property (nonatomic,copy) NSString *AddressEstate;
@property (nonatomic,copy) NSString *VolunteerStartDate;
@property (nonatomic,copy) NSString *CorporationEngName;
@property (nonatomic,copy) NSString *EducationLevel;
@property (nonatomic,copy) NSString *CorporationChiName;
@property (nonatomic,copy) NSString *EngLastName;
@property (nonatomic,copy) NSString *HowToKnoweGive_Other;
@property (nonatomic,copy) NSString *AvailableTime_Other;
@property (nonatomic,copy) NSString *HowToKnoweGive;
@property (nonatomic,copy) NSString *CorporationType_Other;
@property (nonatomic,copy) NSString *Position;
@property (nonatomic,copy) NSString *VolunteerType;
@property (nonatomic,copy) NSString *VolunteerEndDate;
@property (nonatomic,copy) NSString *AgeGroup;
@property (nonatomic,copy) NSString *TelNo;
@property (nonatomic) BOOL AcceptEDM;
@property (nonatomic,copy) NSString *TelCountryCode;
@property (nonatomic,copy) NSString *CorporationType;
@property (nonatomic,copy) NSString *AddressDistrict;
@property (nonatomic,copy) NSString *donationAmount;
@property (nonatomic,copy) NSString *faceBookID;
@property (nonatomic,copy) NSString *weiboID;
@property (nonatomic) NSInteger ShoppingCartCount;

@property (nonatomic,copy) NSString *base64Avatar;//by kevin  头像

-(NSDictionary*)asDictionary;
-(void)fromDictionary:(NSDictionary*)data;


/**
 *  获取成功登录后用户信息
 *  接口GetMemberInfo
 *  @return
 */
+(void)getMemberInfoDataWithMemberId:(NSString *)memberId block:(void (^)(NSDictionary *result,NSError *error)) block;

/**
 *  注册接口
 *  接口SaveMemberInfo
 *  @return
 */
+(void)commitMemberInfoDataWithModel:(EGUserModel *)model block:(void (^)(NSString *result,NSError *error)) block;


/**
 *  change setting lang
 *
 *  @return
 */
+(void)commitLangWithParams:(NSString *)parms block:(void (^)(NSString *result,NSError *error)) block;



/**
 *  向后台注册推送
 *
 *  @return
 */
+(void)changePushMessagePreferenceWithToken:(NSString *)token param:(NSString *)str block:(void (^)(NSString *result,NSError *error)) block;

@end
