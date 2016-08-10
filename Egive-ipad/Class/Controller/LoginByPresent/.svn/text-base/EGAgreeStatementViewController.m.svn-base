//
//  EGAgreeStatementViewController.m
//  Egive-ipad
//
//  Created by kevin on 15/12/23.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGAgreeStatementViewController.h"
#import "Language.h"
#import "MDHTMLLabel.h"
#import "MemberFormModel.h"

@interface EGAgreeStatementViewController ()<MDHTMLLabelDelegate>
{
    BOOL isCheck;
}

@property (retain, nonatomic) UIScrollView *noteScrollView;
@property (retain, nonatomic) UIView *noteView;
@property (retain, nonatomic) UIView *bottomView;
@property (retain, nonatomic) MemberFormModel* FormModel;
@property (retain, nonatomic) UIButton *checkButton;
@end

@implementation EGAgreeStatementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.view.backgroundColor =[UIColor clearColor];
    UIView* bgView= [[UIView alloc] init];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.layer.opacity = 0.8;
    UITapGestureRecognizer * imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction)];
    [bgView addGestureRecognizer:imageTap];
    
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //    make.edges.equalTo(sv
    UIView * contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.view);
        make.width.equalTo(self.view).multipliedBy(0.5);
        make.height.mas_equalTo(HEIGHT-300);
        //        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));//top left bottom right.
    }];
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.text = self.title;
    titleLabel.backgroundColor=[UIColor colorWithHexString:@"#F1F2F3"];
    titleLabel.textColor = [UIColor colorWithHexString:@"#531E7E"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.leading.equalTo(contentView);
        make.height.mas_equalTo(40);
        make.trailing.equalTo(contentView);
    }];

    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = (CGRect){0,0,30,30};
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"common_close"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel);
        make.leading.equalTo(contentView).offset(5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];


    _noteScrollView = [[UIScrollView alloc]init];
    _noteScrollView.contentSize = CGSizeMake(0, 0);
    [_noteScrollView setShowsHorizontalScrollIndicator:NO];
    [_noteScrollView setShowsVerticalScrollIndicator:YES];
    [contentView addSubview:_noteScrollView];

    _noteView = [[UIView alloc]init];
//    _noteView.backgroundColor = [UIColor blackColor];
    [_noteScrollView addSubview:_noteView];
    
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 70)];
    _bottomView.backgroundColor = [UIColor colorWithHexString:@"#E4E5E6"];
    [self.view addSubview:_bottomView];
    
    
    _checkButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 20, 30, 30)];
    _checkButton.backgroundColor = [UIColor lightGrayColor];
    [_checkButton setBackgroundImage:[UIImage imageNamed:@"cart_checkbox_nor"] forState:UIControlStateNormal];
    [_checkButton setBackgroundImage:[UIImage imageNamed:@"cart_checkbox_sel"] forState:UIControlStateSelected];
    [_checkButton addTarget:self action:@selector(checkButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_checkButton];
    
    
    UIButton* confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(30, self.view.bounds.size.height-40-44-10, self.view.bounds.size.width-30*2, 40)];//44是nvBar高度
    confirmButton.backgroundColor = [UIColor colorWithHexString:@"#5CAF21"];
    confirmButton.layer.cornerRadius = 5;
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setTitle:HKLocalizedString(@"Common_button_confirm") forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView).offset(-10);
        make.leading.equalTo(contentView).offset(30);
        make.height.mas_equalTo(40);
        make.trailing.equalTo(contentView).offset(-30);
    }];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(contentView);
        make.height.mas_equalTo(70);
        make.trailing.equalTo(contentView);
        make.bottom.equalTo(confirmButton.mas_top).offset(-10);
    }];
    [_checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView).offset(20);
        make.leading.equalTo(_bottomView).offset(30);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    [_noteScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom);
        make.leading.equalTo(contentView);
        make.trailing.equalTo(contentView);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
    
    [_noteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_noteScrollView);
        make.width.equalTo(_noteScrollView);
        
    }];
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
        [self dismissViewControllerAnimated:YES completion:nil];
//        [UIAlertView alertWithText:@"unknown error"];
    }
    
}

-(void)closeAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    [_noteView addSubview:htmlLabel];
//    htmlLabel.backgroundColor = [UIColor redColor];

    CGSize maxSize = CGSizeMake(self.view.bounds.size.width - 20, CGFLOAT_MAX);
    CGSize size = [htmlLabel sizeThatFits:maxSize];
    
//    htmlLabel.frame = CGRectMake(0, 0, size.width, size.height+20);
    [htmlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_noteView).offset(10);
        make.leading.equalTo(_noteView.mas_leading).offset(10);
        make.height.mas_equalTo(size.height+50);
        make.trailing.equalTo(_noteView.mas_trailing).offset(-10);
    }];
    
    [_noteView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height+60);
    }];
    
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
    [htmlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView);
        make.leading.equalTo(_bottomView).offset(80);
        make.bottom.equalTo(_bottomView);
        make.trailing.equalTo(_bottomView);
    }];
    
//    CGRect rect = _bottomView.frame;
//    
//    CGSize maxSize = CGSizeMake(rect.size.width - 80, rect.size.height);
//    
//    CGSize size = [htmlLabel sizeThatFits:maxSize];
//    
//    htmlLabel.frame = CGRectMake(70, 0, size.width, rect.size.height);
//    [htmlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(size.height + 20);
//    }];
    
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
