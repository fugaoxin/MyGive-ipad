//
//  EGBlessingCell.m
//  Egive-ipad
//
//  Created by 123 on 15/12/11.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGBlessingCell.h"

#define ScreenSize screenWidth-400

@interface EGBlessingCell ()

@property (strong, nonatomic) UIImageView * userIcon;//头像
//@property (strong, nonatomic) UIImageView * bgImageView;//背景
@property (strong, nonatomic) UILabel * memberName;//用户名
//@property (strong, nonatomic) UIButton * deleteButton;//删除按钮
@property (strong, nonatomic) UILabel * timeLabel;//发表时间
@property (strong, nonatomic) UILabel * CommentLabel;//内容
//@property (strong, nonatomic) UIWebView * commentWv;//内容

@end


@implementation EGBlessingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.commentWv = [[UIWebView alloc] init];
    self.commentWv.frame = CGRectMake(22, 60, ScreenSize-44, 110);
    self.commentWv.contentMode = UIViewContentModeScaleAspectFit;
    self.commentWv.scrollView.scrollEnabled = NO;
    self.commentWv.scrollView.bounces = NO;
    self.commentWv.userInteractionEnabled = NO;
    self.commentWv.backgroundColor = [UIColor whiteColor];
    self.commentWv.layer.cornerRadius = 5;
    [self addSubview:self.commentWv];
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 50, ScreenSize-40, 120)];
    //self.bgImageView.backgroundColor=[UIColor orangeColor];
    self.bgImageView.userInteractionEnabled=YES;
    self.bgImageView.layer.cornerRadius = 5;
    self.bgImageView.layer.borderWidth = 1;
    self.bgImageView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.bgImageView.layer.masksToBounds = YES;
    [self addSubview:self.bgImageView];
    
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bgImageView.frame.size.width, 40)];
    //bgView.backgroundColor = [UIColor colorWithRed:110/255.0 green:49/255.0 blue:139/255.0 alpha:1];
    bgView.backgroundColor=tabarColor;
    bgView.userInteractionEnabled=YES;
    [self.bgImageView addSubview:bgView];
    
    UIImageView * imageBG=[[UIImageView alloc] initWithFrame:CGRectMake(28, 23, 80, 80)];
    imageBG.layer.cornerRadius = 40;
    imageBG.layer.masksToBounds = YES;
    //self.userIcon.backgroundColor=[UIColor redColor];
    imageBG.backgroundColor = tabarColor;
    [self addSubview:imageBG];
    
    self.userIcon =[[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 76, 76)];
    self.userIcon.layer.cornerRadius = 38;
    self.userIcon.layer.masksToBounds = YES;
    //self.userIcon.backgroundColor=[UIColor redColor];
    //self.userIcon.backgroundColor = [UIColor colorWithRed:110/255.0 green:49/255.0 blue:139/255.0 alpha:1];
    [imageBG addSubview:self.userIcon];
    
    self.deleteButton = [[UIButton alloc] init];
    self.deleteButton.frame = CGRectMake(bgView.frame.size.width-30, 7, 25, 25);
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"bless_delete"] forState:UIControlStateNormal];
    [bgView addSubview:self.deleteButton];
    [self.deleteButton addTarget:self action:@selector(clickDelete:) forControlEvents:UIControlEventTouchUpInside];
    //    _comment = [view addLabelWithFrame:CGRectMake(10, 55, ScreenSize.width-35, 40) text:nil];
    //    _comment.font = [UIFont systemFontOfSize:14];
    //    _comment.numberOfLines = 3;
    
    self.memberName =[[UILabel alloc] initWithFrame:CGRectMake(95, 5, 200, 30)];
    //self.memberName.font = [UIFont systemFontOfSize:14];
    self.memberName.textColor = [UIColor whiteColor];
    [bgView addSubview:self.memberName];
    
    self.timeLabel =[[UILabel alloc] initWithFrame:CGRectMake(self.bgImageView.frame.size.width+self.bgImageView.frame.origin.x-300, self.bgImageView.frame.origin.y-25, 300, 25)];
    //self.timeLabel.backgroundColor=[UIColor redColor];
    self.timeLabel.textColor = [UIColor grayColor];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    
    [self addSubview:self.timeLabel];
    
}

-(void)clickDelete:(UIButton *)but
{
    [self.delegate deleteBlessing:(int)but.tag];
}

-(void)setModel:(EGBlessingModel *)model andIndex:(int)index
{
    self.deleteButton.tag=index;
    NSURL *url = [NSURL URLWithString:SITE_URL];
    url = [url URLByAppendingPathComponent:model.ImgURL];
    [self.userIcon sd_setImageWithURL:url];
    
    self.memberName.text=model.MemberName;
    self.timeLabel.text=[model.CommentDate substringWithRange:NSMakeRange(0, model.CommentDate.length-3)];
    
    
    NSString* content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"render" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL];
    content = [content stringByReplacingOccurrencesOfString:@":content:" withString:model.Comment];
//    DLOG(@"model.Comment===%@",model.Comment);
//    DLOG(@"fgx=====%@", content);
    [self.commentWv loadHTMLString:content baseURL:[[NSBundle mainBundle] bundleURL]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
