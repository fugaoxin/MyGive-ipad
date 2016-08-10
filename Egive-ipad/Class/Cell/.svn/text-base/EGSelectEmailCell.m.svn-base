//
//  EGSelectEmailCell.m
//  Egive-ipad
//
//  Created by vincentmac on 16/1/15.
//  Copyright © 2016年 Sino. All rights reserved.
//

#import "EGSelectEmailCell.h"

@implementation EGSelectEmailCell

- (void)awakeFromNib {
    _emailField.placeholder = HKLocalizedString(@"valid_email_address");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



+ (instancetype)cellWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath item:(EGContactModel *)item{
    EGSelectEmailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EGSelectEmailCell" owner:self options:nil] lastObject];

        
    }
    
    NSInteger row = indexPath.row;
    
    cell.emailField.text = item.email;
    
    return cell;
}

@end
