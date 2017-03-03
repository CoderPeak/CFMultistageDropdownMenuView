//
//  CFMultistageDropdownMenuView.m
//  CFMultistageDropdownMenuView
//
//  Created by Peak on 17/2/28.
//  Copyright © 2017年 Peak. All rights reserved.
//

#import "CFMultistageDropdownMenuView.h"
#import "CFMacro.h"
#import "CFLabelOnLeftButton.h"
#import "UIView+CFFrame.h"
#import "CFMultistageConditionTableView.h"

#define kViewTagAdd 999  // 所有tag都加上这个 防止出现为0的tag

@interface CFMultistageDropdownMenuView () <CFMultistageConditionTableViewDelegate>

/* 分类 titleBar */
@property (nonatomic, strong) UIView *titleBar;

/** 数据源--一维数组 (每一列的条件标题) */
@property (nonatomic, strong) NSArray *showTitleArray;

/* 整个屏幕的 背景 半透明View */
@property (nonatomic, strong) UIView *backgroundView;

/**
 *  cell为筛选的条件 - 下拉列表 (包含 一级/二级)
 */
@property (nonatomic, strong) CFMultistageConditionTableView *multistageConditionTableView;


/* 最后点击的按钮 */
@property (nonatomic, strong) UIButton *lastClickedButton;

/* 
 * 选中的条件  左 右 索引数组
 * @[@"3-0", @"0-0", @"0-0"]
 */
@property (nonatomic, strong) NSMutableArray *selectedConditionIndexArray;

/* titleBar上 当前选中按钮的 索引 */
@property (nonatomic, assign) NSInteger currentSelectedTitleButtonIndex;

@end

#define titleBarHeight 45

@implementation CFMultistageDropdownMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleBar];
    }
    return self;
}

#pragma mark - lazy
/* 分类 classifyView */
- (UIView *)titleBar
{
    if (!_titleBar) {
        _titleBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CFScreenWidth, titleBarHeight)];
        _titleBar.backgroundColor = [UIColor whiteColor];
    }
    return _titleBar;
}
/* 蒙层view */
- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.startY?:titleBarHeight, CFScreenWidth, CFScreenHeight)];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        
        
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_backgroundView addGestureRecognizer:tapGest];

    }
    return _backgroundView;
}

- (CFMultistageConditionTableView *)multistageConditionTableView
{
    if (!_multistageConditionTableView) {
        _multistageConditionTableView = [[CFMultistageConditionTableView alloc] initWithFrame:CGRectMake(0, self.startY?:titleBarHeight, CFScreenWidth, 0)];
        
        
        _multistageConditionTableView.delegate = self;
        
        _multistageConditionTableView.dataSourceLeftArray = self.dataSourceLeftArray;
        _multistageConditionTableView.dataSourceRightArray = self.dataSourceRightArray;
        
        _multistageConditionTableView.maxRowCount = self.maxRowCount;
        
    }
    return _multistageConditionTableView;
}

#pragma mark - setter
- (void)setDefaultSelectedTitleButtonIndex:(NSInteger)defaultSelectedTitleButtonIndex
{
    _defaultSelectedTitleButtonIndex = defaultSelectedTitleButtonIndex;
    
    _selectedConditionIndexArray[self.defaultSelectedTitleButtonIndex] = [NSString stringWithFormat:@"%zd-0", defaultSelectedTitleButtonIndex];
}

- (void)setDefaulTitleArray:(NSArray *)defaulTitleArray
{
    _defaulTitleArray = defaulTitleArray;
    
    [self setupTitleBarWithDefaulTitleArray:defaulTitleArray];

}

- (void)setupDataSourceLeftArray:(NSArray *)leftArray rightArray:(NSArray *)rightArray
{
    _dataSourceLeftArray = leftArray.mutableCopy;
    _dataSourceRightArray = rightArray.mutableCopy;
    
}

- (void)setupTitleBarWithDefaulTitleArray:(NSArray *)defaulTitleArray
{
    self.titleButtonArray = [[NSMutableArray alloc] init];
    
    CGFloat btnW = CFScreenWidth/defaulTitleArray.count;  // -6 留下左边间距
    CGFloat btnH = 45;
    
    // 选中的条件  左 右 索引数组
    self.selectedConditionIndexArray = [NSMutableArray arrayWithCapacity:defaulTitleArray.count];
    
    for (NSInteger i=0; i<defaulTitleArray.count; i++) {
        
 
        CFLabelOnLeftButton *titleBtn = [CFLabelOnLeftButton createButtonWithImageName:@"" title:@"" titleColor:CF_Color_TextBlackColor frame:CGRectMake(i*btnW+3, 0, btnW-6, btnH) target:self action:@selector(titleButtonClicked:)];
       
        titleBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [titleBtn setTitle:defaulTitleArray[i] forState:UIControlStateNormal];
        titleBtn.tag = i + kViewTagAdd;  // 所有tag都加上这个, 防止出现为0的tag
        
        [self.titleBar addSubview:titleBtn];
        
        [self.titleButtonArray addObject:titleBtn];  // 分类 按钮数组
        
        // 选中的条件  左 右 索引数组  初始为@[@"0-0", @"0-0", @"0-0"]
        [self.selectedConditionIndexArray addObject:@"0-0"];
    }
    
    // 中间分割竖线
    for (NSInteger i=0; i<defaulTitleArray.count-1; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(btnW*(i+1), 0, 1, 0)];
        line.cf_height = 0.6*45;
        line.cf_y = (45-line.cf_height)/2;
        line.backgroundColor = CF_Color_SepertLineColor;
        [self.titleBar addSubview:line];
    }
}

- (void)setStateConfigDict:(NSDictionary *)stateConfigDict
{
    _stateConfigDict = stateConfigDict;
    
    NSString *btnImageName = @"";
    UIColor *btnTitleColor = nil;
    if (self.stateConfigDict[@"normal"]) {
        btnImageName = self.stateConfigDict[@"normal"][1];
        btnTitleColor = self.stateConfigDict[@"normal"][0];
        if (!btnImageName) {
            // 使用CFMultistageDropdownMenuView.bundle自带的
            NSString *str = [NSString stringWithFormat:@"%@.png", self.stateConfigDict[@"normal"][1]];
            btnImageName = CFMultistageDropdownMenuViewSrcName(str)?:CFMultistageDropdownMenuViewFrameworkSrcName(str);
        }
    } else {
        // 默认的
        btnImageName = CFMultistageDropdownMenuViewSrcName(@"灰箭头.png")?:CFMultistageDropdownMenuViewFrameworkSrcName(@"灰箭头.png");
        btnTitleColor = CF_Color_TextBlackColor;
    }
    for (UIButton *btn in self.titleButtonArray) {
        [btn setTitleColor:btnTitleColor forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:btnImageName] forState:UIControlStateNormal];
    }
    
}

#pragma mark - CFMultistageConditionTableViewDelegate
// 最终选中
- (void)selecteWithLeftIndex:(NSInteger)leftIndex right:(NSInteger)rightIndex
{
    [self hide];
    
    NSString *indexStr = [NSString stringWithFormat:@"%zd-%zd", leftIndex, rightIndex];
    
    [_selectedConditionIndexArray setObject:indexStr atIndexedSubscript:_currentSelectedTitleButtonIndex];
    
    NSInteger clickedButtonIndex = _lastClickedButton.tag-kViewTagAdd;
    
    NSArray *leftStringArray  = [_dataSourceLeftArray objectAtIndex:clickedButtonIndex];
    NSString *leftString  = @"";
    NSArray *rightArray  = [_dataSourceRightArray objectAtIndex:clickedButtonIndex];
    NSArray *rightStringArray= [rightArray objectAtIndex:leftIndex];
    
    // 分类内容
    NSString *rightString = [rightStringArray objectAtIndex:rightIndex];
    
    // 选中条件后  标题分类改变
    [self changeButtonTitleWithString:rightString];
    
    // 特殊处理  当下拉菜单为 二级菜单    二级菜单的"全部"  标题栏展示 一级菜单内容 (更合理直观)
    if (leftStringArray.count > 0) {  // 二级菜单
        // 二级菜单 一级内容
        leftString = [leftStringArray objectAtIndex:leftIndex];
        //
        if ([rightString isEqualToString:@"全部"]) {
            NSInteger btnTag = _lastClickedButton.tag;
            UIButton *button = (UIButton *)[self viewWithTag:btnTag];
            [button setTitle:leftString forState:UIControlStateNormal];
        }
    }
    
    // 走代理   处理选中条件后的业务逻辑
    if (self.delegate && [self.delegate respondsToSelector:@selector(multistageDropdownMenuView:selecteTitleButtonIndex:conditionLeftIndex:conditionRightIndex:)]) {
        [self.delegate multistageDropdownMenuView:self selecteTitleButtonIndex:clickedButtonIndex conditionLeftIndex:leftIndex conditionRightIndex:rightIndex];
    }
    
    NSMutableArray *currentTitleArray = [NSMutableArray arrayWithCapacity:self.titleButtonArray.count];
    NSArray *btnArr = self.titleButtonArray;
    for (UIButton *btn in btnArr) {
        [currentTitleArray addObject:btn.titleLabel.text];
    }
    NSString *currentTitle = [currentTitleArray objectAtIndex:clickedButtonIndex];
    // 走代理  处理选中条件后的业务逻辑
    if (self.delegate && [self.delegate respondsToSelector:@selector(multistageDropdownMenuView:selectTitleButtonWithCurrentTitle:currentTitleArray:)]) {
        [self.delegate multistageDropdownMenuView:self selectTitleButtonWithCurrentTitle:currentTitle currentTitleArray:currentTitleArray];
    }
    
}

// 选中条件后  标题分类改变
- (void)changeButtonTitleWithString:(NSString *)str{
    NSInteger btnTag = _lastClickedButton.tag;
    UIButton *button = (UIButton *)[self viewWithTag:btnTag];
    [button setTitle:str forState:UIControlStateNormal];
    button.titleLabel.font = CF_BOLDFont_15;
    
    
    NSString *btnImageName = @"";
    UIColor *btnTitleColor = nil;
    if (self.stateConfigDict[@"selected"]) {
        btnImageName = self.stateConfigDict[@"selected"][1];
        btnTitleColor = self.stateConfigDict[@"selected"][0];
        
        btnImageName = [NSString stringWithFormat:@"%@.png", self.stateConfigDict[@"selected"][1]];
       
        
    } else {
        // 使用CFMultistageDropdownMenuView.bundle自带的
        btnImageName = CFMultistageDropdownMenuViewSrcName(@"天蓝箭头.png")?:CFMultistageDropdownMenuViewFrameworkSrcName(@"天蓝箭头.png");
        btnTitleColor = CF_Color_MainColor;
    }

    [button setTitleColor:btnTitleColor forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:btnImageName] forState:UIControlStateNormal];
    
    
    
}

#pragma mark - title按钮点击
- (void)titleButtonClicked:(UIButton *)btn
{
    _lastClickedButton = btn;
    
    // 移除子控件
    [self removeSubviews];

    
    // 显示下拉
    [self showConditionTableViewWhenClickedButton:btn];
    // 按钮箭头动画
    [self animationWhenClickTitleButton:btn];
    
    //
    //[UIView animateWithDuration:0.25 animations:^{
       // _lastClickedButton.imageView.transform = CGAffineTransformMakeRotation(0.01);
    //}];
}



#pragma mark --
// 点击 title 按钮 后
- (void)showConditionTableViewWhenClickedButton:(UIButton *)btn {
    [self.superview insertSubview:self.backgroundView atIndex:0];
    [self.superview addSubview:self.multistageConditionTableView];
    
    _currentSelectedTitleButtonIndex = btn.tag - kViewTagAdd;
    
    // @"3-0"(二级, -左边不一定为0)  /   @"0-0"(一级,  -左边一定为0)   /   @"0-3"
    NSString *currentSelectedIndexStr = [_selectedConditionIndexArray objectAtIndex:_currentSelectedTitleButtonIndex];
    
    NSArray *arr = [currentSelectedIndexStr componentsSeparatedByString:@"-"];
    NSInteger leftIndex = [[arr objectAtIndex:0] integerValue];
    NSInteger rightIndex = [[arr objectAtIndex:1] integerValue];
    
    //  根据 选中状态  下拉显示tableView
    [self.multistageConditionTableView showTableViewWithSelectedTitleIndex:_currentSelectedTitleButtonIndex selectedLeftIndex:leftIndex selectedRightIndex:rightIndex];
    
    
    
}
// 点击按钮箭头动画
- (void)animationWhenClickTitleButton:(UIButton *)btn
{
 
   
    for (UIButton *subBtn in self.titleButtonArray) {
        if (subBtn==btn) {
            [UIView animateWithDuration:0.25 animations:^{
                subBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
                subBtn.userInteractionEnabled = NO;
            }];
            
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                subBtn.imageView.transform = CGAffineTransformMakeRotation(0);
                subBtn.userInteractionEnabled = YES;
            }];
        }
    }
    
}


- (void)removeSubviews
{
    
    // 此处 千万不能写作 !self.backgroundView?:[self.backgroundView removeFromSuperview];  会崩
    !_backgroundView?:[_backgroundView removeFromSuperview];
    _backgroundView=nil;
    
    !_multistageConditionTableView?:[_multistageConditionTableView removeFromSuperview];
    _multistageConditionTableView=nil;
    
    self.showTitleArray = nil;
    
}

- (void)hide
{
    [self.backgroundView removeFromSuperview];
    [self.multistageConditionTableView hide];
    
    [UIView animateWithDuration:0.25 animations:^{
        _lastClickedButton.imageView.transform = CGAffineTransformMakeRotation(0);
        _lastClickedButton.userInteractionEnabled = YES;
    }];
    

}

@end
