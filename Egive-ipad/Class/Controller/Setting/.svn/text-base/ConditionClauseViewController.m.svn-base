//
//  ConditionClauseViewController.m
//  Egive
//
//  Created by sino on 15/9/12.
//  Copyright (c) 2015年 sino. All rights reserved.
//

#import "ConditionClauseViewController.h"
//#import "EGUtility.h"
#import "MBProgressHUD.h"
#import "EGLoginModel.h"
@interface ConditionClauseViewController ()<UIScrollViewDelegate>

@property (retain, nonatomic) UIScrollView *noteScrollView;

@property (nonatomic, assign) UISlider *slider;
@property (nonatomic, strong)UIView *sliderView;
@property (nonatomic, strong)MDHTMLLabel *htmlLabel;
@property (nonatomic, copy)NSString *htmlString;
@end

#define kScreenW self.size.width
#define kScreenH self.size.height

@implementation ConditionClauseViewController


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.view.frame = CGRectMake(0, 0, self.size.width, self.size.height);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = HKLocalizedString(@"条款及细则");
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#531E7E"]}];
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 25,25);
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"common_header_back"] forState:UIControlStateNormal];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationItem.rightBarButtonItem = nil;
//    [self getStaticPageContentWithFormID:@"TermsOfUse"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [EGLoginModel getStaticPageContentWithFormID:@"TermsOfUse" block:^(NSDictionary *result, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            if (result) {
                [self parseHTML:[result objectForKey:@"ContentText"]];
            }
            
        }else{
            
            [UIAlertView alertWithText:[error.userInfo objectForKey:@"NSLocalizedDescription"]?[error.userInfo objectForKey:@"NSLocalizedDescription"]:@"unknown error"];
        }
    }];
    
    _noteScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, kScreenW,kScreenH)];
    _noteScrollView.backgroundColor = [UIColor clearColor];
    _noteScrollView.delegate = self;
    [self.view addSubview:_noteScrollView];
    [self addMySlider];
    
}

- (void)leftAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addMySlider{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, kScreenH - 57+44, kScreenW - 20, 47)];
    view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    view.layer.cornerRadius = 3;
    view.layer.masksToBounds = YES;
    [self.view addSubview:view];
    _sliderView = view;
    _sliderView.hidden = YES;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 27, 27)];
    label1.font = [UIFont systemFontOfSize:15];
    label1.text = @"A";
    [view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake( view.frame.size.width - 30, 10, 27, 27)];
    label2.font = [UIFont systemFontOfSize:20];
    label2.text = @"A";
    [view addSubview:label2];
    
    UISlider *sliderA=[[UISlider alloc]initWithFrame:CGRectMake(25, 20, view.frame.size.width - 60, 7)];
    sliderA.backgroundColor = [UIColor clearColor];
    sliderA.value=0.5;
    sliderA.minimumValue=0.0;
    sliderA.maximumValue=1.0;
    _slider = sliderA;
    
    //滑块拖动时的事件
    [sliderA addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    //滑动拖动后的事件
    [sliderA addTarget:self action:@selector(sliderDragUp) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sliderView addSubview:sliderA];
    
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [_noteScrollView addGestureRecognizer:longPressGr];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDo:)];
    [_noteScrollView addGestureRecognizer:tapGr];
}

#pragma mark htmlPares

- (void)parseHTML:(NSString*)htmlString
{
    MDHTMLLabel *htmlLabel = [[MDHTMLLabel alloc] init];
    htmlLabel.delegate = self;
    htmlLabel.numberOfLines = 0;
    htmlLabel.font = [UIFont systemFontOfSize:15];

    _htmlLabel = htmlLabel;
    
    htmlLabel.linkAttributes = @{
                                 NSForegroundColorAttributeName: [UIColor blackColor],
                                 NSFontAttributeName: [UIFont systemFontOfSize:15],
                                 NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    
    htmlLabel.activeLinkAttributes = @{
                                       NSForegroundColorAttributeName: [UIColor blackColor],
                                       NSFontAttributeName: [UIFont systemFontOfSize:15],
                                       NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    _htmlString = htmlString;
    
    htmlLabel.htmlText = htmlString;
    
    [_noteScrollView addSubview:htmlLabel];

    CGSize maxSize = CGSizeMake(kScreenW - 20, CGFLOAT_MAX);
    
    CGSize size = [htmlLabel sizeThatFits:maxSize];
    
    htmlLabel.frame = CGRectMake(10, 10, size.width, size.height);
    _noteScrollView.contentSize = CGSizeMake(0, size.height + 20);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sliderValueChanged{
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!_sliderView.hidden) {
        _sliderView.hidden = YES;
    }
}

- (void)tapToDo:(UITapGestureRecognizer *)gr
{
    if (!_sliderView.hidden) {
        _sliderView.hidden = YES;
    }
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        //add your code here
        if (_sliderView.hidden) {
            _sliderView.hidden = NO;
        }
    }
}

-(void)sliderDragUp{
    
    float value = self.slider.value;
    float change = 6*(value - 0.5);
    CGFloat fontSize = 15 + change;
    
    _htmlLabel.numberOfLines = 0;
    _htmlLabel.font = [UIFont systemFontOfSize:fontSize];
    _htmlLabel.htmlText = @"";
    _htmlLabel.htmlText = _htmlString;
    
    CGFloat height = [MDHTMLLabel sizeThatFitsHTMLString:_htmlLabel.htmlText withFont:[UIFont systemFontOfSize:fontSize] constraints:CGSizeMake(kScreenW - 20, CGFLOAT_MAX) limitedToNumberOfLines:0 autoDetectUrls:YES];

    _htmlLabel.frame = CGRectMake(10, 10, self.view.bounds.size.width - 20, height);
    
    _noteScrollView.contentSize = CGSizeMake(0, height + 20);
}

@end
