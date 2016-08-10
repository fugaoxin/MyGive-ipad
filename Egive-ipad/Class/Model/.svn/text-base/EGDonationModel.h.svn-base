//
//  EGDonationModel.h
//  Egive-ipad
//
//  Created by vincentmac on 15/12/2.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGBaseModel.h"

//捐款记录模型
@protocol EGRecordItem
@end

@interface EGRecordItem : EGBaseModel

@property (nonatomic,copy) NSString *Amt ;
@property (nonatomic,copy) NSString *CaseCategory;
@property (nonatomic,copy) NSString *CaseID ;
@property (nonatomic,copy) NSString *CaseRegion ;
@property (nonatomic,copy) NSString *CaseTitle;
@property (nonatomic,assign) BOOL ChargeIncluded ;
@property (nonatomic,copy) NSString *DonateDate ;
@property (nonatomic,copy) NSString *Location;
@property (nonatomic,copy) NSString *ReceivedAmt ;

@end


//购物车列表模型
@protocol EGCartItem
@end

@interface EGCartItem : EGBaseModel

@property (nonatomic,copy) NSString *CaseID ;
@property (nonatomic,copy) NSString *CaseRegion;
@property (nonatomic,assign) NSInteger DonateAmt ;
@property (nonatomic,assign) BOOL IsChecked ;
@property (nonatomic,copy) NSString *ItemMsg;
@property (nonatomic,assign) NSInteger MinDonateAmt ;
@property (nonatomic,assign) NSInteger PayOption1 ;
@property (nonatomic,assign) NSInteger PayOption2 ;
@property (nonatomic,assign) NSInteger PayOption3 ;
@property (nonatomic,assign) NSInteger ReceiveAmt ;
@property (nonatomic,assign) NSInteger SelectedOption ;
@property (nonatomic,copy) NSString *Title;

@end

@interface EGDonationModel : EGBaseModel


@property (nonatomic,strong) NSArray<EGRecordItem> *RecordList;


+ (void)getNoteWithParams:(NSString *)param block:(void (^)(NSString *result,NSError *error)) block;

+ (void)getDonationRecordWithParams:(NSString *)param block:(void (^)(NSArray *array,NSError *error)) block;

+ (void)getCartListWithParams:(NSString *)param block:(void (^)(NSDictionary *dict,NSError *error)) block;

+ (void)updateCartListWithParams:(NSString *)param block:(void (^)(NSDictionary *dict,NSError *error)) block;

+ (void)getDisclaimerWithParams:(NSString *)param block:(void (^)(NSString *content,NSError *error)) block;

+ (void)checkOutShoppingCartWithParams:(NSString *)param block:(void (^)(NSDictionary *content,NSError *error)) block;

@end
