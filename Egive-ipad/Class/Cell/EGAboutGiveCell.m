//
//  EGAboutGiveCell.m
//  Egive-ipad
//
//  Created by User01 on 15/11/23.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGAboutGiveCell.h"

@interface EGAboutGiveCell ()

@property (nonatomic,strong) UIImageView * lineImageView;
@property (nonatomic,strong) UIImageView * PictureImageView;
//@property (nonatomic,strong) UIImageView * FImageView;
@property (nonatomic,strong) UILabel * titleLabel;

@end


@implementation EGAboutGiveCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.lineImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 120-2.5, screenWidth/3, 2.5)];
        self.lineImageView.backgroundColor=[UIColor grayColor];
        self.lineImageView.alpha=0.2;
        
        self.PictureImageView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 80, 120-40)];
        //self.PictureImageView.backgroundColor=[UIColor redColor];
        
        self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.PictureImageView.frame.origin.x+self.PictureImageView.frame.size.width+20, (120-50)/2, 170, 50)];
        //self.titleLabel.backgroundColor=[UIColor redColor];
        self.titleLabel.textColor=tabarColor;
        
        self.FImageView=[[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/3-50, (120-30)/2, 30, 30)];
        //self.FImageView.backgroundColor=[UIColor redColor];
        self.FImageView.image=[UIImage imageNamed:@"menu_arrow"];
        
        [self addSubview:self.lineImageView];
        [self addSubview:self.PictureImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.FImageView];
    }
    return self;
}

-(void)setTitle:(NSString *)title andImage:(NSString *)image
{
    self.PictureImageView.image=[UIImage imageNamed:image];
    self.titleLabel.text=title;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
