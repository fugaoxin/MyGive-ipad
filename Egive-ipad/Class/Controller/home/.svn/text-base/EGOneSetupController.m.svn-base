//
//  EGOneSetupController.m
//  Egive-ipad
//
//  Created by User01 on 15/11/23.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGOneSetupController.h"
#import "AppDelegate.h"
#import "EGMyTabarViewController.h"
#import "EGHomeViewController.h"
#import "EGFollowCaseViewController.h"
#import "EGMessageCenterViewController.h"
#import "EGAboutGiveViewController.h"
#import "EGClickCharityViewController.h"
#import "EGKindnessRankingViewController.h"
#import "EGGiveInformationViewController.h"
#import "EGShareViewController.h"
#import "EGSettingViewController.h"
#import "MediaPlayer/MediaPlayer.h"
#import "EGPersonMemberZoneVC.h"
#import "EGRegisterAllViewController.h"//11.24
#import "EGMessageController.h"

@interface EGOneSetupController ()

@property (nonatomic,strong) MPMoviePlayerController *player;

@end

@implementation EGOneSetupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self setVideo];
}

-(void)setVideo
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"splash_ipad" ofType:@"mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    
    self.player = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    [self.player setContentURL:movieURL];
    [self.player setMovieSourceType:MPMovieSourceTypeFile];
    
    [[self.player view] setFrame:self.view.bounds];
    [self.player view].backgroundColor = [UIColor whiteColor];
    
    self.player.scalingMode = MPMovieScalingModeNone;
    self.player.controlStyle = MPMovieControlStyleNone;
    self.player.backgroundView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview: [self.player view]];
    [self.player play];
    
    NSUserDefaults * user=[NSUserDefaults standardUserDefaults];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (![[user objectForKey:@"one"] isEqualToString:@"one"]) {
            [self settingImage];
        }
        else
        {
            [self setTabBar];
        }
    });
}

-(void)settingImage
{
    UIImageView * view=[[UIImageView alloc] initWithFrame:CGRectMake((screenWidth-454)/2, (screenHeight-350)/2-40, 454, 350)];
    view.userInteractionEnabled=YES;
    view.backgroundColor=[UIColor redColor];
    view.tag=2;
    //554 × 450
    view.image=[UIImage imageNamed:@"dummy_case_related_default"];
    [self.view addSubview:view];

    for (int i=0; i<3; i++) {
        UIButton * button=[[UIButton alloc] initWithFrame:CGRectMake(55+(view.frame.size.width-110)/3*i, view.frame.size.height-50, (view.frame.size.width-110)/3, 40)];
        button.backgroundColor=[UIColor colorWithRed:110/255.0 green:185/255.0 blue:43/255.0 alpha:1];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addSubview:button];
        button.tag=i;
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            [button setTitle:@"English" forState:UIControlStateNormal];
        }
        if (i==1) {
            [button setTitle:@"繁" forState:UIControlStateNormal];
            UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, 1, button.frame.size.height-10)];
            label.backgroundColor=[UIColor whiteColor];
            label.alpha=0.6;
            [button addSubview:label];
        }
        if (i==2) {
            [button setTitle:@"简" forState:UIControlStateNormal];
            
            UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, 1, button.frame.size.height-10)];
            label.backgroundColor=[UIColor whiteColor];
            label.alpha=0.6;
            [button addSubview:label];
        }
    }
}

-(void)clickButton:(UIButton *)button
{
    NSUserDefaults * user=[NSUserDefaults standardUserDefaults];
    if (button.tag==0) {
        [user setObject:@"one" forKey:@"one"];
        [Language setLanguage:EN];
        [self setTabBar];
    }
    if (button.tag==1) {
        [user setObject:@"one" forKey:@"one"];
        [Language setLanguage:HK];
        [self setTabBar];
    }
    if (button.tag==2) {
        [user setObject:@"one" forKey:@"one"];
        [Language setLanguage:CN];
        [self setTabBar];
    }
}

-(void)setTabBar
{
    NSArray *titleArray = @[HKLocalizedString(@"MenuView_homeButton_title"),
                            HKLocalizedString(@"MenuView_FollowCase_title"),
                            HKLocalizedString(@"MenuView_MessageCenter_title"),
                            HKLocalizedString(@"MenuView_aboutButton_title"),
                            HKLocalizedString(@"MenuView_girdButton_title"),
                            HKLocalizedString(@"MenuView_rankingButton_title"),
                            HKLocalizedString(@"MenuView_InformationButton_title"),
                            HKLocalizedString(@"MenuView_shareButton_title"),
                            HKLocalizedString(@"MenuView_settingButton_title")];
    //非选中图片
    NSArray *photoArray = @[@"menu_home_nor",
                            @"menu_bookmark_nor",
                            @"menu_messenger_nor",
                            @"menu_about_nor",
                            @"menu_case_list_nor",
                            @"menu_ranking_nor",
                            @"menu_event_nor",
                            @"menu_share_nor",
                            @"menu_setting_nor"];
    //选中图片
    NSArray *selePArray = @[@"menu_home_sel",
                            @"menu_bookmark_sel",
                            @"menu_messenger_sel",
                            @"menu_about_sel",
                            @"menu_case_list_sel",
                            @"menu_ranking_sel",
                            @"menu_event_sel",
                            @"menu_share_sel",
                            @"menu_setting_sel"];
    EGMyTabarViewController *tBC = [[EGMyTabarViewController alloc]init];
    [tBC setTabBarControllerWithVCArray:@[[EGHomeViewController class],
                                          [EGFollowCaseViewController class],
                                          [EGMessageController class],
                                          [EGAboutGiveViewController class],
                                          [EGClickCharityViewController class],
                                          [EGKindnessRankingViewController class],
                                          [EGGiveInformationViewController class],
                                          [EGShareViewController class],
                                          [EGSettingViewController class],
                                          [EGPersonMemberZoneVC class],
                                          [EGRegisterAllViewController class]]
                          andPhotoArray:photoArray selectedPhotoArray:selePArray titleArray:titleArray];
    
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:tBC];
    nc.navigationBarHidden = YES;
    self.view.window.rootViewController = nc;
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
