//
//  EGDonationsRecordCell.m
//  Egive-ipad
//
//  Created by vincentmac on 15/12/3.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGDonationsRecordCell.h"

@implementation EGDonationsRecordCell

- (void)awakeFromNib {
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#E9EAEC"];
    
    self.nameLabel.font = [UIFont boldSystemFontOfSize:18];
    self.dateLabel.font = [UIFont boldSystemFontOfSize:17];
    self.moneyLabel.font = [UIFont boldSystemFontOfSize:17];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+(instancetype)cellWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indenfity = @"cell";
    
    EGDonationsRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:indenfity];
    
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EGDonationsRecordCell" owner:self options:nil] lastObject];
        cell.moneyLabel.textColor = [UIColor colorWithHexString:@"#4C047A"];
        cell.moneyTextLabel.textColor = [UIColor colorWithHexString:@"#4C047A"];

    }
    
    
    UIView *selectedView = [UIView new];
    selectedView.frame = cell.frame;
    selectedView.backgroundColor = [UIColor colorWithHexString:@"#E9EAEC"];
    cell.selectedBackgroundView = selectedView;
    
    return cell;
}
@end
