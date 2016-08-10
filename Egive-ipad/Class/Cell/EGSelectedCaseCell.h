//
//  EGSelectedCaseCell.h
//  Egive-ipad
//
//  Created by vincentmac on 15/12/7.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGDonationModel.h"


typedef NS_ENUM(NSInteger, EGDonationCounterFeeStyle) {
    EGDonationHKContainFee,
    EGDonationHKUnContainFee,
    EGDonationUnHKContainFee,
    EGDonationUnHKUnContainFee
};


//case改变之后的回调
typedef void(^EGCaseChangeBlock)(EGCartItem *,NSInteger);

typedef void(^EGCaseChangeStyleBlock)(EGCartItem *,NSInteger row);

@interface EGSelectedCaseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *topBgView;

@property (weak, nonatomic) IBOutlet UIButton *checkBox;

@property (weak, nonatomic) IBOutlet UILabel *caseNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *donationLabel;

@property (weak, nonatomic) IBOutlet UILabel *nocaseLabel;

@property (weak, nonatomic) IBOutlet UIView *btnBgView;

@property (weak, nonatomic) IBOutlet UIButton *firstButton;

@property (weak, nonatomic) IBOutlet UIButton *secondButton;

@property (weak, nonatomic) IBOutlet UIButton *thirdButton;

@property (weak, nonatomic) IBOutlet UIButton *fourButton;

@property (weak, nonatomic) IBOutlet UILabel *receiverLabel;

@property (weak, nonatomic) IBOutlet UILabel *donationMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *receivermoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *pointLabel;


//
@property (assign, nonatomic) NSInteger currentSelected;

@property (strong, nonatomic)  UITextField *moneyField;

@property (assign, nonatomic) NSInteger minDonateAmt;

@property (nonatomic,copy) EGCaseChangeBlock block;

@property (nonatomic,copy) EGCaseChangeStyleBlock styleChangeBlock;//

@property (assign, nonatomic) EGDonationCounterFeeStyle feeStyle;

@property (assign, nonatomic) NSInteger row;

@property (assign, nonatomic) NSInteger numberOfSelectedCase;//被选中得case，用于计算平均手续费

//
+ (instancetype)cellWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath item:(EGCartItem *)item;



@end
