//
//  EGBasePresentViewController.m
//  Egive-ipad
//
//  Created by kevin on 15/12/29.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGBasePresentViewController.h"
#import "POPSpringAnimation.h"

@interface EGBasePresentViewController ()

@end

@implementation EGBasePresentViewController

-(void)viewWillAppear:(BOOL)animated{
    self.contentView.hidden = NO;
    self.bgView.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;//隐藏bar
    self.view.backgroundColor =[UIColor clearColor];
    [self creatUI];
    [self showAnimation];
}
-(void)setContentSize:(CGSize)size  bgAction:(BOOL)bgAction  animated:(BOOL)animated
{
    self.size = size;
    self.animated = animated;
    self.bgAction = bgAction;
}

-(void)creatUI{

    UIView* bgView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-5, screenHeight)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.layer.opacity = 0.8;
    [self.view addSubview:bgView];
    
    UITapGestureRecognizer * bgViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewAction)];
    [bgView addGestureRecognizer:bgViewTap];
    _bgView = bgView;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView* animationView = [[UIView alloc]initWithFrame:CGRectMake(self.view.center.x-self.size.width/2, self.view.center.y-self.size.height/2, self.size.width, self.size.height)];
    animationView.backgroundColor = [UIColor whiteColor];
    _animationView = animationView;
    [self.view addSubview:animationView];
    [animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.view);
        make.width.mas_equalTo(self.size.width);
        make.height.mas_equalTo(self.size.height);
        
    }];
    
    UIView *bar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.size.width, 44)];
    bar.backgroundColor=[UIColor colorWithHexString:@"#F1F2F3"];
    [animationView addSubview:bar];
    _barView = bar;
    [bar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(animationView);
        make.leading.equalTo(animationView);
        make.trailing.equalTo(animationView);
        make.height.mas_equalTo(44);
        
    }];
    
    UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, self.size.width, self.size.height-44)];
    contentView.backgroundColor = [UIColor whiteColor];
    _contentView = contentView;
    [animationView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bar.mas_bottom);
        make.leading.equalTo(animationView);
        make.trailing.equalTo(animationView);
        make.height.mas_equalTo(self.size.height-44>0?self.size.height-44:0);
        
    }];
    
    
}

-(void)showAnimation
{
    if(_animated){
        POPSpringAnimation *animation = [self.contentView pop_animationForKey:@"spring"];
        if(animation==nil){
            animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
            animation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.3, 0.3)];
            animation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0f)];
            animation.springBounciness = 20;
            animation.springSpeed = 40;
            [self.animationView pop_addAnimation:animation forKey:@"spring"];
            
        }else{
            animation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
            animation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0f)];
        }
        
    }
}
-(UIView *)createNaviTopBarWithShowBackBtn:(BOOL)showBackBtn showTitle:(BOOL)showTitle;
{
   
    if(showTitle){
        UILabel *naviTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.size.width, 44)];
        _navigationTitle.text=@"";
        _navigationTitle = naviTitle;
        naviTitle.backgroundColor=[UIColor clearColor];
        naviTitle.textAlignment=NSTextAlignmentCenter;
        [naviTitle setFont:[UIFont boldSystemFontOfSize:20]];
        naviTitle.textColor=[UIColor colorWithHexString:@"#531E7E"];
        [naviTitle setText:self.title];
        [_barView addSubview:naviTitle];
    }
    if(showBackBtn){
        UIButton *backBg = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        
        UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(5, backBg.frame.size.height/2-(25)/2,25,25)];
        [back setBackgroundImage:[UIImage imageNamed:@"common_header_back"] forState:UIControlStateNormal];
        [back addTarget:self action:@selector(baseBackAction) forControlEvents:UIControlEventTouchUpInside];
        [backBg addTarget:self action:@selector(baseBackAction) forControlEvents:UIControlEventTouchUpInside];
        _navigationBackButton = back;
        [backBg addSubview:back];
        [_barView addSubview:backBg];
    }
    return _barView;
}

-(void)baseBackAction{
   
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)bgViewAction
{
    if (_bgAction) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
//    SettingViewController* vcx= [[SettingViewController alloc]init];
//    [self.navigationController pushViewController:vcx animated:YES];
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
