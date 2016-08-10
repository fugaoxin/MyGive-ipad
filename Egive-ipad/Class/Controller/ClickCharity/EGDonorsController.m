//
//  EGDonorsController.m
//  Egive-ipad
//
//  Created by 123 on 15/12/8.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGDonorsController.h"

#define myWidth self.view.frame.size.width
#define myHeight self.view.frame.size.height
#define Theight 80   //图片高度

@interface EGDonorsController ()

@end

@implementation EGDonorsController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor=[UIColor whiteColor];
    self.title = [NSString stringWithFormat:@"%@(%lu)",HKLocalizedString(@"捐款者"),self.donorsArray.count];
    [self createNaviTopBarWithShowBackBtn:YES showTitle:YES];
    [self.navigationBackButton setBackgroundImage:[UIImage imageNamed:@"common_close"] forState:UIControlStateNormal];
    
    [self createUI];
}

//重写方法
-(void)baseBackAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createUI{
    //DLOG(@"myWidth==%f",myWidth);
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-400, screenHeight-50-50)];
    [self.contentView addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(0, self.donorsArray.count/5*160);
    
    for (int i = 0; i < self.donorsArray.count; i ++) {
        
        UIImageView * imageBG=[[UIImageView alloc] initWithFrame:CGRectMake(i%5*120+29, i/5*130+19, Theight+2, Theight+2)];
        imageBG.layer.cornerRadius = (Theight+2)/2;
        imageBG.layer.masksToBounds = YES;
        imageBG.backgroundColor = [UIColor lightGrayColor];
        imageBG.alpha=0.5;
        [scrollView addSubview:imageBG];
        
        NSDictionary * dict = self.donorsArray[i];
        UIImageView * donorsImage = [[UIImageView alloc] initWithFrame:CGRectMake(i%5*120+30, i/5*130+20, Theight, Theight)];
        //UIImageView * donorsImage = [[UIImageView alloc] initWithFrame:CGRectMake(i%5*Theight+((myWidth-5*Theight)/6), i/5*120+20, Theight, Theight)];
        //donorsImage.backgroundColor = [UIColor redColor];
        [scrollView addSubview:donorsImage];
        donorsImage.layer.cornerRadius = Theight/2;
        donorsImage.layer.masksToBounds = YES;
        NSURL *url = [NSURL URLWithString:SITE_URL];
        url = [url URLByAppendingPathComponent:dict[@"ImgURL"]];
        [donorsImage sd_setImageWithURL:url];
        
        UILabel * donorsName = [[UILabel alloc] initWithFrame:CGRectMake(i%5*120+30, i/5*130+100, Theight+4, Theight/2+10)];
        //donorsName.backgroundColor=[UIColor redColor];
        donorsName.text=dict[@"DonorName"];
        donorsName.textAlignment = NSTextAlignmentCenter;
        donorsName.font = [UIFont systemFontOfSize:13];
        donorsName.numberOfLines = 3;
        donorsName.textColor = greeBar;
        [scrollView addSubview:donorsName];
    }
    int lines = (int)self.donorsArray.count/5;
    if (self.donorsArray.count %5 > 0) lines++;
    //NSLog(@"lines = %d", lines);
    scrollView.contentSize = CGSizeMake(screenWidth-400, lines * 140);
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
