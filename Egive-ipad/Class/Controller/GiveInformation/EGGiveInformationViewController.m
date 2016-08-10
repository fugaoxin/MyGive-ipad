//
//  EGGiveInformationViewController.m
//  Egive-ipad
//
//  Created by User01 on 15/11/19.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGGiveInformationViewController.h"
#import "MXSegmentedPager.h"
#import "EGScoopDetailViewController.h"
#import "EGReleaseCenterViewController.h"
#import "EGForeShowViewController.h"

@interface EGGiveInformationViewController ()<MXSegmentedPagerDelegate, MXSegmentedPagerDataSource>

@property (nonatomic, strong) MXSegmentedPager  * segmentedPager;

@property (nonatomic, strong) NSArray  *views;

@end

@implementation EGGiveInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //
    EGForeShowViewController *foreShowVC = [[EGForeShowViewController alloc] initWithNibName:@"EGForeShowViewController" bundle:nil];
    EGScoopDetailViewController *scoopDetailVC = [[EGScoopDetailViewController alloc] initWithNibName:@"EGScoopDetailViewController" bundle:nil];
    EGReleaseCenterViewController *centerVC = [[EGReleaseCenterViewController alloc] initWithNibName:@"EGReleaseCenterViewController" bundle:nil];
    
    [self addChildViewController:foreShowVC];
    [self addChildViewController:scoopDetailVC];
    [self addChildViewController:centerVC];
    
    _views = @[foreShowVC.view,scoopDetailVC.view,centerVC.view];
    DLOG(@"%@",[NSValue valueWithCGRect:self.view.bounds]);
    //
    self.segmentedPager.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedPager.segmentedControl.selectionIndicatorColor = [UIColor orangeColor];
    self.segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedPager.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#6B6C6D"]};
    self.segmentedPager.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#531E7E"]};
    self.segmentedPager.segmentedControl.tintColor = [UIColor colorWithHexString:@"#78797A"];
    self.segmentedPager.segmentedControl.selectionIndicatorHeight = 3;
    self.segmentedPager.segmentedControl.selectionIndicatorColor = [UIColor colorWithHexString:@"#531E7E"];
    self.segmentedPager.segmentedControl.type = HMSegmentedControlTypeText;
    self.segmentedPager.segmentedControl.userDraggable = NO;
    //        self.segmentedPager.segmentedControl.touchEnabled = NO;
    self.segmentedPager.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    
    [self.view addSubview:self.segmentedPager];
//    [_segmentedPager mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.view);
//        make.top.equalTo(self.view);
//        make.width.equalTo(self.view);
//        make.height.mas_equalTo(HEIGHT-44);
//    }];
   
    _segmentedPager.frame = (CGRect){0,0,WIDTH-64,HEIGHT-44};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark <MXSegmentedPagerDelegate>

- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didSelectViewWithTitle:(NSString *)title {
    //NSLog(@"%@ page selected.", title);
    if ([title isEqualToString:[Language getStringByKey:@"DonationInfo_scoopButton"]]) {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"NotShowShare_kevin" object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showShare_kevin" object:title];
    }
}
#pragma -mark <MXSegmentedPagerDataSource>

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    return _views.count;
}

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index {
    if (index < _views.count) {
        return [@[[Language getStringByKey:@"DonationInfo_foreshowButton"], [Language getStringByKey:@"DonationInfo_scoopButton"], [Language getStringByKey:@"DonationInfo_releaseButton"]] objectAtIndex:index];
    }
    return [NSString stringWithFormat:@"Page %li", (long) index];
}

- (UIView *)segmentedPager:(MXSegmentedPager *)segmentedPager viewForPageAtIndex:(NSInteger)index {
    
    
    UIView *view = [_views objectAtIndex:index];
    view.frame = self.view.bounds;
    
    return view;

}


#pragma -mark Properties

- (MXSegmentedPager *)segmentedPager {
    if (!_segmentedPager) {
        
        // Set a segmented pager
        _segmentedPager = [[MXSegmentedPager alloc] init];
        _segmentedPager.delegate    = self;
        _segmentedPager.dataSource  = self;
    }
    return _segmentedPager;
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
