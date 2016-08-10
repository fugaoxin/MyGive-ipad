//
//  EGRankRightViewCell.m
//  Egive-ipad
//
//  Created by vincentmac on 15/11/26.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGRankRightViewCell.h"
#import "UIView+line.h"

@implementation EGRankRightViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



+(instancetype)cellWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *leftIndenfity = @"rightcell";
    
    EGRankRightViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftIndenfity];
    
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EGRankRightViewCell" owner:self options:nil] lastObject];
        [cell addSubview:[UIView normalLine]];
    }
    
    NSInteger num = indexPath.row;
    
    cell.rankNumLabel.text = [NSString stringWithFormat:@"%ld",num+1];
    
//    switch (indexPath.row) {
//        case 0:
//            cell.icon.image = [UIImage imageNamed:@"ranking_personal_integrate_icon"];
//            cell.rightLabel.text = [Language getStringByKey:@"综合－累积最高捐款企业"];
//            break;
//        case 1:
//            cell.rightLabel.text = [Language getStringByKey:@"助学－每月最高个人捐款"];
//            cell.icon.image = [UIImage imageNamed:@"ranking_personal_education_icon"];
//            break;
//        case 2:
//            cell.icon.image = [UIImage imageNamed:@"ranking_personal_elderly_icon"];
//            cell.rightLabel.text = [Language getStringByKey:@"安老－每月最高个人捐款"];
//            break;
//        case 3:
//            cell.icon.image = [UIImage imageNamed:@"ranking_personal_medical_icon"];
//            cell.rightLabel.text = [Language getStringByKey:@"助医－每月最高个人捐款"];
//            break;
//        case 4:
//            cell.icon.image = [UIImage imageNamed:@"ranking_personal_poverty_icon"];
//            cell.rightLabel.text = [Language getStringByKey:@"扶贫－每月最高个人捐款"];
//            break;
//        case 5:
//            cell.icon.image = [UIImage imageNamed:@"ranking_personal_emergency_icon"];
//            cell.rightLabel.text = [Language getStringByKey:@"紧急援助－每月最高个人捐款"];
//            break;
//        case 6:
//            cell.icon.image = [UIImage imageNamed:@"ranking_personal_case_list_icon"];
//            cell.rightLabel.text = [Language getStringByKey:@"意赠行动－每月最高个人捐款"];
//            break;
//        case 7:
//            cell.icon.image = [UIImage imageNamed:@"ranking_personal_others_icon"];
//            cell.rightLabel.text = [Language getStringByKey:@"其他－每月最高个人捐款"];
//            break;
//        default:
//            break;
//    }
    
    
    return cell;
}

@end
