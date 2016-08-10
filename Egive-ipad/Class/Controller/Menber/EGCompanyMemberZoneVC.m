//
//  EGCompanyMemberZoneVC.m
//  Egive-ipad
//
//  Created by vincentmac on 15/12/26.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGCompanyMemberZoneVC.h"
#import "EGMZCompanyShowName.h"
#import "EGMZShowConnections.h"
#import "EGMZShowOther.h"
#import "EGMZTopView.h"
#import "EGMZEditCompanyName.h"
#import "EGMZEditAge.h"
#import "EGMZEditCompanyConnection.h"
#import "EGMZEditOther.h"
#import "EGMZEditConnection.h"
#import "EGMemberZoneModel.h"
#import "CZPickerView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "EGMyDonationViewController.h"
#import "EGVerifyTool.h"
#import "NSString+RegexKitLite.h"
#import "EGRegisterAlertViewController.h"

#define kBusinessRegistrationTypeTag 1000
#define kPhoneHeadTag 1001
#define kAddressDistrictTag 1002

@interface EGCompanyMemberZoneVC ()<UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIPickerViewDelegate,UINavigationControllerDelegate>{
    UIView *_showConentView;
    
    UIView *_editConentView;

    
    EGMZTopView *_showTopView;
    
    EGMZTopView *_editTopView;
    
    EGMZCompanyShowName *_nameView;
    
    EGMZShowOther *_otherView;
    
    EGMZEditCompanyName *_editNameView;
    
    EGMZEditCompanyConnection *_editConnectionView;
    
    EGMZEditOther *_editOtherView;
    
    EGMZEditConnection *_editPersonConnView;
    
    NSString * _base64Avatar;
    
    NSURL *PICurl;
    
    BOOL isChangePWD;
    
    UITapGestureRecognizer *_recordAction;
    
    UITapGestureRecognizer *_rankingAction;
}


@property (nonatomic,strong) EGMemberInfo *memberInfo;

@property (nonatomic,strong) UIPickerView *binsRegisTypePicker;//登记类别

@property (nonatomic,strong) UIPickerView *addressDistrictPicker;

@property (nonatomic,strong) UIPickerView *phoneHeadPicker;

@property (nonatomic,copy) NSDictionary *selections;

@property (nonatomic,copy) NSArray *registTypeArray;

@property (nonatomic,copy) NSArray *phoneHeadArray;

@property (nonatomic,copy) NSArray *districtArray;

@property (nonatomic,copy) NSArray *otherBusinessType;

@property (nonatomic,copy) NSArray *normalBusinessType;


//头像
@property (strong, nonatomic) IBOutlet UIImageView *IconImage;

@end

@implementation EGCompanyMemberZoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    isChangePWD = NO;
    [self loadSelections];
    
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

-(void)setupUI{
    //
    _finishBtn.layer.cornerRadius = 6;
    _logoutBtn.layer.cornerRadius = 6;
    _updateBtn.layer.cornerRadius = 6;
    
    //
    [self setupShowScrollerView];
    
    
    [self setupEditScrollerView];
    
    [self languageChangeChange];
    
   
}

-(void)languageChangeChange{
    
    [self getSelections];
    [self.binsRegisTypePicker reloadAllComponents];

    _showTopView.donationTextLabel.text = [NSString stringWithFormat:@"%@:",HKLocalizedString(@"企业累积捐款")];
    _editTopView.donationTextLabel.text = [NSString stringWithFormat:@"%@:",HKLocalizedString(@"企业累积捐款")];
    
    [_updateBtn setTitle:HKLocalizedString(@"修改") forState:UIControlStateNormal];
    [_logoutBtn setTitle:HKLocalizedString(@"登出") forState:UIControlStateNormal];
    [_finishBtn setTitle:HKLocalizedString(@"完成") forState:UIControlStateNormal];
    
    [self refreshData];
}


-(void)loadSelections{
  
     NSString * soapMessage =
     [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body> <GetMemberForm xmlns=\"egive.appservices\"><Lang>%ld</Lang></GetMemberForm></soap:Body></soap:Envelope>",[Language getLanguage]
     ];

    
    [EGMemberZoneModel getCompanySelectionsWithParams:soapMessage block:^(NSDictionary *result, NSError *error) {
        
        
        if (!error) {
            
            NSArray *array =  result[@"BusinessRegistrationTypeOptions"][@"options"];
            if (array>0) {
                
                self.registTypeArray = array;
                [self.binsRegisTypePicker reloadAllComponents];
            }
            
            
            
        }
        
    }];
    
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


-(BOOL)checkCompanyVolunteer{
    if ([_memberInfo.VolunteerType isEqualToString:@"S"]) {
        BOOL fromDate = [EGVerifyTool isDate:_editOtherView.startTimeField.text format:@"YYYY/MM/DD"];
        BOOL endDate = [EGVerifyTool isDate:_editOtherView.endTimeField.text format:@"YYYY/MM/DD"];
        
        if (_editOtherView.startTimeField.text.length>0 && !fromDate) {
            [self showMessageVCWithTitle:HKLocalizedString(@"输入错误") type:@"message_registerSuccess"  message:HKLocalizedString(@"义工服务开始日期-日期格式无效") messageButton:HKLocalizedString(@"Common_button_confirm")];
            
            return NO;
        }
        
        if (_editOtherView.endTimeField.text.length>0 && !endDate) {
            
            [self showMessageVCWithTitle:HKLocalizedString(@"输入错误") type:@"message_registerSuccess"  message:HKLocalizedString(@"义工服务结束日期-日期格式无效") messageButton:HKLocalizedString(@"Common_button_confirm")];
            return NO;
        }
        
        //如果开始日期大于结束日期
        if ([_editOtherView.endTimeField.text compare:_editOtherView.startTimeField.text options:NSNumericSearch] == NSOrderedAscending) {
            
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
        _memberInfo.VolunteerInterest_Other = _editOtherView.otherField.text;
    }
    self.memberInfo.VolunteerInterest = workStr;
    
    
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
        self.memberInfo.AvailableTime_Other = _editOtherView.timeField.text;
    }
    
    self.memberInfo.AvailableTime = timeStr;
    
    
    return YES;
}


#pragma mark 修改完成之后提交
-(void)commitData{
    
    if (isChangePWD) {
        NSString *pwd =  _editNameView.pwdField.text;
        NSString *resetPwd = _editNameView.resetPwdField.text;
        CZPickerView *pv = [[CZPickerView alloc] initWithHeaderTitle:HKLocalizedString(@"Common_button_confirm") cancelButtonTitle:nil confirmButtonTitle:nil];
        pv.headerBackgroundColor = [UIColor colorWithHexString:@"#F4F5F6"];
        pv.headerTitleColor = [UIColor colorWithHexString:@"#673291"];
        pv.showCloseButton = YES;
        [pv setContent:HKLocalizedString(@"密码不一致")];
        if (pwd.length<=0 || resetPwd.length<=0) {
           
            [pv show];
            
            return;
        }else{
            //密码不一致
            if (![pwd isEqualToString:resetPwd]) {
               
                [pv show];
                return;
            }
        }
    }
    
    
    
    if (_editOtherView.workSeg.selectedSegmentIndex==0) {
        if (_editConnectionView.phoneField.text.length<=0) {
            
            CZPickerView *pv = [[CZPickerView alloc] initWithHeaderTitle:HKLocalizedString(@"Common_button_confirm") cancelButtonTitle:nil confirmButtonTitle:nil];
            pv.headerBackgroundColor = [UIColor colorWithHexString:@"#F4F5F6"];
            pv.headerTitleColor = [UIColor colorWithHexString:@"#673291"];
            pv.showCloseButton = YES;
            [pv setContent:HKLocalizedString(@"TelePhoneNumber")];
            [pv show];
            
            return;
        }
    }
    
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
//    if (_memberInfo.JoinVolunteer) {
//        BOOL check = [self checkCompanyVolunteer];
//        
//        if (!check) {
//            return;
//        }
//    }
    
    //
    EGMemberInfo *_item = _memberInfo;

    EGUserModel *model = [EGLoginTool loginSingleton].currentUser;
    
    LanguageKey lang = [Language getLanguage];
    
    if (_base64Avatar == nil){
        _base64Avatar = @"";
//        if (_IconImage != nil  && ![[NSString stringWithFormat:@"%@" ,PICurl]  isEqualToString: @"http://www.egiveforyou.com/Images/default_m.jpg"] && ![[NSString stringWithFormat:@"%@" ,PICurl]  isEqualToString: @"http://www.egiveforyou.com/Images/default_f.jpg"]){
//            
//            _base64Avatar = [UIImagePNGRepresentation([self imageWithImage:[_IconImage image] convertToSize:CGSizeMake(128, 128)]) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//            
//        }
        
        _base64Avatar =  [UIImagePNGRepresentation([self imageWithImage:_editTopView.icon_image.image convertToSize:CGSizeMake(128, 128)]) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    
    /**
         NSString * soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body> <SaveMemberInfo xmlns=\"egive.appservices\"><MemberID>%@</MemberID><MemberType>%@</MemberType><CorporationType>%@</CorporationType><CorporationType_Other>%@</CorporationType_Other><LoginName></LoginName><Password></Password><ConfirmPassword></ConfirmPassword><ProfilePicBase64String>%@</ProfilePicBase64String><CorporationChiName>%@</CorporationChiName><CorporationEngName>%@</CorporationEngName><BusinessRegistrationType>%@</BusinessRegistrationType><BusinessRegistrationNo>%@</BusinessRegistrationNo><ChiNameTitle>%@</ChiNameTitle><ChiLastName>%@</ChiLastName><ChiFirstName>%@</ChiFirstName><EngNameTitle>%@</EngNameTitle><EngLastName>%@</EngLastName><EngFirstName>%@</EngFirstName><Sex>%@</Sex><AgeGroup>%@</AgeGroup><Email>%@</Email><TelCountryCode>%@</TelCountryCode><TelNo>%@</TelNo><AddressRoom>%@</AddressRoom><AddressBldg>%@</AddressBldg><AddressEstate>%@</AddressEstate><AddressStreet>%@</AddressStreet><AddressDistrict>%@</AddressDistrict><AddressCountry>%@</AddressCountry><EducationLevel>%@</EducationLevel><Position>%@</Position><BelongTo>%@</BelongTo><HowToKnoweGive>%@</HowToKnoweGive><HowToKnoweGive_Other>%@</HowToKnoweGive_Other><AcceptEDM>%d</AcceptEDM><DonationInterest>%@</DonationInterest><JoinVolunteer>%d</JoinVolunteer><VolunteerType>%@</VolunteerType><VolunteerStartDate>%@</VolunteerStartDate><VolunteerEndDate>%@</VolunteerEndDate><VolunteerInterest>%@</VolunteerInterest><VolunteerInterest_Other>%@</VolunteerInterest_Other><AvailableTime>%@</AvailableTime><AvailableTime_Other>%@</AvailableTime_Other><AppToken>%@</AppToken><FaceBookID>%@</FaceBookID><WeiboID>%@</WeiboID><Lang>%ld</Lang></SaveMemberInfo></soap:Body></soap:Envelope>",_item.MemberID,_memberInfo.MemberType,_memberInfo.CorporationType,_memberInfo.CorporationType_Other,_base64Avatar,_memberInfo.CorporationChiName,_memberInfo.CorporationEngName,model.BusinessRegistrationType,model.BusinessRegistrationNo,model.ChiNameTitle,model.ChiLastName,model.ChiFirstName,model.EngNameTitle,model.EngLastName,model.EngFirstName,model.Sex,model.AgeGroup,model.Email,model.TelCountryCode,model.TelNo,model.AddressRoom,model.AddressBldg,model.AddressEstate,model.AddressStreet,model.AddressDistrict,model.AddressCountry,model.EducationLevel,model.Position,model.BelongTo,model.HowToKnoweGive,model.HowToKnoweGive_Other,model.AcceptEDM,model.DonationInterest,model.JoinVolunteer,model.VolunteerType,model.VolunteerStartDate,model.VolunteerEndDate,model.VolunteerInterest,model.VolunteerInterest_Other,model.AvailableTime,model.AvailableTime_Other,model.AppToken,model.faceBookID,model.weiboID,lang];
     **/
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppToken_Dict"];
    NSString *token =  dict[@"AppToken"];
    if (!token || token.length<=0) {
        token = [OpenUDID value];//27ad23ca874f2c97aa918df4ba6d2ce652c2ba65
    }
    
    
     NSString * soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body> <SaveMemberInfo xmlns=\"egive.appservices\"><MemberID>%@</MemberID><MemberType>%@</MemberType><CorporationType>%@</CorporationType><CorporationType_Other>%@</CorporationType_Other><LoginName></LoginName><Password></Password><ConfirmPassword></ConfirmPassword><ProfilePicBase64String>%@</ProfilePicBase64String><CorporationChiName>%@</CorporationChiName><CorporationEngName>%@</CorporationEngName><BusinessRegistrationType>%@</BusinessRegistrationType><BusinessRegistrationNo>%@</BusinessRegistrationNo><ChiNameTitle>%@</ChiNameTitle><ChiLastName>%@</ChiLastName><ChiFirstName>%@</ChiFirstName><EngNameTitle>%@</EngNameTitle><EngLastName>%@</EngLastName><EngFirstName>%@</EngFirstName><Sex>%@</Sex><AgeGroup>%@</AgeGroup><Email>%@</Email><TelCountryCode>%@</TelCountryCode><TelNo>%@</TelNo><AddressRoom>%@</AddressRoom><AddressBldg>%@</AddressBldg><AddressEstate>%@</AddressEstate><AddressStreet>%@</AddressStreet><AddressDistrict>%@</AddressDistrict><AddressCountry>%@</AddressCountry><EducationLevel>%@</EducationLevel><Position>%@</Position><BelongTo>%@</BelongTo><HowToKnoweGive>%@</HowToKnoweGive><HowToKnoweGive_Other>%@</HowToKnoweGive_Other><AcceptEDM>%d</AcceptEDM><DonationInterest>%@</DonationInterest><JoinVolunteer>%d</JoinVolunteer><VolunteerType>%@</VolunteerType><VolunteerStartDate>%@</VolunteerStartDate><VolunteerEndDate>%@</VolunteerEndDate><VolunteerInterest>%@</VolunteerInterest><VolunteerInterest_Other>%@</VolunteerInterest_Other><AvailableTime>%@</AvailableTime><AvailableTime_Other>%@</AvailableTime_Other><AppToken>%@</AppToken><FaceBookID>%@</FaceBookID><WeiboID>%@</WeiboID><Lang>%ld</Lang></SaveMemberInfo></soap:Body></soap:Envelope>",_item.MemberID,_memberInfo.MemberType,_memberInfo.CorporationType,_memberInfo.CorporationType_Other,_base64Avatar,_memberInfo.CorporationChiName,_memberInfo.CorporationEngName,_memberInfo.BusinessRegistrationType,_memberInfo.BusinessRegistrationNo,_memberInfo.ChiNameTitle,_memberInfo.ChiLastName,_memberInfo.ChiFirstName,_memberInfo.EngNameTitle,_memberInfo.EngLastName,_memberInfo.EngFirstName,_memberInfo.Sex,_memberInfo.AgeGroup,_memberInfo.Email,_memberInfo.TelCountryCode,_memberInfo.TelNo,_memberInfo.AddressRoom,_memberInfo.AddressBldg,_memberInfo.AddressEstate,_memberInfo.AddressStreet,_memberInfo.AddressDistrict,_memberInfo.AddressCountry,_memberInfo.EducationLevel,_memberInfo.Position,_memberInfo.BelongTo,_memberInfo.HowToKnoweGive,_memberInfo.HowToKnoweGive_Other,_memberInfo.AcceptEDM,_memberInfo.DonationInterest,_memberInfo.JoinVolunteer,_memberInfo.VolunteerType,_memberInfo.VolunteerStartDate,_memberInfo.VolunteerEndDate,_memberInfo.VolunteerInterest,_memberInfo.VolunteerInterest_Other,_memberInfo.AvailableTime,_memberInfo.AvailableTime_Other,token,model.faceBookID,model.weiboID,lang];
    
    
    if (isChangePWD) {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body> <SaveMemberInfo xmlns=\"egive.appservices\"><MemberID>%@</MemberID><MemberType>%@</MemberType><CorporationType>%@</CorporationType><CorporationType_Other>%@</CorporationType_Other><LoginName></LoginName><Password>%@</Password><ConfirmPassword>%@</ConfirmPassword><ProfilePicBase64String>%@</ProfilePicBase64String><CorporationChiName>%@</CorporationChiName><CorporationEngName>%@</CorporationEngName><BusinessRegistrationType>%@</BusinessRegistrationType><BusinessRegistrationNo>%@</BusinessRegistrationNo><ChiNameTitle>%@</ChiNameTitle><ChiLastName>%@</ChiLastName><ChiFirstName>%@</ChiFirstName><EngNameTitle>%@</EngNameTitle><EngLastName>%@</EngLastName><EngFirstName>%@</EngFirstName><Sex>%@</Sex><AgeGroup>%@</AgeGroup><Email>%@</Email><TelCountryCode>%@</TelCountryCode><TelNo>%@</TelNo><AddressRoom>%@</AddressRoom><AddressBldg>%@</AddressBldg><AddressEstate>%@</AddressEstate><AddressStreet>%@</AddressStreet><AddressDistrict>%@</AddressDistrict><AddressCountry>%@</AddressCountry><EducationLevel>%@</EducationLevel><Position>%@</Position><BelongTo>%@</BelongTo><HowToKnoweGive>%@</HowToKnoweGive><HowToKnoweGive_Other>%@</HowToKnoweGive_Other><AcceptEDM>%d</AcceptEDM><DonationInterest>%@</DonationInterest><JoinVolunteer>%d</JoinVolunteer><VolunteerType>%@</VolunteerType><VolunteerStartDate>%@</VolunteerStartDate><VolunteerEndDate>%@</VolunteerEndDate><VolunteerInterest>%@</VolunteerInterest><VolunteerInterest_Other>%@</VolunteerInterest_Other><AvailableTime>%@</AvailableTime><AvailableTime_Other>%@</AvailableTime_Other><AppToken>%@</AppToken><FaceBookID>%@</FaceBookID><WeiboID>%@</WeiboID><Lang>%ld</Lang></SaveMemberInfo></soap:Body></soap:Envelope>",_item.MemberID,_memberInfo.MemberType,_memberInfo.CorporationType,_memberInfo.CorporationType_Other,_editNameView.pwdField.text,_editNameView.resetPwdField.text,_base64Avatar,_memberInfo.CorporationChiName,_memberInfo.CorporationEngName,_memberInfo.BusinessRegistrationType,_memberInfo.BusinessRegistrationNo,_memberInfo.ChiNameTitle,_memberInfo.ChiLastName,_memberInfo.ChiFirstName,_memberInfo.EngNameTitle,_memberInfo.EngLastName,_memberInfo.EngFirstName,_memberInfo.Sex,_memberInfo.AgeGroup,_memberInfo.Email,_memberInfo.TelCountryCode,_memberInfo.TelNo,_memberInfo.AddressRoom,_memberInfo.AddressBldg,_memberInfo.AddressEstate,_memberInfo.AddressStreet,_memberInfo.AddressDistrict,_memberInfo.AddressCountry,_memberInfo.EducationLevel,_memberInfo.Position,_memberInfo.BelongTo,_memberInfo.HowToKnoweGive,_memberInfo.HowToKnoweGive_Other,_memberInfo.AcceptEDM,_memberInfo.DonationInterest,_memberInfo.JoinVolunteer,_memberInfo.VolunteerType,_memberInfo.VolunteerStartDate,_memberInfo.VolunteerEndDate,_memberInfo.VolunteerInterest,_memberInfo.VolunteerInterest_Other,_memberInfo.AvailableTime,_memberInfo.AvailableTime_Other,token,model.faceBookID,model.weiboID,lang];
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
             //[self showErrorMsg:HKLocalizedString(@"系统错误") title:HKLocalizedString(@"系统错误")];
            [self showMessageVCWithTitle:HKLocalizedString(@"系统错误") type:@"message_registerSuccess"  message:HKLocalizedString(@"系统错误") messageButton:HKLocalizedString(@"Common_button_confirm")];
        }
        
        
        
        
    }];
}


-(void)changebusinessRegistrationType{
    //
    if (self.businessRegistrationType.count>0) {
        
        //
        NSMutableArray *tempNor = [self.businessRegistrationType mutableCopy];
        [tempNor removeObjectAtIndex:0];
        NSDictionary *dict = @{@"Cd":@"",@"Desp":HKLocalizedString(@"不适用")};
        [tempNor insertObject:dict atIndex:0];
        _otherBusinessType = tempNor;
        
        //
        NSMutableArray *temp = [self.businessRegistrationType mutableCopy];
        [temp removeObjectAtIndex:0];
        
//        NSDictionary *dict1 = @{@"Cd":@"",@"Desp":HKLocalizedString(@"Register_org_otherButton")};
//        [temp insertObject:dict1 atIndex:0];
        _normalBusinessType = temp;
        
        [self.binsRegisTypePicker reloadAllComponents];
    }

}


-(void)refreshData{
    
    //
    _showTopView.donationTextLabel.text = [NSString stringWithFormat:@"%@:",HKLocalizedString(@"企业累积捐款")];
    _showTopView.donationTextLabel.hidden = YES;
    _editTopView.donationTextLabel.text = [NSString stringWithFormat:@"%@:",HKLocalizedString(@"企业累积捐款")];
    _editTopView.donationTextLabel.hidden = YES;
    //
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"EGIVE_DonationAmountData"];
    NSString *donStr;
    if (dict) {
        donStr = [NSString stringWithFormat:@"HKD$ %@",dict[@"Amt"]];
    }else{
        donStr = [NSString stringWithFormat:@"HKD$ 0"];
    }
    NSString *topNameStr = [NSString stringWithFormat:@"%@%@", [NSString stringWithFormat:@"%@:",HKLocalizedString(@"企业累积捐款")],donStr];
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:topNameStr];
    [attstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#7C7C7D"] range:[topNameStr rangeOfString:[NSString stringWithFormat:@"%@:",HKLocalizedString(@"企业累积捐款")]]];
    [attstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#5F3489"] range:[topNameStr rangeOfString:donStr]];
    
    _showTopView.topNameLabel.attributedText = attstr;
    _editTopView.topNameLabel.attributedText = attstr;
    
    //
    [self changebusinessRegistrationType];
    
    
     _editPersonConnView.conNameLabel.text = HKLocalizedString(@"Register_org_address");
    //判断用户是否存在该头像
    if (self.memberInfo.ProfilePicURL.length>0) {
        PICurl = [NSURL URLWithString:SITE_URL];
        PICurl = [PICurl URLByAppendingPathComponent:self.memberInfo.ProfilePicURL];
        [_showTopView.icon_image sd_setImageWithURL:PICurl placeholderImage:[UIImage imageNamed:@"reg_default_personal"]];
    }
    _showTopView.icon_image.layer.cornerRadius = 50;
    _showTopView.icon_image.layer.masksToBounds = YES;
    
    EGUserModel *model = [EGLoginTool loginSingleton].currentUser;
    //
    _nameView.nameLabel.text = self.memberInfo.LoginName;
    _nameView.belongNumberLabel.text = self.memberInfo.BusinessRegistrationNo;
    NSString *businessRegistrationType = self.memberInfo.BusinessRegistrationType;
    if ([businessRegistrationType isEqualToString:@"B"]) {
        _nameView.belongNumberTextLabel.text = HKLocalizedString(@"商业登记号码");
        _editNameView.belongNumberTextLabel.text = HKLocalizedString(@"商业登记号码");
    }else if ([businessRegistrationType isEqualToString:@"T"]){
        _nameView.belongNumberTextLabel.text = HKLocalizedString(@"税局档号");
        _editNameView.belongNumberTextLabel.text = HKLocalizedString(@"税局档号");
    }else if ([businessRegistrationType isEqualToString:@"C"]){
        _nameView.belongNumberTextLabel.text = HKLocalizedString(@"香港社团注册证明书编号");
        _editNameView.belongNumberTextLabel.text = HKLocalizedString(@"香港社团注册证明书编号");
    }else{
        _nameView.belongNumberTextLabel.text = HKLocalizedString(@"不适用");
        _editNameView.belongNumberTextLabel.text = HKLocalizedString(@"不适用");
    }
    
    
    _nameView.chiLabel.text = self.memberInfo.CorporationChiName;
    _nameView.engLabel.text = self.memberInfo.CorporationEngName;
    
    _nameView.chiContactLabel.text = [NSString stringWithFormat:@"%@%@",self.memberInfo.ChiLastName,self.memberInfo.ChiFirstName];
    _nameView.engContactLabel.text = [NSString stringWithFormat:@"%@ %@",self.memberInfo.EngLastName,self.memberInfo.EngFirstName];
    
    _nameView.emailLabel.text = self.memberInfo.Email;
//    _nameView.phoneLabel.text = self.memberInfo.TelNo;
    if (_memberInfo.TelCountryCode.length>0) {
        _nameView.phoneLabel.text = [NSString stringWithFormat:@"(%@)%@",_memberInfo.TelCountryCode,_memberInfo.TelNo];
    }else{
        _nameView.phoneLabel.text = _memberInfo.TelNo;
    }
    _nameView.positionLabel.text = self.memberInfo.Position;
    
    
    _nameView.addLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",self.memberInfo.AddressDistrict,self.memberInfo.AddressStreet,self.memberInfo.AddressEstate,self.memberInfo.AddressBldg,self.memberInfo.AddressRoom];
    
    
    if (_nameView.chiLabel.text.length<=0) {
        _nameView.chiLabel.text = @"----";
    }
    if (_nameView.engLabel.text.length<=0) {
        _nameView.engLabel.text = @"----";
    }
    if (_nameView.chiContactLabel.text.length<=0) {
        _nameView.chiContactLabel.text = @"----";
    }
    if (_nameView.engContactLabel.text.length<=0) {
        _nameView.engContactLabel.text = @"----";
    }
    if (_nameView.emailLabel.text.length<=0) {
        _nameView.emailLabel.text = @"----";
    }
    if (_nameView.addLabel.text.length<=0) {
        _nameView.addLabel.text = @"----";
    }
    if (_nameView.phoneLabel.text.length<=0) {
        _nameView.phoneLabel.text = @"----";
    }
    
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
        _otherView.Label2.text = [str substringWithRange:NSMakeRange(0, range.location)];
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
        _otherView.Label2.text = ss;
    }
    
    if (_otherView.Label2.text.length<=0) {
        _otherView.Label2.text = @"----";
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
    
    
    if (_memberInfo.AcceptEDM) {
        NSArray *intserests = [_memberInfo.DonationInterest componentsSeparatedByString:@","];
        
        NSMutableString *donationInterestStr = [[NSMutableString alloc] init];
        [donationInterestStr appendString:[NSString stringWithFormat:@"%@,",HKLocalizedString(@"Register_isEmailButton_title")]];
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
        _otherView.Label4.text = [donationInterestStr substringWithRange:NSMakeRange(0, range.location)];;
    }else{
        _otherView.Label4.text = HKLocalizedString(@"Register_noEmailButton_title");
    }
    
    if (_memberInfo.JoinVolunteer) {
        _otherView.Label6.text = HKLocalizedString(@"Register_yButton_title");
    }else{
        _otherView.Label6.text = HKLocalizedString(@"Register_nButton_title");
    }


    //判断用户是否存在该头像
    if ([self.memberInfo.ProfilePicURL isEqualToString:@""] || self.memberInfo.ProfilePicURL == nil) {
        if ([self.memberInfo.Sex isEqualToString:@"M"] || [self.memberInfo.ChiNameTitle isEqualToString:@"R"]) {
            //_IconImage.image = [UIImage imageNamed:@"donor_detail_male@2x.png"];
            PICurl = [NSURL URLWithString:@"http://www.egiveforyou.com/Images/default_m.jpg"];
            [_editTopView.icon_image sd_setImageWithURL:PICurl placeholderImage:[UIImage imageNamed:@"reg_default_personal"]];
            
        }else{
            //_IconImage.image = [UIImage imageNamed:@"donor_detail_female@2x.png"];
            PICurl = [NSURL URLWithString:@"http://www.egiveforyou.com/Images/default_f.jpg"];
            [_editTopView.icon_image sd_setImageWithURL:PICurl placeholderImage:nil];
            
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
    
    //
    [_editNameView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(220);
    }];
    _editNameView.hiddenFieldConstraint.constant = 15;
    _editNameView.detailLabel.hidden = YES;
    _editNameView.detailField.hidden = YES;
    NSString *CorporationType = self.memberInfo.CorporationType;
    
    
    if ([CorporationType isEqualToString:@"C"]) {
        _editNameView.typeSeg.selectedSegmentIndex = 0;
        _editNameView.typeButton.hidden = YES;
        _editNameView.coverButton.hidden = YES;
    }else if ([CorporationType isEqualToString:@"N"]){
        _editNameView.typeSeg.selectedSegmentIndex = 2;
        _editNameView.typeButton.hidden = YES;
        _editNameView.coverButton.hidden = YES;
    }else if ([CorporationType isEqualToString:@"E"]){
        _editNameView.typeSeg.selectedSegmentIndex = 3;
        _editNameView.detailField.text = self.memberInfo.CorporationType_Other;
        _editNameView.hiddenFieldConstraint.constant = 76;
        _editNameView.detailLabel.hidden = NO;
        _editNameView.detailField.hidden = NO;
        _editNameView.typeButton.hidden = NO;
        _editNameView.coverButton.hidden = NO;
        
        if (isChangePWD) {
            
            [_editNameView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(320);
            }];
        }else{
            
            [_editNameView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(270);
            }];
        }
        
    }else if ([CorporationType isEqualToString:@"O"]){
        _editNameView.typeSeg.selectedSegmentIndex = 1;
        _editNameView.typeButton.hidden = YES;
        _editNameView.coverButton.hidden = YES;
    }
    
   

    
    //
    _editNameView.nameField.text = self.memberInfo.LoginName;
//    _editNameView.pwdField.text = model.password;
//    _editNameView.resetPwdField.text = model.password;
    _editNameView.belongNumberTextField.text = self.memberInfo.BusinessRegistrationNo;

    NSString *type = _memberInfo.BusinessRegistrationType;
    DLOG(@"%@",self.businessRegistrationType);
    
    if (_editNameView.typeSeg.selectedSegmentIndex!=3) {
        for (NSDictionary *dict in _normalBusinessType) {
            if ([dict[@"Cd"] isEqualToString:type]) {
                _editNameView.recordTypeField.text = dict[@"Desp"];
                break;
            }
        }
    }else{
        for (NSDictionary *dict in _otherBusinessType) {
            if ([dict[@"Cd"] isEqualToString:type]) {
                _editNameView.recordTypeField.text = dict[@"Desp"];
                break;
            }
        }
    }
    
    

    _editNameView.chiTextField.text = self.memberInfo.CorporationChiName;
    _editNameView.engTextField.text = self.memberInfo.CorporationEngName;
    
    
    //
    NSString *sex = self.memberInfo.ChiNameTitle;
    if ([sex isEqualToString:@"R"]) {
        _editConnectionView.sexSeg.selectedSegmentIndex = 0;
    }else if ([sex isEqualToString:@"S"]){
        _editConnectionView.sexSeg.selectedSegmentIndex = 1;
    }else if ([sex isEqualToString:@"M"]){
        _editConnectionView.sexSeg.selectedSegmentIndex = 2;
    }
    
    
    _editConnectionView.chisurnameField.text = self.memberInfo.ChiLastName;
    _editConnectionView.chinameField.text = self.memberInfo.ChiFirstName;
    _editConnectionView.engsurnameField.text = self.memberInfo.EngLastName;
    _editConnectionView.engnameField.text = self.memberInfo.EngFirstName;
    
    _editConnectionView.emailField.text = self.memberInfo.Email;
    _editConnectionView.jobTitleField.text = self.memberInfo.Position;
    _editConnectionView.phoneHeadField.text = self.memberInfo.TelCountryCode;
    _editConnectionView.phoneField.text = self.memberInfo.TelNo;
    
    //
    _editPersonConnView.conNameLabel.text = HKLocalizedString(@"Register_org_address");
    _editPersonConnView.Field1.text = self.memberInfo.AddressRoom;
    _editPersonConnView.Field2.text = self.memberInfo.AddressBldg;
    _editPersonConnView.Field3.text = self.memberInfo.AddressEstate;
    
    _editPersonConnView.Field4.text = self.memberInfo.AddressStreet;
    _editPersonConnView.Field5.text = self.memberInfo.AddressDistrict;
//    _editPersonConnView.otherField.text = self.memberInfo.AddressCountry;
    
    
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
        _editOtherView.workSeg.selectedSegmentIndex = 0;
//        
//        if ([[_memberInfo.VolunteerType description] isEqualToString:@"S"]) {
//            _editOtherView.startTimeField.text = _memberInfo.VolunteerStartDate;
//            _editOtherView.endTimeField.text = _memberInfo.VolunteerEndDate;
//        }
//        
//        NSString *volunteerInterest = _memberInfo.VolunteerInterest;
//        NSArray *volunteerArray = [volunteerInterest componentsSeparatedByString:@","];
//        
//        for (NSString *s in volunteerArray) {
//            if ([s isEqualToString:@"Admin"]) {
//                
//                _editOtherView.workButton1.selected = YES;
//            }else if ([s isEqualToString:@"Print"]){
//                
//                _editOtherView.workButton2.selected = YES;
//            }else if ([s isEqualToString:@"Contact"]){
//                
//                _editOtherView.workButton3.selected = YES;
//            }else if ([s isEqualToString:@"Editing"]){
//                
//                _editOtherView.workButton4.selected = YES;
//            }else if ([s isEqualToString:@"Translate"]){
//                
//                _editOtherView.workButton5.selected = YES;
//            }else if ([s isEqualToString:@"Write"]){
//                
//                _editOtherView.workButton6.selected = YES;
//            }else if ([s isEqualToString:@"Photo"]){
//                
//                _editOtherView.workButton7.selected = YES;
//            }else if ([s isEqualToString:@"Event"]){
//                
//                _editOtherView.workButton8.selected = YES;
//            }else if ([s isEqualToString:@"Visit"]){
//                
//                _editOtherView.workButton9.selected = YES;
//            }
//        }
//        
//        if (_memberInfo.VolunteerInterest_Other.length>0) {
//            _editOtherView.workButton10.selected = YES;
//            _editOtherView.workLabel16.hidden = NO;
//            _editOtherView.otherField.hidden = NO;
//            _editOtherView.otherField.text = _memberInfo.VolunteerInterest_Other;
//        }else{
//            _editOtherView.workButton10.selected = NO;
//            _editOtherView.otherField.hidden = YES;
//            _editOtherView.workLabel16.hidden = YES;
//        }
//        
//        //
//        NSString *availableTime = _memberInfo.AvailableTime;
//        NSArray *timeArray = [availableTime componentsSeparatedByString:@","];
//        
//        for (NSString *s in timeArray) {
//            if ([s isEqualToString:@"Mon"]) {
//                
//                _editOtherView.timeButton1.selected = YES;
//            }else if ([s isEqualToString:@"Tues"]){
//                
//                _editOtherView.timeButton2.selected = YES;
//            }else if ([s isEqualToString:@"Wed"]){
//                
//                _editOtherView.timeButton3.selected = YES;
//            }else if ([s isEqualToString:@"Thurs"]){
//                
//                _editOtherView.timeButton4.selected = YES;
//            }else if ([s isEqualToString:@"Fri"]){
//                
//                _editOtherView.timeButton5.selected = YES;
//            }else if ([s isEqualToString:@"Sat"]){
//                
//                _editOtherView.timeButton6.selected = YES;
//            }else if ([s isEqualToString:@"Sun"]){
//                
//                _editOtherView.timeButton7.selected = YES;
//            }else if ([s isEqualToString:@"All"]){
//                
//                _editOtherView.timeButton8.selected = YES;
//            }else if ([s isEqualToString:@"Morning"]){
//                
//                _editOtherView.timeButton9.selected = YES;
//            }else if ([s isEqualToString:@"Afternoon"]){
//                
//                _editOtherView.timeButton10.selected = YES;
//            }else if ([s isEqualToString:@"Evening"]){
//                
//                _editOtherView.timeButton11.selected = YES;
//            }else if ([s isEqualToString:@"WholeDay"]){
//                
//                _editOtherView.timeButton12.selected = YES;
//            }
//        }
//        
//        
//        if (_memberInfo.AvailableTime_Other.length>0) {
//            _editOtherView.timeButton13.selected = YES;
//            _editOtherView.workLabel31.hidden = NO;
//            _editOtherView.timeField.hidden = NO;
//            _editOtherView.timeField.text = _memberInfo.VolunteerInterest_Other;
//        }else{
//            _editOtherView.timeButton13.selected = NO;
//            _editOtherView.timeField.hidden = YES;
//            _editOtherView.timeField.hidden = YES;
//            _editOtherView.workLabel31.hidden = YES;
//        }
//        
//        
//        if ([_memberInfo.VolunteerType isEqualToString:@"S"]) {
//            _editOtherView.sureSeg.selectedSegmentIndex = 1;
//            [self hiddenTimeView:NO];
//        }else{
//            _editOtherView.sureSeg.selectedSegmentIndex = 0;
//            [self hiddenTimeView:YES];
//        }
//        
//        [_editOtherView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(760);
//        }];
    }else{
        _editOtherView.workSeg.selectedSegmentIndex = 1;
        
        
//        if(_memberInfo.AcceptEDM){
//            [_editOtherView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(290-10);
//            }];
//        }else{
//            [_editOtherView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(290-65);
//            }];
//        }
    }
    
}



-(void)hiddenTimeView:(BOOL)hidden{
    if (hidden) {
        CGFloat height = 695;
        if (!self.memberInfo.AcceptEDM) {
            height = 695-65;
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
        
        CGFloat height = 760;
        if (!self.memberInfo.AcceptEDM) {
            height = 760-65;
        }
        
        [_editOtherView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(760);
        }];
        
        _editOtherView.workLabel3.hidden = NO;
        _editOtherView.workLabel4.hidden = NO;
        _editOtherView.startTimeField.hidden = NO;
        _editOtherView.endTimeField.hidden = NO;
        
        _editOtherView.timeViewHeight.constant = 65;
    }
}



#pragma mark - picker 

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        tView.font = [UIFont boldSystemFontOfSize:NormalFontSize];
    }
    
    if (pickerView.tag==kBusinessRegistrationTypeTag) {
        if (_editNameView.typeSeg.selectedSegmentIndex==3) {
            NSDictionary *dict = _otherBusinessType[row];
            tView.text = dict[@"Desp"];
        }else{
            NSDictionary *dict = _normalBusinessType[row];
            tView.text = dict[@"Desp"];
        }
    }

    return tView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 20;
}

//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    
//    if (pickerView.tag==kBusinessRegistrationTypeTag) {
//
//        NSDictionary *dict = self.businessRegistrationType[row];
//        return dict[@"Desp"];
//    }
//
//    return @"----";
//}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag==kBusinessRegistrationTypeTag) {
        if (_editNameView.typeSeg.selectedSegmentIndex==3) {
            return _otherBusinessType.count;
        }else{
            return _normalBusinessType.count;
        }
        
    }
    return 0;
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (pickerView.tag==kBusinessRegistrationTypeTag) {
//        NSDictionary *dict = self.businessRegistrationType[row];
        NSDictionary *dict;
        if (_editNameView.typeSeg.selectedSegmentIndex==3) {
            dict = _otherBusinessType[row];
        }else{
            dict = _normalBusinessType[row];
        }
        
        _editNameView.recordTypeField.text = dict[@"Desp"];//
        self.memberInfo.BusinessRegistrationType = dict[@"Cd"];;
        self.binsRegisTypePicker.hidden = YES;
        
        _editNameView.belongNumberTextLabel.text = dict[@"Desp"];
    }else if (pickerView.tag==kAddressDistrictTag){
        
        [_editPersonConnView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(235);
        }];
        
      
        self.addressDistrictPicker.hidden = YES;
    }else if (pickerView.tag==kPhoneHeadTag){
    
        [_editConnectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(300);
        }];
        
        self.phoneHeadPicker.hidden = YES;
    }
    
    
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
    
    BOOL s = [self commitBtnActionOrganiza];
    
    if (s) {
        [self commitData];
    }
}

- (IBAction)logoutClick:(id)sender {
    //登出以后移除捐款信息
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults removeObjectForKey:@"EGIVE_MEMBER_MODEL"];
    
    [standardUserDefaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginChange_ByVC" object:nil];
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
    
    top.donationTextLabel.text = HKLocalizedString(@"企业累积捐款");
    top.rankingView.userInteractionEnabled = YES;
    top.recordView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recordTap)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rankingTap)];
    [top.rankingView addGestureRecognizer:tap2];
    [top.recordView addGestureRecognizer:tap1];
    
    //
    
    
    //
    EGMZEditCompanyName *editNameView = [[[NSBundle mainBundle] loadNibNamed:@"EGMZEditCompanyName" owner:self options:nil] lastObject];
    _editNameView = editNameView;
    editNameView.recordTypeField.userInteractionEnabled = NO;
    [container addSubview:editNameView];
    [editNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(container);
        make.top.equalTo(top.mas_bottom);
        make.width.equalTo(container);
        make.height.mas_equalTo(270);
    }];
    
    //
    [_editNameView.detailField bk_addEventHandler:^(id sender) {
        UITextField *field = sender;
        self.memberInfo.CorporationType_Other = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    //
    [_editNameView.typeSeg bk_addEventHandler:^(id sender) {
        UISegmentedControl *seg = sender;
        
        NSInteger index = seg.selectedSegmentIndex;
        NSDictionary *dict;
        if (index<3) {
            dict = _normalBusinessType[index];
            _editNameView.belongNumberTextLabel.text = dict[@"Desp"];
            _editNameView.coverButton.hidden = YES;
        }
        

        switch (index) {
                
            case 0:
                self.memberInfo.CorporationType = @"C";
                //B - 商業登記號碼
                _editNameView.recordTypeField.text = dict[@"Desp"];
                _memberInfo.BusinessRegistrationType = dict[@"Cd"];
                _editNameView.typeButton.hidden = YES;
                break;
            case 1:
                self.memberInfo.CorporationType = @"O";
                //C - 香港社團註冊證明書編號
                _editNameView.recordTypeField.text = dict[@"Desp"];
                _memberInfo.BusinessRegistrationType = dict[@"Cd"];
                _editNameView.typeButton.hidden = YES;
                break;
            case 2:
                self.memberInfo.CorporationType = @"N";
                //t  税局档案
                _editNameView.recordTypeField.text = dict[@"Desp"];
                _memberInfo.BusinessRegistrationType = dict[@"Cd"];
                _editNameView.typeButton.hidden = YES;
                break;
            case 3:
                self.memberInfo.CorporationType = @"E";
                _editNameView.typeButton.hidden = NO;
                _editNameView.coverButton.hidden = NO;
                break;
            default:
                break;
        }
        
        if (index==3) {
            
            if (isChangePWD) {
                [_editNameView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(320);
                }];
            }else{
                [_editNameView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(270);
                }];
            }
            
            
            _editNameView.hiddenFieldConstraint.constant = 76;
            _editNameView.detailLabel.hidden = NO;
            _editNameView.detailField.hidden = NO;
        }else{
           
            if (isChangePWD) {
                [_editNameView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(270);
                }];
            }else{
                [_editNameView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(220);
                }];
            }
            
            _editNameView.hiddenFieldConstraint.constant = 15;
            _editNameView.detailLabel.hidden = YES;
            _editNameView.detailField.hidden = YES;
        }
        //
        [self changebusinessRegistrationType];
    } forControlEvents:UIControlEventValueChanged];
    
    //
    [_editNameView.nameField bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.LoginName = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    [_editNameView.pwdField bk_addEventHandler:^(id sender) {
        isChangePWD = YES;
        _editNameView.chiConstraint.constant = 76;
        _editNameView.resetPwdLabel.hidden = NO;
        _editNameView.resetPwdField.hidden = NO;
        
        _editNameView.pwdField.text = @"";
        _editNameView.resetPwdField.text = @"";
        
        if (_editNameView.typeSeg.selectedSegmentIndex==3) {
            [_editNameView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(330);
            }];
        }else{
            [_editNameView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(270);
            }];
        }
    } forControlEvents:UIControlEventEditingDidBegin];
    
    //
    [editNameView.typeButton bk_addEventHandler:^(id sender) {
        self.binsRegisTypePicker.hidden = self.binsRegisTypePicker.hidden ? NO : YES;
        
        if (!self.binsRegisTypePicker.hidden) {
            if (_normalBusinessType.count>0) {
                
                if (IOS9_OR_LATER) {
                    [_binsRegisTypePicker selectRow:1 inComponent:0 animated:NO];
                }else{
                    [_binsRegisTypePicker selectRow:2 inComponent:0 animated:NO];
                }
            }
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    //
    [editNameView.coverButton bk_addEventHandler:^(id sender) {
        self.binsRegisTypePicker.hidden = self.binsRegisTypePicker.hidden ? NO : YES;
        
        if (!self.binsRegisTypePicker.hidden) {
            if (_normalBusinessType.count>0) {
                
                if (IOS9_OR_LATER) {
                    [_binsRegisTypePicker selectRow:1 inComponent:0 animated:NO];
                }else{
                    [_binsRegisTypePicker selectRow:2 inComponent:0 animated:NO];
                }
            }
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    //
    [editNameView.belongNumberTextField bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.BusinessRegistrationNo = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    //
    [editNameView.chiTextField bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.CorporationChiName = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    //
    [editNameView.engTextField bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.CorporationEngName = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    
    
    /*********************************************************************************************************/
    
    EGMZEditCompanyConnection *editConnectionPersonView = [[[NSBundle mainBundle] loadNibNamed:@"EGMZEditCompanyConnection" owner:self options:nil] lastObject];
    _editConnectionView = editConnectionPersonView;
    _editConnectionView.dropButton.hidden = YES;
    [container addSubview:editConnectionPersonView];
    [editConnectionPersonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(container);
        make.top.equalTo(editNameView.mas_bottom);
        make.width.equalTo(container);
        make.height.mas_equalTo(300);
    }];
    
    //
    [editConnectionPersonView.sexSeg bk_addEventHandler:^(UISegmentedControl *seg) {
        NSInteger index = seg.selectedSegmentIndex;
        
        switch (index) {
            case 0:
                self.memberInfo.ChiNameTitle = @"R";
                self.memberInfo.EngNameTitle = @"R";
                self.memberInfo.Sex = @"M";
                break;
            case 1:
                self.memberInfo.ChiNameTitle = @"S";
                self.memberInfo.EngNameTitle = @"S";
                self.memberInfo.Sex = @"F";
                break;
            case 2:
                self.memberInfo.ChiNameTitle = @"M";
                self.memberInfo.EngNameTitle = @"M";
                self.memberInfo.Sex = @"F";
                break;
            default:
                break;
        }
    } forControlEvents:UIControlEventValueChanged];
    
    //
    [editConnectionPersonView.chisurnameField bk_addEventHandler:^(UITextField *field) {
//        self.memberInfo.ChiFirstName = field.text;
        self.memberInfo.ChiLastName = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    //
    [editConnectionPersonView.chinameField bk_addEventHandler:^(UITextField *field) {
//        self.memberInfo.ChiLastName = field.text;
        self.memberInfo.ChiFirstName = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    //
    [editConnectionPersonView.engsurnameField bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.EngLastName = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    //
    [editConnectionPersonView.engnameField bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.EngFirstName = field.text;
    } forControlEvents:UIControlEventEditingChanged];

    //
    [editConnectionPersonView.jobTitleField bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.Position = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    //
    [editConnectionPersonView.emailField bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.Email = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    //
    [editConnectionPersonView.phoneHeadField bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.TelCountryCode = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    //
    [editConnectionPersonView.phoneField bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.TelNo = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    //
    [_editConnectionView.dropButton bk_addEventHandler:^(id sender) {
        self.phoneHeadPicker.hidden = self.addressDistrictPicker.hidden ? NO : YES;
        
        if (!self.phoneHeadPicker.hidden) {
            [_editConnectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(350);
            }];
        }else{
            
            [_editConnectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(300);
            }];
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    /*********************************************************************************************************/
    EGMZEditConnection *conn = [[[NSBundle mainBundle] loadNibNamed:@"EGMZEditConnection" owner:self options:nil] lastObject];
    _editPersonConnView = conn;
    [container addSubview:conn];
    [conn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(container);
        make.top.equalTo(editConnectionPersonView.mas_bottom);
        make.width.equalTo(container);
        make.height.mas_equalTo(235);
    }];
    
    //
    [conn.Field1 bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.AddressRoom = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    //
    [conn.Field2 bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.AddressBldg = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    //
    [conn.Field3 bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.AddressEstate = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    //
    [conn.Field4 bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.AddressStreet = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    //
    [conn.Field5 bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.AddressDistrict = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    //
    [conn.otherField bk_addEventHandler:^(UITextField *field) {
        self.memberInfo.AddressCountry = field.text;
    } forControlEvents:UIControlEventEditingChanged];
    
    
    
    //
    [conn.dropButton bk_addEventHandler:^(id sender) {
        self.addressDistrictPicker.hidden = self.addressDistrictPicker.hidden ? NO : YES;
        
        if (!self.addressDistrictPicker.hidden) {
            [conn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(335);
            }];
        }else{
        
            [conn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(235);
            }];
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    
    /*********************************************************************************************************/
    
    EGMZEditOther *editOtherView = [[[NSBundle mainBundle] loadNibNamed:@"EGMZEditOther" owner:self options:nil] lastObject];
    _editOtherView = editOtherView;
    [container addSubview:editOtherView];
    [editOtherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(container);
        make.top.equalTo(conn.mas_bottom);
        make.width.equalTo(container);
        make.height.mas_equalTo(290);//290
    }];
    
    //
    [editOtherView.emailSeg bk_addEventHandler:^(UISegmentedControl *seg) {

        if (seg.selectedSegmentIndex==0) {
            self.memberInfo.AcceptEDM = YES;
            
            [editOtherView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(290-10);
            }];
        }else{
            self.memberInfo.AcceptEDM = NO;
            CGFloat height = 290 - 65 - 10;
            [editOtherView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
        }
    } forControlEvents:UIControlEventValueChanged];
    
    [editOtherView.workSeg bk_addEventHandler:^(UISegmentedControl *seg) {
        if (seg.selectedSegmentIndex==0) {
            self.memberInfo.JoinVolunteer = YES;

        }else{
            self.memberInfo.JoinVolunteer = NO;
        }
        
    } forControlEvents:UIControlEventValueChanged];
    
    _editOtherView.workLabel1.hidden = YES;
    _editOtherView.workLabel2.hidden = YES;
    _editOtherView.workLabel3.hidden = YES;
    _editOtherView.sureSeg.hidden = YES;
    
    
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
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(editOtherView.mas_bottom);
    }];
}


-(void)iconTap{
//    UIActionSheet *photoBtnActionSheet =
//    [[UIActionSheet alloc] initWithTitle:nil
//                                delegate:self
//                       cancelButtonTitle:HKLocalizedString(@"取消")
//                  destructiveButtonTitle:nil
//                       otherButtonTitles:HKLocalizedString(@"从照片库选取") ,HKLocalizedString(@"拍摄新照片"), nil];
//    [photoBtnActionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
//    [photoBtnActionSheet showInView:[self.view window]];
    
    
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

-(void)setupShowScrollerView{
    //
    _recordAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recordTap)];
    _rankingAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rankingTap)];

    
    //
    self.showScrollView.backgroundColor = [UIColor whiteColor];
    TPKeyboardAvoidingScrollView *ss = [TPKeyboardAvoidingScrollView new];
    self.showScrollView = ss;
    _finishBtn.hidden = YES;
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
    _showTopView = top;
    top.backgroundColor = [UIColor colorWithHexString:@"#F6F6F8"];
    [container addSubview:top];
    [top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(container);
        make.leading.equalTo(container);
        make.width.equalTo(container);
        make.height.mas_equalTo(170);
    }];
    
    top.donationTextLabel.text = HKLocalizedString(@"企业累积捐款");
    top.rankingView.userInteractionEnabled = YES;
    top.recordView.userInteractionEnabled = YES;
    [top.rankingView addGestureRecognizer:_rankingAction];
    [top.recordView addGestureRecognizer:_recordAction];

    
    //
    EGMZCompanyShowName *showNameView = [[[NSBundle mainBundle] loadNibNamed:@"EGMZCompanyShowName" owner:self options:nil] lastObject];
    _nameView = showNameView;
    [container addSubview:showNameView];
    [showNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(container);
        make.top.equalTo(top.mas_bottom);
        make.width.equalTo(container);
        make.height.mas_equalTo(270);
    }];
    
    

    
    EGMZShowOther *other = [[[NSBundle mainBundle] loadNibNamed:@"EGMZShowOther" owner:self options:nil] lastObject];
    _otherView = other;
    [container addSubview:other];
    other.workView.hidden = YES;
    
    [other mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showNameView.mas_bottom);
        make.leading.equalTo(container);
        make.width.equalTo(container);
        make.height.mas_equalTo(200);
    }];
    
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(other.mas_bottom);
    }];
}




#pragma mark - lazy init
-(UIPickerView *)binsRegisTypePicker{
    if (!_binsRegisTypePicker) {
        _binsRegisTypePicker = [[UIPickerView alloc] init];//WithFrame:(CGRect){100,35,100,50}
        
        _binsRegisTypePicker.delegate = self;
        _binsRegisTypePicker.dataSource = self;
//        _binsRegisTypePicker.backgroundColor = [UIColor colorWithHexString:@"#F6F6F8"];
        _binsRegisTypePicker.backgroundColor = [UIColor whiteColor];
        _binsRegisTypePicker.layer.cornerRadius = 5;
        _binsRegisTypePicker.hidden = YES;
        _binsRegisTypePicker.tag = kBusinessRegistrationTypeTag;
        
        [_editNameView addSubview:_binsRegisTypePicker];
        
        if(IOS9_OR_LATER){
            [_binsRegisTypePicker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_editNameView.recordTypeField.mas_bottom).offset(0);
                make.left.equalTo(_editNameView.recordTypeField.mas_left);
                make.width.equalTo(_editNameView.recordTypeField);
                make.height.mas_equalTo(100);
            }];
        }else{
            [_binsRegisTypePicker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_editNameView.recordTypeField.mas_bottom).offset(40);
                make.left.equalTo(_editNameView.recordTypeField.mas_left);
                make.width.equalTo(_editNameView.recordTypeField);
                make.height.mas_equalTo(80);
            }];
        }
        
        
    }
    return _binsRegisTypePicker;
}

-(UIPickerView *)addressDistrictPicker{
    
    if (!_addressDistrictPicker) {
        _addressDistrictPicker = [[UIPickerView alloc] init];
        
        
        _addressDistrictPicker.delegate = self;
        _addressDistrictPicker.dataSource = self;
        _addressDistrictPicker.backgroundColor = [UIColor colorWithHexString:@"#F6F6F8"];
        _addressDistrictPicker.layer.cornerRadius = 5;
        _addressDistrictPicker.hidden = YES;
        _addressDistrictPicker.tag = kAddressDistrictTag;
        
        [_editPersonConnView addSubview:_addressDistrictPicker];
        
        
        [_addressDistrictPicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_editPersonConnView.Field5.mas_bottom).offset(35);
            make.left.equalTo(_editPersonConnView.Field5.mas_left);
            make.width.equalTo(_editPersonConnView.Field5);
            make.height.mas_equalTo(100);
        }];
        
    }

    return _addressDistrictPicker;
}


-(UIPickerView *)phoneHeadPicker{

    if (!_phoneHeadPicker) {
        _phoneHeadPicker = [[UIPickerView alloc] init];
        
        
        _phoneHeadPicker.delegate = self;
        _phoneHeadPicker.dataSource = self;
        _phoneHeadPicker.backgroundColor = [UIColor colorWithHexString:@"#F6F6F8"];
        _phoneHeadPicker.layer.cornerRadius = 5;
//        _phoneHeadPicker.hidden = YES;
        _phoneHeadPicker.tag = kPhoneHeadTag;
        
        [_editConnectionView addSubview:_phoneHeadPicker];
        
        
        [_phoneHeadPicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_editConnectionView.phoneHeadField.mas_bottom).offset(50);
            make.left.equalTo(_editConnectionView.phoneHeadField.mas_left);
            make.width.equalTo(_editConnectionView.phoneHeadField);
            make.height.mas_equalTo(50);
        }];
    }
    
    return _phoneHeadPicker;
}

#pragma mark - 机构
-(BOOL)commitBtnActionOrganiza{
    NSString *msg = nil;
    
    UITextField *_organizaNameCh = _editNameView.chiTextField;
    UITextField *_organizaNameEn = _editNameView.engTextField;
    
    if (_editNameView.typeSeg.selectedSegmentIndex==3 && _editNameView.detailField.text.length == 0) {
        msg =HKLocalizedString(@"请输入[其他，请注明]");
    }
    else if ([self userStrIsTrue]) {
        msg = [self userStrIsTrue];
    }
    
    
    //
    
    else if (_organizaNameCh.text.length == 0){
        msg =HKLocalizedString(@"请输入[机构名称(中)]");
    }
    
    //    else if (_organizaNameEn.text.length == 0){
    //        msg =HKLocalizedString(@"请输入机构名称(英)");
    //    }
    else if (_organizaNameEn.text.length >0 && [self IsChinese:_organizaNameEn.text]){
        msg =HKLocalizedString(@"机构名称(英)不接受中文输入");
    }
    //
    else if (_editNameView.belongNumberTextField.text.length == 0 && _editNameView.typeSeg.selectedSegmentIndex != 3) {
        msg =HKLocalizedString(@"请输入[商业登记号码/香港社团注册证明书编号/税局档号]");
    }
    else if ([self IsChinese:_editNameView.belongNumberTextField.text] && _editNameView.typeSeg.selectedSegmentIndex != 3){
        msg =HKLocalizedString(@"[商业登记号码/香港社团注册证明书编号/税局档号] 错误");
    }
    else if (_editNameView.belongNumberTextField.text.length == 0 && ![_editNameView.recordTypeField.text isEqualToString:HKLocalizedString(@"不适用")]) {
        msg =HKLocalizedString(@"请输入[商业登记号码/香港社团注册证明书编号/税局档号]");
    }
    
    else if (![_editNameView.belongNumberTextField.text isEqualToString:HKLocalizedString(@"不适用")] && _editNameView.typeSeg.selectedSegmentIndex != 3 && _editNameView.belongNumberTextField.text.length == 0){
        msg =HKLocalizedString(@"请输入[商业登记号码/香港社团注册证明书编号/税局档号]");
        
    }
    else if (_editNameView.belongNumberTextField.text.length >0 && [self IsChinese:_editNameView.belongNumberTextField.text]){
        msg =HKLocalizedString(@"[商业登记号码/香港社团注册证明书编号/税局档号] 错误");
    }
    //姓名
    else if([self nameStrIsTrue]){
        msg = [self nameStrIsTrue];
    }
    //
    else if (_editConnectionView.jobTitleField.text.length == 0){
        msg = HKLocalizedString(@"请输入[职位]");
    }
    else if (_editConnectionView.emailField.text.length == 0){
        msg = HKLocalizedString(@"请输入[电邮地址]");
    }
    else if (![NSString isEmail:_editConnectionView.emailField.text]){
        msg = HKLocalizedString(@"[电邮地址]错误");
    }
    //    else if (self.telCodeField.text.length == 0){
    //        msg = @"请输入电话区号";
    //    }
    else if (_editConnectionView.phoneField.text.length == 0){
        msg = HKLocalizedString(@"请输入[联络电话]");
    }
    else if (![EGVerifyTool isNumeric:_editConnectionView.phoneField.text]){
        msg = HKLocalizedString(@"[联络电话]只能輸入數字");
    }
    //"请输入[机构地址]"
    else if (_editPersonConnView.Field1.text.length == 0 && _editPersonConnView.Field2.text.length == 0 && _editPersonConnView.Field3.text.length == 0 && _editPersonConnView.Field4.text.length == 0 &&  _editPersonConnView.Field5.text.length == 0){
        msg  = HKLocalizedString(@"请输入[机构地址]");
    }
    else if (_editPersonConnView.addSeg.selectedSegmentIndex == 1 && _editPersonConnView.otherField.text.length == 0){
        msg =HKLocalizedString(@"请输入[其他，请注明]");
    }
   
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
        nav.touchSpaceHide = NO;//点击没有内容的地方消失
    }
    [nav show:YES animated:YES];
}

-(BOOL)IsChinese:(NSString*)str{
    
    for (int j=0; j<str.length; j++) {
        unichar ch = [str characterAtIndex:j];
        if (0x4e00 < ch  && ch < 0x9fff)
        {
            return YES;
        }
        
        
    }
    return NO;
    
}

-(NSString*)nameStrIsTrue{
    NSString* msg = nil;
    //填姓 一定要填名  中文或英文姓名最少有一个也可以
    //中         没有英文姓名  或 输入了中文名  没有中文姓
    
    NSString *chiFirstName = _editConnectionView.chisurnameField.text;
    NSString *chiLastName = _editConnectionView.chinameField.text;
    
    NSString *engFirstName = _editConnectionView.engsurnameField.text;
    NSString *engLastName = _editConnectionView.engnameField.text;
    
    if (((engLastName.length == 0 && engFirstName.length == 0) || chiLastName.length>0)  && chiFirstName.length == 0){
        msg = HKLocalizedString(@"请输入[联络人姓名(中)(姓)]");
    }
    else if (chiFirstName.length>0 && ![EGVerifyTool isVerificatioZhongWen:chiFirstName]){
        msg = HKLocalizedString(@"联络人姓名(中)(姓) 内请输入中文");
    }
    
    else if (chiFirstName.length>0 && chiLastName.length == 0){
        msg = HKLocalizedString(@"请输入[联络人姓名(中)(名)]");
    }
    else if (chiLastName.length>0 && ![EGVerifyTool isVerificatioZhongWen:chiLastName]){
        msg = HKLocalizedString(@"联络人姓名(中)(名) 内请输入中文");
    }
    //英    没有中文姓名  或 输入了英文名  没有英文姓
    else if (((chiFirstName.length == 0 && chiLastName.length == 0 ) || engLastName.length>0) && engFirstName.length == 0){
        msg = HKLocalizedString(@"请输入[联络人姓名(英)(姓)]");
    }
    else if (engFirstName.length>0 && ![EGVerifyTool isVerificationZimu:engFirstName]){
        msg = HKLocalizedString(@"联络人姓名(英)(姓) 内请输入英文");
    }
    else if (engFirstName.length>0 && engLastName.length == 0){
        msg =HKLocalizedString(@"请输入[联络人姓名(英)(名)]");
    }
    else if (engLastName.length>0 && ![EGVerifyTool isVerificationZimu:engLastName]){
        msg = HKLocalizedString(@"联络人姓名(英)(名) 内请输入英文");
    }
    return  msg;
}

-(NSString*)userStrIsTrue{
    //登录名 密码
    
    NSString* msg = nil;
    NSString *name = _editNameView.nameField.text;
    NSString *pwd = _editNameView.pwdField.text;
    NSString *cpwd = _editNameView.resetPwdField.text;
    
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
