//
//  EGMyAlertViewController.m
//  Egive-ipad
//
//  Created by sino on 15/11/26.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGMyAlertViewController.h"
#import "Language.h"
#import "MDHTMLLabel.h"
#import "EGLoginModel.h"

@interface EGMyAlertViewController ()<MDHTMLLabelDelegate>

@property (retain, nonatomic) UIScrollView *noteScrollView;

@end

@implementation EGMyAlertViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationBar cancelLeftItem];
    self.view.backgroundColor =[UIColor colorWithHexString:@"#F1F2F4"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _noteScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height-40-44-10*2)];
    _noteScrollView.backgroundColor = [UIColor whiteColor];
    _noteScrollView.contentSize = CGSizeMake(0, 0);
    [_noteScrollView setShowsHorizontalScrollIndicator:NO];
    [_noteScrollView setShowsVerticalScrollIndicator:YES];
    [self.view addSubview:_noteScrollView];
    
    UIButton* cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(30, self.size.height-40-44-10, self.size.width-30*2, 40)];//44是nvBar高度
    cancelButton.backgroundColor = [UIColor colorWithHexString:@"#5CAF21"];
    cancelButton.layer.cornerRadius = 5;
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitle:HKLocalizedString(@"Common_button_close") forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    [self getStaticPageContent];
}
-(void)closeAction
{
     [self.yqNavigationController  show:NO animated:YES];
    
}

-(void)getStaticPageContent
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [EGLoginModel getStaticPageContentWithFormID:self.type block:^(NSDictionary *result, NSError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            if (result) {
                [self parseHTML2:[result objectForKey:@"ContentText"]];
            }
            
        }else{
           
            [UIAlertView alertWithText:[error.userInfo objectForKey:@"NSLocalizedDescription"]?[error.userInfo objectForKey:@"NSLocalizedDescription"]:@"unknown error"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
