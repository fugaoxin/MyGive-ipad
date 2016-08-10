//
//  EGMZCompanyShowName.m
//  Egive-ipad
//
//  Created by vincentmac on 15/12/27.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGMZCompanyShowName.h"

@implementation EGMZCompanyShowName


-(void)awakeFromNib{
    _nameTextLabel.textColor = MemberZoneTextColor;
    _chiTextLabel.textColor = MemberZoneTextColor;
    _chiContactTextLabel.textColor = MemberZoneTextColor;
    _emailTextLabel.textColor = MemberZoneTextColor;
    
    _pwdTextLabel.textColor = MemberZoneTextColor;
    _engContactTextLabel.textColor = MemberZoneTextColor;
    _phoneTextLabel.textColor = MemberZoneTextColor;
    _belongNumberTextLabel.textColor = MemberZoneTextColor;
    _engTextLabel.textColor = MemberZoneTextColor;
    _positionTextLabel.textColor = MemberZoneTextColor;
    _addTextLabel.textColor = MemberZoneTextColor;
}


-(void)refreshText{

    _nameTextLabel.text = HKLocalizedString(@"Register_userNameTextfile");
    _chiTextLabel.text = HKLocalizedString(@"Register_org_orgNameCh_textFile");
    _chiContactTextLabel.text = HKLocalizedString(@"联络人姓名(中)");
    _emailTextLabel.text = HKLocalizedString(@"Register_email");
    
    _pwdTextLabel.text = HKLocalizedString(@"Register_mpwsTextfile");
    _engContactTextLabel.text = HKLocalizedString(@"联络人姓名(英)");
    _phoneTextLabel.text = HKLocalizedString(@"Register_org_number");
    _belongNumberTextLabel.text = HKLocalizedString(@"商业登记号码");
    _engTextLabel.text = HKLocalizedString(@"Register_org_orgNameEn_textFile");
    _positionTextLabel.text = HKLocalizedString(@"職位");
    _addTextLabel.text = HKLocalizedString(@"Register_org_address");
}




/*
  
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
