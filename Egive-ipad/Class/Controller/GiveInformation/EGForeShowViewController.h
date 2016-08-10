//
//  EGForeShowViewController.h
//  Egive-ipad
//
//  Created by kevin on 15/12/26.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EGForeShowViewController : UIViewController

@property (nonatomic,weak) IBOutlet UITableView * leftTableView;
@property (nonatomic,retain) UIScrollView * rightScrollView;
@property (nonatomic,retain) UIScrollView * headIVScrollView;

@end
