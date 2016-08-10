//
//  EGMyTabarViewController.h
//  Egive-ipad
//
//  Created by User01 on 15/11/19.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EGMyTabarViewController : UIViewController

-(void)setTabBarControllerWithVCArray:(NSArray *)vcArray andPhotoArray:(NSArray *)photoArray selectedPhotoArray:(NSArray *)selectedPhotoArray titleArray:(NSArray *)titleArray;

//by kevin
@property (nonatomic,strong) UIPopoverController *popover;
-(void)reloadTabarUI;

@end
