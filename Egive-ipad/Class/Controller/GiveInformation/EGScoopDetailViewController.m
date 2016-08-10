//
//  EGScoopDetailViewController.m
//  Egive-ipad
//
//  Created by kevin on 15/12/26.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGScoopDetailViewController.h"
#import "EGForeShowListCell.h"
#import "EGGiveItemModel.h"
#import "EGScoopImageShowViewController.h"

@interface EGScoopDetailViewController ()
{
    UIView *contantView;
    UIView *headIV;
    UILabel *titleLab;
    UILabel *dateLab;
    UILabel *receiveMessageLab;
    NSDictionary *dataDic;
    NSArray* itemList;
    int selectTag;
    
    UIButton * hideBtn;
    UIButton * openBtn;
    CGFloat  messageLabelH;
    CGFloat bottomHeight;
}

@end


@implementation EGScoopDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    
//    [self GetEventDtlListWithEventTp:@"R" Year:HKLocalizedString(@"全部")];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
   
    messageLabelH = 20;
    [self createUI];
    [self createHeadView];
    selectTag = 0;
    
    [self GetEventDtlListWithEventTp:@"R" Year:HKLocalizedString(@"全部")];
}

-(void)createHeadView{
    UIImageView* selectView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _timeTF.frame.size.width, _timeTF.frame.size.height)];
    selectView.image = [self getImage];
    [_timeTF addSubview:selectView];
    [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_timeTF);
        make.height.mas_equalTo(_timeTF);
        make.left.equalTo(_timeTF);
        make.right.equalTo(_timeTF);
        
    }];
    self.timeSelView.layer.borderWidth = 0.5;
    self.timeSelView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self getTimeArr];
}
-(void)getTimeArr{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy"];
    NSString *  nowYear=[dateformatter stringFromDate:senddate];
    NSString * lastYear = [NSString stringWithFormat:@"%d",[nowYear intValue]-1];
    
    self.timeSelView.hidden = YES;
    self.timeTF.text = HKLocalizedString(@"全部");
    [self.timeAllBtn setTitle:HKLocalizedString(@"全部") forState:UIControlStateNormal];
    [self.timeOneBtn setTitle:nowYear forState:UIControlStateNormal];
    [self.timeTwoBtn setTitle:lastYear forState:UIControlStateNormal];
}
-(UIImage*)getImage{
    UIImage* image = [UIImage imageNamed:@"comment_picker"];
    CGFloat top = 5; // 顶端盖高度
    CGFloat bottom = 5 ; // 底端盖高度
    CGFloat left = 5; // 左端盖宽度
    CGFloat right = 22; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    return image;
}
- (void)GetEventDtlListWithEventTp:(NSString *)EventTp Year:(NSString*)Year
{
    if ([Year isEqualToString:HKLocalizedString(@"全部")]) {
        Year = @"";
    }
    if (itemList && itemList.count>0) {
        itemList = nil;
        [self setScrollViewUI:nil];
        [self.leftTableView reloadData];
    }
    
    [SVProgressHUD show];
    [EGGiveItemModel getEventDtlListWithEventTp:EventTp year:Year block:^(EGGiveItem *result, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            
            if (result.ItemList && result.ItemList.count>0) {
                self.view.backgroundColor = [UIColor colorWithHexString:@"#EBEAEB"];
                
                itemList = result.ItemList;
                [self.leftTableView reloadData];
                EGGiveItemModel*ItemModel = itemList.firstObject;
                if (ItemModel) {
                    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                    [self setScrollViewUI:ItemModel];
                }
            }
        }
        else{
//            [UIAlertView alertWithText:[error.userInfo objectForKey:@"NSLocalizedDescription"]?[error.userInfo objectForKey:@"NSLocalizedDescription"]:@"unknown error"];
        }
    }];
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    // 关闭键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if (textField == _timeTF) {
        self.timeSelView.hidden = NO;
        return NO;
    }
    
    return YES;
}


#pragma mark UI
-(UILabel*)createLabel:(CGFloat)fontSize
{
    UILabel* label =[[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}
-(UIButton*)createButton:(NSString*)title
{
    UIButton* btn = [[UIButton alloc]init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
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
    
    contantView = [UIView new];
    contantView.userInteractionEnabled = YES;
    contantView.backgroundColor = [UIColor clearColor];
    [_rightScrollView addSubview:contantView];
    
    [contantView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_rightScrollView);
        make.width.equalTo(_rightScrollView);
    }];
    headIV =[ [UIView alloc]init];
    headIV.backgroundColor = [UIColor clearColor];
    [contantView addSubview:headIV];
    [headIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.equalTo(contantView).offset(10);
        make.right.equalTo(contantView).offset(-10);
        make.height.mas_equalTo(((WIDTH-64-383)-20*2)*3/4);
    }];
    //img is nil
//    headIV.image = [UIImage imageNamed:@"dummy_case_related_default"];
//    headIV.contentMode = UIViewContentModeScaleToFill;
    //
    
    [contantView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headIV.mas_bottom).offset(10);
    }];
    
    
    //
    _rightBottomView = [UIView new];
    _rightBottomView.backgroundColor = [UIColor whiteColor];
    _rightBottomView.alpha = 0.85;
    [self.view addSubview:_rightBottomView];
    [_rightBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.mas_equalTo(383);
        make.width.mas_equalTo(WIDTH-64-383);
        make.height.mas_equalTo(90);
    }];
    
    titleLab = [self createLabel:14];
    titleLab.font = [UIFont boldSystemFontOfSize:16];
    titleLab.textColor = [UIColor colorWithHexString:@"#531E7E"];
    [_rightBottomView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rightBottomView);
        make.left.equalTo(_rightBottomView).offset(20);
        make.right.equalTo(_rightBottomView).offset(-20);
        make.height.mas_equalTo(30);
    }];
 
    hideBtn = [self createButton:HKLocalizedString(@"隐藏")];
    hideBtn.tag = 1;
    [_rightBottomView addSubview:hideBtn];
    [hideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rightBottomView).offset(5);
        make.right.equalTo(_rightBottomView).offset(-5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(45);
    }];
    
    _bottomScrollView  = [[UIScrollView alloc]init];
    _bottomScrollView.backgroundColor = [UIColor whiteColor];
    [_rightBottomView addSubview:_bottomScrollView];
    [_bottomScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(5);
        make.left.equalTo(titleLab);
        make.right.equalTo(titleLab);
        make.height.mas_equalTo(messageLabelH);
    }];
    
    receiveMessageLab = [self createLabel:14];
    receiveMessageLab.numberOfLines= 0;
    receiveMessageLab.textColor = [UIColor blackColor];
    [_bottomScrollView addSubview:receiveMessageLab];
    [receiveMessageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bottomScrollView);
        make.width.equalTo(_bottomScrollView);
        make.height.mas_equalTo(messageLabelH);
    }];
    
    dateLab = [self createLabel:14];
    dateLab.textColor = [UIColor grayColor];
    [_rightBottomView addSubview:dateLab];
    [dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rightBottomView.mas_bottom).offset(-35);
        make.left.equalTo(receiveMessageLab);
        make.right.equalTo(receiveMessageLab);
        make.height.mas_equalTo(30);
    }];
    
    openBtn = [self createButton:HKLocalizedString(@"More")];
    openBtn.tag = 2;
    [_rightBottomView addSubview:openBtn];
    [openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rightBottomView.mas_bottom).offset(-35);
        make.right.equalTo(_rightBottomView).offset(-5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(45);
    }];
    
    
}

-(void)bottomButtonAction:(UIButton*)btn
{
    if (btn.tag == 1) {
        hideBtn.hidden = YES;
        openBtn.hidden = NO;
        
        [_bottomScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
        }];
        [receiveMessageLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
        }];
        [_rightBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(bottomHeight);
        }];
    }
    else{
        hideBtn.hidden = NO;
        openBtn.hidden = YES;
        
        if (messageLabelH > 400) {
            [_bottomScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(400);
            }];
        }
        else{
            [_bottomScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(messageLabelH);
            }];
        }
        [receiveMessageLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(messageLabelH);
        }];
        [_rightBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(messageLabelH + bottomHeight - 20);
        }];
    }
    
}

-(void)setScrollViewUI:(EGGiveItemModel*)ItemModel
{
    
    for (UIView* sub in headIV.subviews) {
        if ([sub isKindOfClass:[UIImageView class]]) {
            [sub removeFromSuperview];
        }
    }
    hideBtn.hidden = YES;
    openBtn.hidden = YES;
    
    titleLab.text = @"";
    dateLab.text=@"";
    receiveMessageLab.text=@"";
    _rightScrollView.scrollEnabled = NO;
    if (ItemModel) {
        _rightScrollView.scrollEnabled = YES;
        NSArray* Img = ItemModel.Img;
        NSURL *url = nil;
        CGFloat width = (_rightScrollView.frame.size.width-20*2)/3;
        CGFloat height = width;
        
        titleLab.text = ItemModel.Title;
        CGRect rect = _rightScrollView.frame;
        CGSize maxSize = CGSizeMake(rect.size.width - 20*2 -50, CGFLOAT_MAX);
        CGSize size = [titleLab sizeThatFits:maxSize];
        [titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(size.height+10);
        }];
        
        bottomHeight = size.height+5+45+20;
        [_rightBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(bottomHeight);
        }];
        
        NSString* EventStartDate = ItemModel.EventStartDate.length>10?[ItemModel.EventStartDate substringToIndex:10]:ItemModel.EventStartDate;
        NSString* dateStr = HKLocalizedString(@"DonationInfo_foreshow_date");
        dateStr = [dateStr stringByAppendingString:EventStartDate];
        NSMutableAttributedString *date = [[NSMutableAttributedString alloc] initWithString:[@"" stringByAppendingString:dateStr] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14],NSForegroundColorAttributeName: [UIColor grayColor]}];
        [date addAttribute:NSForegroundColorAttributeName
                     value:[UIColor blackColor]
                     range:NSMakeRange(dateStr.length-EventStartDate.length,EventStartDate.length)];
        [date endEditing];
        dateLab.attributedText = date;
        
        receiveMessageLab.text = ItemModel.Desp;
        
        maxSize = CGSizeMake(rect.size.width - 30*2, CGFLOAT_MAX);
        
        size = [receiveMessageLab sizeThatFits:maxSize];
        if (size.height > 20) {
            openBtn.hidden = NO;
            messageLabelH = size.height+5;
        }
        [receiveMessageLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
        }];
        
        
        
        for (int i =0; i<Img.count; i++) {
            UIImageView* iv =[ [UIImageView alloc]init];
            iv.backgroundColor = [UIColor clearColor];
            iv.tag = i;
            [headIV addSubview:iv];
            int y = i%3;
            int x = i/3;
            //        NSLog(@"%d--%d",x,y);
            [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(x*(10+height));
                make.left.equalTo(headIV).offset(y*(10+width));
                make.height.mas_equalTo(height);
                make.width.mas_equalTo(width);
            }];
            iv.userInteractionEnabled = YES;
            NSString *ImgURL =  Img[i][@"ImgURL"];
            url = [[NSURL URLWithString:SITE_URL] URLByAppendingPathComponent:ImgURL];
            [iv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"dummy_case_related_default"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
            iv.contentMode = UIViewContentModeScaleAspectFill;        // 设置图片正常填充
            iv.clipsToBounds = YES;
            
            UITapGestureRecognizer * imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
            [iv addGestureRecognizer:imageTap];
        }
        headIV.userInteractionEnabled = YES;
        [headIV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(ceilf(Img.count/3.0)*(height+10) + bottomHeight);
        }];
        
        

    }
    
}

- (IBAction)btnAction:(UIButton*)sender {
    self.timeSelView.hidden = YES;
    _timeTF.text = sender.titleLabel.text;
    [self GetEventDtlListWithEventTp:@"R" Year:_timeTF.text];
}

-(void)imageTapAction:(UITapGestureRecognizer*)tap
{
    
    UIImageView *iv = (UIImageView * )tap.view;
  
    if (itemList) {
        EGGiveItemModel*ItemModel = itemList[selectTag];
        if (ItemModel) {
            CGSize size = CGSizeMake(WIDTH-350, HEIGHT-20);//(410, 570)
            EGScoopImageShowViewController* root = [[EGScoopImageShowViewController alloc]init];//

            root.selectImageTag = iv.tag;
            root.ItemModel = ItemModel;
            
            [root setContentSize:size  bgAction:NO animated:NO];
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:root];
            navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:navigationController animated:NO completion:nil];
        }
    }

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
                [cell.iv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"dummy_case_related_default"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
                cell.iv.contentMode = UIViewContentModeScaleToFill;
            }
            cell.title.text = ItemModel.Title ;
            //
            cell.ivWidth.constant = 120*4/3.0;
            
            NSString* date = ItemModel.EventStartDate.length>10?[ItemModel.EventStartDate substringToIndex:10]:ItemModel.EventStartDate;
            cell.date.text = date;
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
            selectTag = indexPath.row;
            [self setScrollViewUI:ItemModel];
        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    self.timeSelView.hidden = YES;
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

