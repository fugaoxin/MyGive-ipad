//
//  EGGirdTableViewCell.h
//  Egive-ipad
//
//  Created by 123 on 16/2/2.
//  Copyright © 2016年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDHTMLLabel.h"

@interface EGGirdTableViewCell : UITableViewCell<MDHTMLLabelDelegate>

@property (strong, nonatomic) MDHTMLLabel *mainLabel;
@property (strong, nonatomic) UIWebView *web;
@property (strong, nonatomic) UIViewController *parent;

-(id) init:(UIViewController *)vc;
-(void) setLabelFont:(UIFont *)font;
-(void) setLabelText:(NSString *)text;

@end
