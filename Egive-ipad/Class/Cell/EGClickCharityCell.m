//
//  EGClickCharityCell.m
//  Egive-ipad
//
//  Created by User01 on 15/11/30.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGClickCharityCell.h"

@interface EGClickCharityCell ()

@property (nonatomic,strong) UIImageView * PictureImageView;
@property (nonatomic,strong) UILabel * titleLabel;//标题
@property (nonatomic,strong) UIImageView * categoryImage;//标识
@property (nonatomic,strong) UILabel * moneyLabel;//已筹金额
@property (nonatomic,strong) UILabel * timeLabel; //剩余时间
@property (nonatomic,strong) UILabel * peopleLabel;//赞助人数

@property (strong, nonatomic) UIProgressView * progress;//进度条
@property (nonatomic,strong) UIImageView * people;//人图像
@property (nonatomic,strong) UIImageView * heartImage;//心按钮
@property (nonatomic,strong) UILabel * proportionLabel;//比例

@property (nonatomic,strong) UIImageView * bgImageView;//关注&捐款背景
@property (nonatomic,strong) UIButton * attentionButton;//关注
@property (nonatomic,strong) UIButton * donationButton;//捐款

@property (nonatomic,assign) int index;//关注&捐款
@property (nonatomic,strong) NSMutableArray * IDArray;//购物车ID数组

@property (nonatomic,strong) NSString * RemainingString;//剩下天数
@property (nonatomic,assign) BOOL Success;
@property (nonatomic,strong) NSString * caseId;//

@property (nonatomic,strong) EGLoginTool * EGLT;//登陆判断

@property (nonatomic,strong) UIImageView * ZTView;

@end

@implementation EGClickCharityCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //self.backgroundColor=[UIColor colorWithRed:233/255.0 green:234/255.0 blue:235/255.0 alpha:1];
        self.backgroundColor=[UIColor whiteColor];
        self.EGLT=[EGLoginTool loginSingleton];
    }
    return self;
}

#pragma mark - 点击关注按钮
-(void)clickAttention:(UIButton *)button
{
    //DLOG(@"关注===%d",self.index);
    if (self.EGLT.isLoggedIn) {
        button.selected=!button.selected;
    }
    if (button.selected) {
        button.backgroundColor=greeBar;
        [self.delegate AddAttention:self.caseId];
    }
    else
    {
        button.backgroundColor=tabarColor;
        [self.delegate DeleteAttention:self.caseId];
    }
}

#pragma mark - 点击捐款按钮
-(void)clickDonation:(UIButton *)button
{
    [self.delegate AddDonation:self.caseId andBut:button andRemainingValue:self.RemainingString andIsSuccess:self.Success andStyleStr:@"NO"];
    if (!([self.RemainingString intValue] == 0||self.Success==1)) {
        button.backgroundColor=greeBar;
        button.selected=YES;
    }
}

-(void)setViewModel:(EGHomeModel *)model andIndex:(int)index
{
    UILabel * lineLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, (screenWidth-64)*2/5, 5)];
    
    self.PictureImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 120, 95-5)];
    
    self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.PictureImageView.frame.origin.x+self.PictureImageView.frame.size.width+10, self.PictureImageView.frame.origin.y, 180, 25)];
    
    self.categoryImage=[[UIImageView alloc] initWithFrame:CGRectMake((screenWidth-64)*2/5-30, 5, 25, 25)];
    
    self.moneyLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.PictureImageView.frame.origin.x+self.PictureImageView.frame.size.width+10, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height, 180, 20)];
    self.moneyLabel.font=[UIFont systemFontOfSize:14];
    
    self.progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progress.frame = CGRectMake(self.PictureImageView.frame.origin.x+self.PictureImageView.frame.size.width+10, self.moneyLabel.frame.origin.y+self.moneyLabel.frame.size.height+10, 180, 2);
    self.progress.layer.cornerRadius = 3;
    self.progress.layer.masksToBounds = YES;
    self.progress.transform = CGAffineTransformMakeScale(1.0f,3.0f);
    //设置进度条左边的进度颜色
    [self.progress setProgressTintColor:[UIColor colorWithRed:255/255.0 green:175/255.0 blue:35/255.0 alpha:1]];
    //设置进度条右边的进度颜色
    [self.progress setTrackTintColor:[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1]];
    
    self.people=[[UIImageView alloc] initWithFrame:CGRectMake(self.PictureImageView.frame.origin.x+self.PictureImageView.frame.size.width, self.moneyLabel.frame.origin.y+self.moneyLabel.frame.size.height, 20, 20)];
    
    self.heartImage=[[UIImageView alloc] initWithFrame:CGRectMake(self.progress.frame.origin.x+self.progress.frame.size.width-5, self.moneyLabel.frame.origin.y+self.moneyLabel.frame.size.height, 20, 18)];
    self.heartImage.image=[UIImage imageNamed:@"comment_progress_heart_nor"];
    
    self.proportionLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.heartImage.frame.origin.x+self.heartImage.frame.size.width, self.heartImage.frame.origin.y-2, 50, 20)];
    
    self.bgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.PictureImageView.frame.origin.x+self.PictureImageView.frame.size.width, 95-25, (screenWidth-64)*2/5-self.PictureImageView.frame.size.width, 25)];
    self.bgImageView.userInteractionEnabled=YES;
    self.bgImageView.backgroundColor=[UIColor whiteColor];
    
    self.timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.PictureImageView.frame.origin.x+self.PictureImageView.frame.size.width+10, self.moneyLabel.frame.origin.y+self.moneyLabel.frame.size.height, self.bgImageView.frame.size.width/2-5, 20)];
    self.timeLabel.font=[UIFont systemFontOfSize:14];
    
    self.peopleLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.timeLabel.frame.origin.x+self.timeLabel.frame.size.width+10, self.timeLabel.frame.origin.y, self.bgImageView.frame.size.width/2-10, 20)];
    self.peopleLabel.font=[UIFont systemFontOfSize:14];
    
    [self addSubview:lineLabel];
    [self addSubview:self.PictureImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.categoryImage];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.progress];
    [self addSubview:self.people];
    [self addSubview:self.heartImage];
    [self addSubview:self.proportionLabel];
    [self addSubview:self.bgImageView];
    [self addSubview:self.timeLabel];
    [self addSubview:self.peopleLabel];
    
    self.attentionButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.bgImageView.frame.size.width/2-1, 25)];
    self.attentionButton.backgroundColor=tabarColor;
    [self.attentionButton setTitle:HKLocalizedString(@"GirdView_attention1_label") forState:UIControlStateNormal];
    [self.attentionButton setTitle:HKLocalizedString(@"GirdView_attention2_label") forState:UIControlStateSelected];
    [self.attentionButton setImage:[UIImage imageNamed:@"comment_list_favourite"] forState:UIControlStateNormal];
    [self.attentionButton addTarget:self action:@selector(clickAttention:) forControlEvents:UIControlEventTouchUpInside];
    
    self.donationButton=[[UIButton alloc] initWithFrame:CGRectMake(self.bgImageView.frame.size.width/2, 0, self.bgImageView.frame.size.width/2, 25)];
    self.donationButton.backgroundColor=tabarColor;
    [self.donationButton setTitle:HKLocalizedString(@"MenuView_donationLabel_title") forState:UIControlStateNormal];
    [self.donationButton setImage:[UIImage imageNamed:@"comment_list_cart_nor"] forState:UIControlStateNormal];
    [self.donationButton setImage:[UIImage imageNamed:@"comment_list_cart_sel"] forState:UIControlStateSelected];
    [self.donationButton addTarget:self action:@selector(clickDonation:) forControlEvents:UIControlEventTouchUpInside];
    //self.donationButton.tag=100+index;
    [self.bgImageView addSubview:self.attentionButton];
    [self.bgImageView addSubview:self.donationButton];
    
    if (model.Isfavourite) {
        self.attentionButton.selected=YES;
        self.attentionButton.backgroundColor=greeBar;
        //[UIColor colorWithRed:90/255.0 green:172/255.0 blue:33/255.0 alpha:1];
    }
    
    for (NSString * str in self.IDArray) {
        if ([str isEqualToString:model.CaseID]) {
            self.donationButton.selected = YES;
            self.donationButton.backgroundColor=greeBar;
            //[UIColor colorWithRed:90/255.0 green:172/255.0 blue:33/255.0 alpha:1];
        }
    }
    
    self.ZTView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.ZTView.image=[UIImage imageNamed:@"comment_poster_complete"];
    [self.PictureImageView addSubview:self.ZTView];
    self.ZTView.hidden=YES;
    UILabel * succeedLabel =[[UILabel alloc] initWithFrame:CGRectMake(-4, 8, 40, 15)];
    [self.ZTView addSubview:succeedLabel];
    succeedLabel.text=HKLocalizedString(@"筹募");
    succeedLabel.textAlignment = NSTextAlignmentCenter;
    succeedLabel.font = [UIFont systemFontOfSize:7];
    succeedLabel.textColor = [UIColor whiteColor];
    succeedLabel.transform = CGAffineTransformMakeRotation(-M_PI/4);
}

-(NSMutableAttributedString *)setStrA:(NSString *)StrA andIndexA:(int)IndexA andColorA:(UIColor *)ColorA andFontA:(id)FontA andStrB:(NSString *)StrB andIndexB:(int)IndexB andColorB:(UIColor *)ColorB andFontB:(id)FontB andStrC:(NSString *)StrC
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:StrC];
    [str addAttribute:NSForegroundColorAttributeName value:ColorA range:NSMakeRange(0,StrA.length+IndexA)];
    [str addAttribute:NSForegroundColorAttributeName value:ColorB range:NSMakeRange(StrA.length+IndexA,StrB.length+IndexB)];
    [str addAttribute:NSFontAttributeName value:FontA range:NSMakeRange(0, StrA.length+IndexA)];
    [str addAttribute:NSFontAttributeName value:FontB range:NSMakeRange(StrA.length+IndexA, StrB.length+IndexB)];
    return str;
}

#pragma mark - 拿到数据
-(void)setModel:(EGHomeModel *)model andIndex:(int)index andID:(NSMutableArray *)IDarray andBool:(BOOL)mybool
{
    self.caseId=model.CaseID;
    self.RemainingString=model.RemainingValue;
    self.Success=model.IsSuccess;
    self.IDArray=IDarray;
    self.index=index;
    for(UIImageView * IV in self.subviews)
    {
        [IV removeFromSuperview];
    }
    [self setViewModel:model andIndex:index];
    NSDictionary * dictionary= @{@"S":@"comment_list_type_education",
                                 @"E":@"comment_list_type_elder",
                                 @"U":@"comment_list_type_emergency",
                                 @"M":@"comment_list_type_medical",
                                 @"P":@"comment_list_type_poverty",
                                 @"A":@"comment_list_type_case_list",
                                 @"O":@"comment_list_type_others"};
    NSArray * array=@[@"O",@"S",@"E",@"M",@"P",@"U",@"A"];
    if (model.Category.length>0) {
        //self.categoryImage.image=[UIImage imageNamed:[dictionary objectForKey:[model.Category substringToIndex:1]]];
        NSString * okStr=@"";
        for (int i=0; i<array.count; i++) {
            if ([okStr isEqualToString:@"ok"]) {
                break;
            }
            for (int j=0; j<model.Category.length; j++) {
                NSString * str=[NSString stringWithFormat:@"%c",[model.Category characterAtIndex:j]];
                if ([array[i] isEqualToString:str]) {
                    self.categoryImage.image=[UIImage imageNamed:[dictionary objectForKey:str]];
                    okStr=@"ok";
                }
            }
        }
    }
    else
    {
        self.categoryImage.image=[UIImage imageNamed:[dictionary objectForKey:@"O"]];
    }

    NSString *  URL = [SITE_URL stringByAppendingPathComponent:[model.ProfilePicURL stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
    //[self.PictureImageView sd_setImageWithURL:[NSURL URLWithString:URL]];
    //[self.PictureImageView sd_setImageWithURL:[NSURL URLWithString:URL] placeholderImage:[UIImage imageNamed:@"dummy_case_related_default"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    [self.PictureImageView sd_setImageWithURL:[NSURL URLWithString:URL] placeholderImage:[UIImage imageNamed:@"dummy_case_related_default"]];
    //self.titleLabel.text=[NSString stringWithFormat:@"%@(%@)",model.Title,model.Region];
    
    NSMutableAttributedString * titleStr = [[NSMutableAttributedString alloc] init];
    titleStr=[self setStrA:[NSString stringWithFormat:@"%@",model.Title] andIndexA:0 andColorA:[UIColor blackColor] andFontA:[UIFont systemFontOfSize:18] andStrB:[NSString stringWithFormat:@"(%@)",model.Region] andIndexB:0 andColorB:[UIColor blackColor] andFontB:[UIFont boldSystemFontOfSize:16] andStrC:[NSString stringWithFormat:@"%@(%@)",model.Title,model.Region]];
    self.titleLabel.attributedText = titleStr;
    
    LanguageKey lang = [Language getLanguage];
    if ([model.RemainingValue intValue]>0) {
        if (lang==1||lang==2) {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
            str=[self setStrA:HKLocalizedString(@"GirdView_time_label") andIndexA:0 andColorA:[UIColor grayColor] andFontA:[UIFont systemFontOfSize:14] andStrB:[NSString stringWithFormat:@"%@",model.RemainingValue] andIndexB:0 andColorB:[UIColor blackColor] andFontB:[UIFont boldSystemFontOfSize:14] andStrC:[NSString stringWithFormat:@"%@%@%@",HKLocalizedString(@"GirdView_time_label"),model.RemainingValue,model.RemainingUnit]];
            self.timeLabel.attributedText = str;
            //self.timeLabel.text = [NSString stringWithFormat:@"%@%@%@",HKLocalizedString(@"GirdView_time_label"),model.RemainingValue,model.RemainingUnit];
        }
        else
        {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
            str=[self setStrA:[NSString stringWithFormat:@"%@",model.RemainingValue] andIndexA:0 andColorA:[UIColor blackColor] andFontA:[UIFont boldSystemFontOfSize:14] andStrB:[NSString stringWithFormat:@"%@%@",model.RemainingUnit,@" To Go"] andIndexB:1 andColorB:[UIColor grayColor] andFontB:[UIFont systemFontOfSize:14] andStrC:[NSString stringWithFormat:@"%@ %@ To Go",model.RemainingValue,model.RemainingUnit]];
            self.timeLabel.attributedText = str;
            //self.timeLabel.text = [NSString stringWithFormat:@"%@ %@ To Go",model.RemainingValue,model.RemainingUnit];
        }
    }
    else
    {
        self.timeLabel.text =HKLocalizedString(@"GirdView_time");
        self.timeLabel.textColor=[UIColor grayColor];
    }
//    if (lang==1||lang==2) {
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
//        str=[self setStrA:HKLocalizedString(@"GirdView_count_label") andIndexA:0 andColorA:[UIColor grayColor] andFontA:[UIFont systemFontOfSize:14] andStrB:[NSString stringWithFormat:@"%@",model.DonorCount] andIndexB:0 andColorB:[UIColor blackColor] andFontB:[UIFont boldSystemFontOfSize:14] andStrC:[NSString stringWithFormat:@"%@%@",HKLocalizedString(@"GirdView_count_label"),model.DonorCount]];
//        self.peopleLabel.attributedText = str;
//        //self.peopleLabel.text=[NSString stringWithFormat:@"%@%@",HKLocalizedString(@"GirdView_count_label"),model.DonorCount];
//    }
//    else
//    {
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
//        str=[self setStrA:[NSString stringWithFormat:@"%@",model.DonorCount] andIndexA:0 andColorA:[UIColor blackColor] andFontA:[UIFont boldSystemFontOfSize:14] andStrB:@" of Donors" andIndexB:0 andColorB:[UIColor grayColor] andFontB:[UIFont systemFontOfSize:14] andStrC:[NSString stringWithFormat:@"%@%@",model.DonorCount,@" of Donors"]];
//        self.peopleLabel.attributedText = str;
//        //self.peopleLabel.text=[NSString stringWithFormat:@"%@%@",model.DonorCount,@" of Donors"];
//    }

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    str=[self setStrA:HKLocalizedString(@"GirdView_count_label") andIndexA:0 andColorA:[UIColor grayColor] andFontA:[UIFont systemFontOfSize:14] andStrB:[NSString stringWithFormat:@"%@",model.DonorCount] andIndexB:0 andColorB:[UIColor blackColor] andFontB:[UIFont boldSystemFontOfSize:14] andStrC:[NSString stringWithFormat:@"%@%@",HKLocalizedString(@"GirdView_count_label"),model.DonorCount]];
    self.peopleLabel.attributedText = str;
    
    if (mybool) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
        if (lang==1||lang==2) {
            str=[self setStrA:HKLocalizedString(@"HomePage_atm_label") andIndexA:1 andColorA:[UIColor grayColor] andFontA:[UIFont systemFontOfSize:14] andStrB:[NSString stringWithFormat:@"%@",model.Amt] andIndexB:1 andColorB:tabarColor andFontB:[UIFont boldSystemFontOfSize:16] andStrC:[NSString stringWithFormat:@"%@:$%@",HKLocalizedString(@"HomePage_atm_label"),model.Amt]];
        }
        else
        {
            str=[self setStrA:@"Raised" andIndexA:1 andColorA:[UIColor grayColor] andFontA:[UIFont systemFontOfSize:14] andStrB:[NSString stringWithFormat:@"%@",model.Amt] andIndexB:1 andColorB:tabarColor andFontB:[UIFont boldSystemFontOfSize:16] andStrC:[NSString stringWithFormat:@"%@:$%@",@"Raised",model.Amt]];
        }
        self.moneyLabel.attributedText = str;
        //self.moneyLabel.text=[NSString stringWithFormat:@"%@:$%@",HKLocalizedString(@"HomePage_atm_label"),model.Amt];
        self.progress.hidden=NO;
        self.people.hidden=NO;
        self.heartImage.hidden=NO;
        self.proportionLabel.hidden=NO;
        self.timeLabel.hidden=YES;
        self.peopleLabel.hidden=YES;
    }
    else
    {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
        if (lang==1||lang==2) {
            str=[self setStrA:HKLocalizedString(@"HomePage_target_label") andIndexA:1 andColorA:[UIColor grayColor] andFontA:[UIFont systemFontOfSize:14] andStrB:[NSString stringWithFormat:@"%@",model.TargetAmt] andIndexB:1 andColorB:tabarColor andFontB:[UIFont boldSystemFontOfSize:16] andStrC:[NSString stringWithFormat:@"%@:$%@",HKLocalizedString(@"HomePage_target_label"),model.TargetAmt]];
        }
        else
        {
            str=[self setStrA:@"Target" andIndexA:1 andColorA:[UIColor grayColor] andFontA:[UIFont systemFontOfSize:14] andStrB:[NSString stringWithFormat:@"%@",model.TargetAmt] andIndexB:1 andColorB:tabarColor andFontB:[UIFont boldSystemFontOfSize:16] andStrC:[NSString stringWithFormat:@"%@:$%@",@"Target",model.TargetAmt]];
        }
        self.moneyLabel.attributedText = str;
        //self.moneyLabel.text=[NSString stringWithFormat:@"%@:$%@",HKLocalizedString(@"HomePage_target_label"),model.TargetAmt];
        self.progress.hidden=YES;
        self.people.hidden=YES;
        self.heartImage.hidden=YES;
        self.proportionLabel.hidden=YES;
        self.timeLabel.hidden=NO;
        self.peopleLabel.hidden=NO;
    }
    
    if (model.Percentage >= 100) {
        self.ZTView.hidden=NO;
        [self.progress setProgressTintColor:progressBar];
        //[UIColor colorWithRed:185/255.0 green:55/255.0 blue:83/255.0 alpha:1]
        self.progress.progress=1;
        self.proportionLabel.text = [NSString stringWithFormat:@"100%%"];
        //把图片添加到动态数组
        NSMutableArray * animateArray = [[NSMutableArray alloc]initWithCapacity:2];
        [animateArray addObject:[UIImage imageNamed:@"comment_progress_heart_nor"]];
        [animateArray addObject:[UIImage imageNamed:@"comment_progress_heart_mid"]];
        [animateArray addObject:[UIImage imageNamed:@"comment_progress_heart_complete"]];
        //为图片设置动态
        self.heartImage.animationImages = animateArray;
        //为动画设置持续时间
        self.heartImage.animationDuration = 0.5;
        //为默认的无限循环
        self.heartImage.animationRepeatCount = 0;
        //开始播放动画
        [self.heartImage startAnimating];
    }else{
        self.heartImage.image=[UIImage imageNamed:@"comment_progress_heart_nor"];
        self.progress.progress=model.Percentage/100.0;
        self.proportionLabel.text = [NSString stringWithFormat:@"%2.f%%",model.Percentage];
        self.proportionLabel.font=[UIFont boldSystemFontOfSize:18];
    }
    if (self.progress.progress>0.93) {
        self.people.frame=CGRectMake(self.PictureImageView.frame.origin.x+self.PictureImageView.frame.size.width+self.progress.frame.size.width*0.93, self.moneyLabel.frame.origin.y+self.moneyLabel.frame.size.height, 20, 20);
    }
    else
    {
        self.people.frame=CGRectMake(self.PictureImageView.frame.origin.x+self.PictureImageView.frame.size.width+self.progress.frame.size.width*self.progress.progress, self.moneyLabel.frame.origin.y+self.moneyLabel.frame.size.height, 20, 20);
    }
    if (self.progress.progress<0.5) {
        self.people.image=[UIImage imageNamed:@"comment_detail_progress_run_1"];
    }
    else
    {
        if (self.progress.progress<0.9999) {
            self.people.image=[UIImage imageNamed:@"comment_detail_progress_run_2"];
        }
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
