//
//  EGSelectedCaseViewController.m
//  Egive-ipad
//
//  Created by vincentmac on 15/12/2.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGSelectedCaseViewController.h"
#import "EGSelectedCaseCell.h"
#import "EGDonationModel.h"
#import <TPKeyboardAvoiding/TPKeyboardAvoidingTableView.h>
#import <MBProgressHUD.h>
#import "EGCaseConfirmViewController.h"
#import "EGClickCharityViewController.h"
#import "NSString+Helper.h"
#import "CZPickerView.h"

@interface EGSelectedCaseViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    BOOL _DonateWithCharge;
    
    NSInteger _totalDonateAmt;
    
    CGFloat _totalReceiveAmt;
    
    NSInteger _addressIndex;
    
    NSString *_location;
    
    NSInteger _numberOfSelectedCase;
}

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *otherLabel;

@property (weak, nonatomic) IBOutlet UIView *footView;

@property (weak, nonatomic) IBOutlet UIView *otherView;

@property (nonatomic,strong)  NSMutableArray *cartList;

@property (weak, nonatomic) IBOutlet UILabel *totalAmtLabel;

@property (weak, nonatomic) IBOutlet UIView *downpullView;

@property (weak, nonatomic) IBOutlet UIButton *pullBtn1;

@property (weak, nonatomic) IBOutlet UIButton *pullBtn2;

@property (weak, nonatomic) IBOutlet UIButton *dropButton;

@property (weak, nonatomic) IBOutlet UIButton *clickButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *addressSegment;

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@property (weak, nonatomic) IBOutlet UILabel *moneyText;


//是否包含手续费
@property (assign, nonatomic)  EGDonationCounterFeeStyle feeStyle;


@end

@implementation EGSelectedCaseViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    self.title = [Language getStringByKey:@"MyDonation_Title"];
//    [self createNaviTopBarWithShowBackBtn:YES showTitle:YES];
    
    //
    [self setupUI];
    
   
}

-(void)viewWillAppear:(BOOL)animated{

    //
    [self loadData];
}


-(void)viewWillDisappear:(BOOL)animated{
    
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - touch event

- (IBAction)segAction:(UISegmentedControl *)sender {
    
    NSInteger Index = sender.selectedSegmentIndex;
    
    _addressIndex = Index;
    
    if(Index==0){
        [_pullBtn1 setTitle:HKLocalizedString(@"不包括手续费") forState:UIControlStateNormal];
        [_pullBtn2 setTitle:HKLocalizedString(@"MyDonation_HKpoundage") forState:UIControlStateNormal];
        if (_DonateWithCharge) {
            _otherLabel.text = HKLocalizedString(@"MyDonation_HKpoundage");
            _feeStyle = EGDonationHKContainFee;
        }else{
            _otherLabel.text = HKLocalizedString(@"不包括手续费");
            _feeStyle = EGDonationHKUnContainFee;
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:@"HK" forKey:@"Location"];
    }else{
        [_pullBtn1 setTitle:HKLocalizedString(@"不包括手续费") forState:UIControlStateNormal];
        [_pullBtn2 setTitle:HKLocalizedString(@"MyDonation_noHKpoundage") forState:UIControlStateNormal];
        
        if (_DonateWithCharge) {
            _otherLabel.text = HKLocalizedString(@"MyDonation_noHKpoundage");
             _feeStyle = EGDonationUnHKContainFee;
        }else{
            _otherLabel.text = HKLocalizedString(@"不包括手续费");
             _feeStyle = EGDonationUnHKUnContainFee;
        }
       [[NSUserDefaults standardUserDefaults] setObject:@"NonHK" forKey:@"Location"];
    }
//    DLOG(@"%p,%@",self.cartList ,self.cartList);
    [_tableView reloadData];
}


#pragma mark 点击下拉按钮
- (IBAction)pullClick:(id)sender {
   
    _downpullView.hidden = _dropButton.selected ? NO : YES;
    _dropButton.selected = _dropButton.selected ? NO :YES;

    
}

- (IBAction)coverClick:(id)sender {
    
    _downpullView.hidden = _dropButton.selected ? NO : YES;
    _dropButton.selected = _dropButton.selected ? NO :YES;
    
    
}



#pragma mark 点击第一个下拉选项
- (IBAction)pullbtn1Click:(id)sender {
    _downpullView.hidden = YES;
    _otherLabel.text = _pullBtn1.titleLabel.text;
    _DonateWithCharge = NO;
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"DonateWithCharge"];//是否包含手续费
    
    if (_addressIndex==0) {
        _feeStyle = EGDonationHKUnContainFee;
    }else{
        _feeStyle = EGDonationUnHKUnContainFee;
    }
    [_tableView reloadData];
}

#pragma mark 点击第二个下拉选项
- (IBAction)pullbtn2Click:(id)sender {
    _downpullView.hidden = YES;
    _otherLabel.text = _pullBtn2.titleLabel.text;
    _DonateWithCharge = YES;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DonateWithCharge"];
    
    if (_addressIndex==0) {
        _feeStyle = EGDonationHKContainFee;
    }else{
        _feeStyle = EGDonationUnHKContainFee;
    }
    [_tableView reloadData];
}


- (IBAction)addProjectClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        //EGClickCharityViewController *click = [EGClickCharityViewController alloc] ;
        
        
        
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCartAddCase object:nil];
    
}




- (IBAction)continueClick:(id)sender {

    for (EGCartItem *item in _cartList) {
        if (item.DonateAmt<item.MinDonateAmt) {
            if (item.IsChecked) {
                
                
                if(item.PayOption1==0 && item.PayOption2==0 && item.PayOption3==0){
                
                }else{
                    CZPickerView *pv = [[CZPickerView alloc] initWithHeaderTitle:HKLocalizedString(@"输入错误") cancelButtonTitle:nil confirmButtonTitle:nil];
                    pv.headerBackgroundColor = [UIColor colorWithHexString:@"#F4F5F6"];
                    pv.headerTitleColor = [UIColor colorWithHexString:@"#673291"];
                    pv.showCloseButton = YES;
                    [pv setContent:HKLocalizedString(@"捐款资料有误，请检查项目内容再试。")];
                    [pv show];
                    return;
                
                }
            }
        }
        
    }
    
    
    EGCaseConfirmViewController *confirm = [[EGCaseConfirmViewController alloc] init];//WithNibName:@"EGCaseConfirmViewController" bundle:nil];
    
    confirm.title = [Language getStringByKey:@"mydonation_comfirm_title"];
    
    confirm.singleCasePrice = _totalDonateAmt;
    confirm.caseName = @"";
    confirm.caseCount = _numberOfSelectedCase;
    [confirm setContentSize:CGSizeMake(WIDTH-200, HEIGHT-100) bgAction:NO animated:NO];
    [self.navigationController pushViewController:confirm animated:YES];
    
}


#pragma mark - private method
-(void)loadData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    LanguageKey lang = [Language getLanguage];
    
    NSString *cookieId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    EGUserModel *user = [EGLoginTool loginSingleton].currentUser;
    NSString *memberID = @"";
    if (user.MemberID && user.MemberID.length>0) {
        memberID = user.MemberID;
        cookieId = @"";
    }
    
    //是否需要手续费
    BOOL DonateWithCharge = [[NSUserDefaults standardUserDefaults] boolForKey:@"DonateWithCharge"];
    DonateWithCharge = YES;
    
    NSString * soapMsg =[NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                         "<soap:Body>"
                         "<GetAndSaveShoppingCart xmlns=\"egive.appservices\">"
                         "<Lang>%ld</Lang>"
                         "<LocationCode>%@</LocationCode>"
                         "<DonateWithCharge>%d</DonateWithCharge>"
                         "<MemberID>%@</MemberID>"
                         "<CookieID>%@</CookieID>"
                         "<StartRowNo>%i</StartRowNo>"
                         "<NumberOfRows>%i</NumberOfRows>"
                         "</GetAndSaveShoppingCart>"
                         "</soap:Body>"
                         "</soap:Envelope>",lang, @"HK",DonateWithCharge,memberID,cookieId,1,20];
    
    
    [EGDonationModel getCartListWithParams:soapMsg block:^(NSDictionary *dict, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            
            NSArray *array = dict[@"ItemList"];
            
            //是否包含手续费
            BOOL donateWithCharge = [dict[@"DonateWithCharge"] boolValue];
            [[NSUserDefaults standardUserDefaults] setBool:donateWithCharge forKey:@"DonateWithCharge"];
            //
            NSString *location = dict[@"Location"];
            _location = location;
            
            if (location.length>0) {
                [[NSUserDefaults standardUserDefaults] setObject:location forKey:@"Location"];
                
                if ([location isEqualToString:@"香港"] || [location isEqualToString:@"Hong Kong"]) {
                    _addressSegment.selectedSegmentIndex = 0;
                    if (DonateWithCharge) {
                        _feeStyle = EGDonationHKContainFee;
                    }else{
                        _feeStyle = EGDonationHKUnContainFee;
                    }
                }else{
                    _addressSegment.selectedSegmentIndex = 1;
                    if (DonateWithCharge) {
                        _feeStyle = EGDonationUnHKContainFee;
                    }else{
                        _feeStyle = EGDonationUnHKUnContainFee;
                    }
                }
            }
            
           
            
            if (![array isEqual: [NSNull null]] && array.count>0) {
                _cartList = [NSMutableArray array];
                for (NSDictionary *dict in array) {
                    EGCartItem *item = [EGCartItem mj_objectWithKeyValues:dict];
                    if (item.IsChecked) {
                        _numberOfSelectedCase ++;
                    }
                    [_cartList addObject:item];
                }
                DLOG(@"_numberOfSelectedCase:%ld",_numberOfSelectedCase);
                [_tableView reloadData];
            }
            
            if (_numberOfSelectedCase<=0) {
                _clickButton.hidden = NO;
                _addButton.hidden = YES;
                _continueButton.hidden = YES;
            }else{
                _clickButton.hidden = YES;
                _addButton.hidden = NO;
                _continueButton.hidden = NO;
            }
            
            _totalDonateAmt = [dict[@"TotalDonateAmt"] integerValue];
            _totalReceiveAmt = [dict[@"TotalReceiveAmt"] floatValue];
            _totalAmtLabel.text = [NSString stringWithFormat:@"HK$ %@",[NSString countNumAndChangeformat:[NSString stringWithFormat:@"%ld",_totalDonateAmt]]];

            _DonateWithCharge = [dict[@"DonateWithCharge"] boolValue];
        }else{
            
        }
        
        
        
    }];
}


#pragma mark 更新购物车数据到服务端
-(void)updateCart:(EGCartItem *)item{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *memberId = [EGLoginTool loginSingleton].currentUser.MemberID;
    NSString *cookieId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    if (memberId.length>0) {
        cookieId = @"";
    }else{
        memberId = @"";
    }
    
    NSInteger money = item.DonateAmt;
    if (_DonateWithCharge) {
        money = item.SelectedOption;
    }
    
    NSString * soapMsg =[NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                         "<soap:Body>"
                         "<SaveShoppingCartItem xmlns=\"egive.appservices\">"
                         "<MemberID>%@</MemberID>"
                         "<CookieID>%@</CookieID>"
                         "<CaseID>%@</CaseID>"
                         "<DonateAmt>%ld</DonateAmt>"
                         "<IsChecked>%d</IsChecked>"
                         "</SaveShoppingCartItem>"
                         "</soap:Body>"
                         "</soap:Envelope>",memberId, cookieId, item.CaseID, money, item.IsChecked];
    
    [EGDonationModel updateCartListWithParams:soapMsg block:^(NSDictionary *dict, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        //无数据返回
        
        
    }];
}


-(void)CalculationTotalPrice{

    NSInteger count = 0;
    
    for (EGCartItem *item in _cartList) {
        
        if (item.IsChecked) {
            count = count + item.DonateAmt;
        }
    }
    
    self.totalAmtLabel.text = [NSString stringWithFormat:@"HK$ %@",[NSString countNumAndChangeformat:[NSString stringWithFormat:@"%ld",count]]];
    _totalDonateAmt = count;
}



#pragma mark 计算包括手续费在内的捐款金额
-(NSDictionary *)CalculationFee:(NSInteger )value{

    //2.35的平均值
    CGFloat fee = 2.35 / _numberOfSelectedCase;
    
    NSInteger donationCount;//捐款金额
    
    NSInteger receiverCount;//收到金额
    
    CGFloat amt;
    
    switch (_feeStyle) {
        case EGDonationHKContainFee:

            amt = (value + fee)/(1 - 3.9*0.01);
            donationCount = roundf(amt + 0.5);
            receiverCount = value;
            break;
        case EGDonationHKUnContainFee:
            donationCount = value;
            receiverCount = donationCount - roundf(value*3.9/100 + fee + 0.5);
            
            break;
        case EGDonationUnHKContainFee:
            amt = (value + fee)/(1 - 4.4*0.01);
            donationCount = roundf(amt + 0.5);
            receiverCount = value;
            break;
        case EGDonationUnHKUnContainFee:
            donationCount = value;
            receiverCount = donationCount - roundf(value*4.4/100 + fee + 0.5);
            break;
        default:
            break;
    }
    
    
    NSDictionary *dict = @{kDonationAmount:@(donationCount),kReceiverAmount:@(receiverCount)};

    return dict;
}

-(void)setupUI{
    
    _otherView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    _footView.layer.opacity = 0.9;
    
    _clickButton.hidden = YES;
    _clickButton.layer.cornerRadius = 6;
    [_clickButton setTitle:HKLocalizedString(@"MenuView_girdButton_title") forState:UIControlStateNormal];
    [_clickButton bk_addEventHandler:^(id sender) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kCartAddCase object:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _otherLabel.userInteractionEnabled = NO;
    _downpullView.hidden = YES;
    _downpullView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _downpullView.layer.borderWidth = 1;
    _footView.backgroundColor = [UIColor colorWithHexString:@"#F4F4F6"];
    
    [_pullBtn1 setTitle:HKLocalizedString(@"不包括手续费") forState:UIControlStateNormal];
    [_pullBtn2 setTitle:HKLocalizedString(@"MyDonation_HKpoundage2") forState:UIControlStateNormal];
    _pullBtn1.titleLabel.font = [UIFont boldSystemFontOfSize:NormalFontSize];
    _pullBtn2.titleLabel.font = [UIFont boldSystemFontOfSize:NormalFontSize];
    _otherLabel.font = [UIFont boldSystemFontOfSize:NormalFontSize];
    _otherLabel.textColor = [UIColor blackColor];

    
    _DonateWithCharge = [[NSUserDefaults standardUserDefaults] boolForKey:@"DonateWithCharge"];
    if(_addressIndex==0){
        if (_DonateWithCharge) {
            _otherLabel.text = HKLocalizedString(@"MyDonation_HKpoundage");
        }else{
            _otherLabel.text = HKLocalizedString(@"不包括手续费");
        }
    }else{
        if (_DonateWithCharge) {
            _otherLabel.text = HKLocalizedString(@"MyDonation_noHKpoundage");
        }else{
            _otherLabel.text = HKLocalizedString(@"不包括手续费");
        }
    }
    
    
    [_addressSegment setTitle:HKLocalizedString(@"ButtonTitleHK") forSegmentAtIndex:0];
    [_addressSegment setTitle:HKLocalizedString(@"MyDonation_noHK") forSegmentAtIndex:1];
    [_addButton setTitle:HKLocalizedString(@"MyDonation_AddButton") forState:UIControlStateNormal];
    [_continueButton setTitle:HKLocalizedString(@"MyDonation_ContinueButton") forState:UIControlStateNormal];
    _moneyText.text = HKLocalizedString(@"MyDonation_Thetotalamountof");
    _moneyText.font = [UIFont boldSystemFontOfSize:NormalFontSize+2];
    _totalAmtLabel.text = @"HK$ 0";
    _totalAmtLabel.font = [UIFont boldSystemFontOfSize:NormalFontSize+2];
    _totalAmtLabel.textColor = [UIColor colorWithHexString:@"#531E7E"];
    
    [_addressSegment setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:NormalFontSize]} forState:UIControlStateNormal];
    _continueButton.titleLabel.font = [UIFont boldSystemFontOfSize:NormalFontSize+2];
    _addButton.titleLabel.font = [UIFont boldSystemFontOfSize:NormalFontSize+2];
    _continueButton.layer.cornerRadius = 6;
    _addButton.layer.cornerRadius = 6;
}

#pragma mark - tableview

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 185;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _cartList.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EGCartItem *item = self.cartList[indexPath.row];
    
    EGSelectedCaseCell *cell = [EGSelectedCaseCell cellWithTableView:tableView atIndexPath:indexPath item:item];
    cell.numberOfSelectedCase = _numberOfSelectedCase;
    
    cell.styleChangeBlock = ^(EGCartItem *item,NSInteger row){
        [self CalculationTotalPrice];
    };
    cell.feeStyle = _feeStyle;
    
    
    
    WEAK_VAR(weakSelf, self);
    cell.block = ^(EGCartItem *cart,NSInteger row){
 
        //更新旧的数据
        EGCartItem *oldCart = weakSelf.cartList[row];
        
        int count = 0;
        for (EGCartItem *e in _cartList) {
            if (e.IsChecked) {
                count++;
            }
        }
        _numberOfSelectedCase = count;
        if (_numberOfSelectedCase<=0) {
            _clickButton.hidden = NO;
            _addButton.hidden = YES;
            _continueButton.hidden = YES;
        }else{
            _clickButton.hidden = YES;
            _addButton.hidden = NO;
            _continueButton.hidden = NO;
        }
        
        oldCart.IsChecked = cart.IsChecked;
        oldCart.SelectedOption = cart.SelectedOption;
        
        //重新计算捐款金额
        if (cart.SelectedOption>0) {
            NSDictionary *dict = [weakSelf CalculationFee:cart.SelectedOption];
            NSInteger donation = [dict[kDonationAmount] integerValue];
            NSInteger reveiver = [dict[kReceiverAmount] integerValue];
            cart.DonateAmt = donation;
            oldCart.DonateAmt = donation;
            cart.ReceiveAmt = reveiver;
            oldCart.ReceiveAmt = reveiver;
            
            
            
            [weakSelf CalculationTotalPrice];
            
            //
            [weakSelf updateCart:cart];
            
            //[weakSelf updateLocalData:cart row:row];
            [_tableView reloadData];
            
        }
        
        
       
    };
    
    
    
    
    
    
    
//    cell.styleChangeBlock = ^(NSInteger row){
//    
//        EGCartItem *oldCart = weakSelf.cartList[row];
//        NSDictionary *dict = [weakSelf CalculationFee:oldCart.SelectedOption];
//        NSInteger donation = [dict[kDonationAmount] integerValue];
//        NSInteger reveiver = [dict[kReceiverAmount] integerValue];
//        oldCart.DonateAmt = donation;
//        oldCart.ReceiveAmt = reveiver;
//        
//        [weakSelf updateLocalData:oldCart row:row];
//    };
    
   
    
    
    
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}


-(void)updateLocalData:(EGCartItem *)item row:(NSInteger)row{
    DLOG(@"update------%@",_cartList);
    
    NSMutableArray *temp = [NSMutableArray array];
    for(int i=0;i<_cartList.count;i++){
        if (i!=row) {
            [temp addObject:_cartList[i]];
        }else{
            [temp addObject:item];
        }
    }
    //DLOG(@"temp------%@",temp);
    self.cartList = nil;
    self.cartList = temp;
    
    DLOG(@"%p,cartList------%@",self.cartList,self.cartList);
}

@end
