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
// 一维数组
@property (nonatomic, strong) NSMutableArray *leftArray;

/* 二级的 右边(二级) */
@property (nonatomic, strong) UITableView *rightTableView;
// 二维数组
@property (nonatomic, strong) NSMutableArray *rightArray;

// 左边-一级选中的索引
@property (nonatomic, assign) NSInteger leftSelectedIndex;

/* 上次选中索引 左边 */
@property (nonatomic, strong) NSIndexPath *leftLastSelectedIndexPath;
/* 上次选中索引 右边 */
@property (nonatomic, strong) NSIndexPath *rightLastSelectedIndexPath;

/* 计算tableView完美高度使用  展示 完美行数 */
@property (nonatomic, assign) NSInteger perfectRowCount;

/* 两列时 中间分割线 */
@property (nonatomic, strong) UIView *midLineV;



@end

static NSString *leftCellId = @"leftCellId";
static NSString *rightCellId = @"rightCellId";
#define CELLHEIGHT 44.0

#define defaultMaxRowCount 6   // 默认最大6行
#define MAXROWCOUNT ((self.maxRowCount)?:defaultMaxRowCount)   // 最多行数

@implementation CFMultistageConditionTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        [self addSubview:self.leftTableView];
        [self addSubview:self.rightTableView];
        
        
        _midLineV = [[UIView alloc] initWithFrame:CGRectMake(CFScreenWidth/2, 0, 1, CELLHEIGHT*MAXROWCOUNT)];
        _midLineV.backgroundColor = CFLineColor;
        [self addSubview:_midLineV];
        
        // 要
        [self setClipsToBounds:YES];
    }
    return self;
}

#pragma mark - lazy
/* leftTableView */
- (UITableView *)leftTableView
{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.cf_width/2, 1000)];
        _leftTableView.backgroundColor = [UIColor whiteColor];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.separatorInset = UIEdgeInsetsZero;
        _leftTableView.separatorColor = CFLineColor;
        [_leftTableView setShowsVerticalScrollIndicator:NO];
        
        
    }
    return _leftTableView;
}

/* rightTableView */
- (UITableView *)rightTableView
{
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.cf_width/2, 0, self.cf_width/2, 1000)];
        _rightTableView.backgroundColor = [UIColor whiteColor];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.separatorInset = UIEdgeInsetsZero;
        _rightTableView.separatorColor = CFLineColor;
        [_rightTableView setShowsVerticalScrollIndicator:NO];
        
        
    }
    return _rightTableView;
}

#pragma mark - setter


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
        
        
        // 最终选中条件
        [self selectAtIndex:indexPath.row];
    }
}


#pragma mark - 处理逻辑
// 最终选中条件
- (void)selectAtIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selecteWithLeftIndex:right:)]) {
        NSInteger leftSelectedIndex = _leftSelectedIndex > 0 ? _leftSelectedIndex : 0;
       
        [self.delegate selecteWithLeftIndex:leftSelectedIndex right:index];
    }
    
}


// 显示下拉菜单 (根据选中的 索引)
- (void)showTableViewWithSelectedTitleIndex:(NSInteger)titleIndex selectedLeftIndex:(NSInteger)leftIndex selectedRightIndex:(NSInteger)rightIndex
{
    // 一维数组
    _leftArray = [[NSMutableArray alloc] initWithArray:[_dataSourceLeftArray objectAtIndex:titleIndex]];
    // 二维数组
    _rightArray = [[NSMutableArray alloc] initWithArray:[_dataSourceRightArray objectAtIndex:titleIndex]];
    
    // 显示 当前title下的 最后一次选中的位置
    [self showLastSelectedWithLeftIndex:leftIndex rightIndex:rightIndex];
 
    // 计算完美高度
    NSInteger maxRightCount = 0;
    NSMutableArray *maxLeftCountArr = [NSMutableArray array];
    NSMutableArray *maxRightCountArr = [NSMutableArray array];
    for (NSInteger i = 0; i < _dataSourceRightArray.count; i++) {
        NSArray *leftitems = _dataSourceLeftArray[i];
        [maxLeftCountArr addObject:[NSString stringWithFormat:@"%zd", leftitems.count]];
        
        NSArray *rightitems = _dataSourceRightArray[i];
        if ([rightitems isKindOfClass:[NSArray class]] && rightitems.count>1) {
            for (NSInteger j = 0; j<rightitems.count; j++) {
                NSInteger count = [rightitems[j] count];
                if (maxRightCount <= count) {
                    maxRightCount = count;
                }
            }
        } else {
            maxRightCount = [rightitems[0] count];
        }
        [maxRightCountArr addObject:[NSString stringWithFormat:@"%zd", maxRightCount]];
        NSLog(@"rightitems--%@", rightitems);
    }
    NSLog(@"maxLeftCountArr--%@", maxLeftCountArr);
    // 左[9,0,0]   右[15,7,6]
    // [8,8,8]
    NSInteger maxCount = 8;
    NSMutableArray *countArr = [NSMutableArray array];
    for (NSInteger i = 0; i < maxLeftCountArr.count; i++) {
        if ([maxLeftCountArr[i] intValue] >= maxCount || [maxRightCountArr[i] intValue] >= maxCount) {
            [countArr addObject:@(maxCount)];
        } else {
            [countArr addObject:MAX(maxLeftCountArr[i], maxRightCountArr[i])];
        }
    }
    // [8,7,6]
    NSLog(@"countArr--%@", countArr);
    
    self.perfectRowCount = [[countArr objectAtIndex:titleIndex] integerValue];
    
    NSLog(@"self.perfectRowCount--%zd", self.perfectRowCount);
    
    
    // 展示
    [self showConditionTableView];
    [UIView animateWithDuration:0.25 animations:^{
        
        self.cf_height = MIN(CELLHEIGHT*MAXROWCOUNT, CELLHEIGHT*self.perfectRowCount);
    }];
    
   
}

// 展示
- (void)showConditionTableView
{
    CGFloat perfectHeight = MIN(CELLHEIGHT*MAXROWCOUNT, CELLHEIGHT*self.perfectRowCount);
    
    
    if (_leftArray.count == 0) {  // 一级菜单
        _leftTableView.hidden = YES;
       
        _rightTableView.frame = CGRectMake( 0, 0, CFScreenWidth, perfectHeight);
        self.midLineV.hidden = YES;
        
    } else {  // 二级菜单
        _leftTableView.hidden = NO;
        _leftTableView.cf_height = perfectHeight;
        _rightTableView.frame = CGRectMake(CFScreenWidth / 2, 0, CFScreenWidth / 2, perfectHeight);
        self.midLineV.hidden = NO;
    }
 
}

// 显示 当前title下的 最后一次选中的位置
- (void)showLastSelectedWithLeftIndex:(NSInteger)leftIndex rightIndex:(NSInteger)rightIndex {
    
    if (_leftArray.count > 0) {  // 二级分类的
        [_leftTableView reloadData];
        NSIndexPath *leftSelectedIndexPath = [NSIndexPath indexPathForRow:leftIndex inSection:0];
        [_leftTableView selectRowAtIndexPath:leftSelectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        //  上次选中的 行 字体改变(加粗)
        UITableViewCell *cell = [_leftTableView cellForRowAtIndexPath:leftSelectedIndexPath];
        cell.textLabel.font = CF_BOLDFont_14;
        self.leftLastSelectedIndexPath = leftSelectedIndexPath;
        
    }
    
    _leftSelectedIndex = leftIndex;
    
    [_rightTableView reloadData];
    NSIndexPath *rightSelectedIndexPath = [NSIndexPath indexPathForRow:rightIndex inSection:0];
    
    //  上次选中的 行 字体改变(加粗)
    UITableViewCell *cell = [_rightTableView cellForRowAtIndexPath:rightSelectedIndexPath];
    cell.textLabel.font = CF_BOLDFont_14;
    self.rightLastSelectedIndexPath = rightSelectedIndexPath;
   
    
    [_rightTableView selectRowAtIndexPath:rightSelectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

// 隐藏
- (void)hide {
    [UIView animateWithDuration:0.05 animations:^{
        self.alpha = 0.0;
        self.cf_height = 0;

    } completion:^(BOOL finish){
        [self removeFromSuperview];
    }];
}

@end
