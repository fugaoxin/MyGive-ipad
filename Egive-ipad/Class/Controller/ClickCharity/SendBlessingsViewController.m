//
//  SendBlessingsViewController.m
//  Egive
//
//  Created by sino on 15/9/13.
//  Copyright (c) 2015年 sino. All rights reserved.
//

//#import "Constants.h"
#import "SendBlessingsViewController.h"
#import "PreviewViewController.h"
//#import "UIView+ZJQuickControl.h"
#import "UIKit+AFNetworking.h"
#import "AppDelegate.h"

//#define ScreenSize [UIScreen mainScreen].bounds.size
#define viewWith screenWidth-400
#define viewHeight screenHeight-50-44

@interface SendBlessingsViewController ()
{
    BOOL editingMode;
    BOOL couldHideKeyboard;
    BOOL showingEmojiKeyboard;
    CGRect keyboardFrameBeginRect;
    
    CGRect _tapFrame;
    
    CGRect _emojiFrame;
    
    UILabel *_countLabel;
    UIDevice *device_;
}
//@property (strong, nonatomic) MemberModel * item;
@property (strong, nonatomic) UIScrollView * scroll;
@property (strong, nonatomic) UIWebView * wv;
@property (strong, nonatomic) UIButton * tapButton;
@property (strong, nonatomic) UIButton * emojiButton;
@property (strong, nonatomic) UIView *mask;
@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UIButton *rightBtn;
@property (strong, nonatomic) UIView * leftBtnLine;
@property (strong, nonatomic) UIView * rightBtnLine;

@property (nonatomic,strong) UILabel * TLLabel; //标题
@property (nonatomic,strong) UIButton * submitButton;
@property (nonatomic,strong) NSString * memberString;//MemberID表示符
@property (nonatomic,strong) EGLoginTool * EGLT;

@end

@interface UIWebView (HackishAccessoryHiding)
@property (nonatomic, assign) BOOL hackishlyHidesInputAccessoryView;
- (void) setHackishlyHidesInputAccessoryView:(BOOL)value;
@end

@implementation SendBlessingsViewController

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    NSLog(@"SendBlessingsViewController");
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self setNVBar];
    
    editingMode = NO;
    couldHideKeyboard = NO;
    showingEmojiKeyboard = NO;
    
    if (![EGLoginTool loginSingleton].isLoggedIn) {
        
    }
    
     device_=[[UIDevice alloc] init];
    
    [self setModel];
    [self setMainInterface];
    [self createUI];
    
    // Listen for keyboard appearances and disappearances
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAction)];
    [self.view addGestureRecognizer:tap];
    
}

-(void)setModel//初始化储存器
{
    self.EGLT=[EGLoginTool loginSingleton];
    EGUserModel * UModel=[self.EGLT currentUser];
    if (UModel.MemberID == nil) {
        self.memberString=@"";
    }
    else
    {
        self.memberString=UModel.MemberID;
    }
}

#pragma mark - 设置导航栏
-(void)setNVBar
{
    self.title =HKLocalizedString(@"GirdView_blessings_button");
    [self.navigationBar showLeftItemWithImage:@"common_header_back"];
    self.navigationBar.barTintColor = [UIColor colorWithHexString:@"#F1F2F3"];
}

#pragma mark - 设置主界面
-(void)setMainInterface
{
//    self.submitButton=[[UIButton alloc] initWithFrame:CGRectMake(20, viewHeight-41, viewWith-40, 32)];
//    self.submitButton.backgroundColor=[UIColor colorWithRed:90/255.0 green:172/255.0 blue:33/255.0 alpha:1];
//    self.submitButton.layer.masksToBounds=YES;
//    self.submitButton.layer.cornerRadius=4;
//    [self.view addSubview:self.submitButton];
//    [self.submitButton setTitle:HKLocalizedString(@"Register_commitButton_title") forState:UIControlStateNormal];
//    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.submitButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    
    _scroll = [[UIScrollView alloc] init];
    _scroll.frame = CGRectMake(0, 0, viewWith, viewHeight);
    _scroll.contentSize = CGSizeMake(viewWith, 800);
    _scroll.userInteractionEnabled=YES;
    _scroll.delegate = self;
    [self.view addSubview:_scroll];
}

- (void)keyboardDidShow: (NSNotification *) notif{
    if (IS_IPHONE_5|| [device_.model isEqualToString:@"iPad"]||IS_IPHONE_4_OR_LESS) return;
    editingMode = YES;
    
    NSDictionary* keyboardInfo = [notif userInfo];
    CGSize kbSize = [[keyboardInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"UIKeyboardFrameEndUserInfoKey kbSize = %f", kbSize.height);
    
    if (_leftBtn != nil) {
        //        [self.view addSubview:_leftBtn]; // Temp Solution
    } else {
        _leftBtnLine = [[UIView alloc] init];
        _leftBtnLine.backgroundColor = [UIColor colorWithRed:110/255.0 green:49/255.0 blue:139/255.0 alpha:1];
        _leftBtnLine.frame = CGRectMake(0, 36, viewWith/2, 4);
        _leftBtn = [[UIButton alloc] init];
        [_leftBtn setImage:[UIImage imageNamed:@"bless_text_sel"] forState:UIControlStateNormal];
        [_leftBtn setTitle:@"Keyboard" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor colorWithRed:110/255.0 green:49/255.0 blue:139/255.0 alpha:1] forState:UIControlStateNormal];
        [_leftBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        _leftBtn.frame = CGRectMake(0, viewHeight - kbSize.height - 40, viewWith/2, 40);
        _leftBtn.backgroundColor = [UIColor whiteColor];
        [_leftBtn addTarget:self action:@selector(toggleKeyboard:) forControlEvents:UIControlEventTouchUpInside];
        [_leftBtn addSubview:_leftBtnLine];
        //        [self.view addSubview:_leftBtn]; // Temp Solution
    }
    
    if (_rightBtn != nil) {
        //        [self.view addSubview:_rightBtn]; // Temp Solution
    } else {
        _rightBtnLine = [[UIView alloc] init];
        _rightBtnLine.backgroundColor = [UIColor lightGrayColor];
        _rightBtnLine.frame = CGRectMake(0, 36, viewWith/2, 4); // Temp Solution
        _rightBtnLine.frame = CGRectMake(0, 36, viewWith, 4); // Temp Solution
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setImage:[UIImage imageNamed:@"bless_icon_nor"] forState:UIControlStateNormal];
        [_rightBtn setTitle:@"Emoji" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_rightBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        _rightBtn.titleLabel.text = @"Emoji";
        _rightBtn.frame = CGRectMake(viewWith/2+1, viewHeight - kbSize.height - 40, viewWith/2, 40); // Temp Solution
        _rightBtn.frame = CGRectMake(0, viewHeight - kbSize.height - 40, viewWith, 40);
        _rightBtn.backgroundColor = [UIColor whiteColor];
        [_rightBtn addTarget:self action:@selector(toggleEmoji:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn addSubview:_rightBtnLine];
        //        [self.view addSubview:_rightBtn]; // Temp Solution
    }
    
    showingEmojiKeyboard = NO;
    _leftBtnLine.backgroundColor = [UIColor lightGrayColor];
    [_leftBtn setImage:[UIImage imageNamed:@"bless_text_nor"] forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_leftBtn setEnabled:NO];
    
    _rightBtnLine.backgroundColor = [UIColor colorWithRed:110/255.0 green:49/255.0 blue:139/255.0 alpha:1];
    [_rightBtn setImage:[UIImage imageNamed:@"bless_icon_sel"] forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor colorWithRed:110/255.0 green:49/255.0 blue:139/255.0 alpha:1] forState:UIControlStateNormal];
    [_rightBtn setEnabled:YES];
    
    if (!editingMode || !couldHideKeyboard) {
        [_scroll setContentSize:CGSizeMake(viewWith, (IS_IPHONE_6P?(editingMode?1070:900):(IS_IPHONE_5?1290:1090)))];
        CGPoint bottomOffset = CGPointMake(0, _scroll.contentSize.height - _scroll.bounds.size.height - 20);
  
        [_tapButton setFrame:_tapFrame]; // Temp Solution
        [_emojiButton setFrame:_emojiFrame];
        
       
        
        [_scroll setContentOffset:bottomOffset animated:IS_IPHONE_5?NO:YES];
    }
    couldHideKeyboard = YES;
}

- (void)keyboardDidHide: (NSNotification *) notif{
    [_mask removeFromSuperview];
    
    
    NSString *val = [_wv stringByEvaluatingJavaScriptFromString: @"$('<div/>').text(document.getElementById('ctl00_cnt_PageContent_txt_Comment').value).html();"];
    _countLabel.text = [NSString stringWithFormat:@"%ld/500",val.length];
    //    showingEmojiKeyboard = NO;
}

- (void)keyboardWillShow: (NSNotification *) notif{
    //NSLog(@"keyboardWillShow");
    
}

- (void)toggleKeyboard:(id)target
{
    //NSLog(@"toggleKeyboard");
    if (!showingEmojiKeyboard) return;
    
    showingEmojiKeyboard = NO;
    _leftBtnLine.backgroundColor = [UIColor lightGrayColor];
    [_leftBtn setImage:[UIImage imageNamed:@"bless_text_nor"] forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_leftBtn setEnabled:NO];
    
    _rightBtnLine.backgroundColor = [UIColor colorWithRed:110/255.0 green:49/255.0 blue:139/255.0 alpha:1];
    [_rightBtn setImage:[UIImage imageNamed:@"bless_icon_sel"] forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor colorWithRed:110/255.0 green:49/255.0 blue:139/255.0 alpha:1] forState:UIControlStateNormal];
    [_rightBtn setEnabled:YES];
    
    [_scroll addSubview:_mask];
    
    couldHideKeyboard = YES;
    [_wv becomeFirstResponder];
    [_wv endEditing:NO];
    [_wv stringByEvaluatingJavaScriptFromString:@"document.getElementById('emoji-wysiwyg-editor').focus()"];
}

-(void)tapImageAction{

    [_wv resignFirstResponder];
    [_wv endEditing:YES];


}

- (void)toggleEmoji:(id)target{
    //NSLog(@"toggleEmoji");
    if (IS_IPHONE_5 || [device_.model isEqualToString:@"iPad"]||IS_IPHONE_4_OR_LESS) {
        [_wv resignFirstResponder];
        [_wv endEditing:YES];
        return;
    }
    
    if (showingEmojiKeyboard) return;
    
    _leftBtnLine.backgroundColor = [UIColor colorWithRed:110/255.0 green:49/255.0 blue:139/255.0 alpha:1];
    [_leftBtn setImage:[UIImage imageNamed:@"bless_text_sel"] forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor colorWithRed:110/255.0 green:49/255.0 blue:139/255.0 alpha:1] forState:UIControlStateNormal];
    [_leftBtn setEnabled:YES];
    
    _rightBtnLine.backgroundColor = [UIColor lightGrayColor];
    [_rightBtn setImage:[UIImage imageNamed:@"bless_icon_nor"] forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_rightBtn setEnabled:NO]; // Temp Solution
    [_rightBtn removeFromSuperview]; // Temp Solution
    
    showingEmojiKeyboard = YES;
    [_mask removeFromSuperview];
    
    [_scroll setContentSize:CGSizeMake(viewWith, 1090)];
    CGPoint bottomOffset = CGPointMake(0, _scroll.contentSize.height - _scroll.bounds.size.height);
    
    [_tapButton setFrame:_tapFrame]; // Temp Solution
    [_emojiButton setFrame:_emojiFrame];

    
    [_scroll setContentOffset:bottomOffset animated:YES];
    
    
    [_wv resignFirstResponder];
    [_wv endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (IS_IPHONE_5 || [device_.model isEqualToString:@"iPad"] || IS_IPHONE_4_OR_LESS) return;
    editingMode = NO;
    if (couldHideKeyboard || showingEmojiKeyboard) {
        couldHideKeyboard = NO;
        [self.view endEditing:YES];
        CGPoint bottomOffset = CGPointMake(0, 0);
        
        [_tapButton setFrame:_tapFrame]; // Temp Solution
        [_emojiButton setFrame:_emojiFrame];
        

        //[_scroll setContentOffset:bottomOffset animated:YES];
        [_scroll setContentSize:CGSizeMake(viewWith, 640)];
        [_scroll scrollsToTop];
        
        [_wv stringByEvaluatingJavaScriptFromString:@"document.activeElement.blur()"];
        [_wv endEditing:YES];
        [_wv resignFirstResponder];
        
        [_leftBtn removeFromSuperview];
        [_rightBtn removeFromSuperview];
        [_mask removeFromSuperview];
        
        NSString *val = [_wv stringByEvaluatingJavaScriptFromString: @"$('<div/>').text(document.getElementById('ctl00_cnt_PageContent_txt_Comment').value).html();"];
        NSLog(@"Emoji Keyboard = %@", val);
    }
}

- (void)createUI {
    //CGRectMake(60, 55, viewWith-120, 150)
    UIImageView * image =[[UIImageView alloc] initWithFrame:CGRectMake((viewWith-200)/2, 30, 200, 150)];
    [_scroll addSubview:image];
    //[_scroll addImageViewWithFrame:CGRectMake(60, 55, ScreenSize.width-120, 150) image:nil];
    //    [image setImage:[UIImage imageNamed:@"dummy_case_related_default@2x.png"]]; // for fast testing
    NSURL *url = [NSURL URLWithString:SITE_URL];
    url = [url URLByAppendingPathComponent:_model.ProfilePicURL];
    [image setImageWithURL:url placeholderImage:[UIImage imageNamed:@"dummy_case_related_default@2x.png"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    
    // UIImageView * commentInputBg = [self.view addImageViewWithFrame:CGRectMake(20, 300, ScreenSize.width-40, ScreenSize.height-360) image:@"comment_input@2x.png"];
    
    self.TLLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, image.frame.origin.y+image.frame.size.height+10, viewWith, 40)];
    self.TLLabel.textAlignment=NSTextAlignmentCenter;
    //self.TLLabel.backgroundColor=[UIColor redColor];
    [_scroll addSubview:self.TLLabel];
    self.TLLabel.text=self.model.Title;
    
//    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(20, self.TLLabel.frame.origin.y+self.TLLabel.frame.size.height+10, viewWith-40, 100)];
//    textView.delegate = self;
////    textView.font = [UIFont systemFontOfSize:15];
////    textView.backgroundColor=[UIColor greenColor];
////    textView.autocorrectionType = UITextAutocorrectionTypeNo;
//    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    textView.delegate=self;
//    textView.layer.borderWidth =1.0;
//    textView.backgroundColor=[UIColor greenColor];
//    [_scroll addSubview:textView];
    
    
    //
    int height=0;
    if (IS_IPHONE_5) {
        
        height=345;
    }else if (IS_IPHONE_6){
    
        height=445;
    }else if (IS_IPHONE_6P){
    
         height=450;
    }else if([device_.model isEqualToString:@"iPad"] || IS_IPHONE_4_OR_LESS) {
        
       height=450;
    }
    
    UILabel *countLabel =[[UILabel alloc] initWithFrame:CGRectMake(viewWith-100-27, height, 100, 150)];
    //[_scroll addLabelWithFrame:CGRectMake(ScreenSize.width-100-27, height, 100, 150) text:@""];
    [_scroll addSubview:countLabel];
    _countLabel = countLabel;
    countLabel.layer.zPosition = 9999999;
    countLabel.text = @"0/500";
//    countLabel.backgroundColor = [UIColor blackColor];
    countLabel.textAlignment = NSTextAlignmentRight;
    countLabel.font = [UIFont systemFontOfSize:14];
    countLabel.textColor = tabarColor;
//    countLabel.frame = (CGRect){ScreenSize.width-45 - 20, ScreenSize.height-(IS_IPHONE_6P?210:150), 100, 15};
    [_scroll addSubview:countLabel];
    
    NSString *filePath=[[NSBundle mainBundle] pathForResource:IS_IPHONE_6P?@"emoji-iphone6p":(IS_IPHONE_5?@"emoji-iphone5s":@"emoji") ofType:@"html" inDirectory:@""];
    _wv = [[UIWebView alloc] init];
    _wv.frame = CGRectMake(0, 240, viewWith, 500);
    //_wv.contentMode = UIViewContentModeScaleAspectFit;
    _wv.scrollView.scrollEnabled = NO;
    _wv.scrollView.bounces = NO;
    [_wv loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    [_wv setHackishlyHidesInputAccessoryView:YES];
    [_scroll addSubview:_wv];
    _mask = [[UIView alloc] init];
    _mask.frame = CGRectMake(0, 500, viewWith, 500);
    _mask.backgroundColor = [UIColor clearColor];
    [_scroll addSubview:_mask];
    
    _tapButton = [[UIButton alloc] init];
    //    [_tapButton setFrame:CGRectMake(20, ScreenSize.height-150, ScreenSize.width-40, 35)]; // Temp Solution
    
    if ([device_.model isEqualToString:@"iPad"] || IS_IPHONE_4_OR_LESS) {
        
         _tapFrame = CGRectMake(20, viewHeight+60+25, viewWith-40 - 45 - 10, 35);
    }else{
    
        _tapFrame = CGRectMake(20, viewHeight-(IS_IPHONE_6P?210:150)+15, viewWith-40 - 45 - 10, 35);
    }
    [_tapButton setFrame:_tapFrame]; // Temp Solution
    
    [_tapButton setTitle:HKLocalizedString(@"Register_commitButton_title") forState:UIControlStateNormal];
    [_tapButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [_tapButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _tapButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _tapButton.layer.cornerRadius = 4;
    _tapButton.backgroundColor = [UIColor colorWithRed:110/255.0 green:184/255.0 blue:43/255.0 alpha:1];
    [_scroll addSubview:_tapButton];
    
    _emojiButton = [[UIButton alloc] init];
    if ([device_.model isEqualToString:@"iPad"]||IS_IPHONE_4_OR_LESS) {
        
        _emojiFrame = CGRectMake(viewWith-45 - 20, viewHeight+60+25, 45, 35);
    }else{
        _emojiFrame = CGRectMake(viewWith-45 - 20, viewHeight-(IS_IPHONE_6P?210:150)+15, 45, 35);
    }
    [_emojiButton setFrame:_emojiFrame];
    [_emojiButton setImage:[UIImage imageNamed:@"bless_icon_sel"] forState:UIControlStateNormal];
    [_emojiButton addTarget:self action:@selector(toggleEmoji:) forControlEvents:UIControlEventTouchUpInside];
    _emojiButton.layer.cornerRadius = 4;
    _emojiButton.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0];
    [_scroll addSubview:_emojiButton];
    
    if (IS_IPHONE_5) {
        CGPoint bottomOffset = CGPointMake(0, _scroll.contentSize.height - _scroll.bounds.size.height + 64);
        [_scroll setContentOffset:bottomOffset animated:YES];
    }
}
#pragma mark - 点击提交
-(void) submit: (id)sender
{
    DLOG(@"点击提交");
    couldHideKeyboard = NO;
    [self.view endEditing:YES];
    if (!(IS_IPHONE_5 || [device_.model isEqualToString:@"iPad"]||IS_IPHONE_4_OR_LESS)) {
        CGPoint bottomOffset = CGPointMake(0, 0);
        //    [_tapButton setFrame:CGRectMake(20, ScreenSize.height-150, ScreenSize.width-40, 35)]; // Temp Solution
//        [_tapButton setFrame:CGRectMake(20, ScreenSize.height-(IS_IPHONE_6P?210:150), ScreenSize.width-40 - 45 - 10, 35)]; // Temp Solution
        [_tapButton setFrame:_tapFrame];
        
//        [_emojiButton setFrame:CGRectMake(ScreenSize.width-45 - 20, ScreenSize.height-(IS_IPHONE_6P?210:150), 45, 35)];
         [_emojiButton setFrame:_emojiFrame];
        //        [_scroll setContentOffset:bottomOffset animated:YES];
        [_scroll setContentSize:CGSizeMake(viewWith, 640)];
        [_scroll scrollsToTop];

        [_wv stringByEvaluatingJavaScriptFromString:@"document.activeElement.blur()"];
        [_wv endEditing:YES];
        [_wv resignFirstResponder];
        
        [_leftBtn removeFromSuperview];
        [_rightBtn removeFromSuperview];
        [_mask removeFromSuperview];
    }
    NSString *val = [_wv stringByEvaluatingJavaScriptFromString: @"$('<div/>').text(document.getElementById('ctl00_cnt_PageContent_txt_Comment').value).html();"];
   
    
    //NSLog(@"Emoji Keyboard = %@", val);
    

    _countLabel.text = [NSString stringWithFormat:@"%ld/500",val.length];
    
    if (![val isEqualToString:@""]){
        NSLog(@"%ld",[val length]);
        if ([val length] > 500) {
            UIAlertView * alertView = [[UIAlertView alloc] init];
            alertView.message =HKLocalizedString(@"内容不能超过500个字符");
            [alertView addButtonWithTitle:HKLocalizedString(@"Common_button_confirm")];
            [alertView show];
            return;
        }
        PreviewViewController * vc = [[PreviewViewController alloc] init];
//        [vc setAction:^(void) {
//            if(self.action)
//            {
//                self.action();
//            }
//        }];
        
        vc.caseId = self.model.CaseID;
        //NSLog(@"%@",val);
        vc.comments = [val stringByReplacingOccurrencesOfString:@" " withString:@""];
        vc.memberId = self.memberString;
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self.yqNavigationController pushYQViewController:vc animated:YES];
        
    }else{
        UIAlertView * alertView = [[UIAlertView alloc] init];
        alertView.message =HKLocalizedString(@"请输入祝福内容!");
        [alertView addButtonWithTitle:HKLocalizedString(@"Common_button_confirm")];
        [alertView show];
    }
}

//计算字符长度
- (int)convertToInt:(NSString*)strtemp{
        int strlength = 0;
        char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
        for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
            if (*p) {
                p++;
                strlength++;
            }
            else {
                p++;
            }
        }
        NSLog(@"%d",strlength);
        return strlength;
    
}

#pragma mark - UITextFieldDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        
        NSTimeInterval animationDuration = 0.20f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.view.frame = rect;
        [UIView commitAnimations];
        [textView resignFirstResponder];
        return YES;
        
        return NO;
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    CGRect frame = textView.frame;
    //    NSLog(@"frame.origin.y = %f [_serverArr count] = %lu", frame.origin.y, (unsigned long)[_serverArr count]);
    //int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    int offset = frame.origin.y + 270 - (self.view.frame.size.height - 310.0);//键盘高度216;
    NSTimeInterval animationDuration = 0.20f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
    
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
