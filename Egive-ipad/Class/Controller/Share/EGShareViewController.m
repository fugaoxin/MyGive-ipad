//
//  EGShareViewController.m
//  Egive-ipad
//
//  Created by User01 on 15/11/19.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGShareViewController.h"
#import "EGShareShowViewController.h"
#import "AppDelegate.h"
#import "EmailItemProvider.h"
@interface EGShareViewController ()<FBSDKSharingDelegate>
{
    BOOL isRect;
}
@end

@implementation EGShareViewController

//  subject:标题 content:内容 url:地址 image:图片
-(id)initWithSubject:(NSString *)subject content:(NSString *)content url:(NSString *)url image:(UIImage *)image Block:(EGShareViewControllerBlock)block{
    self = [super init];
    if(self){
        self.subject = subject;
        self.content = content;
        self.url = url;
        self.image = image;
        shareViewControllerBlock = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor =[UIColor whiteColor];
    
}

// * rect:箭头点位置 permittedArrowDirections:箭头方向 showView:哪个View显示
- (void)showShareUIWithRect:(CGRect)rect view:(UIView*)showView permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections;
{
    self.showView = showView;
    self.rect = rect;
    isRect = YES;
    self.permittedArrowDirections = arrowDirections;
    //showview
    CGSize size = CGSizeMake(400, 300);//(410, 570)
    EGShareShowViewController *root = [[EGShareShowViewController alloc]init];
    root.size = size;
    UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:root];
    navi.preferredContentSize = size; //内容大小
    _popover = [[UIPopoverController alloc] initWithContentViewController:navi];
    _popover.delegate = self;
    root.navigationController.navigationBarHidden = YES;
    [root setButtonAction:^(NSString *type) {
        
        if ([type isEqualToString:@"facebookShare"]) {
            [self dismissPopoverReloadUI];
            [self facebookShare];
        }
        else if ([type isEqualToString:@"weiboShare"]) {
            [self weiboShare];//appdelegate 接收返回结果执行dismissPopoverReloadUI
        }
        else if ([type isEqualToString:@"whatsAppShare"]) {
            [self dismissPopoverReloadUI];
            [self whatsAppShare];
        }
        else if([type isEqualToString:@"otherShare"]){
            [_popover dismissPopoverAnimated:NO];
            [self otherShare];
        }else{
            [self dismissPopoverReloadUI];
        }
        
        
    }];
    // 在view这个视图point点，在0＊0区域显示这个Popover
    [_popover presentPopoverFromRect:_rect inView:_showView permittedArrowDirections:_permittedArrowDirections animated:YES];
}

// * point:箭头点位置 permittedArrowDirections:箭头方向 showView:哪个View显示
- (void)showShareUIWithPoint:(CGPoint)point view:(UIView*)showView permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections;
{
    self.showView = showView;
    self.point = point;
    isRect = NO;
    self.permittedArrowDirections = arrowDirections;
    //showview
    CGSize size = CGSizeMake(400, 300);//(410, 570)
    EGShareShowViewController *root = [[EGShareShowViewController alloc]init];
    root.size = size;
    UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:root];
    navi.preferredContentSize = size; //内容大小
    _popover = [[UIPopoverController alloc] initWithContentViewController:navi];
    _popover.delegate = self;
    root.navigationController.navigationBarHidden = YES;
    [root setButtonAction:^(NSString *type) {
        
        if ([type isEqualToString:@"facebookShare"]) {
            [self dismissPopoverReloadUI];
            [self facebookShare];
        }
        else if ([type isEqualToString:@"weiboShare"]) {
            [self weiboShare];//appdelegate 接收返回结果执行dismissPopoverReloadUI
        }
        else if ([type isEqualToString:@"whatsAppShare"]) {
            [self dismissPopoverReloadUI];
            [self whatsAppShare];
        }
        else if([type isEqualToString:@"otherShare"]){
            [_popover dismissPopoverAnimated:NO];
            [self otherShare];
        }else{
            [self dismissPopoverReloadUI];
        }
        
        
    }];
    // 在view这个视图point点，在0＊0区域显示这个Popover
    [_popover presentPopoverFromRect:CGRectMake(_point.x, _point.y, 0, 0) inView:_showView permittedArrowDirections:_permittedArrowDirections animated:YES];
}

#pragma mark -popoverController消失的时候调用
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    if(shareViewControllerBlock){
        shareViewControllerBlock(nil);
    }
}
-(void)dismissPopoverReloadUI{
    [_popover dismissPopoverAnimated:NO];
    if(shareViewControllerBlock){
        shareViewControllerBlock(nil);
    }
}
#pragma mark - facebookShare
-(void)facebookShare{
    DLOG(@"Facebook");
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
        // TODO: publish content.
        DLOG(@"TODO: publish content");
        if (_image != nil) {
            FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
            photo.image = _image;
            photo.userGenerated = YES;
            FBSDKSharePhotoContent *sdkcontent = [[FBSDKSharePhotoContent alloc] init];
            sdkcontent.photos = @[photo];
            if (_url != nil)
                sdkcontent.contentURL = [NSURL URLWithString:_url];
            UIViewController* top = [UIApplication sharedApplication].keyWindow.rootViewController;
            [FBSDKShareDialog showFromViewController:top withContent:sdkcontent delegate:self];
        } else if (_url != nil) {
            FBSDKShareLinkContent *sdkcontent = [[FBSDKShareLinkContent alloc] init];
            sdkcontent.contentURL = [NSURL URLWithString:_url];
            sdkcontent.contentTitle = _subject;
            sdkcontent.contentDescription = _content;
            
            UIViewController* top = [UIApplication sharedApplication].keyWindow.rootViewController;
            [FBSDKShareDialog showFromViewController:top withContent:sdkcontent delegate:self];
        } else {
            FBSDKShareLinkContent *sdkcontent = [[FBSDKShareLinkContent alloc] init];
            sdkcontent.contentURL = [NSURL URLWithString:@"http://www.egive4u.org"];
            sdkcontent.contentTitle = _subject;
            sdkcontent.contentDescription = _content;
            
            UIViewController* top = [UIApplication sharedApplication].keyWindow.rootViewController;
            [FBSDKShareDialog showFromViewController:top withContent:sdkcontent delegate:self];
        }
    } else {
        
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
         [loginManager logOut];//如果用其他账号授权过，先登出
        [loginManager logInWithPublishPermissions:@[@"publish_actions"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
             if (error) {
                 DLOG(@"error %@", error);
             }
             else { // (NB for multiple permissions, check every one)
                DLOG(@"TODO: publish content after grant permission");
#warning TODO
                 /*
                  BOOL hadInstalledFB = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fbauth://"]];
                  BOOL hadInstalledFB2 = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fbauth2://"]];
                  BOOL canShareImage = NO;
                  if (hadInstalledFB || hadInstalledFB2) {
                  canShareImage = YES;
                  }
                  Photos must be less than 12MB in size
                  People need the native Facebook for iOS app installed, version 7.0 or higher
                  if (_image != nil && canShareImage) {
                  */
                 _image = nil;
                 
                 UIViewController* top = [self viewController:self.showView];
                 if (top == nil) {
                     top = [UIApplication sharedApplication].keyWindow.rootViewController;
                 }
                 
                 if ([FBSDKAccessToken currentAccessToken]) {
                    if (_image != nil) {
                        FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
                        photo.image = _image;
                        photo.userGenerated = YES;
                        FBSDKSharePhotoContent *sdkcontent = [[FBSDKSharePhotoContent alloc] init];
                        sdkcontent.photos = @[photo];
                        if (_url != nil)
                            sdkcontent.contentURL = [NSURL URLWithString:_url];
//                        UIViewController* top = [UIApplication sharedApplication].keyWindow.rootViewController;
                        [FBSDKShareDialog showFromViewController:top withContent:sdkcontent delegate:self];
                    } else if (_url != nil) {
                        
                        FBSDKShareLinkContent *sdkcontent = [[FBSDKShareLinkContent alloc] init];
                        sdkcontent.contentURL = [NSURL URLWithString:_url];
                        sdkcontent.contentTitle = _subject;
                        sdkcontent.contentDescription = _content;
                        
//                        UIViewController* top = [UIApplication sharedApplication].keyWindow.rootViewController;
                        [FBSDKShareDialog showFromViewController:top withContent:sdkcontent delegate:self];
                    } else {
                        FBSDKShareLinkContent *sdkcontent = [[FBSDKShareLinkContent alloc] init];
                        sdkcontent.contentURL = [NSURL URLWithString:@"http://www.egive4u.org"];//_url
                        sdkcontent.contentTitle = _subject;
                        sdkcontent.contentDescription = _content;
                        
//                        UIViewController* top = [UIApplication sharedApplication].keyWindow.rootViewController;
                        [FBSDKShareDialog showFromViewController:top withContent:sdkcontent delegate:self];
                    }
                 }
            }

        }];
    }
}

//得到此view 所在的viewController

- (UIViewController*)viewController:(UIView*)view{
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark - weiboShare
-(void)weiboShare{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [myDelegate setShareViewController:self];
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
    webpage.webpageUrl = SITE_URL;//@"http://www.egive4u.org";//_url
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
#pragma mark - whatsAppShare
-(void)whatsAppShare{

    [WhatsAppKit launchWhatsAppWithMessage:_content];
}
#pragma mark - otherShare
-(void)otherShare
{
    EmailItemProvider *email = [EmailItemProvider new];
    email.subject = _subject;
    email.body = _content;
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[email] applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePrint];
    [activityViewController setValue:_subject forKey:@"subject"];
    
    //用以UIActivityViewController执行结束后，被调用，做一些后续处理。
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType, BOOL completed, NSArray * returnedItems, NSError * activityError)
    {
        NSLog(@"activityType :%@", activityType);
        if (completed)
        {
            NSLog(@"completed");
        }else
        {
            NSLog(@"cancel");
        }
        //放回上一级界面
        if(shareViewControllerBlock){
            shareViewControllerBlock(nil);
        }
    };
    // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
    activityViewController.completionWithItemsHandler = myBlock;
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//    {
//        UIViewController* top = [UIApplication sharedApplication].keyWindow.rootViewController;
//        [top presentViewController:activityViewController animated:YES completion:nil];
//    }
//    //if iPad
//    else
//    {
        // Change Rect to position Popover
        _popoverEmail = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
    if (isRect) {
        [_popoverEmail presentPopoverFromRect:_rect inView:_showView permittedArrowDirections:_permittedArrowDirections animated:YES];
    }else{
        [_popoverEmail presentPopoverFromRect:CGRectMake(_point.x, _point.y, 0, 0) inView:_showView permittedArrowDirections:_permittedArrowDirections animated:YES];
    }
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma Facebook Share FBSDKSharingDelegate

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    DLOG(@"%@",results);
    //    NSString *title = nil;
    //            UIAlertView *alert = nil;
    //            title = NSLocalizedString(@"收到网络回调", nil);
    //            alert = [[UIAlertView alloc] initWithTitle:title
    //                                               message:[NSString stringWithFormat:@"%@",results]
    //                                              delegate:nil
    //                                     cancelButtonTitle:NSLocalizedString(@"确定", nil)
    //                                     otherButtonTitles:nil];
    //            [alert show];
}
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    
}
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    
    //不同sdk Display name可能不需要
//    "Display name" : the same name as the app name
//    "Bundle ID" with the string return by [[NSBundle mainBundle] bundleIdentifier];
    
    UIAlertView *alert = nil;
  
    alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"error_reason"]]
                                       message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"error_description"]]
                                      delegate:nil
                             cancelButtonTitle:HKLocalizedString(@"Common_button_confirm")
                             otherButtonTitles:nil];
    [alert show];
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
