//
//  EGClickCharityCell.h
//  Egive-ipad
//
//  Created by User01 on 15/11/30.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGHomeModel.h"

@protocol EGClickCharityDelegate <NSObject>
/**
 * 添加关注
 * caseID: 专案ID
 */
-(void)AddAttention:(NSString *)caseID;

/**
 * 取消关注
 * caseID: 专案ID
 */
-(void)DeleteAttention:(NSString *)caseID;

/**
 * 立即捐款
 * caseId: 专案ID
 * but: 捐款按钮
 * RemaingValue: 等于0，专案已结束
 * Success: 等于1，专案已成功
 * StyleStr:
 */
-(void)AddDonation:(NSString *)caseId andBut:(UIButton *)but andRemainingValue:(NSString *)RemainingValue andIsSuccess:(BOOL)Success andStyleStr:(NSString *)StyleStr;

@end


@interface EGClickCharityCell : UITableViewCell

@property (nonatomic,weak)id<EGClickCharityDelegate>delegate;
-(void)setModel:(EGHomeModel *)model andIndex:(int)index andID:(NSMutableArray *)IDarray andBool:(BOOL)mybool;;

@end
