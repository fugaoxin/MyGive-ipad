//
//  EGBannerController.m
//  Egive-ipad
//
//  Created by 123 on 15/12/11.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGBannerController.h"

@interface EGBannerController ()<UIWebViewDelegate>

@property (retain, nonatomic) UIWebView * webView;
@property (nonatomic,strong) UIImageView *imageview;

@end

@implementation EGBannerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNaviTopBarWithShowBackBtn:YES showTitle:YES];
    [self setDatil];
}

-(void)baseBackAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setDatil
{
    if (![_url isEqualToString:@""]){
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(100, 64, screenWidth-200, screenHeight-50-40)];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_webView];
        [_webView setScalesPageToFit:YES];
        //NSLog(@"%@",_url);
        LanguageKey lang = [Language getLanguage];
        
        if ([_url containsString:@"egive4u"]){
            NSString *strUrl = [ NSString stringWithFormat:@"%@&&lang=%ld",_url,lang];
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]]];
        }else{
            //NSLog(@"%@",_url);
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
        }
        
        
    }else{
        _imageurl = [SITE_URL stringByAppendingPathComponent:[_imageurl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
        //DLOG(@"_imageurl==%@",_imageurl);
        self.imageview = [[UIImageView alloc] initWithFrame:CGRectMake(50, 64, screenWidth-100, screenHeight-50-40)];
        //self.imageview.backgroundColor=[UIColor redColor];
        self.imageview.contentMode = UIViewContentModeScaleAspectFit;
        [self.imageview sd_setImageWithURL:[NSURL URLWithString:_imageurl]];
        [self.view addSubview:self.imageview];
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
