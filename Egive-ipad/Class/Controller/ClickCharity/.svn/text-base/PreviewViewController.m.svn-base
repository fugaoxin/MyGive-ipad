//
//  PreviewViewController.m
//  Egive
//
//  Created by sino on 15/9/13.
//  Copyright (c) 2015年 sino. All rights reserved.
//

#import "PreviewViewController.h"
#define viewWith screenWidth-400
#define viewHeight screenHeight-50-44

@interface PreviewViewController (){

    UIDevice *device_;

}
@property (strong, nonatomic) UIView * PreviewBgView;
@property (nonatomic,strong) UIButton * submitButton;
@property (nonatomic,strong) NSString * OKString;

@property (nonatomic,strong) EGDataCenter * DC;//my单例
@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentView.backgroundColor = [UIColor colorWithRed:224/255.0 green:225/255.0 blue:226/255.0 alpha:1];
    device_=[[UIDevice alloc] init];
    [self setNVBar];
    [self setMainInterface];
    
    [self PreviewView];
}

#pragma mark - 设置导航栏
-(void)setNVBar
{
    self.title = HKLocalizedString(@"预览");
    [self createNaviTopBarWithShowBackBtn:YES showTitle:YES];
    [self.navigationBackButton setBackgroundImage:[UIImage imageNamed:@"common_header_back"] forState:UIControlStateNormal];
}

-(void)baseBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 设置主界面
-(void)setMainInterface
{
    UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, viewHeight-50, viewWith, 50)];
    imageView.userInteractionEnabled=YES;
    imageView.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:244/255.0 alpha:1];
    [self.contentView addSubview:imageView];
    
    self.submitButton=[[UIButton alloc] initWithFrame:CGRectMake(20, 9, viewWith-40, 32)];
    self.submitButton.backgroundColor=greeBar;
    //[UIColor colorWithRed:90/255.0 green:172/255.0 blue:33/255.0 alpha:1];
    self.submitButton.layer.masksToBounds=YES;
    self.submitButton.layer.cornerRadius=4;
    [imageView addSubview:self.submitButton];
    [self.submitButton setTitle:HKLocalizedString(@"Common_button_confirm") forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(clickDetermineButton) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickDetermineButton
{
    if ([self.OKString isEqualToString:@"OK"]) {
        
    }
    else
    {
        self.OKString=@"OK";
        [self SaveCaseComment:self.caseId andMemberID:self.memberId];
    }
}

- (void)PreviewView{
    
    UIScrollView * contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 100, viewWith-40, viewHeight-250)];
    contentScrollView.backgroundColor=[UIColor whiteColor];
    contentScrollView.contentSize = CGSizeMake(viewWith-40, viewHeight-250);
    //[_PreviewBgView addSubview:contentScrollView];
    [self.contentView addSubview:contentScrollView];
    
    UIImageView * imageV=[[UIImageView alloc] initWithFrame:CGRectMake(0, 20, viewWith-40, viewHeight-250-40)];
    [contentScrollView addSubview:imageV];
    
    NSString* content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"preview" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL];
    content = [content stringByReplacingOccurrencesOfString:@":content:" withString:_comments];
    //NSLog(@"%@", content);
    UIWebView *_wv = [[UIWebView alloc] init];
    _wv.frame = CGRectMake(-20, 0, viewWith+40, viewHeight-250-40);
    _wv.contentMode = UIViewContentModeScaleAspectFit;
    _wv.scrollView.scrollEnabled = NO;
    _wv.scrollView.bounces = NO;
    _wv.userInteractionEnabled = NO;
    [_wv loadHTMLString:content baseURL:[[NSBundle mainBundle] bundleURL]];
    [imageV addSubview:_wv];
    [_wv.superview sendSubviewToBack:_wv];
}

- (void)SaveCaseComment:(NSString *)caseID andMemberID:(NSString *)memberID{
    //NSString * str=@"爸爸去哪？:kiss:";
    //DLOG(@"comments===%@",_comments);
    NSString * soapMessage = [NSString stringWithFormat:
                              @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body> <SaveCaseComment xmlns=\"egive.appservices\"><CaseCommentID></CaseCommentID><CaseID>%@</CaseID><MemberID>%@</MemberID><Comment>%@</Comment></SaveCaseComment></soap:Body></soap:Envelope>",caseID,memberID,_comments];
    
    [EGHomeModel postWithHttpsConnection:YES soapMsg:soapMessage success:^(id result) {
        NSString *dataString = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        dataString = [EGBaseModel captureData:dataString];
        self.OKString=@"";
        if ([[EGBaseModel captureData:dataString] isEqualToString:@"\"\""]) {
            self.PreviewBgView.hidden = YES;
            EGBlessOKController * EGED=[[EGBlessOKController alloc] init];
            EGED.disappearStr=self.disappearStr;
            CGSize size = CGSizeMake(screenWidth-400, screenHeight-50);
            [EGED setContentSize:size  bgAction:NO animated:NO];
            [self.navigationController pushViewController:EGED animated:YES];
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] init];
            alertView.message = result;
            [alertView addButtonWithTitle:HKLocalizedString(@"Common_button_confirm")];
            [alertView show];
        }
        
        
    } failure:^(NSError * error) {
       
    }];
    
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
