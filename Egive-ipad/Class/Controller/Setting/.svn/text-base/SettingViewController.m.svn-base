//
//  SettingViewController.m
//  Egive
//
//  Created by sino on 15/7/30.
//  Copyright (c) 2015年 sino. All rights reserved.
//

#import "SettingViewController.h"
#import "MessageViewController.h"
#import "CommonProblemsViewController.h"
#import "ConditionClauseViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "Language.h"
#import "EGUserModel.h"

#define ScreenSize self.size
@interface SettingViewController ()<MFMailComposeViewControllerDelegate> {
    BOOL isSelectU;
    
    UILabel * phoneLabel;
    UILabel * faxLabel;
    UILabel * emailLabel;
    UILabel * timeLabel;
    UILabel * timeLabel1;
    UILabel * timeLabel2;
    UILabel * timeLabel3;
    CGFloat  widthForCall;
    CGFloat  segmentedY ;
    UIImageView * contactLabelBg;
    UIImageView * promptLabelBg;
    UIImageView * errorLabelBg;
    UIImageView * stipulationLabelBg;
  
}
@property (strong, nonatomic) UILabel * cartLabel;
@property (nonatomic, weak)UILabel * contactLabel;
@property (nonatomic, weak)UILabel * prompt;
@property (nonatomic, weak)UILabel * errorLabel;
@property (nonatomic, weak)UILabel * stipulation;
@property (nonatomic, weak)UILabel * version;

@property (nonatomic, weak)UIView * contactView;


@property (nonatomic, retain)UISegmentedControl * segmentedControl;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    isSelectU = NO;
    widthForCall = 60;
    segmentedY = 20;
    
    [self createTableView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.title = @"";
    [self updateLocalizedString];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    _cartLabel.hidden = YES;
}



//添加图片视图
-(void )addImageViewWithFrame:(CGRect)frame
                                image:(NSString *)imageName :(UIView*)view
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.frame];
//    imageView.image = [UIImage imageNamed:image];
    UIImage* image = [UIImage imageNamed:imageName];
    CGFloat top = 5; // 顶端盖高度
    CGFloat bottom = 5 ; // 底端盖高度
    CGFloat left = 5; // 左端盖宽度
    CGFloat right = 22; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    imageView.image = image;
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    if (view == _contactLabel) {
        contactLabelBg =imageView;
    }else if (view == _prompt) {
        promptLabelBg =imageView;
    }else if (view == _errorLabel) {
        errorLabelBg =imageView;
    }else if (view == _stipulation) {
        stipulationLabelBg =imageView;
    }
}

//添加标签
-(UILabel *)addLabelWithFrame:(CGRect)frame
                         text:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    [self.view addSubview:label];
    return label;
}

//添加标签by view
-(UILabel *)addLabelWithFrame:(CGRect)frame
                         text:(NSString *)text :(UIView*)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    [view addSubview:label];
    return label;
}

- (void)createTableView{
    
    NSArray * languageArray = @[@"Eng",@"繁",@"简"];
    _segmentedControl= [[UISegmentedControl alloc]initWithItems:languageArray];
    _segmentedControl.frame = CGRectMake(20, 0+segmentedY, ScreenSize.width-40, 26);
    _segmentedControl.tintColor = [UIColor colorWithHexString:@"#5CAF21"];
    if ([Language getLanguage] == 3) {
        _segmentedControl.selectedSegmentIndex  = 0;
    }else if ([Language getLanguage] == 1)
    {
        _segmentedControl.selectedSegmentIndex  = 1;
    }else if ([Language getLanguage] == 2){
        _segmentedControl.selectedSegmentIndex = 2;
    }

    [_segmentedControl  addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];  //添加委托方法
    [self.view addSubview:_segmentedControl];
    
    UILabel * contactLabel = [self addLabelWithFrame:CGRectMake(20, 60+segmentedY, ScreenSize.width-40, 30) text:nil];
    contactLabel.userInteractionEnabled = YES;
    contactLabel.font = [UIFont systemFontOfSize:15];
    contactLabel.textColor = [UIColor colorWithRed:110/255.0 green:49/255.0 blue:139/255.0 alpha:1];

    _contactLabel  = contactLabel;
    [self addImageViewWithFrame:CGRectMake(0, 0, contactLabel.frame.size.width, contactLabel.frame.size.height) image:@"setting_detail_arrow" :_contactLabel];

    UITapGestureRecognizer * callTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callTapAction)];
    [contactLabel addGestureRecognizer:callTap];
    
    //
    
    UILabel * prompt = [self addLabelWithFrame:CGRectMake(20, 110+segmentedY, ScreenSize.width-40, 30) text:nil];
    prompt.userInteractionEnabled = YES;
    prompt.font = [UIFont systemFontOfSize:15];
    prompt.textColor = [UIColor colorWithRed:110/255.0 green:49/255.0 blue:139/255.0 alpha:1];
    
    _prompt = prompt;

    UITapGestureRecognizer * proTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(proTapAction)];
    [prompt addGestureRecognizer:proTap];
    
    [self addImageViewWithFrame:CGRectMake(0, 0, prompt.frame.size.width, prompt.frame.size.height) image:@"setting_detail_arrow" :_prompt];
    
    UILabel * errorLabel = [self addLabelWithFrame:CGRectMake(20, 160+segmentedY, ScreenSize.width-40, 30) text:nil];
    errorLabel.userInteractionEnabled = YES;
    errorLabel.font = [UIFont systemFontOfSize:15];
    errorLabel.textColor = [UIColor colorWithRed:110/255.0 green:49/255.0 blue:139/255.0 alpha:1];
   
    _errorLabel = errorLabel;
    
    UITapGestureRecognizer * problemTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(problemTapAction)];
    [errorLabel addGestureRecognizer:problemTap];
    
    [self addImageViewWithFrame:CGRectMake(0, 0, errorLabel.frame.size.width, errorLabel.frame.size.height) image:@"setting_detail_arrow" :_errorLabel];
    
    
    UILabel * stipulation = [self addLabelWithFrame:CGRectMake(20, 210+segmentedY, ScreenSize.width-40, 30) text:nil];
    stipulation.userInteractionEnabled = YES;
    stipulation.font = [UIFont systemFontOfSize:15];
    stipulation.textColor = [UIColor colorWithRed:110/255.0 green:49/255.0 blue:139/255.0 alpha:1];
    
    _stipulation = stipulation;
    
    UITapGestureRecognizer * stiTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stiTapAction)];
    [stipulation addGestureRecognizer:stiTap];

    
    [self addImageViewWithFrame:CGRectMake(0, 0, stipulation.frame.size.width, stipulation.frame.size.height) image:@"setting_detail_arrow" :_stipulation];
    
    UILabel * versions = [self addLabelWithFrame:CGRectMake(20, 255+segmentedY, 150, 25) text:@"版本 1.1"];
    versions.font = [UIFont systemFontOfSize:16];
    versions.textColor = [UIColor grayColor];
    _version = versions;
    
    UIView * contactView =[[UIView alloc]initWithFrame:CGRectMake(20, 60+30+segmentedY, ScreenSize.width-40, ScreenSize.height - segmentedY-280)];
    _contactView  = contactView;
    _contactView.hidden = YES;
    [self.view addSubview:_contactView];
    [self createContactView];
}


-(void)createContactView{
    
    CGFloat height = _contactView.frame.size.height/7;
    CGFloat width = _contactView.frame.size.width;
    
    phoneLabel = [self addLabelWithFrame:CGRectMake(0,5, widthForCall, height) text:nil :_contactView];
    phoneLabel.font = [UIFont systemFontOfSize:14];
    phoneLabel.textColor = [UIColor grayColor];
    
    UILabel * phone = [self addLabelWithFrame:CGRectMake(0+widthForCall, 5, width-widthForCall, height) text:@"(852) 2210 2600"  :_contactView];
    phone.font = [UIFont systemFontOfSize:15];
//    //☎️按钮
//    [self addImageButtonWithFrame:CGRectMake(135, 40, 23, 23) title:nil backgroud:@"setting_phone@2x.png" action:^(UIButton *button) {
//        
//        NSString *allString = [NSString stringWithFormat:@"tel:85222102600"];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
//        
//    }];
    
    faxLabel = [self  addLabelWithFrame:CGRectMake(0,5+height, widthForCall, height) text:nil :_contactView];
    faxLabel.font = [UIFont systemFontOfSize:14];
    faxLabel.textColor = [UIColor grayColor];
    
    UILabel * fax = [self  addLabelWithFrame:CGRectMake(0+widthForCall, 5+height, width-widthForCall, height) text:@"(852) 2210 2676" :_contactView];
    fax.font = [UIFont systemFontOfSize:15];
    
    emailLabel = [self  addLabelWithFrame:CGRectMake(0,5+height*2, width, height) text:nil :_contactView];
    emailLabel.font = [UIFont systemFontOfSize:14];
    emailLabel.textColor = [UIColor grayColor];
    
    
    CGRect frame = [@"info@egive4u.org" boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    
    UILabel * email = [self  addLabelWithFrame:CGRectMake(0+widthForCall, 5+height*2, frame.size.width+10, height) text:@"info@egive4u.org" :_contactView];
    email.font = [UIFont systemFontOfSize:15];
    email.textColor = [UIColor colorWithHexString:@"#602288"];
    email.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [email addGestureRecognizer:tap];
    
//    contact_email
    
    UIImageView* iv= [[UIImageView alloc]initWithFrame:CGRectMake(0+widthForCall+15+frame.size.width, 5+height*2+height/2-22/2, 22, 22)];
    iv.image = [UIImage imageNamed:@"contact_email"];
    [_contactView addSubview:iv];
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [iv addGestureRecognizer:tap1];
    
//    //📧按钮
//    [self  addImageButtonWithFrame:CGRectMake(150, 90, 23, 23) title:nil backgroud:@"setting_mail@2x.png" action:^(UIButton *button) {
//        
////        [weakSelf displayMailPicker];
//        
//    }];
    
    timeLabel = [self  addLabelWithFrame:CGRectMake(0,5+height*3, width, height) text:nil :_contactView];
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textColor = [UIColor grayColor];
    
    timeLabel1 = [self  addLabelWithFrame:CGRectMake(0,5+height*4, width, height) text:nil :_contactView];
    timeLabel1.font = [UIFont systemFontOfSize:15];
    
    timeLabel2 = [self  addLabelWithFrame:CGRectMake(0,5+height*5, width, height) text:nil :_contactView];
    timeLabel2.font = [UIFont systemFontOfSize:15];
    
    timeLabel3 = [self  addLabelWithFrame:CGRectMake(0,5+height*6, width, height) text:nil :_contactView];
    timeLabel3.numberOfLines = 2;
    timeLabel3.font = [UIFont systemFontOfSize:15];
    
}

-(void)tapAction
{
    [self displayMailPicker];
}
//调出邮件发送窗口
- (void)displayMailPicker
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    
    if (!mailPicker) {
        // 在设备还没有添加邮件账户的时候mailViewController为空，下面的present view controller会导致程序崩溃，这里要作出判断
        
        NSLog(@"设备还没有添加邮件账户");
        return;
    }
    
    mailPicker.mailComposeDelegate = self;
    //    MyLog(EGLocalizedString(@"email_heading", nil));
    //设置主题
    [mailPicker setSubject: HKLocalizedString(@"email_heading")];// EGLocalizedString(@"email_heading", nil)];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject:@"info@egive4u.org"];
    
    [mailPicker setToRecipients: toRecipients];
    
    // 添加一张图片
    UIImage *addPic = [UIImage imageNamed:@"Icon"];
    NSData *imageData = UIImagePNGRepresentation(addPic);            // png
    //关于mimeType：http://www.iana.org/assignments/media-types/index.html
    [mailPicker addAttachmentData: imageData mimeType: @"" fileName: @"Icon.png"];
    
    NSString * emailBody = @"";
    if ([Language getLanguage]==1) {
        NSString * str =@"姓名:\n電話:\n查詢內容:\n\n\n我們將盡快處理閣下的查詢！\n\n意贈慈善基金\nEgive For You Charity Foundation\n電話: (852) 2210 2600\n電郵: info@egive4u.org";
        emailBody = str;
        
    }else if ([Language getLanguage]==2){
        NSString *str = @"姓名:\n电话:\n查询内容:\n\n\n我们将尽快处理阁下的查询！\n\n意赠慈善基金\nEgive For You Charity Foundation\n电話: (852) 2210 2600\n电邮: info@egive4u.org";
        emailBody = str;
    }else{
        
        NSString * str = [NSString stringWithFormat:@"Name:\nDaytime Contact No.:\nThe Enquiry:\n\nThank you for your enquiry and we will get back to you soonest!\n\nEgive For You Charity Foundation\nTel: (852) 2210 2600\nEmail: info@egive4u.org"];
        emailBody = str;
    }
    [mailPicker setMessageBody:emailBody isHTML:NO];
   
    [self presentViewController:mailPicker animated:YES completion:nil];
    
}

- (void)callTapAction {
    isSelectU = !isSelectU;
    [self updateTableView];
}
-(void)updateTableView{
    int height = _contactView.bounds.size.height+segmentedY;
    if (!isSelectU) {
        _contactView.hidden = YES;
        contactLabelBg.hidden = NO;
        _contactLabel.frame = CGRectMake(20, 60+segmentedY, ScreenSize.width-40, 30);
        _contactLabel.font = [UIFont systemFontOfSize:15];
        _contactLabel.textColor = [UIColor colorWithRed:110/255.0 green:49/255.0 blue:139/255.0 alpha:1];
        
        _prompt.frame = CGRectMake(20, 110+segmentedY, ScreenSize.width-40, 30);
        _errorLabel.frame = CGRectMake(20, 160+segmentedY, ScreenSize.width-40, 30);
        _stipulation.frame = CGRectMake(20, 210+segmentedY, ScreenSize.width-40, 30);
        _version.frame = CGRectMake(20, 255+segmentedY, 150, 25);
        
        [self updateFrame:segmentedY];
        
    }else{
        _contactView.hidden = NO;
        contactLabelBg.hidden = YES;
        _contactLabel.frame = CGRectMake(13, 60+segmentedY, ScreenSize.width-40, 30);
        _contactLabel.font = [UIFont boldSystemFontOfSize:16];
        _contactLabel.textColor = [UIColor grayColor];
        
        [self updateFrame:height];
    }
}
-(void)updateFrame:(CGFloat)height{
    _prompt.frame = CGRectMake(20, 110+height, ScreenSize.width-40, 30);
    _errorLabel.frame = CGRectMake(20, 160+height, ScreenSize.width-40, 30);
    _stipulation.frame = CGRectMake(20, 210+height, ScreenSize.width-40, 30);
    _version.frame = CGRectMake(20, 255+height, 150, 25);
    
    promptLabelBg.frame = _prompt.frame;
    errorLabelBg.frame = _errorLabel.frame;
    stipulationLabelBg.frame =  _stipulation.frame;
    
}

- (void)proTapAction {

    MessageViewController * vc = [[MessageViewController alloc] init];
    vc.size = self.size;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)problemTapAction{
    
    CommonProblemsViewController * vc = [[CommonProblemsViewController alloc] init];
    vc.size = self.size;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)stiTapAction {
    
    ConditionClauseViewController * vc = [[ConditionClauseViewController alloc] init];
    vc.size = self.size;
    [self.navigationController pushViewController:vc animated:YES];
    
}

//具体委托方法实例
-(void)segmentAction:(UISegmentedControl *)Seg{
//    HK = 1,
//    CN = 2,
//    EN = 3
    LanguageKey lang = 0;
    if (Seg.selectedSegmentIndex == 0) {
        lang = 3;
    }else if (Seg.selectedSegmentIndex == 1)
    {
        lang = 1;
    }else if (Seg.selectedSegmentIndex == 2){
        lang = 2;
    }
    [self switchLang:lang];
}
- (void)switchLang:(LanguageKey)lang
{
    NSUserDefaults * user=[NSUserDefaults standardUserDefaults];
        [user setObject:@"one" forKey:@"one"];
        [Language setLanguage:lang];
    // update
    [self updateLocalizedString];
    
    
    
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppToken_Dict"];
    NSString *token =  dict[@"AppToken"];
    
    NSString * soapMessage =
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><ChangeAppLanguageSetting xmlns=\"egive.appservices\"><AppToken>%@</AppToken><AppLang>%ld</AppLang></ChangeAppLanguageSetting></soap:Body></soap:Envelope>",token,lang];
    
    
    [EGUserModel commitLangWithParams:soapMessage block:^(NSString *result, NSError *error) {
        
    }];
    
}

- (void)updateLocalizedString
{

    if ([Language getLanguage] == 3) {
        widthForCall = 120;
    }else{
        widthForCall = 60;
    }
    for (UIView* subView in _contactView.subviews) {
        [subView removeFromSuperview];
    }
    [self createContactView];
    
    _contactLabel.text = HKLocalizedString(@"Setting_label_title1");
    _prompt.text = HKLocalizedString(@"Setting_label_title2");
    _errorLabel.text = HKLocalizedString(@"Setting_label_title3");
    _stipulation.text = HKLocalizedString(@"Setting_label_title4");
    NSString *versionText = HKLocalizedString(@"Setting_label_version");
    _version.text = [NSString stringWithFormat:@"%@ %@",versionText, [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    phoneLabel.text = HKLocalizedString(@"电话");
    faxLabel.text = HKLocalizedString(@"传真:");
    emailLabel.text = HKLocalizedString(@"电邮");
    timeLabel.text = HKLocalizedString(@"办公时间");
    timeLabel1.text = HKLocalizedString(@"星期一至五");
    timeLabel2.text = HKLocalizedString(@"上午9时至下午1时/下午2时至6时");
    timeLabel3.text = HKLocalizedString(@"星期六丶日及公共假期休息");
    
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
