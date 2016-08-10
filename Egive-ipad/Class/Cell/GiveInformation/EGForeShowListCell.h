//
//  EGForeShowListCell.h
//  Egive-ipad
//
//  Created by kevin on 15/12/26.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EGForeShowListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ivWidth;
@property (nonatomic,weak) IBOutlet UIImageView * iv;
@property (nonatomic,weak) IBOutlet UILabel * title;
@property (nonatomic,weak) IBOutlet UILabel * desp;
@property (nonatomic,weak) IBOutlet UILabel * date;
@property (nonatomic,weak) IBOutlet UIView * line;
@end
