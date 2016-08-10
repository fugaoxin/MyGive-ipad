//
//  EGRegisterAlertViewController.m
//  Egive-ipad
//
//  Created by sino on 15/12/10.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGRegisterAlertViewController.h"
#import "Language.h"
#import "MDHTMLLabel.h"
#import "MemberFormModel.h"

@interface EGRegisterAlertViewController ()<MDHTMLLabelDelegate>
{
    BOOL isCheck;
}

@property (retain, nonatomic) UIScrollView *noteScrollView;
@property (retain, nonatomic) UIView *bottomView;
@property (retain, nonatomic) MemberFormModel* FormModel;
@property (retain, nonatomic) UIButton *checkButton;

@end

@implementation EGRegisterAlertViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationBar.barTintColor = [UIColor colorWithHexString:@"#F1F2F4"];
    if(self.notShowLeftItem){
        [self.navigationBar cancelLeftItem];
    }
    WEAK_VAR(weakSelf, self);
    self.navigationBar.leftBlock = ^(){
        
        [weakSelf.yqNavigationController show:NO animated:YES];
        
        if (weakSelf.CloseAction) {
            weakSelf.CloseAction();
        }
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.message && self.message.length>0) {
        [self createMessageUI];
    }else{
        [self createAgreeStatementUI];
    }
    
}
#pragma mark  message提示
-(void)createMessageUI{
    UILabel* messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, self.size.width-20*2, self.size.height-44-20)];//44是nvBar高度
    if (self.btnTitle) {
        messageLabel.frame = CGRectMake(20, 10, self.size.width-20*2, self.size.height-44-20-60);//44是nvBar高度 60 btnView高度
    }
    
    messageLabel.textColor = [UIColor blackColor];
//    messageLabel.backgroundColor = [UIColor blueColor];
    messageLabel.text = self.message;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont boldSystemFontOfSize:16];
    messageLabel.numberOfLines = 0;
    [self.view addSubview:messageLabel];
    
    if (self.btnTitle) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.size.height-44-60,self.size.width, 60)];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#F1F2F4"];
        [self.view addSubview:_bottomView];
        
        UIButton* confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 10, self.size.width-30*2, 40)];//44是nvBar高度
        confirmButton.backgroundColor = [UIColor colorWithHexString:@"#5CAF21"];
        confirmButton.layer.cornerRadius = 5;
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmButton setTitle:self.btnTitle forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmMsgAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:confirmButton];
    }
    
}
-(void)confirmMsgAction
{
    if(self.messageAction){
        _messageAction(self);
    }
    [self.yqNavigationController  show:NO animated:YES];

}

#pragma mark  agreeStatement声明
-(void)createAgreeStatementUI{
    
    CGFloat nvBarH = 44;
    CGFloat confirmButtonH = 35;
    CGFloat bottomViewH = 70;
    
    _noteScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height-confirmButtonH-nvBarH-10*2-bottomViewH)];
    _noteScrollView.contentSize = CGSizeMake(0, 0);
    [_noteScrollView setShowsHorizontalScrollIndicator:NO];
    [_noteScrollView setShowsVerticalScrollIndicator:YES];
    [self.view addSubview:_noteScrollView];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.size.height-confirmButtonH-nvBarH-10*2-bottomViewH,self.size.width, bottomViewH)];
    _bottomView.backgroundColor = [UIColor colorWithHexString:@"#E4E5E6"];
    [self.view addSubview:_bottomView];
    
    _checkButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 20, 30, 30)];
    _checkButton.backgroundColor = [UIColor lightGrayColor];
    [_checkButton setBackgroundImage:[UIImage imageNamed:@"cart_checkbox_nor"] forState:UIControlStateNormal];
    [_checkButton setBackgroundImage:[UIImage imageNamed:@"cart_checkbox_sel"] forState:UIControlStateSelected];
    [_checkButton addTarget:self action:@selector(checkButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_checkButton];
    
    
    UIButton* confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(30, self.size.height-confirmButtonH-nvBarH-10, self.size.width-30*2, confirmButtonH)];//44是nvBar高度
    confirmButton.backgroundColor = [UIColor colorWithHexString:@"#6eb92b"];
    confirmButton.layer.cornerRadius = 5;
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setTitle:HKLocalizedString(@"Common_button_confirm") forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
    
    [self getAgreeString];
}
-(void)getAgreeString{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
//    NSDictionary *dict =  [standardUserDefaults objectForKey:@"EGIVE_MemberFormModel_kevin"];
    NSDictionary* dict=[standardUserDefaults objectForKey:[NSString stringWithFormat:@"EGIVE_MemberFormModel_%ld_kevin",[Language getLanguage]]];
    
    if(dict && dict.count>0){
        _FormModel = [[MemberFormModel alloc] init];
        [_FormModel setValuesForKeysWithDictionary:dict];
        
        NSMutableArray * contentArray = [[NSMutableArray alloc] init];
        NSArray * arr = _FormModel.ContentText;
        for (NSDictionary * donorsDict in arr) {
            NSDictionary * dict = [[NSDictionary alloc]initWithObjectsAndKeys:donorsDict[@"LabelName"],@"LabelName",donorsDict[@"LabelDescription"],@"LabelDescription", nil];
            [contentArray addObject:dict];
        }
        
        NSDictionary * dict1 = contentArray[0];//聲明
        NSDictionary * dict2 = contentArray[1];//本機構</span>願意成為意贈之友並同意上述聲明，明白以上所提供的個人資料將會用作為「意贈慈善基金」日後通訊之用。
        
        NSString* AlertLabeltext = [dict1[@"LabelDescription"] stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
        NSRange ind = [AlertLabeltext rangeOfString:@"\n"];
        AlertLabeltext = [AlertLabeltext substringFromIndex:ind.location+ind.length*2];
        AlertLabeltext = [AlertLabeltext stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
        AlertLabeltext = [AlertLabeltext stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        AlertLabeltext = [AlertLabeltext stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"\""];
        AlertLabeltext =[AlertLabeltext stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"\""];
        
        [self parseHTML1:AlertLabeltext];
        
        AlertLabeltext = @"";
        AlertLabeltext = [[dict2[@"LabelDescription"] stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"] stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
        AlertLabeltext = [AlertLabeltext stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        AlertLabeltext = [AlertLabeltext stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"\""];
        AlertLabeltext =[AlertLabeltext stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"\""];
        [self parseHTML2:AlertLabeltext];
    }
    else{
        [self.yqNavigationController  show:NO animated:YES];
        [UIAlertView alertWithText:@"unknown error"];
    }
}

-(void)checkButtonAction
{
    _checkButton.selected = !_checkButton.selected;
    if (_checkButton.selected) {
        isCheck = YES;
    }else{
        isCheck = NO;
    }
}


-(void)confirmAction
{
    if (isCheck){
        if(self.agreeStatement){
            _agreeStatement(self);
        }
        _checkButton.selected = NO;
        isCheck = NO;
         [self.yqNavigationController  show:NO animated:YES];

    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc] init];
        alertView.delegate = self;
        alertView.message = HKLocalizedString(@"请选择并同意上述声明");
        [alertView addButtonWithTitle:HKLocalizedString(@"Common_button_confirm")];
        [alertView show];
    }
    
}

#pragma mark htmlPares
- (void)parseHTML1:(NSString *)htmlString
{
    MDHTMLLabel *htmlLabel = [[MDHTMLLabel alloc] init];
    htmlLabel.delegate = self;
    htmlLabel.numberOfLines = 0;
    htmlLabel.font = [UIFont systemFontOfSize:15];
    
    htmlLabel.linkAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
    htmlLabel.activeLinkAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
    
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    
    htmlLabel.htmlText = htmlString;
    
    [_noteScrollView addSubview:htmlLabel];
    
    CGRect rect = _noteScrollView.frame;
    
    CGSize maxSize = CGSizeMake(rect.size.width - 20, CGFLOAT_MAX);
    
    CGSize size = [htmlLabel sizeThatFits:maxSize];
    
    htmlLabel.frame = CGRectMake(10, 10, size.width, size.height);
    _noteScrollView.contentSize = CGSizeMake(0, size.height + 20);
}

- (void)parseHTML2:(NSString *)htmlString
{
    MDHTMLLabel *htmlLabel = [[MDHTMLLabel alloc] init];
    htmlLabel.delegate = self;
    htmlLabel.numberOfLines = 0;
    htmlLabel.font = [UIFont systemFontOfSize:15];
    
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    
    htmlLabel.htmlText = htmlString;
    
    [_bottomView addSubview:htmlLabel];
    
    CGRect rect = _bottomView.frame;
    
    CGSize maxSize = CGSizeMake(rect.size.width - 80, rect.size.height);
    
    CGSize size = [htmlLabel sizeThatFits:maxSize];
    
    htmlLabel.frame = CGRectMake(70, 0, size.width, rect.size.height);
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
