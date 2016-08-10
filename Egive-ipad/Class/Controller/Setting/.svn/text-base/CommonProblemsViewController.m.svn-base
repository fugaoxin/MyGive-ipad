//
//  CommonProblemsViewController.m
//  Egive
//
//  Created by sino on 15/9/12.
//  Copyright (c) 2015年 sino. All rights reserved.
//

#import "CommonProblemsViewController.h"
//#import "MyDonationViewController.h"
#import "EGSettingWebViewController.h"
#import "MBProgressHUD.h"
#import "EGMyDonationViewController.h"
#import "EGMyTabarViewController.h"
#import "AppDelegate.h"
#import "EGLoginModel.h"
@interface CommonProblemsViewController ()<UIWebViewDelegate>

@end

@implementation CommonProblemsViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.view.frame = CGRectMake(0, 0, self.size.width, self.size.height);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = HKLocalizedString(@"常见问题");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#531E7E"]}];
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 25,25);
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"common_header_back"] forState:UIControlStateNormal];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
//    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton.frame = CGRectMake(0, 0, 25, 25);
//    [rightButton addTarget:self action:@selector(chairmanButton:) forControlEvents:UIControlEventTouchUpInside];
//    [rightButton setBackgroundImage:[UIImage imageNamed:@"common_header_share"] forState:UIControlStateNormal];
//    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = rightItem;
//    

    __weak typeof(self) weakSelf = self;
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [EGLoginModel getStaticPageContentWithFormID:@"Public_FAQ" block:^(NSDictionary *result, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            if (result) {
                if ([result objectForKey:@"ContentText"]) {
                    UIWebView *webView = [[UIWebView alloc] initWithFrame:(CGRect){0,44,self.size.width,self.size.height}];
                    webView.backgroundColor = [UIColor whiteColor];
                    [self.view addSubview:webView];
                    webView.delegate = weakSelf;
                    NSString* content = [result objectForKey:@"ContentText"];
                    content = [content stringByReplacingOccurrencesOfString:@"onclick" withString:@"href"];
                    content = [content stringByReplacingOccurrencesOfString:@"DonateNow();" withString:@"ios-DonateNow"];
                    [webView loadHTMLString:content baseURL:nil];
                }
            }
            
        }else{
            
            [UIAlertView alertWithText:[error.userInfo objectForKey:@"NSLocalizedDescription"]?[error.userInfo objectForKey:@"NSLocalizedDescription"]:@"unknown error"];
        }
    }];


}
- (void)leftAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)chairmanButton:(UIButton*)sender{
    
    NSString * string = @"";
    NSString * subject = @"";
    if ([Language getLanguage]==1) {
        NSString *str = @"Egive 常見問題\nEgive - 常見問題  http://www.egive4u.org/FAQ.aspx\n\n請瀏覽: http://www.egive4u.org/\n\n意贈慈善基金\nEgive For You Charity Foundation\n\n電話: (852) 2210 2600\n電郵: info@egive4u.org";
        string = str;
        subject = @"Egive - FAQ";
        
    }else if ([Language getLanguage]==2){
        NSString *str = @"Egive 常见问题\nEgive - 常见问题  http://www.egive4u.org/FAQ.aspx\n\n请浏览: http://www.egive4u.org/\n\n意赠慈善基金\nEgive For You Charity Foundation\n电话: (852) 2210 2600\n电邮: info@egive4u.org";
        string = str;
        subject = @"Egive - 常见问题";
    }else{
        
        NSString * str = [NSString stringWithFormat:@"Egive - FAQ www.egive4u.org/FAQ.aspx\n\nVisit us at www.egive4u.org\n\nEgive For You Charity Foundation\nTel: (852) 2210 2600\nEmail: info@egive4u.org"];
        string = str;
        subject = @"Egive - 常見問題";
    }

    EGShareViewController * shareVC= [[EGShareViewController alloc]initWithSubject:subject content:string url:SITE_URL image:nil Block:^(id result) {
        //popview dismaiss
    }];
    [shareVC showShareUIWithPoint:sender.center view:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[request URL] absoluteString];
    
    NSLog(@"shouldStartLoadWithRequest requestString=%@", requestString);
    
    if ([requestString rangeOfString:@"applewebdata"].length > 0) {
        
        if ([requestString rangeOfString:@"DownloadForm.aspx"].length > 0) {
            EGSettingWebViewController * vc = [[EGSettingWebViewController alloc] init];
             NSString *urlString = [NSString stringWithFormat:@"DownloadForm.aspx?type=D&lang=%d",[Language getLanguage]];
            [vc setURL:urlString];
            [self presentViewController:vc animated:YES completion:nil];
            return NO;
        }
        
        if ([requestString rangeOfString:@"Privacy.aspx"].length > 0) {
             NSString *urlString = [NSString stringWithFormat:@"Privacy.aspx?lang=%d",[Language getLanguage]];
            EGSettingWebViewController * vc = [[EGSettingWebViewController alloc] init];
            [vc setURL:urlString];
            [self presentViewController:vc animated:YES completion:nil];
            return NO;
        }
        if ([requestString rangeOfString:@"ios-DonateNow"].length > 0) {
            
            
            AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
            if (myDelegate.tabarVC) {
                [myDelegate.tabarVC.popover dismissPopoverAnimated:YES];
                [myDelegate.tabarVC reloadTabarUI];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"rightButtonClick_kevin" object:nil];
            
            return NO;
        }
        
    }
    
    if ([requestString rangeOfString:@"tel:(852)"].length > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:requestString]];
        return NO;
    }
    
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
 
    [MBProgressHUD showHUDAddedTo:webView animated:YES];
 
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:webView animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
 [MBProgressHUD hideHUDForView:webView animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
