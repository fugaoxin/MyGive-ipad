//
//  EGSettingWebViewController.m
//  Egive-ipad
//
//  Created by kevin on 15/12/30.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGSettingWebViewController.h"
#import "MBProgressHUD.h"

@interface EGSettingWebViewController ()<UIWebViewDelegate>
@property (retain, nonatomic) UIWebView * webView;
@property (retain, nonatomic) NSString * url;

@end

@implementation EGSettingWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
    UIView* barView= [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    barView.backgroundColor = [UIColor colorWithHexString:@"#F1F2F3"];
    [self.view addSubview:barView];
    
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithRed:110/255.0 green:49/255.0 blue:139/255.0 alpha:1]}];
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 85,50);
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"ic_header_logo.png"] forState:UIControlStateNormal];
    [barView addSubview:leftButton];
    
//    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    self.navigationItem.leftBarButtonItem = leftItem;
   
    
     DLOG(@"URL = %@", (_aURL != nil ? _aURL : [NSString stringWithFormat:@"%@/%@",SITE_URL,_sURL]));
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20+44, self.view.frame.size.width, self.view.frame.size.height-20-44)];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];
    _webView.scalesPageToFit = YES;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: (_aURL != nil ? _aURL : [NSString stringWithFormat:@"%@/%@",SITE_URL,_sURL])]]];
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    [MBProgressHUD showHUDAddedTo:_webView animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
   [MBProgressHUD hideHUDForView:_webView animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error;
{
   [MBProgressHUD hideHUDForView:_webView animated:YES];
}
- (void)leftAction{
    [self dismissViewControllerAnimated:YES completion:nil];
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
