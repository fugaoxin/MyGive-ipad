//
//  EGMyNvgViewController.h
//  Egive-ipad
//
//  Created by User01 on 15/11/19.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EGMyNvgViewController : UIViewController

@property(nonatomic,strong) UIImageView *headerBgImageView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIButton *leftButton;
@property(nonatomic,strong) UIButton *rightButton;
@property(nonatomic,strong) UIButton *rightTowButton;

-(void)rightButtonClick:(UIButton *)button;
-(void)dismVC;

@end
