//
//  EGDonationRecordViewController.m
//  Egive-ipad
//
//  Created by vincentmac on 15/12/2.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGDonationRecordViewController.h"
#import "EGDonationModel.h"
#import "EGDonationsRecordCell.h"
#import <MBProgressHUD.h>

@interface EGDonationRecordViewController ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic,copy) NSArray *recordArray;



@end

@implementation EGDonationRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    //
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    //
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - private method

-(void)setupUI{
    //
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E9EAEC"];
    _rightBgView.hidden = YES;
    
    //
//    self.tableView.emptyDataSetSource = self;
//    self.tableView.emptyDataSetDelegate = self;
    
    //
    self.projectLabel.text = HKLocalizedString(@"捐款项目");
    _projectLabel.font = [UIFont boldSystemFontOfSize:NormalFontSize+2];
    
    self.moneyLabel.text = HKLocalizedString(@"捐款金额");
    _moneyLabel.font = [UIFont boldSystemFontOfSize:NormalFontSize+2];
    self.moneyNumLabel.textColor = [UIColor colorWithHexString:@"#4C047A"];
    self.dateLabel.text = HKLocalizedString(@"捐款日期");
    _dateLabel.font = [UIFont boldSystemFontOfSize:NormalFontSize+2];
    
    self.sourceLabel.text = HKLocalizedString(@"捐款来源");
    _sourceLabel.font = [UIFont boldSystemFontOfSize:NormalFontSize+2];
    self.receiveLabel.text = HKLocalizedString(@"受助者收到金额");
    _receiveLabel.font = [UIFont boldSystemFontOfSize:NormalFontSize+2];
    self.typeLabel.text = HKLocalizedString(@"捐款形式");
    _typeLabel.font = [UIFont boldSystemFontOfSize:NormalFontSize+2];
    
    self.projectNameLabel.font = [UIFont boldSystemFontOfSize:18];
    self.moneyNumLabel.font = [UIFont boldSystemFontOfSize:17];
    self.sourceAddressLabel.font = [UIFont boldSystemFontOfSize:17];
    self.recevieTypeLabel.font = [UIFont boldSystemFontOfSize:17];
}


-(void)refreshRightView:(EGRecordItem *)item{
    NSString *url = [NSString stringWithFormat:@"%@/CaseDetail.aspx?CaseID=%@",SITE_URL,item.CaseID];//案例详情前缀
    
    self.projectNameLabel.text = item.CaseTitle;
    self.moneyNumLabel.text = [NSString stringWithFormat:@"HK$ %@",item.Amt];
    self.datetimeLabel.text = item.DonateDate;
    self.receiveMoneyLabel.text = [NSString stringWithFormat:@"HK$ %@",item.ReceivedAmt];
    self.sourceAddressLabel.text = item.Location;
    self.recevieTypeLabel.text = item.CaseCategory;
    
    if ([item.Location isEqualToString:@"香港"] || [item.Location isEqualToString:@"Hong Kong"]) {
        if (item.ChargeIncluded) {
            self.recevieTypeLabel.text = HKLocalizedString(@"MyDonation_HKpoundage");
        }else{
            self.recevieTypeLabel.text = HKLocalizedString(@"不包括手续费");
        }
    }else{
        if (item.ChargeIncluded) {
            self.recevieTypeLabel.text = HKLocalizedString(@"MyDonation_noHKpoundage");
        }else{
            self.recevieTypeLabel.text = HKLocalizedString(@"不包括手续费");
        }
    }
    
    if (_shareBlock) {
        _shareBlock(item.CaseTitle,url,item.CaseID);
    }
}

-(void)loadData{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *memberID;
    EGUserModel *model = [EGLoginTool loginSingleton].currentUser;
    if (model.MemberID && [model.MemberID rangeOfString:@"null"].length<=0) {
        memberID = model.MemberID;
    }
    
    LanguageKey lang = [Language getLanguage];
    
    NSString *DonationID = @"";
    
    NSString * soapMsg =[NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                         "<soap:Body>"
                         "<GetDonationRecord xmlns=\"egive.appservices\">"
                         "<Lang>%ld</Lang>"
                         "<MemberID>%@</MemberID>"
                         "<DonationID>%@</DonationID>"
                         "<StartRowNo>1</StartRowNo>"
                         "<NumberOfRows>999</NumberOfRows>"
                         "</GetDonationRecord>"
                         "</soap:Body>"
                         "</soap:Envelope>",lang, memberID,DonationID];
    
    [EGDonationModel getDonationRecordWithParams:soapMsg block:^(NSArray *array, NSError *error) {
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            
            if (array.count>0) {
                self.recordArray = array;
                _rightBgView.hidden = NO;
                _tempView.hidden = YES;
                
                
               
                [_tableView reloadData];
                
                if (_caseId.length>0) {
                    for (int i=0; i<_recordArray.count; i++) {
                        EGRecordItem *item = _recordArray[i];
                        if ([item.CaseID isEqualToString:_caseId]) {
                            
                            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                            [self refreshRightView:_recordArray[i]];
                            break;
                        }
                    }
                }
                else{
                    [self refreshRightView:_recordArray[0]];
                }
                
            }else{
                if (_shareBlock) {
                    _shareBlock(nil,nil,nil);
                }
                
                [_tableView reloadData];
                
                _tempView.hidden = NO;
            }
            
        }else{
            //[UIAlertView alertWithText:@"Unknow error"];
            _shareBlock(nil,nil,nil);
        }
    }];

}

#pragma mark - empty
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = HKLocalizedString(@"No_Records");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}



#pragma mark - tableview

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    return 80;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return _recordArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EGDonationsRecordCell *cell = [EGDonationsRecordCell cellWithTableView:tableView atIndexPath:indexPath];
    
    EGRecordItem *item = _recordArray[indexPath.row];
    
    cell.nameLabel.text = item.CaseTitle;
//    cell.moneyLabel.text = [NSString stringWithFormat:@"HK$ %@",item.Amt];
    cell.moneyLabel.text = [NSString stringWithFormat:@"%@",item.Amt];
    cell.dateLabel.text = item.DonateDate;
    
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    EGRecordItem *item = _recordArray[indexPath.row];
    [self refreshRightView:item];
}


#pragma mark - setter
-(void)setCaseId:(NSString *)caseId{

    _caseId = caseId;
    
   
}

@end
