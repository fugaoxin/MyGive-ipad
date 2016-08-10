//
//  EGMessageCenterViewController.m
//  Egive-ipad
//
//  Created by User01 on 15/11/19.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGMessageCenterViewController.h"
#import "EGMessageCenterCell.h"
#import "EGMessageModel.h"
#import "EGGiveItemModel.h"

@interface EGMessageCenterViewController ()
{
    UIImageView *headIV;
    UIView *line;
    UILabel *titleLab;
    UILabel *dateLab;
    UILabel *receiveMessageLab;
    NSMutableArray *itemList;
}
@end

@implementation EGMessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self createHeadView];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EBEAEB"];

    itemList = [[NSMutableArray alloc] initWithArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"1",@"1"]];
}

-(void)createHeadView{
    UIImageView* selectView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _TypeTF.frame.size.width, _TypeTF.frame.size.height)];
    selectView.image = [self getImage];
    [_TypeTF addSubview:selectView];
    [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_TypeTF);
        make.height.mas_equalTo(_TypeTF);
        make.leading.equalTo(_TypeTF);
        make.trailing.equalTo(_TypeTF);
        
    }];
    self.TypeSelView.layer.borderWidth = 0.5;
    self.TypeSelView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self getTypeArr];
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
-(void)getTypeArr{
    
    self.TypeSelView.hidden = YES;
    self.TypeTF.text = HKLocalizedString(@"全部");
    [self.TypeAllBtn setTitle:HKLocalizedString(@"全部") forState:UIControlStateNormal];
    [self.TypeBtn_EVENT setTitle:HKLocalizedString(@"意赠活动") forState:UIControlStateNormal];
    [self.TypeBtn_CASE setTitle:HKLocalizedString(@"最新专案") forState:UIControlStateNormal];
    [self.TypeBtn_CASEUPDATE setTitle:HKLocalizedString(@"进度报告") forState:UIControlStateNormal];
    [self.TypeBtn_SUCCESS setTitle:HKLocalizedString(@"成功筹募") forState:UIControlStateNormal];
//    //HKLocalizedString(@"捐款记录");
    
}
- (IBAction)btnAction:(UIButton*)sender {
    self.TypeSelView.hidden = YES;
    _TypeTF.text = sender.titleLabel.text;
//    [self GetEventDtlListWithEventTp:@"R" Year:_timeTF.text];
}
- (void)GetEventDtlListWithEventTp:(NSString *)EventTp Year:(NSString*)Year
{
    [SVProgressHUD show];
    
    
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
    return 125;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * str=@"EGMessageCenterCell";
    EGMessageCenterCell * cell=[tableView dequeueReusableCellWithIdentifier:str];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EGMessageCenterCell" owner:self options:nil];
    if (!cell && [nib count]>0)
    {
        cell = [nib objectAtIndex:0];
        cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor=[UIColor colorWithHexString:@"#EBEAEB"];
    }
    
    //        cell.selectionStyle=UITableViewCellSelectionStyleNone;//cell的选中风格
    NSArray * types = @[HKLocalizedString(@"意赠活动"), HKLocalizedString(@"最新专案"),
                        HKLocalizedString(@"进度报告"), HKLocalizedString(@"成功筹募")];
//
    cell.title.text = [NSString stringWithFormat:@"%@ - %@",types[indexPath.row%4],@"测试"];
    cell.desp.text = @"测试";
    cell.date.text = @"2016-1-21";
    if (indexPath.row%4) {
        cell.iv_new.hidden = YES;
    }
    cell.ivWidth.constant = 125*4/3.0;
    if (itemList) {
//        EGGiveItemModel*ItemModel = itemList[indexPath.row];
//        if (ItemModel) {
//
//            NSArray* Img = ItemModel.Img;
//            if (Img.count) {
//                NSString *ImgURL =  Img[0][@"ImgURL"];
//                NSURL *url = [NSURL URLWithString:SITE_URL];
//                url = [url URLByAppendingPathComponent:ImgURL];
//                [cell.iv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"dummy_case_related_default"] options:SDWebImageRetryFailed|SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                    if (image) {
//                        cell.iv.image = [self rerol:image];
//                    }
//                    cell.iv.contentMode = UIViewContentModeScaleToFill;
//                }];
//            }
//            cell.title.text = ItemModel.Title ;
//           
//            NSString* EventStartDate = ItemModel.EventStartDate.length>10?[ItemModel.EventStartDate substringToIndex:10]:ItemModel.EventStartDate;
//            cell.date.text = EventStartDate;
//            cell.desp.text = ItemModel.Desp;
//        }
    }
    return cell;
    
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    self.TypeSelView.hidden = YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    

    return YES;
 
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    LanguageKey lang = [Language getLanguage];
    if (lang == HK)
        return @"删除";
    else if (lang == CN)
        return @"删除";
    else
        return @"Delete";
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        alertView.tag = indexPath.row;
        [alertView show];
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
        if (itemList){
            NSString* k = [itemList objectAtIndex:alertView.tag];
            [itemList removeObject:k];
            
            [self.leftTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:alertView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    self.TypeSelView.hidden = YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    // 关闭键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if (textField == _TypeTF) {
        self.TypeSelView.hidden = NO;
        return NO;
    }
    
    return YES;
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

