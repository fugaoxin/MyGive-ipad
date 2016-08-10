//
//  EGMZTopView.m
//  Egive-ipad
//
//  Created by vincentmac on 15/12/25.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGMZTopView.h"


@implementation EGMZTopView

-(void)awakeFromNib{
    
    self.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    self.toprankLabel.font = [UIFont boldSystemFontOfSize:18];
    self.donationTextLabel.font = [UIFont boldSystemFontOfSize:18];
    self.donationMoneyLabel.font = [UIFont boldSystemFontOfSize:18];
    self.historyLabel.font = [UIFont boldSystemFontOfSize:18];
    self.donationMoneyLabel.textColor = [UIColor colorWithHexString:@"#531E7E"];
    
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"EGIVE_DonationAmountData"];
    if (dict) {
        self.donationMoneyLabel.text = [NSString stringWithFormat:@"HKD$ %@",dict[@"Amt"]];
    }else{
        self.donationMoneyLabel.text = [NSString stringWithFormat:@"HKD$ 0"];
    }
    
    self.donationMoneyLabel.hidden = YES;
    self.donationTextLabel.hidden = YES;
}

-(void)refreshText{
    self.toprankLabel.text = HKLocalizedString(@"查看排名");
//    self.donationTextLabel.text = HKLocalizedString(@"个人累积捐款");
    self.historyLabel.text = HKLocalizedString(@"捐款记录");
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
