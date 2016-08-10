//
//  EGForgotPWByPushViewController.m
//  Egive-ipad
//
//  Created by sino on 15/11/25.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGForgotPWByPushViewController.h"
#import "EGLoginModel.h"
#import "NSString+RegexKitLite.h"
#import "EGPrentAlertViewController.h"
#import "CZPickerView.h"

@interface EGForgotPWByPushViewController ()
{
    int offset;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewTop;
@end

@implementation EGForgotPWByPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = HKLocalizedString(@"找回密码");
    UIView* barView = [self createNaviTopBarWithShowBackBtn:YES showTitle:YES];
//    barView.backgroundColor = [UIColor whiteColor];
    
    [self setForgetUI];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.contentView addGestureRecognizer:tap];
//    [self.navigationBar showLeftItemWithImage:@"common_header_back"];
    
    
    self.emailMessageLab.text = HKLocalizedString(@"请输入注册会员时所填的邮箱");
    self.EmailTextField.placeholder = HKLocalizedString(@"Register_email");
    [self.termsOfUseBtn setTitle:HKLocalizedString(@"Login_label_title1") forState:UIControlStateNormal];
    [self.privacyBtn setTitle:HKLocalizedString(@"Login_label_title2") forState:UIControlStateNormal];
    [self.copyrightBtn setTitle:HKLocalizedString(@"Login_label_title3") forState:UIControlStateNormal];
    [self.commitBtn setTitle:HKLocalizedString(@"Register_commitButton_title") forState:UIControlStateNormal];
}

#pragma mark 其他
-(void)setForgetUI{
    
    //
    self.logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.logoImageView.image = [UIImage imageNamed:@"language_logo"];
    
    [self.contentView addSubview:self.logoImageView];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(50);
        make.centerX.mas_equalTo(self.contentView .mas_centerX);
        make.size.mas_equalTo(CGSizeMake(self.size.width/3,self.size.width/3/3));
    }];
    //
    
    self.EmailTextField = [self createTextFild];
    [self.contentView addSubview:self.EmailTextField];

    [self.EmailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(-20);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(self.size.width/2.5+20);
        make.height.mas_equalTo(40);
    }];
    
    self.emailMessageLab = [[UILabel alloc]init];
    self.emailMessageLab.textColor = [UIColor darkGrayColor];
    self.emailMessageLab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.emailMessageLab];
    
    [self.emailMessageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_EmailTextField.mas_top);
        make.leading.equalTo(_EmailTextField);
        make.trailing.equalTo(self.contentView);
        make.height.equalTo(_EmailTextField);
    }];
    

    self.commitBtn = [self createButton];
    self.commitBtn.backgroundColor = [UIColor colorWithHexString:@"#5CAF21"];
    self.commitBtn.layer.cornerRadius = 5;
    [self.commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.commitBtn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    self.commitBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -36, 0, 0);
    [self.contentView addSubview:self.commitBtn];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_EmailTextField.mas_bottom).offset(30);
        make.leading.equalTo(_EmailTextField);
        make.trailing.equalTo(_EmailTextField);
        make.height.equalTo(_EmailTextField);
    }];
    //
    self.termsOfUseBtn = [self createButton];
    [self.termsOfUseBtn addTarget:self action:@selector(termsOfUseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.termsOfUseBtn];
    [self.termsOfUseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(40);
        make.leading.equalTo(_commitBtn);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-30);
        
        
    }];
    
    self.privacyBtn = [self createButton];
    [self.privacyBtn addTarget:self action:@selector(privacyAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.privacyBtn];
    [self.privacyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.termsOfUseBtn);
        make.height.mas_equalTo(self.termsOfUseBtn);
        make.width.mas_equalTo(self.termsOfUseBtn);
        make.leading.equalTo(self.termsOfUseBtn.mas_trailing).offset(15);
        
    }];
    
    self.copyrightBtn = [self createButton];
    [self.copyrightBtn addTarget:self action:@selector(copyrightAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.copyrightBtn];
    [self.copyrightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.termsOfUseBtn);
        make.height.mas_equalTo(self.termsOfUseBtn);
        make.width.mas_equalTo(self.termsOfUseBtn);
        make.leading.equalTo(self.privacyBtn.mas_trailing).offset(15);
        make.trailing.equalTo(_commitBtn);
        
    }];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor =  [UIColor darkGrayColor];
    [self.contentView  addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.termsOfUseBtn);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(1);
        make.leading.equalTo(self.termsOfUseBtn.mas_trailing).offset(3);
        
    }];
    UIView *line2 = [UIView new];
    line2.backgroundColor =  [UIColor darkGrayColor];
    [self.contentView  addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.termsOfUseBtn);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(1);
        make.leading.equalTo(self.privacyBtn.mas_trailing).offset(3);
        
    }];
    //
}

-(UIButton*)createButton
{
    UIButton* button =[[UIButton alloc]init];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    return button;
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

- (void)tapAction{
    // 关闭键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}

#pragma mark 返回
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 提交
- (IBAction)commitAction:(id)sender {
    // 关闭键盘
    [self.EmailTextField resignFirstResponder];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if ([NSString isEmail:self.EmailTextField.text]) {
        [self ForgetPasswordAPI:self.EmailTextField.text];
    }else{
        [self showMessageVCWithTitle:HKLocalizedString(@"输入错误")  type:@"message" message:HKLocalizedString(@"无效的电子邮箱")];
    }
}
#pragma mark - 发送找回密码请求
- (void)ForgetPasswordAPI:(NSString *)emailAddress{

    [EGLoginModel commitForgetPasswordWithFormEmailAddress:emailAddress block:^(NSString *result, NSError *error) {
        if (!error) {
            result = [NSString captureData:result];
            if ([result isEqualToString:@"\"\""]) {
                
                [self  showMessageVCWithTitle:HKLocalizedString(@"提示") type:@"message_dissVC" message:HKLocalizedString(@"密码重设成功,已发送至您的邮箱,请注意查收!")];

                
            }else{
                if ([result isEqualToString:@"\"Error(1001)\""]){
                    result = HKLocalizedString(@"输入错误");
                }
                else if ([result isEqualToString:@"\"Error(5004)\""]){
                    result = HKLocalizedString(@"请输入注册会员时所填的邮箱");
                }
            
                [self showMessageVCWithTitle:HKLocalizedString(@"提示") type:@"message" message:result];
                
            }
        }else{
            
           [self showMessageVCWithTitle:[NSString stringWithFormat:@"error %@",HKLocalizedString(@"提示")]  type:@"message" message:[error.userInfo objectForKey:@"NSLocalizedDescription"]?[error.userInfo objectForKey:@"NSLocalizedDescription"]:@"unknown error"];
        }
    }];
    
}

#pragma mark 使用条款
- (IBAction)termsOfUseAction:(UIButton *)sender {
    
    [self showVCWithTitle:HKLocalizedString(@"Login_label_title1") type:@"TermsOfUse"];
}
#pragma mark 隐私政策
- (IBAction)privacyAction:(UIButton *)sender {
    
    [self showVCWithTitle:HKLocalizedString(@"Login_label_title2") type:@"Privacy"];
}
#pragma mark 版权说明
- (IBAction)copyrightAction:(UIButton *)sender {
    
    [self showVCWithTitle:HKLocalizedString(@"Login_label_title3") type:@"Copyright"];
}

#pragma mark - popView
-(void)showVCWithTitle:(NSString*)title type:(NSString*)type
{

    EGPrentAlertViewController* root = [[EGPrentAlertViewController alloc]init];
    root.title = title;
    root.type = type;
    root.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:root animated:YES completion:nil];

}
-(void)showMessageVCWithTitle:(NSString*)title type:(NSString*)type message:(NSString*)message
{
    if ([type isEqualToString:@"message_dissVC"]) {
        CZPickerView *pv = [[CZPickerView alloc] initWithHeaderTitle:title singleButtonTitle:HKLocalizedString(@"Common_button_confirm") singleTapAction:^{
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        pv.headerBackgroundColor = [UIColor colorWithHexString:@"#F4F5F6"];
        pv.headerTitleColor = [UIColor colorWithHexString:@"#673291"];
        pv.cancelButtonBackgroundColor = [UIColor colorWithHexString:@"#5CAF21"];
        pv.cancelButtonNormalColor = [UIColor whiteColor];
        pv.showCloseButton = YES;
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

-(void)returnFrame{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    _bgViewTop.constant = 50;
//    [_bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(offset);
//    }];
//    [_bgView updateConstraints];
    [UIView commitAnimations];
}
#pragma mark - UITextFieldDelegate
//解决虚拟键盘挡住UITextField的方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self returnFrame];
    [textField resignFirstResponder];
    [self commitAction:nil];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    [self returnFrame];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    frame = [textField.superview convertRect:frame toView:self.view];
    
    offset = frame.origin.y - (self.view.frame.size.height - 398 - 80);//键盘高度398;
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    if(offset > 0)
    {
        _bgViewTop.constant = 50-offset;
//        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.offset(-offset);
//        }];
//        [_bgView updateConstraints];
    }
    [UIView commitAnimations];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)se
 nder {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
