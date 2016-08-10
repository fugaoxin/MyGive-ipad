//
//  EGGirdTableViewCell.m
//  Egive-ipad
//
//  Created by 123 on 16/2/2.
//  Copyright © 2016年 Sino. All rights reserved.
//

#import "EGGirdTableViewCell.h"
#import "AnyWebViewController.h"

@implementation EGGirdTableViewCell

- (id)init:(UIViewController *)vc
{
    // NSLog(@"GirdTableViewCell");
    self = [super init]; //initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _parent = vc;
        _mainLabel = [[MDHTMLLabel alloc] init];//[[UILabel alloc] init];
        _mainLabel.frame = CGRectMake(0, 0, screenWidth-64-(screenWidth-64)*2/5-45, 200);
        _mainLabel.numberOfLines = 0;
        //        _mainLabel.userInteractionEnabled = YES;
        _mainLabel.delegate = self;
        
        [self addSubview:_mainLabel];
    }
    return self;
}

-(void) setLabelFont:(UIFont *)font
{
    _mainLabel.font = font;
}

-(void) setLabelText:(NSString *)text
{
    _mainLabel.htmlText = text;
     //NSLog(@"www_mainLabel.text %@", _mainLabel.htmlText);
    [_mainLabel sizeToFit];
    _mainLabel.frame = CGRectMake(0, 0, screenWidth-64-(screenWidth-64)*2/5-45, _mainLabel.frame.size.height);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - MDHTMLLabelDelegate methods

- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL *)URL
{
    // NSLog(@"Did select link with URL: %@", URL.absoluteString);
    
    AnyWebViewController * vc = [[AnyWebViewController alloc] init];
    [vc setAbsoluteURL:[URL absoluteString]];
    [_parent presentViewController:vc animated:YES completion:^{
        
    }];
    //[_parent.navigationController pushViewController:vc animated:YES];
}

- (void)HTMLLabel:(MDHTMLLabel *)label didHoldLinkWithURL:(NSURL *)URL
{
    // NSLog(@"Did hold link with URL: %@", URL.absoluteString);
    
    AnyWebViewController * vc = [[AnyWebViewController alloc] init];
    [vc setAbsoluteURL:[URL absoluteString]];
    [_parent presentViewController:vc animated:YES completion:^{
        
    }];
    //[_parent.navigationController pushViewController:vc animated:YES];
}

@end
