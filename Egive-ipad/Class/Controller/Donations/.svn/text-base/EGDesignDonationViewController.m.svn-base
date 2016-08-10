//
//  EGDesignDonationViewController.m
//  Egive-ipad
//
//  Created by vincentmac on 15/12/2.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGDesignDonationViewController.h"
#import "EGDonationModel.h"
#import "TFHpple.h"
#import "FDLabelView.h"
#import <MBProgressHUD.h>

// 字体
#define kTitleTextFont [UIFont systemFontOfSize:15]
#define kDescTextFont  [UIFont systemFontOfSize:12]
#define kTitleFontH2   [UIFont systemFontOfSize:16]

@interface EGDesignDonationViewController (){

    UIScrollView *_noteView;
}

@property (nonatomic, assign)CGFloat currentY;

@end

@implementation EGDesignDonationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
    //
//    _noteView = [[UIScrollView alloc] init];
//    _noteView.frame = (CGRect){0,20,WIDTH-200,self.view.bounds.size.height};
//    [self.view addSubview:_noteView];
    //
    
    
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [self.view addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(1);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{

    
}


-(void)viewDidDisappear:(BOOL)animated{

    
}


-(void)getInfo{
   
//    if (_noteView!=nil) {
//        [_noteView removeFromSuperview];
//        _noteView = nil;
//        _noteView = [[UIScrollView alloc] init];
//        _noteView.frame = (CGRect){0,20,WIDTH-200,self.view.bounds.size.height};
//        [self.view addSubview:_noteView];
//    }else{
//        _noteView = [[UIScrollView alloc] init];
//        _noteView.frame = (CGRect){0,20,WIDTH-200,self.view.bounds.size.height};
//        [self.view addSubview:_noteView];
//    }
    
    LanguageKey lang = [Language getLanguage];
    
    NSString *memberID = @"";
    
    NSString *LocationCode;
    NSString *location = [[NSUserDefaults standardUserDefaults] objectForKey:@"Location"];
    if (location && ([location isEqualToString:@"香港"] || [location isEqualToString:@"Hong Kong"])) {
        LocationCode = @"HK";
    }else{
        LocationCode = @"NonHK";
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString * soapMsg =[NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                         "<soap12:Body>"
                         "<GetShoppingCartDisclaimer xmlns=\"egive.appservices\">"
                         "<Lang>%ld</Lang>"
                         "<LocationCode>%@</LocationCode>"
                         "<MemberID>%@</MemberID>"
                         "</GetShoppingCartDisclaimer>"
                         "</soap12:Body>"
                         "</soap12:Envelope>",lang, LocationCode, memberID];
    
    [EGDonationModel getNoteWithParams:soapMsg block:^(NSString *result, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error) {
            
            _currentY = 0 ;
            [_noteView removeFromSuperview];
            _noteView = nil;
            _noteView = [[UIScrollView alloc] init];
            _noteView.frame = (CGRect){0,20,WIDTH-200,self.view.bounds.size.height};
            [self.view addSubview:_noteView];
            
            [self parseHTML:result];
        }else{
            
        }
    }];
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
                //MyLog(@"tagName:%@, content:%@", element.tagName, element.content);
                [self addTitleText:element.content font:kTitleFontH2];
            } else if ([element.tagName isEqualToString:@"p"]) {
                //MyLog(@"tagName:%@, content:%@", element.tagName, element.content);
                [self addSubText:element.content];
            }
        }
    }
}
//添加文章标题
- (void)addTitleText:(NSString *)content font:(UIFont*)font {
    
    FDLabelView *titleView = [[FDLabelView alloc] initWithFrame:CGRectMake(10, _currentY, _noteView.bounds.size.width-20, 0)];
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
    FDLabelView *titleView = [[FDLabelView alloc] initWithFrame:CGRectMake(10, _currentY, _noteView.bounds.size.width-20, 0)];
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
