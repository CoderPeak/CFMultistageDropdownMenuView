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
/* 分类按钮 数组 */
@property (nonatomic, strong) NSMutableArray *titleButtonArray;
/** 数据源--一维数组 (每一列的条件标题) */
@property (nonatomic, strong) NSArray *showTitleArray;

/* 整个屏幕的 背景 半透明View */
@property (nonatomic, strong) UIView *backgroundView;

/**
 *  cell为筛选的条件 - 下拉列表 (包含 一级/二级)
 */
@property (nonatomic, strong) CFMultistageConditionTableView *multistageConditionTableView;

/**
 *  数据源--二维数组
 *  一级列表数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSourceLeftArray;
/**
 *  数据源--二维数组
 *  二级列表数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSourceRightArray;
/* 最后点击的按钮 */
@property (nonatomic, strong) UIButton *lastClickedButton;
@end

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
        _titleBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CFScreenWidth, 45)];
        _titleBar.backgroundColor = [UIColor whiteColor];
    }
    return _titleBar;
}
/* 蒙层view */
- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.startY?:45, CFScreenWidth, CFScreenHeight)];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        
        
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_backgroundView addGestureRecognizer:tapGest];
    }
    return _backgroundView;
}

- (CFMultistageConditionTableView *)multistageConditionTableView
{
    if (!_multistageConditionTableView) {
        _multistageConditionTableView = [[CFMultistageConditionTableView alloc] initWithFrame:CGRectMake(0, self.startY?:45, CFScreenWidth, 0)];
        
        _multistageConditionTableView.backgroundColor = [UIColor whiteColor];
        
        _multistageConditionTableView.delegate = self;
        
        _multistageConditionTableView.dataSourceLeftArray = self.dataSourceLeftArray;
        _multistageConditionTableView.dataSourceRightArray = self.dataSourceRightArray;
        
    }
    return _multistageConditionTableView;
}

#pragma mark - setter
- (void)setDefaulTitleArray:(NSArray *)defaulTitleArray
{
    _defaulTitleArray = defaulTitleArray;
    
    [self setupTitleBarWithDefaulTitleArray:defaulTitleArray];
    
    

}

- (void)setupLeftArray:(NSArray *)leftArray rightArray:(NSArray *)rightArray
{
    _dataSourceLeftArray = leftArray.mutableCopy;
    _dataSourceRightArray = rightArray.mutableCopy;
    
    
}

- (void)setupTitleBarWithDefaulTitleArray:(NSArray *)defaulTitleArray
{
    self.titleButtonArray = [[NSMutableArray alloc] init];
    
    CGFloat btnW = CFScreenWidth/defaulTitleArray.count;
    CGFloat btnH = 45;
    
    for (NSInteger i=0; i<defaulTitleArray.count; i++) {
        
        CFLabelOnLeftButton *titleBtn = nil;
        
        titleBtn = [CFLabelOnLeftButton createButtonWithImageName:CFDrowMenuViewSrcName(@"灰箭头.png")?:CFDrowMenuViewFrameworkSrcName(@"灰箭头.png") title:@"" titleColor:CF_Color_TextDarkGrayColor frame:CGRectMake(i*btnW, 0, btnW, btnH) target:self action:@selector(titleButtonClicked:)];
        [titleBtn setTitle:defaulTitleArray[i] forState:UIControlStateNormal];
        titleBtn.tag = i + kViewTagAdd;  // 所有tag都加上这个, 防止出现为0的tag
        
        [self.titleBar addSubview:titleBtn];
        
        [self.titleButtonArray addObject:titleBtn];  // 分类 按钮数组
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
- (void)selecteLeftIndex:(NSInteger)leftIndex right:(NSInteger)rightIndex
{
    NSString *index = [NSString stringWithFormat:@"%zd-%zd", leftIndex, rightIndex];
    
    NSLog(@"index...---%@", index);
//    NSLog(@"_buttonSelectedIndex...%zd", _buttonSelectedIndex);
    
//    NSLog(@"_buttonIndexArray...%@", _buttonIndexArray);
    
//    [_buttonIndexArray setObject:index atIndexedSubscript:_buttonSelectedIndex];
//    [self returnSelectedLeftIndex:first RightIndex:second];
}

#pragma mark - title按钮点击
- (void)titleButtonClicked:(UIButton *)btn
{
    _lastClickedButton = btn;
    
    // 移除子控件
    [self removeSubviews];
//    self.showTitleArray = self.dataSourceArr[btn.tag-kViewTagAdd];
    
    // 加上 选择内容
    [self showConditionTableViewWhenClickedButton:btn];
    // 按钮箭头动画
    [self animationWhenClickTitleButton:btn];
}

#pragma mark --
- (void)showConditionTableViewWhenClickedButton:(UIButton *)btn {
    [self.superview addSubview:self.backgroundView];
    [self.superview addSubview:self.multistageConditionTableView];
    
    //..
//    [];
    
    [UIView animateWithDuration:0.25 animations:^{
        //        self.multistageConditionTableView.frame = CGRectMake(0, self.startY, CFScreenWidth, MIN(44 * 5, 44 * self.dataSource.count));
        self.multistageConditionTableView.frame = CGRectMake(0, self.startY, CFScreenWidth, 44 * 5);
        
    } completion:^(BOOL finished) {
        //        [self.multistageConditionTableView reloadData];
    }];
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

@end
