//
//  AnyWebViewController.m
//  Egive-ipad
//
//  Created by 123 on 16/2/2.
//  Copyright © 2016年 Sino. All rights reserved.
//

#import "AnyWebViewController.h"

@interface AnyWebViewController ()<UIWebViewDelegate>
@property (retain, nonatomic) UIWebView * webView;
@property (retain, nonatomic) NSString * url;

@end

@implementation AnyWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 50,50);
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"common_header_back"] forState:UIControlStateNormal];
    [self.view addSubview:leftButton];
    
    // MyLog(@"URL = %@", (_aURL != nil ? _aURL : [NSString stringWithFormat:@"%@/%@",SITE_URL,_sURL]));
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, screenWidth, screenHeight-50)];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];
    _webView.scalesPageToFit = YES;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: (_aURL != nil ? _aURL : [NSString stringWithFormat:@"%@/%@",SITE_URL,_sURL])]]];
}

- (void)leftAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)setAbsoluteURL:(NSString *)theURL{
    _aURL = theURL;
}

-(void)setURL:(NSString *)theURL{
    _sURL = theURL;
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
