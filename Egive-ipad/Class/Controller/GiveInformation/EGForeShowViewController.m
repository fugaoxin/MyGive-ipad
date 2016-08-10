//
//  EGForeShowViewController.m
//  Egive-ipad
//
//  Created by kevin on 15/12/26.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGForeShowViewController.h"
#import "EGForeShowListCell.h"
#import "EGGiveItemModel.h"

@interface EGForeShowViewController ()<UIScrollViewDelegate>
{
    UIView *contantView;
    UIView *headIVcontant;
    UIPageControl *pageControl;
    
//    UIImageView *headIV;
    UIView *line;
    UILabel *titleLab;
    UILabel *dateLab;
    UILabel *receiveMessageLab;
    NSArray *itemList;
}

@end

@implementation EGForeShowViewController
-(void)viewWillAppear:(BOOL)animated{
//    [self GetEventDtlListWithEventTp:@"P" Year:@"2015"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
    self.view.backgroundColor = [UIColor whiteColor];
    [self GetEventDtlListWithEventTp:@"P" Year:@""];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
    });
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VCgoVC:) name:@"informationDetail" object:nil];
}

-(void)VCgoVC:(NSNotification *)notification
{
    [self informationGotoDataEventTp:@"P" Year:@"" andCaseID:[notification.userInfo[@"index"] objectForKey:@"CaseID"]];
}

-(void)informationGotoDataEventTp:(NSString *)EventTp Year:(NSString*)Year andCaseID:(NSString *)CaseID
{
    [SVProgressHUD show];
    WEAK_VAR(weakSelf, self);
    [EGGiveItemModel getEventDtlListWithEventTp:EventTp year:Year block:^(EGGiveItem *result, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            
            if (result.ItemList && result.ItemList.count>0) {
                weakSelf.view.backgroundColor = [UIColor colorWithHexString:@"#EBEAEB"];
                for(int i=0; i<result.ItemList.count; i++){
                    EGGiveItemModel * Item = result.ItemList[i];
                    if ([Item.EventID isEqualToString:CaseID]) {
                        itemList = result.ItemList;
                        [weakSelf.leftTableView reloadData];
                        [weakSelf.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                        [weakSelf setScrollViewUI:Item];
                    }
                }
            }
        }
    }];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"informationDetail" object:nil];
}

- (void)GetEventDtlListWithEventTp:(NSString *)EventTp Year:(NSString*)Year
{
    [SVProgressHUD show];
    WEAK_VAR(weakSelf, self);
    [EGGiveItemModel getEventDtlListWithEventTp:EventTp year:Year block:^(EGGiveItem *result, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            
            if (result.ItemList && result.ItemList.count>0) {
                weakSelf.view.backgroundColor = [UIColor colorWithHexString:@"#EBEAEB"];
                //                self.leftTableView.backgroundColor = [UIColor colorWithHexString:@"#EBEAEB"];
                itemList = result.ItemList;
                [weakSelf.leftTableView reloadData];
                EGGiveItemModel*ItemModel = itemList.firstObject;
                if (ItemModel) {
                    [weakSelf.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                    [weakSelf setScrollViewUI:ItemModel];
                }
                
            }
        }
        else{
            //            [UIAlertView alertWithText:[error.userInfo objectForKey:@"NSLocalizedDescription"]?[error.userInfo objectForKey:@"NSLocalizedDescription"]:@"unknown error"];
        }
    }];
}
-(UILabel*)createLabel:(CGFloat)fontSize
{
    UILabel* label =[[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}


-(void)createUI{
    _rightScrollView = [[UIScrollView alloc]init];
    _rightScrollView.backgroundColor = [UIColor whiteColor];
     [self.view addSubview:_rightScrollView];
    [_rightScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(3);
        make.left.mas_equalTo(383);
        make.width.mas_equalTo(WIDTH-64-383);
        make.height.mas_equalTo(HEIGHT-44-3-44);
    }];
//    _rightScrollView.frame = CGRectMake(383, 100, 300, 300);
//    [self.view addSubview:_rightScrollView];
    
    contantView = [UIView new];
    contantView.userInteractionEnabled = YES;
    contantView.backgroundColor = [UIColor clearColor];
    [_rightScrollView addSubview:contantView];
    
    [contantView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_rightScrollView);
        make.width.equalTo(_rightScrollView);
    }];
    
    _headIVScrollView = [[UIScrollView alloc]init];
    _headIVScrollView.backgroundColor = [UIColor whiteColor];
    _headIVScrollView.showsHorizontalScrollIndicator = NO;
    _headIVScrollView.delegate = self;
    _headIVScrollView.pagingEnabled = YES;
    
    [contantView addSubview:_headIVScrollView];
    
    [_headIVScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.equalTo(contantView).offset(20);
        make.right.equalTo(contantView).offset(-20);
        make.height.mas_equalTo(((WIDTH-64-383)-20*2)*3/4);
    }];
    
    headIVcontant = [UIView new];
    headIVcontant.backgroundColor = [UIColor clearColor];
    [_headIVScrollView addSubview:headIVcontant];
    
    [headIVcontant mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_headIVScrollView);
        make.height.equalTo(_headIVScrollView);
        
    }];
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-20, 50, 10)];
    pageControl.numberOfPages = 1;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.userInteractionEnabled = NO;
    [contantView addSubview:pageControl];
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contantView).offset(-10);
        make.left.equalTo(contantView).offset(10);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(_headIVScrollView).offset(-5);
    }];

//    headIV =[ [UIImageView alloc]init];
//    headIV.backgroundColor = [UIColor clearColor];
//    headIV.hidden = YES;
//    [contantView addSubview:headIV];
//    [headIV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(20);
//        make.left.equalTo(contantView).offset(20);
//        make.right.equalTo(contantView).offset(-20);
//        make.height.mas_equalTo((*3/4);
//    }];
    
    titleLab = [self createLabel:16];
    titleLab.font = [UIFont boldSystemFontOfSize:16];
    titleLab.textColor = [UIColor colorWithHexString:@"#531E7E"];
    [contantView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headIVScrollView.mas_bottom).offset(20);
        make.left.equalTo(contantView).offset(20);
        make.right.equalTo(contantView).offset(-20);
        make.height.mas_equalTo(30);
    }];
    //    //
    line = [UIView new];
    line.backgroundColor =  [UIColor colorWithHexString:@"#B6B6B6"];
    [contantView addSubview:line];
    line.hidden = YES;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(15);
        make.left.equalTo(titleLab);
        make.right.equalTo(titleLab);
        make.height.mas_equalTo(1);
    }];
    dateLab = [self createLabel:14];
    dateLab.textColor = [UIColor grayColor];
    [contantView addSubview:dateLab];
    [dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(15);
        make.left.equalTo(line);
        make.right.equalTo(line);
        make.height.mas_equalTo(20);
    }];
    
    //
    receiveMessageLab = [self createLabel:14];
    receiveMessageLab.numberOfLines=0;
    receiveMessageLab.textColor = [UIColor blackColor];
    [contantView addSubview:receiveMessageLab];
    [receiveMessageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLab.mas_bottom).offset(20);
        make.left.equalTo(dateLab);
        make.right.equalTo(dateLab);
        make.height.mas_equalTo(300);
    }];
    //
    
    [contantView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(receiveMessageLab.mas_bottom).offset(10);
    }];
}

-(UIImage*)rerol:(UIImage*)aImage{

    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));

    CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
  
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;

}

-(void)setHeadViewUI:(EGGiveItemModel*)ItemModel
{
    NSArray* Img = ItemModel.Img;
    NSURL *url = nil;
    NSInteger imgConut = Img.count;
    CGFloat imageWidth = ((WIDTH-64-383)-20*2);
    for (int i =0; i<imgConut; i++) {
        UIImageView* iv =[ [UIImageView alloc]init];
        iv.backgroundColor = [UIColor clearColor];
        iv.userInteractionEnabled = YES;
        iv.tag = i;
        [headIVcontant addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headIVcontant);
            make.left.equalTo(headIVcontant).offset(i* imageWidth);
            make.height.mas_equalTo(imageWidth*3/4);
            make.width.mas_equalTo(imageWidth);
        }];
        NSString *ImgURL =  Img[i][@"ImgURL"];
        url = [[NSURL URLWithString:SITE_URL] URLByAppendingPathComponent:ImgURL];
        WEAK_VAR(weakSelf, self);
        [iv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"dummy_case_related_default"] options:SDWebImageRetryFailed|SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                iv.image = [weakSelf rerol:image];
            }
            iv.contentMode = UIViewContentModeScaleToFill;
        }];
 
    }
    if (imgConut == 0) {
        imgConut = 1;
        UIImageView* iv =[ [UIImageView alloc]init];
        iv.backgroundColor = [UIColor clearColor];
        iv.userInteractionEnabled = YES;
        iv.tag = 0;
        [headIVcontant addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headIVcontant);
            make.left.equalTo(headIVcontant);
            make.height.mas_equalTo(imageWidth*3/4);
            make.width.mas_equalTo(imageWidth);
        }];
        iv.image = [UIImage imageNamed:@"dummy_case_related_default"];
    }
    pageControl.numberOfPages = imgConut;
    [headIVcontant mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(imgConut * imageWidth);
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (sender == _headIVScrollView) {
        CGFloat pageWith = ((WIDTH-64-383)-20*2);
        NSInteger page = (_headIVScrollView.contentOffset.x + (0.5f * pageWith)) / pageWith;
        if (pageControl.currentPage != page) {
            pageControl.currentPage = page;
            
        }
    }
}
-(void)setScrollViewUI:(EGGiveItemModel*)ItemModel
{
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:ItemModel.Title forKey:@"EventName_GiveInfomation_foreshow"];

    line.hidden = NO;
    [self setHeadViewUI:ItemModel];
//    NSArray* Img = ItemModel.Img;
//    NSURL *url = nil;
//    if (Img.count>0) {
//        NSString *ImgURL =  Img[0][@"ImgURL"];
//        url = [[NSURL URLWithString:SITE_URL] URLByAppendingPathComponent:ImgURL];
//        
//    }
//    WEAK_VAR(weakSelf, self);
//    [headIV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"dummy_case_related_default"] options:SDWebImageRetryFailed|SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (image) {
//            headIV.image = [weakSelf rerol:image];
////            [standardUserDefaults setObject:image forKey:@"EventPic_GiveInfomation_foreshow"];
//        }
//        
//        headIV.contentMode = UIViewContentModeScaleToFill;
//    }];
  
    titleLab.text = ItemModel.Title;
    CGRect rect = _rightScrollView.frame;
    CGSize maxSize = CGSizeMake(rect.size.width - 20*2, CGFLOAT_MAX);
    CGSize size = [titleLab sizeThatFits:maxSize];
    [titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height+10);
    }];
    
    
    NSString* dateStr = @"";
    NSString* EventStartDate = ItemModel.EventStartDate.length>10?[ItemModel.EventStartDate substringToIndex:10]:ItemModel.EventStartDate;
    NSString* EventEndDate = ItemModel.EventEndDate.length>10?[ItemModel.EventEndDate substringToIndex:10]:ItemModel.EventEndDate;
    if (EventEndDate.length > 0) {
        dateStr =[HKLocalizedString(@" 至 ") stringByAppendingString:EventEndDate];
    }
    dateStr = [EventStartDate stringByAppendingString:dateStr];
    NSMutableAttributedString *date = [[NSMutableAttributedString alloc] initWithString:[HKLocalizedString(@"DonationInfo_foreshow_date") stringByAppendingString:dateStr] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14],NSForegroundColorAttributeName: [UIColor grayColor]}];
    [date addAttribute:NSForegroundColorAttributeName
                 value:[UIColor blackColor]
                 range:NSMakeRange(HKLocalizedString(@"DonationInfo_foreshow_date").length,EventStartDate.length)];
    [date addAttribute:NSForegroundColorAttributeName
                 value:[UIColor blackColor]
                 range:NSMakeRange(dateStr.length-EventEndDate.length+HKLocalizedString(@"DonationInfo_foreshow_date").length,EventEndDate.length)];
    [date endEditing];
    dateLab.attributedText = date;
    receiveMessageLab.text = ItemModel.Desp;
    
    
    maxSize = CGSizeMake(rect.size.width - 30*2, CGFLOAT_MAX);
    size = [receiveMessageLab sizeThatFits:maxSize];
    [receiveMessageLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height);
    }];

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
    return 120;
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    static NSString * str=@"cell";
    EGForeShowListCell * cell=[tableView dequeueReusableCellWithIdentifier:str];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EGForeShowListCell" owner:self options:nil];
    if (!cell && [nib count]>0)
    {
        cell = [nib objectAtIndex:0];
        cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor=[UIColor colorWithHexString:@"#EBEAEB"];
    }
    
    //        cell.selectionStyle=UITableViewCellSelectionStyleNone;//cell的选中风格

    if (itemList) {
        EGGiveItemModel*ItemModel = itemList[indexPath.row];
        if (ItemModel) {
           
            NSArray* Img = ItemModel.Img;
            if (Img.count) {
                NSString *ImgURL =  Img[0][@"ImgURL"];
                NSURL *url = [NSURL URLWithString:SITE_URL];
                url = [url URLByAppendingPathComponent:ImgURL];
                WEAK_VAR(weakSelf, self);
                [cell.iv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"dummy_case_related_default"] options:SDWebImageRetryFailed|SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image) {
                        cell.iv.image = [weakSelf rerol:image];
                    }
                    cell.iv.contentMode = UIViewContentModeScaleToFill;
                }];
            }
            cell.title.text = ItemModel.Title ;
            //
            
            cell.ivWidth.constant = 120*4/3.0;
            
            NSString* dateStr = @"";
            NSString* EventStartDate = ItemModel.EventStartDate.length>10?[ItemModel.EventStartDate substringToIndex:10]:ItemModel.EventStartDate;
            NSString* EventEndDate = ItemModel.EventEndDate.length>10?[ItemModel.EventEndDate substringToIndex:10]:ItemModel.EventEndDate;
            if (EventEndDate.length > 0) {
                dateStr =[HKLocalizedString(@" 至 ") stringByAppendingString:EventEndDate];
            }
            dateStr = [EventStartDate stringByAppendingString:dateStr];
            NSMutableAttributedString *date = [[NSMutableAttributedString alloc] initWithString:dateStr attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14],NSForegroundColorAttributeName: [UIColor grayColor]}];
            [date addAttribute:NSForegroundColorAttributeName
                           value:[UIColor blackColor]
                           range:NSMakeRange(0,EventStartDate.length)];
            [date addAttribute:NSForegroundColorAttributeName
                           value:[UIColor blackColor]
                           range:NSMakeRange(dateStr.length-EventEndDate.length,EventEndDate.length)];
            [date endEditing];
            
            cell.date.attributedText = date;
            cell.desp.text = ItemModel.Desp;
        }
    }
    return cell;

}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (itemList) {
        EGGiveItemModel*ItemModel = itemList[indexPath.row];
        if (ItemModel) {
            [self setScrollViewUI:ItemModel];
            DLOG(@"EventID===%@",ItemModel.EventID);
        }
    }
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
