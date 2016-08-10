//
//  EGtextLabelCell.m
//  Egive-ipad
//
//  Created by 123 on 16/1/27.
//  Copyright © 2016年 Sino. All rights reserved.
//

#import "EGtextLabelCell.h"

@implementation EGtextLabelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.EGLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, screenWidth-64-40, 40)];
        //self.EGLabel.numberOfLines=0;
        [self addSubview:self.EGLabel];
        
        UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(0, self.EGLabel.frame.size.height-1, screenWidth-64, 1)];
        label.backgroundColor=[UIColor lightGrayColor];
        label.alpha=0.8;
        [self addSubview:label];
    }
    return self;
}

//-(void)setTextSize:(CGSize)size
//{
//    self.EGLabel.frame=CGRectMake(0, 0, size.width, size.height);
//}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
