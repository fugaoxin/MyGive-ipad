//
//  EGHomeTableViewCell.m
//  Egive-ipad
//
//  Created by User01 on 15/11/19.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGHomeTableViewCell.h"
#import "EGHomeCellView.h"
#import "EGLoginViewController.h"

@interface EGHomeTableViewCell ()

@property (nonatomic,strong) UIImageView * PictureImageView;
@property (strong, nonatomic) UIProgressView * progress;
@property (nonatomic,strong) UIButton * favouriteButton;//收藏按钮

@property (strong, nonatomic) EGBaseModel * Model;
@property (strong, nonatomic) NSMutableArray * dataArray;

@property (nonatomic,strong) EGLoginTool * EGLT;

@property (nonatomic,strong) UIImageView * ZTView;

//@property (nonatomic,strong) UIImageView * clickView;//最后一个View

@property (nonatomic,assign) BOOL mybool;

@end

@implementation EGHomeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor=[UIColor colorWithRed:233/255.0 green:234/255.0 blue:235/255.0 alpha:1];
        self.EGLT=[EGLoginTool loginSingleton];
    }
    return self;
}

-(void)setDataArray:(NSMutableArray *)Array andIndex:(int)index andID:(NSMutableArray *)IDarray andBool:(BOOL)mybool andTypes:(NSString *)Types
{
    self.mybool=mybool;
    self.dataArray=Array;
    for(UIImageView * IV in self.subviews)
    {
        [IV removeFromSuperview];
    }
    for (int i=0; i<Array.count; i++) {
        EGHomeModel * Model=[[EGHomeModel alloc] init];
        [Model setDictionary:Array[i]];
        //NSString *  URL = [SITE_URL stringByAppendingPathComponent:[[Array[i] objectForKey:@"ProfilePicURL"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
        NSString *  URL = [SITE_URL stringByAppendingPathComponent:[Model.ProfilePicURL stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
        self.PictureImageView=[[UIImageView alloc] init];
        if (index==0) {
            self.PictureImageView.frame=CGRectMake(28+((screenWidth-64-106)/3+26)*i, 29, (screenWidth-64-106)/3, (((screenWidth-64-106)/3)*3)/4);
        }
        else
        {
            self.PictureImageView.frame=CGRectMake(28+((screenWidth-64-106)/3+26)*i, 25, (screenWidth-64-106)/3, (((screenWidth-64-106)/3)*3)/4);
        }
        //CGRectMake(10+((screenWidth-64-40)/3+10)*i, 25, (screenWidth-64-40)/3, (((screenWidth-64-40)/3)*3)/4);
        //self.PictureImageView.backgroundColor=[UIColor redColor];
        self.PictureImageView.tag=i+index*3;
        self.PictureImageView.userInteractionEnabled=YES;
        //[self.PictureImageView sd_setImageWithURL:[NSURL URLWithString:URL]];
        //[self.PictureImageView sd_setImageWithURL:[NSURL URLWithString:URL] placeholderImage:[UIImage imageNamed:@"dummy_case_related_default"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
        [self.PictureImageView sd_setImageWithURL:[NSURL URLWithString:URL] placeholderImage:[UIImage imageNamed:@"dummy_case_related_default"]];
        [self addSubview:self.PictureImageView];
        //NSLog(@"Array===%@",Array);
        UITapGestureRecognizer * TGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPictureImageView:)];
        [self.PictureImageView addGestureRecognizer:TGR];
        
        if ([Types isEqualToString:@"home"]) {
            if (Array.count<3) {
                self.clickView=[[UIImageView alloc] initWithFrame:CGRectMake(28+((screenWidth-64-106)/3+26)*Array.count, 25, (screenWidth-64-106)/3, (((screenWidth-64-106)/3)*3)/4)];

                self.clickView.backgroundColor=tabarColor;
                self.clickView.userInteractionEnabled=YES;
                //[self.PictureImageView sd_setImageWithURL:[NSURL URLWithString:URL]];
                [self addSubview:self.clickView];
                
                UITapGestureRecognizer * TGRR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLastPictureImageView:)];
                [self.clickView addGestureRecognizer:TGRR];
                
                UIImageView * IA=[[UIImageView alloc] initWithFrame:CGRectMake((self.clickView.frame.size.width-69)/2, 50, 69, 77)];
                IA.image=[UIImage imageNamed:@"home_donation"];
                
                UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake((self.clickView.frame.size.width-200)/2, IA.frame.size.height+IA.frame.origin.y+10, 200, 40)];
                //lab.backgroundColor=[UIColor redColor];
                lab.textAlignment=NSTextAlignmentCenter;
                lab.font=[UIFont systemFontOfSize:22];
                lab.textColor=[UIColor whiteColor];
                lab.text=[HKLocalizedString(@"MenuView_girdButton_title") stringByReplacingOccurrencesOfString:@"\n" withString:@" "];;
                
                UILabel * labb=[[UILabel alloc] initWithFrame:CGRectMake(0, self.clickView.frame.size.height-45, self.clickView.frame.size.width, 30)];
                //labb.backgroundColor=[UIColor redColor];
                labb.textAlignment=NSTextAlignmentCenter;
                labb.font=[UIFont systemFontOfSize:16];
                labb.textColor=[UIColor whiteColor];
                labb.alpha=0.6;
                labb.text=HKLocalizedString(@"查看更多不同类型的专案");
                
                [self.clickView addSubview:IA];
                [self.clickView addSubview:lab];
                [self.clickView addSubview:labb];
            }
        }
        
        self.favouriteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        self.favouriteButton.tag=500+i;
        [self.PictureImageView addSubview:self.favouriteButton];
        [self.favouriteButton setBackgroundImage:[UIImage imageNamed:@"comment_poster_favourite_nor"] forState:UIControlStateNormal];
        [self.favouriteButton setBackgroundImage:[UIImage imageNamed:@"comment_poster_favourite_sel"] forState:UIControlStateSelected];
        if (Model.Isfavourite) {
            self.favouriteButton.selected=YES;
        }
        
        [self.favouriteButton addTarget:self action:@selector(clickFavour:) forControlEvents:UIControlEventTouchUpInside];
        
        self.ZTView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
        self.ZTView.image=[UIImage imageNamed:@"comment_poster_complete"];
        [self.PictureImageView addSubview:self.ZTView];
        self.ZTView.hidden=YES;
        UILabel * succeedLabel =[[UILabel alloc] initWithFrame:CGRectMake(-5, 20, 70, 20)];
        [self.ZTView addSubview:succeedLabel];
        succeedLabel.text=HKLocalizedString(@"筹募");
        //[_succeedImage addLabelWithFrame:CGRectMake(-5, 20, 70, 20) text:EGLocalizedString(@"筹募", nil)];
        succeedLabel.textAlignment = NSTextAlignmentCenter;
        succeedLabel.font = [UIFont systemFontOfSize:13];
        succeedLabel.textColor = [UIColor whiteColor];
        succeedLabel.transform = CGAffineTransformMakeRotation(-M_PI/4);
        
        [self setPurpleView:Model and:i andID:IDarray];
    }
    
}

//收藏
-(void)clickFavour:(UIButton *)button
{
    if (self.EGLT.isLoggedIn) {
        button.selected=!button.selected;
    }
    if (button.selected) {
        //DLOG(@"shou");
        [self.delegate AddCaseFavourite:[self.dataArray[button.tag-500] objectForKey:@"CaseID"]];
    }
    else
    {
        //DLOG(@"fan");
        [self.delegate DeleteCaseFavourite:[self.dataArray[button.tag-500] objectForKey:@"CaseID"]];
    }
}

-(void)setPurpleView:(EGHomeModel *)Model and:(int)i andID:(NSMutableArray *)IDarray
{
    NSDictionary * dictionary= @{@"S":@"comment_poster_type_education",//助学
                                 @"E":@"comment_poster_type_elder",//安老
                                 @"U":@"comment_poster_type_emergency",//紧急救援
                                 @"M":@"comment_poster_type_medical",//助医
                                 @"P":@"comment_poster_type_poverty",//扶贫
                                 @"A":@"comment_poster_type_case_list",//意增行动
                                 @"O":@"comment_poster_type_others"};//其它
    NSArray * array=@[@"O",@"S",@"E",@"M",@"P",@"U",@"A"];//排序
    EGHomeCellView * view = [[EGHomeCellView alloc] initWithFrame:CGRectMake(0, (((screenWidth-64-106)/3)*3)/4-80, self.PictureImageView.frame.size.width, 80)];
    view.alpha=0.8;
    [self.PictureImageView addSubview:view];
    view.backgroundColor=tabarColor;
    if (Model.Category.length>0) {
        //view.typeImage.image=[UIImage imageNamed:[dictionary objectForKey:[Model.Category substringToIndex:1]]];
        NSString * okStr=@"";
        for (int i=0; i<array.count; i++) {
            if ([okStr isEqualToString:@"ok"]) {
                break;
            }
            for (int j=0; j<Model.Category.length; j++) {
                NSString * str=[NSString stringWithFormat:@"%c",[Model.Category characterAtIndex:j]];
                if ([array[i] isEqualToString:str]) {
                    view.typeImage.image=[UIImage imageNamed:[dictionary objectForKey:str]];
                    okStr=@"ok";
                }
            }
        }
    }
    else
    {
        view.typeImage.image=[UIImage imageNamed:[dictionary objectForKey:@"O"]];
    }
    view.titleLabel.text = [NSString stringWithFormat:@"%@(%@)",Model.Title,Model.Region];
    //view.timeLabel.text = [NSString stringWithFormat:@"%@%@%@",HKLocalizedString(@"GirdView_time_label"),Model.RemainingValue,Model.RemainingUnit];
    LanguageKey lang = [Language getLanguage];
    if ([Model.RemainingValue intValue]>0) {
        if (lang==1||lang==2) {
            view.timeLabel.text = [NSString stringWithFormat:@"%@%@%@",HKLocalizedString(@"GirdView_time_label"),Model.RemainingValue,Model.RemainingUnit];
        }
        else
        {
            view.timeLabel.text = [NSString stringWithFormat:@"%@ %@ To Go",Model.RemainingValue,Model.RemainingUnit];
        }
    }
    else
    {
        view.timeLabel.text =HKLocalizedString(@"GirdView_time");
    }

    //view.peopleLabel.text=[NSString stringWithFormat:@"%@%@",HKLocalizedString(@"GirdView_count_label"),Model.DonorCount];
    if (lang==1||lang==2) {
        view.peopleLabel.text=[NSString stringWithFormat:@"%@%@",HKLocalizedString(@"GirdView_count_label"),Model.DonorCount];
    }
    else
    {
        //view.peopleLabel.text=[NSString stringWithFormat:@"%@%@",Model.DonorCount,@" of Donors"];
        view.peopleLabel.text=[NSString stringWithFormat:@"%@%@",HKLocalizedString(@"GirdView_count_label"),Model.DonorCount];
    }
    if (self.mybool) {
        if (lang==1||lang==2) {
            view.moneyLabel.text=[NSString stringWithFormat:@"%@:$%@",HKLocalizedString(@"HomePage_atm_label"),Model.Amt];
        }
        else
        {
            view.moneyLabel.text=[NSString stringWithFormat:@"%@:$%@",@"Raised",Model.Amt];
        }
    }
    else
    {
        if (lang==1||lang==2) {
            view.moneyLabel.text=[NSString stringWithFormat:@"%@:$%@",HKLocalizedString(@"HomePage_target_label"),Model.TargetAmt];
        }
        else
        {
            view.moneyLabel.text=[NSString stringWithFormat:@"%@:$%@",@"Target",Model.TargetAmt];
        }
    }
    
    for (NSString * str in IDarray) {
        if ([str isEqualToString:Model.CaseID]) {
            view.CollectButton.selected = YES;
        }
    }
    [view.CollectButton setImage:[UIImage imageNamed:@"common_cart_nor"] forState:UIControlStateNormal];
    [view.CollectButton setImage:[UIImage imageNamed:@"common_cart_sel"] forState:UIControlStateSelected];
    view.CollectButton.tag=10+i;
    [view.CollectButton addTarget:self action:@selector(clickCollectButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * lineLLabel=[[UILabel alloc] initWithFrame:CGRectMake(190, 5, 2, 40)];
    lineLLabel.backgroundColor=[UIColor whiteColor];
    lineLLabel.alpha=0.5;
    
    UILabel * lineDLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.PictureImageView.frame.size.width, 1)];
    lineDLabel.backgroundColor=[UIColor whiteColor];
    lineDLabel.alpha=0.5;
    
    [view addSubview:lineLLabel];
    [view addSubview:lineDLabel];
    
    self.progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progress.frame = CGRectMake(40, 37, 85, 2);
    //self.progress.backgroundColor=[UIColor redColor];
    self.progress.layer.cornerRadius = 3;
    self.progress.layer.masksToBounds = YES;
    self.progress.transform = CGAffineTransformMakeScale(1.0f,3.0f);
    //设置进度条左边的进度颜色
    [self.progress setProgressTintColor:[UIColor colorWithRed:255/255.0 green:175/255.0 blue:35/255.0 alpha:1]];
    //设置进度条右边的进度颜色
    [self.progress setTrackTintColor:[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1]];
    [view addSubview:self.progress];
    if (Model.Percentage >= 100) {
        self.ZTView.hidden=NO;
        [self.progress setProgressTintColor:progressBar];
        //[UIColor colorWithRed:185/255.0 green:55/255.0 blue:83/255.0 alpha:1]
        self.progress.progress=1;
        view.valueLabel.text = [NSString stringWithFormat:@"100%%"];
        //把图片添加到动态数组
        NSMutableArray * animateArray = [[NSMutableArray alloc]initWithCapacity:2];
        [animateArray addObject:[UIImage imageNamed:@"comment_progress_heart_nor"]];
        [animateArray addObject:[UIImage imageNamed:@"comment_progress_heart_mid"]];
        [animateArray addObject:[UIImage imageNamed:@"comment_progress_heart_complete"]];
        //为图片设置动态
        view.yellowButton.animationImages = animateArray;
        //为动画设置持续时间
        view.yellowButton.animationDuration = 0.5;
        //为默认的无限循环
        view.yellowButton.animationRepeatCount = 0;
        //开始播放动画
        [view.yellowButton startAnimating];
    }else{
        view.yellowButton.image=[UIImage imageNamed:@"comment_progress_heart_nor"];
        self.progress.progress=Model.Percentage/100.0;
        view.valueLabel.text = [NSString stringWithFormat:@"%2.f%%",Model.Percentage];
    }
    UIImageView * people=[[UIImageView alloc] init];
    if (self.progress.progress>0.82) {
        people.frame=CGRectMake(40+85*0.82-12, 25, 25, 25);
    }
    else
    {
        people.frame=CGRectMake(40+85*self.progress.progress-12, 25, 25, 25);
    }
    if (self.progress.progress<0.5) {
       people.image=[UIImage imageNamed:@"comment_detail_progress_run_1"];
    }
    else
    {
        if (self.progress.progress<0.9999) {
            people.image=[UIImage imageNamed:@"comment_detail_progress_run_2"];//临界点设为0.85
        }
    }
    [view addSubview:people];
}

//购物车
-(void)clickCollectButton:(UIButton *)but
{
    [self.delegate saveShoppingCartItem:[self.dataArray[but.tag-10] objectForKey:@"CaseID"] andBut:but andRemainingValue:[self.dataArray[but.tag-10] objectForKey:@"RemainingValue"] andIsSuccess:[self.dataArray[but.tag-10] objectForKey:@"IsSuccess"] andStyleStr:@"NO"];
    //NSLog(@"www===%lu",but.tag);
    if (!([[self.dataArray[but.tag-10] objectForKey:@"RemainingValue"] intValue] == 0||
        [[self.dataArray[but.tag-10] objectForKey:@"IsSuccess"] intValue] == 1)) {
       but.selected=YES;
    }
}

-(void)clickLastPictureImageView:(UITapGestureRecognizer *)TGRR
{
    [self.delegate clickLastView];
}

-(void)clickPictureImageView:(UITapGestureRecognizer *)TGR
{
    [self.delegate clickView:self.dataArray[(int)TGR.view.tag%3] and:(int)TGR.view.tag];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
