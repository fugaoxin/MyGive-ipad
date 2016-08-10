//
//  EGSettingWebViewController.h
//  Egive-ipad
//
//  Created by kevin on 15/12/30.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGBaseViewController.h"

@interface EGSettingWebViewController : EGBaseViewController

@property (strong, nonatomic) NSString * sURL;
@property (strong, nonatomic) NSString * aURL;
-(void)setAbsoluteURL:(NSString *)theURL;
-(void)setURL:(NSString *)theURL;

@end
