//
//  CFMultistageDropdownMenuView.h
//  CFMultistageDropdownMenuView
//
//  Created by Peak on 17/2/28.
//  Copyright © 2017年 Peak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFMultistageDropdownMenuView : UIView


/* 默认显示的 */
@property (nonatomic, strong) NSArray *defaulTitleArray;

/* 分类内容 动画起始位置 */
@property (nonatomic, assign) CGFloat startY;

/**
 *  设置数据源
 */
- (void)setupLeftArray:(NSArray *)leftArray rightArray:(NSArray *)rightArray;

@end
