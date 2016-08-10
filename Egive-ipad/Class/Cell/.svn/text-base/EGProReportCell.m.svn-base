//
//  EGProReportCell.m
//  Egive-ipad
//
//  Created by 123 on 16/1/4.
//  Copyright © 2016年 Sino. All rights reserved.
//

#import "EGProReportCell.h"

@implementation EGProReportCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(3, 0, 300, 30)];
        self.numLabel=[[UILabel alloc] initWithFrame:CGRectMake(screenWidth-600-60-10, 0, 200, 30)];
        self.numLabel.textAlignment=NSTextAlignmentRight;
        [self addSubview:self.dateLabel];
        [self addSubview:self.numLabel];
    }
    return self;
}


- (void)awakeFromNib {
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
