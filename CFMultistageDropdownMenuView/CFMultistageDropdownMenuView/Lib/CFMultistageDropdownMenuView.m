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
    
    CGFloat btnW = CFScreenWidth/defaulTitleArray.count;
    CGFloat btnH = 45;
    
    // 选中的条件  左 右 索引数组
    self.selectedConditionIndexArray = [NSMutableArray arrayWithCapacity:defaulTitleArray.count];
    
    for (NSInteger i=0; i<defaulTitleArray.count; i++) {
        
        CFLabelOnLeftButton *titleBtn = nil;
        
        titleBtn = [CFLabelOnLeftButton createButtonWithImageName:CFDrowMenuViewSrcName(@"灰箭头.png")?:CFDrowMenuViewFrameworkSrcName(@"灰箭头.png") title:@"" titleColor:CF_Color_TextDarkGrayColor frame:CGRectMake(i*btnW, 0, btnW, btnH) target:self action:@selector(titleButtonClicked:)];
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
    if (leftStringArray.count > 0) {  // 二级菜单
        // 二级菜单 一级内容
        leftString = [leftStringArray objectAtIndex:leftIndex];
    }
    NSArray *rightArray  = [_dataSourceRightArray objectAtIndex:clickedButtonIndex];
    NSArray *rightStringArray= [rightArray objectAtIndex:leftIndex];
    
    // 分类内容
    NSString *rightString = [rightStringArray objectAtIndex:rightIndex];

    // 文字长度太长  进行字符串截取
//    if(rightString.length>5){
//        rightString=[NSString stringWithFormat:@"%@...",[rightString substringToIndex:4]];
//    }
    
    // 选中条件后  标题分类改变
    [self changeButtonTitleWithString:rightString];
    
    // 走代理 或者 block  处理选中条件后的业务逻辑
    if (self.delegate && [self.delegate respondsToSelector:@selector(multistageDropdownMenuView:selecteTitleButtonIndex:conditionLeftIndex:conditionRightIndex:)]) {
        [self.delegate multistageDropdownMenuView:self selecteTitleButtonIndex:clickedButtonIndex conditionLeftIndex:leftIndex conditionRightIndex:rightIndex];
    }
    
    NSMutableArray *currentTitleArray = [NSMutableArray arrayWithCapacity:self.titleButtonArray.count];
    NSArray *btnArr = self.titleButtonArray;
    for (UIButton *btn in btnArr) {
        [currentTitleArray addObject:btn.titleLabel.text];
    }
    NSString *currentTitle = [currentTitleArray objectAtIndex:clickedButtonIndex];
    // 走代理 或者 block  处理选中条件后的业务逻辑
    if (self.delegate && [self.delegate respondsToSelector:@selector(multistageDropdownMenuView:selectTitleButtonWithCurrentTitle:currentTitleArray:)]) {
        [self.delegate multistageDropdownMenuView:self selectTitleButtonWithCurrentTitle:currentTitle currentTitleArray:currentTitleArray];
    }
    
}

// 选中条件后  标题分类改变
- (void)changeButtonTitleWithString:(NSString *)str{
    NSInteger btnTag = _lastClickedButton.tag;
    UIButton *button = (UIButton *)[self viewWithTag:btnTag];
    [button setTitle:str forState:UIControlStateNormal];
    
    
    [button setTitleColor:CF_Color_MainColor forState:UIControlStateNormal];
    button.titleLabel.font = CF_BOLDFont_15;
    [button setImage:[UIImage imageNamed:@"天蓝箭头"] forState:UIControlStateNormal];
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
 
    _lastClickedButton = btn;
   
    for (UIButton *subBtn in self.titleButtonArray) {
        if (subBtn==btn) {
            [UIView animateWithDuration:0.25 animations:^{
                subBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
                subBtn.enabled = NO;
            }];
            
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                subBtn.imageView.transform = CGAffineTransformMakeRotation(0);
                subBtn.enabled = YES;
            }];
        }
    }
    
    // multistageConditionTableView动画
    //[UIView animateWithDuration:0.25 animations:^{
        //        self.multistageConditionTableView.frame = CGRectMake(0, self.startY, CFScreenWidth, MIN(44 * 5, 44 * self.dataSource.count));
        //self.multistageConditionTableView.frame = CGRectMake(0, self.startY, CFScreenWidth, 44 * 5);
        
    //} completion:^(BOOL finished) {
        //        [self.multistageConditionTableView reloadData];
    //}];
    
}


- (void)removeSubviews
{
    [UIView animateWithDuration:0.25 animations:^{
        _lastClickedButton.imageView.transform = CGAffineTransformMakeRotation(0.01);
    }];
    // 此处 千万不能写作 !self.backgroundView?:[self.backgroundView removeFromSuperview];  会崩
    !_backgroundView?:[_backgroundView removeFromSuperview];
    _backgroundView=nil;
    
    !_multistageConditionTableView?:[_multistageConditionTableView removeFromSuperview];
    _multistageConditionTableView=nil;
    
    self.showTitleArray = nil;
    
    
    // 按钮恢复点击
    [self buttonEnable];
}
// 按钮恢复点击
- (void)buttonEnable
{
    // 所有 分类按钮  都变为 可点击
    for (NSInteger i=0; i<self.defaulTitleArray.count; i++) {
        UIButton *btn = self.titleButtonArray[i];
        btn.enabled = YES;
    }
}

- (void)hide
{
    [self.backgroundView removeFromSuperview];
    [self.multistageConditionTableView hide];
    
    [self buttonEnable];
}

@end
