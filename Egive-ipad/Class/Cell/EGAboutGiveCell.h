//
//  EGAboutGiveCell.h
//  Egive-ipad
//
//  Created by User01 on 15/11/23.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EGAboutGiveCell : UITableViewCell

@property (nonatomic,strong) UIImageView * FImageView;//箭头图标

-(void)setTitle:(NSString *)title andImage:(NSString *)image;

@end
