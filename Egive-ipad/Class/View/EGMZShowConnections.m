//
//  EGMZShowConnections.m
//  Egive-ipad
//
//  Created by vincentmac on 15/12/25.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGMZShowConnections.h"

@implementation EGMZShowConnections


-(void)awakeFromNib{
    self.ageTextLabel.textColor = MemberZoneTextColor;
    self.phoneTextLabel.textColor = MemberZoneTextColor;
    self.addTextLabel.textColor = MemberZoneTextColor;
    self.jobTextLabel.textColor = MemberZoneTextColor;
    self.educationTextLabel.textColor = MemberZoneTextColor;
}


-(void)refreshText{

    self.ageTextLabel.text = HKLocalizedString(@"年龄组别");
    self.phoneTextLabel.text = HKLocalizedString(@"Register_org_number");
    self.addTextLabel.text = HKLocalizedString(@"通讯地址");
    self.jobTextLabel.text = HKLocalizedString(@"Occupation");
    self.educationTextLabel.text = HKLocalizedString(@"Educationlevel");
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
