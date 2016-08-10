//
//  EGLogoController.m
//  Egive-ipad
//
//  Created by 123 on 15/12/10.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGLogoController.h"
#import "EGHomeModel.h"

@interface EGLogoController ()

@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UIButton * Xbutton;

@end

@implementation EGLogoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setPopupView];
}

-(void)viewDidAppear:(BOOL)animated{
    //self.navigationBar.hidden=YES;
}

-(void)setPopupView
{
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, screenHeight)];//WIDTH-500
    //self.imageView.backgroundColor = [UIColor redColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.urlString]];
    //[self.imageView sd_setImageWithURL:[NSURL URLWithString:self.urlString] placeholderImage:[UIImage imageNamed:@"Lanch"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    
    self.Xbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.Xbutton.frame = CGRectMake(screenWidth - 50,40, 35, 35);
    [self.Xbutton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.Xbutton setImage:[UIImage imageNamed:@"ad_close"] forState:UIControlStateNormal];
    [self.view addSubview:self.Xbutton];
}

- (void)closeAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
