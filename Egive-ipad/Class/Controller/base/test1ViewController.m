//
//  testViewController.m
//  Egive-ipad
//
//  Created by kevin on 15/12/29.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "test1ViewController.h"
#import "EGAgreeStatementViewController.h"
#import "POPSpringAnimation.h"
#import "test2ViewController.h"

@interface test1ViewController ()

@end

@implementation test1ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"测试";
    [self createNaviTopBarWithShowBackBtn:NO showTitle:YES];
    
    UIButton* cancelButton = [[UIButton alloc]init];//44是nvBar高度
    cancelButton.layer.cornerRadius = 5;
    cancelButton.backgroundColor = [UIColor colorWithHexString:@"#5CAF21"];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitle:@"pushAtion" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(ssAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.leading.equalTo(self.contentView);
        make.height.mas_equalTo(40);
        make.trailing.equalTo(self.contentView);
    }];

}

-(void)ssAction
{
    self.contentView.hidden = YES;
    self.bgView.hidden = YES;
    test2ViewController* root = [[test2ViewController alloc]init];//
    [root setContentSize:self.size bgAction:NO animated:NO];
    [self.navigationController pushViewController:root animated:YES];
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
