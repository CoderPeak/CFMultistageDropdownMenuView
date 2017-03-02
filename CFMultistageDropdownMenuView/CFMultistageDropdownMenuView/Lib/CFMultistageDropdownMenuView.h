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
- (void)multistageDropdownMenuView:(CFMultistageDropdownMenuView *)multistageDropdownMenuView selecteTitleButtonIndex:(NSInteger)titleButtonIndex conditionLeftIndex:(NSInteger)leftIndex conditionRightIndex:(NSInteger)rightIndex;

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

/* 代理 */
@property (nonatomic, weak) id<CFMultistageDropdownMenuViewDelegate> delegate;

@end
