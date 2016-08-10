//
//  EGEditBlessingController.m
//  Egive-ipad
//
//  Created by 123 on 15/12/17.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGEditBlessingController.h"

#define viewWith screenWidth-400
#define viewHeight screenHeight-50-44

@interface EGEditBlessingController ()<UITextViewDelegate>

@property (nonatomic,strong) UIScrollView * bgScrollView;
@property (nonatomic,strong) UIImageView * photoImage;//图片
@property (nonatomic,strong) UIImageView * BQImageV;//表情背景
@property (nonatomic,strong) UILabel * titleLabel; //标题
@property (nonatomic,strong) UITextView * textView;//输入框
@property (nonatomic,strong) UILabel * promptLabel;//提示
@property (nonatomic,strong) UILabel * SurplusLabel;//500


@property (nonatomic,strong) UIButton * submitButton;//提交
@property (nonatomic,strong) UIButton * BQButton;//表情

@property (nonatomic,strong) UIButton * keyboardButton;//键盘

@property (nonatomic,strong) NSDictionary * BQDic;//表情字典
@property (nonatomic,strong) NSArray * BQArr;//表情数组
@property (nonatomic,strong) NSArray * BQArray;//表情字典数组
@property (nonatomic,copy) NSString * lastString;
@property (nonatomic,strong) NSString * memberString;//MemberID表示符
@property (nonatomic,strong) EGLoginTool * EGLT;

@end

@interface UIWebView (HackishAccessoryHiding)
@property (nonatomic, assign) BOOL hackishlyHidesInputAccessoryView;
- (void) setHackishlyHidesInputAccessoryView:(BOOL)value;
@end

@implementation EGEditBlessingController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor=[UIColor colorWithRed:233/255.0 green:234/255.0 blue:235/255.0 alpha:1];
    [self BqDictionary];
    [self setNVBar];
    [self setMainInterface];
    [self keyboardNotice];
    
}

#pragma mark - 设置导航栏
-(void)setNVBar
{
    self.title = HKLocalizedString(@"GirdView_blessings_button");
    [self createNaviTopBarWithShowBackBtn:YES showTitle:YES];
    [self.navigationBackButton setBackgroundImage:[UIImage imageNamed:@"common_header_back"] forState:UIControlStateNormal];
}

-(void)baseBackAction{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 设置主界面
-(void)setMainInterface
{
    self.bgScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWith, viewHeight)];
    self.bgScrollView.backgroundColor=[UIColor whiteColor];
    self.bgScrollView.userInteractionEnabled=YES;
    [self.contentView addSubview:self.bgScrollView];
    
    UILabel * butBgLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, viewHeight-50, viewWith, 50)];
    butBgLabel.backgroundColor=[UIColor colorWithHexString:@"#F1F2F3"];
    [self.bgScrollView addSubview:butBgLabel];
    
    self.BQButton=[[UIButton alloc] initWithFrame:CGRectMake(viewWith-50, viewHeight-40, 30, 30)];
    [self.BQButton setImage:[UIImage imageNamed:@"bless_icon_sel"] forState:UIControlStateNormal];
    self.BQButton.tag=100;
    [self.bgScrollView addSubview:self.BQButton];
    [self.BQButton addTarget:self action:@selector(clickBQButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.submitButton=[[UIButton alloc] initWithFrame:CGRectMake(20, viewHeight-41, viewWith-40-50, 32)];
    self.submitButton.backgroundColor=greeBar;
    //[UIColor colorWithRed:90/255.0 green:172/255.0 blue:33/255.0 alpha:1];
    self.submitButton.layer.masksToBounds=YES;
    self.submitButton.layer.cornerRadius=4;
    [self.bgScrollView addSubview:self.submitButton];
    [self.submitButton setTitle:HKLocalizedString(@"Register_commitButton_title") forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(clickSubmit) forControlEvents:UIControlEventTouchUpInside];
    
    self.BQImageV=[[UIImageView alloc] initWithFrame:CGRectMake(20, viewHeight, viewWith-40, 290)];
    self.BQImageV.backgroundColor=[UIColor colorWithRed:233/255.0 green:234/255.0 blue:235/255.0 alpha:1];
    self.BQImageV.userInteractionEnabled=YES;
    self.BQImageV.hidden=YES;
    [self.bgScrollView addSubview:self.BQImageV];
    
    float IVW=(viewWith-40-5*90)/6;
    for (int i=0; i<20; i++) {
        UIImageView * IV=[[UIImageView alloc] initWithFrame:CGRectMake(IVW+i%5*(90+IVW), 10+i/5*(60+10), 90, 60)];
        //IV.backgroundColor=[UIColor redColor];
        IV.userInteractionEnabled=YES;
        IV.image=[UIImage imageNamed:self.BQArr[i]];
        IV.tag=i;
        [self.BQImageV addSubview:IV];
        
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBQImage:)];
        [IV addGestureRecognizer:tap];
    }
    
    self.photoImage=[[UIImageView alloc] initWithFrame:CGRectMake((viewWith-200)/2, 30, 200, 150)];
    //self.photoImage.backgroundColor=[UIColor greenColor];
    
    self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, self.photoImage.frame.origin.y+self.photoImage.frame.size.height+10, viewWith, 40)];
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    //self.titleLabel.backgroundColor=[UIColor redColor];
    
    float TVHeight=self.bgScrollView.frame.size.height-self.titleLabel.frame.origin.y-self.titleLabel.frame.size.height-10-50-50;
    self.textView=[[UITextView alloc] initWithFrame:CGRectMake(20, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+10, viewWith-40, TVHeight)];
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.font=[UIFont systemFontOfSize:24];
    self.textView.delegate=self;
    self.textView.layer.borderWidth =1.0;
    //self.textView.backgroundColor=[UIColor orangeColor];
    
    self.promptLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, self.textView.frame.origin.y+self.textView.frame.size.height+5, 400, 30)];
    self.promptLabel.textColor=[UIColor grayColor];
    self.promptLabel.font=[UIFont systemFontOfSize:15];
    //self.promptLabel.backgroundColor=[UIColor redColor];
    
    self.SurplusLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.textView.frame.size.width+20-150, self.promptLabel.frame.origin.y, 150, 30)];
    self.SurplusLabel.textAlignment=NSTextAlignmentRight;
    self.SurplusLabel.textColor=tabarColor;
    self.SurplusLabel.font=[UIFont systemFontOfSize:15];
    //self.SurplusLabel.backgroundColor=[UIColor redColor];
    
    [self.bgScrollView addSubview:self.photoImage];
    [self.bgScrollView addSubview:self.titleLabel];
    [self.bgScrollView addSubview:self.textView];
    //[self.bgScrollView addSubview:self.promptLabel];
    [self.bgScrollView addSubview:self.SurplusLabel];
    
    UITapGestureRecognizer * TapGes=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(receiveKeyboard)];
    [self.view addGestureRecognizer:TapGes];//收键盘
    
    NSString *  URL = [SITE_URL stringByAppendingPathComponent:[self.model.ProfilePicURL stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:URL] placeholderImage:[UIImage imageNamed:@"dummy_case_related_default"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    self.titleLabel.text=self.model.Title;
    //self.promptLabel.text=[NSString stringWithFormat:@"(%@)",@"最多输入500字元，1个图标等于4个字元"];
    self.SurplusLabel.text=@"0/500";
    //HKLocalizedString(@"");
}

#pragma mark - 表情
-(void)BqDictionary
{
    self.EGLT=[EGLoginTool loginSingleton];
    EGUserModel * UModel=[self.EGLT currentUser];
    if (UModel.MemberID == nil) {
        self.memberString=@"";
    }
    else
    {
        self.memberString=UModel.MemberID;
    }
    self.lastString=@"";
    self.BQArr=@[@"believe.jpg" ,@"better.jpg",
                 @"bless.jpg"   ,@"care.jpg",
                 @"cheer.jpg"   ,@"courage.jpg",
                 @"hug.jpg"     ,@"kiss.jpg",
                 @"luck.jpg"    ,@"model.jpg",
                 @"partner.jpg" ,@"power.jpg",
                 @"sad.jpg"     ,@"support.jpg",
                 @"takecare.jpg",@"thank.jpg",
                 @"together.jpg",@"touch.jpg",
                 @"victory.jpg" ,@"workhard.jpg"];
    self.BQDic=@{@":believe:":@"believe.jpg"  ,@":better:":@"better.jpg",
                 @":bless:":@"bless.jpg"      ,@":care:":@"care.jpg",
                 @":cheer:":@"cheer.jpg"      ,@":courage:":@"courage.jpg",
                 @":hug:":@"hug.jpg"          ,@":kiss:":@"kiss.jpg",
                 @":luck:":@"luck.jpg"        ,@":model:":@"model.jpg",
                 @":partner:":@"partner.jpg"  ,@":power:":@"power.jpg",
                 @":sad:":@"sad.jpg"          ,@":support:":@"support.jpg",
                 @":takecare:":@"takecare.jpg",@":thank:":@"thank.jpg",
                 @":together:":@"together.jpg",@":touch:":@"touch.jpg",
                 @":victory:":@"victory.jpg"  ,@":workhard:":@"workhard.jpg"};
    
    self.BQArray=@[@{@"believe.jpg":@":believe:"},@{@"better.jpg":@":better:"},
                   @{@"bless.jpg":@":bless:"},@{@"care.jpg":@":care:"},
                   @{@"cheer.jpg":@":cheer:"},@{@"courage.jpg":@":courage:"},
                   @{@"hug.jpg":@":hug:"},@{@"kiss.jpg":@":kiss:"},
                   @{@"luck.jpg":@":luck:"},@{@"model.jpg":@":model:"},
                   @{@"partner.jpg":@":partner:"},@{@"power.jpg":@":power:"},
                   @{@"sad.jpg":@":sad:"},@{@"support.jpg":@":support:"},
                   @{@"takecare.jpg":@":takecare:"},@{@"thank.jpg":@":thank:"},
                   @{@"together.jpg":@":together:"},@{@"touch.jpg":@":touch:"},
                   @{@"victory.jpg":@":victory:"},@{@"workhard.jpg":@":workhard:"}];
}

- (void)resetTextStyle {
    //After changing text selection, should reset style.
    NSRange wholeRange = NSMakeRange(0, self.textView.textStorage.length);
    [self.textView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    [self.textView.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:26] range:wholeRange];
    
    self.lastString = [NSString stringWithFormat:@"%@", [self.textView.textStorage getPlainString]];
    if (500-(int)self.lastString.length>=0) {
        self.SurplusLabel.text=[NSString stringWithFormat:@"%ld/500",self.lastString.length];
        self.submitButton.backgroundColor=greeBar;
        //[UIColor colorWithRed:90/255.0 green:172/255.0 blue:33/255.0 alpha:1];
    }
    else
    {
        self.SurplusLabel.text=[NSString stringWithFormat:@"500/500"];
        self.submitButton.backgroundColor=[UIColor lightGrayColor];
    }
}

#pragma mark - 点击表情图片
-(void)clickBQImage:(UITapGestureRecognizer *)tap
{
    EGEmojiTextAttachment *emojiTextAttachment = [EGEmojiTextAttachment new];
    emojiTextAttachment.emojiTag = [self.BQArray[tap.view.tag] objectForKey:self.BQArr[tap.view.tag]];
    emojiTextAttachment.image = [UIImage imageNamed:self.BQArr[tap.view.tag]];
    emojiTextAttachment.emojiSize = CGSizeMake(90,60);
    [self.textView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment]atIndex:self.textView.selectedRange.location];
    self.textView.selectedRange = NSMakeRange(self.textView.selectedRange.location + 1, self.textView.selectedRange.length);
    [self resetTextStyle];
}


#pragma mark - 点击提交
-(void)clickSubmit
{
    //NSLog(@"self.lastString==%@",self.lastString);
    if (![self.lastString isEqualToString:@""]){
        if ([self.lastString length] > 500) {
//            UIAlertView * alertView = [[UIAlertView alloc] init];
//            alertView.message = HKLocalizedString(@"内容不能超过500个字符");
//            [alertView addButtonWithTitle:HKLocalizedString(@"Common_button_confirm")];
//            [alertView show];
            return;
        }
        PreviewViewController * vc = [[PreviewViewController alloc] init];
        CGSize size = CGSizeMake(screenWidth-400, screenHeight-50);
        [vc setContentSize:size  bgAction:NO animated:NO];
        vc.caseId = self.model.CaseID;
        vc.comments = self.lastString;
        vc.memberId = self.memberString;
        vc.disappearStr=self.disappearStr;
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        //[self.yqNavigationController pushYQViewController:vc animated:YES];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        UIAlertView * alertView = [[UIAlertView alloc] init];
        alertView.message =HKLocalizedString(@"请输入祝福内容!");
        [alertView addButtonWithTitle:HKLocalizedString(@"Common_button_confirm")];
        [alertView show];
    }
}

#pragma mark - 点击表情按钮
-(void)clickBQButton:(UIButton *)button
{
    //DLOG(@"点击表情按钮");
    button.selected=!button.selected;
    if (button.selected) {
        self.BQImageV.hidden=NO;
       self.bgScrollView.contentOffset = CGPointMake(0, 270);
       self.bgScrollView.contentSize=CGSizeMake(viewWith, viewHeight+self.BQImageV.frame.size.height+20);
    }
    else
    {
        self.BQImageV.hidden=YES;
        self.bgScrollView.contentSize=CGSizeMake(viewWith, viewHeight);
    }
}

#pragma mark - 键盘通知
-(void)keyboardNotice
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)keyboardDidHide: (NSNotification *) notif{
    UIButton * button=(UIButton *)[self.bgScrollView viewWithTag:100];
    if (!button.selected) {
        self.bgScrollView.contentSize=CGSizeMake(viewWith, viewHeight-50);
    }
    [self.keyboardButton removeFromSuperview];
}

- (void)keyboardWillShow: (NSNotification *) notif{
    NSDictionary* keyboardInfo = [notif userInfo];
    CGSize kbSize = [[keyboardInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //DLOG(@"UIKeyboardFrameEndUserInfoKey kbSize = %f", kbSize.height);
    self.bgScrollView.contentSize=CGSizeMake(viewWith, viewHeight+kbSize.height);
}

#pragma mark - textViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    self.lastString = [NSString stringWithFormat:@"%@", [self.textView.textStorage getPlainString]];
    if (500-(int)self.lastString.length>=0) {
        self.SurplusLabel.text=[NSString stringWithFormat:@"%ld/500",self.lastString.length];
        self.submitButton.backgroundColor=greeBar;
        //[UIColor colorWithRed:90/255.0 green:172/255.0 blue:33/255.0 alpha:1];
    }
    else
    {
        self.SurplusLabel.text=[NSString stringWithFormat:@"500/500"];
        self.submitButton.backgroundColor=[UIColor lightGrayColor];
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.lastString = [NSString stringWithFormat:@"%@", [self.textView.textStorage getPlainString]];
    if (500-(int)self.lastString.length>=0) {
        self.SurplusLabel.text=[NSString stringWithFormat:@"%ld/500",self.lastString.length];
        self.submitButton.backgroundColor=greeBar;
        //[UIColor colorWithRed:90/255.0 green:172/255.0 blue:33/255.0 alpha:1];
    }
    else
    {
        self.SurplusLabel.text=[NSString stringWithFormat:@"500/500"];
        self.submitButton.backgroundColor=[UIColor lightGrayColor];
    }
    return YES;
}

-(void)receiveKeyboard
{
    [self.view endEditing:YES];
    [self.keyboardButton removeFromSuperview];
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
