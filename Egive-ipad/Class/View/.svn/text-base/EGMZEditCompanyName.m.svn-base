//
//  EGMZEditCompanyName.m
//  Egive-ipad
//
//  Created by vincentmac on 15/12/27.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGMZEditCompanyName.h"

@implementation EGMZEditCompanyName



-(void)awakeFromNib{
    
    _chiConstraint.constant = 35;
//    CGRect rect = self.frame;
//    rect.size.height = 270;
//    self.bounds = (CGRect){0,0,rect.size.width,rect.size.height};
    _pwdField.text = @"******";
    _resetPwdField.text = @"******";
    _resetPwdLabel.hidden = YES;
    _resetPwdField.hidden = YES;
    
    _nameField.userInteractionEnabled = NO;
    _nameField.enabled = NO;

    BOOL nor_login = [[NSUserDefaults standardUserDefaults] boolForKey:@"NORMAL_Login"];
    if (!nor_login) {
        _pwdField.userInteractionEnabled = NO;
        _pwdField.enabled = NO;
    }
    
    
    _nameTextLabel.textColor = MemberZoneTextColor;
    _detailLabel.textColor = MemberZoneTextColor;
    _pwdTextLabel.textColor = MemberZoneTextColor;
    _resetPwdLabel.textColor = MemberZoneTextColor;
    _recordTypeLabel.textColor = MemberZoneTextColor;
    _belongNumberTextLabel.textColor = MemberZoneTextColor;
    _chiTextLabel.textColor = MemberZoneTextColor;
    _engTextLabel.textColor = MemberZoneTextColor;
    _otherLabel.textColor = MemberZoneTextColor;
}

-(void)refreshText{

    [_typeSeg setTitle:HKLocalizedString(@"企业") forSegmentAtIndex:0];
    [_typeSeg setTitle:HKLocalizedString(@"社团组织") forSegmentAtIndex:1];
    [_typeSeg setTitle:HKLocalizedString(@"非牟利组织") forSegmentAtIndex:2];
    [_typeSeg setTitle:HKLocalizedString(@"其他") forSegmentAtIndex:3];

    _nameTextLabel.text = HKLocalizedString(@"Register_userNameTextfile");
    _detailLabel.text = HKLocalizedString(@"请说明");
    _pwdTextLabel.text = HKLocalizedString(@"Register_mpwsTextfile");
    _resetPwdLabel.text = HKLocalizedString(@"Register_comfirmpwsTextfile");
    _recordTypeLabel.text = HKLocalizedString(@"BusinessRegistrationType");
//    _belongNumberTextLabel.text = HKLocalizedString(@"商业登记号码");
//    _belongNumberTextLabel.text = _recordTypeField.text;
    _chiTextLabel.text = HKLocalizedString(@"Register_org_orgNameCh_textFile");
    _engTextLabel.text = HKLocalizedString(@"Register_org_orgNameEn_textFile");
    _otherLabel.text = HKLocalizedString(@"非牟利机构需填写税局档号；社团组织需填写香港社团注册证明书编号");
    
    if ([Language getLanguage]==3) {
        _belongNumberTextLabel.font = [UIFont boldSystemFontOfSize:15];
    }else{
        _belongNumberTextLabel.font = [UIFont boldSystemFontOfSize:17];
    }
}

/*
 "联络人姓名(中)" = "联络人姓名(中)";
 "联络人姓名(英)" = "联络人姓名(英)";
 "修改" = "修改";
 "登出" = "登出";
 
 "Login_userName_textFile" = "会员名称";
 "Login_passWord_textFile" = "密码";
 "Login_loginButton_title" = "登入";
 "Login_registerButton_title" = "会员注册";
 "Login_faceBookButton_title" = "以facebook登入";
 "Login_wbButton_title" = "以微博登入";
 "Login_note_title" = "请输入您的帐号或密码。";
 
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
 "Register_noteLabel1_title" = "(请提供正确邮件地址以确认意赠之友登记资料及接收电子捐款收据)";
 "Register_isEmailButton_title" = "是";
 "Register_noEmailButton_title" = "否";
 "Register_IsEmailNote" = "你是否希望定期收到「意赠」的电邮资讯?";
 "Register_noteLabel3_title" = "你是否愿意成为「意赠」义工,有兴趣参与日后「意赠」义工活动?";
 "Register_yButton_title" = "愿意";
 "Register_nButton_title" = "暂不考虑";
 "Register_commitButton_title" = "提交";
 "Register_org_Button1_title" = "企业";
 "Register_org_Button2_title" = "社团组织";
 "Register_org_Button3_title" = "非牟利组织";
 "Register_org_Button4_title" = "其他";
 "Register_org_orgNameCh_textFile" = "机构名称 (中)";
 "Register_org_orgNameEn_textFile" = "机构名称 (英)";
 "Register_org_position_textFile" = "职位";
 "Register_org_noteLabel" = "联络人姓名";
 "Register_org_number" = "联络电话";
 "Register_org_address" = "机构地址";
 "Register_org_region1" = "室/楼/座";
 "Register_org_region2" = "大楼/楼宇名称";
 "Register_org_region3" = "屋苑/屋邨名称";
 "Register_org_region4" = "门牌号数及街道名称";
 "Register_org_selRegion" = "地区";
 "Register_org_regionButton" = "香港";
 "Register_org_otherButton" = "其他";
 "Register_org_noteLabel1_title" = "(请提供正确邮件地址以确认意赠之友登记资料及接收电子捐款收据)";
 "Register_org_noteLabel2_title" = "(请提供正确通讯地址以便接收资讯)";
 "Register_org_noteLabel3_title" = "你是否愿意成为「意赠」义工,有兴趣参与日后「意赠」义工活动?";
 
 


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
