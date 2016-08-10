//
//  EGAboutUsPageController.h
//  Egive-ipad
//
//  Created by 123 on 15/12/26.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGStaticPageController.h"

@protocol EGAboutUsPageDelegate <NSObject>

-(void)obtainAboutImage:(NSString *)image;

@end

@interface EGAboutUsPageController : EGStaticPageController

@property (nonatomic,strong) NSString * ContentText;

@property (nonatomic,weak)id<EGAboutUsPageDelegate> delegate;

@end
