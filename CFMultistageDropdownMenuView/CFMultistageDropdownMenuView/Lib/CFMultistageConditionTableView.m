//
//  CFMultistageConditionTableView.m
//  CFMultistageDropdownMenuView
//
//  Created by Peak on 17/2/28.
//  Copyright © 2017年 Peak. All rights reserved.
//

#import "CFMultistageConditionTableView.h"
#import "UIView+CFFrame.h"
#import "CFMacro.h"

@interface CFMultistageConditionTableView () <UITableViewDelegate, UITableViewDataSource>
/* 二级的 左边(一级)  当下拉列表为一级时,没有leftTableView/只有rightTableView */
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) NSMutableArray *leftArray;

/* 二级的 右边(二级) */
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) NSMutableArray *rightArray;

// 左边-一级选中的索引
@property (nonatomic, assign) NSInteger leftSelectedIndex;

/* 上次选中索引 左边 */
@property (nonatomic, strong) NSIndexPath *leftLastSelectedIndexPath;
/* 上次选中索引 右边 */
@property (nonatomic, strong) NSIndexPath *rightLastSelectedIndexPath;

@end

static NSString *leftCellId = @"leftCellId";
static NSString *rightCellId = @"rightCellId";
#define CELLHEIGHT 44.0

@implementation CFMultistageConditionTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.leftTableView];
        [self addSubview:self.rightTableView];
        
    }
    return self;
}

#pragma mark - lazy
/* leftTableView */
- (UITableView *)leftTableView
{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.cf_width/2, 300)];
        _leftTableView.backgroundColor = [UIColor whiteColor];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.separatorInset = UIEdgeInsetsZero;
        _leftTableView.separatorColor = UIColorFromHex(0xEFEFF4);
        
    
    }
    return _leftTableView;
}

/* rightTableView */
- (UITableView *)rightTableView
{
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.cf_width/2, 0, self.cf_width/2, 200)];
        _rightTableView.backgroundColor = [UIColor whiteColor];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.separatorInset = UIEdgeInsetsZero;
        _rightTableView.separatorColor = UIColorFromHex(0xEFEFF4);
    }
    return _rightTableView;
}

#pragma mark - setter
- (void)setDataSourceLeftArray:(NSMutableArray *)dataSourceLeftArray
{
    _dataSourceLeftArray = dataSourceLeftArray;
    
    
}

- (void)setDataSourceRightArray:(NSMutableArray *)dataSourceRightArray
{
    _dataSourceRightArray = dataSourceRightArray;
    
    
}

- (void)removeSubviewsOfCell:(UITableViewCell*)cell {
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _leftTableView) {
        return _leftArray.count;
    } else if (tableView == _rightTableView) {
        
        NSArray *array = [_rightArray objectAtIndex:_leftSelectedIndex];
        return array.count;
        
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (tableView == _leftTableView) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:leftCellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftCellId];
        }
        [self removeSubviewsOfCell:cell];
        if (_leftArray.count > 0) {
            cell.textLabel.text = [_leftArray objectAtIndex:indexPath.row];
        }
        
    } else if (tableView == _rightTableView){
        
        cell = [tableView dequeueReusableCellWithIdentifier:rightCellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightCellId];
        }
        [self removeSubviewsOfCell:cell];
        NSArray *array = [_rightArray objectAtIndex:_leftSelectedIndex];
       
        cell.textLabel.text = [array objectAtIndex:indexPath.row];
        
        cell.textLabel.highlightedTextColor = CF_Color_MainColor;
        
    }
    
    
    UIView *selectView = [[UIView alloc] initWithFrame:cell.contentView.bounds];
    selectView.backgroundColor = CF_Color_DefalutBackGroundColor;
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, CELLHEIGHT)];
    lineV.backgroundColor = CF_Color_MainColor;
    [selectView addSubview:lineV];
    
    cell.selectedBackgroundView = selectView;
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.textLabel.highlightedTextColor = CF_Color_MainColor;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = CF_Color_TextBlackColor;
    return cell;
}



#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELLHEIGHT;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell= [tableView cellForRowAtIndexPath:indexPath];
    
    if (tableView == _leftTableView && _leftArray.count > 0) {
        // 点击 一级菜单
        _leftSelectedIndex = indexPath.row;
        
        // 当前选中加粗
        cell.textLabel.font = CF_BOLDFont_14;
        
        if (self.leftLastSelectedIndexPath) {
            UITableViewCell *lastSelectedcell= [tableView cellForRowAtIndexPath:self.leftLastSelectedIndexPath];
            // 上一次选中 加粗效果取消
            lastSelectedcell.textLabel.font = CF_Font_14;
        }
        self.leftLastSelectedIndexPath = indexPath;
       
        [_rightTableView reloadData];
        
    } else {
        
        cell.textLabel.font = CF_BOLDFont_14;
        
        if (self.rightLastSelectedIndexPath) {
            UITableViewCell *lastSelectedcell= [tableView cellForRowAtIndexPath:self.rightLastSelectedIndexPath];
            lastSelectedcell.textLabel.font = CF_Font_14;
        }
        self.rightLastSelectedIndexPath = indexPath;
        //...
        
        // 选中 二级菜单
        [self selectAtIndex:indexPath.row];
    }
}

// 选中 二级菜单
- (void)selectAtIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selecteLeftIndex:right:)]) {
        NSInteger leftSelectedIndex = _leftSelectedIndex > 0 ? _leftSelectedIndex : 0;
       
        [self.delegate selecteLeftIndex:leftSelectedIndex right:index];
        
        // 隐藏
        [self hide];
    }
}

// 隐藏
- (void)hide {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
        self.frame = CGRectMake(0, 0, CFScreenWidth, 0);

    } completion:^(BOOL finish){
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

@end
