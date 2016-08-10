//
//  EGFAQPageController.m
//  Egive-ipad
//
//  Created by 123 on 15/12/26.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGFAQPageController.h"

@interface EGFAQPageController ()<UIScrollViewDelegate,MDHTMLLabelDelegate>

@end

@implementation EGFAQPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    currentY = 0;
    mScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth-screenWidth/3-64, screenHeight-64)];
    mScrollView.backgroundColor = [UIColor clearColor];
//    mScrollView.userInteractionEnabled=YES;
    mScrollView.delegate = self;
    mScrollView.maximumZoomScale=3.0;
//    mScrollView.zoomScale=1.5;
    mScrollView.minimumZoomScale=0.5;
    [self.view addSubview:mScrollView];
    
    UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 2.5, screenHeight-64)];
    label.backgroundColor=[UIColor grayColor];
    label.alpha=0.2;
    [self.view addSubview:label];
    
    [self getStaticPageContentWithContentText:self.ContentText];
}

-(void)shareAction{
    
    LanguageKey lang = [Language getLanguage];
    NSString * string = @"";
    NSString * subject = @"";
    if (lang==1) {
        NSString *str = @"Egive - 常見問題  http://www.egive4u.org/FAQ.aspx\n\n請瀏覽: http://www.egive4u.org/\n\n意贈慈善基金\nEgive For You Charity Foundation\n電話: (852) 2210 2600\n電郵: info@egive4u.org";
        string = str;
        subject = @"Egive - FAQ";
        
    }else if (lang==2){
        NSString *str = @"Egive - 常见问题  http://www.egive4u.org/FAQ.aspx\n\n请浏览: http://www.egive4u.org/\n\n意赠慈善基金\nEgive For You Charity Foundation\n电话: (852) 2210 2600\n电邮: info@egive4u.org";
        string = str;
        subject = @"Egive - 常见问题";
    }else{
        
        NSString * str = [NSString stringWithFormat:@"Egive - FAQ www.egive4u.org/FAQ.aspx\n\nVisit us at www.egive4u.org\n\nEgive For You Charity Foundation\nTel: (852) 2210 2600\nEmail: info@egive4u.org"];
        string = str;
        subject = @"Egive - 常見問題";
    }
    
    //[MenuViewController shareToSocialNetworkWithSubject:subject content:string url:nil image:nil];
}

- (void)parseHTML:(NSString*)htmlString
{
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    NSData *dataTitle=[htmlString dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *xpathParser=[[TFHpple alloc]initWithHTMLData:dataTitle];
    NSArray *elements=[xpathParser searchWithXPathQuery:@"//img"];
    
    [self parseElements:elements];
}

- (void)addSubImageView:(NSURL *)imageURL {
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        CGFloat height = (screenWidth-screenWidth/3-40-60)/image.size.width * image.size.height;
        CGRect rect = CGRectMake(15, currentY, screenWidth-screenWidth/3-40-60, height);
        currentY += height + 10;
        imageView.frame = rect;
        imageView.tag = 100;
        [mScrollView setContentSize:CGSizeMake(screenWidth-screenWidth/3-60, currentY)];
    }];
    [mScrollView addSubview:imageView];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIImageView * view=(UIImageView *)[mScrollView viewWithTag:100];
    return view;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

@end
