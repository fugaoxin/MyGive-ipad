//
//  EGStaticPageController.m
//  Egive-ipad
//
//  Created by 123 on 15/12/26.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGStaticPageController.h"

#define myW screenWidth-screenWidth/3-64
#define myH screenHeight-64

@interface EGStaticPageController ()<UIScrollViewDelegate>

@property (nonatomic, strong)UIImageView *sliderView;
@property (nonatomic, assign) NSInteger titleSize;
@property (nonatomic, assign) NSInteger subTitleSize;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, strong)NSMutableArray *labelViews;

@end

@implementation EGStaticPageController

- (NSMutableArray *)labelViews
{
    if (!_labelViews) {
        _labelViews = [NSMutableArray array];
    }
    return _labelViews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleSize = 22;
    _subTitleSize = 20;
}

- (void)getStaticPageContentWithContentText:(NSString*)ContentText{
    
    [self parseHTML:ContentText];
}

- (void)parseHTML:(NSString*)htmlString{
    //NSLog(@"htmlString = %@", htmlString);
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<p>1." withString:@"<p>　1."];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<br />2." withString:@"</p><p>　2."];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<br />3." withString:@"</p><p>　3."];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<br />4." withString:@"</p><p>　4."];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    NSData *dataTitle=[htmlString dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *xpathParser=[[TFHpple alloc]initWithHTMLData:dataTitle];
    NSArray *elements=[xpathParser searchWithXPathQuery:@"//ul"];
    [self parseElements:elements];
}


-(void)parseElements:(NSArray *)elements
{
    for (TFHppleElement *element in elements) {
        NSArray *childs=[element children];
        if (childs.count) {
            
            if ([element.tagName isEqualToString:@"video"]) {
                NSString *videoSrc = [element objectForKey:@"src"];
                NSURL *imageURL = [NSURL URLWithString:SITE_URL];
                imageURL = [imageURL URLByAppendingPathComponent:videoSrc];
                [self addSubImageView:imageURL];
            }
            else if ([[element objectForKey:@"class"] isEqualToString:@"chairmantitle"]) {
                NSString *chairmantitle = [element content];
                TFHppleElement *signature = [element firstChild];
                chairmantitle = [NSString stringWithFormat:@"%@\n%@",chairmantitle,signature.content];
                [self addTitleText:chairmantitle font:kTitleFontH2];
            } else if ([element.tagName isEqualToString:@"table"]) {
                NSArray *trs=[element children];
                NSString *str_tr = @"";
                for (TFHppleElement *tr in trs) {
                    
                    NSArray *tds=[tr children];
                    for (TFHppleElement *td in tds) {
                        str_tr = [str_tr stringByAppendingString:@" "];
                        str_tr = [str_tr stringByAppendingString:[td content]];
                    }
                    str_tr = [str_tr stringByAppendingString:@"\n"];
                }
                [self addSubText:str_tr];
            } else {
                [self parseElements:childs];
            }
        } else {
            //没有子节点
            if ([element.tagName isEqualToString:@"img"]) {
                NSString *imgSrc = [element objectForKey:@"src"];
                NSURL *imageURL = [NSURL URLWithString:SITE_URL];
                imageURL = [imageURL URLByAppendingPathComponent:imgSrc];
                [self addSubImageView:imageURL];
                
            } else if ([element.tagName isEqualToString:@"span"]) {
            } else if ([element.tagName isEqualToString:@"h2"]) {
                [self addTitleText:element.content font:kTitleFontH2];
            } else if ([element.tagName isEqualToString:@"p"]) {
                [self addSubText:element.content];
            }
            
        }
    }
}

- (void)addSubImageView:(NSURL *)imageURL {
    
    
    
}

//添加文章标题
- (void)addTitleText:(NSString *)content font:(UIFont*)font {
    
    FDLabelView *titleView = [[FDLabelView alloc] initWithFrame:CGRectMake(10, currentY, myW - 20, 0)];
    //titleView.backgroundColor = [UIColor redColor];
    titleView.textColor = [UIColor colorWithRed:110/255.0 green:49/255.0 blue:139/255.0 alpha:1];
    titleView.font = [UIFont systemFontOfSize:_titleSize];
    titleView.minimumScaleFactor = 0.50;
    titleView.numberOfLines = 0;
    titleView.text = content;
    titleView.tag = 1;
    titleView.lineHeightScale = 0.90;
    titleView.fixedLineHeight = 25;
    titleView.fdLineScaleBaseLine = FDLineHeightScaleBaseLineCenter;
    titleView.fdTextAlignment = FDTextAlignmentLeft;
    titleView.fdAutoFitMode = FDAutoFitModeAutoHeight;
    titleView.fdLabelFitAlignment = FDLabelFitAlignmentCenter;
    titleView.contentInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    [mScrollView addSubview:titleView];
    currentY += titleView.visualTextHeight;
    [mScrollView setContentSize:CGSizeMake(myW, currentY)];
    [self.labelViews addObject:titleView];
}

//添加文章段落
- (void)addSubText:(NSString *)content {
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, currentY, myW-40, 0);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:_subTitleSize];
    label.minimumScaleFactor = 0.50;
    label.numberOfLines = 0;
    label.text = content;
    label.tag = 0;
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = 20.f;
    style.maximumLineHeight = 20.f;
    NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,};
    label.attributedText = [[NSAttributedString alloc] initWithString:content
                                                           attributes:attributtes];
    [label sizeToFit];
    
    [mScrollView addSubview:label];
    currentY += label.frame.size.height /* .visualTextHeight*/ + 20;
    [mScrollView setContentSize:CGSizeMake(myW - 40, currentY)];
    
    [self.labelViews addObject:label];
    //    titleView.debug = NO;
}

-(void)addMySlider{
    self.sliderView=[[UIImageView alloc] initWithFrame:CGRectMake(20, myH - 67, myW - 40, 47)];
    self.sliderView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    self.sliderView.layer.cornerRadius = 3;
    self.sliderView.layer.masksToBounds = YES;
    self.sliderView.hidden = YES;
    self.sliderView.userInteractionEnabled=YES;
    [self.view addSubview:self.sliderView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 27, 27)];
    label1.font = [UIFont systemFontOfSize:16];
    label1.text = @"A";
    [self.sliderView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake( self.sliderView.frame.size.width - 30, 10, 27, 27)];
    label2.font = [UIFont systemFontOfSize:22];
    label2.text = @"A";
    [self.sliderView addSubview:label2];
    
    UISlider *sliderA=[[UISlider alloc]initWithFrame:CGRectMake(25, 20, self.sliderView.frame.size.width - 60, 7)];
    sliderA.backgroundColor = [UIColor clearColor];
    sliderA.value=0.5;
    sliderA.minimumValue=0.0;
    sliderA.maximumValue=1.0;
    //_slider = sliderA;
    
    //滑块拖动时的事件
    [sliderA addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.sliderView addSubview:sliderA];
    
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [mScrollView addGestureRecognizer:longPressGr];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDo:)];
    [mScrollView addGestureRecognizer:tapGr];
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    if (!_sliderView.hidden) {
//        _sliderView.hidden = YES;
//    }
//}

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

-(void)sliderValueChanged:(UISlider *)sender{
    float value = sender.value;
    float change = 4*(value - 0.5);
    for (FDLabelView *view in _labelViews) {
        
        CGFloat fontSize;
        if (view.tag) {
            fontSize = _titleSize + change;
        } else {
            fontSize = _subTitleSize +change;
        }
        view.font = [UIFont systemFontOfSize:fontSize];
        if (self.aboutString==nil) {
            [view sizeToFit];
        }
    }
    
    NSInteger count = _labelViews.count;
    if (count) {
        CGFloat offY = CGRectGetMaxY(((FDLabelView*)[_labelViews firstObject]).frame) + 10;
        for (int i = 1; i < count; i++) {
            FDLabelView *view = _labelViews[i];
            CGRect frame = view.frame;
            frame.size.width = myW - 30;
            frame.origin.y = offY;
            view.frame = frame;
            offY = CGRectGetMaxY(view.frame) + 10;
        }
        [mScrollView setContentSize:CGSizeMake(0, offY)];
        
    }
}

@end
