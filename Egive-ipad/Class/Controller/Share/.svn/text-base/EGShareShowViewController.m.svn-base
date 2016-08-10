//
//  EGShareShowViewController.m
//  Egive-ipad
//
//  Created by kevin on 15/12/25.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGShareShowViewController.h"
#import "AppDelegate.h"
#import "EmailItemProvider.h"

@interface EGShareShowViewController ()

@end

@implementation EGShareShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#CBB9DC"];
    [self setUI];
}
-(void)setUI{
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.backgroundColor = [UIColor colorWithHexString:@"#F8F9F8"];
    titleLabel.numberOfLines = 2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [NSString stringWithFormat:@"%@\n%@",HKLocalizedString(@"意赠慈善基金"),HKLocalizedString(@"MenuView_shareButton_title")];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.height.mas_equalTo(80);
    }];
    
    
    UIButton* facebookBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 60, self.size.width-30*2, 40)];//44是nvBar高度
    facebookBtn.backgroundColor = [UIColor colorWithHexString:@"#F8F9F8"];
    [facebookBtn setTitleColor:[UIColor colorWithHexString:@"#0F6DFF"] forState:UIControlStateNormal];
    [facebookBtn setTitle:@"Facebook" forState:UIControlStateNormal];
    [facebookBtn addTarget:self action:@selector(facebookBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:facebookBtn];
    [facebookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(1);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        
    }];
    
    UIButton* weiboBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 60, self.size.width-30*2, 40)];//44是nvBar高度
    weiboBtn.backgroundColor = [UIColor colorWithHexString:@"#F8F9F8"];
    [weiboBtn setTitleColor:[UIColor colorWithHexString:@"#0F6DFF"] forState:UIControlStateNormal];
    [weiboBtn setTitle:HKLocalizedString(@"Weibo") forState:UIControlStateNormal];
    [weiboBtn addTarget:self action:@selector(weiboBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiboBtn];
    [weiboBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(facebookBtn.mas_bottom).offset(1);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        
    }];

    UIButton* whatsAppBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 60, self.size.width-30*2, 40)];//44是nvBar高度
    whatsAppBtn.backgroundColor = [UIColor colorWithHexString:@"#F8F9F8"];
    [whatsAppBtn setTitleColor:[UIColor colorWithHexString:@"#0F6DFF"] forState:UIControlStateNormal];
    [whatsAppBtn setTitle:@"WhatsApp" forState:UIControlStateNormal];
    [whatsAppBtn addTarget:self action:@selector(whatsAppBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:whatsAppBtn];
    [whatsAppBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weiboBtn.mas_bottom).offset(1);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        
    }];
    if ([WhatsAppKit isWhatsAppInstalled]) {//判断是否安装WhatsApp
        whatsAppBtn.hidden = NO;
    }else{
        whatsAppBtn.hidden = YES;
    }
    UIButton* otherBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 60, self.size.width-30*2, 40)];//44是nvBar高度
    otherBtn.backgroundColor = [UIColor colorWithHexString:@"#F8F9F8"];
    [otherBtn setTitleColor:[UIColor colorWithHexString:@"#0F6DFF"] forState:UIControlStateNormal];
    [otherBtn setTitle:HKLocalizedString(@"其他") forState:UIControlStateNormal];
    [otherBtn addTarget:self action:@selector(otherBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:otherBtn];

    [otherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (whatsAppBtn.hidden){
            make.top.equalTo(weiboBtn.mas_bottom).offset(1);
        }else{
            make.top.equalTo(whatsAppBtn.mas_bottom).offset(1);
        }
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        
    }];

    
    
    UIButton* cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 60, self.size.width-30*2, 40)];//44是nvBar高度
    cancelButton.backgroundColor = [UIColor colorWithHexString:@"#F8F9F8"];
    [cancelButton setTitleColor:[UIColor colorWithHexString:@"#0F6DFF"] forState:UIControlStateNormal];
    [cancelButton setTitle:HKLocalizedString(@"Cancel") forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(otherBtn.mas_bottom).offset(1);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(facebookBtn);
        make.height.equalTo(weiboBtn);
        make.height.equalTo(otherBtn);
        make.height.equalTo(whatsAppBtn);
    }];
}
-(void)facebookBtnAction
{
    if (self.buttonAction) {
        self.buttonAction(@"facebookShare");
    }
}

-(void)weiboBtnAction
{
    if (self.buttonAction) {
        self.buttonAction(@"weiboShare");
    }
}
-(void)whatsAppBtnAction
{
    if (self.buttonAction) {
        self.buttonAction(@"whatsAppShare");
    }
}
-(void)otherBtnAction
{
    if (self.buttonAction) {
        self.buttonAction(@"otherShare");
    }
}
-(void)cancelButtonAction
{
    if (self.buttonAction) {
        self.buttonAction(@"cancel");
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
