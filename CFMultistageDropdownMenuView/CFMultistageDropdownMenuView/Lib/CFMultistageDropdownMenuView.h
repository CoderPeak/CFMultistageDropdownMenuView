//
//  CFMultistageDropdownMenuView.h
//  CFMultistageDropdownMenuView
//
//  Created by Peak on 17/2/28.
//  Copyright © 2017年 Peak. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CFMultistageDropdownMenuView;
@protocol CFMultistageDropdownMenuViewDelegate <NSObject>

@optional
// 能得到 当前选中的是第几个titleButton(即第几个分类下的条件) / 一级菜单 当前选中的索引和内容 / 二级菜单 当前选中的索引和内容
- (void)multistageDropdownMenuView:(CFMultistageDropdownMenuView *)multistageDropdownMenuView selecteTitleButtonIndex:(NSInteger)titleButtonIndex conditionLeftIndex:(NSInteger)leftIndex conditionRightIndex:(NSInteger)rightIndex;

// 能得到 当前选中的 内容 /  整个titleBar上 所有展示的内容
- (void)multistageDropdownMenuView:(CFMultistageDropdownMenuView *)multistageDropdownMenuView selectTitleButtonWithCurrentTitle:(NSString *)currentTitle currentTitleArray:(NSArray *)currentTitleArray;

@end

@interface CFMultistageDropdownMenuView : UIView

/* 分类按钮 数组 */
@property (nonatomic, strong) NSMutableArray *titleButtonArray;

/* 默认显示的 */
@property (nonatomic, strong) NSArray *defaulTitleArray;

/* 分类内容 动画起始位置 */
@property (nonatomic, assign) CGFloat startY;

/* 刚进来时 默认选中的分类索引 titleBar上按钮的索引 */
@property (nonatomic, assign) NSInteger defaultSelectedTitleButtonIndex;

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

/**
 *  设置数据源
 */
- (void)setupDataSourceLeftArray:(NSArray *)leftArray rightArray:(NSArray *)rightArray;


/* 最大展示行数 -- 不传-默认6条 */
@property (nonatomic, assign) NSInteger maxRowCount;

/* 选中状态和未选中状态
 * 默认  选中状态:天蓝文字,天蓝箭头
 *      未选中状态:黑文字,灰箭头
 * 使用注意: 参数格式
 @{
 @"selected" : @[[UIColor BlueColor], @"蓝箭头"],  // 选中状态
 @"normal" : @[[UIColor BlackColor], @"黑箭头"]  // 未选中状态
 };
 可以不传 / 也可以只传其中一对键值对 / 也可以都传 (key必须为@"selected"  @"normal")
 */
@property (nonatomic, strong) NSDictionary *stateConfigDict;


/* 代理 */
@property (nonatomic, weak) id<CFMultistageDropdownMenuViewDelegate> delegate;

@end
