//
//  EGScoopImageShowViewController.m
//  Egive-ipad
//
//  Created by kevin on 16/1/4.
//  Copyright © 2016年 Sino. All rights reserved.
//

#import "EGScoopImageShowViewController.h"
#import "EGShareViewController.h"
@interface EGScoopImageShowViewController ()
{
    UIImageView *headIV;
    UILabel *titleLab;
    CGFloat imageWidth;
    CGFloat imageHeight;
}
@property (nonatomic,retain) UIScrollView* bottomsSV;
@property (nonatomic,retain) UIView* contantSV;
@property (nonatomic,retain) UIView* selectView;

@property (nonatomic,retain) NSMutableArray* imageViews;
@end

@implementation EGScoopImageShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.ItemModel.Title;
    UIView * barView=[self createNaviTopBarWithShowBackBtn:YES showTitle:YES];
    [self.navigationBackButton setBackgroundImage:[UIImage imageNamed:@"common_close"] forState:UIControlStateNormal];//重写方法 baseBackAction
    UIButton *shareBtnBg = [[UIButton alloc]initWithFrame:CGRectMake(barView.frame.size.width-44, 0, 44, 44)];
    
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, shareBtnBg.frame.size.height/2-(25)/2,25,25)];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"common_header_share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [shareBtnBg addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [shareBtnBg addSubview:shareBtn];
    [barView addSubview:shareBtnBg];
    
    _imageViews = [[NSMutableArray alloc]init];
    [self  createUI];
    
}
-(void)viewDidLayoutSubviews{
    [self updateUI:_selectImageTag];
}

-(void)createUI{

    imageWidth = (self.size.width-(60*2+5*2+10*4))/5;
    imageHeight = imageWidth;
    
    headIV =[ [UIImageView alloc]init];
    headIV.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:headIV];
    [headIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(self.size.width*0.75);
//        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-(imageWidth+20+(20+10+20)+10*2));
    }];
    //img is nil
        headIV.image = [UIImage imageNamed:@"dummy_case_related_default"];
        headIV.contentMode = UIViewContentModeScaleToFill;
    
    titleLab = [self createLabel:14];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.numberOfLines = 3;
//    titleLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headIV.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
//        make.height.mas_equalTo(20+10+30);
    }];
    

    UIButton* lBtn = [[UIButton alloc]init];
    [lBtn setImage:[UIImage imageNamed:@"event_album_l_arrow"] forState:UIControlStateNormal];
    [lBtn addTarget:self action:@selector(lBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:lBtn];
    [lBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(10);
        make.left.equalTo(self.contentView);
        make.width.mas_equalTo(60);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
    }];
    
    UIButton* rBtn = [[UIButton alloc]init];
    [rBtn setImage:[UIImage imageNamed:@"event_album_r_arrow"] forState:UIControlStateNormal];
    [rBtn addTarget:self action:@selector(rBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:rBtn];
    [rBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(10);
        make.right.equalTo(self.contentView);
        make.width.equalTo(lBtn);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
    }];
    
    _bottomsSV= [[UIScrollView alloc]init];
    _bottomsSV.backgroundColor = [UIColor whiteColor];
    _bottomsSV.userInteractionEnabled = YES;
    _bottomsSV.showsHorizontalScrollIndicator = NO;
    _bottomsSV.scrollEnabled = YES;

    [self.contentView addSubview:_bottomsSV];
    [_bottomsSV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(10);
        make.left.equalTo(lBtn.mas_right).offset(5);
        make.right.equalTo(rBtn.mas_left).offset(-5);
        make.height.mas_equalTo(imageHeight);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
    }];

    _contantSV = [UIView new];
    _contantSV.backgroundColor = [UIColor clearColor];
    _contantSV.userInteractionEnabled = YES;
    [_bottomsSV addSubview:_contantSV];
    
    [_contantSV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bottomsSV);
        make.height.equalTo(_bottomsSV);
        
    }];
    
    [self setScrollViewUI:self.ItemModel];
}
-(void)setScrollViewUI:(EGGiveItemModel*)ItemModel
{
    NSArray* Img = ItemModel.Img;
    NSURL *url = nil;

    for (int i =0; i<Img.count; i++) {
        UIImageView* iv =[ [UIImageView alloc]init];
        iv.backgroundColor = [UIColor clearColor];
        iv.userInteractionEnabled = YES;
        iv.tag = i;
        [_contantSV addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contantSV);
            make.left.equalTo(_contantSV).offset(i*(10+imageWidth));
            make.height.mas_equalTo(imageHeight);
            make.width.mas_equalTo(imageWidth);
        }];
        NSString *ImgURL =  Img[i][@"ImgURL"];
        url = [[NSURL URLWithString:SITE_URL] URLByAppendingPathComponent:ImgURL];
        [iv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"dummy_case_related_default"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
        iv.contentMode = UIViewContentModeScaleAspectFill;        // 设置图片正常填充
        iv.clipsToBounds = YES;
        
        UITapGestureRecognizer * imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
        [iv addGestureRecognizer:imageTap];
        [_imageViews addObject:iv];
    }

    [_contantSV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Img.count*(10+imageWidth));
    }];

}


-(void)updateUI:(int)selectTag
{
    UIImageView *iv = _imageViews[selectTag];
    [self createSelectView:iv];
    
    NSArray* Img = self.ItemModel.Img;
    NSURL *url = nil;
    NSString *ImgURL =  Img[selectTag][@"ImgURL"];
    NSString *ImgCaption =  Img[selectTag][@"ImgCaption"];
    url = [[NSURL URLWithString:SITE_URL] URLByAppendingPathComponent:ImgURL];
    
    [headIV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"dummy_case_related_default"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    headIV.contentMode = UIViewContentModeScaleAspectFit;
    
    titleLab.text = ImgCaption;
    CGSize maxSize = CGSizeMake(self.size.width - 10*2, CGFLOAT_MAX);
    CGSize size = [titleLab sizeThatFits:maxSize];
//    [titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(size.height);
//    }];
    //0开始
    if (selectTag > 1 && selectTag < Img.count-2) {
        [_bottomsSV setContentOffset:CGPointMake((imageWidth+10)*(selectTag-2), 0)];
    }
    else if(selectTag < 2){
        [_bottomsSV setContentOffset:CGPointMake(0, 0)];
    }
    else if(selectTag >= Img.count-2){
        if (Img.count>=5) {
             [_bottomsSV setContentOffset:CGPointMake((imageWidth+10)*(Img.count-5), 0)];
        }else{
            [_bottomsSV setContentOffset:CGPointMake(0, 0)];
        }
       
    }
    
}

-(void)createSelectView:(UIImageView* )inView
{
    for (UIImageView* sub in _imageViews) {
        sub.layer.borderWidth = 0;
        sub.layer.borderColor = [UIColor clearColor].CGColor;
    }
    inView.layer.borderWidth = 5;
    inView.layer.borderColor = tabarColor.CGColor;
}

-(UILabel*)createLabel:(CGFloat)fontSize
{
    UILabel* label =[[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:fontSize];
    return label;
}

#pragma mark Action
//重写方法
-(void)baseBackAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)shareBtnAction
{
//    2. 活動花絮- Egive - 活動花絮
     NSString* eventDtlName = self.ItemModel.Title;
    NSString * content = @"";
    NSString * subject = @"";
    if ([Language getLanguage]==1) {
        NSString *str = [NSString stringWithFormat:@"Egive - 活動花絮\n%@\n精彩活動花絮已上載，請瀏覽:%@/EventTitle.aspx?lang=1 \n\n意贈慈善基金\nEgive For You Charity Foundation\n電話: (852) 2210 2600\n電郵: info@egive4u.org",eventDtlName,SITE_URL];
        content = str;
        subject = [NSString stringWithFormat:@"Egive活動花絮 - %@",eventDtlName];
    }else if ([Language getLanguage]==2){
        NSString *str = [NSString stringWithFormat:@"Egive - 活动花絮\n%@\n精彩活动花絮已上载，请浏览:%@/EventTitle.aspx?lang=2 \n\n意赠慈善基金\nEgive For You Charity Foundation\n电話: (852) 2210 2600\n电邮: info@egive4u.org",eventDtlName,SITE_URL];
        content = str;
        subject = [NSString stringWithFormat:@"Egive活动花絮 - %@",eventDtlName];
    }else{
        
        NSString * str = [NSString stringWithFormat:@"Egive - Event Highlights\n%@\nPlease visit %@/EventTitle.aspx?lang=3 for more event highlights!\n\nEgive For You Charity Foundation\nTel: (852) 2210 2600\nEmail: info@egive4u.org",eventDtlName,SITE_URL];
        content = str;
        subject = [NSString stringWithFormat:@"Egive - Event Highlights %@",eventDtlName];
    }
    UIImageView* iv = nil;//to do
//    http://www.egiveforyou.com/EventDetail.aspx?EventID
    
    if(_imageViews.count>0){
        
        for (UIImageView *vv in _imageViews) {
            if (_selectImageTag == vv.tag ) {
                
                iv = vv;
                
            }
        }
        
       
    }
    
    
    
    
    
    //?iv.image:[UIImage imageNamed:@"dummy_case_related_default"]  iv.image?iv.image:[UIImage imageNamed:@"dummy_case_related_default"] 设置了图片也没用，根据网页端的图片来显示的图片
    
    DLOG(@"%@",[SITE_URL stringByAppendingString:[NSString stringWithFormat:@"/EventDetail.aspx?EventID=%@&lang=%ld",self.ItemModel.EventID,[Language getLanguage]]]);
    
    EGShareViewController * shareVC= [[EGShareViewController alloc]initWithSubject:subject content:content url:[SITE_URL stringByAppendingString:[NSString stringWithFormat:@"/EventDetail.aspx?EventID=%@&lang=%ld",self.ItemModel.EventID,[Language getLanguage]]] image:iv.image?iv.image:[UIImage imageNamed:@"dummy_case_related_default"] Block:nil];
    [shareVC showShareUIWithPoint:CGPointMake(self.size.width-22, 0) view:self.contentView permittedArrowDirections:UIPopoverArrowDirectionUp];
}
-(void)lBtnAction
{
    if (_selectImageTag > 0) {
        _selectImageTag -= 1;
        [self updateUI:_selectImageTag];
    }
    
}
-(void)rBtnAction
{
    if (_selectImageTag < _imageViews.count-1) {
        _selectImageTag += 1;
         [self updateUI:_selectImageTag];
    }
   
}
-(void)imageTapAction:(UITapGestureRecognizer*)tap
{
    
    UIImageView *iv = (UIImageView * )tap.view;
    _selectImageTag  = iv.tag;
   [self updateUI:_selectImageTag];
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
