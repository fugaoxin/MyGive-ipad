//
//  EGScoopDetailViewController.h
//  Egive-ipad
//
//  Created by kevin on 15/12/26.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EGScoopDetailViewController : UIViewController

@property (nonatomic,weak) IBOutlet UIView * searchView;
@property (nonatomic,weak) IBOutlet UITableView * leftTableView;
@property (nonatomic,retain) UIScrollView * rightScrollView;
@property (nonatomic,retain) UIView * rightBottomView;
@property (nonatomic,retain) UIScrollView * bottomScrollView;


@property (nonatomic,weak) IBOutlet UITextField * timeTF;
@property (nonatomic,weak) IBOutlet UIView * timeSelView;
@property (nonatomic,weak) IBOutlet UIButton * timeAllBtn;
@property (nonatomic,weak) IBOutlet UIButton * timeOneBtn;
@property (nonatomic,weak) IBOutlet UIButton * timeTwoBtn;
@end
