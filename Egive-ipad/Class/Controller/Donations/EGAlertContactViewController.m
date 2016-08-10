//
//  EGAlertContactViewController.m
//  Egive-ipad
//
//  Created by vincentmac on 16/1/14.
//  Copyright © 2016年 Sino. All rights reserved.
//

#import "EGAlertContactViewController.h"
#import "EGContactCell.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "EGContactModel.h"

@interface EGAlertContactViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *blackView;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


@property (nonatomic, strong)NSMutableArray *contactList;

@property(retain,nonatomic)NSMutableArray *numberArray;
@property(retain,nonatomic)NSMutableArray *zhongwenArray;
@property(retain,nonatomic)NSMutableArray *zimuArray;

@end

@implementation EGAlertContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
     self.blackView.layer.opacity = 0.8;
    self.bgView.layer.cornerRadius = 8;
    
    _contactList = [NSMutableArray array];
    
    
    self.titleLabel.text = HKLocalizedString(@"呼籲募捐");
    [_cancelButton setTitle:HKLocalizedString(@"Cancel") forState:UIControlStateNormal];
    [_confirmBtn setTitle:HKLocalizedString(@"Confirm") forState:UIControlStateNormal];
    
    
    //
    UIView *headView = [UIView new];
    headView.frame = (CGRect){0,0,_tableView.frame.size.width,64};
    headView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.tableHeaderView = headView;
    
    //HKLocalizedString(@"选择呼吁对象")
    UILabel *headTextLabel = [UILabel createWithSize:17];
    headTextLabel.text = HKLocalizedString(@"选择呼吁对象");
    [headView addSubview:headTextLabel];
    
    [headTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(28);
        make.centerY.equalTo(headView);
    }];
    
    //
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [checkBtn setImage:[UIImage imageNamed:@"cart_checkbox_nor"] forState:UIControlStateNormal];
    [checkBtn setImage:[UIImage imageNamed:@"cart_checkbox_sel"] forState:UIControlStateSelected];
    [headView addSubview:checkBtn];
    
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.equalTo(headView);
        make.right.equalTo(headView).offset(-28);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];
    
    
    [checkBtn bk_addEventHandler:^(UIButton *sender) {
        sender.selected = sender.selected ? NO :YES;
        
        if (sender.selected) {
            for (EGContactModel *model in _contactList) {
                model.isChecked = YES;
            }
        }else{
            for (EGContactModel *model in _contactList) {
                model.isChecked = NO;
            }
        }
        [_tableView reloadData];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //
    // 请求读取通讯录权限
    CFErrorRef *error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    if (addressBook) {
        CFRelease(addressBook);
    }
    
    [self loadContactList];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)cancelAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (IBAction)confirmAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //如果没有授权则退出
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        [self dismissViewControllerAnimated:NO completion:nil];
        return ;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    
    if (self.dismissBlock) {
        self.dismissBlock(self.contactList);
    }
}

- (void)loadContactList
{
    
    
    _numberArray = [NSMutableArray array];
    _zhongwenArray = [NSMutableArray array];
    _zimuArray = [NSMutableArray array];
    
    CFErrorRef error = NULL;
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    //如果没有授权则退出
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        return ;
    }
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个addressBook model类
        EGContactModel *addressBook = [[EGContactModel alloc] init];
        addressBook.isChecked = NO;
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        
        NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        firstName = firstName != nil?firstName:@"";
        
        NSString *lastName =  CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
        lastName = lastName != nil?lastName:@"";
        
        NSString *nameString = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
        
        addressBook.name = nameString;
        addressBook.recordID = (int)ABRecordGetRecordID(person);;
        
        ABPropertyID property = kABPersonEmailProperty;
        ABMultiValueRef emailsProperty = ABRecordCopyValue(person, property);
        NSArray* emailsArray = CFBridgingRelease(ABMultiValueCopyArrayOfAllValues(emailsProperty));
        if (emailsArray.count) {
            for(int index = 0; index< [emailsArray count]; index++){
                
                NSString *email = [emailsArray objectAtIndex:index];
                NSString *emailLabel = CFBridgingRelease(ABMultiValueCopyLabelAtIndex(emailsProperty, index));
                
                if ([emailLabel isEqualToString:(NSString*)kABWorkLabel]) {
                    addressBook.email = email;
                } else if ([emailLabel isEqualToString:(NSString*)kABHomeLabel]) {
                    addressBook.email = email;
                } else {
                    addressBook.email = email;
                }
            }
            //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
            [self.contactList addObject:addressBook];
        }
        
        
        CFRelease(person);
        CFRelease(emailsProperty);
    }
    
    DLOG(@"list:%@",self.contactList);
    for (int i=0;i<[self.contactList count];i++) {
        
        EGContactModel *addressBook = [self.contactList objectAtIndex:i];
        
        NSString *firstStr = [addressBook.name substringToIndex:1];
        
        if ([self number:firstStr]) {
            
            [self.numberArray addObject:addressBook];
        }else if ([self pipeizimu:firstStr]){
            
            [self.zimuArray addObject:addressBook];
            
        }else{
            
            [self.zhongwenArray addObject:addressBook];
            
        }
        
    }
    
    
    [_contactList removeAllObjects];
    
    //数字
    if (self.numberArray.count != 0){
        for (int i = 0; i< [self.numberArray count]-1 ; i ++) {
            for (int j = 0; j < [self.numberArray count]-1-i; j++) {
                
                EGContactModel *addressBook1 = [self.numberArray objectAtIndex:j];
                NSString *firstStr1 = [addressBook1.name substringToIndex:1];
                EGContactModel *addressBook2 = [self.numberArray objectAtIndex:j+1];
                NSString *firstStr2 = [addressBook2.name substringToIndex:1];
                if ([firstStr1 compare:firstStr2] == NSOrderedDescending) {
                    
                    [self.numberArray exchangeObjectAtIndex:j+1 withObjectAtIndex:j];
                }
                
            }
        }
        for ( EGContactModel *addressBook in self.numberArray) {
            [self.contactList addObject:addressBook];
        }
    }
    
    
    //字母
    if (self.zimuArray.count != 0) {
        for (int i = 0; i< [self.zimuArray count]-1 ; i ++) {
            for (int j = 0; j < [self.zimuArray count]-1-i; j++) {
                
                EGContactModel *addressBook1 = [self.zimuArray objectAtIndex:j];
                NSString *firstStr1 = [addressBook1.name substringToIndex:1];
                EGContactModel *addressBook2 = [self.zimuArray objectAtIndex:j+1];
                NSString *firstStr2 = [addressBook2.name substringToIndex:1];
                if ([firstStr1 compare:firstStr2] == NSOrderedDescending) {
                    
                    [self.zimuArray exchangeObjectAtIndex:j+1 withObjectAtIndex:j];
                }
                
            }
        }
        for ( EGContactModel *addressBook in self.zimuArray) {
            [self.contactList addObject:addressBook];
        }
    }
    //中文
    if (self.zhongwenArray.count != 0){
        for (int i = 0; i< [self.zhongwenArray count]-1 ; i ++) {
            for (int j = 0; j < [self.zhongwenArray count]-1-i; j++) {
                
                EGContactModel *addressBook1 = [self.zhongwenArray objectAtIndex:j];
                NSString *firstStr1 = [addressBook1.name substringToIndex:1];
                EGContactModel *addressBook2 = [self.zhongwenArray objectAtIndex:j+1];
                NSString *firstStr2 = [addressBook2.name substringToIndex:1];
                if ([firstStr1 localizedCompare:firstStr2] == NSOrderedDescending) {
                    
                    [self.zhongwenArray exchangeObjectAtIndex:j+1 withObjectAtIndex:j];
                }
                
            }
        }
        for ( EGContactModel *addressBook in self.zhongwenArray) {
            [self.contactList addObject:addressBook];
        }
    }
    DLOG(@"sssss list:%@",self.contactList);
    
    CFRelease(addressBook);
    [self.tableView reloadData];
}
#pragma mark 正则表达式
-(BOOL)number:(NSString*)str{
    //判断是否以数字开头
    NSString *ZIMU = @"^[0-9]*$";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    
    if ([regextestA evaluateWithObject:str] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(BOOL)pipeizimu:(NSString *)str
{
    //判断是否以字母开头
    NSString *ZIMU = @"^[a-zA-z]";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    
    if ([regextestA evaluateWithObject:str] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(BOOL)isZhongWenFirst:(NSString *)firstStr
{
    //是否以中文开头(unicode中文编码范围是0x4e00~0x9fa5)
    int utfCode = 0;
    void *buffer = &utfCode;
    NSRange range = NSMakeRange(0, 1);
    //判断是不是中文开头的,buffer->获取字符的字节数据 maxLength->buffer的最大长度 usedLength->实际写入的长度，不需要的话可以传递NULL encoding->字符编码常数，不同编码方式转换后的字节长是不一样的，这里我用了UTF16 Little-Endian，maxLength为2字节，如果使用Unicode，则需要4字节 options->编码转换的选项，有两个值，分别是NSStringEncodingConversionAllowLossy和NSStringEncodingConversionExternalRepresentation range->获取的字符串中的字符范围,这里设置的第一个字符 remainingRange->建议获取的范围，可以传递NULL
    BOOL b = [firstStr getBytes:buffer maxLength:2 usedLength:NULL encoding:NSUTF16LittleEndianStringEncoding options:NSStringEncodingConversionExternalRepresentation range:range remainingRange:NULL];
    if (b && (utfCode >= 0x4e00 && utfCode <= 0x9fa5))
        return YES;
    else
        return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _contactList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EGContactModel *item = _contactList[indexPath.row];
    EGContactCell *cell = [EGContactCell cellWithTableView:tableView atIndexPath:indexPath item:item];
//    cell.checkedBlock = ^(ContactCell *cell, BOOL isChecked){
//        ContactModel *model = self.contactList[indexPath.row];
//        model.isChecked = isChecked;
//        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    };
//    cell.model = self.contactList[indexPath.row];
    
    
    [cell.checkButton bk_addEventHandler:^(UIButton *btn) {
        
        btn.selected = btn.selected ? NO :YES;
        
        item.isChecked = btn.selected;
        
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
}

@end
