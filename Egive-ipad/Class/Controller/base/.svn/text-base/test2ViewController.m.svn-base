//
//  test2ViewController.m
//  Egive-ipad
//
//  Created by kevin on 15/12/29.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "test2ViewController.h"

@interface test2ViewController ()

@end

@implementation test2ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"测试2";
   [self createNaviTopBarWithShowBackBtn:YES showTitle:YES];
    
    UIButton* cancelButton = [[UIButton alloc]init];//44是nvBar高度
    cancelButton.layer.cornerRadius = 5;
    cancelButton.backgroundColor = [UIColor colorWithHexString:@"#5CAF21"];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitle:@"weiboShare" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(weiboShare) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.leading.equalTo(self.contentView);
        make.height.mas_equalTo(40);
        make.trailing.equalTo(self.contentView);
    }];
    
}
-(void)weiboShare{
    NSString* _subject = @"测试";
    NSString* _content = @"测试";
    UIImage* _image = nil;
    
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [myDelegate setShareViewController:self];
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"http://www.sino.com";
    authRequest.scope = @"all";
    
    WBMessageObject *message = [WBMessageObject message];
    
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = @"identifier1";
    webpage.title = _subject;
    webpage.description = _content;
    
    if (_image != nil) {
        webpage.thumbnailData =  UIImageJPEGRepresentation(_image, 0.8);//[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_2" ofType:@"jpg"]];
    }
    webpage.webpageUrl = @"http://www.egive4u.org";//_url
    message.mediaObject = webpage;
    message.text = _content;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:myDelegate.wbtoken];//];//不限制登录微博客户端分享 请打开注释
    
    request.userInfo = @{@"ShareMessageFrom": @"EGShareViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}
                         };
    
    
    [WeiboSDK sendRequest:request];
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
