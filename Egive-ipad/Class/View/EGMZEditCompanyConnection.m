//
//  EGMZEditCompanyConnection.m
//  Egive-ipad
//
//  Created by vincentmac on 15/12/27.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGMZEditCompanyConnection.h"

@implementation EGMZEditCompanyConnection



-(void)awakeFromNib{
    _nameTextLabel.textColor = MemberZoneTextColor;
    _chinameTextLabel.textColor = MemberZoneTextColor;
    _engnameTextLabel.textColor = MemberZoneTextColor;
    _chisurnameTextLabel.textColor = MemberZoneTextColor;
    _engsurnameTextLabel.textColor = MemberZoneTextColor;
    
    
    
    _jobTitleLabel.textColor = MemberZoneTextColor;
    _emailOtherLabel.textColor = MemberZoneTextColor;
    _emailTextLabel.textColor = MemberZoneTextColor;
    _phoneTextLabel.textColor = MemberZoneTextColor;
    
}


-(void)refreshText{

    _nameTextLabel.text = HKLocalizedString(@"联络人");
    _chinameTextLabel.text = HKLocalizedString(@"Register_nameCh");
    _engnameTextLabel.text = HKLocalizedString(@"Register_nameEh");
    _chisurnameTextLabel.text = HKLocalizedString(@"Register_lastNameCh");
    _engsurnameTextLabel.text = HKLocalizedString(@"Register_lastNameEn");
    
    
    
    _jobTitleLabel.text = HKLocalizedString(@"職位");
    _emailOtherLabel.text = HKLocalizedString(@"Register_noteLabel1_title");
    _emailTextLabel.text = HKLocalizedString(@"Register_email");
    _phoneTextLabel.text = HKLocalizedString(@"Register_org_number");
    
    
    [_sexSeg setTitle:HKLocalizedString(@"Register_sexMrButton_title") forSegmentAtIndex:0];
    [_sexSeg setTitle:HKLocalizedString(@"Register_sexMrsButton_title") forSegmentAtIndex:1];
    [_sexSeg setTitle:HKLocalizedString(@"Register_sexMrssButton_title") forSegmentAtIndex:2];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
