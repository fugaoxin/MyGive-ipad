//
//  TestViewController.m
//  Egive-ipad
//
//  Created by vincentmac on 15/12/18.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()


@property (nonatomic,weak) IBOutlet UIView *blackView;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.blackView.layer.opacity = 0.7;
    self.view.backgroundColor  = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)click :(id)sender{

    [self.yqNavigationController popYQViewControllerAnimated:YES];
}



-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
