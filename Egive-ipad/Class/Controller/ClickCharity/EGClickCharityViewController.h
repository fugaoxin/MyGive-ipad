//
//  EGClickCharityViewController.h
//  Egive-ipad
//
//  Created by User01 on 15/11/19.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YQNavigationController.h"
#import "EGMyDonationViewController.h"
#import "EGProReportController.h"//进度
#import "EGDonorsController.h"   //捐赠者
#import "EGBlessingController.h" //祝福
#import "EGWebpageController.h"//网页
#import "EGLoginViewController.h"
#import "EGMyFMDataBase.h"
#import "UILabel+StringFrame.h"
#import "EGtextLabelCell.h"
#import "EGGirdTableViewCell.h"
#import "EGEditBlessingController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <SwipeView/SwipeView.h>

@interface EGClickCharityViewController : UIViewController<SwipeViewDelegate,SwipeViewDataSource>

@property (nonatomic,strong) UIImageView * videoImageView;
@property (nonatomic,strong) NSMutableArray * videoArray;


@property (nonatomic,strong) SwipeView * videoScrollView;

@property (nonatomic,copy) NSMutableArray *videoImageArray;//保存视频截图

@property (nonatomic,strong) UIScrollView * videoScrollView222;
@property (nonatomic,strong) UIPageControl  * pageControl;
@property (nonatomic,assign) int page;

@end



@interface EGClickCharityImageCell : UIView

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIButton * playButton;

@end