//
//  CZPickerView.h
//
//  Created by chenzeyu on 9/6/15.
//  Copyright (c) 2015 chenzeyu. All rights reserved.
//

#import "CZPickerView.h"

#define CZP_FOOTER_HEIGHT 44.0
#define CZP_HEADER_HEIGHT 44.0

#define CZP_MIN_CONTENT_HEIGHT 90.0
#define CZP_MAX_CONTENT_HEIGHT 690.0

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1 
#define CZP_BACKGROUND_ALPHA 0.9
#else
#define CZP_BACKGROUND_ALPHA 0.3
#endif



typedef void (^CZDismissCompletionCallback)(void);

@interface CZPickerView ()
@property NSString *headerTitle;
@property NSString *cancelButtonTitle;
@property NSString *confirmButtonTitle;
@property UIView *backgroundDimmingView;
@property UIView *containerView;
@property UIView *headerView;
@property UIView *footerview;
@property UITableView *tableView;
@property NSIndexPath *selectedIndexPath;
@property NSMutableArray *selectedRows;

@property (nonatomic,strong) UITextView *textview;

@property (nonatomic,strong) NSString *content;

//
@property (nonatomic, copy) void (^singleTapAction)();

@end

@implementation CZPickerView

- (id)initWithHeaderTitle:(NSString *)headerTitle
        cancelButtonTitle:(NSString *)cancelButtonTitle
       confirmButtonTitle:(NSString *)confirmButtonTitle{
    self = [super init];
    if(self){
        if([self needHandleOrientation]){
            [[NSNotificationCenter defaultCenter] addObserver: self
                                                     selector:@selector(deviceOrientationDidChange:)
                                                         name:UIDeviceOrientationDidChangeNotification
                                                       object: nil];
        }
        self.tapBackgroundToDismiss = YES;
        self.needFooterView = NO;
        self.allowMultipleSelection = NO;
        
        self.confirmButtonTitle = confirmButtonTitle;
        self.cancelButtonTitle = cancelButtonTitle;
        
        self.headerTitle = headerTitle ? headerTitle : @"";
        self.headerTitleColor = [UIColor whiteColor];
        self.headerBackgroundColor = [UIColor colorWithRed:56.0/255 green:185.0/255 blue:158.0/255 alpha:1];
        
        self.cancelButtonNormalColor = [UIColor colorWithRed:59.0/255 green:72/255.0 blue:5.0/255 alpha:1];
        self.cancelButtonHighlightedColor = [UIColor grayColor];
        self.cancelButtonBackgroundColor = [UIColor colorWithRed:236.0/255 green:240/255.0 blue:241.0/255 alpha:1];
        
        self.confirmButtonNormalColor = [UIColor whiteColor];
        self.confirmButtonHighlightedColor = [UIColor colorWithRed:236.0/255 green:240/255.0 blue:241.0/255 alpha:1];
        self.confirmButtonBackgroundColor = [UIColor colorWithRed:56.0/255 green:185.0/255 blue:158.0/255 alpha:1];
        
        CGRect rect= [UIScreen mainScreen].bounds;
        self.frame = rect;
    }
    return self;
}


-(id)initWithHeaderTitle:(NSString *)headerTitle content:(NSString *)content cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle{
    self.content = content;
    return [self initWithHeaderTitle:headerTitle cancelButtonTitle:cancelButtonTitle confirmButtonTitle:confirmButtonTitle];
}

-(id)initWithHeaderTitle:(NSString *)headerTitle singleButtonTitle:(NSString *)singleButtonTitle singleTapAction:(void (^)())action{
    self.singleTapAction = action;
    return [self initWithHeaderTitle:headerTitle cancelButtonTitle:singleButtonTitle confirmButtonTitle:nil];
}

- (void)setupSubviews{
    if(!self.backgroundDimmingView){
        self.backgroundDimmingView = [self buildBackgroundDimmingView];
        [self addSubview:self.backgroundDimmingView];
    }
    
    self.containerView = [self buildContainerView];
    [self addSubview:self.containerView];
    
    self.tableView = [self buildTableView];
    [self.containerView addSubview:self.tableView];
    
    self.headerView = [self buildHeaderView];
    [self.containerView addSubview:self.headerView];
    
    
    self.textview = [self buildTextView];
    [self.containerView addSubview:self.textview];
    
    self.footerview = [self buildFooterView];
    [self.containerView addSubview:self.footerview];
    
    
    
    CGRect frame = self.containerView.frame;
    
    //
    CGFloat heightOffset = frame.size.height - CZP_HEADER_HEIGHT - CZP_FOOTER_HEIGHT;
    frame.size.width -= 150;
    CGSize size = [_content sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = size.height>CZP_MIN_CONTENT_HEIGHT ? size.height : CZP_MIN_CONTENT_HEIGHT;
    
    
    
//    self.containerView.frame = CGRectMake(frame.origin.x,
//                                          frame.origin.y,
//                                          frame.size.width,
//                                          self.headerView.frame.size.height + self.tableView.frame.size.height + self.footerview.frame.size.height);
    
    
    self.containerView.frame = CGRectMake(frame.origin.x,
                                          frame.origin.y,
                                          frame.size.width,
                                          self.headerView.frame.size.height + height + self.footerview.frame.size.height);
    self.containerView.center = CGPointMake(self.center.x, self.center.y + self.frame.size.height);
    
}




- (void)performContainerAnimation {
    
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:3.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.containerView.center = self.center;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)show{
    
    if(self.allowMultipleSelection && !self.needFooterView){
        self.needFooterView = self.allowMultipleSelection;
    }
    
    UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
    self.frame = mainWindow.frame;
    [mainWindow addSubview:self];
    [self setupSubviews];
    [self performContainerAnimation];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundDimmingView.alpha = CZP_BACKGROUND_ALPHA;
    }];
}

- (void)dismissPicker:(CZDismissCompletionCallback)completion{
    
    //
    [_textview removeObserver:self forKeyPath:@"contentSize" context:nil];
    
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:3.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.containerView.center = CGPointMake(self.center.x, self.center.y + self.frame.size.height);
    }completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundDimmingView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if(finished){
            if(completion){
                completion();
            }
            [self removeFromSuperview];
        }
    }];
}

- (UIView *)buildContainerView{
    CGAffineTransform transform = CGAffineTransformMake(0.8, 0, 0, 0.8, 0, 0);
    CGRect newRect = CGRectApplyAffineTransform(self.frame, transform);
    UIView *cv = [[UIView alloc] initWithFrame:newRect];
    cv.layer.cornerRadius = 6.0f;
    cv.clipsToBounds = YES;
    cv.center = CGPointMake(self.center.x, self.center.y + self.frame.size.height);
    return cv;
}

- (UITableView *)buildTableView{
    CGAffineTransform transform = CGAffineTransformMake(0.8, 0, 0, 0.8, 0, 0);
    CGRect newRect = CGRectApplyAffineTransform(self.frame, transform);
    NSInteger n = [self.dataSource numberOfRowsInPickerView:self];
    CGRect tableRect;
    float heightOffset = CZP_HEADER_HEIGHT + CZP_FOOTER_HEIGHT;
    if(n > 0){
        float height = n * 44.0;
        height = height > newRect.size.height - heightOffset ? newRect.size.height -heightOffset : height;
        tableRect = CGRectMake(0, 44.0, newRect.size.width, height);
    } else {
//        tableRect = CGRectMake(0, 44.0, newRect.size.width, newRect.size.height - heightOffset);
        tableRect = CGRectMake(0, 44.0, newRect.size.width-150, newRect.size.height - heightOffset-300);
    }
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return tableView;
}

- (UITextView *)buildTextView{
    CGAffineTransform transform = CGAffineTransformMake(0.8, 0, 0, 0.8, 0, 0);
    CGRect newRect = CGRectApplyAffineTransform(self.frame, transform);
    //
    newRect.size.width -= 150;
    float heightOffset = CZP_HEADER_HEIGHT + CZP_FOOTER_HEIGHT;
    UITextView *textview = [UITextView new];
    textview.textAlignment = NSTextAlignmentCenter;
    textview.font = [UIFont systemFontOfSize:17];
    textview.text = _content;
    textview.editable = NO;
    
    CGSize size = [_content sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(newRect.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = size.height>CZP_MIN_CONTENT_HEIGHT ? size.height : CZP_MIN_CONTENT_HEIGHT;
    
    
    
    //textview.frame = (CGRect){0,44,newRect.size.width,newRect.size.height - heightOffset-100};
    textview.frame = (CGRect){0,44,newRect.size.width,height};
    [textview addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];

    return textview;
}

//接收处理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UITextView *mTrasView = object;
    
    CGFloat topCorrect = ([mTrasView bounds].size.height - [mTrasView contentSize].height * [mTrasView zoomScale])/2.0;
    
    topCorrect = (topCorrect <0.0 ?0.0 : topCorrect);
    
    mTrasView.contentOffset = (CGPoint){.x =0, .y = -topCorrect/2};
}

-(void)setContent:(NSString *)content{
    self.tableView.hidden = YES;
    _content = content;
}

- (UIView *)buildBackgroundDimmingView{
    
    UIView *bgView;
    //blur effect for iOS8
    CGFloat frameHeight = self.frame.size.height;
    CGFloat frameWidth = self.frame.size.width;
    CGFloat sideLength = frameHeight > frameWidth ? frameHeight : frameWidth;
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        UIBlurEffect *eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        bgView = [[UIVisualEffectView alloc] initWithEffect:eff];
        bgView.frame = CGRectMake(0, 0, sideLength, sideLength);
    }
    else {
        bgView = [[UIView alloc] initWithFrame:self.frame];
        bgView.backgroundColor = [UIColor blackColor];
    }
    bgView.alpha = 0.0;
    if(self.tapBackgroundToDismiss){
        [bgView addGestureRecognizer:
         [[UITapGestureRecognizer alloc] initWithTarget:self
                                                 action:@selector(cancelPress)]];
    }
    return bgView;
}


-(void)cancelPress{
    [self dismissPicker:^{
        
    }];
}

- (UIView *)buildFooterView{
    if (!self.needFooterView){
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    //CGRect rect = self.tableView.frame;
    CGRect rect = self.textview.frame;
    CGRect newRect = CGRectMake(0,
                                rect.origin.y + rect.size.height,
                                rect.size.width,
                                CZP_FOOTER_HEIGHT);
    CGFloat margin = 10;
    
//    CGRect leftRect = CGRectMake(0,0, newRect.size.width /2, CZP_FOOTER_HEIGHT);
//    CGRect rightRect = CGRectMake(newRect.size.width /2,0, newRect.size.width /2, CZP_FOOTER_HEIGHT);
    
    CGRect leftRect = CGRectMake(10,5, newRect.size.width /2 - margin*2, CZP_FOOTER_HEIGHT-margin);
    CGRect rightRect = CGRectMake(newRect.size.width /2 + margin,5, newRect.size.width /2 - margin*2, CZP_FOOTER_HEIGHT-margin);
    
    UIView *view = [[UIView alloc] initWithFrame:newRect];
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:leftRect];
    [cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    [cancelButton setTitleColor: self.cancelButtonNormalColor forState:UIControlStateNormal];
    [cancelButton setTitleColor:self.cancelButtonHighlightedColor forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    cancelButton.backgroundColor = self.cancelButtonBackgroundColor;
    [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelButton];
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:rightRect];
    [confirmButton setTitle:self.confirmButtonTitle forState:UIControlStateNormal];
    [confirmButton setTitleColor:self.confirmButtonNormalColor forState:UIControlStateNormal];
    [confirmButton setTitleColor:self.confirmButtonHighlightedColor forState:UIControlStateHighlighted];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
    confirmButton.backgroundColor = self.confirmButtonBackgroundColor;
    [confirmButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:confirmButton];
    
    
    //单个按钮
    if (!_confirmButtonTitle) {
        leftRect = CGRectMake(10,5, newRect.size.width - margin*2, CZP_FOOTER_HEIGHT-margin);
        cancelButton.frame = leftRect;
        confirmButton.hidden = YES;
    }
    
    //
    view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F8"];
    cancelButton.layer.cornerRadius = 5.0;
    confirmButton.layer.cornerRadius = 5.0;
    cancelButton.layer.masksToBounds = YES;
    confirmButton.layer.masksToBounds  = YES;

    return view;
}

- (UIView *)buildHeaderView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, CZP_HEADER_HEIGHT)];
    view.backgroundColor = self.headerBackgroundColor;
    NSDictionary *dict = @{
                           NSForegroundColorAttributeName: self.headerTitleColor,
                           NSFontAttributeName: [UIFont systemFontOfSize:18.0]
                           };
    NSAttributedString *at = [[NSAttributedString alloc] initWithString:self.headerTitle attributes:dict];
    UILabel *label = [[UILabel alloc] initWithFrame:view.frame];
    label.attributedText = at;
    [label sizeToFit];
    [view addSubview:label];
    label.center = view.center;
    
    //
    if (self.showCloseButton) {
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = (CGRect){5,5,30,30};
        UIImage *closeImage = [UIImage imageNamed:@"common_close"];
        [closeBtn setImage:closeImage forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:closeBtn];
    }
    
    return view;
}

-(void)closeBtn:(UIButton *)btn{
    [self dismissPicker:^{
        
    }];
};

- (IBAction)cancelButtonPressed:(id)sender{
    //
    if (_singleTapAction) {
        _singleTapAction();
    }
    
    if (_leftTapAction) {
        _leftTapAction();
    }
    
    [self dismissPicker:^{
        if([self.delegate respondsToSelector:@selector(czpickerViewDidClickCancelButton:)]){
            [self.delegate czpickerViewDidClickCancelButton:self];
        }
    }];
}

- (IBAction)confirmButtonPressed:(id)sender{
    
    //
    if (_rightTapAction) {
        _rightTapAction();
    }
    
    
    [self dismissPicker:^{
        if(self.allowMultipleSelection && [self.delegate respondsToSelector:@selector(czpickerView:didConfirmWithItemsAtRows:)]){
            [self.delegate czpickerView:self didConfirmWithItemsAtRows:self.selectedRows];
        }
        else if(self.selectedIndexPath && [self.delegate respondsToSelector:@selector(czpickerView:didConfirmWithItemAtRow:)]){
            [self.delegate czpickerView:self didConfirmWithItemAtRow:self.selectedIndexPath.row];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.dataSource respondsToSelector:@selector(numberOfRowsInPickerView:)]) {
        return [self.dataSource numberOfRowsInPickerView:self];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"czpicker_view_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    for(NSNumber *n in self.selectedRows){
        if([n integerValue] == indexPath.row){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    if([self.selectedIndexPath isEqual:indexPath]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    if ([self.dataSource respondsToSelector:@selector(czpickerView:attributedTitleForRow:)]) {
        cell.textLabel.attributedText = [self.dataSource czpickerView:self attributedTitleForRow:indexPath.row];
    } else if([self.dataSource respondsToSelector:@selector(czpickerView:titleForRow:)]){
        cell.textLabel.text = [self.dataSource czpickerView:self titleForRow:indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.allowMultipleSelection){
        if(!self.selectedRows){
            self.selectedRows = [NSMutableArray new];
        }
        NSNumber *row = @(indexPath.row);
        // the row has already been selected
        if([self.selectedRows containsObject:row]){
            [self.selectedRows removeObject:row];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            [self.selectedRows addObject:row];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else {
        if(self.selectedIndexPath){
            UITableViewCell *prevCell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
            if(prevCell){
                prevCell.accessoryType = UITableViewCellAccessoryNone;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        } else{
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        self.selectedIndexPath = indexPath;
        if(!self.needFooterView && [self.delegate respondsToSelector:@selector(czpickerView:didConfirmWithItemAtRow:)]){
            [self dismissPicker:^{
                [self.delegate czpickerView:self didConfirmWithItemAtRow:indexPath.row];
            }];
        }
    }
}

#pragma mark - Notification Handler

- (BOOL)needHandleOrientation{
    NSArray *supportedOrientations = [[[NSBundle mainBundle] infoDictionary]
                                      objectForKey:@"UISupportedInterfaceOrientations"];
    NSMutableSet *set = [NSMutableSet set];
    for(NSString *o in supportedOrientations){
        NSRange range = [o rangeOfString:@"Portrait"];
        if ( range.location != NSNotFound ) {
            [set addObject:@"Portrait"];
        }
        
        range = [o rangeOfString:@"Landscape"];
        if ( range.location != NSNotFound ) {
            [set addObject:@"Landscape"];
        }
    }
    return set.count == 2;
}

- (BOOL)orientationSupported:(UIDeviceOrientation)orientation{
    NSString *orientationStr;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            orientationStr = @"UIInterfaceOrientationPortrait";
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientationStr = @"UIInterfaceOrientationPortraitUpsideDown";
            break;
        case UIDeviceOrientationLandscapeLeft:
            orientationStr = @"UIInterfaceOrientationLandscapeLeft";
            break;
        case UIDeviceOrientationLandscapeRight:
            orientationStr = @"UIInterfaceOrientationLandscapeRight";
            break;
        default:
            orientationStr = @"Invalid Interface Orientation";
            break;
    }
    NSArray *supportedOrientations = [[[NSBundle mainBundle] infoDictionary]
                                      objectForKey:@"UISupportedInterfaceOrientations"];
    for(NSString *o in supportedOrientations){
        if([o hasPrefix:orientationStr]){
            return YES;
        }
    }
    return NO;
}

- (void)deviceOrientationDidChange:(NSNotification *)notification{
    if(![self orientationSupported:[[UIDevice currentDevice] orientation]]){
        return;
    }
    self.frame = [UIScreen mainScreen].bounds;
    for(UIView *v in self.subviews){
        if([v isEqual:self.backgroundDimmingView]) continue;
        
        [UIView animateWithDuration:0.2f animations:^{
            v.alpha = 0.0;
        } completion:^(BOOL finished) {
            [v removeFromSuperview];
            //as backgroundDimmingView will not be removed
            if(self.subviews.count == 1){
                [self setupSubviews];
                [self performContainerAnimation];
            }
        }];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
