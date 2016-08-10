//
//  EGWebpageController.m
//  Egive-ipad
//
//  Created by 123 on 15/12/16.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGWebpageController.h"

@interface EGWebpageController ()<UIWebViewDelegate>
@property (retain, nonatomic) UIWebView * webView;

@end

@implementation EGWebpageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self.leftButton setImage:[UIImage imageNamed:@"ic_header_logo-1"] forState:UIControlStateNormal];
    [self setWebV];
}

-(void)setWebV{
    LanguageKey lang = [Language getLanguage];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight-64)];
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];
    self.webView.scalesPageToFit = YES;
    if (lang==1) {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:
                                                            
                                                            [NSString stringWithFormat:@"%@/CaseApplicationTerms.aspx?type=S&lang=1&MemberID=%@&AppToken=",SITE_URL,self.MemberID]]]];
   
    }else if (lang==2){
        
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:
                                                            [NSString stringWithFormat:@"%@/CaseApplicationTerms.aspx?type=S&lang=2&MemberID=%@&AppToken=",SITE_URL,self.MemberID]]]];
    }else{
        
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:
                                                            [NSString stringWithFormat:@"%@/CaseApplicationTerms.aspx?type=S&lang=3&MemberID=%@&AppToken=",SITE_URL,self.MemberID]]]];

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
