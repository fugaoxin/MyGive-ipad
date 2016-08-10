//
//  EGMyNvgViewController.m
//  Egive-ipad
//
//  Created by User01 on 15/11/19.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGMyNvgViewController.h"

@interface EGMyNvgViewController ()

@end

@implementation EGMyNvgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitleBar];
}

-(void)setTitleBar{
    
    self.headerBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 64)];
    self.headerBgImageView.userInteractionEnabled = YES;
    self.headerBgImageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headerBgImageView];
    
    UILabel * lane1=[[UILabel alloc] initWithFrame:CGRectMake(0, 63, screenWidth, 1)];
    lane1.backgroundColor=[UIColor grayColor];
    lane1.alpha=0.5;
    [self.headerBgImageView addSubview:lane1];
    
    //设置title
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, screenWidth-100, 44)];
    self.titleLabel.textColor=tabarColor;
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.titleLabel.userInteractionEnabled=YES;
    [self.headerBgImageView addSubview:self.titleLabel];
    
    //创建左按钮
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, (44*75)/45, 44)];
    [self.leftButton addTarget:self action:@selector(dismVC) forControlEvents:UIControlEventTouchUpInside];
    //self.leftButton.backgroundColor=[UIColor orangeColor];
    [self.headerBgImageView addSubview:self.leftButton];
    
    //创建右按钮
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 10 - 44, 20, 44, 44 )];
    [self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //self.rightButton.backgroundColor=[UIColor greenColor];
    [self.headerBgImageView addSubview:self.rightButton];
    
    //创建右二按钮
    self.rightTowButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 98, 20, 44, 44 )];
    [self.rightTowButton addTarget:self action:@selector(rightTowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //self.rightButton.backgroundColor=[UIColor greenColor];
    [self.headerBgImageView addSubview:self.rightTowButton];
}

//实现返回功能
-(void)dismVC{
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightButtonClick:(UIButton *)button{
    //NSLog(@"这个方法需要在子类中重写");
}

-(void)rightTowButtonClick:(UIButton *)button{
    //NSLog(@"这个方法需要在子类中重写");
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
