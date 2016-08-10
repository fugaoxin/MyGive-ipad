//
//  EGProReportController.m
//  Egive-ipad
//
//  Created by 123 on 15/12/7.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGProReportController.h"
#import "EGProReportModel.h"
#import "EGScrollView.h"
#import "EGProReportCell.h"

#define viewWith screenWidth-400
#define viewHeight screenHeight-50

//滑块AA
#define minFont 16
#define maxFont 22

//标题
#define titleMinFont 16
#define titleFont 18
#define titleMaxFont 22

//时间&日期
#define dataMinFont 12
#define dataFont 15
#define dataMaxFont 18

//内容
#define contentMinFont 17
#define contentFont 20
#define contentMaxFont 23

@interface EGProReportController ()<UIActionSheetDelegate,MDHTMLLabelDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) EGProReportModel * RModel;
@property (nonatomic,strong) UIImageView * selectView;//日期选择
@property (nonatomic,strong) UIScrollView * bgScrollView;//背景
@property (nonatomic,strong) UILabel * titleLabel;//标题
@property (nonatomic,strong) UILabel * dateLabel;//日期
@property (nonatomic,strong) UILabel * numLabel;//序号
@property (nonatomic,strong) UILabel * contentLabel;//内容标题
@property (nonatomic,strong) EGScrollView * loopScrollView;//滚动图片
@property (nonatomic,strong) UIWebView *webview;//内容
@property (nonatomic,assign) CGSize retSize;

@property (nonatomic,strong) UIButton * dateButton;//日期选择
@property (nonatomic,strong) UITableView * listTableView;//日期列表

@property (nonatomic,strong) UIImageView * fontView;//字体调整背景
@property (nonatomic,assign) long myLong;

@end

@implementation EGProReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor=[UIColor colorWithRed:233/255.0 green:234/255.0 blue:235/255.0 alpha:1];
    self.title = HKLocalizedString(@"进度报告");
    UIView *barView=[self createNaviTopBarWithShowBackBtn:YES showTitle:YES];
    UIButton * shareBut=[[UIButton alloc] initWithFrame:CGRectMake(barView.frame.size.width-44, 0, 44, 44)];
    [shareBut setImage:[UIImage imageNamed:@"common_header_share"] forState:UIControlStateNormal];
    [barView addSubview:shareBut];
    [shareBut addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBackButton setBackgroundImage:[UIImage imageNamed:@"common_close"] forState:UIControlStateNormal];
    [self setOneData];
}

//重写方法
-(void)baseBackAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clickRightButton
{
    if (self.dataArray.count>0) {
        LanguageKey lang = [Language getLanguage];
        NSString * string = @"";
        NSString * subject = @"";
        //NSLog(@"self.nameString%@",self.nameString);
        if (lang==1) {
            NSString *str = [NSString stringWithFormat:@"Egive – 進度報告:%@ - %@/CaseUpdate.aspx?CaseID=%@&lang=%lu\n\n請瀏覽: %@?lang=%lu\n\n意贈慈善基金\nEgive For You Charity Foundation\n電話: (852) 2210 2600\n電郵: info@egive4u.org",[self.nameString stringByReplacingOccurrencesOfString:@"(null)" withString:@""],SITE_URL,self.caseId,lang,SITE_URL,lang];
            string = str;
            subject = [NSString stringWithFormat:@"Egive專案 - %@",[self.nameString stringByReplacingOccurrencesOfString:@"(null)" withString:@""]];
            
        }else if (lang==2){
            NSString *str = [NSString stringWithFormat:@"Egive – 进度报告:%@ - %@/CaseUpdate.aspx?CaseID=%@&lang=%lu\n\n请浏览: %@?lang=%lu\n\n意赠慈善基金\nEgive For You Charity Foundation\n电话: (852) 2210 2600\n电邮: info@egive4u.org",[self.nameString stringByReplacingOccurrencesOfString:@"(null)" withString:@""],SITE_URL,self.caseId,lang,SITE_URL,lang];
            string = str;
            subject = [NSString stringWithFormat:@"Egive专案 - %@",[self.nameString stringByReplacingOccurrencesOfString:@"(null)" withString:@""]];
        }else{
            
            NSString * str = [NSString stringWithFormat:@"Egive - Progress Report:%@ - %@/CaseUpdate.aspx?CaseID=%@&lang=%lu\n\nVisit us at %@?lang=%lu\n\nEgive For You Charity Foundation\nTel: (852) 2210 2600\nEmail: info@egive4u.org",[self.nameString  stringByReplacingOccurrencesOfString:@"(null)" withString:@""],SITE_URL,self.caseId,lang,SITE_URL,lang];
            string = str;
            subject = [NSString stringWithFormat:@"Egive Projects - %@",[self.nameString stringByReplacingOccurrencesOfString:@"(null)" withString:@""]];
        }
        NSString * image;
        if (self.RModel.GalleryImg.count>0) {
            image=[self.RModel.GalleryImg[0] objectForKey:@"ImgURL"];
            //DLOG(@"image==%@",image);
        }
        else
        {
            image=@"dummy_case_related_default";
        }
        
        NSString * urlStr=[NSString stringWithFormat:@"%@/CaseUpdate.aspx?CaseID=%@&lang=%lu",SITE_URL,self.caseId,lang];
        
        //[UIImage imageNamed:image]
        EGShareViewController * shareVC= [[EGShareViewController alloc] initWithSubject:subject content:string url:urlStr image:nil Block:^(id result) {
            
        }];
        [shareVC showShareUIWithPoint:CGPointMake(screenWidth-200-35, 0) view:self.view permittedArrowDirections:UIPopoverArrowDirectionRight];
    }
}

#pragma mark - 选择报告按钮
-(void)setSelectView
{
    self.contentView.backgroundColor=[UIColor colorWithRed:233/255.0 green:234/255.0 blue:235/255.0 alpha:1];
    self.dateButton=[[UIButton alloc] initWithFrame:CGRectMake(20, 5, viewWith-40, 30)];
    self.dateButton.backgroundColor=[UIColor whiteColor];
    [self.dateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.dateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.dateButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.dateButton.contentEdgeInsets = UIEdgeInsetsMake(0,5, 0, 0);
    [self.contentView addSubview:self.dateButton];
    [self.dateButton.layer setMasksToBounds:YES];
    [self.dateButton.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    //边框宽度
    [self.dateButton.layer setBorderWidth:0.5];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0, 0, 0, 0.5 });
    [self.dateButton.layer setBorderColor:colorref];
    
    [self.dateButton addTarget:self action:@selector(clickDateButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(self.dateButton.frame.size.width-110, 0, 80, 30)];
    label.textAlignment=NSTextAlignmentRight;
    label.tag=20;
    [self.dateButton addSubview:label];
    
    UIImage * imag=[UIImage imageNamed:@"comment_picker"];
    imag=[imag stretchableImageWithLeftCapWidth:imag.size.width/2 topCapHeight:imag.size.height/2];
    [self.dateButton setBackgroundImage:imag forState:UIControlStateNormal];
    NSString * texstr=[self.RModel.UpdateDate stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    [self.dateButton setTitle:texstr forState:UIControlStateNormal];
    label.text=[NSString stringWithFormat:@"(%@%@)",HKLocalizedString(@"报告"),self.RModel.CaseUpdateIndex];
}

#pragma mark - 选择报告
-(void)clickDateButton:(UIButton *)button
{
    button.selected=!button.selected;
    if (button.selected) {
        [self setTableView];
    }
    else
    {
        [self.listTableView removeFromSuperview];
    }
}

-(void)setNOdataView
{
    UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWith, viewHeight)];
    label.backgroundColor=[UIColor whiteColor];
    label.text=HKLocalizedString(@"NoContent");
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:22];
    [self.contentView addSubview:label];
}

#pragma mark - 判断有木有报告
-(void)setOneData
{
    self.RModel=[[EGProReportModel alloc] init];
    if (self.dataArray.count>0) {
        //DLOG(@"dataArray===%@",self.dataArray);
        [self.RModel setDictionary:self.dataArray[0]];
        [self setSelectView];
        [self setBgScrollViewIndex:0];
    }
    else
    {
        [self setNOdataView];
    }
}

-(void)clickTap
{
    self.fontView.hidden=YES;
    [self.listTableView removeFromSuperview];
}

-(void)clickLongPress
{
    self.fontView.hidden=NO;
}

-(void)setBgScrollViewIndex:(int)index
{
//    DLOG(@"self.dataArray==%@",self.dataArray);
//    DLOG(@"ViewHeight==%f",viewHeight);
//    DLOG(@"ViewHeight3333==%f",viewHeight*3);
    
    self.bgScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, viewWith, viewHeight-80)];
    self.bgScrollView.userInteractionEnabled=YES;
    self.bgScrollView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:self.bgScrollView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickLongPress)];
    [self.bgScrollView addGestureRecognizer:longPress];
    
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap)];
    [self.bgScrollView addGestureRecognizer:tap];
    
    NSMutableArray * picArray=[[NSMutableArray alloc] init];
    for (NSDictionary * adDict in self.RModel.GalleryImg) {
        NSString *  URL = [SITE_URL stringByAppendingPathComponent:[[adDict objectForKey:@"ImgURL"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
        [picArray addObject:URL];
    }
    //图片
    self.loopScrollView=[[EGScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWith, 500)];
    self.loopScrollView.backgroundColor=[UIColor whiteColor];
    self.loopScrollView.pageCount=(int)picArray.count;
    [self.bgScrollView addSubview:self.loopScrollView];
    self.loopScrollView.showPageControl=YES;
//    self.loopScrollView.pageControl.backgroundColor=[UIColor redColor];
    for (int i=0; i<picArray.count; i++) {
        [self.loopScrollView setImageWithUrlString:picArray[i] atIndex:i];
    }
    
    __weak typeof (self) weakSelf = self;
    [self.loopScrollView setClickAction:^(UIImageView *imageView, int index) {
        weakSelf.fontView.hidden=YES;
        [weakSelf.listTableView removeFromSuperview];
    }];
    
    self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(40, self.loopScrollView.frame.size.height+self.loopScrollView.frame.origin.y, viewWith-80, 60)];
    //self.titleLabel.backgroundColor=[UIColor redColor];
    self.titleLabel.font=[UIFont systemFontOfSize:titleFont];
    self.titleLabel.textColor=tabarColor;
    self.titleLabel.text=self.nameString;
    self.titleLabel.numberOfLines=2;
    [self.bgScrollView addSubview:self.titleLabel];
    [self setLine:self.titleLabel andY:48];
    
    self.dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(40, self.titleLabel.frame.size.height+self.titleLabel.frame.origin.y+5, 300, 30)];
    //self.dateLabel.backgroundColor=[UIColor greenColor];
    [self.bgScrollView addSubview:self.dateLabel];
    NSMutableAttributedString * dateStr = [[NSMutableAttributedString alloc] init];
    dateStr=[self setStrA:HKLocalizedString(@"Date") andIndexA:0 andColorA:[UIColor grayColor] andFontA:[UIFont systemFontOfSize:dataFont] andStrB:[NSString stringWithFormat:@"%@",self.RModel.UpdateDate] andIndexB:0 andColorB:[UIColor blackColor] andFontB:[UIFont boldSystemFontOfSize:dataFont] andStrC:[NSString stringWithFormat:@"%@%@",HKLocalizedString(@"Date"),self.RModel.UpdateDate]];
    self.dateLabel.attributedText = dateStr;
    
    self.numLabel=[[UILabel alloc] initWithFrame:CGRectMake(viewWith-40-200, self.dateLabel.frame.origin.y, 200, 30)];
    //self.numLabel.backgroundColor=[UIColor greenColor];
    self.numLabel.textAlignment=NSTextAlignmentRight;
    [self.bgScrollView addSubview:self.numLabel];
    NSMutableAttributedString * numStr = [[NSMutableAttributedString alloc] init];
    numStr=[self setStrA:HKLocalizedString(@"进度报告") andIndexA:1 andColorA:[UIColor grayColor] andFontA:[UIFont systemFontOfSize:dataFont] andStrB:[NSString stringWithFormat:@"%@",self.RModel.CaseUpdateIndex] andIndexB:0 andColorB:[UIColor blackColor] andFontB:[UIFont boldSystemFontOfSize:dataFont] andStrC:[NSString stringWithFormat:@"%@:%@",HKLocalizedString(@"进度报告"),self.RModel.CaseUpdateIndex]];
    self.numLabel.attributedText = numStr;
    
    self.contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(40, self.dateLabel.frame.size.height+self.dateLabel.frame.origin.y, viewWith-80, 30)];
    [self.bgScrollView addSubview:self.contentLabel];
//    NSMutableAttributedString * contentStr = [[NSMutableAttributedString alloc] init];
//    contentStr=[self setStrA:HKLocalizedString(@"Content") andIndexA:0 andColorA:[UIColor grayColor] andFontA:[UIFont systemFontOfSize:dataFont] andStrB:[NSString stringWithFormat:@"%@",self.RModel.UpdateDate] andIndexB:0 andColorB:[UIColor blackColor] andFontB:[UIFont boldSystemFontOfSize:dataFont] andStrC:[NSString stringWithFormat:@"%@%@",HKLocalizedString(@"Content"),self.RModel.UpdateDate]];
//    self.contentLabel.attributedText = contentStr;
    self.contentLabel.text=HKLocalizedString(@"Content");
    self.contentLabel.textColor=[UIColor grayColor];
    
    NSArray *array = [self.RModel.Content componentsSeparatedByString:@"<br>"];
    if (array.count>0) {
        [self htmlLabel:array[0] andFont:contentFont];
    }
    
    self.fontView=[[UIImageView alloc] initWithFrame:CGRectMake(130, viewHeight-70-40, viewWith-260, 50)];
    self.fontView.backgroundColor=[UIColor grayColor];
    self.fontView.userInteractionEnabled=YES;
    self.fontView.layer.masksToBounds = YES;
    self.fontView.layer.cornerRadius = 4.0;
    self.fontView.hidden=YES;
    self.fontView.alpha=0.8;
    [self.contentView addSubview:self.fontView];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50, (50-20)/2, self.fontView.frame.size.width-100, 20)];
    slider.minimumValue = 0;//指定可变最小值
    slider.maximumValue = 100;//指定可变最大值
    slider.value = 50;//指定初始值
    [slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];//设置响应事件
    [self.fontView addSubview:slider];
    
    UILabel * Llabel=[[UILabel alloc] initWithFrame:CGRectMake(20, (50-30)/2, 30, 30)];
    UILabel * Dlabel=[[UILabel alloc] initWithFrame:CGRectMake(self.fontView.frame.size.width-50, 0, 50, 50)];
    Llabel.text=@"A";
    Dlabel.text=@"A";
    Llabel.textAlignment=NSTextAlignmentRight;
    Llabel.font=[UIFont systemFontOfSize:minFont];
    Dlabel.font=[UIFont systemFontOfSize:maxFont];
    [self.fontView addSubview:Llabel];
    [self.fontView addSubview:Dlabel];
}

#pragma mark 文字分割
-(NSMutableAttributedString *)setStrA:(NSString *)StrA andIndexA:(int)IndexA andColorA:(UIColor *)ColorA andFontA:(id)FontA andStrB:(NSString *)StrB andIndexB:(int)IndexB andColorB:(UIColor *)ColorB andFontB:(id)FontB andStrC:(NSString *)StrC
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:StrC];
    [str addAttribute:NSForegroundColorAttributeName value:ColorA range:NSMakeRange(0,StrA.length+IndexA)];
    [str addAttribute:NSForegroundColorAttributeName value:ColorB range:NSMakeRange(StrA.length+IndexA,StrB.length+IndexB)];
    [str addAttribute:NSFontAttributeName value:FontA range:NSMakeRange(0, StrA.length+IndexA)];
    [str addAttribute:NSFontAttributeName value:FontB range:NSMakeRange(StrA.length+IndexA, StrB.length+IndexB)];
    return str;
}

-(void)htmlLabel:(NSString *)htmlString andFont:(int)font
{
    MDHTMLLabel *htmlLabel = [[MDHTMLLabel alloc] init];
    htmlLabel.delegate = self;
    //htmlLabel.backgroundColor=[UIColor greenColor];
    //htmlLabel.tag=11;
    htmlLabel.numberOfLines = 0;
    htmlLabel.font = [UIFont systemFontOfSize:font];
    htmlLabel.shadowColor = [UIColor whiteColor];
    htmlLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    //htmlLabel.translatesAutoresizingMaskIntoConstraints = NO;
    htmlLabel.linkAttributes = @{NSForegroundColorAttributeName: [UIColor blueColor],
                                 NSFontAttributeName: [UIFont boldSystemFontOfSize:htmlLabel.font.pointSize],
                                 NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    
    htmlLabel.activeLinkAttributes = @{NSForegroundColorAttributeName: [UIColor redColor],
                                       NSFontAttributeName: [UIFont boldSystemFontOfSize:htmlLabel.font.pointSize],
                                       NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    
    NSString * html = [htmlString stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    htmlLabel.htmlText = html;
    [self.bgScrollView addSubview:htmlLabel];
    EGDataCenter * DC=[EGDataCenter shareDataCenter];
    [self htmlLabelTow:DC.htmlSting andFont:font];
}

-(void)htmlLabelTow:(NSString *)htmlString andFont:(int)font
{
    //DLOG(@"fgx2=======%@",htmlString);
    MDHTMLLabel *htmlLabel = [[MDHTMLLabel alloc] init];
    htmlLabel.tag=200;
    htmlLabel.delegate = self;
    //htmlLabel.backgroundColor=[UIColor greenColor];
    //htmlLabel.tag=11;
    htmlLabel.numberOfLines = 0;
    htmlLabel.font = [UIFont systemFontOfSize:font];
    htmlLabel.shadowColor = [UIColor whiteColor];
    htmlLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    //htmlLabel.translatesAutoresizingMaskIntoConstraints = NO;
    htmlLabel.linkAttributes = @{NSForegroundColorAttributeName: [UIColor blueColor],
                                 NSFontAttributeName: [UIFont boldSystemFontOfSize:htmlLabel.font.pointSize],
                                 NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    
    htmlLabel.activeLinkAttributes = @{NSForegroundColorAttributeName: [UIColor redColor],
                                       NSFontAttributeName: [UIFont boldSystemFontOfSize:htmlLabel.font.pointSize],
                                       NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    
    NSString * html = [htmlString stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    
    htmlLabel.htmlText = html;
    [self.bgScrollView addSubview:htmlLabel];
    EGDataCenter * DC=[EGDataCenter shareDataCenter];
    //DLOG(@"DC.htmlSting2===%@",DC.htmlSting);
    CGRect contentRect  = [DC.htmlSting boundingRectWithSize:CGSizeMake(viewWith-40*2, 5000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    if (contentRect.size.height < 60) {
        contentRect.size.height = 60;
        htmlLabel.frame=CGRectMake(40, self.contentLabel.frame.size.height+self.contentLabel.frame.origin.y, viewWith-40*2, contentRect.size.height);
    }
    else
    {
        htmlLabel.frame=CGRectMake(40, self.contentLabel.frame.size.height+self.contentLabel.frame.origin.y, viewWith-40*2, contentRect.size.height+60);
    }
    //htmlLabel.backgroundColor=[UIColor redColor];
    
    float num=self.loopScrollView.frame.size.height+self.titleLabel.frame.size.height+self.dateLabel.frame.size.height+self.contentLabel.frame.size.height+htmlLabel.frame.size.height;
    self.bgScrollView.contentSize = CGSizeMake(viewWith, num);
}


-(void)updateValue:(UISlider *)sender{
    float f=(6/100.00)*sender.value; //读取滑块的值
    self.titleLabel.font=[UIFont systemFontOfSize:titleMinFont+f];
    self.dateLabel.font=[UIFont systemFontOfSize:dataMinFont+f];
    self.numLabel.font=[UIFont systemFontOfSize:dataMinFont+f];
    self.contentLabel.font=[UIFont systemFontOfSize:dataMinFont+f];
    NSArray *array = [self.RModel.Content componentsSeparatedByString:@"<br>"];
    if (array.count>0) {
        MDHTMLLabel *html=(MDHTMLLabel*)[self.bgScrollView viewWithTag:200];
        [html removeFromSuperview];
        [self htmlLabel:array[0] andFont:contentMinFont+f];
    }
}

#pragma mark 灰色分割线
-(void)setLine:(UILabel *)View andY:(float)Y
{
    //灰色分割线
    UILabel * lineLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, Y, View.frame.size.width, 2)];
    lineLabel.backgroundColor=[UIColor grayColor];
    lineLabel.alpha=0.4;
    [View addSubview:lineLabel];
}

#pragma mark - tableView
-(void)setTableView
{
    //self.dateButton=[[UIButton alloc] initWithFrame:CGRectMake(20, 5, viewWith-40, 30)];
    int lex=(int)self.dataArray.count;
    if (lex>21) {
        lex=21;
    }
    self.listTableView=[[UITableView alloc] initWithFrame:CGRectMake(20, 35, viewWith-40, 30*lex) style:UITableViewStylePlain];
    //self.listTableView.backgroundColor=[UIColor redColor];
    self.listTableView.delegate=self;
    self.listTableView.dataSource=self;
    self.listTableView.allowsSelection=YES;
    //self.listTableView.separatorStyle = NO;
    [self.contentView addSubview:self.listTableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str=@"cell";
    EGProReportCell * cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        
        cell=[[EGProReportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//cell的选中风格
    //cell.backgroundColor=[UIColor redColor];
    cell.dateLabel.text=[[self.dataArray[indexPath.row] objectForKey:@"UpdateDate"] stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    cell.numLabel.text=[NSString stringWithFormat:@"(%@%@)",HKLocalizedString(@"报告"),[self.dataArray[indexPath.row] objectForKey:@"CaseUpdateIndex"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * texstr=[[self.dataArray[indexPath.row] objectForKey:@"UpdateDate"] stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    [self.dateButton setTitle:texstr forState:UIControlStateNormal];
    UILabel * label=(UILabel *)[self.dateButton viewWithTag:20];
    label.text=[NSString stringWithFormat:@"(%@%@)",HKLocalizedString(@"报告"),[self.dataArray[indexPath.row] objectForKey:@"CaseUpdateIndex"]];
    [self.listTableView removeFromSuperview];
    //DLOG(@"indexPath.row==%@",self.dataArray[indexPath.row]);
    [self.RModel setDictionary:self.dataArray[indexPath.row]];
    [self setBgScrollViewIndex:(int)indexPath.row];
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
