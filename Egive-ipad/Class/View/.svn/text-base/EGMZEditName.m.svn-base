//
//  EGMZEditName.m
//  Egive-ipad
//
//  Created by vincentmac on 15/12/25.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGMZEditName.h"

@implementation EGMZEditName



-(void)awakeFromNib{
    self.institutionField.userInteractionEnabled = NO;
    
    _confirmLabel.hidden = YES;
    _confirmField.hidden = YES;
    _hiddenConstraint.constant = 15;
    
    BOOL nor_login = [[NSUserDefaults standardUserDefaults] boolForKey:@"NORMAL_Login"];
    if (!nor_login) {
        _pwdField.userInteractionEnabled = NO;
        _pwdField.enabled = NO;
    }
    
    _nameField.userInteractionEnabled = NO;
    _nameField.enabled = NO;
    
    
    _nameTextLabel.textColor = MemberZoneTextColor;
    _pwdTextLabel.textColor = MemberZoneTextColor;
    _confirmLabel.textColor = MemberZoneTextColor;
    _emailTextLabel.textColor = MemberZoneTextColor;
    _institutionTextLabel.textColor = MemberZoneTextColor;
    _chisurnameTextLabel.textColor = MemberZoneTextColor;
    _chinameTextLabel.textColor = MemberZoneTextColor;
    _engsurnameTextLabel.textColor = MemberZoneTextColor;
    _engnameTextLabel.textColor = MemberZoneTextColor;
    _confirmLabel.textColor = MemberZoneTextColor;
}

-(void)refreshText{

    _nameTextLabel.text = HKLocalizedString(@"Register_userNameTextfile");
    _pwdTextLabel.text = HKLocalizedString(@"Register_mpwsTextfile");
    _emailTextLabel.text = HKLocalizedString(@"Register_email");
    _institutionTextLabel.text = HKLocalizedString(@"Register_belongto");
    _chisurnameTextLabel.text = HKLocalizedString(@"Register_lastNameCh");
    _chinameTextLabel.text = HKLocalizedString(@"Register_nameCh");
    _engsurnameTextLabel.text = HKLocalizedString(@"Register_lastNameEn");
    _engnameTextLabel.text = HKLocalizedString(@"Register_nameEh");
    _confirmLabel.text = HKLocalizedString(@"Register_comfirmpwsTextfile");
    
    
    [_sexSeg setTitle:HKLocalizedString(@"Register_sexMrButton_title") forSegmentAtIndex:0];
    [_sexSeg setTitle:HKLocalizedString(@"Register_sexMrsButton_title") forSegmentAtIndex:1];
    [_sexSeg setTitle:HKLocalizedString(@"Register_sexMrssButton_title") forSegmentAtIndex:2];
}




/*
 
 
 "Register_personalButton_title" = "个人登记";
 "Register_organizationButton_title" = "机构登记";
 "Register_userNameTextfile" = "会员名称";
 "Register_mpwsTextfile" = "登入密码";
 "Register_comfirmpwsTextfile" = "确认密码";
 "Register_noteLabel_title" = "(最少需要6个字元)";
 "Register_sexMrButton_title" = "先生/Mr.";
 "Register_sexMrsButton_title" = "女士/Mrs.";
 "Register_sexMrssButton_title" = "小姐/Miss.";
 "Register_lastNameCh" = "姓(中)";
 "Register_nameCh" = "名(中)";
 "Register_lastNameEn" = "姓(英)";
 "Register_nameEh" = "名(英)";
 "Register_email" = "电邮地址";
 "Register_belongto" = " 所属机构";
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
