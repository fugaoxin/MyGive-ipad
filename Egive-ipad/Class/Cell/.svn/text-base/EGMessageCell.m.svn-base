//
//  EGMessageCell.m
//  Egive-ipad
//
//  Created by 123 on 16/3/4.
//  Copyright © 2016年 Sino. All rights reserved.
//

#import "EGMessageCell.h"

@interface EGMessageCell ()

@property (nonatomic,strong) UIImageView * lineImageView;
@property (nonatomic,strong) UIImageView * PictureImageView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * contentLabel;
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) UIImageView * statusView;

@property (nonatomic, strong)MDHTMLLabel *htmlLabel;
@property (nonatomic, copy)NSString *htmlString;

@end

@implementation EGMessageCell

-(NSMutableAttributedString *)setStrA:(NSString *)StrA andIndexA:(int)IndexA andColorA:(UIColor *)ColorA andStrB:(NSString *)StrB andIndexB:(int)IndexB andColorB:(UIColor *)ColorB andStrC:(NSString *)StrC
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:StrC];
    [str addAttribute:NSForegroundColorAttributeName value:ColorA range:NSMakeRange(0,StrA.length+IndexA)];
    [str addAttribute:NSForegroundColorAttributeName value:ColorB range:NSMakeRange(StrA.length+IndexA,StrB.length+IndexB)];
    return str;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.lineImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, screenWidth-64, 2.5)];
        self.lineImageView.backgroundColor = [UIColor colorWithHexString:@"#EBEAEB"];
        
        self.PictureImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 160, 120)];
        //self.PictureImageView.backgroundColor=[UIColor redColor];
        self.PictureImageView.contentMode = UIViewContentModeScaleToFill;
        self.PictureImageView.image=[UIImage imageNamed:@"dummy_case_related_default"];
        
        self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.PictureImageView.frame.origin.x+self.PictureImageView.frame.size.width+10, self.PictureImageView.frame.origin.y, screenWidth-self.PictureImageView.frame.size.width-10-64-60, 30)];
        //self.titleLabel.backgroundColor=[UIColor greenColor];
        //self.titleLabel.text=@"意赠活动 - 测试";
        self.titleLabel.font=[UIFont systemFontOfSize:18];
        //self.titleLabel.textColor = [UIColor colorWithHexString:@"#69318f"];
        
        
        self.contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.PictureImageView.frame.origin.x+self.PictureImageView.frame.size.width+10, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+10, self.titleLabel.frame.size.width, 50)];
        //self.contentLabel.backgroundColor=[UIColor redColor];
        //self.contentLabel.text=@"测试titleStr=[self setStrA:strA andIndexA:0 andColorA:[UIColor colorWithHexString: andStrB:strB andIndexB:0 andColorB:[UIColor colorWithHexString:";
        self.contentLabel.numberOfLines=0;
        self.titleLabel.font=[UIFont systemFontOfSize:16];
        
        self.timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.PictureImageView.frame.origin.x+self.PictureImageView.frame.size.width+10, self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height, self.titleLabel.frame.size.width, 25)];
        //self.timeLabel.backgroundColor=[UIColor orangeColor];
        //self.timeLabel.text=@"2016-1-21";
        self.timeLabel.font=[UIFont systemFontOfSize:18];
        
        self.statusView=[[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-64-50, 15, 30, 30)];
        self.statusView.image=[UIImage imageNamed:@"message_new"];
        self.statusView.hidden=YES;
        
        [self addSubview:self.lineImageView];
        [self addSubview:self.PictureImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.statusView];
    }
    return self;
}

-(void)setData:(NSDictionary *)dataDic andIDArray:(NSArray *)array
{
    if([[dataDic objectForKey:@"Title"] rangeOfString:@"-"].location!=NSNotFound){
        NSString * strA=nil;
        NSString * strB=nil;
        for (int i=0; i<[[dataDic objectForKey:@"Title"] length]; i++) {
            NSString *temp = [[dataDic objectForKey:@"Title"] substringWithRange:NSMakeRange(i, 1)];
            if ([temp isEqualToString:@"-"]) {
                strA=[[dataDic objectForKey:@"Title"] substringToIndex:i+1];
                strB=[[dataDic objectForKey:@"Title"] substringFromIndex:i+1];
                break;
            }
        }
        NSMutableAttributedString * titleStr = [[NSMutableAttributedString alloc] init];
        titleStr=[self setStrA:strA andIndexA:0 andColorA:[UIColor colorWithHexString:@"#000000"] andStrB:strB andIndexB:0 andColorB:[UIColor colorWithHexString:@"#69318f"] andStrC:[dataDic objectForKey:@"Title"]];
        self.titleLabel.attributedText=titleStr;
    }
    else{
        self.titleLabel.text=[dataDic objectForKey:@"Title"];
    }
    
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentJustified;//设置对齐方式
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSString * htmlString =[NSString stringWithFormat:@"<html><body>%@</body></html>",[dataDic objectForKey:@"Msg"]];
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType ,NSParagraphStyleAttributeName:paragraph } documentAttributes:nil error:nil];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, attrStr.length)];
    self.contentLabel.attributedText = attrStr;
    self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.timeLabel.text=[dataDic objectForKey:@"CreatedDate"];
    
    NSString *  URL = [SITE_URL stringByAppendingPathComponent:[[dataDic objectForKey:@"ImageFilePath"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
    [self.PictureImageView sd_setImageWithURL:[NSURL URLWithString:URL] placeholderImage:[UIImage imageNamed:@"dummy_case_related_default"]];
    
    if (array.count>0) {
        for(int i=0; i<array.count; i++)
        {
            if (![[dataDic objectForKey:@"MsgID"] isEqualToString:array[i]]) {
                if (array.count-1==i) {
                    self.statusView.hidden=NO;
                }
            }
            else
            {
                self.statusView.hidden=YES;
                break;
            }
        }
    }
    else{
        self.statusView.hidden=NO;
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
