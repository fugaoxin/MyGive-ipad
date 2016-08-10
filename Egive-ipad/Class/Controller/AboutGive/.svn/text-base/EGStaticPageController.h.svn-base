//
//  EGStaticPageController.h
//  Egive-ipad
//
//  Created by 123 on 15/12/26.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDLabelView.h"
#import "TFHpple.h"

@interface EGStaticPageController : UIViewController
{
    CGFloat currentY;
    UIScrollView *mScrollView;
}
@property (nonatomic, assign) UISlider *slider;

- (void)getStaticPageContentWithContentText:(NSString*)ContentText;
-(void)parseElements:(NSArray *)elements;

- (void)addSubImageView:(NSURL *)imageURL;
- (void)addTitleText:(NSString *)content font:(UIFont*)font;
- (void)addSubText:(NSString *)content;
-(void)addMySlider;
//-(void)sliderDragUp;

@property (nonatomic,strong) NSString * aboutString;

@end
