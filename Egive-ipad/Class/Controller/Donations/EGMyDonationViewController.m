//
//  EGMyDonationViewController.m
//  Egive-ipad
//
//  Created by vincentmac on 15/11/27.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGMyDonationViewController.h"
#import "EGConfirmInfoViewController.h"
#import "MXSegmentedPager.h"
#import "EGKindnessRankingViewController.h"
#import "EGSelectedCaseViewController.h"
#import "EGDesignDonationViewController.h"
#import "EGDonationRecordViewController.h"
#import "EGShareViewController.h"
#import "EGLoginTool.h"

@interface EGMyDonationViewController ()<MXSegmentedPagerDelegate, MXSegmentedPagerDataSource>{

    UIButton *_shareBtn;
    
    EGDesignDonationViewController *_designVC;
    
    NSString *_shareTitle;
    
    NSString *_shareUrl;
    
    NSString *_caseId;
}

@property (nonatomic, strong) MXSegmentedPager  * segmentedPager;

@property (nonatomic, strong) NSArray  *views;

@end

@implementation EGMyDonationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    if (_views.count<=0) {
        [self setupViews];
    }
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissDonation) name:@"DismissDonation" object:nil];
}


-(void)dismissDonation{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    //保存弹起购物车标记
    [[EGLoginTool loginSingleton] saveAlertDonation:NO];
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DismissDonation" object:nil];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    
    NSUserDefaults *donDefaults = [NSUserDefaults standardUserDefaults];
    [donDefaults setObject:nil forKey:kDonationCaseList];
    [donDefaults synchronize];
    
}


-(void)setupViews{
    
    //
    EGSelectedCaseViewController *selectedVC = [[EGSelectedCaseViewController alloc] initWithNibName:@"EGSelectedCaseViewController" bundle:nil];
    EGDonationRecordViewController *recordVC = [[EGDonationRecordViewController alloc] initWithNibName:@"EGDonationRecordViewController" bundle:nil];
    EGDesignDonationViewController *designVC = [[EGDesignDonationViewController alloc] initWithNibName:@"EGDesignDonationViewController" bundle:nil];
    _designVC = designVC;
    
    
    [self addChildViewController:selectedVC];
    [self addChildViewController:recordVC];
    [self addChildViewController:designVC];
    
    _views = @[selectedVC.view,recordVC.view,designVC.view];
//    DLOG(@"%@",[NSValue valueWithCGRect:self.view.bounds]);
    
    recordVC.shareBlock = ^(NSString *title,NSString *url,NSString *caseId){
        _shareTitle = title;
        _shareUrl = url;
        _caseId = caseId;
        
        if (title.length<=0) {
            _shareBtn.hidden = YES;
        }else{
            _shareBtn.hidden = NO;
        }
        
    };
    
    self.title = [Language getStringByKey:@"MyDonation_Title"];
    
    [self createNaviTopBarWithShowBackBtn:YES showTitle:YES];
    [self.navigationBackButton setBackgroundImage:[UIImage imageNamed:@"common_close"] forState:UIControlStateNormal];//重写方法 baseBackAction
    
    
    //
    [self.contentView addSubview:self.segmentedPager];
    
    _segmentedPager.frame = (CGRect){0,0,self.size.width,self.size.height-44};
    
    //    [_segmentedPager mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.leading.equalTo(self.contentView);
    //        make.top.equalTo(self.contentView);
    //        make.width.equalTo(self.contentView);
    //        make.height.mas_equalTo(HEIGHT-100-44);
    //    }];
    
    
    self.segmentedPager.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedPager.segmentedControl.selectionIndicatorColor = [UIColor orangeColor];
    self.segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedPager.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#69318f"]};
    //    self.segmentedPager.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#531E7D"]};
    self.segmentedPager.segmentedControl.tintColor = [UIColor colorWithHexString:@"#531E7D"];
    self.segmentedPager.segmentedControl.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:NormalFontSize+3],NSForegroundColorAttributeName:[UIColor grayColor]};
    self.segmentedPager.segmentedControl.selectionIndicatorHeight = 3;
    self.segmentedPager.segmentedControl.selectionIndicatorColor = [UIColor colorWithHexString:@"#69318f"];
    self.segmentedPager.segmentedControl.type = HMSegmentedControlTypeText;
    //    self.segmentedPager.segmentedControl.userDraggable = NO;
    //    self.segmentedPager.segmentedControl.touchEnabled = NO;
    self.segmentedPager.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    
   
    
    //
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareBtn setImage:[UIImage imageNamed:@"common_header_share"] forState:UIControlStateNormal];
    [self.barView addSubview:_shareBtn];
    
    [_shareBtn bk_addEventHandler:^(id sender) {
        
        [self share];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.barView).offset(-15);
        make.centerY.equalTo(self.barView);
//        make.width.mas_equalTo(150);
//        make.height.mas_equalTo(150);
    }];
    _shareBtn.hidden = YES;
    
    if (_showType==1) {
        [self.segmentedPager scrollToPageAtIndex:1 animated:YES];
        _shareBtn.hidden = NO;
        
        if (_caseId.length>0) {
            recordVC.caseId = _caseId;
        }
    }
}

-(void)share{
   
    NSString * string = @"";
    NSString * subject = @"";
    if (_shareTitle.length>0) {
        
        if ([Language getLanguage]==1) {
            NSString *str = [NSString stringWithFormat:@"我剛剛贊助了Eigve - %@，您也來支持！ - %@ \n \n 請瀏覽:%@/ \n \n 意贈慈善基金 \n Egive For You Charity Foundation \n 電話: (852) 2210 2600 \n 電郵: info@egive4u.org",_shareTitle,[_shareUrl stringByAppendingString:@"?lang=1"],[SITE_URL stringByAppendingString:@"?lang=1"]];
            string = str;
            subject = [NSString stringWithFormat:@"請支持Egive專案 –%@",_shareTitle];
        }else if ([Language getLanguage]==2){
            
            NSString *str = [NSString stringWithFormat:@"我刚刚赞助了Eigve - %@，您也来支持！ - %@ \n\n请浏览: %@/ \n \n意赠慈善基金 \n Egive For You Charity Foundation \n 电话: (852) 2210 2600 \n 电邮: info@egive4u.org",_shareTitle,[_shareUrl stringByAppendingString:@"?lang=2"],[SITE_URL stringByAppendingString:@"?lang=2"]];
            string = str;
            subject = [NSString stringWithFormat:@"请支持Egive项目 –%@",_shareTitle];
        }else{
            
            NSString * str = [NSString stringWithFormat:@"I just made an donation to support Egive - %@, let's join me and support Egive!\n %@ \n\n Visit us at %@ \n\n Egive For You Charity Foundation \n Tel: (852) 2210 2600 \n Email: info@egive4u.org",_shareTitle,[_shareUrl stringByAppendingString:@"?lang=3"],[SITE_URL stringByAppendingString:@"?lang=3"]];
            string = str;
            
            subject = [NSString stringWithFormat:@"Let's support Egive Projects  – %@",_shareTitle];
        }
        
        
        
        
        EGShareViewController * shareVC= [[EGShareViewController alloc] initWithSubject:subject content:string url:[NSString stringWithFormat:@"%@/CaseDetail.aspx?CaseID=%@&lang=%ld",SITE_URL,_caseId,[Language getLanguage]] image:[UIImage imageNamed:@"common_header_logo"] Block:^(id result) {
            //[self reloadTabarUI];
        }];
        [shareVC showShareUIWithPoint:CGPointMake(_shareBtn.center.x, _shareBtn.center.y) view:self.barView permittedArrowDirections:UIPopoverArrowDirectionAny];
    }
}

//重写方法
-(void)baseBackAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    //保存弹起购物车标记
    [[EGLoginTool loginSingleton] saveAlertDonation:NO];
    
//    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
//    [standardUserDefaults setBool:NO forKey:kShowAlertDonation];
//    [standardUserDefaults synchronize];
}

- (IBAction)push:(id)sender {
    

//    [self.navigationBar setLeftBlock:^{
//        [my.yqNavigationController popYQViewControllerAnimated:YES];
//    }];
    //[self.yqNavigationController.rootViewController.navigationBar showLeftItemWithImage:@"message_new"];
    
    //[self.yqNavigationController pushYQViewController:[[EGConfirmInfoViewController alloc] initWithNibName:@"EGConfirmInfoViewController" bundle:nil] animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







#pragma -mark <MXSegmentedPagerDelegate>

- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didSelectViewWithTitle:(NSString *)title {
    //NSLog(@"%@ page selected.", title);
    
    
    
}


- (void) segmentedPager:(MXSegmentedPager*)segmentedPager didSelectViewWithIndex:(NSInteger)index{
    
    if (index==2) {
        [_designVC getInfo];
    }
    
    if (index==1) {
        
        if (_shareTitle.length<=0) {
            _shareBtn.hidden = YES;
        }else{
            _shareBtn.hidden = NO;
        }
    }else{
        _shareBtn.hidden = YES;
        
    }
}


//-(void)setShowType:(NSInteger)showType{
//    _showType = showType;
//    
//    if (_showType==1 && _views.count>1) {
//        [self.segmentedPager scrollToPageAtIndex:1 animated:YES];
//    }else {
//        [self setupViews];
//    }
//}

#pragma -mark <MXSegmentedPagerDataSource>

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    return 3;
}

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index {
    if (index < 3) {
        return [@[[Language getStringByKey:@"MyDonation_selectedButton"], [Language getStringByKey:@"MyDonation_recordButton"], [Language getStringByKey:@"MyDonation_designationButton"]] objectAtIndex:index];
    }
    return [NSString stringWithFormat:@"Page %li", (long) index];
}

- (UIView *)segmentedPager:(MXSegmentedPager *)segmentedPager viewForPageAtIndex:(NSInteger)index {
    
    
    UIView *view = [_views objectAtIndex:index];
    view.frame = self.view.bounds;
    
    
   
    
    
    
    return view;
    
    //    if (index < 3) {
    //        return [@[self.tableView, self.webView, self.textView] objectAtIndex:index];
    //    }
    //
    //    //Dequeue reusable page
    //    UITextView *page = [segmentedPager.pager dequeueReusablePageWithIdentifier:@"TextPage"];
    //    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"LongText" ofType:@"txt"];
    //    page.text = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
//    UIView *re = [UIView new];
//    re.backgroundColor = [UIColor redColor];
//    re.frame = (CGRect){10,10,200,800};
//    if (index==1) {
//        return re;
//    }
//    
//    EGKindnessRankingViewController *kind = [[EGKindnessRankingViewController alloc] initWithNibName:@"EGKindnessRankingViewController" bundle:nil];
//    if (index==2) {
//        return kind.view;
//    }
//    
//    return [UIView new];
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


@end
