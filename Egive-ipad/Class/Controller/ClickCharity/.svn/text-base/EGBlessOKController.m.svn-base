//
//  EGBlessOKController.m
//  Egive-ipad
//
//  Created by 123 on 15/12/23.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGBlessOKController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

#define viewWith screenWidth-400
#define viewHeight screenHeight-50-44

@interface EGBlessOKController ()

@property (strong,nonatomic) MPMoviePlayerController *playerController;
@property (strong, nonatomic) UIView * successfulView;
@property (nonatomic,strong) UIButton * submitButton;

@end

@implementation EGBlessOKController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNVBar];
    [self setMainInterface];
}

#pragma mark - 设置导航栏
-(void)setNVBar
{
    self.title = HKLocalizedString(@"成功传送");
    [self createNaviTopBarWithShowBackBtn:YES showTitle:YES];
    [self.navigationBackButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
}

-(void)baseBackAction{
    
}

#pragma mark - 设置主界面
-(void)setMainInterface
{
    UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, viewHeight-50, viewWith, 50)];
    imageView.userInteractionEnabled=YES;
    imageView.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:244/255.0 alpha:1];
    [self.contentView addSubview:imageView];
    
    self.submitButton=[[UIButton alloc] initWithFrame:CGRectMake(20, 9, viewWith-40, 32)];
    self.submitButton.backgroundColor=greeBar;
    //[UIColor colorWithRed:90/255.0 green:172/255.0 blue:33/255.0 alpha:1];
    self.submitButton.layer.masksToBounds=YES;
    self.submitButton.layer.cornerRadius=4;
    [self.submitButton setTitle:HKLocalizedString(@"完成") forState:UIControlStateNormal];
    [imageView addSubview:self.submitButton];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(clickDetermineButton) forControlEvents:UIControlEventTouchUpInside];
    
    //成功传送的view
    _successfulView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWith, viewHeight-50)];
    //_successfulView.hidden = YES;
    _successfulView.backgroundColor = [UIColor whiteColor];
    //    _successfulView.layer.cornerRadius = 8;
    //    _successfulView.layer.masksToBounds = YES;
    [self.contentView addSubview:_successfulView];
    
    //创建视频controller
    NSString *path = [[NSBundle mainBundle] pathForResource:@"envelope1" ofType:@"mp4"];
    _playerController = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
    _playerController.view.backgroundColor = [UIColor whiteColor];
    _playerController.controlStyle = MPMovieControlStyleNone;   //视频无框
    _playerController.scalingMode = MPMovieScalingModeAspectFill;  //设置视频全屏
    _playerController.view.frame = CGRectMake(0, 0,viewWith, _successfulView.frame.size.height);
    _playerController.repeatMode = MPMovieRepeatModeOne;    //设置视频循环播放
    [_successfulView addSubview:_playerController.view];
    
    [self.playerController play];
}

-(void)clickDetermineButton
{
    if ([self.disappearStr isEqualToString:@"disappear"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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
