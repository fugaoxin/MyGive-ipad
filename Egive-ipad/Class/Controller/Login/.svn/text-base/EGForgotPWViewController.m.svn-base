//
//  EGForgotPWViewController.m
//  Egive-ipad
//
//  Created by sino on 15/11/25.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGForgotPWViewController.h"
#import "EGMyAlertViewController.h"
#import "EGLoginModel.h"
#import "NSString+RegexKitLite.h"
#import "EGRegisterAlertViewController.h"

@interface EGForgotPWViewController ()
{
    int offset;
    BOOL isSuccess;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewTop;
@end

@implementation EGForgotPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.bgView addGestureRecognizer:tap];
    isSuccess = NO;
    
    self.titleLab.text = HKLocalizedString(@"找回密码");
    self.emailMessageLab.text = HKLocalizedString(@"请输入注册会员时所填的邮箱");
    self.EmailTextField.placeholder = HKLocalizedString(@"Register_email");
    [self.termsOfUseBtn setTitle:HKLocalizedString(@"Login_label_title1") forState:UIControlStateNormal];
    [self.privacyBtn setTitle:HKLocalizedString(@"Login_label_title2") forState:UIControlStateNormal];
    [self.copyrightBtn setTitle:HKLocalizedString(@"Login_label_title3") forState:UIControlStateNormal];
    [self.commitBtn setTitle:HKLocalizedString(@"Register_commitButton_title") forState:UIControlStateNormal];
}

- (void)tapAction{
    // 关闭键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}

-(void)showAlertView:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.message = message;
    alertView.delegate = self;
    [alertView addButtonWithTitle:HKLocalizedString(@"Common_button_confirm")];
    [alertView show];
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
        [self showMessageVCWithTitle:HKLocalizedString(@"输入错误") message:HKLocalizedString(@"无效的电子邮箱")];
    }
}
#pragma mark - 发送找回密码请求
- (void)ForgetPasswordAPI:(NSString *)emailAddress{

    [EGLoginModel commitForgetPasswordWithFormEmailAddress:emailAddress block:^(NSString *result, NSError *error) {
        if (!error) {
            result = [NSString captureData:result];
            if ([result isEqualToString:@"\"\""]) {
                
                [self showAlertView:HKLocalizedString(@"密码重设成功,已发送至您的邮箱,请注意查收!")];
                isSuccess = YES;
                
            }else{
                if ([result isEqualToString:@"\"Error(1001)\""]){
                    result = HKLocalizedString(@"输入错误");
                }
                else if ([result isEqualToString:@"\"Error(5004)\""]){
                    result = HKLocalizedString(@"请输入注册会员时所填的邮箱");
                }
            
                [self showMessageVCWithTitle:HKLocalizedString(@"提示") message:result];
                
            }
        }else{
            
           [self showMessageVCWithTitle:[NSString stringWithFormat:@"error %@",HKLocalizedString(@"提示")] message:[error.userInfo objectForKey:@"NSLocalizedDescription"]?[error.userInfo objectForKey:@"NSLocalizedDescription"]:@"unknown error"];
        }
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (isSuccess) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
    CGSize size = CGSizeMake(WIDTH-200, HEIGHT-100);
    EGMyAlertViewController* root = [[EGMyAlertViewController alloc]init];
    root.size = size;
    root.title = title;
    root.type = type;
    YQNavigationController *nav = [[YQNavigationController alloc] initWithSize:size rootViewController:root];
    nav.touchSpaceHide = YES;//点击没有内容的地方消失
    nav.panPopView = YES;//滑动返回上一层视图
    
    [nav show:YES animated:YES];
}
-(void)showMessageVCWithTitle:(NSString*)title message:(NSString*)message
{
    CGSize size  = CGSizeMake(WIDTH-500, 200);
    EGRegisterAlertViewController* root = [[EGRegisterAlertViewController alloc]init];
    root.size = size;
    root.title = title;
    root.message = message;

    YQNavigationController *nav = [[YQNavigationController alloc] initWithSize:size rootViewController:root];
    nav.touchSpaceHide = YES;//点击没有内容的地方消失
    nav.panPopView = YES;//滑动返回上一层视图
    [nav show:YES animated:YES];
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
    
    offset = frame.origin.y - (self.view.frame.size.height - 398 - 100);//键盘高度398; title 40
    
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
