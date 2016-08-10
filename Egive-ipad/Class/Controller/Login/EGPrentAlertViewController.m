//
//  EGPrentAlertViewController.m
//  Egive-ipad
//
//  Created by kevin on 15/12/23.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGPrentAlertViewController.h"
#import "Language.h"
#import "MDHTMLLabel.h"
#import "EGLoginModel.h"
#import "MBProgressHUD.h"

@interface EGPrentAlertViewController ()<MDHTMLLabelDelegate>

@property (retain, nonatomic) UIScrollView *noteScrollView;

@end

@implementation EGPrentAlertViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    UIView* bgView= [[UIView alloc]init];
    bgView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer * imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction)];
    [bgView addGestureRecognizer:imageTap];
    
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //    make.edges.equalTo(sv
    UIView * contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
//        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));//top left bottom right.
    }];
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.text = self.title;
    titleLabel.backgroundColor=[UIColor colorWithHexString:@"#F1F2F3"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.leading.equalTo(contentView);
        make.height.mas_equalTo(40);
        make.trailing.equalTo(contentView);
    }];
    
    _noteScrollView = [[UIScrollView alloc]init];
    _noteScrollView.contentSize = CGSizeMake(0, 0);
    [_noteScrollView setShowsHorizontalScrollIndicator:NO];
    [_noteScrollView setShowsVerticalScrollIndicator:YES];
    [contentView addSubview:_noteScrollView];
    [_noteScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView).with.insets(UIEdgeInsetsMake(40, 0, 40, 0));
    }];
    
    UIButton* cancelButton = [[UIButton alloc]init];//44是nvBar高度
    cancelButton.backgroundColor = [UIColor colorWithHexString:@"#5CAF21"];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitle:HKLocalizedString(@"Common_button_close") forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelButton];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_noteScrollView.mas_bottom);
        make.leading.equalTo(_noteScrollView);
        make.bottom.equalTo(contentView);
        make.trailing.equalTo(_noteScrollView);
    }];
    
    
    [self getStaticPageContent];
}
-(void)closeAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)getStaticPageContent
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [EGLoginModel getStaticPageContentWithFormID:self.type block:^(NSDictionary *result, NSError *error) {
        if (!error) {
            [self parseHTML2:[result objectForKey:@"ContentText"]];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [UIAlertView alertWithText:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        }
    }];
    
}

- (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSRange r;
    while ((r = [JSONString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
        JSONString = [JSONString stringByReplacingCharactersInRange:r withString:@""];
        
    }
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    
    return responseJSON;
}
#pragma mark htmlPares
- (void)parseHTML2:(NSString *)htmlString
{
    MDHTMLLabel *htmlLabel = [[MDHTMLLabel alloc] init];
    htmlLabel.delegate = self;
    htmlLabel.numberOfLines = 0;
    htmlLabel.font = [UIFont systemFontOfSize:15];
    //htmlLabel.shadowColor = [UIColor whiteColor];
    //htmlLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    //htmlLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    htmlLabel.linkAttributes = @{
                                 NSForegroundColorAttributeName: [UIColor blackColor],
                                 //NSFontAttributeName: [UIFont systemFontOfSize:15],
                                 NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    
    htmlLabel.activeLinkAttributes = @{
                                       NSForegroundColorAttributeName: [UIColor blackColor],
                                       //NSFontAttributeName: [UIFont systemFontOfSize:15],
                                       NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    
    htmlLabel.htmlText = htmlString;
    
    [_noteScrollView addSubview:htmlLabel];
    
    CGRect rect = _noteScrollView.frame;
    
    CGSize maxSize = CGSizeMake(rect.size.width - 20, CGFLOAT_MAX);
    
    CGSize size = [htmlLabel sizeThatFits:maxSize];
    
    htmlLabel.frame = CGRectMake(10, 10, size.width, size.height);
    _noteScrollView.contentSize = CGSizeMake(0, size.height + 20);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
