//
//  EGMZTopView.h
//  Egive-ipad
//
//  Created by vincentmac on 15/12/25.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGBaseView.h"

@interface EGMZTopView : EGBaseView

@property (weak, nonatomic) IBOutlet UIImageView *rankingView;

@property (weak, nonatomic) IBOutlet UIImageView *icon_image;

@property (weak, nonatomic) IBOutlet UIImageView *recordView;

@property (weak, nonatomic) IBOutlet UILabel *toprankLabel;

@property (weak, nonatomic) IBOutlet UILabel *donationTextLabel;

@property (weak, nonatomic) IBOutlet UILabel *donationMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *historyLabel;

@property (weak, nonatomic) IBOutlet UILabel *topNameLabel;
@end
