//
//  EGMenberController.h
//  Egive-ipad
//
//  Created by User01 on 15/12/3.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGPAndCMemberZoneBaseVC.h"
#import <TPKeyboardAvoiding/TPKeyboardAvoidingScrollView.h>

@interface EGPersonMemberZoneVC : EGPAndCMemberZoneBaseVC

//xib
@property (weak, nonatomic) IBOutlet UIView *topBgView;



@property (weak, nonatomic) IBOutlet UILabel *donationTextLabel;

@property (weak, nonatomic) IBOutlet UILabel *donationMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *toprankLabel;

@property (weak, nonatomic) IBOutlet UILabel *historyLabel;

@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

//头像
@property (strong, nonatomic) IBOutlet UIImageView *IconImage;


@end
