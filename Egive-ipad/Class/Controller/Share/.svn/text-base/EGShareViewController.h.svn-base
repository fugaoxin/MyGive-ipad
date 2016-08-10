//
//  EGShareViewController.h
//  Egive-ipad
//
//  Created by User01 on 15/11/19.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGBaseViewController.h"
#import <Facebook-iOS-SDK/FBSDKCoreKit/FBSDKCoreKit.h>
#import <Facebook-iOS-SDK/FBSDKLoginKit/FBSDKLoginKit.h>
#import <Facebook-iOS-SDK/FBSDKShareKit/FBSDKShareKit.h>
#import <WeiboSDK/WeiboSDK.h>
#import "WhatsAppKit.h"

typedef void (^EGShareViewControllerBlock)(id result);

@interface EGShareViewController : EGBaseViewController<UIPopoverControllerDelegate>
{
    EGShareViewControllerBlock shareViewControllerBlock;
}
@property (copy,nonatomic) NSString *subject;
@property (copy,nonatomic) NSString *content;
@property (copy,nonatomic) NSString *url;
@property (strong,nonatomic) UIImage *image;

@property (nonatomic) CGPoint point;
@property (nonatomic) CGRect  rect;
@property (nonatomic,strong) UIPopoverController *popover;
@property (nonatomic,strong) UIPopoverController *popoverEmail;
@property (nonatomic,strong) UIView *showView;
@property (nonatomic) UIPopoverArrowDirection permittedArrowDirections;

/**
 *  分享 创建
 *  subject:标题 content:内容 url:地址 image:图片  fromVC:(UIViewController*)fromVC
 *  @return
 */
-(id)initWithSubject:(NSString *)subject content:(NSString *)content url:(NSString *)url
               image:(UIImage *)image Block:(EGShareViewControllerBlock)block;


/**
 *  分享 显示
 *  rect:箭头点位置 可偏移  permittedArrowDirections:箭头方向 showView:哪个View显示
 *  @return
 */
- (void)showShareUIWithRect:(CGRect)rect view:(UIView*)showView permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections;
/**
 *  分享 显示
 *  point:箭头点位置 居中 permittedArrowDirections:箭头方向 showView:哪个View显示
 *  @return
 */
- (void)showShareUIWithPoint:(CGPoint)point view:(UIView*)showView permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections;


-(void)dismissPopoverReloadUI;


@end
