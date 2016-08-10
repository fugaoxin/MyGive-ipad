//
//  EGNoticeViewController.m
//  Egive-ipad
//
//  Created by vincentmac on 15/12/17.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGNoticeViewController.h"
#import "TFHpple.h"
#import "FDLabelView.h"

#define kTitleFontH2   [UIFont systemFontOfSize:16]

@interface EGNoticeViewController ()

@property (nonatomic, assign) CGFloat currentY;

@property (weak, nonatomic) IBOutlet UIScrollView * noteView;

@end

@implementation EGNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self parseHTML:_content];
    
    _titleLabel.textColor = [UIColor colorWithHexString:@"#673291"];
    _titleLabel.text = HKLocalizedString(@"MyDonation_designationButton");
}

#pragma mark HTML数据解析
- (void)parseHTML:(NSString*)htmlString
{
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<br /><br />" withString:@"</p><p>"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"</span>" withString:@"</span></p><p>"];
    
    NSData *dataTitle=[htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *xpathParser=[[TFHpple alloc]initWithHTMLData:dataTitle];
    
    NSArray *elements=[xpathParser searchWithXPathQuery:@"//p"];
    
    [self parseElements:elements];
}

-(void)parseElements:(NSArray *)elements
{
    for (TFHppleElement *element in elements) {
        NSArray *childs=[element children];
        if (childs.count) {
            [self parseElements:childs];
        } else {
            //没有子节点
            if ([element.tagName isEqualToString:@"span"]) {
                
                [self addTitleText:element.content font:kTitleFontH2];
            } else if ([element.tagName isEqualToString:@"p"]) {
                
                [self addSubText:element.content];
            }
        }
    }
}
//添加文章标题
- (void)addTitleText:(NSString *)content font:(UIFont*)font {
    
    FDLabelView *titleView = [[FDLabelView alloc] initWithFrame:CGRectMake(10, _currentY, 300, 0)];
    //titleView.backgroundColor = [UIColor redColor];
    titleView.textColor = [UIColor colorWithRed:110/255.0 green:49/255.0 blue:139/255.0 alpha:1];
    //titleView.backgroundColor = [UIColor redColor];
    titleView.font = kTitleFontH2;
    titleView.minimumScaleFactor = 0.50;
    titleView.numberOfLines = 0;
    titleView.text = content;
    titleView.lineHeightScale = 0.90;
    titleView.fixedLineHeight = 25;
    titleView.fdLineScaleBaseLine = FDLineHeightScaleBaseLineCenter;
    titleView.fdTextAlignment = FDTextAlignmentLeft;
    titleView.fdAutoFitMode = FDAutoFitModeAutoHeight;
    titleView.fdLabelFitAlignment = FDLabelFitAlignmentCenter;
    titleView.contentInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    [_noteView addSubview:titleView];
    _currentY += titleView.visualTextHeight;
    [_noteView setContentSize:CGSizeMake(320, _currentY)];
}

//添加文章段落
- (void)addSubText:(NSString *)content {
    FDLabelView *titleView = [[FDLabelView alloc] initWithFrame:CGRectMake(10, _currentY, 300, 0)];
    titleView.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.00];
    titleView.textColor = [UIColor blackColor];
    //titleView.backgroundColor = [UIColor redColor];
    titleView.font = [UIFont systemFontOfSize:15];
    titleView.minimumScaleFactor = 0.50;
    titleView.numberOfLines = 0;
    titleView.text = content;
    titleView.lineHeightScale = 0.80;
    titleView.fixedLineHeight = 20;
    titleView.fdLineScaleBaseLine = FDLineHeightScaleBaseLineCenter;
    titleView.fdTextAlignment = FDTextAlignmentLeft;
    titleView.fdAutoFitMode = FDAutoFitModeAutoHeight;
    titleView.fdLabelFitAlignment = FDLabelFitAlignmentCenter;
    titleView.contentInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    [_noteView addSubview:titleView];
    
    _currentY += titleView.visualTextHeight;
    
    [_noteView setContentSize:CGSizeMake(320, _currentY)];
    
    titleView.debug = NO;
}

@end
