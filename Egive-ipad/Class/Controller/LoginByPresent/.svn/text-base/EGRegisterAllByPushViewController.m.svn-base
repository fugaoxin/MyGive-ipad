//
//  EGRegisterSelfViewController.m
//  Egive-ipad
//
//  Created by sino on 15/12/7.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGRegisterAllByPushViewController.h"
#import "MemberFormModel.h"
#import "EGUserModel.h"
#import "EGRegisterAlertViewController.h"
#import "EGVerifyTool.h"
#import "NSString+RegexKitLite.h"
#import "CZPickerView.h"
#import "NSString+Helper.h"
#import "EGAgreeStatementViewController.h"

@interface EGRegisterAllByPushViewController ()<UIPickerViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    NSMutableArray * _belongCd;
    NSMutableArray * _belongDesp;
    
    NSMutableArray *BusinessTypeCd;
    NSMutableArray *BusinessTypeDesp;
    
    NSMutableArray * AreaDesp;
    
    NSInteger selectedBelongTo;
    NSInteger selectedBusinessType;
    NSInteger selectedArea;
    
    BOOL isThrRegister;
    BOOL isWeibo;
    BOOL isFaceBook;
    BOOL isSelEmail;//是否收电邮
    BOOL isLike;//愿意
    NSString * sexType;//性别
    NSString* CorporationType; //商业类型
    
    UIImageView* organizaBusinessIV;
    UIImageView* organizaAreaIV;
    
    UIView *line1;
    UIView *line3;
    
    NSString *  base64AvatarPerson;//个人头像
    NSString *  base64AvatarOrganiza;//机构头像
    NSString *  base64Avatar;//头像
    
}
@property (strong, nonatomic) NSMutableArray *receiveBtns;
@property (copy, nonatomic) NSMutableArray *receiveSelArr;

@property (strong, nonatomic) UIPickerView *pickerViewPopupBelongTo;
@property (strong, nonatomic) UIPickerView *pickerViewPopupBusinessType;
@property (strong, nonatomic) UIPickerView *pickerViewPopupArea;

@property (strong, nonatomic) MemberFormModel* FormModel;
@property(nonatomic,retain) UIView *selectView;//选择

//
@property (copy, nonatomic) NSDictionary *fbdata;
@property (copy, nonatomic) NSDictionary *wbdata;
@property (retain, nonatomic) UIView *contantPersonView;
@property (retain, nonatomic) UIView *contantOrganizaView;


//
@property (strong, nonatomic)  UIImageView *userImgeView;

@property (strong, nonatomic)  UITextField * userName;
@property (strong, nonatomic)  UITextField * passWord;
@property (strong, nonatomic)  UITextField * confirmPW;
@property (strong, nonatomic)  UILabel *pwMessageLab;

@property (strong, nonatomic)  UISegmentedControl *segment_M;

@property (strong, nonatomic)  UITextField * lastNameCh;
@property (strong, nonatomic)  UITextField * nameCh;
@property (strong, nonatomic)  UITextField * lastNameEn;
@property (strong, nonatomic)  UITextField * nameEn;

@property (strong, nonatomic)  UITextField * email;
@property (strong, nonatomic)  UILabel *emailMessageLab;

@property (strong, nonatomic)  UITextField * belongToType;

//
@property (strong, nonatomic)  UILabel *receiveMessageLab;
@property (strong, nonatomic)  UISegmentedControl *segment_IsReceive;
@property (strong, nonatomic)  UIView *receiveView;
@property (strong, nonatomic)  UILabel *receiveViewMessageLab;

@property (strong, nonatomic)  UILabel *likeMessageLab;
@property (strong, nonatomic)  UISegmentedControl *segment_Like;
@property (strong, nonatomic)  UIView *likeView;
@property (strong, nonatomic)  UITextField * telField;
@property (strong, nonatomic)  UITextField * telCodeField;

//
@property (strong, nonatomic)  UISegmentedControl *segment_OrganizationType;//企业类型
@property (strong, nonatomic)  UITextField *otherMessage;
//机构信息
@property (strong, nonatomic)  UITextField * organizaNameCh;
@property (strong, nonatomic)  UITextField * organizaNameEn;

@property (strong, nonatomic)  UITextField * organizaNumber;//商业登记号
@property (strong, nonatomic)  UITextField * otherOrganizaNumber;//其他号

@property (strong, nonatomic)  UILabel *organizaNumberLabel;

@property (strong, nonatomic)  UILabel * contactPersonLabel;
@property (strong, nonatomic)  UITextField * position;//职位
//机构地址
@property (strong, nonatomic)  UILabel *organizaAddressLab;
@property (strong, nonatomic)  UILabel *organizaAddressMsgLab;

@property (strong, nonatomic)  UITextField *organizaAddress1;//室
@property (strong, nonatomic)  UITextField *organizaAddress2;//大楼
@property (strong, nonatomic)  UITextField *organizaAddress3;//屋宛
@property (strong, nonatomic)  UITextField *organizaAddress4;//门牌
@property (strong, nonatomic)  UITextField *organizaAddress5;//地区
@property (strong, nonatomic)  UISegmentedControl *segment_organizaAddress;//是否香港
@property (strong, nonatomic)  UITextField *organizaAddress6;//不是香港 填国家

@end

@implementation EGRegisterAllByPushViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = HKLocalizedString(@"意赠之友登记表格");
    [self createNaviTopBarWithShowBackBtn:YES showTitle:YES];
    base64Avatar = @"";
    base64AvatarPerson = @"";
    base64AvatarOrganiza = @"";
    //head
    _switchTabbar = [UIView new];
    _switchTabbar.frame = (CGRect){0,0,self.size.width,45};
    [self.contentView addSubview:self.switchTabbar];
    
    _personBtn = [self createButton:0 title:@"个人" nor:@"reg_personal_nor" sel:@"reg_personal_sel"];
    _personBtn.selected = YES;
    [self.switchTabbar addSubview:_personBtn];
    [self.personBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_switchTabbar);
        make.leading.equalTo(_switchTabbar);
        make.bottom.equalTo(_switchTabbar);
    }];
    _organizaBtn = [self createButton:1 title:@"机构" nor:@"reg_company_nor" sel:@"reg_company_sel"];
    [self.switchTabbar addSubview:_organizaBtn];
    [self.organizaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_switchTabbar);
        make.leading.mas_equalTo(_personBtn.mas_trailing);
        make.bottom.equalTo(_switchTabbar);
        make.trailing.mas_equalTo(_switchTabbar.mas_trailing).offset(-30);
        make.width.equalTo(_personBtn);
    }];
   //
    _bgPersonScrollView = [TPKeyboardAvoidingScrollView new];
    _bgPersonScrollView.frame = (CGRect){0,45,self.size.width,self.size.height-60-44-45};//44bar高度
    _bgOrganizaScrollView = [TPKeyboardAvoidingScrollView new];
    _bgOrganizaScrollView.frame = (CGRect){0,45,self.size.width,self.size.height-60-44-45};
    [self.contentView addSubview:self.bgPersonScrollView];
    [self.contentView addSubview:self.bgOrganizaScrollView];
    
    _bottomView = [UIView new];
    _bottomView.frame = (CGRect){0,self.size.height-60-44,self.size.width,60};
    [self.contentView addSubview:self.bottomView];
    //bottom
    //bottom
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    _commitBtn = [[UIButton alloc]init];
    [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _commitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _commitBtn.backgroundColor = [UIColor colorWithHexString:@"#531E7E"];
    _commitBtn.layer.cornerRadius = 5;
    [_commitBtn addTarget:self action:@selector(commitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:_commitBtn];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bottomView).offset(10);
        make.leading.mas_equalTo(_bottomView.mas_leading).offset(30);
        make.bottom.mas_equalTo(_bottomView).offset(-10);
        make.trailing.mas_equalTo(_bottomView.mas_trailing).offset(-30);
    }];
    
    [self setPersonUI];
    [_bgOrganizaScrollView setHidden:YES];
    
    [self getBelongToArr];
    
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardWillHide_register)];
    [self.contentView addGestureRecognizer:tap0];
    
    //
    UIView *colorView = [[UIView alloc]initWithFrame:CGRectMake(0, self.switchTabbar.frame.size.height-1, self.switchTabbar.frame.size.width, 1)];
    colorView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    [self.switchTabbar addSubview:colorView];
    
    self.selectView = [[UIView alloc]initWithFrame:CGRectMake(0, self.switchTabbar.frame.size.height-4, _personBtn.frame.size.width, 3)];
    self.selectView.backgroundColor = [UIColor colorWithHexString:@"#69318f"];
    [self.switchTabbar addSubview:self.selectView];
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_switchTabbar.mas_bottom).offset(-1);
        make.leading.mas_equalTo(_switchTabbar.mas_leading);
        make.trailing.mas_equalTo(_switchTabbar.mas_centerX);
        make.height.mas_equalTo(3);
    }];
   
}

- (void)viewDidDisappear:(BOOL)animated
{
    // MyLog(@"viewDidDisappear");
    [super viewDidDisappear:YES];
    [SVProgressHUD dismiss];
}
#pragma mark- tab点击事件
-(IBAction)typeAction:(UIButton *)button{
    if(button.selected){
        return;
    }
    _personBtn.selected = NO;
    _organizaBtn.selected = NO;
    [_bgPersonScrollView setHidden:YES];
    [_bgOrganizaScrollView setHidden:YES];
    
    button.selected = YES;
//    self.selectView.frame = CGRectMake(self.switchTabbar.frame.size.width/2*button.tag, self.selectView.frame.origin.y, self.selectView.frame.size.width, self.selectView.frame.size.height);
    if (button.tag == 0) {
         [_bgPersonScrollView setHidden:NO];
        [self setPersonUI];
        [self.selectView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_switchTabbar.mas_leading);
            make.trailing.mas_equalTo(_switchTabbar.mas_centerX);
            make.bottom.equalTo(_switchTabbar.mas_bottom).offset(-1);
            make.height.mas_equalTo(3);
        }];
        
    }else if(button.tag == 1){
         [_bgOrganizaScrollView setHidden:NO];
         [self setOrganizaUI];
        [self.selectView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_switchTabbar.mas_bottom).offset(-1);
            make.height.mas_equalTo(3);
            make.trailing.mas_equalTo(_switchTabbar.mas_trailing);
            make.leading.mas_equalTo(_switchTabbar.mas_centerX);
        }];
    }
}

#pragma mark -  method
-(void)loadFBandWBdata
{
    //
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *faceBookString = [NSString stringWithFormat:@"%@",[standardUserDefaults objectForKey:@"FACEBOOK_REG_REQ"]];
    NSString *weiBoString = [NSString stringWithFormat:@"%@",[standardUserDefaults objectForKey:@"WEIBO_REG_REQ"]];
    isThrRegister = NO;
    isWeibo = NO;
    isFaceBook = NO;
    if ([faceBookString isEqualToString:@"1"] || [weiBoString isEqualToString:@"1"]){
        //是微博 或 Facebook
        isThrRegister = YES;
        if ([weiBoString isEqualToString:@"1"]) {
            isWeibo = YES;
        }else{
            isFaceBook = YES;
        }
    }
    if ([standardUserDefaults objectForKey:@"FACEBOOK_REG_REQ"] != nil && [[standardUserDefaults objectForKey:@"FACEBOOK_REG_REQ"] isEqualToString:@"1"])
    {
        _fbdata = [standardUserDefaults objectForKey:@"FACEBOOK_DETAIL"];
        self.userName.text = [_fbdata objectForKey:@"name"] ;
        if ([EGVerifyTool isChinese:[_fbdata objectForKey:@"last_name"]]){
            _lastNameCh.text = [_fbdata objectForKey:@"last_name"];
            
        }else{
            _lastNameEn.text = [_fbdata objectForKey:@"last_name"];
        }
        if ([EGVerifyTool isChinese:[_fbdata objectForKey:@"first_name"]]) {
            
            _nameCh.text = [_fbdata objectForKey:@"first_name"];
        }else{
            
            _nameEn.text = [_fbdata objectForKey:@"first_name"];
        }
        self.email.text = [_fbdata objectForKey:@"email"];
        self.userImgeView.image = [UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:[standardUserDefaults objectForKey:@"FACEBOOK_PICTURE"] options:NSDataBase64DecodingIgnoreUnknownCharacters]];
        
    } else if ([standardUserDefaults objectForKey:@"WEIBO_REG_REQ"] != nil && [[standardUserDefaults objectForKey:@"WEIBO_REG_REQ"] isEqualToString:@"1"])
    {
        _wbdata = [standardUserDefaults objectForKey:@"WEIBO_DETAIL"];
        self.userName.text = [_wbdata objectForKey:@"userName"];
        self.userImgeView.image = [UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:[standardUserDefaults objectForKey:@"WEIBO_PICTURE"] options:NSDataBase64DecodingIgnoreUnknownCharacters]];
    }
    //
    sexType = @"R";
    _segment_M.selectedSegmentIndex = 0;
    if (_fbdata != nil) {
        NSString *gender = [_fbdata objectForKey:@"gender"];
        if (![gender isEqualToString:@"male"]) {
            _segment_M.selectedSegmentIndex = 2;
            sexType = @"M";
        }
    } else if (_wbdata != nil) {
        NSString *gender = [_wbdata objectForKey:@"gender"];
        if (![gender isEqualToString:@"m"]) {
            _segment_M.selectedSegmentIndex = 2;
            sexType = @"M";
        }
    }
}

-(void)passwordShow{
    if (isThrRegister) {
        _passWord.placeholder = HKLocalizedString(@"此项不需要填写");
        _passWord.userInteractionEnabled = NO;
        _confirmPW.placeholder = HKLocalizedString(@"此项不需要填写");
        _confirmPW.userInteractionEnabled = NO;
    }else{
        _passWord.userInteractionEnabled = YES;
        _confirmPW.userInteractionEnabled = YES;
    }
    
}

-(NSString*)userStrIsTrue{
    //登录名 密码
    
    NSString* msg = nil;
    if (self.userName.text.length == 0) {
        msg =HKLocalizedString(@"请输入登入名称");
    }
    else if(![NSString validateUserName:self.userName.text]){
        msg =HKLocalizedString(@"无效的用户名称");
    }
    ////密码可以中文
    else  if (self.passWord.text.length == 0 && !isThrRegister){
        msg = HKLocalizedString(@"密码不能为空");
    }
    else if ([EGVerifyTool isVerificatioZhongWen:self.passWord.text] && !isThrRegister){
        msg = HKLocalizedString(@"密码不能输入中文");
    }
    else if (self.passWord.text.length < 6 && !isThrRegister) {
        msg = HKLocalizedString(@"最少需要6個字元");
    }
    
    else if (self.confirmPW.text.length == 0 && !isThrRegister){
        msg = HKLocalizedString(@"请输入确认密码");
    }
    else if (![self.confirmPW.text isEqualToString:self.passWord.text] && !isThrRegister){
        msg = HKLocalizedString(@"密码不一致");
    }
    return  msg;
}

-(NSString*)nameStrIsTruePerson{
    NSString* msg = nil;
    //填姓 一定要填名  中文或英文姓名最少有一个也可以
    //中         没有英文姓名  或 输入了中文名  没有中文姓
    if (((self.lastNameEn.text.length == 0 && self.nameEn.text.length == 0) || self.nameCh.text.length>0)  && self.lastNameCh.text.length == 0){
        msg = HKLocalizedString(@"请输入[姓名(中)(姓)]");
    }
    else if (self.lastNameCh.text.length>0 && ![EGVerifyTool isVerificatioZhongWen:self.lastNameCh.text]){
        msg = HKLocalizedString(@"姓名(中)(姓) 内请输入中文");
    }
    
    else if (self.lastNameCh.text.length>0 && self.nameCh.text.length == 0){
        msg = HKLocalizedString(@"请输入[姓名(中)(名)]");
    }
    else if (self.nameCh.text.length>0 && ![EGVerifyTool isVerificatioZhongWen:self.nameCh.text]){
        msg = HKLocalizedString(@"姓名(中)(名) 内请输入中文");
    }
    //英    没有中文姓名  或 输入了英文名  没有英文姓
    else if (((self.lastNameCh.text.length == 0 && self.nameCh.text.length == 0 ) || self.nameEn.text.length>0) && self.lastNameEn.text.length == 0){
        msg = HKLocalizedString(@"请输入[姓名(英)(姓)]");
    }
    else if (self.lastNameEn.text.length>0 && ![EGVerifyTool isVerificationZimu:self.lastNameEn.text]){
        msg = HKLocalizedString(@"姓名(英)(姓) 内请输入英文");
    }
    
    else if (self.lastNameEn.text.length>0 && self.nameEn.text.length == 0){
        msg =HKLocalizedString(@"请输入[姓名(英)(名)]");
    }
    else if (self.nameEn.text.length>0 && ![EGVerifyTool isVerificationZimu:self.nameEn.text]){
        msg = HKLocalizedString(@"姓名(英)(名) 内请输入英文");
    }
    return  msg;
}
-(NSString*)nameStrIsTrue{
    NSString* msg = nil;
    //填姓 一定要填名  中文或英文姓名最少有一个也可以
    //中         没有英文姓名  或 输入了中文名  没有中文姓
    if (((self.lastNameEn.text.length == 0 && self.nameEn.text.length == 0) || self.nameCh.text.length>0)  && self.lastNameCh.text.length == 0){
        msg = HKLocalizedString(@"请输入[联络人姓名(中)(姓)]");
    }
    else if (self.lastNameCh.text.length>0 && ![EGVerifyTool isVerificatioZhongWen:self.lastNameCh.text]){
        msg = HKLocalizedString(@"联络人姓名(中)(姓) 内请输入中文");
    }
    
    else if (self.lastNameCh.text.length>0 && self.nameCh.text.length == 0){
        msg = HKLocalizedString(@"请输入[联络人姓名(中)(名)]");
    }
    else if (self.nameCh.text.length>0 && ![EGVerifyTool isVerificatioZhongWen:self.nameCh.text]){
        msg = HKLocalizedString(@"联络人姓名(中)(名) 内请输入中文");
    }
    //英    没有中文姓名  或 输入了英文名  没有英文姓
    else if (((self.lastNameCh.text.length == 0 && self.nameCh.text.length == 0 ) || self.nameEn.text.length>0) && self.lastNameEn.text.length == 0){
        msg = HKLocalizedString(@"请输入[联络人姓名(英)(姓)]");
    }
    else if (self.lastNameEn.text.length>0 && ![EGVerifyTool isVerificationZimu:self.lastNameEn.text]){
        msg = HKLocalizedString(@"联络人姓名(英)(姓) 内请输入英文");
    }
    
    else if (self.lastNameEn.text.length>0 && self.nameEn.text.length == 0){
        msg =HKLocalizedString(@"请输入[联络人姓名(英)(名)]");
    }
    else if (self.nameEn.text.length>0 && ![EGVerifyTool isVerificationZimu:self.nameEn.text]){
        msg = HKLocalizedString(@"联络人姓名(英)(名) 内请输入英文");
    }
    return  msg;
}

-(UIImage*)getImage{
    UIImage* image = [UIImage imageNamed:@"comment_picker"];
    CGFloat top = 5; // 顶端盖高度
    CGFloat bottom = 5 ; // 底端盖高度
    CGFloat left = 5; // 左端盖宽度
    CGFloat right = 22; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    return image;
}

-(void)getBelongToArr{
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
//    NSDictionary *dict =  [standardUserDefaults objectForKey:@"EGIVE_MemberFormModel_kevin"];
    NSDictionary* dict=[standardUserDefaults objectForKey:[NSString stringWithFormat:@"EGIVE_MemberFormModel_%ld_kevin",[Language getLanguage]]];
    if(dict && dict.count>0){
        _FormModel = [[MemberFormModel alloc] init];
        [_FormModel setValuesForKeysWithDictionary:dict];
    }
    NSArray * options = _FormModel.BelongToOptions[@"options"];
    //    NSLog(@"optionsoptionsoptions = %@", options);
    if (!_belongDesp) {
        _belongDesp = [[NSMutableArray alloc] init];
        _belongCd = [[NSMutableArray alloc] init];
    }
    for (NSDictionary * opDict in options) {
        
        [_belongDesp addObject:opDict[@"Desp"]];
        [_belongCd addObject:opDict[@"Cd"]];
    }

}

-(void)getBusinessTypeArr{
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
//    NSDictionary *dict =  [standardUserDefaults objectForKey:@"EGIVE_MemberFormModel_kevin"];
    NSDictionary* dict=[standardUserDefaults objectForKey:[NSString stringWithFormat:@"EGIVE_MemberFormModel_%ld_kevin",[Language getLanguage]]];
    if(dict && dict.count>0){
        _FormModel = [[MemberFormModel alloc] init];
        [_FormModel setValuesForKeysWithDictionary:dict];
    }
    NSArray * options = _FormModel.BusinessRegistrationTypeOptions[@"options"];
    //    NSLog(@"optionsoptionsoptions = %@", options);
    if (!BusinessTypeDesp || BusinessTypeDesp.count>0 ) {
        BusinessTypeDesp = [[NSMutableArray alloc] init];
        BusinessTypeCd = [[NSMutableArray alloc] init];
    }
    for (NSDictionary * opDict in options) {
        if ([opDict[@"Cd"] isEqualToString:@""]) {
            [BusinessTypeDesp addObject:HKLocalizedString(@"不适用")];
        }else{
            [BusinessTypeDesp addObject:opDict[@"Desp"]];
        }
        [BusinessTypeCd addObject:opDict[@"Cd"]];
    }
}

-(void)getAreaArr{
    
    
    AreaDesp = [[NSMutableArray alloc] init];
    
    [AreaDesp addObject:HKLocalizedString(@"Central and Western")];
    [AreaDesp addObject:HKLocalizedString(@"Eastern")];
    [AreaDesp addObject:HKLocalizedString(@"Southern")];
    [AreaDesp addObject:HKLocalizedString(@"Wan Chai")];
    [AreaDesp addObject:HKLocalizedString(@"Sham Shui Po")];
    [AreaDesp addObject:HKLocalizedString(@"Kowloon City")];
    [AreaDesp addObject:HKLocalizedString(@"Kwun Tong")];
    [AreaDesp addObject:HKLocalizedString(@"Wong Tai Sin")];
    [AreaDesp addObject:HKLocalizedString(@"Yau Tsim Mong")];
    [AreaDesp addObject:HKLocalizedString(@"Islands")];
    [AreaDesp addObject:HKLocalizedString(@"Kwai Tsing")];
    [AreaDesp addObject:HKLocalizedString(@"North")];
    [AreaDesp addObject:HKLocalizedString(@"Sai Kung")];
    [AreaDesp addObject:HKLocalizedString(@"Sha Tin")];
    [AreaDesp addObject:HKLocalizedString(@"Tai Po")];
    [AreaDesp addObject:HKLocalizedString(@"Tsuen Wan")];
    [AreaDesp addObject:HKLocalizedString(@"Tuen Mun")];
    [AreaDesp addObject:HKLocalizedString(@"Yuen Long")];
}


- (void)keyboardWillHide_register{
    // 关闭键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self removePopview];
}
-(void)removePopview{
    if (_pickerViewPopupBelongTo) {
        [_pickerViewPopupBelongTo removeFromSuperview];
    }
    if (_pickerViewPopupBusinessType) {
        [_pickerViewPopupBusinessType removeFromSuperview];
    }
    if (_pickerViewPopupArea) {
        [_pickerViewPopupArea removeFromSuperview];
    }
}

-(UITextField*)createTextFild
{
    UITextField* textField =[[UITextField alloc]init];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:15];
    textField.borderStyle =  UITextBorderStyleRoundedRect;
    textField.delegate = self;
    return textField;
}

-(UILabel*)createLabel:(CGFloat)fontSize
{
    UILabel* label =[[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithHexString:@"#7d7d7d"];
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}
-(UIButton*)createButton:(int)tag title:(NSString*)title nor:(NSString*)norImage sel:(NSString*)selImage
{
    UIButton* btn = [[UIButton alloc]init];
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor colorWithHexString:@"#7d7d7d"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#69318f"] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn setImage:[UIImage imageNamed:norImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selImage] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(typeAction:) forControlEvents:UIControlEventTouchUpInside];

    return btn;
}

#pragma mark - createView method
#pragma mark   个人UI
-(void)setPersonUI{
    if (_contantPersonView) {
        [_contantPersonView removeFromSuperview];
    }
    UIView *contantPersonView = [UIView new];
    contantPersonView.userInteractionEnabled = YES;
    _contantPersonView = contantPersonView;
    contantPersonView.backgroundColor = [UIColor clearColor];
    [_bgPersonScrollView addSubview:contantPersonView];
    
    [contantPersonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bgPersonScrollView);
        make.width.equalTo(_bgPersonScrollView);
    }];
    //
    self.userImgeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 98, 98)];
    self.userImgeView.userInteractionEnabled = YES;
    self.userImgeView.backgroundColor = [UIColor lightGrayColor];
    self.userImgeView.layer.cornerRadius = 98/2;
    self.userImgeView.layer.masksToBounds = YES;
    
    if ([base64AvatarPerson isEqualToString:@""] || base64AvatarPerson == nil) {
        self.userImgeView.image = [UIImage imageNamed:@"reg_default_personal"];
    }else{
        self.userImgeView.image = [UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:base64AvatarPerson options:NSDataBase64DecodingIgnoreUnknownCharacters]];
    }
    UITapGestureRecognizer * imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageTapAction)];
    [self.userImgeView addGestureRecognizer:imageTap];
    [_contantPersonView addSubview:self.userImgeView];
    [self.userImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.centerX.mas_equalTo(_contantPersonView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(98, 98));
    }];
    //用户
    self.userName = [self createTextFild];
    [_contantPersonView addSubview:self.userName];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userImgeView.mas_bottom).offset(30);
//        make.leading.mas_equalTo(60);
        make.height.mas_equalTo(30);
        make.trailing.mas_equalTo(_userImgeView.mas_centerX).offset(-5);
    }];
    
    self.passWord = [self createTextFild];
    [_contantPersonView addSubview:self.passWord];
    [self.passWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_userName);
        make.leading.mas_equalTo(_userImgeView.mas_centerX).offset(5);
        make.height.equalTo(_userName);
    }];
    
    self.confirmPW = [self createTextFild];
    [_contantPersonView addSubview:self.confirmPW];
    [self.confirmPW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_userName);
//        make.trailing.equalTo(_contantPersonView).offset(-60);
        make.height.equalTo(_passWord);
        make.width.equalTo(_passWord);
        make.leading.equalTo(_passWord.mas_trailing).offset(10);
        
    }];
    
    self.pwMessageLab = [self createLabel:14];
    self.pwMessageLab.textColor = [UIColor colorWithHexString:@"#a7a9ac"];
    [_contantPersonView addSubview:self.pwMessageLab];
    [self.pwMessageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passWord.mas_bottom);
        make.leading.equalTo(_passWord);
        make.trailing.equalTo(_confirmPW);
        make.height.mas_equalTo(20);
    }];
    //
    self.segment_M = [[UISegmentedControl alloc]initWithItems:@[@"1",@"2",@"3"]];
    self.segment_M.selectedSegmentIndex = 0;
    self.segment_M.tintColor = [UIColor colorWithHexString:@"#6eb92b"];
    [self.segment_M addTarget:self action:@selector(contactPersonAction:) forControlEvents:UIControlEventValueChanged];
    [_contantPersonView addSubview:self.segment_M];
    [self.segment_M mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pwMessageLab.mas_bottom).offset(10);
        make.centerX.equalTo(_userImgeView);
        make.width.mas_equalTo(240*3);
        make.leading.equalTo(_userName);
        make.trailing.equalTo(_confirmPW);
        make.height.mas_equalTo(28);
    }];
    //姓名
    self.lastNameCh = [self createTextFild];
    [_contantPersonView addSubview:self.lastNameCh];
    [self.lastNameCh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_segment_M.mas_bottom).offset(30);
        make.leading.equalTo(_segment_M);
        make.height.mas_equalTo(30);
    }];
    
    self.nameCh = [self createTextFild];
    [_contantPersonView addSubview:self.nameCh];
    [self.nameCh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_lastNameCh);
        make.height.mas_equalTo(_lastNameCh);
        make.width.mas_equalTo(_lastNameCh);
        make.trailing.equalTo(_userName);
        make.leading.equalTo(_lastNameCh.mas_trailing).offset(10);
        
    }];
    self.lastNameEn = [self createTextFild];
    [_contantPersonView addSubview:self.lastNameEn];
    [self.lastNameEn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_lastNameCh);
        make.leading.equalTo(_passWord);
        
    }];
    self.nameEn = [self createTextFild];
    [_contantPersonView addSubview:self.nameEn];
    [self.nameEn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_lastNameCh);
        make.height.mas_equalTo(_lastNameEn);
        make.width.mas_equalTo(_lastNameEn);
        make.trailing.equalTo(_segment_M);
        make.leading.equalTo(_lastNameEn.mas_trailing).offset(10);
        
    }];
    
    //地址
    self.email = [self createTextFild];
    [_contantPersonView addSubview:self.email];
    [self.email mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lastNameCh.mas_bottom).offset(30);
        make.height.mas_equalTo(30);
        make.leading.equalTo(_lastNameCh);
        make.trailing.equalTo(_nameCh);
        
    }];
    self.belongToType = [self createTextFild];
    
    [_contantPersonView addSubview:self.belongToType];
    [self.belongToType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_email);
        make.height.mas_equalTo(30);
        make.leading.equalTo(_lastNameEn);
        make.trailing.equalTo(_nameEn);
        
    }];
    
    UIImageView* selectView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _belongToType.frame.size.width, _belongToType.frame.size.height)];
    selectView.image = [self getImage];
    [_belongToType addSubview:selectView];
    [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_belongToType);
        make.height.mas_equalTo(_belongToType);
        make.leading.equalTo(_belongToType);
        make.trailing.equalTo(_belongToType);
        
    }];
    
    self.emailMessageLab = [self createLabel:14];
    [_contantPersonView addSubview:self.emailMessageLab];
    [self.emailMessageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_email.mas_bottom);
        make.leading.equalTo(_email);
        make.trailing.equalTo(_belongToType);
        make.height.mas_equalTo(20);
    }];
    //
    UIView *line = [UIView new];
    line.backgroundColor =  [UIColor colorWithHexString:@"#B6B6B6"];
    [_contantPersonView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_emailMessageLab.mas_bottom).offset(20);
        make.leading.equalTo(_emailMessageLab);
        make.trailing.equalTo(_emailMessageLab);
        make.height.mas_equalTo(1);
    }];
    //希望
    self.receiveMessageLab = [self createLabel:14];
    self.receiveMessageLab.textColor = [UIColor grayColor];
    [_contantPersonView addSubview:self.receiveMessageLab];
    [self.receiveMessageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(20);
        make.leading.equalTo(line);
        make.height.mas_equalTo(30);
    }];
    self.segment_IsReceive = [[UISegmentedControl alloc]initWithItems:@[@"1",@"2"]];
//    self.segment_IsReceive.selectedSegmentIndex = 1;
    self.segment_IsReceive.tintColor = [UIColor colorWithHexString:@"#6eb92b"];
    [self.segment_IsReceive addTarget:self action:@selector(receiveMessageAction:) forControlEvents:UIControlEventValueChanged];
    [_contantPersonView addSubview:self.segment_IsReceive];
    [self.segment_IsReceive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_receiveMessageLab);
        make.leading.equalTo(_receiveMessageLab.mas_trailing).offset(10);
        make.trailing.equalTo(line);
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(150);
    }];
    //receiveView
    self.receiveView = [UIView new];
    self.receiveView.userInteractionEnabled = YES;
    [_contantPersonView addSubview:self.receiveView];
    [self.receiveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_receiveMessageLab.mas_bottom).offset(5);
        make.leading.equalTo(_receiveMessageLab);
        make.trailing.equalTo(_segment_IsReceive);
        make.height.mas_equalTo(60);
    }];
    self.receiveViewMessageLab = [self createLabel:14];
    [_receiveView addSubview:self.receiveViewMessageLab];
    [self.receiveViewMessageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_receiveView);
        make.leading.equalTo(_receiveView);
        make.trailing.equalTo(_receiveView);
        make.height.mas_equalTo(60-30);
    }];
    //receiveView 按钮
    [self createReceiveBtns];
    //愿意
    self.likeMessageLab = [self createLabel:14];
    self.likeMessageLab.textColor = [UIColor grayColor];
    [_contantPersonView addSubview:self.likeMessageLab];
    [self.likeMessageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_receiveMessageLab.mas_bottom).offset(20+60);
        make.leading.equalTo(_receiveMessageLab);
        make.height.mas_equalTo(30);
    }];
    self.segment_Like = [[UISegmentedControl alloc]initWithItems:@[@"1",@"2"]];
//    self.segment_Like.selectedSegmentIndex = 1;
    self.segment_Like.tintColor = [UIColor colorWithHexString:@"#6eb92b"];
    [self.segment_Like addTarget:self action:@selector(likeMessageAction:) forControlEvents:UIControlEventValueChanged];
    [_contantPersonView addSubview:self.segment_Like];
    [self.segment_Like mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_likeMessageLab);
        make.leading.equalTo(_likeMessageLab.mas_trailing).offset(10);
        make.trailing.equalTo(_segment_IsReceive);
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(150);
    }];
    //likeView
    self.likeView = [UIView new];
    //    self.likeView.backgroundColor = [UIColor blueColor];
    [_contantPersonView addSubview:self.likeView];
    [self.likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_likeMessageLab.mas_bottom).offset(5);
        make.leading.equalTo(_likeMessageLab);
        make.trailing.equalTo(_segment_Like);
        make.height.mas_equalTo(30);
    }];
    self.telCodeField = [self createTextFild];
    [_likeView addSubview:self.telCodeField];
    [self.telCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_likeView);
        make.height.mas_equalTo(_likeView);
        make.leading.equalTo(_likeView);
        make.width.mas_equalTo(60);
        
    }];
    self.telField = [self createTextFild];
    [_likeView addSubview:self.telField];
    [self.telField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_telCodeField);
        make.height.equalTo(_telCodeField);
        make.leading.equalTo(_telCodeField.mas_trailing).offset(10);
        make.width.mas_equalTo(360);
        
    }];
    
    //
    [_contantPersonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_likeView.mas_bottom).offset(20);
    }];
    
//    _segment_IsReceive.selectedSegmentIndex = 1;
//    _segment_Like.selectedSegmentIndex = 1;

//    isSelEmail = NO;
    isLike = NO;
    
    _receiveView.hidden = YES;
    _likeView.hidden = YES;
    [self.likeMessageLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_receiveMessageLab.mas_bottom).offset(20);
    }];
    
    [self loadFBandWBdata];
    
    [self setUIString];
}

-(void)createReceiveBtns
{
    for (UIView* sub in _receiveView.subviews) {
        [sub removeFromSuperview];
    }
    UILabel* messageLabel = [self createLabel:14];
    messageLabel.text = HKLocalizedString(@"请选择你喜欢的专案类别(可选多项)");
    [_receiveView addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_receiveView);
        make.leading.equalTo(_receiveView);
        make.trailing.equalTo(_receiveView);
        make.height.mas_equalTo(20);
        
    }];
    
    _receiveBtns = [NSMutableArray array];
    NSMutableArray* widths = [NSMutableArray array];
    NSArray * emailViewTitleArray = @[HKLocalizedString(@"助学"),HKLocalizedString(@"安老"),HKLocalizedString(@"助医"),HKLocalizedString(@"扶贫"),HKLocalizedString(@"紧急援助"),HKLocalizedString(@"其他"),HKLocalizedString(@"意赠行动"),HKLocalizedString(@"全部")];
    CGFloat widthBtn = 0;
    for (int i = 0; i < 8; i++) {
        UILabel* aLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 25)];
        aLabel.text = emailViewTitleArray[i];
        CGSize maxSize = CGSizeMake(CGFLOAT_MAX, 25);
        CGSize size = [aLabel sizeThatFits:maxSize];
        CGFloat width = size.width+22;
        [widths addObject:[NSString stringWithFormat:@"%f",width]];
        
        widthBtn += size.width+22;
    }
    CGFloat spacing = (240*3 - widthBtn)/7;
    
    for (int i = 0; i < 8; i++) {
        UIButton* btn = [[UIButton alloc]init];
        btn.tag = i;
        //                btn.backgroundColor = [UIColor blueColor];
        [btn setTitle:@"2" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setImage:[UIImage imageNamed:@"cart_checkbox_nor"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"cart_checkbox_sel"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(receiveViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);//图标偏移
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);//偏移
        [_receiveView addSubview:btn];
        if (i==0) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_receiveView).offset(-5);
                make.leading.equalTo(_receiveView);
                make.height.mas_equalTo(25);
                make.width.mas_equalTo([widths[0] floatValue]);
            }];
        }else if (i==7) {
            UIButton* oneBtn = _receiveBtns[6];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(oneBtn);
                make.leading.equalTo(oneBtn.mas_trailing).offset(spacing);
                make.trailing.equalTo(_receiveView);
                make.height.mas_equalTo(oneBtn);
                make.width.mas_equalTo([widths[7] floatValue]);
            }];
        }else{
            UIButton* oneBtn = _receiveBtns[i-1];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(oneBtn);
                make.leading.equalTo(oneBtn.mas_trailing).offset(spacing);
                make.height.mas_equalTo(oneBtn);
                make.width.mas_equalTo([widths[i] floatValue]);
            }];
        }
        [_receiveBtns addObject:btn];
    }
}

#pragma mark  机构UI
-(void)setOrganizaUI{
    if (_contantOrganizaView) {
        [_contantOrganizaView removeFromSuperview];
    }
    
    
    UIView *contantOrganizaView = [UIView new];
    contantOrganizaView.userInteractionEnabled = YES;
    _contantOrganizaView = contantOrganizaView;
    contantOrganizaView.backgroundColor = [UIColor clearColor];
    [_bgOrganizaScrollView addSubview:contantOrganizaView];
    
    [contantOrganizaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bgOrganizaScrollView);
        make.width.equalTo(_bgOrganizaScrollView);
    }];
    //
    self.userImgeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 98, 98)];
    self.userImgeView.userInteractionEnabled = YES;
    self.userImgeView.backgroundColor = [UIColor lightGrayColor];
    self.userImgeView.layer.cornerRadius = 98/2;
    self.userImgeView.layer.masksToBounds = YES;
    
    if ([base64AvatarOrganiza isEqualToString:@""] || base64AvatarOrganiza == nil) {
        self.userImgeView.image = [UIImage imageNamed:@"reg_default_company"];
    }else{
        self.userImgeView.image = [UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:base64AvatarOrganiza options:NSDataBase64DecodingIgnoreUnknownCharacters]];
    }
    
    UITapGestureRecognizer * imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageTapAction)];
    [self.userImgeView addGestureRecognizer:imageTap];
    [_contantOrganizaView addSubview:self.userImgeView];
    [self.userImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.centerX.mas_equalTo(_contantOrganizaView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(98, 98));
    }];
    //企业类型
    self.segment_OrganizationType = [[UISegmentedControl alloc]initWithItems:@[@"1",@"2",@"3",@"4"]];
    self.segment_OrganizationType.selectedSegmentIndex = 0;
    self.segment_OrganizationType.tintColor = [UIColor colorWithHexString:@"#6eb92b"];
    [self.segment_OrganizationType addTarget:self action:@selector(organizationTypeAction:) forControlEvents:UIControlEventValueChanged];
    [_contantOrganizaView addSubview:self.segment_OrganizationType];
    [self.segment_OrganizationType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userImgeView.mas_bottom).offset(30);
        make.centerX.equalTo(_userImgeView);
        make.width.mas_equalTo(180*4);
        make.height.mas_equalTo(28);
    }];
    //其他 -- 注明
    self.otherMessage = [self createTextFild];
    [_contantOrganizaView addSubview:self.otherMessage];
    [self.otherMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_segment_OrganizationType.mas_bottom).offset(30);
        make.leading.equalTo(_segment_OrganizationType);
        make.trailing.equalTo(_segment_OrganizationType);
        make.height.mas_equalTo(30);
    }];
    
    //用户
    self.userName = [self createTextFild];
    [_contantOrganizaView addSubview:self.userName];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_segment_OrganizationType.mas_bottom).offset(30+30+30);
        make.leading.equalTo(_segment_OrganizationType);
        make.height.mas_equalTo(30);
        make.trailing.mas_equalTo(_userImgeView.mas_centerX).offset(-5);
    }];
    
    
    self.passWord = [self createTextFild];
    [_contantOrganizaView addSubview:self.passWord];
    [self.passWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_userName);
        make.leading.mas_equalTo(_userImgeView.mas_centerX).offset(5);
        make.height.equalTo(_userName);
    }];
    
    self.confirmPW = [self createTextFild];
    [_contantOrganizaView addSubview:self.confirmPW];
    [self.confirmPW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_userName);
        make.trailing.equalTo(_segment_OrganizationType);
        make.height.equalTo(_passWord);
        make.width.equalTo(_passWord);
        make.leading.equalTo(_passWord.mas_trailing).offset(10);
        
    }];
    
    self.pwMessageLab = [self createLabel:14];
    [_contantOrganizaView addSubview:self.pwMessageLab];
    [self.pwMessageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passWord.mas_bottom);
        make.leading.equalTo(_passWord);
        make.trailing.equalTo(_confirmPW);
        make.height.mas_equalTo(20);
    }];
   
    //机构信息
    self.organizaNameCh = [self createTextFild];
    [_contantOrganizaView addSubview:self.organizaNameCh];
    [self.organizaNameCh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pwMessageLab.mas_bottom).offset(10);
        make.trailing.equalTo(_userName);
        make.height.equalTo(_userName);
        make.leading.equalTo(_userName);
        
    }];
  
    self.organizaNameEn = [self createTextFild];
    [_contantOrganizaView addSubview:self.organizaNameEn];
    [self.organizaNameEn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_organizaNameCh);
        make.trailing.equalTo(_confirmPW);
        make.height.equalTo(_organizaNameCh);
        make.leading.equalTo(_passWord);
        
    }];
    
    self.organizaNumber = [self createTextFild];
    [_contantOrganizaView addSubview:self.organizaNumber];
    [self.organizaNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_organizaNameCh.mas_bottom).offset(30);
        make.trailing.equalTo(_organizaNameEn);
        make.height.equalTo(_organizaNameCh);
        make.leading.equalTo(_organizaNameCh);
        
    }];
    
    organizaBusinessIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _belongToType.frame.size.width, _belongToType.frame.size.height)];
    organizaBusinessIV.image = [self getImage];
    [_organizaNumber addSubview:organizaBusinessIV];
    [organizaBusinessIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_organizaNumber);
        make.height.mas_equalTo(_organizaNumber);
        make.leading.equalTo(_organizaNumber);
        make.trailing.equalTo(_organizaNumber);
        
    }];
    
    self.otherOrganizaNumber = [self createTextFild];
    [_contantOrganizaView addSubview:self.otherOrganizaNumber];
    [self.otherOrganizaNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_organizaNumber.mas_bottom).offset(20);
        make.trailing.equalTo(_organizaNumber);
        make.height.equalTo(_organizaNumber);
        make.leading.equalTo(_organizaNumber);
        
    }];
    //
    line1 = [UIView new];
    line1.backgroundColor =  [UIColor colorWithHexString:@"#B6B6B6"];
    [_contantOrganizaView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_organizaNumber.mas_bottom).offset(30+20+30);
        make.leading.equalTo(_organizaNumber);
        make.trailing.equalTo(_organizaNumber);
        make.height.mas_equalTo(1);
    }];
    
    self.organizaNumberLabel = [self createLabel:14];
    [_contantOrganizaView addSubview:self.organizaNumberLabel];
    [self.organizaNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_top).offset(-30);
        make.leading.equalTo(line1);
        make.trailing.equalTo(line1);
        make.height.mas_equalTo(20);
    }];
    
    self.contactPersonLabel = [self createLabel:14];
    self.contactPersonLabel.textColor = [UIColor blackColor];
    [_contantOrganizaView addSubview:self.contactPersonLabel];
    [self.contactPersonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(10);
        make.leading.equalTo(line1);
        make.trailing.equalTo(line1);
        make.height.mas_equalTo(20);
    }];
    
    //
    self.segment_M = [[UISegmentedControl alloc]initWithItems:@[@"1",@"2",@"3"]];
    self.segment_M.selectedSegmentIndex = 0;
    self.segment_M.tintColor = [UIColor colorWithHexString:@"#6eb92b"];
    [self.segment_M addTarget:self action:@selector(contactPersonAction:) forControlEvents:UIControlEventValueChanged];
    [_contantOrganizaView addSubview:self.segment_M];
    [self.segment_M mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contactPersonLabel.mas_bottom).offset(10);
        make.leading.equalTo(_contactPersonLabel);
        make.trailing.equalTo(_contactPersonLabel);
        make.height.mas_equalTo(28);
    }];
    //姓名
    self.lastNameCh = [self createTextFild];
    [_contantOrganizaView addSubview:self.lastNameCh];
    [self.lastNameCh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_segment_M.mas_bottom).offset(30);
        make.leading.equalTo(_segment_M);
        make.height.mas_equalTo(30);
    }];
    
    self.nameCh = [self createTextFild];
    [_contantOrganizaView addSubview:self.nameCh];
    [self.nameCh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_lastNameCh);
        make.height.mas_equalTo(_lastNameCh);
        make.width.mas_equalTo(_lastNameCh);
        make.trailing.equalTo(_userName);
        make.leading.equalTo(_lastNameCh.mas_trailing).offset(10);
        
    }];
    self.lastNameEn = [self createTextFild];
    [_contantOrganizaView addSubview:self.lastNameEn];
    [self.lastNameEn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_lastNameCh);
        make.leading.equalTo(_passWord);
        
    }];
    self.nameEn = [self createTextFild];
    [_contantOrganizaView addSubview:self.nameEn];
    [self.nameEn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_lastNameCh);
        make.height.mas_equalTo(_lastNameEn);
        make.width.mas_equalTo(_lastNameEn);
        make.trailing.equalTo(_segment_M);
        make.leading.equalTo(_lastNameEn.mas_trailing).offset(10);
        
    }];
    
    
    self.position = [self createTextFild];
    [_contantOrganizaView addSubview:self.position];
    [self.position mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lastNameCh.mas_bottom).offset(30);
        make.height.mas_equalTo(_lastNameCh);
        make.leading.equalTo(_lastNameCh);
        make.trailing.equalTo(_nameCh);
        
    }];
    
    //电邮地址
    self.email = [self createTextFild];
    [_contantOrganizaView addSubview:self.email];
    [self.email mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_position);
        make.height.mas_equalTo(_position);
        make.leading.equalTo(_lastNameEn);
        make.trailing.equalTo(_nameEn);
        
    }];
    
    self.emailMessageLab = [self createLabel:14];
    self.emailMessageLab.numberOfLines = 0;
    [_contantOrganizaView addSubview:self.emailMessageLab];
    [self.emailMessageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_email.mas_bottom);
        make.leading.equalTo(_email);
        make.trailing.equalTo(_email);
        make.height.mas_equalTo(40);
    }];
  
    self.telCodeField = [self createTextFild];
    [_contantOrganizaView addSubview:self.telCodeField];
    [self.telCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_position.mas_bottom).offset(30);
        make.height.equalTo(_position);
        make.leading.equalTo(_position);
        make.width.mas_equalTo(60);
        
    }];
    self.telField = [self createTextFild];
    [_contantOrganizaView addSubview:self.telField];
    [self.telField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_telCodeField);
        make.height.equalTo(_telCodeField);
        make.trailing.equalTo(_position);
        make.leading.equalTo(_telCodeField.mas_trailing).offset(10);
    }];
    
    //
    UIView *line2 = [UIView new];
    line2.backgroundColor =  [UIColor colorWithHexString:@"#B6B6B6"];
    [_contantOrganizaView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_telCodeField.mas_bottom).offset(20);
        make.leading.equalTo(_telCodeField);
        make.trailing.equalTo(_emailMessageLab);
        make.height.mas_equalTo(1);
    }];
    
    
    //机构地址
    self.organizaAddressLab = [self createLabel:14];
    self.organizaAddressLab.textColor = [UIColor blackColor];
    [_contantOrganizaView addSubview:self.organizaAddressLab];
    [self.organizaAddressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom).offset(10);
        make.leading.equalTo(line2);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(160);
    }];
    self.organizaAddressMsgLab = [self createLabel:14];
    [_contantOrganizaView addSubview:self.organizaAddressMsgLab];
    [self.organizaAddressMsgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_organizaAddressLab);
        make.leading.equalTo(_organizaAddressLab.mas_trailing).offset(5);
        make.height.equalTo(_organizaAddressLab);
        make.trailing.equalTo(line2);
        
    }];
    
    self.organizaAddress1 = [self createTextFild];
    [_contantOrganizaView addSubview:self.organizaAddress1];
    [self.organizaAddress1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_organizaAddressLab.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(150);
        make.leading.equalTo(_organizaAddressLab);
    }];
    self.organizaAddress2 = [self createTextFild];
    [_contantOrganizaView addSubview:self.organizaAddress2];
    [self.organizaAddress2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_organizaAddress1);
        make.height.equalTo(_organizaAddress1);
        make.trailing.equalTo(_telField);
        make.leading.equalTo(_organizaAddress1.mas_trailing).offset(10);
    }];
    self.organizaAddress3 = [self createTextFild];
    [_contantOrganizaView addSubview:self.organizaAddress3];
    [self.organizaAddress3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_organizaAddress1);
        make.height.equalTo(_organizaAddress1);
        make.trailing.equalTo(_emailMessageLab);
        make.leading.equalTo(_emailMessageLab);
    }];
    self.organizaAddress4 = [self createTextFild];
    [_contantOrganizaView addSubview:self.organizaAddress4];
    [self.organizaAddress4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_organizaAddress1.mas_bottom).offset(30);
        make.height.equalTo(_organizaAddress1);
        make.trailing.equalTo(_organizaAddress2);
        make.leading.equalTo(_organizaAddress1);
    }];
    self.organizaAddress5 = [self createTextFild];
    [_contantOrganizaView addSubview:self.organizaAddress5];
    [self.organizaAddress5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_organizaAddress4);
        make.height.equalTo(_organizaAddress4);
        make.leading.equalTo(_organizaAddress3);

    }];
    organizaAreaIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _organizaAddress5.frame.size.width, _organizaAddress5.frame.size.height)];
    organizaAreaIV.image = [self getImage];
    [_organizaAddress5 addSubview:organizaAreaIV];
    [organizaAreaIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_organizaAddress5);
        make.height.mas_equalTo(_organizaAddress5);
        make.leading.equalTo(_organizaAddress5);
        make.trailing.equalTo(_organizaAddress5);
        
    }];
    organizaAreaIV.hidden = YES;
    
    self.segment_organizaAddress = [[UISegmentedControl alloc]initWithItems:@[@"1",@"2"]];
    self.segment_organizaAddress.selectedSegmentIndex = 1;
    self.segment_organizaAddress.tintColor = [UIColor colorWithHexString:@"#6eb92b"];
    [self.segment_organizaAddress addTarget:self action:@selector(organizationAddressAction:) forControlEvents:UIControlEventValueChanged];
    [_contantOrganizaView addSubview:self.segment_organizaAddress];
    [self.segment_organizaAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_organizaAddress4);
        make.leading.equalTo(_organizaAddress5.mas_trailing).offset(10);
        make.trailing.equalTo(_organizaAddress3);
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(150);
    }];
    
    self.organizaAddress6 = [self createTextFild];
    [_contantOrganizaView addSubview:self.organizaAddress6];
    [self.organizaAddress6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_organizaAddress4.mas_bottom).offset(30);
        make.height.equalTo(_organizaAddress4);
        make.trailing.equalTo(_segment_organizaAddress);
        make.leading.equalTo(_organizaAddress4);
    }];
    
    //
    line3 = [UIView new];
    line3.backgroundColor =  [UIColor colorWithHexString:@"#B6B6B6"];
    [_contantOrganizaView addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_organizaAddress4.mas_bottom).offset(30+30+20);
        make.leading.equalTo(_organizaAddress6);
        make.trailing.equalTo(_organizaAddress6);
        make.height.mas_equalTo(1);
    }];
    //希望
    self.receiveMessageLab = [self createLabel:14];
    self.receiveMessageLab.textColor = [UIColor grayColor];
    [_contantOrganizaView addSubview:self.receiveMessageLab];
    [self.receiveMessageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line3.mas_bottom).offset(20);
        make.leading.equalTo(line3);
        make.height.mas_equalTo(30);
    }];
    self.segment_IsReceive = [[UISegmentedControl alloc]initWithItems:@[@"1",@"2"]];
//    self.segment_IsReceive.selectedSegmentIndex = 1;
    self.segment_IsReceive.tintColor = [UIColor colorWithHexString:@"#6eb92b"];
    [self.segment_IsReceive addTarget:self action:@selector(receiveMessageAction:) forControlEvents:UIControlEventValueChanged];
    [_contantOrganizaView addSubview:self.segment_IsReceive];
    [self.segment_IsReceive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_receiveMessageLab);
        make.leading.equalTo(_receiveMessageLab.mas_trailing).offset(10);
        make.trailing.equalTo(line3);
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(150);
    }];
    //receiveView
    self.receiveView = [UIView new];
    self.receiveView.userInteractionEnabled = YES;
    [_contantOrganizaView addSubview:self.receiveView];
    [self.receiveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_receiveMessageLab.mas_bottom).offset(5);
        make.leading.equalTo(_receiveMessageLab);
        make.trailing.equalTo(_segment_IsReceive);
        make.height.mas_equalTo(60);
    }];
    self.receiveViewMessageLab = [self createLabel:14];
    [_receiveView addSubview:self.receiveViewMessageLab];
    [self.receiveViewMessageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_receiveView);
        make.leading.equalTo(_receiveView);
        make.trailing.equalTo(_receiveView);
        make.height.mas_equalTo(60-30);
    }];
    //receiveView 按钮
    [self createReceiveBtns];
//    _receiveBtns = [NSMutableArray array];
//    for (int i = 0; i < 8; i++) {
//        UIButton* btn = [[UIButton alloc]init];
//        btn.tag = i;
//        //        btn.backgroundColor = [UIColor blueColor];
//        [btn setTitle:@"2" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [btn setImage:[UIImage imageNamed:@"cart_checkbox_nor"] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"cart_checkbox_sel"] forState:UIControlStateSelected];
//        [btn addTarget:self action:@selector(receiveViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);//图标偏移
//        [_receiveView addSubview:btn];
//        if (i==0) {
//            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.bottom.equalTo(_receiveView).offset(-5);
//                make.leading.equalTo(_receiveView);
//                make.height.mas_equalTo(25);
//            }];
//        }else if (i==7) {
//            UIButton* oneBtn = _receiveBtns[6];
//            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(oneBtn);
//                make.leading.equalTo(oneBtn.mas_trailing).offset(2);
//                make.trailing.equalTo(_receiveView);
//                make.height.mas_equalTo(oneBtn);
//                make.width.mas_equalTo(oneBtn);
//            }];
//        }else{
//            UIButton* oneBtn = _receiveBtns[i-1];
//            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(oneBtn);
//                make.leading.equalTo(oneBtn.mas_trailing).offset(2);
//                make.height.mas_equalTo(oneBtn);
//                make.width.mas_equalTo(oneBtn);
//            }];
//        }
//        [_receiveBtns addObject:btn];
//    }
    //愿意
    self.likeMessageLab = [self createLabel:14];
    self.likeMessageLab.textColor = [UIColor grayColor];
    [_contantOrganizaView addSubview:self.likeMessageLab];
    [self.likeMessageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_receiveMessageLab.mas_bottom).offset(20+60);
        make.leading.equalTo(_receiveMessageLab);
        make.height.mas_equalTo(30);
    }];
    self.segment_Like = [[UISegmentedControl alloc]initWithItems:@[@"1",@"2"]];
//    self.segment_Like.selectedSegmentIndex = 1;
    self.segment_Like.tintColor = [UIColor colorWithHexString:@"#6eb92b"];
    [self.segment_Like addTarget:self action:@selector(likeMessageAction:) forControlEvents:UIControlEventValueChanged];
    [_contantOrganizaView addSubview:self.segment_Like];
    [self.segment_Like mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_likeMessageLab);
        make.leading.equalTo(_likeMessageLab.mas_trailing).offset(10);
        make.trailing.equalTo(_segment_IsReceive);
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(150);
    }];
    
    //
    [_contantOrganizaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_likeMessageLab.mas_bottom).offset(30);
    }];
    
//    _segment_IsReceive.selectedSegmentIndex = 1;
//    _segment_Like.selectedSegmentIndex = 1;
    _segment_organizaAddress.selectedSegmentIndex = 0;
    _segment_OrganizationType.selectedSegmentIndex = 0;
//    isSelEmail = NO;
    isLike = NO;
    _receiveView.hidden = YES;
    organizaBusinessIV.hidden= YES;
    CorporationType = @"C"; //默认商业类型  "企业"
    _otherOrganizaNumber.hidden = YES;
    _otherMessage.hidden = YES;
    _organizaNumber.placeholder = HKLocalizedString(@"");
    _organizaAddress6.hidden = YES;
    
    [self getBusinessTypeArr];
    [self getAreaArr];
    
    [self.likeMessageLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_receiveMessageLab.mas_bottom).offset(20);
    }];
    [line3 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_organizaAddress4.mas_bottom).offset(20);
    }];
    [self.userName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_segment_OrganizationType.mas_bottom).offset(30);
    }];
    
    [line1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_organizaNumber.mas_bottom).offset(20+20);
    }];
    
    [self loadFBandWBdata];
    
    [self setUIString];
}

#pragma mark  Pop View
-(void)createBelongToPickerViewPopup{
    if (_pickerViewPopupBelongTo) {
        [_pickerViewPopupBelongTo removeFromSuperview];
    }
    _pickerViewPopupBelongTo = [[UIPickerView alloc] initWithFrame:CGRectMake(_belongToType.frame.origin.x, CGRectGetMaxY(_belongToType.frame),_belongToType.frame.size.width, 300)];
    _pickerViewPopupBelongTo.delegate = self;
    _pickerViewPopupBelongTo.showsSelectionIndicator = YES;
    _pickerViewPopupBelongTo.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _pickerViewPopupBelongTo.layer.borderWidth = 0.5f;
    
    _pickerViewPopupBelongTo.backgroundColor = [UIColor whiteColor];
    [_pickerViewPopupBelongTo selectRow:selectedBelongTo inComponent:0 animated:YES];
    [_contantPersonView addSubview:_pickerViewPopupBelongTo];
    [_pickerViewPopupBelongTo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_belongToType.mas_bottom);
        make.height.mas_equalTo(150);
        make.leading.equalTo(_belongToType);
        make.trailing.equalTo(_belongToType);
        
    }];
    
}
-(void)createBusinessTypePickerViewPopup{
    if (_pickerViewPopupBusinessType) {
        [_pickerViewPopupBusinessType removeFromSuperview];
    }
    _pickerViewPopupBusinessType = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_organizaNumber.frame),_organizaNumber.frame.size.width, 300)];
    _pickerViewPopupBusinessType.delegate = self;
    _pickerViewPopupBusinessType.showsSelectionIndicator = YES;
    _pickerViewPopupBusinessType.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _pickerViewPopupBusinessType.layer.borderWidth = 0.5f;
    
    _pickerViewPopupBusinessType.backgroundColor = [UIColor whiteColor];
    [_pickerViewPopupBusinessType selectRow:selectedBusinessType inComponent:0 animated:YES];
    [_contantOrganizaView addSubview:_pickerViewPopupBusinessType];
    [_pickerViewPopupBusinessType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_organizaNumber.mas_bottom);
        make.height.mas_equalTo(150);
        make.leading.equalTo(_organizaNumber);
        make.trailing.equalTo(_organizaNumber);
        
    }];
    
}
-(void)createAreaPickerViewPopup{
    if (_pickerViewPopupArea) {
        [_pickerViewPopupArea removeFromSuperview];
    }
    _pickerViewPopupArea = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_organizaAddress5.frame),_organizaAddress5.frame.size.width, 300)];
    _pickerViewPopupArea.delegate = self;
    _pickerViewPopupArea.showsSelectionIndicator = YES;
    _pickerViewPopupArea.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _pickerViewPopupArea.layer.borderWidth = 0.5f;
    
    _pickerViewPopupArea.backgroundColor = [UIColor whiteColor];
    [_pickerViewPopupArea selectRow:selectedArea inComponent:0 animated:YES];
    [_contantOrganizaView addSubview:_pickerViewPopupArea];
    [_pickerViewPopupArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_organizaAddress5.mas_bottom);
        make.height.mas_equalTo(150);
        make.leading.equalTo(_organizaAddress5);
        make.trailing.equalTo(_organizaAddress5);
        
    }];
    
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if (textField == _belongToType) {
        [self keyboardWillHide_register];
        [self createBelongToPickerViewPopup];
        return NO;
    }else if (textField == _organizaNumber) {
        if (_segment_OrganizationType.selectedSegmentIndex == 3) {//其他
            [self keyboardWillHide_register];
            [self createBusinessTypePickerViewPopup];
            return NO;
        }
        
    }else{
        [self removePopview];
    }
//    else if (textField == _organizaAddress5) {
//        
//        [self createAreaPickerViewPopup];
//        return NO;
//    }
    return YES;
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    
    if ([pickerView isEqual:_pickerViewPopupArea]) {
        
        selectedArea = row;
        if (AreaDesp) {
            _organizaAddress5.text = [AreaDesp objectAtIndex:row];
        }
        
        
        if ([_organizaAddress5.text length] < 1) {
            _organizaAddress5.text = @"";
        }
        _organizaAddress5.textColor = [UIColor blackColor];
        if (_pickerViewPopupArea) {
            [_pickerViewPopupArea removeFromSuperview];
        }
        
    }else if (pickerView == _pickerViewPopupBusinessType){
        
        selectedBusinessType = row;
        if (BusinessTypeDesp) {
            _organizaNumber.text = [NSString stringWithFormat:@"  %@",[BusinessTypeDesp objectAtIndex:row]];
        }
        
        if ([_organizaNumber.text length] < 1) {
            _organizaNumber.text = @"";
        }
        _organizaNumber.textColor = [UIColor blackColor];
        if (_pickerViewPopupBusinessType) {
            [_pickerViewPopupBusinessType removeFromSuperview];
        }
        
    }else if (pickerView == _pickerViewPopupBelongTo){
        selectedBelongTo = row;
        if (_belongDesp) {
            _belongToType.text = [NSString stringWithFormat:@"  %@",[_belongDesp objectAtIndex:row]];
        }
        
        if ([_belongToType.text length] < 1) {
            _belongToType.text = @"";
        }
        _belongToType.textColor = [UIColor blackColor];
        if (_pickerViewPopupBelongTo) {
            [_pickerViewPopupBelongTo removeFromSuperview];
        }
    }
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([pickerView isEqual:_pickerViewPopupArea]) {
        return [AreaDesp objectAtIndex:row];
        
    }else if (pickerView == _pickerViewPopupBusinessType){
        return [BusinessTypeDesp objectAtIndex:row];
        
    }else if (pickerView == _pickerViewPopupBelongTo){
        return [_belongDesp objectAtIndex:row];
    }
    return @"";
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    if ([thePickerView isEqual:_pickerViewPopupArea]) {
        return AreaDesp.count;
        
    }else if (thePickerView == _pickerViewPopupBusinessType){
        return BusinessTypeDesp.count;
        
    }else if (thePickerView == _pickerViewPopupBelongTo){
        return _belongDesp.count;
    }
    return 0;
    
}
#pragma mark - 点击更换头像
-(void)iconImageTapAction{
    
    UIActionSheet *photoBtnActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                                            cancelButtonTitle:nil
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:HKLocalizedString(@"从照片库选取") ,HKLocalizedString(@"拍摄新照片"),HKLocalizedString(@"取消"), nil];
    [photoBtnActionSheet setActionSheetStyle:UIActionSheetStyleDefault];
    //在0＊0区域显示这个Popover
    [photoBtnActionSheet showFromRect:CGRectMake(self.userImgeView.center.x, CGRectGetMaxY(self.userImgeView.frame), 0, 0) inView:self.contentView animated:YES];
    
}
#pragma mark - UIActionSheetDelegate
//  Attempt to present on which is already presenting 原因在警告里说得比较明白了，因为已经有actionsheet存在了，不能present新的。此时我们选择新的委托方法
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
                [popover presentPopoverFromRect:CGRectMake(self.userImgeView.center.x, CGRectGetMaxY(self.userImgeView.frame), 0, 0) inView:self.contentView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
                
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
                self.commitBtn.enabled = NO;
            }else {
                NSLog(@"Camera is not available.");
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Camera is not available.");
        }
    }
}
//点击cancel 调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"Image Picker Controller canceled.");
    self.commitBtn.enabled = YES;
    //Cancel以后将ImagePicker删除
    [self dismissViewControllerAnimated:NO completion:nil];
}
//点击相册中的图片 货照相机照完后点击use  后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"Image Picker Controller did finish picking media.");
    
    NSLog(@"UIImagePickerControllerMediaURL-------------%@",info[UIImagePickerControllerReferenceURL]);
    UIImage *image = [self fixOrientation:info[UIImagePickerControllerOriginalImage]];
    if (_personBtn.selected) {
        base64AvatarPerson = [UIImagePNGRepresentation([self imageWithImage:image convertToSize:CGSizeMake(128, 128)]) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }else{
        base64AvatarOrganiza = [UIImagePNGRepresentation([self imageWithImage:image convertToSize:CGSizeMake(128, 128)]) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    self.userImgeView.image = image;
    self.commitBtn.enabled = YES;
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}
#pragma mark - 图片旋转90校正
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

#pragma mark - receiveView button method
-(void)setReceiveViewBtnTitle{
    NSArray * emailViewTitleArray = @[HKLocalizedString(@"助学"),HKLocalizedString(@"安老"),HKLocalizedString(@"助医"),HKLocalizedString(@"扶贫"),HKLocalizedString(@"紧急援助"),HKLocalizedString(@"其他"),HKLocalizedString(@"意赠行动"),HKLocalizedString(@"全部")];
    for (UIButton*  receiveViewButton in _receiveBtns) {
        [receiveViewButton setTitle:emailViewTitleArray[receiveViewButton.tag] forState:UIControlStateNormal];
    }
}
- (IBAction)receiveViewButtonAction:(UIButton*)sender
{
    
    NSArray * DonationInterest = @[@"S",@"E",@"M",@"P",@"U",@"O",@"A",@"L"];
    if (sender) {
        if (sender.tag == 7) {
            if (sender.selected) {
                for (UIButton*  receiveViewButton in _receiveBtns) {
                    receiveViewButton.selected = NO;
                }
                for (NSString*  donationInterest in DonationInterest) {
                    [_receiveSelArr removeObject:donationInterest];
                }
            }else{
                for (UIButton*  receiveViewButton in _receiveBtns) {
                    receiveViewButton.selected = YES;
                }
                for (NSString*  donationInterest in DonationInterest) {
                    [_receiveSelArr addObject:donationInterest];
                }
            }
            
            
        }else{
            if (sender.selected) {
                sender.selected = NO;
                [_receiveSelArr removeObject:DonationInterest[sender.tag]];
            }else{
                sender.selected = YES;
                [_receiveSelArr addObject:DonationInterest[sender.tag]];
            }
        }
        
        
    }
}

#pragma mark - UISegmentedControl method
//先生、小姐
- (IBAction)contactPersonAction:(UISegmentedControl*)sender {
     [self keyboardWillHide_register];
    if (sender.selectedSegmentIndex == 0) {
        sexType = @"R";
    }else if (sender.selectedSegmentIndex == 1){
        sexType = @"S";
    }else{
        sexType = @"M";
    }
}

//是、否
- (IBAction)receiveMessageAction:(UISegmentedControl*)sender {
     [self keyboardWillHide_register];
    if (sender.selectedSegmentIndex == 0) {
        isSelEmail = YES;
        [self.likeMessageLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_receiveMessageLab.mas_bottom).offset(20+60);
        }];
        _receiveView.hidden = NO;
        _receiveSelArr = [[NSMutableArray alloc]init];
        
    }else{
        isSelEmail = NO;
        [self.likeMessageLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_receiveMessageLab.mas_bottom).offset(20);
        }];
        _receiveView.hidden = YES;
    }
}

//愿意、不愿意
- (IBAction)likeMessageAction:(UISegmentedControl*)sender {
     [self keyboardWillHide_register];
    if (sender.selectedSegmentIndex == 0) {
        isLike = YES;
        _likeView.hidden = NO;
    }else{
        isLike = NO;
        _likeView.hidden = YES;
    }
}

//是否香港
- (IBAction)organizationAddressAction:(UISegmentedControl*)sender {
     [self keyboardWillHide_register];
    _organizaAddress5.text = @"";
    if (sender.selectedSegmentIndex == 1) {//其他
        _organizaAddress6.hidden = NO;
        
        [line3 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_organizaAddress4.mas_bottom).offset(30+30+20);
        }];
        
        
    }else{
        _organizaAddress6.hidden = YES;
        [line3 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_organizaAddress4.mas_bottom).offset(20);
        }];
        
        
    }
}

//企业类型
- (IBAction)organizationTypeAction:(UISegmentedControl*)sender {
     [self keyboardWillHide_register];
    //    C - 企業  O - 社團組織  N - 非牟利組織  E - 其他
    NSArray* CorporationTypes = @[@"C",@"O",@"N",@"E"];
    CorporationType = CorporationTypes[sender.selectedSegmentIndex];
    
    if (sender.selectedSegmentIndex == 3) {//其他
        [self.userName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_segment_OrganizationType.mas_bottom).offset(30+30+30+10);
        }];
        [line1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_organizaNumber.mas_bottom).offset(20+(30+30));//otherOrganizaNumber
        }];
        _otherMessage.hidden = NO;
        _organizaNumber.text = HKLocalizedString(@"不适用");
        organizaBusinessIV.hidden = NO;
        _otherOrganizaNumber.hidden = NO;
        
    }else{
        [self.userName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_segment_OrganizationType.mas_bottom).offset(30);
        }];
        [line1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_organizaNumber.mas_bottom).offset(20+20);
        }];
        _otherMessage.hidden = YES;
        _otherOrganizaNumber.hidden = YES;
        organizaBusinessIV.hidden = YES;
        _organizaNumber.text = @"";
        _organizaNumber.placeholder = HKLocalizedString(@"商业登记号码");
    }
    if (sender.selectedSegmentIndex == 1) {
        _organizaNumber.placeholder = HKLocalizedString(@"香港社团注册证明书编号");
    }else if (sender.selectedSegmentIndex == 2) {
        _organizaNumber.placeholder = HKLocalizedString(@"税局档号");
    }
    _organizaNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_organizaNumber.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    
}


#pragma mark - 提交
- (IBAction)commitBtnAction:(UIButton*)sender {
    if (_personBtn.selected) {
        [self commitBtnActionPerson];
    }else if (_organizaBtn.selected){
        [self commitBtnActionOrganiza];
    }
    
}
#pragma mark - 个人
-(void)commitBtnActionPerson{
    
    NSString *msg = nil;
    
    //登录名 密码
    if ([self nameStrIsTruePerson]) {
        msg = [self nameStrIsTruePerson];
    }
    //姓名
    else if([self nameStrIsTrue]){
        msg = [self nameStrIsTrue];
    }
    //
    else if (self.email.text.length == 0){
        msg = HKLocalizedString(@"请输入[电邮地址]");
    }
    else if (![NSString isEmail:self.email.text]){
        msg = HKLocalizedString(@"[电邮地址]错误");
    }
    
    else if (self.belongToType.text.length == 0){
        msg = HKLocalizedString(@"请选择所属机构");
    }
    //
    else if (_segment_IsReceive.selectedSegmentIndex == -1){
        msg = HKLocalizedString(@"请选择 [你是否希望定期收到「意赠」的电邮资讯？]");
    }
    else if (_receiveSelArr.count==0 && isSelEmail){
        msg = HKLocalizedString(@"[请选取您喜欢的专案类别(可选择多项)]");
    }
//    else if (self.telCodeField.text.length == 0 && isLike){
//        msg = @"请输入电话区号";
//    }
    else if (self.telField.text.length == 0 && isLike){
        msg = HKLocalizedString(@"请输入[联络电话]");
    }
    else if (![EGVerifyTool isNumeric:self.telField.text] && isLike){
        msg = HKLocalizedString(@"[联络电话]只能輸入數字");
    }
    if(msg){
        [self showVCWithTitle:HKLocalizedString(@"输入错误") message:msg];
        return;
    }
    [self showVCWithTitle:HKLocalizedString(@"TitleLabel") message:nil];
}

- (void)PostIndividualUserInfo{
    
    EGUserModel * model = [[EGUserModel alloc] init];
    model.MemberType = @"P";
    model.Position = @"";
    model.TelNo = _telField.text;
    model.TelCountryCode = _telCodeField.text;
    model.LoginName = _userName.text;
    model.password = _passWord.text;
    model.BusinessRegistrationType=@"";
    model.BusinessRegistrationNo=@"";
    model.CorporationType=@"";
    model.CorporationType_Other=@"";
    model.ChiNameTitle = sexType;
    model.EngNameTitle = sexType;
    if ([sexType isEqualToString:@"R"]) {
        model.Sex = @"M";
    }else{
        model.Sex = @"F";
    }
    model.ChiLastName = _lastNameCh.text;
    model.ChiFirstName = _nameCh.text;
    model.EngLastName = _lastNameEn.text;
    model.EngFirstName = _nameEn.text;
    model.Email = [_email.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    model.AddressRoom = @"";
    model.AddressBldg = @"";
    model.AddressEstate = @"";
    model.AddressStreet = @"";
    model.AddressDistrict = @"";
    model.AddressCountry=@"香港";
    
    model.BelongTo = [_belongCd objectAtIndex:selectedBelongTo];
    if (isSelEmail) {
        model.AcceptEDM = YES;
        
    }else{
        model.AcceptEDM = NO;
    }
    if (isLike) {
        model.JoinVolunteer = YES;
        //            if (_shortVolunteer.selected) {
        //                model.VolunteerType = @"L";
        //            }else{
        model.VolunteerType = @"S";
        //            }
        model.VolunteerStartDate = @" ";//_dateStart.text;
        model.VolunteerEndDate = @" ";//_dateEnd.text;
        model.VolunteerInterest = @" ";
        model.AvailableTime = @" ";
        
    }else{
        model.JoinVolunteer = NO;
    }
    //选择专案类别
    NSMutableString * muStr = [[NSMutableString alloc] init];
    for (int i = 0; i < _receiveSelArr.count; i ++) {
        [muStr appendString:[NSString stringWithFormat:@",%@",_receiveSelArr[i]]];
    }
    if (_receiveSelArr.count > 0) {
        model.DonationInterest = muStr;
    }else{
        model.DonationInterest = @" ";
    }
    model.VolunteerType = @" ";
    model.VolunteerStartDate = @" ";
    model.VolunteerEndDate = @" ";
    model.VolunteerInterest_Other = @" ";
    model.AvailableTime_Other = @" ";
    NSString *deviceid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    model.AppToken = deviceid;
    [self SaveMemberInfo:model];
    
}
#pragma mark - 机构
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

-(void)commitBtnActionOrganiza{
    NSString *msg = nil;
    
    if (!self.otherMessage.hidden && self.otherMessage.text.length == 0) {
        msg =HKLocalizedString(@"请输入[其他，请注明]");
    }
    //登录名 密码
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
    else if (_organizaNumber.text.length == 0){
        msg =HKLocalizedString(@"请输入[商业登记号码/香港社团注册证明书编号/税局档号]");
    }
    else if ([self IsChinese:_organizaNumber.text] && _segment_OrganizationType.selectedSegmentIndex != 3){
        msg =HKLocalizedString(@"[商业登记号码/香港社团注册证明书编号/税局档号] 错误");
    }
    
    else if (![_organizaNumber.text isEqualToString:HKLocalizedString(@"不适用")] && _otherOrganizaNumber.hidden == NO && _otherOrganizaNumber.text.length == 0){
        msg =HKLocalizedString(@"请输入[商业登记号码/香港社团注册证明书编号/税局档号]");
        
    }
    else if (_otherOrganizaNumber.text.length >0 && [self IsChinese:_otherOrganizaNumber.text]){
        msg =HKLocalizedString(@"[商业登记号码/香港社团注册证明书编号/税局档号] 错误");
    }
    //姓名
    else if([self nameStrIsTrue]){
        msg = [self nameStrIsTrue];
    }
    //
    else if (self.position.text.length == 0){
        msg = HKLocalizedString(@"请输入[职位]");
    }
    else if (self.email.text.length == 0){
        msg = HKLocalizedString(@"请输入[电邮地址]");
    }
    else if (![NSString isEmail:self.email.text]){
        msg = HKLocalizedString(@"[电邮地址]错误");
    }
//    else if (self.telCodeField.text.length == 0){
//        msg = @"请输入电话区号";
//    }
    else if (self.telField.text.length == 0){
        msg = HKLocalizedString(@"请输入[联络电话]");
    }
    else if (![EGVerifyTool isNumeric:self.telField.text]){
        msg = HKLocalizedString(@"[联络电话]只能輸入數字");
    }
    //"请输入[机构地址]"
    else if (self.organizaAddress1.text.length == 0 && self.organizaAddress2.text.length == 0 && self.organizaAddress3.text.length == 0 && self.organizaAddress4.text.length == 0 &&  self.organizaAddress5.text.length == 0){
        msg  = HKLocalizedString(@"请输入[机构地址]");
    }
    else if (_segment_organizaAddress.selectedSegmentIndex == 1 && _organizaAddress6.text.length == 0){
        msg =HKLocalizedString(@"请输入[其他，请注明]");
    }
    //
    else if (_segment_IsReceive.selectedSegmentIndex == -1){
        msg = HKLocalizedString(@"请选择 [你是否希望定期收到「意赠」的电邮资讯？]");
    }
    else if (_receiveSelArr.count==0 && isSelEmail){
        msg = HKLocalizedString(@"[请选取您喜欢的专案类别(可选择多项)]");
    }
    
    if(msg){
        [self showVCWithTitle:HKLocalizedString(@"输入错误") message:msg];
        return;
    }
    [self showVCWithTitle:HKLocalizedString(@"TitleLabel") message:nil];
    
    
}

- (void)PostOrganizationUserInfo {
    
    EGUserModel * model = [[EGUserModel alloc] init];
    model.MemberType = @"C";
    model.CorporationType = CorporationType;
    if ([model.CorporationType isEqualToString:@"E"])
    {
        model.CorporationType_Other = _otherMessage.text;
    } else {
        model.CorporationType_Other = @"";
    }
    model.CorporationChiName = _organizaNameCh.text;
    model.CorporationEngName = _organizaNameEn.text;
    // B - 商業登記號碼 T - 稅局檔號  C - 香港社團註冊證明書編號
    // ** must be “T” when CoporationType = “N”
    // ** must be “C” when CorporationType = “O”
    if (![model.CorporationType isEqualToString:@"E"])//不是其他
    {
        if ([model.CorporationType isEqualToString:@"N"]) {
            model.BusinessRegistrationType = @"T";
        }else if ([model.CorporationType isEqualToString:@"O"]) {
            model.BusinessRegistrationType = @"C";
        }else{
            model.BusinessRegistrationType = @"B";
        }
    }else{
        model.BusinessRegistrationType = [NSString stringWithFormat:@"%@",[BusinessTypeCd objectAtIndex:selectedBelongTo]];
    }
    if ([model.CorporationType isEqualToString:@"E"])//其他
    {
        model.BusinessRegistrationNo = _otherOrganizaNumber.text;
        
    }else{
        model.BusinessRegistrationNo = _organizaNumber.text;
    }
    
    model.Position = _position.text;
    model.TelNo = _telField.text;
    model.TelCountryCode = _telCodeField.text;
    model.LoginName = _userName.text;
    model.password = _passWord.text;
    model.ChiNameTitle = sexType;
    model.EngNameTitle = sexType;
    if ([sexType isEqualToString:@"R"]) {
        model.Sex = @"M";
    }else{
        model.Sex = @"F";
    }
    model.ChiLastName = _lastNameCh.text;
    model.ChiFirstName = _nameCh.text;
    model.EngLastName = _lastNameEn.text;
    model.EngFirstName = _nameEn.text;
    model.Email = [_email.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    UIButton * button;
    if (button.selected){
        model.AddressCountry = _organizaAddress6.text;
        
    }else{
        model.AddressCountry = @"香港";
        
    }
    model.AddressRoom = _organizaAddress1.text;
    model.AddressBldg = _organizaAddress2.text;
    model.AddressEstate = _organizaAddress3.text;
    model.AddressStreet = _organizaAddress4.text;
    model.AddressDistrict = _organizaAddress5.text;
    model.BelongTo = @"Other";
    if (isSelEmail) {
        model.AcceptEDM = YES;
    }else{
        model.AcceptEDM = NO;
    }
    
    if (isLike) {
        model.JoinVolunteer = YES;
        //            if (_shortVolunteer.selected) {
        //                model.VolunteerType = @"L";
        //            }else{
        model.VolunteerType = @"S";
        //            }
        model.VolunteerStartDate = @" ";//_dateStart.text;
        model.VolunteerEndDate = @" ";//_dateEnd.text;
        model.VolunteerInterest = @" ";
        model.AvailableTime = @" ";
        
    }else{
        model.JoinVolunteer = NO;
    }
    //选择专案类别
    NSMutableString * muStr = [[NSMutableString alloc] init];
    for (int i = 0; i < _receiveSelArr.count; i ++) {
        [muStr appendString:[NSString stringWithFormat:@",%@",_receiveSelArr[i]]];
    }
    if (_receiveSelArr.count > 0) {
        model.DonationInterest = muStr;
    }else{
        model.DonationInterest = @" ";
    }
    
    model.VolunteerType = @" ";
    model.VolunteerStartDate = @" ";
    model.VolunteerEndDate = @" ";
    model.VolunteerInterest = @" ";
    model.VolunteerInterest_Other = @" ";
    model.AvailableTime = @" ";
    model.AvailableTime_Other = @" ";
    NSString *deviceid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    model.AppToken = deviceid;
    [self SaveMemberInfo:model];
    
}

#pragma mark - 发送注册信息
- (void)SaveMemberInfo:(EGUserModel *)model{
    
    [SVProgressHUD show];
    
    NSString *fbID = @"";
    NSString *wbID = @"";
    if (isThrRegister) {
        fbID = _fbdata != nil ? [_fbdata objectForKey:@"id"] : @"";
        wbID = _wbdata != nil ? [_wbdata objectForKey:@"usid"] : @"";
    }
    if (_personBtn.selected) {
        base64Avatar =  base64AvatarPerson;
    }else{
       base64Avatar =  base64AvatarOrganiza;
    }
    if ([base64Avatar isEqualToString:@""] || base64Avatar == nil) {
        if (self.userImgeView.image != nil) {
            base64Avatar = [UIImagePNGRepresentation([self imageWithImage:self.userImgeView.image convertToSize:CGSizeMake(128, 128)]) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        }
    }
    model.password =  isThrRegister ? @"" : model.password;
    model.weiboID = wbID;
    model.faceBookID = fbID;
    model.base64Avatar = base64Avatar;
    
    [EGUserModel commitMemberInfoDataWithModel:model block:^(NSString *result, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            NSDictionary * dict = [NSString parseJSONStringToNSDictionary:result];
            NSString *_registerResult  = [NSString jSONStringToNSDictionary:result];
            
            if (dict != nil) {
                NSString* showMessage = HKLocalizedString(@"注册成功!请点击确定按钮返回登入页面!");
                NSString* MessageBtnTitle = HKLocalizedString(@"Common_button_confirm");
                [self showMessageVCWithTitle:HKLocalizedString(@"提示") type:@"message_registerSuccess"  message:showMessage messageButton:MessageBtnTitle];
                
            }else{
                NSString* message = _registerResult;
                if ([_registerResult isEqualToString:@"\"Error(5005)\""]) {
                    message = HKLocalizedString(@"电邮已被注册").length>0?HKLocalizedString(@"电邮已被注册"):_registerResult;
                    
                }else if ([_registerResult isEqualToString:@"\"Error(5003)\""]){
                    message = HKLocalizedString(@"此账号已被注册").length>0?HKLocalizedString(@"此账号已被注册"):_registerResult;
                    
                }
                [self showVCWithTitle:HKLocalizedString(@"提示") message:message];
            }
            
        }else{
            [self showVCWithTitle:[NSString stringWithFormat:@"error %@",HKLocalizedString(@"提示")] message:[error.userInfo objectForKey:@"NSLocalizedDescription"]?[error.userInfo objectForKey:@"NSLocalizedDescription"]:@"unknown error"];
        }
    }];
    
}


#pragma mark - EGRegisterAlertViewController
-(void)showVCWithTitle:(NSString*)title message:(NSString*)message
{
    if (message){//是不是message
        CZPickerView *pv = [[CZPickerView alloc] initWithHeaderTitle:title cancelButtonTitle:nil confirmButtonTitle:nil];
        pv.headerBackgroundColor = [UIColor colorWithHexString:@"#F4F5F6"];
        pv.headerTitleColor = [UIColor colorWithHexString:@"#673291"];
        pv.showCloseButton = YES;
        [pv setContent:message];
        [pv show];
        return;
    }
    
    EGAgreeStatementViewController* root = [[EGAgreeStatementViewController alloc]init];
    root.title = title;
    __weak __typeof(self)weakself = self;
    [root setAgreeStatement:^(EGAgreeStatementViewController *vc) {
        //同意声明
        [vc dismissViewControllerAnimated:YES completion:^{
            if (weakself.personBtn.selected) {
                [weakself PostIndividualUserInfo];

            }else if (weakself.organizaBtn.selected){
                [weakself PostOrganizationUserInfo];
            }
        }];
        
    }];
    [self presentViewController:root animated:YES completion:nil];

}
-(void)showMessageVCWithTitle:(NSString*)title type:(NSString*)type message:(NSString*)message messageButton:(NSString*)btnTitle
{
    if ([type isEqualToString:@"message_registerSuccess"]) {
        CZPickerView *pv = [[CZPickerView alloc] initWithHeaderTitle:title singleButtonTitle:btnTitle singleTapAction:^{
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:self.userName.text forKey:@"loginName_registerBack"];
            if (isWeibo) {
                [def setObject:@"weibo" forKey:@"loginType_registerBack"];
            }else if (isFaceBook){
                [def setObject:@"facebook" forKey:@"loginType_registerBack"];
            }else{
                [def setObject:@"normal" forKey:@"loginType_registerBack"];
            }
            [def synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"popRegisterVC_kevin" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        pv.headerBackgroundColor = [UIColor colorWithHexString:@"#F4F5F6"];
        pv.headerTitleColor = [UIColor colorWithHexString:@"#673291"];
        pv.cancelButtonBackgroundColor = [UIColor colorWithHexString:@"#5CAF21"];
        pv.cancelButtonNormalColor = [UIColor whiteColor];
        pv.showCloseButton = NO;
        pv.needFooterView = YES;
        [pv setContent:message];
        [pv show];
        return;
    }
    if ([type rangeOfString:@"message"].location != NSNotFound && message) {//是不是message
        CZPickerView *pv = [[CZPickerView alloc] initWithHeaderTitle:title cancelButtonTitle:nil confirmButtonTitle:nil];
        pv.headerBackgroundColor = [UIColor colorWithHexString:@"#F4F5F6"];
        pv.headerTitleColor = [UIColor colorWithHexString:@"#673291"];
        pv.showCloseButton = YES;
        [pv setContent:message];
        [pv show];
        return;
    }

}

#pragma mark - 改变语言
-(void)setUIString{
    
    [_personBtn setTitle:HKLocalizedString(@"Register_personalButton_title") forState:UIControlStateNormal];
    [_organizaBtn setTitle:HKLocalizedString(@"Register_organizationButton_title") forState:UIControlStateNormal];
    
    _userName.placeholder = HKLocalizedString(@"Register_userNameTextfile_pla");
    _passWord.placeholder = HKLocalizedString(@"Register_mpwsTextfile");
    _confirmPW.placeholder = HKLocalizedString(@"Register_comfirmpwsTextfile");//确认密码
    _pwMessageLab.text = HKLocalizedString(@"Register_noteLabel_title");
    
    //person 信息
    _lastNameCh.placeholder = HKLocalizedString(@"Register_lastNameCh");
    _nameCh.placeholder = HKLocalizedString(@"Register_nameCh");
    _lastNameEn.placeholder = HKLocalizedString(@"Register_lastNameEn");
    _nameEn.placeholder = HKLocalizedString(@"Register_nameEh");
    
    [_segment_M setTitle:HKLocalizedString(@"Register_sexMrButton_title") forSegmentAtIndex:0];
    [_segment_M setTitle:HKLocalizedString(@"Register_sexMrsButton_title") forSegmentAtIndex:1];
    [_segment_M setTitle:HKLocalizedString(@"Register_sexMrssButton_title") forSegmentAtIndex:2];
    
    _email.placeholder = HKLocalizedString(@"Register_email");
    _emailMessageLab.text = HKLocalizedString(@"Register_org_noteLabel1_title");
    
    _belongToType.placeholder = HKLocalizedString(@"Register_belongto");
    _receiveMessageLab.text = HKLocalizedString(@"Register_IsEmailNote");//收资讯
    //是、否
    [_segment_IsReceive setTitle:HKLocalizedString(@"Register_isEmailButton_title") forSegmentAtIndex:0];
    [_segment_IsReceive setTitle:HKLocalizedString(@"Register_noEmailButton_title") forSegmentAtIndex:1];
    _receiveViewMessageLab.text = HKLocalizedString(@"请选取你喜欢的专案类别(可选择多项):");
    
    _likeMessageLab.text = HKLocalizedString(@"Register_org_noteLabel3_title");//成为义工
    //愿意、不愿意
    [_segment_Like setTitle:HKLocalizedString(@"Register_yButton_title") forSegmentAtIndex:0];
    [_segment_Like setTitle:HKLocalizedString(@"Register_nButton_title") forSegmentAtIndex:1];
    
    
    [_commitBtn setTitle:HKLocalizedString(@"Register_commitButton_title") forState:UIControlStateNormal];
    _telCodeField.text = @"852";
    _telCodeField.placeholder = @"852";
    _telField.placeholder = HKLocalizedString(@"Register_org_number");
    //
    [_segment_OrganizationType setTitle:HKLocalizedString(@"Register_org_Button1_title") forSegmentAtIndex:0];
    [_segment_OrganizationType setTitle:HKLocalizedString(@"Register_org_Button2_title") forSegmentAtIndex:1];
    [_segment_OrganizationType setTitle:HKLocalizedString(@"Register_org_Button3_title") forSegmentAtIndex:2];
    [_segment_OrganizationType setTitle:HKLocalizedString(@"Register_org_Button4_title") forSegmentAtIndex:3];
    
    _otherMessage.placeholder = HKLocalizedString(@"请说明");
    //机构信息
    _organizaNameCh.placeholder = HKLocalizedString(@"Register_org_orgNameCh_textFile");
    _organizaNameEn.placeholder = HKLocalizedString(@"Register_org_orgNameEn_textFile");
    
    _organizaNumber.placeholder = HKLocalizedString(@"商业登记号码");//商业登记号
    _otherOrganizaNumber.placeholder = HKLocalizedString(@"请说明");
    
    _organizaNumberLabel.text = HKLocalizedString(@"非牟利机构需填写税局档号；社团组织需填写香港社团注册证明书编号");
    
    _contactPersonLabel.text = HKLocalizedString(@"联络人姓名");
    _position.placeholder = HKLocalizedString(@"Register_org_position_textFile");//职位
    //机构地址
    _organizaAddressLab.text = HKLocalizedString(@"Register_org_address");
    CGRect frame = [_organizaAddressLab.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    [_organizaAddressLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(frame.size.width+5);
    }];
    _organizaAddressMsgLab.text = HKLocalizedString(@"Register_org_noteLabel2_title");
    
    _organizaAddress1.placeholder = HKLocalizedString(@"Register_org_region1");//室
    _organizaAddress2.placeholder = HKLocalizedString(@"Register_org_region2");//大楼
    _organizaAddress3.placeholder = HKLocalizedString(@"Register_org_region3");//屋宛
    _organizaAddress4.placeholder = HKLocalizedString(@"Register_org_region4");//门牌
    _organizaAddress5.placeholder = HKLocalizedString(@"Register_org_selRegion");//地区
    _organizaAddress6.placeholder = HKLocalizedString(@"请说明");
    //是否香港
    [_segment_organizaAddress setTitle:HKLocalizedString(@"Register_org_regionButton") forSegmentAtIndex:0];
    [_segment_organizaAddress setTitle:HKLocalizedString(@"Register_org_otherButton") forSegmentAtIndex:1];
    
    [self createReceiveBtns];
    [self passwordShow];
    [self setReceiveViewBtnTitle];
    [self setTextFieldPlaceholderColor];
}

-(void)setTextFieldPlaceholderColor{
    NSDictionary* attDic = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#7d7d7d"]};//颜色
    [self setAttributedPlaceholder:_userName attDic:attDic];
    [self setAttributedPlaceholder:_passWord attDic:attDic];
    [self setAttributedPlaceholder:_confirmPW attDic:attDic];
    
    [self setAttributedPlaceholder:_lastNameCh attDic:attDic];
    [self setAttributedPlaceholder:_nameCh attDic:attDic];
    [self setAttributedPlaceholder:_lastNameEn attDic:attDic];
    [self setAttributedPlaceholder:_nameEn attDic:attDic];
    
    [self setAttributedPlaceholder:_email attDic:attDic];
    [self setAttributedPlaceholder:_telCodeField attDic:attDic];
    [self setAttributedPlaceholder:_telField attDic:attDic];
    [self setAttributedPlaceholder:_otherMessage attDic:attDic];
    
    [self setAttributedPlaceholder:_belongToType attDic:attDic];
    [self setAttributedPlaceholder:_position attDic:attDic];
    [self setAttributedPlaceholder:_organizaNameCh attDic:attDic];
    [self setAttributedPlaceholder:_organizaNameEn attDic:attDic];
    [self setAttributedPlaceholder:_organizaNumber attDic:attDic];
    [self setAttributedPlaceholder:_otherOrganizaNumber attDic:attDic];
    
    [self setAttributedPlaceholder:_organizaAddress1 attDic:attDic];
    [self setAttributedPlaceholder:_organizaAddress2 attDic:attDic];
    [self setAttributedPlaceholder:_organizaAddress3 attDic:attDic];
    [self setAttributedPlaceholder:_organizaAddress4 attDic:attDic];
    [self setAttributedPlaceholder:_organizaAddress5 attDic:attDic];
    [self setAttributedPlaceholder:_organizaAddress6 attDic:attDic];
    
}
-(void)setAttributedPlaceholder:(UITextField*)textField attDic:(NSDictionary*)attDic{
    if (textField) {
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:attDic];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
