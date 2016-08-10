//
//  EGContactCell.m
//  Egive-ipad
//
//  Created by vincentmac on 16/1/15.
//  Copyright © 2016年 Sino. All rights reserved.
//

#import "EGContactCell.h"

@implementation EGContactCell

- (void)awakeFromNib {
   
    [_checkButton setImage:[UIImage imageNamed:@"cart_checkbox_nor"] forState:UIControlStateNormal];
    [_checkButton setImage:[UIImage imageNamed:@"cart_checkbox_sel"] forState:UIControlStateSelected];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+(instancetype)cellWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath item:(EGContactModel *)item{

    EGContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EGContactCell" owner:self options:nil] lastObject];
        
        
    }
    
    cell.nameLabel.text = item.name;
    cell.emailLabel.text = item.email;
    
    if (item.isChecked) {
        cell.checkButton.selected = YES;
    }else{
        cell.checkButton.selected = NO;
    }
    
    return cell;
}

@end
