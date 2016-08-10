//
//  EGMessageCell.h
//  Egive-ipad
//
//  Created by 123 on 16/3/4.
//  Copyright © 2016年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDHTMLLabel.h"

@interface EGMessageCell : UITableViewCell

/**
 * 获取数据
 * dataDic: 数据字典
 * array: 已读信息数组
 */
-(void)setData:(NSDictionary *)dataDic andIDArray:(NSArray *)array;

@end
