//
//  EGReleaseCenterViewController.m
//  Egive-ipad
//
//  Created by kevin on 15/12/26.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGReleaseCenterViewController.h"
#import "EGGiveItemModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"

@interface EGReleaseCenterViewController ()<UIWebViewDelegate>
{
    UILabel * titleLabel;
    UIView *line;
    NSArray* itemList;
    NSURL* videoUrl;
    UIButton * playButton;
}
@property (nonatomic,retain) UIWebView *svWebView;
@property (nonatomic,retain) UIImageView *videoView;
@end

@implementation EGReleaseCenterViewController

-(void)viewWillAppear:(BOOL)animated{
//    [self getEventCentreList];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUI];
    [self getEventCentreList];
//
}

- (void)getEventCentreList
{
    [SVProgressHUD show];
    [EGAnnouncement getEventCentreListWithBlock:^(NSArray *results, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            if (results.count>0) {
                self.view.backgroundColor = [UIColor colorWithHexString:@"#EBEAEB"];
                
                itemList = results;
                [self.leftTableView reloadData];
                EGAnnouncement*ItemModel = itemList.firstObject;
                if (ItemModel) {
                    [self setRightViewUI:ItemModel];
                    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
            }
        
        }
        else{
//            [UIAlertView alertWithText:[error.userInfo objectForKey:@"NSLocalizedDescription"]?[error.userInfo objectForKey:@"NSLocalizedDescription"]:@"unknown error"];
        }
    }];
    
}

-(void)createUI{
    //
    titleLabel = [[UILabel alloc]init];
    //titleLabel.backgroundColor=[UIColor redColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.numberOfLines=0;
    titleLabel.textColor = [UIColor colorWithHexString:@"#531E7E"];
    [_rightView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rightView).offset(10);
        make.left.equalTo(_rightView).offset(20);
        make.right.equalTo(_rightView).offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    line = [UIView new];
    line.backgroundColor =  [UIColor colorWithHexString:@"#B6B6B6"];
    [_rightView addSubview:line];
    line.hidden = YES;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
//        make.left.equalTo(titleLabel);
//        make.right.equalTo(titleLabel);
        make.left.equalTo(_rightView);
        make.right.equalTo(_rightView);
        make.height.mas_equalTo(1);
    }];
    
    _svWebView= [[UIWebView alloc] initWithFrame:CGRectMake(0, 155, 500,355)];
    _svWebView.backgroundColor = [UIColor whiteColor];
    _svWebView.scalesPageToFit = YES;
    _svWebView.delegate = self;
    [_rightView addSubview:_svWebView];
    [_svWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(20);
        make.left.equalTo(line);
        make.right.equalTo(line);
        make.bottom.equalTo(_rightView).offset(-20);
    }];
    
    
    _videoView = [[UIImageView alloc]init];
    _videoView.image = [UIImage imageNamed:@"dummy_case_related_default"];
    _videoView.userInteractionEnabled=YES;
    _videoView.contentMode = UIViewContentModeScaleToFill;
    
    [_rightView addSubview:_videoView];
    [_videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(20);
        make.left.equalTo(line);
        make.right.equalTo(line);
        make.height.mas_equalTo(400);
    }];
    
    playButton =[[UIButton alloc] init];
    [_videoView addSubview:playButton];
    [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_videoView).offset(20);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(_videoView.mas_bottom).offset(-20);
    }];
    [playButton addTarget:self action:@selector(clickplayButton:) forControlEvents:UIControlEventTouchUpInside];
    [playButton setBackgroundImage:[UIImage imageNamed:@"comment_play"] forState:UIControlStateNormal];
    
    _svWebView.hidden = YES;
    _videoView.hidden = YES;
}
-(void)setRightViewUI:(EGAnnouncement*)ItemModel
{
    _svWebView.hidden = YES;
    _videoView.hidden = YES;
    
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:ItemModel.Title forKey:@"EventName_GiveInfomation_center"];
    [standardUserDefaults synchronize];
   
    line.hidden = NO;
    titleLabel.text = ItemModel.Title;
    CGSize maxSize = CGSizeMake(self.rightView.frame.size.width - 20*2, CGFLOAT_MAX);
    CGSize size = [titleLabel sizeThatFits:maxSize];
    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height+10);
    }];
    
    [MBProgressHUD hideHUDForView:_rightView animated:YES];
    [_svWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    
    
    NSURL *targetURL = nil;
    if (ItemModel.FilePath.length > 0) {
        targetURL = [[NSURL URLWithString:SITE_URL] URLByAppendingPathComponent:ItemModel.FilePath];
    }else if(ItemModel.URL.length>0){
        targetURL = [NSURL URLWithString:ItemModel.URL];
    }
    NSString* urlString = [NSString stringWithFormat:@"%@",targetURL];
    if ([urlString rangeOfString:@".mp4"].location != NSNotFound)  {
        _videoView.hidden = NO;
        videoUrl = targetURL;
        NSThread *thr = [[NSThread alloc]initWithTarget:self selector:@selector(getThumbnailImage) object:nil];
        [thr start];
       
    }
//    else if ([urlString rangeOfString:@".jpg"].location != NSNotFound)  {
//        _videoView.hidden = NO;
//        [_videoView sd_setImageWithURL:targetURL placeholderImage:[UIImage imageNamed:@"dummy_case_related_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if (image) {
////                [standardUserDefaults setObject:image forKey:@"EventPic_GiveInfomation_center"];
//            }
//        }];
//        
//        
//    }
    else{
        [MBProgressHUD showHUDAddedTo:_rightView animated:YES];
//        NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:targetURL];
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        
        [_svWebView loadRequest:request];
    }
    
}
-(void)getThumbnailImage{
    
    NSString *urlString = [NSString stringWithFormat:@"%@",videoUrl];
    UIImage *ThumbnailImage = [self getThumbnailImage:urlString];
    _videoView.image=ThumbnailImage;
    
}

-(void)clickplayButton:(UIButton *)button
{
    MPMoviePlayerViewController *mpvc = [[MPMoviePlayerViewController alloc] initWithContentURL:videoUrl];
    [self presentViewController:mpvc animated:YES completion:nil];
}

-(UIImage *)getThumbnailImage:(NSString *)videoURL{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:videoURL] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(5, 20);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if (error) {
        DLOG(@"截取视频图片失败:%@",error.localizedDescription);
        return [UIImage imageNamed:@"dummy_case_related_default"];
    }
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    return thumb;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return itemList?itemList.count:0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EGAnnouncement*ItemModel = itemList[indexPath.row];
    if (ItemModel) {
        
        UILabel* aLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1000, CGFLOAT_MAX)];
        aLabel.numberOfLines = 0;
        aLabel.font = [UIFont systemFontOfSize:16.0f];
        aLabel.text =[@"\n" stringByAppendingString:ItemModel.Title];
        
        CGSize maxSize = CGSizeMake(380 - 15*2, CGFLOAT_MAX);
        CGSize size = [aLabel sizeThatFits:maxSize];
        
        return 60+size.height+5;
        
        
    }
    return 85;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * str=@"centerCell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
        
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
//        cell.textLabel.textColor = [UIColor colorWithHexString:@"#531E7E"];
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#531E7E"];
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0f];
        
        UIView * line1= [[UIView alloc]initWithFrame:CGRectMake(0, 72-2, self.leftTableView.frame.size.width, 2)];
        line1.tag = 9999;
        [cell.contentView addSubview:line1];
        line1.backgroundColor = [UIColor colorWithHexString:@"#EBEAEB"];
        cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor=[UIColor colorWithHexString:@"#EBEAEB"];
        
    }
    if (itemList) {
        EGAnnouncement*ItemModel = itemList[indexPath.row];
        if (ItemModel) {
            cell.textLabel.text = ItemModel.PublishDate;
            cell.detailTextLabel.text = [@"\n" stringByAppendingString:ItemModel.Title];//ItemModel.Title;
            
            UILabel* aLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1000, CGFLOAT_MAX)];
            aLabel.numberOfLines = 0;
            aLabel.font = [UIFont systemFontOfSize:16.0f];
            aLabel.text = [@"\n" stringByAppendingString:ItemModel.Title];
            
            CGSize maxSize = CGSizeMake(380 - 15*2, CGFLOAT_MAX);
            CGSize size = [aLabel sizeThatFits:maxSize];
           
            UIView *line2 = [cell.contentView viewWithTag:9999];
            line2.frame = CGRectMake(0, 60+size.height+5-2, self.leftTableView.frame.size.width, 2);
            NSLog(@"");
        }
    }
    
    return cell;
    
}
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (itemList) {
        EGAnnouncement*ItemModel = itemList[indexPath.row];
        if (ItemModel) {
            [self setRightViewUI:ItemModel];
        }
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    _svWebView.hidden = NO;
    [MBProgressHUD hideHUDForView:_rightView animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
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
