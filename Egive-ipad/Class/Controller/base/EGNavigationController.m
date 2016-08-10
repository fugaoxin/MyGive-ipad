//
//  EGNavigationController.m
//  Egive-ipad
//
//  Created by vincentmac on 15/11/18.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGNavigationController.h"

@interface EGNavigationController ()

@end

@implementation EGNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



+(void)initialize{
    //
    UIImage *barImage = [UIImage imageNamed:@"col"];
    
    UINavigationBar *navBar = [UINavigationBar appearance];
//    [navBar setBackgroundImage:barImage forBarMetrics:UIBarMetricsDefault];
//    [navBar setShadowImage:[UIImage imageWithColor:[UIColor orangeColor] size:CGSizeMake(WIDTH, 1.5)]];
    
    //    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor colorWithHexString:@"#142C05"]  forKey:NSForegroundColorAttributeName];
    //  [UIColor colorWithHexString:@"#142C05"]
    
    UIFont* font = [UIFont fontWithName:@"Arial-ItalicMT" size:18.0];
    NSDictionary* textAttributes = @{NSFontAttributeName:font,
                                     
                                     NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    navBar.titleTextAttributes = textAttributes;
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
