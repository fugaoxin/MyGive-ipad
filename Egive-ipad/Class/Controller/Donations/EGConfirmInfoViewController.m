//
//  EGConfirmInfoViewController.m
//  Egive-ipad
//
//  Created by vincentmac on 15/11/27.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGConfirmInfoViewController.h"

@interface EGConfirmInfoViewController ()

@end

@implementation EGConfirmInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [Language getStringByKey:@"mydonation_comfirm_title"];
    
    [self.navigationBar showLeftItemWithImage:@"common_header_back"];
    self.navigationBar.barTintColor = [UIColor colorWithHexString:@"#F1F2F3"];
    self.navigationBar.title = [Language getStringByKey:@"mydonation_comfirm_title"];
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
