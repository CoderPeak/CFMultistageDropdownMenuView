//
//  CFMultistageConditionTableView.h
//  CFMultistageDropdownMenuView
//
//  Created by Peak on 17/2/28.
//  Copyright © 2017年 Peak. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CFMultistageConditionTableViewDelegate <NSObject>

@required
- (void)selecteWithLeftIndex:(NSInteger)leftIndex right:(NSInteger)rightIndex;
- (void)hideTableView;
@end

@interface CFMultistageConditionTableView : UIView

@property (nonatomic, strong) id <CFMultistageConditionTableViewDelegate>delegate;

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

/* 最大展示行数 -- 不传-默认6条 */
@property (nonatomic, assign) NSInteger maxRowCount;

// 显示下拉菜单 (根据选中的 索引)
- (void)showTableViewWithSelectedTitleIndex:(NSInteger)titleIndex selectedLeftIndex:(NSInteger)leftIndex selectedRightIndex:(NSInteger)rightIndex;

- (void)hide;

@end
