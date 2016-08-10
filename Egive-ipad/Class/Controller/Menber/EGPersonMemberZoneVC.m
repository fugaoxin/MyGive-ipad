//
//  EGMenberController.m
//  Egive-ipad
//
//  Created by User01 on 15/12/3.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGPersonMemberZoneVC.h"
#import "EGMZShowName.h"
#import "EGMZShowConnections.h"
#import "EGMZShowOther.h"
#import "EGMZTopView.h"
#import "EGMZEditName.h"
#import "EGMZEditAge.h"
#import "EGMZEditConnection.h"
#import "EGMZEditOther.h"
#import "EGMemberZoneModel.h"
#import "EGMyDonationViewController.h"
#import "CZPickerView.h"
#import "NSString+RegexKitLite.h"
#import "EGVerifyTool.h"
#import "EGRegisterAlertViewController.h"


#define kAgePickerTag 100
#define kEducationPickerTag 101
#define kPositionPickerTag 102
#define kBelongPickerTag 103

@interface EGPersonMemberZoneVC ()<UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIPickerViewDelegate,UINavigationControllerDelegate>{


    UIView *_showConentView;
    
    UIView *_editConentView;
    
    EGMZTopView *_showTopView;
    
    EGMZTopView *_editTopView;
    
    EGMZShowName *_showNameView;
    
    EGMZShowOther *_showOtherView;
    
    EGMZShowConnections *_showConnView;
    
    EGMZEditName *_editNameView;
    
    EGMZEditAge *_editAgeView;
    
    EGMZEditOther *_editOtherView;
    
    EGMZEditConnection *_editConnView;
    
    NSString * _base64Avatar;
    
    NSURL *PICurl;
    
    BOOL isChangePWD;
    
    UITapGestureRecognizer *_recordAction;
    
    UITapGestureRecognizer *_rankingAction;
    
//    NSArray *_ageGroupArray;
}


@property (nonatomic,strong) EGMemberInfo *memberInfo;

@property (nonatomic,strong) UIPickerView *agePicker;

@property (nonatomic,strong) UIPickerView *educationPicker;

@property (nonatomic,strong) UIPickerView *positionPicker;

@property (nonatomic,strong) UIPickerView *belongPicker;

@end

@implementation EGPersonMemberZoneVC

- (void)viewDidLoad {
    
//    NSArray *ageGroupArray = @[@"0 - 10",@"11 - 20",@"21 - 30",@"31 - 40",@"41 - 50",@"51 - 60",@"61 - 70",@"71 - 80",@"81 - 90",@"90+"];
//    _ageGroupArray = ageGroupArray;
    
    [super viewDidLoad];

    isChangePWD = NO;
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChangeChange) name:@"LanguageChange" object:nil];
}


-(void)viewWillDisappear:(BOOL)animated{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LanguageChange" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private method

-(void)languageChangeChange{
    [self getSelections];
    [self.belongPicker reloadAllComponents];
    [self.educationPicker reloadAllComponents];
    [self.positionPicker reloadAllComponents];
    _showTopView.donationTextLabel.text = [NSString stringWithFormat:@"%@:",HKLocalizedString(@"个人累积捐款")];
    _editTopView.donationTextLabel.text = [NSString stringWithFormat:@"%@:",HKLocalizedString(@"个人累积捐款")];
    

    [self refreshData];
    [_updateBtn setTitle:HKLocalizedString(@"修改") forState:UIControlStateNormal];
    [_logoutBtn setTitle:HKLocalizedString(@"登出") forState:UIControlStateNormal];
    [_finishBtn setTitle:HKLocalizedString(@"完成") forState:UIControlStateNormal];
   
}

-(void)loadData{
    [SVProgressHUD show];
    NSString *memberId = [EGLoginTool loginSingleton].currentUser.MemberID;
    
    NSString * soapMessage =
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><GetMemberInfo xmlns=\"egive.appservices\"><MemberID>%@</MemberID></GetMemberInfo></soap:Body></soap:Envelope>",memberId];
    
    [EGMemberZoneModel getCompanyInfoWithParams:soapMessage block:^(EGMemberInfo *result, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            
            if (result) {
                self.memberInfo = result;
                [self refreshData];
            }else{
                
                
            }
        }else{
            
            
        }
        
        
    }];
}

-(void)refreshData{
    
    //
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"EGIVE_DonationAmountData"];
    NSString *donStr;
    if (dict) {
        donStr = [NSString stringWithFormat:@"HKD$ %@",dict[@"Amt"]];
    }else{
        donStr = [NSString stringWithFormat:@"HKD$ 0"];
    }
    NSString *topNameStr = [NSString stringWithFormat:@"%@:%@", [NSString stringWithFormat:@"%@",HKLocalizedString(@"个人累积捐款")],donStr];
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:topNameStr];
    [attstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#7C7C7D"] range:[topNameStr rangeOfString:HKLocalizedString(@"个人累积捐款")]];
    [attstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#5F3489"] range:[topNameStr rangeOfString:donStr]];

    _showTopView.topNameLabel.attributedText = attstr;
    _editTopView.topNameLabel.attributedText = attstr;
    
    
    //show
    _editConnView.conNameLabel.text = HKLocalizedString(@"通讯地址");
   
    
    //判断用户是否存在该头像
    if (self.memberInfo.ProfilePicURL.length>0) {
        PICurl = [NSURL URLWithString:SITE_URL];
        PICurl = [PICurl URLByAppendingPathComponent:self.memberInfo.ProfilePicURL];
        [_showTopView.icon_image sd_setImageWithURL:PICurl placeholderImage:[UIImage imageNamed:@"reg_default_personal"]];
    }
    _showTopView.icon_image.layer.cornerRadius = 50;
    _showTopView.icon_image.layer.masksToBounds = YES;
    
    //
     _showNameView.nameLabel.text = self.memberInfo.LoginName;
    _showNameView.institutionLabel.text = self.memberInfo.BelongTo;
    _showNameView.chiLabel.text = [NSString stringWithFormat:@"%@%@",self.memberInfo.ChiLastName,self.memberInfo.ChiFirstName];
    if(_showNameView.chiLabel.text.length<=0){
        _showNameView.chiLabel.text = @"----";
    }
    _showNameView.engLabel.text = [NSString stringWithFormat:@"%@ %@",self.memberInfo.EngLastName,self.memberInfo.EngFirstName];
    if(_showNameView.engLabel.text.length<=0){
        _showNameView.engLabel.text = @"----";
    }
    _showNameView.emailLabel.text = self.memberInfo.Email;
    
    if ([_memberInfo.Sex isEqualToString:@"F"]) {
        _showNameView.sexLabel.text = HKLocalizedString(@"女");
    }else{
        _showNameView.sexLabel.text = HKLocalizedString(@"男");
    }
    
    NSString *belong = _memberInfo.BelongTo;
    for (NSDictionary *dict in self.belongToOptions) {
        if ([belong isEqualToString:dict[@"Cd"]]) {
            _editNameView.institutionField.text = dict[@"Desp"];
            _showNameView.institutionLabel.text = dict[@"Desp"];
            break;
        }
    }
    
    //
    NSString *ageStr;
    
    if ([_memberInfo.AgeGroup isEqualToString:@" "]) {
        _showConnView.ageLabel.text = @"----";
    }else{
        
        if (self.ageGroups.count>0) {
            NSInteger age = [_memberInfo.AgeGroup integerValue];
            switch (age) {
                case 0:
                    _showConnView.ageLabel.text = self.ageGroups[0][@"Desp"];
                    break;
                case 1:
                    _showConnView.ageLabel.text = self.ageGroups[1][@"Desp"];
                    break;
                case 2:
                    _showConnView.ageLabel.text = self.ageGroups[2][@"Desp"];
                    break;
                case 3:
                    _showConnView.ageLabel.text = self.ageGroups[3][@"Desp"];
                    break;
                case 4:
                    _showConnView.ageLabel.text = self.ageGroups[4][@"Desp"];
                    break;
                case 5:
                    _showConnView.ageLabel.text = self.ageGroups[5][@"Desp"];
                    break;
                case 6:
                    _showConnView.ageLabel.text = self.ageGroups[6][@"Desp"];
                    break;
                case 7:
                    _showConnView.ageLabel.text = self.ageGroups[7][@"Desp"];
                    break;
                case 8:
                    _showConnView.ageLabel.text = self.ageGroups[8][@"Desp"];
                    break;
                case 9:
                    _showConnView.ageLabel.text = self.ageGroups[9][@"Desp"];
                    break;
                default:
                    break;
            }
            ageStr = _showConnView.ageLabel.text;
        }
    }
    
    if (_memberInfo.TelCountryCode.length>0) {
        _showConnView.phoneLabel.text = [NSString stringWithFormat:@"(%@)%@",_memberInfo.TelCountryCode,_memberInfo.TelNo];
    }else{
        _showConnView.phoneLabel.text = _memberInfo.TelNo;
    }
    if( _showConnView.phoneLabel.text.length<=0){
         _showConnView.phoneLabel.text = @"----";
    }
    _showConnView.jobLabel.text = _memberInfo.Position;
    _showConnView.addLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",self.memberInfo.AddressDistrict,self.memberInfo.AddressStreet,self.memberInfo.AddressEstate,self.memberInfo.AddressBldg,self.memberInfo.AddressRoom];
    if([_showConnView.addLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""].length<=0){
        _showConnView.addLabel.text = @"----";
    }
    NSString *educationLevel = _memberInfo.EducationLevel;
    if ([educationLevel isEqualToString:@"U"]) {
        _showConnView.educationLabel.text = HKLocalizedString(@"大专或以上");
    }else if ([educationLevel isEqualToString:@"P"]){
        _showConnView.educationLabel.text = HKLocalizedString(@"小学或以下");
    }else if ([educationLevel isEqualToString:@"S"]){
        _showConnView.educationLabel.text = HKLocalizedString(@"中学");
    }else{
        _showConnView.educationLabel.text = @"----";
    }
    
    EGUserModel *user = [EGLoginTool loginSingleton].currentUser;
    
    //
    //other
    NSString *egivetype = self.memberInfo.HowToKnoweGive;
    
    NSMutableString *str = [[NSMutableString alloc] init];
    NSArray *egives ;
    if (egivetype.length>0 ) {
        egives = [egivetype componentsSeparatedByString:@","];
    }
    
    
    if (egives.count>0) {
        for (NSString *s in egives) {
            if ([s isEqualToString:@"Donor"]) {
                [str appendString: [NSString stringWithFormat:@"%@, ",HKLocalizedString(@"為「意贈」的捐款者")]];
                _editOtherView.donationButton.selected = YES;
            }else if ([s isEqualToString:@"Web"]){
                [str appendString: [NSString stringWithFormat:@"%@, ",HKLocalizedString(@"「意贈」網頁")]];
                _editOtherView.webButton.selected = YES;
            }else if ([s isEqualToString:@"Friend"]){
                [str appendString: [NSString stringWithFormat:@"%@, ",HKLocalizedString(@"朋友")]];
                _editOtherView.friendButton.selected = YES;
            }else if ([s isEqualToString:@"News"]){
                [str appendString: [NSString stringWithFormat:@"%@, ",HKLocalizedString(@"報章")]];
                _editOtherView.paperButton.selected = YES;
            }else if ([s isEqualToString:@"Event"]){
                [str appendString: [NSString stringWithFormat:@"%@, ",HKLocalizedString(@"「意贈」活動/刊物")]];
                _editOtherView.activityButton.selected = YES;
            }else if ([s isEqualToString:@"Social"]){
                [str appendString: [NSString stringWithFormat:@"%@,",HKLocalizedString(@"社交媒體(Facebook、新浪微博等)")]];
                _editOtherView.socialButton.selected = YES;
            }
        }
    }
    
    if (str.length>0) {
        
        NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
        _showOtherView.Label2.text = [str substringWithRange:NSMakeRange(0, range.location)];
        //_otherView.Label2.text = [str substringWithRange:NSMakeRange(0, str.length-1)];
    }else{
        NSString *ss;
        
        if ([egivetype isEqualToString:@"Donor"]) {
            ss = HKLocalizedString(@"為「意贈」的捐款者");
        }else if ([egivetype isEqualToString:@"Web"]){
            ss = HKLocalizedString(@"「意贈」網頁");
        }else if ([egivetype isEqualToString:@"Friend"]){
            ss = HKLocalizedString(@"朋友");
        }else if ([egivetype isEqualToString:@"News"]){
            ss = HKLocalizedString(@"報章");
        }else if ([egivetype isEqualToString:@"Event"]){
            ss = HKLocalizedString(@"「意贈」活動/刊物");
        }else if ([egivetype isEqualToString:@"Social"]){
            ss = HKLocalizedString(@"社交媒體(Facebook、新浪微博等)");
        }
        _showOtherView.Label2.text = ss;
    }
    
    if (_showOtherView.Label2.text.length<=0) {
        _showOtherView.Label2.text = @"----";
    }
    
    if (self.memberInfo.HowToKnoweGive_Other.length>0) {
        _editOtherView.otherButton.selected = YES;
    }
    
    /*
     Donor – 為「意贈」的捐款者
     Web – 「意贈」網頁
     Friend – 朋友
     News – 報章
     Event – 「意贈」活動/刊物
     Social - 社交媒體(Facebook、新浪微博等)
     **/
    
    //
    if (_memberInfo.AcceptEDM) {
        NSArray *intserests = [_memberInfo.DonationInterest componentsSeparatedByString:@","];
        
        NSMutableString *donationInterestStr = [[NSMutableString alloc] init];
        [donationInterestStr appendString:[NSString stringWithFormat:@"%@,%@ ",HKLocalizedString(@"Register_isEmailButton_title"),HKLocalizedString(@"希望定期收到")]];
        for (NSString *s in intserests) {
            
            if ([s isEqualToString:@"S"]) {
                [donationInterestStr appendString:[NSString stringWithFormat:@"%@,",HKLocalizedString(@"助学")]];
            }else if ([s isEqualToString:@"M"]){
                [donationInterestStr appendString:[NSString stringWithFormat:@"%@,",HKLocalizedString(@"助医")]];
            }else if ([s isEqualToString:@"U"]){
                [donationInterestStr appendString:[NSString stringWithFormat:@"%@,",HKLocalizedString(@"紧急援助")]];
            }else if ([s isEqualToString:@"A"]){
                [donationInterestStr appendString:[NSString stringWithFormat:@"%@,",HKLocalizedString(@"意赠行动")]];
            }else if ([s isEqualToString:@"E"]){
                [donationInterestStr appendString:[NSString stringWithFormat:@"%@,",HKLocalizedString(@"安老")]];
            }else if ([s isEqualToString:@"P"]){
                [donationInterestStr appendString:[NSString stringWithFormat:@"%@,",HKLocalizedString(@"扶贫")]];
            }else if ([s isEqualToString:@"O"]){
                [donationInterestStr appendString:[NSString stringWithFormat:@"%@,",HKLocalizedString(@"其他")]];
            }else if ([s isEqualToString:@"L"]){
                [donationInterestStr appendString:[NSString stringWithFormat:@"%@,",HKLocalizedString(@"全部")]];
            }
        }
        NSRange range = [donationInterestStr rangeOfString:@"," options:NSBackwardsSearch];
        _showOtherView.Label4.text = [donationInterestStr substringWithRange:NSMakeRange(0, range.location)];;
    }else{
        _showOtherView.Label4.text = HKLocalizedString(@"Register_noEmailButton_title");
    }
    
    
    
    //
    if (_memberInfo.JoinVolunteer) {
        _showOtherView.Label6.text = HKLocalizedString(@"Register_yButton_title");
    }else{
        _showOtherView.Label6.text = HKLocalizedString(@"Register_nButton_title");
        
    }
    
    
    //edit
    //判断用户是否存在该头像
    if ([self.memberInfo.ProfilePicURL isEqualToString:@""] || self.memberInfo.ProfilePicURL == nil) {
        if ([self.memberInfo.Sex isEqualToString:@"M"] || [self.memberInfo.ChiNameTitle isEqualToString:@"R"]) {
            //_IconImage.image = [UIImage imageNamed:@"donor_detail_male@2x.png"];
            PICurl = [NSURL URLWithString:@"http://www.egiveforyou.com/Images/default_m.jpg"];
            [_editTopView.icon_image sd_setImageWithURL:PICurl placeholderImage:[UIImage imageNamed:@"reg_default_personal"]];
            
        }else{
            //_IconImage.image = [UIImage imageNamed:@"donor_detail_female@2x.png"];
            PICurl = [NSURL URLWithString:@"http://www.egiveforyou.com/Images/default_f.jpg"];
            [_editTopView.icon_image sd_setImageWithURL:PICurl placeholderImage:[UIImage imageNamed:@"reg_default_personal"]];
            
        }
    }else{
        PICurl = [NSURL URLWithString:SITE_URL];
        PICurl = [PICurl URLByAppendingPathComponent:self.memberInfo.ProfilePicURL];
        [_editTopView.icon_image sd_setImageWithURL:PICurl placeholderImage:[UIImage imageNamed:@"reg_default_personal"]];
    }
    
    _editTopView.icon_image.layer.cornerRadius = 50;
    _editTopView.icon_image.layer.masksToBounds = YES;
    _editTopView.icon_image.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTap)];
    [_editTopView.icon_image addGestureRecognizer:imageTap];
    
    //_IconImage = _editTopView.icon_image;
    
    //
    _editNameView.nameField.text = _memberInfo.LoginName;
//    _editNameView.pwdField.text = user.password;
//    _editNameView.confirmField.text = user.password;
    _editNameView.emailField.text = _memberInfo.Email;
    _editNameView.chinameField.text = _memberInfo.ChiFirstName;
    _editNameView.chisurnameField.text = _memberInfo.ChiLastName;
    _editNameView.engsurnameField.text = _memberInfo.EngLastName;
    _editNameView.engnameField.text = _memberInfo.EngFirstName;
    NSString *sex = _memberInfo.ChiNameTitle;
    if ([sex isEqualToString:@"R"]) {
        _editNameView.sexSeg.selectedSegmentIndex = 0;
    }else if ([sex isEqualToString:@"S"]){
        _editNameView.sexSeg.selectedSegmentIndex = 1;
    }else if ([sex isEqualToString:@"M"]){
        _editNameView.sexSeg.selectedSegmentIndex = 2;
    }
    

    
    //
    _editAgeView.phoneHeadField.text = _memberInfo.TelCountryCode;
    _editAgeView.phoneNumField.text = _memberInfo.TelNo;
    _editAgeView.ageField.text = ageStr;
    
    NSString *edu = _memberInfo.EducationLevel;
    if ([edu isEqualToString:@"P"]) {
        _editAgeView.educationField.text = HKLocalizedString(@"小学或以下");
    }else if ([edu isEqualToString:@"S"]){
        _editAgeView.educationField.text = HKLocalizedString(@"中学");
    }else if ([edu isEqualToString:@"U"]){
        _editAgeView.educationField.text = HKLocalizedString(@"大专或以上");
    }
    
    NSString *postion = _memberInfo.Position;
    
    if (postion.length>0) {
        for (NSDictionary *dict in self.jobs) {
            if ([postion isEqualToString:dict[@"Cd"]]) {
                _editAgeView.workField.text = dict[@"Desp"];
                _showConnView.jobLabel.text = dict[@"Desp"];
                break;
            }
        }
    }else{
        _editAgeView.workField.text = @"";
        _showConnView.jobLabel.text = @"----";
    }
    
    
    //
    _editConnView.Field1.text = self.memberInfo.AddressRoom;
    _editConnView.Field2.text = self.memberInfo.AddressBldg;
    _editConnView.Field3.text = self.memberInfo.AddressEstate;
    
    _editConnView.Field4.text = self.memberInfo.AddressStreet;
    _editConnView.Field5.text = self.memberInfo.AddressDistrict;
//    _editConnView.otherField.text = self.memberInfo.AddressCountry;
    
    
    //
    BOOL acceptEmail = _memberInfo.AcceptEDM;
    
    if (acceptEmail) {
        _editOtherView.emailSeg.selectedSegmentIndex = 0;
        NSString *interestStr = self.memberInfo.DonationInterest;
        NSArray *interestArray = [interestStr componentsSeparatedByString:@","];
        
        for (NSString *s in interestArray) {
            if ([s isEqualToString:@"S"]) {
                
                _editOtherView.Button1.selected = YES;
            }else if ([s isEqualToString:@"M"]){
                
                _editOtherView.Button2.selected = YES;
            }else if ([s isEqualToString:@"U"]){
                
                _editOtherView.Button3.selected = YES;
            }else if ([s isEqualToString:@"A"]){
                
                _editOtherView.Button4.selected = YES;
            }else if ([s isEqualToString:@"E"]){
                
                _editOtherView.Button5.selected = YES;
            }else if ([s isEqualToString:@"P"]){
                
                _editOtherView.Button6.selected = YES;
            }else if ([s isEqualToString:@"O"]){
                
                _editOtherView.Button7.selected = YES;
            }else if ([s isEqualToString:@"L"]){
                
                _editOtherView.Button8.selected = YES;
            }
        }
        
    }else{
        _editOtherView.emailSeg.selectedSegmentIndex = 1;
    }
    _editOtherView.acceptEmail = acceptEmail;
    
    
    /*
     S – 助學
     E – 安老
     M – 助醫
     P – 扶貧
     U – 緊急援助
     O – 其他
     A – 意贈行動
     L – 全部
     
     */
    
    
    
    BOOL joinVolunteer = _memberInfo.JoinVolunteer;
    //
    if (joinVolunteer) {
        _editOtherView.workView.hidden = NO;
        _editOtherView.workSeg.selectedSegmentIndex = 0;
        
        if ([[_memberInfo.VolunteerType description] isEqualToString:@"S"]) {
            _editOtherView.startTimeField.text = _memberInfo.VolunteerStartDate;
            _editOtherView.endTimeField.text = _memberInfo.VolunteerEndDate;
        }
        
        NSString *volunteerInterest = _memberInfo.VolunteerInterest;
        NSArray *volunteerArray = [volunteerInterest componentsSeparatedByString:@","];
        
//        if (_memberInfo.VolunteerInterest.length<=0) {
//            [_editOtherView clearWorkSelected];
//        }
        
        for (NSString *s in volunteerArray) {
            if ([s isEqualToString:@"Admin"]) {
                
                _editOtherView.workButton1.selected = YES;
                _showOtherView.workButton1.selected = YES;
            }else if ([s isEqualToString:@"Print"]){
                
                _editOtherView.workButton2.selected = YES;
                _showOtherView.workButton2.selected = YES;
            }else if ([s isEqualToString:@"Contact"]){
                
                _editOtherView.workButton3.selected = YES;
                _showOtherView.workButton3.selected = YES;
            }else if ([s isEqualToString:@"Editing"]){
                
                _editOtherView.workButton4.selected = YES;
                _showOtherView.workButton4.selected = YES;
            }else if ([s isEqualToString:@"Translate"]){
                
                _editOtherView.workButton5.selected = YES;
                _showOtherView.workButton5.selected = YES;
            }else if ([s isEqualToString:@"Write"]){
                
                _editOtherView.workButton6.selected = YES;
                
                _showOtherView.workButton6.selected = YES;
            }else if ([s isEqualToString:@"Photo"]){
                
                _editOtherView.workButton7.selected = YES;
                _showOtherView.workButton7.selected = YES;
            }else if ([s isEqualToString:@"Event"]){
                
                _editOtherView.workButton8.selected = YES;
                _showOtherView.workButton8.selected = YES;
            }else if ([s isEqualToString:@"Visit"]){
                
                _editOtherView.workButton9.selected = YES;
                _showOtherView.workButton9.selected = YES;
            }
        }
        
        if (_memberInfo.VolunteerInterest_Other.length>0) {
            _editOtherView.workButton10.selected = YES;
            _editOtherView.workLabel16.hidden = NO;
            _editOtherView.otherField.hidden = NO;
            _editOtherView.otherField.text = _memberInfo.VolunteerInterest_Other;
            _showOtherView.otherField.text = _memberInfo.VolunteerInterest_Other;
            
            _showOtherView.workButton10.selected = YES;
            _showOtherView.workLabel16.hidden = NO;
            _showOtherView.otherField.hidden = NO;
            _showOtherView.otherField.enabled = NO;
        }else{
            _editOtherView.workButton10.selected = NO;
            _editOtherView.otherField.hidden = YES;
            _editOtherView.workLabel16.hidden = YES;
            _editOtherView.otherField.text = @"";
            
            _showOtherView.workButton10.selected = NO;
            _showOtherView.otherField.hidden = YES;
            _showOtherView.workLabel16.hidden = YES;
            _showOtherView.otherField.enabled = NO;
        }
        
        //
        NSString *availableTime = _memberInfo.AvailableTime;
        NSArray *timeArray = [availableTime componentsSeparatedByString:@","];
        
//        if (_memberInfo.AvailableTime.length<=0) {
//            [_editOtherView clearTimeSelected];
//        }
        
        
        for (NSString *s in timeArray) {
            if ([s isEqualToString:@"Mon"]) {
                
                _editOtherView.timeButton1.selected = YES;
                
                _showOtherView.timeButton1.selected = YES;
            }else if ([s isEqualToString:@"Tues"]){
                _showOtherView.timeButton2.selected = YES;
                _editOtherView.timeButton2.selected = YES;
            }else if ([s isEqualToString:@"Wed"]){
                _showOtherView.timeButton3.selected = YES;
                _editOtherView.timeButton3.selected = YES;
            }else if ([s isEqualToString:@"Thurs"]){
                _showOtherView.timeButton4.selected = YES;
                _editOtherView.timeButton4.selected = YES;
            }else if ([s isEqualToString:@"Fri"]){
                _showOtherView.timeButton5.selected = YES;
                _editOtherView.timeButton5.selected = YES;
            }else if ([s isEqualToString:@"Sat"]){
                _showOtherView.timeButton6.selected = YES;
                _editOtherView.timeButton6.selected = YES;
            }else if ([s isEqualToString:@"Sun"]){
                _showOtherView.timeButton7.selected = YES;
                _editOtherView.timeButton7.selected = YES;
            }else if ([s isEqualToString:@"All"]){
                _showOtherView.timeButton8.selected = YES;
                _editOtherView.timeButton8.selected = YES;
            }else if ([s isEqualToString:@"Morning"]){
                _showOtherView.timeButton9.selected = YES;
                _editOtherView.timeButton9.selected = YES;
            }else if ([s isEqualToString:@"Afternoon"]){
                _showOtherView.timeButton10.selected = YES;
                _editOtherView.timeButton10.selected = YES;
            }else if ([s isEqualToString:@"Evening"]){
                _showOtherView.timeButton11.selected = YES;
                _editOtherView.timeButton11.selected = YES;
            }else if ([s isEqualToString:@"WholeDay"]){
                _showOtherView.timeButton12.selected = YES;
                _editOtherView.timeButton12.selected = YES;
            }
        }

        
        if (_memberInfo.AvailableTime_Other.length>0) {
            _editOtherView.timeButton13.selected = YES;
            _editOtherView.workLabel31.hidden = NO;
            _editOtherView.timeField.hidden = NO;
            _editOtherView.timeField.text = _memberInfo.AvailableTime_Other;
            
            _showOtherView.timeButton13.selected = YES;
            _showOtherView.workLabel31.hidden = NO;
            _showOtherView.timeField.hidden = NO;
            _showOtherView.timeField.text = _memberInfo.AvailableTime_Other;
            _showOtherView.timeField.enabled = NO;
        }else{
            _editOtherView.timeButton13.selected = NO;
            _editOtherView.workLabel31.hidden = YES;
            _editOtherView.timeField.hidden = YES;
            _editOtherView.workLabel31.hidden = YES;
            _editOtherView.timeField.text = @"";
            
            _showOtherView.timeButton13.selected = NO;
            _showOtherView.workLabel31.hidden = YES;
            _showOtherView.timeField.hidden = YES;
            _showOtherView.workLabel31.hidden = YES;
        }
        
        
        if ([_memberInfo.VolunteerType isEqualToString:@"S"]) {
            _showOtherView.sureSeg.selectedSegmentIndex = 1;
            _showOtherView.startTimeField.text = _memberInfo.VolunteerStartDate;
            _showOtherView.endTimeField.text = _memberInfo.VolunteerEndDate;
            _showOtherView.startTimeField.enabled = NO;
            _showOtherView.endTimeField.enabled = NO;
            
            
            _editOtherView.sureSeg.selectedSegmentIndex = 1;
            [self hiddenTimeView:NO];
        }else{
            _showOtherView.sureSeg.selectedSegmentIndex = 0;
            _editOtherView.sureSeg.selectedSegmentIndex = 0;
            [self hiddenTimeView:YES];
        }
        
        [_editOtherView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(780);
        }];
        
        [_showOtherView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(690);
            
        }];
        
        _showOtherView.workView.hidden = NO;
        _showOtherView.sureSeg.userInteractionEnabled = NO;
        _showOtherView.startTimeField.enabled = NO;
        _showOtherView.endTimeField.enabled = NO;
    }else{
        _editOtherView.workSeg.selectedSegmentIndex = 1;
        _editOtherView.workView.hidden = YES;
        
        
        _editOtherView.timeField.hidden = YES;
        _editOtherView.workLabel31.hidden = YES;
        _editOtherView.otherField.hidden = YES;
        _editOtherView.workLabel16.hidden = YES;
        
        if(_memberInfo.AcceptEDM){
            [_editOtherView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(290);
            }];
        }else{
            [_editOtherView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(290-65);
            }];
        }
        
        //
        [_showOtherView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(200);
            
        }];
        
        _showOtherView.workView.hidden = YES;
        
    }
}

-(void)setupUI{
    
    //
    _recordAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pRecordTap)];
    _rankingAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pRankingTap)];

    //
    _finishBtn.layer.cornerRadius = 6;
    _logoutBtn.layer.cornerRadius = 6;
    _updateBtn.layer.cornerRadius = 6;
    
    //
    [self setupShowScrollerView];
    
    [self setupEditScrollerView];
    
    [self languageChangeChange];
}


-(void)setupEditScrollerView{
    TPKeyboardAvoidingScrollView *scrollView = [TPKeyboardAvoidingScrollView new];
    self.editScrollView = scrollView;
    self.editScrollView.hidden = YES;
    _finishBtn.hidden = YES;

    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.leading.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-60);
    }];
    self.editScrollView.bounces = NO;
    
    //
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:container];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    EGMZTopView *top = [[[NSBundle mainBundle] loadNibNamed:@"EGMZTopView" owner:self options:nil] lastObject];
    _editTopView = top;
    top.backgroundColor = [UIColor colorWithHexString:@"#F6F6F8"];
    [container addSubview:top];
    [top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(container);
        make.leading.equalTo(container);
        make.width.equalTo(container);
        make.height.mas_equalTo(170);
    }];

    //
    top.rankingView.userInteractionEnabled = YES;
    top.recordView.userInteractionEnabled = YES;
    [top.rankingView addGestureRecognizer:_rankingAction];
    [top.recordView addGestureRecognizer:_recordAction];

    //
    EGMZEditName *editNameView = [[[NSBundle mainBundle] loadNibNamed:@"EGMZEditName" owner:self options:nil] lastObject];
    _editNameView = editNameView;
    [container addSubview:editNameView];
    [editNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(container);
        make.top.equalTo(top.mas_bottom);
        make.width.equalTo(container);
        make.height.mas_equalTo(250);
    }];
    
   

    [editNameView.pwdField bk_addEventHandler:^(id sender) {
        isChangePWD = YES;
        editNameView.confirmField.hidden = NO;
        editNameView.confirmLabel.hidden = NO;
        _editNameView.pwdField.text = @"";
        _editNameView.confirmField.text = @"";
        editNameView.hiddenConstraint.constant = 60;
        [editNameView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(280);
        }];
    } forControlEvents:UIControlEventEditingDidBegin];
    
    
    [_editNameView.chisurnameField bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.ChiLastName = field.text;
    } forControlEvents:UIControlEventEditingDidEnd];
    
    [_editNameView.chinameField bk_addEventHandler:^(UITextField *field) {
        
        self.memberInfo.ChiFirstName = field.text;
    } forControlEvents:UIControlEventEditingDidEnd];
    
    [_editNameView.engsurnameField bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.EngLastName = field.text;
    } forControlEvents:UIControlEventEditingDidEnd];
    
    [_editNameView.engnameField bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.EngFirstName = field.text;
    } forControlEvents:UIControlEventEditingDidEnd];
    
    [_editNameView.emailField  bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.Email = field.text;
    } forControlEvents:UIControlEventEditingDidEnd];
    

    [editNameView.belongDropButton bk_addEventHandler:^(id sender) {
        
        self.belongPicker.hidden = self.belongPicker.hidden ? NO : YES;
        
        if (self.belongPicker.hidden) {
            [editNameView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(250);
            }];
        }else{
            [editNameView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(350);
            }];
        }
        
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    [editNameView.sexSeg bk_addEventHandler:^(UISegmentedControl *seg) {
        NSInteger selectedSegmentIndex = seg.selectedSegmentIndex;
        
        if (selectedSegmentIndex == 0) {
            self.memberInfo.ChiNameTitle = @"R";
            self.memberInfo.EngNameTitle = @"R";
            self.memberInfo.Sex = @"M";
        }else if (selectedSegmentIndex == 1){
            self.memberInfo.ChiNameTitle = @"S";
            self.memberInfo.EngNameTitle = @"S";
            self.memberInfo.Sex = @"F";
        }else if (selectedSegmentIndex == 2){
            self.memberInfo.ChiNameTitle = @"M";
            self.memberInfo.EngNameTitle = @"M";
            self.memberInfo.Sex = @"F";
        }
    } forControlEvents:UIControlEventValueChanged];
    
    [editNameView.coverButton bk_addEventHandler:^(id sender) {
        
        self.belongPicker.hidden = self.belongPicker.hidden ? NO : YES;
        
        if (self.belongPicker.hidden) {
            [editNameView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(250);
            }];
        }else{
            [editNameView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(350);
            }];
        }
        
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    EGMZEditAge *editAgeView = [[[NSBundle mainBundle] loadNibNamed:@"EGMZEditAge" owner:self options:nil] lastObject];
    _editAgeView = editAgeView;
    [container addSubview:editAgeView];
    
    
    [editAgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(container);
        make.top.equalTo(editNameView.mas_bottom);
        make.width.equalTo(container);
        make.height.mas_equalTo(100);
    }];
    
    //
    [editAgeView.ageDropButton bk_addEventHandler:^(id sender) {
       
        self.agePicker.hidden = self.agePicker.hidden ? NO : YES;
        
        if (self.agePicker.hidden) {
            [editAgeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(100);
            }];
            self.educationPicker.hidden = YES;
            self.positionPicker.hidden = YES;
            
            
            
            
        }else{
            [editAgeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(200);
            }];
            
            [_agePicker mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_editAgeView.ageField.mas_bottom).offset(0);
                make.height.mas_equalTo(60);
            }];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    [editAgeView.phoneHeadField bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.TelCountryCode = field.text;
    } forControlEvents:UIControlEventEditingDidEnd];
    
    [editAgeView.phoneNumField bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.TelNo = field.text;
    } forControlEvents:UIControlEventEditingDidEnd];
    
    [editAgeView.coverButton1 bk_addEventHandler:^(id sender) {
        
        self.agePicker.hidden = self.agePicker.hidden ? NO : YES;
        
        if (self.agePicker.hidden) {
            [editAgeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(100);
            }];
            self.educationPicker.hidden = YES;
            self.positionPicker.hidden = YES;
        }else{
            [editAgeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(200);
            }];
            
            if (IOS9_OR_LATER) {
                
            }else{
            
//                [editAgeView mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.height.mas_equalTo(200);
//                }];
                
                [_agePicker mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_editAgeView.ageField.mas_bottom).offset(0);
                    make.height.mas_equalTo(80);
                }];
            }
            
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    //
    [editAgeView.eductionDropButton bk_addEventHandler:^(id sender) {
         self.educationPicker.hidden = self.educationPicker.hidden ? NO : YES;

        if (self.educationPicker.hidden) {
            [editAgeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(100);
            }];
            self.agePicker.hidden = YES;
            self.positionPicker.hidden = YES;
        }else{
            [editAgeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(200);
            }];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    [editAgeView.coverButton2 bk_addEventHandler:^(id sender) {
        self.educationPicker.hidden = self.educationPicker.hidden ? NO : YES;
        
        if (self.educationPicker.hidden) {
            [editAgeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(100);
            }];
            self.agePicker.hidden = YES;
            self.positionPicker.hidden = YES;
        }else{
           
            [editAgeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(200);
            }];
            if (IOS9_OR_LATER) {
                
            }else{
//                [editAgeView mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.height.mas_equalTo(250);
//                }];
                
                [_educationPicker mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_editAgeView.educationField.mas_bottom).offset(0);
                    make.height.mas_equalTo(80);
                }];
            }
            
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    //
    [editAgeView.workDropButton bk_addEventHandler:^(id sender) {
        self.positionPicker.hidden = self.positionPicker.hidden ? NO : YES;
        
        if (self.positionPicker.hidden) {
            [editAgeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(100);
            }];
            self.educationPicker.hidden = YES;
            self.agePicker.hidden = YES;
        }else{
            [editAgeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(250);
            }];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    [editAgeView.coverButton3 bk_addEventHandler:^(id sender) {
        self.positionPicker.hidden = self.positionPicker.hidden ? NO : YES;
        
        if (self.positionPicker.hidden) {
            [editAgeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(100);
            }];
            self.educationPicker.hidden = YES;
            self.agePicker.hidden = YES;
        }else{
            [editAgeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(200);
            }];
            
            if (IOS9_OR_LATER) {
                
            }else{
//                [editAgeView mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.height.mas_equalTo(250);
//                }];
                
                [_positionPicker mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_editAgeView.workField.mas_bottom).offset(0);
                    make.height.mas_equalTo(80);
                }];
            
            }
            
           
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    //
    EGMZEditConnection *editConnectionView = [[[NSBundle mainBundle] loadNibNamed:@"EGMZEditConnection" owner:self options:nil] lastObject];
    [container addSubview:editConnectionView];
    _editConnView = editConnectionView;
    [editConnectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(container);
        make.top.equalTo(editAgeView.mas_bottom);
        make.width.equalTo(container);
        make.height.mas_equalTo(235);
    }];
    //
    [editConnectionView.Field1 bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.AddressRoom = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    //
    [editConnectionView.Field2 bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.AddressBldg = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    //
    [editConnectionView.Field3 bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.AddressEstate = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    //
    [editConnectionView.Field4 bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.AddressStreet = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    //
    [editConnectionView.Field5 bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.AddressDistrict = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    //
    [editConnectionView.otherField bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.AddressCountry = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    
    //
    EGMZEditOther *editOtherView = [[[NSBundle mainBundle] loadNibNamed:@"EGMZEditOther" owner:self options:nil] lastObject];
    _editOtherView = editOtherView;
    [container addSubview:editOtherView];
    [editOtherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(container);
        make.top.equalTo(editConnectionView.mas_bottom);
        make.width.equalTo(container);
        make.height.mas_equalTo(780);//290
    }];
    
    
    //
    [editOtherView.emailSeg bk_addEventHandler:^(UISegmentedControl *seg) {
        
        if (seg.selectedSegmentIndex==0) {
            self.memberInfo.AcceptEDM = YES;
            
            if (!_memberInfo.JoinVolunteer) {
                [editOtherView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(290);
                }];
            }
        }else{
            self.memberInfo.AcceptEDM = NO;
            
            
            if (!_memberInfo.JoinVolunteer) {
                [editOtherView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(290-65);
                }];
            }
        }
    } forControlEvents:UIControlEventValueChanged];
    
    [editOtherView.workSeg bk_addEventHandler:^(UISegmentedControl *seg) {
        if (seg.selectedSegmentIndex==0) {
            self.memberInfo.JoinVolunteer = YES;
            _editOtherView.workView.hidden = NO;
            [editOtherView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(780);
            }];
            
            if ([self.memberInfo.VolunteerType isEqualToString: @"L"]) {
                editOtherView.sureSeg.selectedSegmentIndex = 0;
            }else{
                editOtherView.sureSeg.selectedSegmentIndex = 1;
            }

        }else{
            self.memberInfo.JoinVolunteer = NO;
            _editOtherView.workView.hidden = YES;
            
            [editOtherView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(290);
            }];
        }
        [self refreshData];
    } forControlEvents:UIControlEventValueChanged];
    
    [editOtherView.otherField bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.VolunteerInterest_Other = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    [editOtherView.timeField bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.AvailableTime_Other = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    editOtherView.workView.userInteractionEnabled = YES;
    [editOtherView.sureSeg bk_addEventHandler:^(UISegmentedControl *seg) {

        if (seg.selectedSegmentIndex==0) {
            self.memberInfo.VolunteerType = @"L";
            
            [self hiddenTimeView:YES];
            
        }else{
            self.memberInfo.VolunteerType = @"S";
            
           [self hiddenTimeView:NO];
        }
    } forControlEvents:UIControlEventValueChanged];
    
    
    //
//    EGMZShowConnections *showConnectionView = [[[NSBundle mainBundle] loadNibNamed:@"EGMZShowConnections" owner:self options:nil] lastObject];
//    [container addSubview:showConnectionView];
//    
//    [showConnectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(showNameView.mas_bottom);
//        make.leading.equalTo(container);
//        make.width.equalTo(container);
//        make.height.mas_equalTo(150);
//    }];
//    
//    EGMZShowOther *other = [[[NSBundle mainBundle] loadNibNamed:@"EGMZShowOther" owner:self options:nil] lastObject];
//    [container addSubview:other];
//    
//    [other mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(showConnectionView.mas_bottom);
//        make.leading.equalTo(container);
//        make.width.equalTo(container);
//        make.height.mas_equalTo(220);
//    }];
    
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(editOtherView.mas_bottom);
    }];
}


-(void)hiddenTimeView:(BOOL)hidden{
    if (hidden) {
        CGFloat height = 715;
        if (!self.memberInfo.AcceptEDM) {
            height = 715-65;
        }
        
        [_editOtherView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        
        _editOtherView.workLabel3.hidden = YES;
        _editOtherView.workLabel4.hidden = YES;
        _editOtherView.startTimeField.hidden = YES;
        _editOtherView.endTimeField.hidden = YES;
        
        
        _editOtherView.timeViewHeight.constant = 0.5;
    }else{
    
        CGFloat height = 780;
        if (!self.memberInfo.AcceptEDM) {
            height = 780-65;
        }
        
        [_editOtherView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(780);
        }];
        
        _editOtherView.workLabel3.hidden = NO;
        _editOtherView.workLabel4.hidden = NO;
        _editOtherView.startTimeField.hidden = NO;
        _editOtherView.endTimeField.hidden = NO;

        _editOtherView.timeViewHeight.constant = 65;
    }
}


-(void)setupShowScrollerView{
    
//    _topBgView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F8"];
    self.showScrollView.backgroundColor = [UIColor whiteColor];
    TPKeyboardAvoidingScrollView *ss = [TPKeyboardAvoidingScrollView new];
    self.showScrollView = ss;
    ss.scrollEnabled = YES;
    [self.view addSubview:ss];
    [ss mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.leading.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-60);
    }];

    self.showScrollView.bounces = NO;
    
    //
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = [UIColor lightGrayColor];
    [ss addSubview:container];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ss);
        make.width.equalTo(ss);
    }];
    
    EGMZTopView *top = [[[NSBundle mainBundle] loadNibNamed:@"EGMZTopView" owner:self options:nil] lastObject];
    top.backgroundColor = [UIColor colorWithHexString:@"#F6F6F8"];
    _showTopView = top;
    [container addSubview:top];
    [top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(container);
        make.leading.equalTo(container);
        make.width.equalTo(container);
        make.height.mas_equalTo(170);
    }];
    
    top.rankingView.userInteractionEnabled = YES;
    top.recordView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pRankingTap)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pRecordTap)];
    [top.rankingView addGestureRecognizer:tap1];
    [top.recordView addGestureRecognizer:tap2];

    
    //
    EGMZShowName *showNameView = [[[NSBundle mainBundle] loadNibNamed:@"EGMZShowName" owner:self options:nil] lastObject];
    _showNameView = showNameView;
    [container addSubview:showNameView];
    [showNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(container);
        make.top.equalTo(top.mas_bottom);
        make.width.equalTo(container);
        make.height.mas_equalTo(170);
    }];

    
    //
    EGMZShowConnections *showConnectionView = [[[NSBundle mainBundle] loadNibNamed:@"EGMZShowConnections" owner:self options:nil] lastObject];
    [container addSubview:showConnectionView];
    _showConnView = showConnectionView;
    [showConnectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showNameView.mas_bottom);
        make.leading.equalTo(container);
        make.width.equalTo(container);
        make.height.mas_equalTo(130);
    }];
    
    EGMZShowOther *other = [[[NSBundle mainBundle] loadNibNamed:@"EGMZShowOther" owner:self options:nil] lastObject];
    [container addSubview:other];
    _showOtherView = other;
    [other mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showConnectionView.mas_bottom);
        make.leading.equalTo(container);
        make.width.equalTo(container);
        make.height.mas_equalTo(690);//200
    }];

    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(other.mas_bottom);
    }];
    
}





#pragma mark - touch event
//登出Button
- (IBAction)LoginOutButtonAction:(id)sender{

}

- (IBAction)updateClick:(id)sender {
    self.showScrollView.hidden = YES;
    self.editScrollView.hidden = NO;
    _finishBtn.hidden = NO;
    _logoutBtn.hidden = YES;
    _updateBtn.hidden = YES;
}

- (IBAction)finishClick:(id)sender {
    
    
    //验证
    BOOL ss = [self commitBtnActionPerson];
    if (!ss) {
        return;
    }else{
        [self updateInfo];
    }
    
    
}


-(BOOL)checkVolunteer{
    if ([_memberInfo.VolunteerType isEqualToString:@"S"]) {
//        BOOL fromDate = [EGVerifyTool isDate:_editOtherView.startTimeField.text format:@"YYYY/MM/DD"];
//        BOOL endDate = [EGVerifyTool isDate:_editOtherView.endTimeField.text format:@"YYYY/MM/DD"];
        
        BOOL fromDate = [EGVerifyTool isMemberZoneDate:_editOtherView.startTimeField.text];
        BOOL endDate = [EGVerifyTool isMemberZoneDate:_editOtherView.endTimeField.text];

        if (_editOtherView.startTimeField.text.length>0 && !fromDate) {
             [self showMessageVCWithTitle:HKLocalizedString(@"输入错误") type:@"message_registerSuccess"  message:HKLocalizedString(@"义工服务开始日期-日期格式无效") messageButton:HKLocalizedString(@"Common_button_confirm")];
            
            return NO;
        }
        
        if (_editOtherView.endTimeField.text.length>0 && !endDate) {
            
            [self showMessageVCWithTitle:HKLocalizedString(@"输入错误") type:@"message_registerSuccess"  message:HKLocalizedString(@"义工服务结束日期-日期格式无效") messageButton:HKLocalizedString(@"Common_button_confirm")];
            return NO;
        }
        
        //如果开始日期大于结束日期
        if (_editOtherView.endTimeField.text.length>0 && [_editOtherView.endTimeField.text compare:_editOtherView.startTimeField.text options:NSNumericSearch] == NSOrderedAscending) {
            
             [self showMessageVCWithTitle:HKLocalizedString(@"输入错误") type:@"message_registerSuccess"  message:HKLocalizedString(@"开始日期必须早于结束日期（义工服务开始日期）") messageButton:HKLocalizedString(@"Common_button_confirm")];
            return NO;
        }else{
            self.memberInfo.VolunteerStartDate = _editOtherView.startTimeField.text;
            self.memberInfo.VolunteerEndDate = _editOtherView.endTimeField.text;
        }
        
        
    }else{
        self.memberInfo.VolunteerStartDate = @"";
        self.memberInfo.VolunteerEndDate = @"";
    }
    
    //
    NSMutableString *workStr = [[NSMutableString alloc] init];
    if (_editOtherView.workButton1.selected) {
        [workStr appendString:@"Admin,"];
    }
    if (_editOtherView.workButton2.selected){
        [workStr appendString:@"Print,"];
    }
    if (_editOtherView.workButton3.selected){
        [workStr appendString:@"Contact,"];
    }
    if (_editOtherView.workButton4.selected){
        [workStr appendString:@"Editing,"];
    }
    if (_editOtherView.workButton5.selected){
        [workStr appendString:@"Translate,"];
    }
    if (_editOtherView.workButton6.selected){
        [workStr appendString:@"Write,"];
    }
    if (_editOtherView.workButton7.selected){
        [workStr appendString:@"Photo,"];
    }
    if (_editOtherView.workButton8.selected){
        [workStr appendString:@"Event,"];
    }
    if (_editOtherView.workButton9.selected){
        [workStr appendString:@"Visit,"];
    }
    if (_editOtherView.workButton10.selected){
        
        if (_editOtherView.otherField.text.length<=0) {
            [self showMessageVCWithTitle:HKLocalizedString(@"输入错误") type:@"message_registerSuccess"  message:HKLocalizedString(@"请输入[有兴趣协助之项目(其他，请注明)]") messageButton:HKLocalizedString(@"Common_button_confirm")];
            return NO;
        }
        
        _memberInfo.VolunteerInterest_Other = _editOtherView.otherField.text;
    }
    _memberInfo.VolunteerInterest = workStr;
    
    
    NSMutableString *timeStr = [[NSMutableString alloc] init];
    if (_editOtherView.timeButton1.selected) {
        [timeStr appendString:@"Mon,"];
    }
    if (_editOtherView.timeButton2.selected){
        [timeStr appendString:@"Tues,"];
    }
    if (_editOtherView.timeButton3.selected){
        [timeStr appendString:@"Wed,"];
    }
    if (_editOtherView.timeButton4.selected){
        [timeStr appendString:@"Thurs,"];
    }
    if (_editOtherView.timeButton5.selected){
        [timeStr appendString:@"Fri,"];
    }
    if (_editOtherView.timeButton6.selected){
        [timeStr appendString:@"Sat,"];
    }
    if (_editOtherView.timeButton7.selected){
        [timeStr appendString:@"Sun,"];
    }
    if (_editOtherView.timeButton8.selected){
        [timeStr appendString:@"All,"];
    }
    if (_editOtherView.timeButton9.selected){
        [timeStr appendString:@"Morning,"];
    }
    if (_editOtherView.timeButton10.selected){
        [timeStr appendString:@"Afternoon,"];
    }
    if (_editOtherView.timeButton11.selected) {
        [timeStr appendString:@"Evening,"];
    }
    if (_editOtherView.timeButton12.selected){
        [timeStr appendString:@"WholeDay,"];
    }
    if (_editOtherView.timeButton13.selected){
        _memberInfo.AvailableTime_Other = _editOtherView.timeField.text;
        
        if (_editOtherView.timeField.text.length<=0) {
            [self showMessageVCWithTitle:HKLocalizedString(@"输入错误") type:@"message_registerSuccess"  message:HKLocalizedString(@"请输入[可服务的时间(可选择多项)(其他，请注明)]") messageButton:HKLocalizedString(@"Common_button_confirm")];
            return NO;
        }
    }
    
    _memberInfo.AvailableTime = timeStr;
    
    
    return YES;
}


#pragma mark 提交资料
-(void)updateInfo{
    
   
    
    NSMutableString *egiveStr = [[NSMutableString alloc] init];
    for (UIButton *btn in _editOtherView.egiveBtns) {
        NSInteger tag = btn.tag;
        
        if (tag==0) {
            if (btn.selected) {
                [egiveStr appendString:@"Web,"];
            }
        }else if (tag==1){
            if (btn.selected) {
                [egiveStr appendString:@"Event ,"];
            }
        }else if (tag==2){
            if (btn.selected) {
                [egiveStr appendString:@"Friend,"];
            }
        }else if (tag==3){
            if (btn.selected) {
                [egiveStr appendString:@"News,"];
            }
        }else if (tag==4){
            if (btn.selected) {
                [egiveStr appendString:@"Social,"];
            }
        }else if (tag==5){
            if (btn.selected) {
                [egiveStr appendString:@"Donor,"];
            }
        }else if (tag==6){
            
        }
    }
    self.memberInfo.HowToKnoweGive = egiveStr;
    
    
    
    NSMutableString *donationInterestStr = [[NSMutableString alloc] init];
    for (UIButton *btn in _editOtherView.emailBtns) {
        
        NSInteger tag = btn.tag;
        
        if (tag==0) {
            if (btn.selected) {
                [donationInterestStr appendString:@"S,"];
            }
        }else if (tag==1){
            if (btn.selected) {
                [donationInterestStr appendString:@"M,"];
            }
        }else if (tag==2){
            if (btn.selected) {
                [donationInterestStr appendString:@"U,"];
            }
        }else if (tag==3){
            if (btn.selected) {
                [donationInterestStr appendString:@"A,"];
            }
        }else if (tag==4){
            if (btn.selected) {
                [donationInterestStr appendString:@"E,"];
            }
        }else if (tag==5){
            if (btn.selected) {
                [donationInterestStr appendString:@"P,"];
            }
        }else if (tag==6){
            if (btn.selected) {
                [donationInterestStr appendString:@"O,"];
            }
        }else if (tag==7){
            if (btn.selected) {
                [donationInterestStr appendString:@"L"];
            }
        }
        
    }
    self.memberInfo.DonationInterest = donationInterestStr;
    BOOL accept = self.memberInfo.AcceptEDM;
    
    if (accept && self.memberInfo.DonationInterest.length<=0) {
        //[self showErrorMsg:HKLocalizedString(@"[请选取您喜欢的专案类别(可选择多项)]") title:HKLocalizedString(@"输入错误")];
        [self showMessageVCWithTitle:HKLocalizedString(@"输入错误") type:@"message_registerSuccess"  message:HKLocalizedString(@"[请选取您喜欢的专案类别(可选择多项)]") messageButton:HKLocalizedString(@"Common_button_confirm")];
        return;
    }
    
    
    //义工
    if (_memberInfo.JoinVolunteer) {
        
        BOOL check = [self checkVolunteer];
        
        if (!check) {
            return;
        }
    }else{
        self.memberInfo.VolunteerInterest = @"";
        self.memberInfo.VolunteerInterest_Other = @"";
        self.memberInfo.AvailableTime = @"";
        self.memberInfo.AvailableTime_Other = @"";
        self.memberInfo.VolunteerStartDate = @"";
        self.memberInfo.VolunteerEndDate = @"";
        [_editOtherView clearTimeSelected];
        [_editOtherView clearWorkSelected];
    }
    
    
    //
    EGMemberInfo *_item = _memberInfo;
    
    EGUserModel *model = [EGLoginTool loginSingleton].currentUser;
    
    LanguageKey lang = [Language getLanguage];
    
    if (_base64Avatar == nil){
//        _base64Avatar = @"";
//        if (_IconImage != nil  && ![[NSString stringWithFormat:@"%@" ,PICurl]  isEqualToString: @"http://www.egiveforyou.com/Images/default_m.jpg"] && ![[NSString stringWithFormat:@"%@" ,PICurl]  isEqualToString: @"http://www.egiveforyou.com/Images/default_f.jpg"]){
//            
//            _base64Avatar = [UIImagePNGRepresentation([self imageWithImage:[_IconImage image] convertToSize:CGSizeMake(128, 128)]) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//            
//        }
        
        _base64Avatar =  [UIImagePNGRepresentation([self imageWithImage:_editTopView.icon_image.image convertToSize:CGSizeMake(128, 128)]) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppToken_Dict"];
    NSString *token =  dict[@"AppToken"];
    
    if (!token || token.length<=0) {
        token = [OpenUDID value];
    }
    
    
    NSString * soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body> <SaveMemberInfo xmlns=\"egive.appservices\"><MemberID>%@</MemberID><MemberType>%@</MemberType><CorporationType>%@</CorporationType><CorporationType_Other>%@</CorporationType_Other><LoginName></LoginName><Password></Password><ConfirmPassword></ConfirmPassword><ProfilePicBase64String>%@</ProfilePicBase64String><CorporationChiName>%@</CorporationChiName><CorporationEngName>%@</CorporationEngName><BusinessRegistrationType>%@</BusinessRegistrationType><BusinessRegistrationNo>%@</BusinessRegistrationNo><ChiNameTitle>%@</ChiNameTitle><ChiLastName>%@</ChiLastName><ChiFirstName>%@</ChiFirstName><EngNameTitle>%@</EngNameTitle><EngLastName>%@</EngLastName><EngFirstName>%@</EngFirstName><Sex>%@</Sex><AgeGroup>%@</AgeGroup><Email>%@</Email><TelCountryCode>%@</TelCountryCode><TelNo>%@</TelNo><AddressRoom>%@</AddressRoom><AddressBldg>%@</AddressBldg><AddressEstate>%@</AddressEstate><AddressStreet>%@</AddressStreet><AddressDistrict>%@</AddressDistrict><AddressCountry>%@</AddressCountry><EducationLevel>%@</EducationLevel><Position>%@</Position><BelongTo>%@</BelongTo><HowToKnoweGive>%@</HowToKnoweGive><HowToKnoweGive_Other>%@</HowToKnoweGive_Other><AcceptEDM>%d</AcceptEDM><DonationInterest>%@</DonationInterest><JoinVolunteer>%d</JoinVolunteer><VolunteerType>%@</VolunteerType><VolunteerStartDate>%@</VolunteerStartDate><VolunteerEndDate>%@</VolunteerEndDate><VolunteerInterest>%@</VolunteerInterest><VolunteerInterest_Other>%@</VolunteerInterest_Other><AvailableTime>%@</AvailableTime><AvailableTime_Other>%@</AvailableTime_Other><AppToken>%@</AppToken><FaceBookID>%@</FaceBookID><WeiboID>%@</WeiboID><Lang>%ld</Lang></SaveMemberInfo></soap:Body></soap:Envelope>",_item.MemberID,_memberInfo.MemberType,_memberInfo.CorporationType,_memberInfo.CorporationType_Other,_base64Avatar,_memberInfo.CorporationChiName,_memberInfo.CorporationEngName,_memberInfo.BusinessRegistrationType,_memberInfo.BusinessRegistrationNo,_memberInfo.ChiNameTitle,_memberInfo.ChiLastName,_memberInfo.ChiFirstName,_memberInfo.EngNameTitle,_memberInfo.EngLastName,_memberInfo.EngFirstName,_memberInfo.Sex,_memberInfo.AgeGroup,_memberInfo.Email,_memberInfo.TelCountryCode,_memberInfo.TelNo,_memberInfo.AddressRoom,_memberInfo.AddressBldg,_memberInfo.AddressEstate,_memberInfo.AddressStreet,_memberInfo.AddressDistrict,_memberInfo.AddressCountry,_memberInfo.EducationLevel,_memberInfo.Position,_memberInfo.BelongTo,_memberInfo.HowToKnoweGive,_memberInfo.HowToKnoweGive_Other,_memberInfo.AcceptEDM,_memberInfo.DonationInterest,_memberInfo.JoinVolunteer,_memberInfo.VolunteerType,_memberInfo.VolunteerStartDate,_memberInfo.VolunteerEndDate,_memberInfo.VolunteerInterest,_memberInfo.VolunteerInterest_Other,_memberInfo.AvailableTime,_memberInfo.AvailableTime_Other,token,model.faceBookID,model.weiboID,lang];
    
    
    if (isChangePWD) {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body> <SaveMemberInfo xmlns=\"egive.appservices\"><MemberID>%@</MemberID><MemberType>%@</MemberType><CorporationType>%@</CorporationType><CorporationType_Other>%@</CorporationType_Other><LoginName></LoginName><Password>%@</Password><ConfirmPassword>%@</ConfirmPassword><ProfilePicBase64String>%@</ProfilePicBase64String><CorporationChiName>%@</CorporationChiName><CorporationEngName>%@</CorporationEngName><BusinessRegistrationType>%@</BusinessRegistrationType><BusinessRegistrationNo>%@</BusinessRegistrationNo><ChiNameTitle>%@</ChiNameTitle><ChiLastName>%@</ChiLastName><ChiFirstName>%@</ChiFirstName><EngNameTitle>%@</EngNameTitle><EngLastName>%@</EngLastName><EngFirstName>%@</EngFirstName><Sex>%@</Sex><AgeGroup>%@</AgeGroup><Email>%@</Email><TelCountryCode>%@</TelCountryCode><TelNo>%@</TelNo><AddressRoom>%@</AddressRoom><AddressBldg>%@</AddressBldg><AddressEstate>%@</AddressEstate><AddressStreet>%@</AddressStreet><AddressDistrict>%@</AddressDistrict><AddressCountry>%@</AddressCountry><EducationLevel>%@</EducationLevel><Position>%@</Position><BelongTo>%@</BelongTo><HowToKnoweGive>%@</HowToKnoweGive><HowToKnoweGive_Other>%@</HowToKnoweGive_Other><AcceptEDM>%d</AcceptEDM><DonationInterest>%@</DonationInterest><JoinVolunteer>%d</JoinVolunteer><VolunteerType>%@</VolunteerType><VolunteerStartDate>%@</VolunteerStartDate><VolunteerEndDate>%@</VolunteerEndDate><VolunteerInterest>%@</VolunteerInterest><VolunteerInterest_Other>%@</VolunteerInterest_Other><AvailableTime>%@</AvailableTime><AvailableTime_Other>%@</AvailableTime_Other><AppToken>%@</AppToken><FaceBookID>%@</FaceBookID><WeiboID>%@</WeiboID><Lang>%ld</Lang></SaveMemberInfo></soap:Body></soap:Envelope>",_item.MemberID,_memberInfo.MemberType,_memberInfo.CorporationType,_memberInfo.CorporationType_Other,_editNameView.pwdField.text,_editNameView.confirmField.text,_base64Avatar,_memberInfo.CorporationChiName,_memberInfo.CorporationEngName,_memberInfo.BusinessRegistrationType,_memberInfo.BusinessRegistrationNo,_memberInfo.ChiNameTitle,_memberInfo.ChiLastName,_memberInfo.ChiFirstName,_memberInfo.EngNameTitle,_memberInfo.EngLastName,_memberInfo.EngFirstName,_memberInfo.Sex,_memberInfo.AgeGroup,_memberInfo.Email,_memberInfo.TelCountryCode,_memberInfo.TelNo,_memberInfo.AddressRoom,_memberInfo.AddressBldg,_memberInfo.AddressEstate,_memberInfo.AddressStreet,_memberInfo.AddressDistrict,_memberInfo.AddressCountry,_memberInfo.EducationLevel,_memberInfo.Position,_memberInfo.BelongTo,_memberInfo.HowToKnoweGive,_memberInfo.HowToKnoweGive_Other,_memberInfo.AcceptEDM,_memberInfo.DonationInterest,_memberInfo.JoinVolunteer,_memberInfo.VolunteerType,_memberInfo.VolunteerStartDate,_memberInfo.VolunteerEndDate,_memberInfo.VolunteerInterest,_memberInfo.VolunteerInterest_Other,_memberInfo.AvailableTime,_memberInfo.AvailableTime_Other,token,model.faceBookID,model.weiboID,lang];
    }
    
    [SVProgressHUD show];
    [EGMemberZoneModel updateMemberWithParams:soapMessage block:^(NSString *s, NSError *error) {
        [SVProgressHUD dismiss];
        
        
        if (!error) {
            NSDictionary *result = [NSString parseJSONStringToNSDictionary:s];
            NSString *str = [NSString jSONStringToNSDictionary:s];
            
            if (result) {
                self.showScrollView.hidden = NO;
                self.editScrollView.hidden = YES;
                _finishBtn.hidden = YES;
                _logoutBtn.hidden = NO;
                _updateBtn.hidden = NO;
                
//                CZPickerView *pv = [[CZPickerView alloc] initWithHeaderTitle:HKLocalizedString(@"Common_button_confirm") cancelButtonTitle:nil confirmButtonTitle:nil];
//                pv.headerBackgroundColor = [UIColor colorWithHexString:@"#F4F5F6"];
//                pv.headerTitleColor = [UIColor colorWithHexString:@"#673291"];
//                pv.showCloseButton = YES;
//                [pv setContent:HKLocalizedString(@"修改成功!")];
//                [pv show];
                
                [self showMessageVCWithTitle:HKLocalizedString(@"提示") type:@"message_registerSuccess"  message:HKLocalizedString(@"修改成功!") messageButton:HKLocalizedString(@"Common_button_confirm")];
                
                [self refreshData];
                if (_IconImage) {
                    _editTopView.icon_image.image = _IconImage.image;
                    _showTopView.icon_image.image = _editTopView.icon_image.image;
                }
            }else{
                NSString *msg;
                if ([str isEqualToString:@"\"Error(5005)\""]) {
                    msg = HKLocalizedString(@"电邮已被注册").length>0?HKLocalizedString(@"电邮已被注册"):str;
                    
                }else if ([str isEqualToString:@"\"Error(5003)\""]){
                    msg = HKLocalizedString(@"此账号已被注册").length>0?HKLocalizedString(@"此账号已被注册"):str;
                    
                }else{
                    msg = HKLocalizedString(@"系统错误");
                }
                //[self showErrorMsg:msg title:HKLocalizedString(@"提示")];
                [self showMessageVCWithTitle:HKLocalizedString(@"提示") type:@"message_registerSuccess"  message:msg messageButton:HKLocalizedString(@"Common_button_confirm")];
            }
        }else{
            
            //[self showErrorMsg:HKLocalizedString(@"系统错误") title:HKLocalizedString(@"提示")];
            [self showMessageVCWithTitle:HKLocalizedString(@"系统错误") type:@"message_registerSuccess"  message:HKLocalizedString(@"系统错误") messageButton:HKLocalizedString(@"Common_button_confirm")];
        }
        
       
        
        
    }];
}


- (IBAction)logoutClick:(id)sender {
    //登出以后移除捐款信息
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults removeObjectForKey:@"EGIVE_MEMBER_MODEL"];
    
    [standardUserDefaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginChange_ByVC" object:nil];
}


#pragma mark 捐款记录
-(void)pRecordTap{
    //
    EGMyDonationViewController *root = [[EGMyDonationViewController alloc] initWithNibName:@"EGMyDonationViewController" bundle:nil];
    CGSize size = CGSizeMake(WIDTH-200, HEIGHT-100);//(410, 570)
    [root setContentSize:size  bgAction:NO animated:NO];
    root.showType = 1;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:root];
    navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark 排名
-(void)pRankingTap{
    [[NSNotificationCenter defaultCenter] postNotificationName:kToKindnessRanking object:nil];
}


#pragma mark - image
-(void)iconTap{
    UIActionSheet *photoBtnActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                                            cancelButtonTitle:nil
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:HKLocalizedString(@"从照片库选取") ,HKLocalizedString(@"拍摄新照片"),HKLocalizedString(@"取消"), nil];
    [photoBtnActionSheet setActionSheetStyle:UIActionSheetStyleDefault];
    //    [photoBtnActionSheet showInView:self.view.window];
    //在0＊0区域显示这个Popover
    [photoBtnActionSheet showFromRect:CGRectMake(_editTopView.icon_image.center.x, CGRectGetMaxY(_editTopView.icon_image.frame), 0, 0) inView:self.view animated:YES];
}

#pragma mark 捐款记录
-(void)recordTap{
    //
    EGMyDonationViewController *root = [[EGMyDonationViewController alloc] initWithNibName:@"EGMyDonationViewController" bundle:nil];
    CGSize size = CGSizeMake(WIDTH-200, HEIGHT-100);//(410, 570)
    [root setContentSize:size  bgAction:NO animated:NO];
    root.showType = 1;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:root];
    navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark 排名
-(void)rankingTap{
    [[NSNotificationCenter defaultCenter] postNotificationName:kToKindnessRanking object:nil];
}


#pragma mark - image
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    //}
    //-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        @try {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                //    打开相册：
                UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;//是否允许编辑
                picker.sourceType = sourceType;
                //UIPopoverController只能在ipad设备上面使用；作用是用于显示临时内容，特点是总是显示在当前视图最前端，当单击界面的其他地方时自动消失。
                UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:picker];
                //permittedArrowDirections 设置箭头方向 在0＊0区域显示这个Popover
                [popover presentPopoverFromRect:CGRectMake(_editTopView.icon_image.center.x, CGRectGetMaxY(_editTopView.icon_image.frame), 0, 0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
                
            }else {
                NSLog(@"Album is not available.");
            }
        }
        @catch (NSException *exception) {
            //Error
            NSLog(@"Album is not available.");
        }
    }
    if (buttonIndex == 1) {
        //Take Photo with Camera
        @try {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *cameraVC = [[UIImagePickerController alloc] init];
                [cameraVC setSourceType:UIImagePickerControllerSourceTypeCamera];
                [cameraVC.navigationBar setBarStyle:UIBarStyleBlack];
                [cameraVC setDelegate:self];
                [cameraVC setAllowsEditing:NO];
                //显示Camera VC
                [self presentViewController:cameraVC animated:YES completion:nil];
                
            }else {
                NSLog(@"Camera is not available.");
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Camera is not available.");
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"Image Picker Controller canceled.");
    //Cancel以后将ImagePicker删除
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"Image Picker Controller did finish picking media.");
    if (!_IconImage) {
        _IconImage = [UIImageView new];
    }
    _IconImage.image = info[UIImagePickerControllerOriginalImage];
    
    NSLog(@"UIImagePickerControllerMediaURL-----%@",info[UIImagePickerControllerReferenceURL]);
    _base64Avatar = [UIImagePNGRepresentation([self imageWithImage:_IconImage.image convertToSize:CGSizeMake(128, 128)]) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    UIImage *image = [self fixOrientation:info[UIImagePickerControllerOriginalImage]];
    _editTopView.icon_image.image = image;
    //[self saveImage:image WithName:@"test.jpg"];
    //[self updateIcon];
    [self dismissViewControllerAnimated:NO completion:nil];
}

//图片旋转90校正
- (UIImage *)fixOrientation:(UIImage *)aImage {
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}



#pragma mark - picker

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        tView.font = [UIFont boldSystemFontOfSize:NormalFontSize];
    }
    
    if (pickerView.tag==kAgePickerTag) {
        tView.text = self.ageGroups[row][@"Desp"];
        
    }else if (pickerView.tag==kEducationPickerTag){
        
        NSDictionary *dict = self.educationLevels[row];
        
        tView.text = dict[@"Desp"];
    }else if (pickerView.tag==kPositionPickerTag){
        
        NSDictionary *dict = self.jobs[row];
               
        tView.text = dict[@"Desp"];
    }else if (pickerView.tag==kBelongPickerTag){
        
        NSDictionary *dict = self.belongToOptions[row];
        
        tView.text = dict[@"Desp"];
    }
    
    return tView;
}

//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    
//    if (pickerView.tag==kAgePickerTag) {
//        
////        NSDictionary *dict = self.ageGroups[row];
////        return dict[@"Cd"];
//        return _ageGroupArray[row];
//    }else if (pickerView.tag==kEducationPickerTag){
//        
//        NSDictionary *dict = self.educationLevels[row];
//
//        return dict[@"Desp"];
//    }else if (pickerView.tag==kPositionPickerTag){
//        
//        NSDictionary *dict = self.jobs[row];
//
//        return dict[@"Desp"];
//    }else if (pickerView.tag==kBelongPickerTag){
//
//        NSDictionary *dict = self.belongToOptions[row];
//        
//        return dict[@"Desp"];
//    }
//    
//    return @"----";
//}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag==kAgePickerTag) {
        
//        return _ageGroupArray.count;
        return self.ageGroups.count;
    }else if (pickerView.tag==kEducationPickerTag){
        
        return self.educationLevels.count;
    }else if (pickerView.tag==kPositionPickerTag){
        return self.jobs.count;
    }else if (pickerView.tag==kBelongPickerTag){
        return self.belongToOptions.count;
    }
    
    return 10;
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (pickerView.tag==kAgePickerTag) {
        NSDictionary *dict = self.ageGroups[row];
//        _editAgeView.ageField.text = dict[@"Cd"];
//        self.memberInfo.AgeGroup = [dict[@"Cd"] description];
        
//        _editAgeView.ageField.text = _ageGroupArray[row];

//        self.memberInfo.AgeGroup = [dict[@"Cd"] integerValue];
        
        
        _editAgeView.ageField.text = [dict[@"Desp"] description];
         self.memberInfo.AgeGroup = [dict[@"Cd"] description];
        self.agePicker.hidden = YES;
    }
    else if (pickerView.tag==kEducationPickerTag){
        
        NSDictionary *dict = self.educationLevels[row];
        
        _editAgeView.educationField.text = dict[@"Desp"];
        self.memberInfo.EducationLevel = dict[@"Cd"];
        self.educationPicker.hidden = YES;
    }else if (pickerView.tag==kPositionPickerTag){

        NSDictionary *dict = self.jobs[row];
        
        _editAgeView.workField.text = dict[@"Desp"];
        self.memberInfo.Position = dict[@"Cd"];
        self.positionPicker.hidden = YES;
    }else if (pickerView.tag == kBelongPickerTag){
        
        NSDictionary *dict = self.belongToOptions[row];
        self.memberInfo.BelongTo = dict[@"Cd"];
        self.belongPicker.hidden = YES;
        _editNameView.institutionField.text = dict[@"Desp"];
        
        if(isChangePWD){
            [_editNameView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(280);
            }];
        }else{
            [_editNameView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(250);
            }];
        }
    }
    
    self.agePicker.hidden = YES;
    self.educationPicker.hidden = YES;
    self.positionPicker.hidden = YES;
    
    if (pickerView.tag!=kBelongPickerTag) {
        [_editAgeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(100);
        }];
    }
    
}



#pragma mark - lazy init

-(UIPickerView *)agePicker{

    if (!_agePicker) {
        _agePicker = [[UIPickerView alloc] init];//WithFrame:(CGRect){100,200,100,200}
        
        _agePicker.delegate = self;
        _agePicker.dataSource = self;
//        _agePicker.backgroundColor = [UIColor colorWithHexString:@"#F6F6F8"];
        _agePicker.backgroundColor = [UIColor whiteColor];
        _agePicker.layer.cornerRadius = 5;
        _agePicker.hidden = YES;
        _agePicker.tag = kAgePickerTag;
        
//        [_editAgeView addSubview:_agePicker];

        [_editAgeView insertSubview:_agePicker atIndex:0];
//
//        [_agePicker mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_editAgeView.mas_bottom).offset(-20);
//            make.left.equalTo(_editAgeView.ageField.mas_left);
//            make.width.equalTo(_editAgeView.ageField);
//            make.height.mas_equalTo(100);
//            
//        }];
        
//        CGRect frame = _editAgeView.ageField.frame;
//        _agePicker.frame = (CGRect){frame.origin.x,frame.origin.y+30,frame.size.width,30};
        
        if(IOS9_OR_LATER){
            [_agePicker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_editAgeView.ageField.mas_bottom).offset(0);
                make.left.equalTo(_editAgeView.ageField.mas_left);
                make.width.equalTo(_editAgeView.ageField);
                make.height.mas_equalTo(100);

            }];
        }else{
            [_agePicker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_editAgeView.ageField.mas_bottom).offset(0);
                make.left.equalTo(_editAgeView.ageField.mas_left);
                make.width.equalTo(_editAgeView.ageField);
                make.height.mas_equalTo(80);
            }];
        }
    }
    return _agePicker;
}

-(UIPickerView *)educationPicker{
    if (!_educationPicker) {
        _educationPicker = [[UIPickerView alloc] init];//WithFrame:(CGRect){100,200,100,200}
        
        _educationPicker.delegate = self;
        _educationPicker.dataSource = self;
//        _educationPicker.backgroundColor = [UIColor colorWithHexString:@"#F6F6F8"];
        _educationPicker.backgroundColor = [UIColor whiteColor];
        _educationPicker.layer.cornerRadius = 5;
        _educationPicker.hidden = YES;
        _educationPicker.tag = kEducationPickerTag;
        
//        [_editAgeView addSubview:_educationPicker];
        [_editAgeView insertSubview:_educationPicker atIndex:0];
        
        if(IOS9_OR_LATER){
            [_educationPicker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_editAgeView.educationField.mas_bottom).offset(0);
                make.left.equalTo(_editAgeView.educationField.mas_left);
                make.width.equalTo(_editAgeView.educationField);
                make.height.mas_equalTo(100);
            }];
        }else{
            [_educationPicker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_editAgeView.educationField.mas_bottom).offset(35);
                make.left.equalTo(_editAgeView.educationField.mas_left);
                make.width.equalTo(_editAgeView.educationField);
                make.height.mas_equalTo(100);
            }];
        }
    }
    
    return _educationPicker;
}


-(UIPickerView *)positionPicker{
    if (!_positionPicker) {
        _positionPicker = [[UIPickerView alloc] init];//WithFrame:(CGRect){100,200,100,200}
        
        _positionPicker.delegate = self;
        _positionPicker.dataSource = self;
//        _positionPicker.backgroundColor = [UIColor colorWithHexString:@"#F6F6F8"];
        _positionPicker.backgroundColor = [UIColor whiteColor];
        _positionPicker.layer.cornerRadius = 5;
        _positionPicker.hidden = YES;
        _positionPicker.tag = kPositionPickerTag;
        
//        [_editAgeView addSubview:_positionPicker];
        [_editAgeView insertSubview:_positionPicker atIndex:0];
        
       
        
        if(IOS9_OR_LATER){
            [_positionPicker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_editAgeView.workField.mas_bottom).offset(0);
                make.left.equalTo(_editAgeView.workField.mas_left);
                make.width.equalTo(_editAgeView.workField);
                make.height.mas_equalTo(100);
            }];
        }else{
            [_positionPicker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_editAgeView.workField.mas_bottom).offset(35);
                make.left.equalTo(_editAgeView.workField.mas_left);
                make.width.equalTo(_editAgeView.workField);
                make.height.mas_equalTo(100);
            }];
        }
    }
    return _positionPicker;
}


-(UIPickerView *)belongPicker{
    if (!_belongPicker) {
        _belongPicker = [[UIPickerView alloc] init];//WithFrame:(CGRect){100,200,100,200}
        
        _belongPicker.delegate = self;
        _belongPicker.dataSource = self;
//        _belongPicker.backgroundColor = [UIColor colorWithHexString:@"#F6F6F8"];
        _belongPicker.backgroundColor = [UIColor whiteColor];
        _belongPicker.layer.cornerRadius = 5;
        _belongPicker.hidden = YES;
        _belongPicker.tag = kBelongPickerTag;
        
//        [_editNameView addSubview:_belongPicker];
        
        [_editNameView insertSubview:_belongPicker atIndex:0];
        
        if(IOS9_OR_LATER){
            
            [_belongPicker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_editNameView.institutionField.mas_bottom).offset(0);
                make.left.equalTo(_editNameView.institutionField.mas_left);
                make.width.equalTo(_editNameView.institutionField);
                make.height.mas_equalTo(100);
            }];
        }else{
            
            [_belongPicker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_editNameView.institutionField.mas_bottom).offset(0);
                make.left.equalTo(_editNameView.institutionField.mas_left);
                make.width.equalTo(_editNameView.institutionField);
                make.height.mas_equalTo(80);
            }];
        }
    }
    return _belongPicker;

}


#pragma mark - 验证
#pragma mark - 个人
-(BOOL)commitBtnActionPerson{
    
    NSString *msg = nil;
    //登录名 密码
    if ([self userStrIsTrue]) {
        msg = [self userStrIsTrue];
    }
    //姓名
    else if([self nameStrIsTrue]){
        msg = [self nameStrIsTrue];
    }
    //
    else if (_editNameView.emailField.text.length == 0){
        msg = HKLocalizedString(@"请输入[电邮地址]");
    }
    else if (![NSString isEmail:_editNameView.emailField.text]){
        msg = HKLocalizedString(@"[电邮地址]错误");
    }
    
    else if (_editNameView.institutionField.text.length == 0){
        msg = HKLocalizedString(@"请选择所属机构");
    }

    else if (_editAgeView.phoneNumField.text.length == 0 && _editOtherView.workSeg.selectedSegmentIndex==0){
        msg = HKLocalizedString(@"请输入[联络电话]");
    }
    else if (![EGVerifyTool isNumeric:_editAgeView.phoneNumField.text] && _editOtherView.workSeg.selectedSegmentIndex==0){
        msg = HKLocalizedString(@"[联络电话]只能輸入數字");
    }
    else if (_editConnView.addSeg.selectedSegmentIndex==1 && _editConnView.otherField.text.length<=0 ){
        msg = HKLocalizedString(@"请输入[其他，请注明]");
    }
//    else if ([self addressStrIsTrue].length<=0){
//        msg = HKLocalizedString(@"请输入[机构地址]");
//    }
    
    if(msg){

        //[self showErrorMsg:msg title:HKLocalizedString(@"输入错误")];
        [self showMessageVCWithTitle:HKLocalizedString(@"输入错误") type:@"message_registerSuccess"  message:msg messageButton:HKLocalizedString(@"Common_button_confirm")];
        return NO;
    }

    return YES;
}


-(void)showErrorMsg:(NSString *)msg title:(NSString *)title{
    CZPickerView *pv = [[CZPickerView alloc] initWithHeaderTitle:title cancelButtonTitle:nil confirmButtonTitle:nil];
    pv.headerBackgroundColor = [UIColor colorWithHexString:@"#F4F5F6"];
    pv.headerTitleColor = [UIColor colorWithHexString:@"#673291"];
    pv.showCloseButton = YES;
    [pv setContent:msg];
    [pv show];
}

-(void)showMessageVCWithTitle:(NSString*)title type:(NSString*)type message:(NSString*)message messageButton:(NSString*)btnTitle
{
    CGSize size = CGSizeMake(WIDTH-450, HEIGHT-350);
    if (message) {
        size = CGSizeMake(WIDTH-500, 200);
        if (btnTitle) {
            size = CGSizeMake(WIDTH-500, 200+60);//60 btnView高度
        }
    }
    EGRegisterAlertViewController* root = [[EGRegisterAlertViewController alloc]init];
    root.size = size;
    root.title = title;
    root.message = message;
    root.btnTitle = btnTitle;
    
    
    YQNavigationController *nav = [[YQNavigationController alloc] initWithSize:size rootViewController:root];
    nav.touchSpaceHide = YES;//点击没有内容的地方消失
    nav.panPopView = YES;//滑动返回上一层视图
    if ([type isEqualToString:@"message_registerSuccess"]){
        root.notShowLeftItem = YES;
        nav.touchSpaceHide = YES;//点击没有内容的地方消失
    }
    [nav show:YES animated:YES];
}


-(NSString *)addressStrIsTrue{
    return [NSString stringWithFormat:@"%@%@%@%@%@",self.memberInfo.AddressDistrict,self.memberInfo.AddressStreet,self.memberInfo.AddressEstate,self.memberInfo.AddressBldg,self.memberInfo.AddressRoom];
}

-(NSString*)nameStrIsTrue{
    NSString* msg = nil;
    //填姓 一定要填名  中文或英文姓名最少有一个也可以
    //中         没有英文姓名  或 输入了中文名  没有中文姓
    
    NSString *chiFirstName = _editNameView.chisurnameField.text;
    NSString *chiLastName = _editNameView.chinameField.text;
    
    NSString *engFirstName = _editNameView.engsurnameField.text;
    NSString *engLastName = _editNameView.engnameField.text;
    
    if (((engLastName.length == 0 && engFirstName.length == 0) || chiLastName.length>0)  && chiFirstName.length == 0){
        msg = HKLocalizedString(@"请输入[姓名(中)(姓)]");
    }
    else if (chiFirstName.length>0 && ![EGVerifyTool isVerificatioZhongWen:chiFirstName]){
        msg = HKLocalizedString(@"姓名(中)(姓) 内请输入中文");
    }
    
    else if (chiFirstName.length>0 && chiLastName.length == 0){
        msg = HKLocalizedString(@"请输入[姓名(中)(名)]");
    }
    else if (chiLastName.length>0 && ![EGVerifyTool isVerificatioZhongWen:chiLastName]){
        msg = HKLocalizedString(@"姓名(中)(名) 内请输入中文");
    }
    //英    没有中文姓名  或 输入了英文名  没有英文姓
    else if (((chiFirstName.length == 0 && chiLastName.length == 0 ) || engLastName.length>0) && engFirstName.length == 0){
        msg = HKLocalizedString(@"请输入[姓名(英)(姓)]");
    }
    else if (engLastName.length>0 && ![EGVerifyTool isVerificationZimu:engLastName]){
        msg = HKLocalizedString(@"姓名(英)(姓) 内请输入英文");
    }
    
    else if (engFirstName.length>0 && engLastName.length == 0){
        msg =HKLocalizedString(@"请输入[姓名(英)(名)]");
    }
    else if (engLastName.length>0 && ![EGVerifyTool isVerificationZimu:engLastName]){
        msg = HKLocalizedString(@"姓名(英)(名) 内请输入英文");
    }
    return  msg;
}

-(NSString*)userStrIsTrue{
    //登录名 密码
    
    NSString* msg = nil;
    NSString *name = _editNameView.nameField.text;
    NSString *pwd = _editNameView.pwdField.text;
    NSString *cpwd = _editNameView.confirmField.text;
    
    if (name.length == 0) {
        msg =HKLocalizedString(@"请输入登入名称");
    }
    else if(![NSString validateUserName:name]){
        msg =HKLocalizedString(@"无效的用户名称");
    }
    ////密码可以中文
    else  if (pwd.length == 0){
        msg = HKLocalizedString(@"密码不能为空");
    }
    else if ([EGVerifyTool isVerificatioZhongWen:pwd] ){
        msg = HKLocalizedString(@"密码不能输入中文");
    }
    else if (pwd.length < 6) {
        msg = HKLocalizedString(@"最少需要6個字元");
    }
    
    else if (cpwd.length == 0){
        msg = HKLocalizedString(@"请输入确认密码");
    }
    else if (![cpwd isEqualToString:pwd]){
        msg = HKLocalizedString(@"密码不一致");
    }
    return  msg;
}

@end
